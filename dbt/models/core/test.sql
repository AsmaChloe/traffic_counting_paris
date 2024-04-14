with data as (
    select 
        *
    from 
        {{ref("stg_traffic_counting_data")}}
)
select 
    d.*
from 
    {{ref("geographical_referential")}} r
left join
data d 
on r.iu_ac = d.iu_ac
where d.libelle = 'Bac'
