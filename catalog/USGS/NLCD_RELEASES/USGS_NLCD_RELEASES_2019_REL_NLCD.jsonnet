local id = 'USGS/NLCD_RELEASES/2019_REL/NLCD';
local subdir = 'USGS/NLCD_RELEASES';
local predecessor_id = 'USGS/NLCD_RELEASES/2016_REL';

local ee_const = import 'earthengine_const.libsonnet';
local ee = import 'earthengine.libsonnet';
local spdx = import 'spdx.libsonnet';

local license = spdx.cc0_1_0;

local basename = std.strReplace(id, '/', '_');
local base_filename = basename + '.json';
local predecessor_basename = std.strReplace(predecessor_id, '/', '_');
local predecessor_filename = predecessor_basename + '.json';

local self_ee_catalog_url = ee_const.ee_catalog_url + basename;
local catalog_subdir_url = ee_const.catalog_base + subdir + '/';
local parent_url = catalog_subdir_url + 'catalog.json';
local self_url = catalog_subdir_url + base_filename;
local predecessor_url = catalog_subdir_url + predecessor_filename;

{
  stac_version: ee_const.stac_version,
  type: ee_const.stac_type.collection,
  stac_extensions: [
    ee_const.ext_eo,
    ee_const.ext_sci,
    ee_const.ext_ver,
  ],
  id: id,
  title: 'NLCD 2019: USGS National Land Cover Database, 2019 release',
  version: '2.0',
  'gee:type': ee_const.gee_type.image_collection,
  description: |||
    NLCD (the National Land Cover Database) is a 30-m Landsat-based land cover
    database spanning 8 epochs
    (2001, 2004, 2006, 2008, 2011, 2013, 2016, and 2019).
    The images rely on the imperviousness data layer for the
    urban classes and on a decision-tree classification for the rest.

    This dataset has one image for the continental US for each epoch.
    Alaska, Hawaii, and Puerto Rico data can be found in the previous
    [2016 NLCD release](USGS_NLCD_RELEASES_2016_REL).

    NLCD products are created by the Multi-Resolution Land Characteristics
    (MRLC) Consortium, a partnership of federal agencies led by the
    U.S. Geological Survey.
  |||,
  'gee:user_uploaded': true,
  license: license.id,
  links: ee.standardLinks(subdir, id) + [
    ee.link.predecessor(predecessor_id, predecessor_url)
  ],
  keywords: [
    'blm',
    'landcover',
    'mrlc',
    'nlcd',
    'usgs',
  ],
  providers: [
    ee.producer_provider('USGS', 'https://www.mrlc.gov'),
    ee.host_provider(self_ee_catalog_url),
  ],
  extent: ee.extent(-130.24, 21.75, -63.66, 50,
                    '2001-01-01T00:00:00Z', '2019-01-01T00:00:00Z'),
  summaries: {
    'gee:schema': [
      {
        name: 'landcover_class_names',
        description: 'Landcover class names',
        type: ee_const.var_type.double,
      },
      {
        name: 'landcover_class_palette',
        description: 'Landcover class palette',
        type: ee_const.var_type.double,
      },
      {
        name: 'landcover_class_values',
        description: 'Landcover class values',
        type: ee_const.var_type.double,
      },
      {
        name: 'impervious_descriptor_class_names',
        description: 'Impervious descriptor class names',
        type: ee_const.var_type.double,
      },
      {
        name: 'impervious_descriptor_class_palette',
        description: 'Impervious descriptor class palette',
        type: ee_const.var_type.double,
      },
      {
        name: 'impervious_descriptor_class_values',
        description: 'Impervious descriptor class values',
        type: ee_const.var_type.double,
      },
    ],
    gsd: [
      30.0,
    ],
    'eo:bands': [
      {
        name: 'landcover',
        description: |||
          All images include the landcover classification scheme described in the [Product Legend](https://www.mrlc.gov/data/legends/national-land-cover-database-class-legend-and-description). The legends are also available as metadata on each image. The classes in the product legend are given below.
        |||,
        'gee:classes': [
          {
            value: 11,
            color: '466b9f',
            description: 'Open water: areas of open water, generally with less than 25% cover of vegetation or soil.',
          },
          {
            value: 12,
            color: 'd1def8',
            description: |||
              Perennial ice/snow: areas characterized by a perennial cover of ice and/or snow, generally greater than 25% of total cover.
            |||,
          },
          {
            value: 21,
            color: 'dec5c5',
            description: |||
              Developed, open space: areas with a mixture of some constructed materials, but mostly vegetation in the form of lawn grasses. Impervious surfaces account for less than 20% of total cover. These areas most commonly include large-lot single-family housing units, parks, golf courses, and vegetation planted in developed settings for recreation, erosion control, or aesthetic purposes.
            |||,
          },
          {
            value: 22,
            color: 'd99282',
            description: |||
              Developed, low intensity: areas with a mixture of constructed materials and vegetation. Impervious surfaces account for 20% to 49% percent of total cover. These areas most commonly include single-family housing units.
            |||,
          },
          {
            value: 23,
            color: 'eb0000',
            description: |||
              Developed, medium intensity: areas with a mixture of constructed materials and vegetation. Impervious surfaces account for 50% to 79% of the total cover. These areas most commonly include single-family housing units.
            |||,
          },
          {
            value: 24,
            color: 'ab0000',
            description: |||
              Developed high intensity: highly developed areas where people reside or work in high numbers. Examples include apartment complexes, row houses, and commercial/industrial. Impervious surfaces account for 80% to 100% of the total cover.
            |||,
          },
          {
            value: 31,
            color: 'b3ac9f',
            description: |||
              Barren land (rock/sand/clay): areas of bedrock, desert pavement, scarps, talus, slides, volcanic material, glacial debris, sand dunes, strip mines, gravel pits, and other accumulations of earthen material. Generally, vegetation accounts for less than 15% of total cover.
            |||,
          },
          {
            value: 41,
            color: '68ab5f',
            description: |||
              Deciduous forest: areas dominated by trees generally greater than 5 meters tall, and greater than 20% of total vegetation cover. More than 75% of the tree species shed foliage simultaneously in response to seasonal change.
            |||,
          },
          {
            value: 42,
            color: '1c5f2c',
            description: |||
              Evergreen forest: areas dominated by trees generally greater than 5 meters tall, and greater than 20% of total vegetation cover. More than 75% of the tree species maintain their leaves all year. Canopy is never without green foliage.
            |||,
          },
          {
            value: 43,
            color: 'b5c58f',
            description: |||
              Mixed forest: areas dominated by trees generally greater than 5 meters tall, and greater than 20% of total vegetation cover. Neither deciduous nor evergreen species are greater than 75% of total tree cover.
            |||,
          },
          {
            value: 51,
            color: 'af963c',
            description: |||
              Dwarf scrub: Alaska only areas dominated by shrubs less than 20 centimeters tall with shrub canopy typically greater than 20% of total vegetation. This type is often co-associated with grasses, sedges, herbs, and non-vascular vegetation.
            |||,
          },
          {
            value: 52,
            color: 'ccb879',
            description: |||
              Shrub/scrub: areas dominated by shrubs less than 5 meters tall with shrub canopy typically greater than 20% of total vegetation. This class includes true shrubs, young trees in an early successional stage, or trees stunted from environmental conditions.
            |||,
          },
          {
            value: 71,
            color: 'dfdfc2',
            description: |||
              Grassland/herbaceous: areas dominated by gramanoid or herbaceous vegetation, generally greater than 80% of total vegetation. These areas are not subject to intensive management such as tilling, but can be utilized for grazing.
            |||,
          },
          {
            value: 72,
            color: 'd1d182',
            description: |||
              Sedge/herbaceous: Alaska only areas dominated by sedges and forbs, generally greater than 80% of total vegetation. This type can occur with significant other grasses or other grass like plants, and includes sedge tundra and sedge tussock tundra.
            |||,
          },
          {
            value: 73,
            color: 'a3cc51',
            description: |||
              Lichens: Alaska only areas dominated by fruticose or foliose lichens generally greater than 80% of total vegetation.
            |||,
          },
          {
            value: 74,
            color: '82ba9e',
            description: 'Moss: Alaska only areas dominated by mosses, generally greater than 80% of total vegetation.',
          },
          {
            value: 81,
            color: 'dcd939',
            description: |||
              Pasture/hay: areas of grasses, legumes, or grass-legume mixtures planted for livestock grazing or the production of seed or hay crops, typically on a perennial cycle. Pasture/hay vegetation accounts for greater than 20% of total vegetation.
            |||,
          },
          {
            value: 82,
            color: 'ab6c28',
            description: |||
              Cultivated crops: areas used for the production of annual crops, such as corn, soybeans, vegetables, tobacco, and cotton, and also perennial woody crops such as orchards and vineyards. Crop vegetation accounts for greater than 20% of total vegetation. This class also includes all land being actively tilled.
            |||,
          },
          {
            value: 90,
            color: 'b8d9eb',
            description: |||
              Woody wetlands: areas where forest or shrubland vegetation accounts for greater than 20% of vegetative cover and the soil or substrate is periodically saturated with or covered with water.
            |||,
          },
          {
            value: 95,
            color: '6c9fb8',
            description: |||
              Emergent herbaceous wetlands: areas where perennial herbaceous vegetation accounts for greater than 80% of vegetative cover and the soil or substrate is periodically saturated with or covered with water.
            |||,
          },
        ],
      },
      {
        name: 'impervious',
        description: |||
          Percent of the pixel covered by developed impervious surface.
        |||,
        'gee:units': '%',
      },
      {
        name: 'impervious_descriptor',
        description: |||
          Defines which impervious layer pixels are roads and provides the best fit description for impervious pixels that are not roads.
        |||,
        'gee:classes': [
          {
            value: 0,
            color: '000000',
            description: 'Unclassified.'
          },
          {
            value: 20,
            color: 'ff0000',
            description: |||
              Primary road. Interstates and other major roads. Pixels were
              derived from the 2018 NavStreets Street Data.
            |||,
          },
          {
            value: 21,
            color: 'ffff00',
            description: |||
              Secondary road. Non-interstate highways. Pixels were derived
               from the 2018 NavStreets Street Data.
            |||,
          },
          {
            value: 22,
            color: '0000ff',
            description: |||
              Tertiary road. Any two-lane road. Pixels were derived from the
              2018 NavStreets Street Data.
            |||,
          },
          {
            value: 23,
            color: 'ffffff',
            description: |||
              Thinned road. Small tertiary roads that generally are not paved
              and have been removed from the landcover but remain as part of
              the impervious surface product. Pixels were derived from the 2018
              NavStreets Street Data.
            |||,
          },
          {
            value: 24,
            color: 'ffc0c5',
            description: |||
              Non-road non-energy impervious. Developed areas that are
              generally not roads or energy production; includes
              residential/commercial/industrial areas, parks, and golf courses.
            |||,
          },
          {
            value: 25,
            color: 'eb82eb',
            description: |||
              Microsoft buildings. Buildings not captured in the NLCD
              impervious process, and not included in the nonroad impervious
              surface class. Pixels derived from the Microsoft US Building
              Footprints dataset.
            |||,
          },
          {
            value: 26,
            color: '9f1feb',
            description: |||
              LCMAP impervious. Impervious pixels from LCMAP that were used
              to fill in gaps left when roads were updated from previous
              versions of NLCD.
            |||,
          },
          {
            value: 27,
            color: '40dfd0',
            description: |||
              Wind turbines. Pixels derived from the US Wind Turbine Dataset,
              accessed on 1/9/2020.
            |||,
          },
          {
            value: 28,
            color: '79ff00',
            description: |||
              Well pads. Pixels derived from the 2019 Oil and Natural Gas Wells
              dataset from the Oak Ridge National Laboratory.
            |||,
          },
          {
            value: 29,
            color: '005f00',
            description: |||
              Other energy production. Areas previously identified as well pads
              and wind turbines and classified in coordination with the
              Landfire project.
            |||,
          },
        ],
      },
    ],
    'gee:visualizations': [
      {
        display_name: 'Landcover',
        lookat: {
          lat: 38.686,
          lon: -115.356,
          zoom: 5,
        },
        image_visualization: {
          band_vis: {
            min: [
              0.0,
            ],
            max: [
              95.0,
            ],
            palette: [
              '466b9f',
              'd1def8',
              'dec5c5',
              'd99282',
              'eb0000',
              'ab0000',
              'b3ac9f',
              '68ab5f',
              '1c5f2c',
              'b5c58f',
              'af963c',
              'ccb879',
              'dfdfc2',
              'd1d182',
              'a3cc51',
              '82ba9e',
              'dcd939',
              'ab6c28',
              'b8d9eb',
              '6c9fb8',
            ],
            bands: [
              'landcover',
            ],
          },
        },
      },
    ],
    landcover: {
      minimum: 11.0,
      maximum: 95.0,
      'gee:estimated_range': false,
    },
    impervious: {
      minimum: 0.0,
      maximum: 100.0,
      'gee:estimated_range': false,
    },
    impervious_descriptor: {
      minimum: 1.0,
      maximum: 12.0,
      'gee:estimated_range': false,
    },
  },
  'sci:citation': |||
    Dewitz, J., and U.S. Geological Survey, 2021, National Land Cover Database (NLCD)
    2019 Products (ver. 2.0, June 2021): U.S. Geological Survey data release,
    [doi:10.5066/P9KZCM54](https://doi.org/10.5066/P9KZCM54)
  |||,
  'sci:doi': '10.5066/P9KZCM54',
  'gee:terms_of_use': |||
    Most U.S. Geological Survey (USGS) information is federally created data and
    therefore reside in the public domain and may be used, transferred, or
    reproduced without copyright restriction.
    Additional information on [Acknowledging or Crediting USGS as Information
    Source](https://www.usgs.gov/centers/eros/data-citation) is available.
  |||,
}
