-- models/marts/spots/fct_spots.sql
{{ config(materialized='table') }}

with brasil as (
    select
        date(Fecha) as fecha,
        'Brasil' as pais,
        upper(trim(Marca)) as marca,
        case 
            when lower(Emisora) like '%espn%' then 'ESPN'
            else trim(Emisora)
        end as canal,
        Duracion as spot_duracion,
        ValorDolar as spot_costo,
        Medio as tipo_medio, 
        Hora,
        case
            when Hora between '08:00:00' and '17:59:59' then 'Day'
            when Hora between '18:00:00' and '23:59:59' then 'Primetime'
            when Hora between '00:00:00' and '01:59:59' then 'Primetime'
            else 'Greytime'
        end as segmento
    from {{ ref('stg_spots_brasil') }}
),

mexico as (
    select
        date(substr("Hora GMT", 1, 10)) as fecha,
        'Mexico' as pais,
        upper(trim(Marca)) as marca,
        case
            when lower("Canal") like '%espn%' then 'ESPN'
            else trim("Canal")
        end as canal,
        cast("Duración Programada" as int) as spot_duracion,
        null as spot_costo,
        Medio as tipo_medio,  
        substr("Hora GMT", 12, 8) as Hora,
        case
            when substr("Hora GMT", 12, 8) between '08:00:00' and '17:59:59' then 'Day'
            when substr("Hora GMT", 12, 8) between '18:00:00' and '23:59:59' then 'Primetime'
            when substr("Hora GMT", 12, 8) between '00:00:00' and '01:59:59' then 'Primetime'
            else 'Greytime'
        end as segmento
    from {{ ref('stg_spots_mexico') }}
),

costos_promedio_brasil as (
    select
        segmento,
        avg(spot_costo) as costo_promedio
    from brasil
    where spot_costo is not null
    group by segmento
),

spots_brasil_imputado as (
    select
        b.fecha,
        b.pais,
        b.marca,
        b.canal,
        b.spot_duracion,
        coalesce(b.spot_costo, cp.costo_promedio) as spot_costo,
        b.tipo_medio,
        b.segmento
    from brasil b
    left join costos_promedio_brasil cp on b.segmento = cp.segmento
),

spots_mexico_imputado as (
    select
        m.fecha,
        m.pais,
        m.marca,
        m.canal,
        m.spot_duracion,
        cp.costo_promedio as spot_costo,
        m.tipo_medio,
        m.segmento
    from mexico m
    left join costos_promedio_brasil cp on m.segmento = cp.segmento
),

union_all as (
    select * from spots_brasil_imputado
    union all
    select * from spots_mexico_imputado
)

select * from union_all
