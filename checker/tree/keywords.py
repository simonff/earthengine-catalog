"""Checks for keywords that need the entire tree.

Each keyword should occur in at least two datasets.  One of the primary purposes
of keywords is to connect multiple datasets by concepts.

When new keywords are introduced to the catalog, it is critical to capture
the definition of the keyword and understand what they keyword means.  The
warnings generated by this check are designed help start that discussion.
"""

import collections
from typing import Iterator

from checker import stac

KEYWORDS = 'keywords'

# TODO(schwehr): Comment out these keywords in the catalog or use the keyword
# in more than one STAC collection.
# Do not add more keywords to this list.
EXCEPTIONS = frozenset({
    'aafc', 'aer', 'aerial', 'aim', 'air_temperature', 'alerts',
    'aod', 'aot', 'argillic', 'asia', 'aura', 'avnir_2', 'backscatter',
    'belowground', 'bioclim', 'biome', 'biopama', 'biota', 'bnu',
    'brandenburg', 'brightness_temperature', 'builtup',
    'bulk', 'bulk_density', 'burnseverity', 'c2s', 'c3s', 'calcium',
    'calibrated', 'caltech', 'canopy', 'carbon_organic', 'cci', 'cdem', 'cdl',
    'cgiar', 'china', 'chip', 'ciesin_derived',
    'climatic_water_balance', 'cloudtostreet', 'coldest', 'condensation',
    'corine_derived', 'cpom', 'cryosat_2', 'dartmouth',
    'demographic', 'dess', 'development', 'dfo', 'digital_soil_mapping',
    'diurnal', 'driest', 'dust', 'ecosystem', 'eddi', 'emc',
    'endangered', 'energy', 'environment', 'eo_1', 'eorc', 'eos', 'eosdis',
    'famine', 'fcc', 'fireburning', 'firecci', 'firecci51', 'firms', 'fldas',
    'flood', 'flow_regulation', 'fpac', 'fundamental', 'gcos', 'ged',
    'geostationary', 'germany',
    'ges_disc', 'gfd', 'gfs', 'gimms', 'glad', 'glas',
    'globalsoilmap', 'globcover', 'goddard', 'grsg', 'gtopo30', 'habitats',
    'half_hourly', 'hapludalfs', 'health', 'human', 'hyperion',
    'hyperspectral', 'igbp', 'impervious', 'infrastructure', 'inundation',
    'iran', 'iron', 'irrigated_land', 'isccp', 'isothermality', 'kbdi', 'kntu',
    'label', 'lance', 'landscan', 'landscape', 'lst_derived', 'lt8',
    'magnesium', 'maiac', 'mask', 'mavi',
    'mcd115a3h', 'mcd12q1', 'mcd12q2', 'mcd15a3h',
    'mcd19a2', 'mcd43a3', 'mcd43c3', 'methane', 'metop', 'ml', 'mod17a2',
    'mod17a3gf', 'mod44b', 'modocga', 'multitemporal', 'myd17a2', 'myd17a3gf',
    'mydocga', 'naip', 'nasadem', 'nass', 'ncdc', 'ned', 'nfdrs',
    'nitrogen', 'nldas', 'nrcan', 'oilpalm', 'olci', 'omega', 'omi',
    'organic', 'orthorectified', 'pantropical',
    'particulate_matter', 'pathfinder', 'persiann', 'phosphorus',
    'plantation', 'pnoa', 'poes', 'polarization', 'potassium',
    'power', 'power_plants', 'precipitable', 'prescribedfire', 'protection',
    'radarsat_1', 'range', 'resolve', 'rgbn', 'river_networks',
    'roads', 'rtma', 'saltmarsh', 'sea_ice',
    'seasonality', 'seawifs', 'sentinelhub',
    'silt', 'slga', 'slv', 'smod', 'smos', 'social',
    'soil_depth', 'soil_temperature', 'south_asia',
    'southeast_asia', 'spain', 'spei', 'spi', 'stone',
    'stray_light', 'sulfur', 'swissimage', 'swisstopo',
    'taxonomy', 'terrace', 'terradat',
    'terrestrialaim', 'texture', 'tidal_flat', 'tidal_marsh', 'tile', 'tir',
    'tirs', 'tnc', 'toms', 'tropical',
    'ukraine', 'unep', 'utokyo', 'visibility', 'vnir', 'vnp09ga', 'vnp13a1',
    'void_filled', 'warmest', 'watercontent', 'wetness', 'wettest', 'whoi',
    'wildlife', 'wtlab', 'zcta', 'zinc', 'zip_code',
})


# Use a function to allow a mock during testing.
def is_single_use_exception(keyword: str) -> bool:
  return keyword in EXCEPTIONS


class Check(stac.TreeCheck):
  """Checks keywords across collections."""
  name = 'keywords_tree'

  @classmethod
  def run(cls, nodes: list[stac.Node]) -> Iterator[stac.Issue]:
    nodes = [node for node in nodes if node.type != stac.StacType.CATALOG]

    counts = collections.Counter()
    for node in nodes:
      counts.update(node.stac.get(KEYWORDS, []))

    single_keywords = {
        k for k, v in counts.items()
        if v == 1 and not is_single_use_exception(k)}

    if single_keywords:
      for node in nodes:
        for keyword in node.stac.get(KEYWORDS, []):
          if keyword in single_keywords:
            # To add a keyword to the system, it should to occur in at least
            # two datasets.  For those where the keyword is critical, but there
            # is currently only one keyword, add the keyword to the exception
            # list.
            yield cls.new_issue(node, f'Only one instance of "{keyword}"')

    multiple_use_keywords = {k for k, v in counts.items() if v > 1}
    no_longer_single_use = multiple_use_keywords.intersection(EXCEPTIONS)
    unknown_node = stac.Node(
        stac.UNKNOWN_ID, stac.UNKNOWN_PATH, stac.StacType.COLLECTION,
        stac.GeeType.NONE, {})
    for keyword in sorted(no_longer_single_use):
      yield cls.new_issue(
          unknown_node,
          f'"{keyword}" should be removed from exceptions')
