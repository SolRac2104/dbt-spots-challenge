import sqlite3

# en ruta_db añadi la ruta de mi pc esta debe ser reemplazada por la ruta local del equipo a instalar
ruta_db = '/home/justinel/projects/dbt_spots/data/etl.db'

# Nombres de las tablas generadas desde los CSV es carge en el carpeta seeds
tablas = [
    "mercado_brasil_20240831",
    "mercado_brasil_20240901",
    "mercado_mexico_20240830",
    "mercado_mexico_20240831"
]

# Conexión a la base de datos SQLite
conn = sqlite3.connect(ruta_db)
cursor = conn.cursor()

# Mostrar columnas de cada tabla
for tabla in tablas:
    print(f"\n📋 Columnas en {tabla}:")
    try:
        cursor.execute(f"PRAGMA table_info({tabla});")
        columnas = cursor.fetchall()
        if columnas:
            for col in columnas:
                print(f"- {col[1]} ({col[2]})")  # col[1]: nombre, col[2]: tipo de dato
        else:
            print("⚠️  Tabla vacía o no encontrada.")
    except sqlite3.Error as e:
        print(f"❌ Error al acceder a la tabla {tabla}: {e}")

conn.close()

