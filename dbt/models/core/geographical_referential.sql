{{ config(materialized='table') }}

select 
    * ,
    ST_GeogFromGeoJson(
    CONCAT(
      '{"type":"', geo_shape_geometry_type, '","coordinates":', geo_shape_geometry_coordinates, '}'
    )
  ) AS geography_column
from {{ ref('geographical_referential_raw')}}