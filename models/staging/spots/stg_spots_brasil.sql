{{ config(materialized='view') }}

with source as (
    select * from {{ ref('mercado_brasil_20240831') }}
    union all
    select * from {{ ref('mercado_brasil_20240901') }}
),

limpio as (
    select
        'Brasil' as pais,
        Fecha as fecha,
        Hora as hora,
        Medio as tipo_medio,
        Plaza as canal_original,
        Red,
        Emisora,
        Operador,
        Programa,
        Evento,
        lower(trim(Marca)) as marca,
        Producto,
        Version,
        Sector,
        Subsector,
        Segmento,
        Agencia,
        Duracion as spot_duracion,
        ValorDolar as spot_costo,
        Falla,
        EsPrimera
    from source
    where Falla = 0
),

formateado as (
    select
        date(fecha) as fecha,
        pais,
        upper(trim(marca)) as marca,
        case 
            when lower(Emisora) like '%espn%' then 'ESPN'
            else trim(Emisora)
        end as canal,
        spot_duracion,
        spot_costo,
        tipo_medio,
        hora,
        case
            when hora between '08:00:00' and '17:59:59' then 'Day'
            when hora between '18:00:00' and '23:59:59' then 'Primetime'
            when hora between '00:00:00' and '01:59:59' then 'Primetime'
            else 'Greytime'
        end as segmento
    from limpio
)

select * from formateado
