import mysql.connector
from datetime import datetime

db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="admin",
    database="sistema_gestion_biblioteca"
)

cursor = db.cursor()

# Funcion para gestionar usuarios
def agregar_usuario():
    nombre = input("Nombre: ")
    apellido = input("Apellido: ")
    correo = input("Correo Electrónico: ")
    fecha_registro = datetime.now().date()
    estado_cuota = input("¿Estado de la cuota? (1 para al día, 0 para moroso): ")

    query = "INSERT INTO Usuarios (nombre, apellido, correo_electronico, fecha_registro, estado_cuota) VALUES (%s, %s, %s, %s, %s)"
    cursor.execute(query, (nombre, apellido, correo, fecha_registro, estado_cuota))
    db.commit()
    print("Usuario agregado exitosamente.")

def ver_usuarios():
    cursor.execute("SELECT * FROM Usuarios")
    for usuario in cursor.fetchall():
        print(usuario)

def actualizar_usuario():
    user_id = input("ID del usuario a actualizar: ")
    nuevo_estado_cuota = input("Nuevo estado de la cuota (1 para al día, 0 para moroso): ")
    
    query = "UPDATE Usuarios SET estado_cuota = %s WHERE id_usuario = %s"
    cursor.execute(query, (nuevo_estado_cuota, user_id))
    db.commit()
    print("Usuario actualizado exitosamente.")

def eliminar_usuario():
    user_id = input("ID del usuario a eliminar: ")
    query = "DELETE FROM Usuarios WHERE id_usuario = %s"
    cursor.execute(query, (user_id,))
    db.commit()
    print("Usuario eliminado exitosamente.")

# Funcion para gestionar libros
def agregar_libro():
    titulo = input("Título: ")
    autor = input("Autor: ")
    genero = input("Género: ")
    estado = input("Estado del libro (Disponible/Prestado): ")

    query = "INSERT INTO Libros (titulo, autor, genero, estado) VALUES (%s, %s, %s, %s)"
    cursor.execute(query, (titulo, autor, genero, estado))
    db.commit()
    print("Libro agregado exitosamente.")

def ver_libros():
    cursor.execute("SELECT * FROM Libros")
    for libro in cursor.fetchall():
        print(libro)

def actualizar_libro():
    libro_id = input("ID del libro a actualizar: ")
    nuevo_estado = input("Nuevo estado (Disponible/Prestado): ")

    query = "UPDATE Libros SET estado = %s WHERE id_libro = %s"
    cursor.execute(query, (nuevo_estado, libro_id))
    db.commit()
    print("Libro actualizado exitosamente.")

def eliminar_libro():
    libro_id = input("ID del libro a eliminar: ")
    query = "DELETE FROM Libros WHERE id_libro = %s"
    cursor.execute(query, (libro_id,))
    db.commit()
    print("Libro eliminado exitosamente.")

# Funcion para manejar prestamos y calcular multas
def manejar_prestamo():
    user_id = input("ID del usuario: ")
    libro_id = input("ID del libro: ")
    fecha_prestamo = datetime.now().date()

    query = "INSERT INTO Prestamos (id_usuario, id_libro, fecha_prestamo) VALUES (%s, %s, %s)"
    cursor.execute(query, (user_id, libro_id, fecha_prestamo))
    db.commit()
    print("Préstamo registrado exitosamente.")

def calcular_multa():
    user_id = input("ID del usuario: ")
    dias_retraso = int(input("Días de retraso: "))
    query = "CALL CalcularMulta(%s, %s)"
    cursor.execute(query, (user_id, dias_retraso))
    
    for multa in cursor.fetchall():
        print(f"La multa es: {multa[0]}")

# Funcion para manejar pagos
def realizar_pago():
    user_id = input("ID del usuario: ")
    monto = float(input("Monto del pago: "))
    fecha_pago = datetime.now().date()

    query = "INSERT INTO Pagos (id_usuario, monto, fecha_pago, estado_pago) VALUES (%s, %s, %s, 'Pagado')"
    cursor.execute(query, (user_id, monto, fecha_pago))
    db.commit()
    print("Pago realizado exitosamente.")

# Funcion para mostrar reporte de morosos
def reporte_morosos():
    query = "SELECT AVG(TIMESTAMPDIFF(MONTH, fecha_registro, CURDATE())) FROM Usuarios WHERE estado_cuota = 0"
    cursor.execute(query)
    for resultado in cursor.fetchall():
        print(f"Promedio de meses de morosidad: {resultado[0]} meses.")

# Funcion para modificar cuota
def modificar_cuota():
    nuevo_monto = float(input("Nuevo monto de la cuota: "))
    mes = int(input("Mes: "))
    anio = int(input("Año: "))

    query = "UPDATE Pagos SET monto = %s WHERE MONTH(fecha_pago) = %s AND YEAR(fecha_pago) = %s"
    cursor.execute(query, (nuevo_monto, mes, anio))
    db.commit()
    print("Cuota modificada exitosamente.")

# Funcion para mostrar el menu
def mostrar_menu():
    while True:
        print("\n----- Menú -----")
        print("1. Gestión de Usuarios")
        print("2. Gestión de Libros")
        print("3. Manejo de Préstamos")
        print("4. Reporte de Morosos")
        print("5. Modificar Cuota")
        print("6. Salir")
        
        opcion = input("Elija una opción: ")

        if opcion == "1":
            print("\n1. Agregar Usuario\n2. Ver Usuarios\n3. Actualizar Usuario\n4. Eliminar Usuario")
            subopcion = input("Elija una opción: ")
            if subopcion == "1":
                agregar_usuario()
            elif subopcion == "2":
                ver_usuarios()
            elif subopcion == "3":
                actualizar_usuario()
            elif subopcion == "4":
                eliminar_usuario()

        elif opcion == "2":
            print("\n1. Agregar Libro\n2. Ver Libros\n3. Actualizar Libro\n4. Eliminar Libro")
            subopcion = input("Elija una opción: ")
            if subopcion == "1":
                agregar_libro()
            elif subopcion == "2":
                ver_libros()
            elif subopcion == "3":
                actualizar_libro()
            elif subopcion == "4":
                eliminar_libro()

        elif opcion == "3":
            print("\n1. Registrar Préstamo\n2. Calcular Multa")
            subopcion = input("Elija una opción: ")
            if subopcion == "1":
                manejar_prestamo()
            elif subopcion == "2":
                calcular_multa()

        elif opcion == "4":
            reporte_morosos()

        elif opcion == "5":
            modificar_cuota()

        elif opcion == "6":
            print("Saliendo del sistema...")
            break

if __name__ == "__main__":
    mostrar_menu()

cursor.close()
db.close()
