-- models/marts/spots/fct_spots.sql
{{ config(materialized='table') }}

with brasil as (
    select
        date(Fecha) as fecha,
        'Brasil' as pais,
        upper(trim(Marca)) as marca,
        -- Normalizar canal con criterios simples, puedes extender
        case 
            when lower(Emisora) like '%espn%' then 'ESPN'
            else trim(Emisora)
        end as canal,
        Duracion as spot_duracion,
        ValorDolar as spot_costo,
        Medio as tipo_medio
    from {{ ref('stg_spots_brasil') }}
),

mexico as (
    select
        date(substr("Hora GMT", 1, 10)) as fecha, -- Ajusta según formato real
        'Mexico' as pais,
        upper(trim(Marca)) as marca,
        case
            when lower("Canal") like '%espn%' then 'ESPN'
            else trim("Canal")
        end as canal,
        cast("Duración Programada" as int) as spot_duracion,
        null as spot_costo, -- Aquí falta costo en México, hay que estimar luego
        Medio as tipo_medio
    from {{ ref('stg_spots_mexico') }}
),

union_all as (
    select * from brasil
    union all
    select * from mexico
)

select * from union_all
