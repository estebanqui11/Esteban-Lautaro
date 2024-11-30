CREATE DATABASE IF NOT EXISTS sistema_gestion_biblioteca;
USE sistema_gestion_biblioteca;

-- Creacion de las tablas

CREATE TABLE IF NOT EXISTS Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    fecha_registro DATE NOT NULL,
    estado_cuota BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS Libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    autor VARCHAR(255) NOT NULL,
    genero VARCHAR(50),
    estado ENUM('Disponible', 'Prestado') DEFAULT 'Disponible'
);

CREATE TABLE IF NOT EXISTS Prestamos (
    id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    id_libro INT,
    fecha_prestamo DATE NOT NULL,
    fecha_devolucion DATE,
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (id_libro) REFERENCES Libros(id_libro) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_pago DATE NOT NULL,
    estado_pago ENUM('Pagado', 'Pendiente') DEFAULT 'Pendiente',
    FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- Insertar datos iniciales

INSERT INTO Usuarios (nombre, apellido, correo_electronico, fecha_registro, estado_cuota) VALUES
('Juan', 'Pérez', 'juan@example.com', '2023-01-15', TRUE),
('Ana', 'Gómez', 'ana@example.com', '2023-02-20', TRUE),
('Carlos', 'López', 'carlos@example.com', '2023-03-12', FALSE),
('Laura', 'Martínez', 'laura@example.com', '2023-04-05', TRUE),
('Pedro', 'Díaz', 'pedro@example.com', '2023-05-18', TRUE),
('María', 'Fernández', 'maria@example.com', '2023-06-25', FALSE),
('Luis', 'García', 'luis@example.com', '2023-07-30', TRUE),
('Sofía', 'Rodríguez', 'sofia@example.com', '2023-08-10', TRUE),
('Miguel', 'Hernández', 'miguel@example.com', '2023-09-15', TRUE),
('Elena', 'Sánchez', 'elena@example.com', '2023-10-01', FALSE);

INSERT INTO Libros (titulo, autor, genero, estado) VALUES
('El Quijote', 'Miguel de Cervantes', 'Novela', 'Disponible'),
('1984', 'George Orwell', 'Distopía', 'Disponible'),
('Cien años de soledad', 'Gabriel García Márquez', 'Realismo mágico', 'Disponible'),
('Fahrenheit 451', 'Ray Bradbury', 'Ciencia ficción', 'Disponible'),
('Matar a un ruiseñor', 'Harper Lee', 'Ficción', 'Disponible'),
('El Hobbit', 'J.R.R. Tolkien', 'Fantasía', 'Disponible'),
('Orgullo y prejuicio', 'Jane Austen', 'Romántico', 'Disponible'),
('La sombra del viento', 'Carlos Ruiz Zafón', 'Suspenso', 'Disponible'),
('Harry Potter y la piedra filosofal', 'J.K. Rowling', 'Fantasía', 'Disponible'),
('El código Da Vinci', 'Dan Brown', 'Thriller', 'Disponible');

-- Creacion de procedimientos almacenados

DELIMITER $$ 
CREATE PROCEDURE CalcularMulta(IN usuario_id INT, IN dias_retraso INT)
BEGIN
    DECLARE cuota DECIMAL(10,2);
    DECLARE multa DECIMAL(10,2);
    
    -- Obtener cuota del usuario
    SELECT monto INTO cuota
    FROM Pagos
    WHERE id_usuario = usuario_id AND estado_pago = 'Pendiente' ORDER BY fecha_pago DESC LIMIT 1;
    
    -- Calcular la multa
    SET multa = (cuota * 0.03) * dias_retraso;
    
    -- Mostrar la multa
    SELECT multa AS multa_a_pagar;
END $$ 
DELIMITER ;

-- Crear indices 

CREATE INDEX idx_estado_cuota ON Usuarios(estado_cuota);
CREATE INDEX idx_estado_libro ON Libros(estado);

-- Consultas adicionales 
SELECT nombre, apellido, estado_cuota FROM Usuarios WHERE estado_cuota = FALSE;
