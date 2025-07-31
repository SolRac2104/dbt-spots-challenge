-- models/marts/spots/union_all_spots.sql
{{ config(materialized='table') }}

SELECT
  fecha,
  canal,
  segmento,
  marca,
  spot_costo,
  pais
FROM {{ ref('fct_spots') }}
