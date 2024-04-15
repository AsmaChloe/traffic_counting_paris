<<<<<<< HEAD
{{ config(materialized='table') }}

select 
    * ,
    ST_GeogFromGeoJson(
    CONCAT(
      '{"type":"', geo_shape_geometry_type, '","coordinates":', geo_shape_geometry_coordinates, '}'
    )
  ) AS geography_column
from {{ ref('geographical_referential_raw')}}
=======
{{ config(materialized='table') }}

with raw_data as 
    (
select 
    *,
    row_number() over (partition by iu_ac order by date_fin desc) as rno
from {{ ref('geographical_referential_raw')}}
)
select
    iu_ac,
    libelle,
    iu_nd_aval,
    libelle_nd_aval,
    iu_nd_amont,
    libelle_nd_amont,
    geo_point_2d_lon,
    geo_point_2d_lat,
    ST_GeogFromGeoJson(
        CONCAT(
        '{"type":"', geo_shape_geometry_type, '","coordinates":', geo_shape_geometry_coordinates, '}'
        )
    ) as geography_column
from 
    raw_data
where rno = 1
>>>>>>> dbt
