{{ config(materialized='view') }}

with source as (
    select * from {{ ref('mercado_brasil_20240831') }}
    union all
    select * from {{ ref('mercado_brasil_20240901') }}
),

limpio as (
    select
        Pais,
        Fecha,
        Hora,
        Medio,
        Plaza as Canal,
        Red,
        Emisora,
        Operador,
        Programa,
        Evento,
        lower(trim(Marca)) as Marca,
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
    from source
    where Falla = 0  -- eliminamos los falsos positivos
)

select * from limpio
