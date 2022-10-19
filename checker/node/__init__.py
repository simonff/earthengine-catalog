"""Runs all the single node checks on one Node."""

from typing import Iterator

from checker import stac
from checker.node import description
from checker.node import extensions
from checker.node import extent
from checker.node import file_path
from checker.node import gee_classes
from checker.node import id_field
from checker.node import interval
from checker.node import keywords
from checker.node import license_field
from checker.node import providers
from checker.node import required
from checker.node import schema
from checker.node import stac_version
from checker.node import title
from checker.node import top_level
from checker.node import version_extension

_CHECKS = [
    required.Check,
    top_level.Check,
    stac_version.Check,
    id_field.Check,
    file_path.Check,

    extensions.Check,
    extent.Check,
    keywords.Check,
    title.Check,
    description.Check,
    license_field.Check,
    providers.Check,

    # extensions
    version_extension.Check,

    # gee extensions
    gee_classes.Check,
    schema.Check,
    interval.Check,
]


def run_checks(
    node: stac.Node, checks: list[str]) -> Iterator[stac.Issue]:
  """Runs all checks on one STAC node."""

  for check in _CHECKS:
    if checks and check.name not in checks:
      continue
    yield from check.run(node)
