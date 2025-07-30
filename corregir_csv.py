import csv
import os

# Ruta a la carpeta donde están los archivos
carpeta_seeds = "seeds"

# Archivos a procesar
archivos = [
    "mercado_brasil_20240831.csv",
    "mercado_brasil_20240901.csv"
]

for nombre_archivo in archivos:
    ruta_original = os.path.join(carpeta_seeds, nombre_archivo)
    ruta_corregida = os.path.join(carpeta_seeds, "corregido_" + nombre_archivo)

    with open(ruta_original, mode='r', encoding='utf-8') as archivo_original:
        lector = csv.reader(archivo_original, delimiter=';')
        filas = list(lector)

    # Filtrar filas vacías y validar columnas
    encabezado = filas[0]
    columnas_esperadas = len(encabezado)
    filas_validas = [encabezado]

    for i, fila in enumerate(filas[1:], start=2):
        if len(fila) == columnas_esperadas:
            filas_validas.append(fila)
        else:
            print(f"[!] Fila descartada en {nombre_archivo} (línea {i}): {fila}")

    # Escribir archivo corregido con comas
    with open(ruta_corregida, mode='w', encoding='utf-8', newline='') as archivo_nuevo:
        escritor = csv.writer(archivo_nuevo, delimiter=',')
        escritor.writerows(filas_validas)

    print(f"[✔] Archivo corregido guardado: {ruta_corregida}")

