import csv
from pathlib import Path

# Archivos originales delimitados por ';'
archivos_mexico = [
    "mercado_mexico_20240830.csv",
    "mercado_mexico_20240831.csv"
]

# Ruta base (ajusta si estás fuera del directorio `seeds`)
ruta_base = Path("/home/justinel/projects/dbt_spots/seeds")

for nombre in archivos_mexico:
    archivo_entrada = ruta_base / nombre
    archivo_salida = ruta_base / f"convertido_{nombre}"

    with open(archivo_entrada, mode="r", encoding="utf-8") as infile, \
         open(archivo_salida, mode="w", encoding="utf-8", newline='') as outfile:

        lector = csv.reader(infile, delimiter=';')
        escritor = csv.writer(outfile, delimiter=',')

        for fila in lector:
            escritor.writerow(fila)

    print(f"✅ Archivo convertido: {archivo_salida.name}")
