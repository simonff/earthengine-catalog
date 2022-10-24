"""Checks for gee:type.

- gee:type cannot be in STAC Catalogs
  - This is enforced in top_level.py
- Each STAC Collection must have a gee:type
- gee_type is a string that is one of:
  - image
  - image_collection
  - table
  - table_collection
"""

from typing import Iterator

from checker import stac

GEE_TYPE = 'gee:type'

IMAGE = 'image'
IMAGE_COLLECTION = 'image_collection'
TABLE = 'table'
TABLE_COLLECTION = 'table_collection'

GEE_TYPE_SET = frozenset({IMAGE, IMAGE_COLLECTION, TABLE, TABLE_COLLECTION})


class Check(stac.NodeCheck):
  """Checks for gee:type."""
  name = 'gee_type'

  @classmethod
  def run(cls, node: stac.Node) -> Iterator[stac.Issue]:
    if GEE_TYPE not in node.stac:
      return

    gee_type = node.stac[GEE_TYPE]

    if not isinstance(gee_type, str):
      yield cls.new_issue(node, f'{GEE_TYPE} must be a str')
      return

    if gee_type not in GEE_TYPE_SET:
      yield cls.new_issue(
          node, f'{GEE_TYPE} must be one of {sorted(GEE_TYPE_SET)}')
