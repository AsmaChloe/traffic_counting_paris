with 

source as (

    select * from {{ source('staging', 'traffic_counting_data_raw') }}

),

renamed as (

    select
        iu_ac,
        libelle,
        t_1h,
        q,
        k,
        etat_trafic,
        iu_nd_amont,
        libelle_nd_amont,
        iu_nd_aval,
        libelle_nd_aval,
        etat_barre,
        date_debut,
        date_fin,
        geo_point_2d,
        geo_shape

    from source

)

select * from renamed