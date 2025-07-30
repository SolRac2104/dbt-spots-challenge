with brasil as (
    select
        Pais,
        Fecha,
        Hora,
        Medio,
        Canal,
        Marca,
        Duracion,
        ValorDolar,
        Segmento
    from {{ ref('stg_spots_brasil') }}
),

mexico as (
    select
        'México' as Pais,  -- México no tiene columna País, la asignamos manualmente
        Fecha,
        Hora_GMT as Hora,
        Medio,
        Canal,
        Marca,
        Duración_Programada as Duracion,
        null as ValorDolar,  -- Aquí agregas la lógica para costo si la tienes
        Rango_Horario as Segmento
    from {{ ref('stg_spots_mexico') }}
)

select * from brasil
union all
select * from mexico

