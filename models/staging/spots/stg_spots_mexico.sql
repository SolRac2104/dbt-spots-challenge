{{ config(materialized='view') }}

with union_mexico as (

    select * from {{ ref('mercado_mexico_20240830') }}
    union all
    select * from {{ ref('mercado_mexico_20240831') }}

),

renombrado as (

    select
        'Mexico' as Pais,
        substr("Hora GMT", 1, 10) as Fecha,
        substr("Hora GMT", 12, 5) as Hora,
        "Medio",
        "Localidad" as Plaza,
        "Grupo Comercial" as Red,
        "Estación/Canal" as Emisora,
        "Grupo Estación" as Operador,
        "Canal" as Programa,
        null as Evento,
        "Marca",
        "Producto",
        "Versión",
        "Sector",
        "Sub Sector" as Subsector,
        "Categoria" as Segmento,
        null as Agencia,
        cast("Seg. Truncados" as integer) as Duracion,
        null as ValorDolar,
        0 as Falla,
        0 as EsPrimera

    from union_mexico

)

select * from renombrado
