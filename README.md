#  DBT Code Challenge - Pipeline Spots de TV y Radio

Este proyecto es parte de un challenge técnico para un puesto como **Data Engineer**, y tiene como objetivo crear un pipeline con DBT que unifique spots de televisión y radio provenientes de distintos mercados de Latinoamérica.

## Descripción del Proyecto

Se trabajo con datasets de dos países: **Brasil** y **México**. Cada país tiene su propio formato y características únicas, por lo que el reto consiste en:

- Estandarizar columnas clave (fecha, marca, canal, medio, duración, hora).
- Homologar marcas y canales (por ejemplo, todos los ESPN como "ESPN").
- Crear segmentación horaria (`Day`, `Primetime`, `Greytime`).
- Imputar costos faltantes con promedios por segmento.
- Unificar ambas fuentes en una tabla de hechos (`fct_spots`).


## 📁 Estructura del Repositorio

dbt_spots/
├── datasets/ # Carpeta de datasets de entrada (simulan la nube)
│ ├── mercado_brasil_20240831.csv
│ └── mercado_mexico_20240831.csv
├── seeds/ # Seeds utilizados por DBT
│ ├── mercado_brasil_20240831.csv
│ └── mercado_mexico_20240831.csv
├── models/
│ ├── staging/
│ │ ├── stg_spots_brasil.sql
│ │ └── stg_spots_mexico.sql
│ └── marts/
│ └── spots/
│ └── fct_spots.sql
├── dbt_project.yml
├── requirements.txt
└── README.md

---
## Base de datos utilizada para este proyecto

### sqlite3

## Simulación de almacenamiento en la nube

Debido a las restricciones del entorno, **los datasets fueron alojados localmente en la carpeta `datasets/` y referenciados como seeds por DBT**. Esta simulación permite emular un entorno de cloud storage sin depender de un proveedor externo.

---
## Requerimientos
```
dbt-core==1.10.6
dbt-sqlite==1.10.0
```

## Instalación y Ejecución

### 1. Instalar dependencias
```
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 2. Ejecutar DBT
```
dbt seed         # Cargar datasets como tablas base
dbt run          # Ejecutar pipeline completo
dbt docs generate && dbt docs serve  # (Opcional) Explorar la documentación
```
## Transformaciones Principales
Limpieza y trim de marcas y canales

- Normalización de "ESPN"
- Conversión de formatos de fecha y hora
- Categorización de horarios en segmentos publicitarios
- Imputación de valores nulos usando promedios por segmento (sólo Brasil)
- Unión final en una tabla de negocio con campos clave

## "Resumen del Proceso y Desafíos" 

  El proyecto consistió en construir un modelo de datos unificado a partir de fuentes heterogéneas de Brasil y México. El principal reto fue la falta de estandarización en marcas, canales y formatos de hora, además de valores nulos en costos en el dataset de Brasil. Para resolverlo, se aplicaron limpiezas de texto, normalización de entidades (como "ESPN"), y se imputaron costos faltantes mediante promedios por segmento. También se diseñó una lógica robusta para clasificar los horarios en franjas (Day, Primetime, Greytime). El resultado es una tabla de hechos consistente y lista para análisis de inversión publicitaria por país, medio y franja horaria. 

