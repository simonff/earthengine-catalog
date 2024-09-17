local id = 'MODIS/061/MOD11A1';
local versions = import 'versions.libsonnet';
local version_table = import 'templates/MOD11A1_versions.libsonnet';

local subdir = 'MODIS';

local ee_const = import 'earthengine_const.libsonnet';
local ee = import 'earthengine.libsonnet';
local spdx = import 'spdx.libsonnet';
local version_config = versions(subdir, version_table, id);
local version = version_config.version;
local license = spdx.proprietary;
local template = import 'templates/MODIS_006_MOD11A1.libsonnet';

{
  stac_version: ee_const.stac_version,
  type: ee_const.stac_type.collection,
  stac_extensions: [
    ee_const.ext_eo,
    ee_const.ext_sci,
    ee_const.ext_ver,
  ],
  id: id,
  title: 'MOD11A1.061 Terra Land Surface Temperature and Emissivity Daily Global 1km',
  version: version,
  'gee:type': ee_const.gee_type.image_collection,
  description: |||
    The MOD11A1 V6.1 product provides daily land surface temperature
    (LST) and emissivity values in a 1200 x 1200 kilometer grid. The
    temperature value is derived from the MOD11_L2 swath product. Above
    30 degrees latitude, some pixels may have multiple observations
    where the criteria for clear-sky are met. When this occurs, the
    pixel value is the average of all qualifying observations. Provided
    along with both the day-time and night-time surface temperature
    bands and their quality indicator layers are MODIS bands 31 and
    32 and six observation layers.

    Documentation:

    * [User's Guide](https://lpdaac.usgs.gov/documents/118/MOD11_User_Guide_V6.pdf)

    * [Algorithm Theoretical Basis Document (ATBD)](https://lpdaac.usgs.gov/documents/119/MOD11_ATBD.pdf)

    * [General Documentation](https://ladsweb.modaps.eosdis.nasa.gov/filespec/MODIS/61/MOD11A1)
  |||,
  license: license.id,
  links: ee.standardLinks(subdir, id) + [
    {
      rel: ee_const.rel.cite_as,
      href: 'https://doi.org/10.5067/MODIS/MOD11A1.061',
    },
  ] + version_config.version_links,
  keywords: [
    'daily',
    'emissivity',
    'global',
    'lst',
    'mod11a1',
    'modis',
    'nasa',
    'surface_temperature',
    'terra',
    'usgs',
  ],
  providers: [
    ee.producer_provider('NASA LP DAAC at the USGS EROS Center', 'https://doi.org/10.5067/MODIS/MOD11A1.061'),
    ee.host_provider(version_config.ee_catalog_url),
  ],
  'gee:provider_ids': [
    'C1621100535-LPDAAC_ECS',
  ],
  extent: ee.extent_global('2000-02-24T00:00:00Z', null),
  summaries: template.summaries {
    platform: [
      'Terra',
    ],
  },
  'sci:doi': '10.5067/MODIS/MOD11A1.061',
  'sci:citation': |||
    Please visit [LP DAAC 'Citing Our Data' page](https://lpdaac.usgs.gov/citing_our_data)
    for information on citing LP DAAC datasets.
  |||,
  'gee:interval': {
    type: 'cadence',
    unit: 'day',
    interval: 1,
  },
  'gee:terms_of_use': |||
    MODIS data and products acquired through the LP DAAC
    have no restrictions on subsequent use, sale, or redistribution.
  |||,
}
