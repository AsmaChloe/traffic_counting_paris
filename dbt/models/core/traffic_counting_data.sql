select 
    data.iu_ac,
    data.libelle,
    data.t_1h,
    data.q,
    data.k,
    data.etat_trafic,
    data.iu_nd_amont,
    data.libelle_nd_amont,
    data.iu_nd_aval,
    data.libelle_nd_aval,
    data.etat_barre,
    geo.geo_point_2d_lon,
    geo.geo_point_2d_lat,
    geo.geography_column
from {{ref("stg_traffic_counting_data")}} data
left join {{ref('geographical_referential')}} geo 
on 
    (data.iu_ac = geo.iu_ac 
    and data.iu_nd_amont = geo.iu_nd_amont
    and data.iu_nd_aval = geo.iu_nd_aval)