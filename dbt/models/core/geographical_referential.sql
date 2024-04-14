{{ config(materialized='table') }}

select 
    *
from {{ ref('geographical_referential_raw')}}