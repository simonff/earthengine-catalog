"""Checks for gee:incomplete_entry validity.

gee:incomplete_entry specifies whether a dataset should be omitted from
publishing.

Requirements and specification:
- If the node is a catalog, it cannot have the field.
- If the field exists, its value must be a boolean.
"""

from typing import Iterator

from checker import stac

GEE_INCOMPLETE_ENTRY = 'gee:incomplete_entry'


class Check(stac.NodeCheck):
  """Checks for gee:incomplete_entry."""
  name = 'gee_skip_indexing'

  @classmethod
  def run(cls, node: stac.Node) -> Iterator[stac.Issue]:
    if GEE_INCOMPLETE_ENTRY in node.stac:
      if node.type == stac.StacType.CATALOG:
        yield cls.new_issue(
            node, f'Catalogs may not have a {GEE_INCOMPLETE_ENTRY} field'
        )
      elif node.type == stac.StacType.COLLECTION:
        field_value = node.stac.get(GEE_INCOMPLETE_ENTRY)
        if not isinstance(field_value, bool):
          yield cls.new_issue(node, f'{GEE_INCOMPLETE_ENTRY} must be a boolean')
