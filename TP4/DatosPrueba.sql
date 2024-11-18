-- Insertar datos en Productos
INSERT INTO Productos (NombreProducto, Precio, Categoria)
VALUES 
('Producto A', 100.00, 'Electrónica'),
('Producto B', 200.00, 'Electrónica'),
('Producto C', 150.00, 'Hogar');

-- Insertar datos en CompetenciaPrecios
INSERT INTO CompetenciaPrecios (NombreProducto, PrecioCompetencia, Categoria)
VALUES 
('Producto A', 95.00, 'Electrónica'),
('Producto B', 210.00, 'Electrónica'),
('Producto C', 140.00, 'Hogar');
