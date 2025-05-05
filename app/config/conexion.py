# Importando pyodbc para la conexión a la base de datos
import pyodbc 

class DBConexion:

    # Esta clase se encarga de establecer la conexión a la base de datos SQL Server utilizando pyodbc.
    def __init__(self, server, database, username, password, driver="{ODBC Driver 17 for SQL Server}"):
        self.server = server
        self.database = database
        self.username = username
        self.password = password
        self.driver = driver
        self.conn = None
    
    # Método para establecer la conexión a la base de datos
    def conectar(self):
        try:
            self.conn = pyodbc.connect(
                f"DRIVER={self.driver};"
                f"SERVER={self.server};"
                f"DATABASE={self.database};"
                f"UID={self.username};"
                f"PWD={self.password}",
                timeout=5
            )
        except Exception as e:
            print(f"Error al conectarse a la base de datos: {e}")
            raise

    # Cerrar la conexión a la base de datos
    def cerrar(self):
        if self.conn:
            self.conn.close()
            self.conn = None
    
    # Método para ejecutar una consulta SQL y devolver los resultados
    def ejecutar_procedimiento_almacenado(self, procedimiento, params=()):
        try:
            if not self.conn:
                self.conectar()
            cursor = self.conn.cursor()
            parametros = ','.join('?' for _ in params)
            consulta = f"EXEC {procedimiento} {parametros}"
            cursor.execute(consulta, params)
            self.conn.commit()
            return cursor
        except Exception as e:
            print(f"Error al ejecutar el procedimiento almacenado: {e}")
            raise
    
    # Método para ejecutar una consulta SQL y devolver los resultados
    def obtener_resultados(self, cursor):
        try:
            columnas = [column[0] for column in cursor.description]
            return [dict(zip(columnas, fila)) for fila in cursor.fetchall()]
        except Exception as e:
            print(f"Error al obtener los resultados: {e}")
            raise