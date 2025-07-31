{{ config(materialized='view') }}

with union_brasil as (

    select * from {{ ref('mercado_brasil_20240831') }}
    union all
    select * from {{ ref('mercado_brasil_20240901') }}

),

filtrado as (

    -- Incluye solo registros sin errores (Falla es NULL o 0)
    select *
    from union_brasil
    where Falla IS NULL OR Falla = 0

),

renombrado as (

    select
        Pais,
        Fecha,
        Hora,
        Medio,
        Plaza,
        Red,
        Emisora,
        Operador,
        Programa,
        Evento,
        Marca,
        Producto,
        Version,
        Sector,
        Subsector,
        Segmento,
        Agencia,
        Duracion,
        ValorDolar,
        Falla,
        EsPrimera
    from filtrado

)

select * from renombrado
