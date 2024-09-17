local id = 'Estonia/Maamet/orthos/rgb';
local subdir = 'Estonia';

local ee_const = import 'earthengine_const.libsonnet';
local ee = import 'earthengine.libsonnet';
local spdx = import 'spdx.libsonnet';
local license = spdx.proprietary;

local estonia_orthos = import 'Estonia_orthos.libsonnet';

local basename = std.strReplace(id, '/', '_');
local base_filename = basename + '.json';
local self_ee_catalog_url = ee_const.ee_catalog_url + basename;

{
  stac_version: ee_const.stac_version,
  type: ee_const.stac_type.collection,
  stac_extensions: [
    ee_const.ext_eo,
    ee_const.ext_sci,
  ],
  id: id,
  title: 'Estonia RGB orthophotos',
  'gee:type': ee_const.gee_type.image_collection,
  description: estonia_orthos.description + |||
    The RGB dataset has three bands with nationwide coverage: red, green, and
    blue.

    For more information, please see the
    [Estonia orthophotos documentation](https://geoportaal.maaamet.ee/eng/Spatial-Data/Orthophotos-p309.html)
  |||,
  license: license.id,
  links: ee.standardLinks(subdir, id),
  keywords: [
    'estonia',
    'orthophoto',
    'rgb',
  ],
  providers: estonia_orthos.providers('', self_ee_catalog_url),
  extent: estonia_orthos.extent,
  summaries: {
    gsd: [
      0.4,
    ],
    'eo:bands': [
      {
        name: 'R',
        description: 'Red',
      },
      {
        name: 'G',
        description: 'Green',
      },
      {
        name: 'B',
        description: 'Blue',
      }
    ],
    'gee:visualizations': [
        {
        display_name: 'RGB',
        lookat: {
          lat: 24.959,
          lon: 58.148,
          zoom: 18,
        },
        image_visualization: {
          band_vis: {
            min: [
              0,
            ],
            max: [
              255
            ],
            bands: [
              'R',
              'G',
              'B',
            ],
          },
        },
      },
    ],
    R: {
      minimum: 0.0,
      maximum: 255.0,
      'gee:estimated_range': false,
    },
    G: {
      minimum: 0.0,
      maximum: 255.0,
      'gee:estimated_range': false,
    },
    B: {
      minimum: 0.0,
      maximum: 255.0,
      'gee:estimated_range': false,
    },
  },
  'sci:citation': estonia_orthos.citation,
  'gee:terms_of_use': estonia_orthos.terms_of_use
}
