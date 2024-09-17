local ee_const = import 'earthengine_const.libsonnet';
local ee = import 'earthengine.libsonnet';
local spdx = import 'spdx.libsonnet';

local versions = import 'versions.libsonnet';
local version_table = import 'JRC_GSW_Metadata_version_map.libsonnet';

local subdir = 'JRC';
local id = 'JRC/GSW1_4/Metadata';
local version_config = versions(subdir, version_table, id);
local version = version_config.version;

local license = spdx.proprietary;

{
  stac_version: ee_const.stac_version,
  type: ee_const.stac_type.collection,
  stac_extensions: [
    ee_const.ext_eo,
    ee_const.ext_sci,
    ee_const.ext_ver,
  ],
  id: id,
  title: 'JRC Global Surface Water Metadata, v1.4',
  version: '1.4',
  'gee:type': ee_const.gee_type.image,
  description: (importstr 'JRC_GSW_1_4_description.md') + |||
    This product contains metadata about the observations that went into
    computing The Global Surface Water dataset. Areas where water has never
    been detected are masked.
  |||,
  license: license.id,
  links: ee.standardLinks(subdir, id) +
  version_config.version_links,
  keywords: [
    'geophysical',
    'google',
    'jrc',
    'landsat_derived',
    'surface',
    'water',
  ],
  providers: [
    ee.producer_provider('EC JRC / Google', 'https://global-surface-water.appspot.com'),
    ee.host_provider(version_config.ee_catalog_url),
  ],
  extent: ee.extent_global('1984-03-16T00:00:00Z', '2022-01-01T00:00:00Z'),
  summaries: {
    gsd: [
      30.0,
    ],
    'eo:bands': [
      {
        name: 'detections',
        description: 'The number of water detections in the study period.',
      },
      {
        name: 'valid_obs',
        description: 'The number of valid observations in the study period.',
      },
      {
        name: 'total_obs',
        description: 'The total number of available observations (i.e. scenes) in the study period.',
      },
    ],
    'gee:visualizations': [
      {
        display_name: 'Detections/Observations',
        lookat: {
          lat: 52.48,
          lon: 71.72,
          zoom: 1,
        },
        image_visualization: {
          band_vis: {
            min: [
              100.0,
            ],
            max: [
              900.0,
            ],
            bands: [
              'detections',
              'valid_obs',
              'total_obs',
            ],
          },
        },
      },
    ],
    detections: {
      minimum: 0.0,
      maximum: 2007.0,
      'gee:estimated_range': true,
    },
    valid_obs: {
      minimum: 0.0,
      maximum: 2076.0,
      'gee:estimated_range': true,
    },
    total_obs: {
      minimum: 0.0,
      maximum: 2417.0,
      'gee:estimated_range': true,
    },
  },
  'sci:citation': |||
    Jean-Francois Pekel, Andrew Cottam, Noel Gorelick, Alan S. Belward,
    High-resolution mapping of global surface water and its long-term changes.
    Nature 540, 418-422 (2016). ([doi:10.1038/nature20584](https://doi.org/10.1038/nature20584))
  |||,
  'gee:terms_of_use': |||
    All data here is produced under the Copernicus Programme and is provided
    free of charge, without restriction of use. For the full license
    information see the Copernicus Regulation.

    Publications, models, and data products that make use of these datasets
    must include proper acknowledgement, including citing datasets and the
    journal article as in the following citation.

    If you are using the data as a layer in a published map, please include the
    following attribution text: 'Source: EC JRC/Google'
  |||,
  'gee:user_uploaded': true,
}
