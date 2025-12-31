"""Checks for gee:status validity.

gee:status specifies whether a dataset is not completely active.

Requirements and specification:
- If the node is a catalog, it cannot have the field.
- If the field is set, its value must be one of several enum values.
"""

from functools import lru_cache
import json
import os
import subprocess
from typing import Iterator

from absl import logging
from checker import stac

@lru_cache(maxsize=1)
def get_added_jsonnet_files():
    """Returns list of newly added .jsonnet files in the PR, empty list otherwise."""
    
    # Only works in GitHub Actions pull_request events
    if os.environ.get('GITHUB_ACTIONS') != 'true':
        return ['bad1']

    event_name = os.environ.get('GITHUB_EVENT_NAME')
    if event_name not in ['pull_request', 'push']:
        return ['bad2 %s' % os.environ.get('GITHUB_EVENT_NAME')]  # Not a PR, skip
    
    # Skip for copybara sync PRs
    if os.environ.get('GITHUB_ACTOR') == 'copybara-service[bot]':
        return ['bad3']  # Skip internal Google syncs
    
    if event_name == 'push':
       result = subprocess.run(
            ['git', 'show', '--name-only', '--diff-filter=A', '--pretty=format:', 'HEAD'],
            capture_output=True, text=True
        )
        
        if result.returncode != 0:
          return ['bad4 %s' % result]
        
        files = result.stdout.strip().split('\n') if result.stdout.strip() else []
        return [f for f in files if f.endswith('.jsonnet')]    
    elif event_name == 'pull_request':
        # For PR events, use GitHub API to get PR files
        github_ref = os.environ.get('GITHUB_REF', '')
        if not github_ref.startswith('refs/pull/'):
            return ['bad5']
        
        pr_number = github_ref.split('/')[2]
        repo = os.environ.get('GITHUB_REPOSITORY')
        
        # Call GitHub API
        env = os.environ.copy()
        env['GH_TOKEN'] = os.environ.get('GITHUB_TOKEN', '')
        
        result = subprocess.run(
            ['gh', 'api', f'repos/{repo}/pulls/{pr_number}/files'],
            capture_output=True, text=True,
            env=env
        )
        
        if result.returncode != 0:
            logging.error(f"Failed to get PR files: {result.stderr}")
            return ['bad6']
        
        files = json.loads(result.stdout)
        return [
            f['filename'] 
            for f in files 
            if f['status'] == 'added' and f['filename'].endswith('.jsonnet')
        ]
    else:
        print(f"Unsupported event type: {event_name}")
        return ['bad7']

class Check(stac.NodeCheck):
  """Checks for gee:status."""
  name = 'gee_status'

  @classmethod
  def run(cls, node: stac.Node) -> Iterator[stac.Issue]:
    if stac.GEE_STATUS in node.stac:
      if node.type == stac.StacType.CATALOG:
        yield cls.new_issue(
            node, f'Catalogs may not have a {stac.GEE_STATUS} field'
        )
      elif node.type == stac.StacType.COLLECTION:
        field_value = node.stac.get(stac.GEE_STATUS)
        if field_value not in stac.Status.allowed_statuses():
          yield cls.new_issue(
              node,
              f'{stac.GEE_STATUS}, if set, must be one of'
              f' {sorted(stac.Status.allowed_statuses())}',
          )
        if node.id == 'AAFC/ACI5':
            yield cls.new_issue(node, get_added_jsonnet_files())
        if field_value == stac.Status.READY:
            jsonnet_suffix = node.id.replace('/', '_')
            if any(x for x in get_added_jsonnet_files() if x.endswith('/'+jsonnet_suffix)):
                yield cls.new_issue(node, 'Do not set status to READY for new datasets, set it to BETA')
            else:
                yield cls.new_issue(node, 'Error not hit')
