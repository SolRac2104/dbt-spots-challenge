{{ config(materialized='view') }}

with source as (
    select * from {{ ref('mercado_mexico_20240830') }}
    union all
    select * from {{ ref('mercado_mexico_20240831') }}
),

renombrado as (
    select
        'Mexico' as pais,
        substr("Hora GMT", 1, 10) as fecha,
        substr("Hora GMT", 12, 8) as hora,
        "Medio" as Medio,
        "Localidad" as plaza,
        "Grupo Comercial" as red,
        "Estación/Canal" as emisora,
        "Grupo Estación" as operador,
        "Canal" as canal_original,
        null as evento,
        lower(trim("Marca")) as marca,
        "Producto",
        "Versión",
        "Sector",
        "Sub Sector" as subsector,
        "Categoria" as segmento_comercial,
        null as agencia,
        cast("Seg. Truncados" as integer) as spot_duracion,
        null as spot_costo,
        0 as falla,
        0 as esprimera
    from source
),

formateado as (
    select
        date(fecha) as fecha,
        pais,
        upper(trim(marca)) as marca,
        case
            when lower(canal_original) like '%espn%' then 'ESPN'
            else trim(canal_original)
        end as canal,
        spot_duracion,
        spot_costo,
        Medio,
        hora,
        case
            when hora between '08:00:00' and '17:59:59' then 'Day'
            when hora between '18:00:00' and '23:59:59' then 'Primetime'
            when hora between '00:00:00' and '01:59:59' then 'Primetime'
            else 'Greytime'
        end as segmento
    from renombrado
)

select * from formateado
