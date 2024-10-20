CREATE PROCEDURE AjustarPreciosCompetitivos
AS
BEGIN
    BEGIN TRY
        -- Iniciar la transacción
        BEGIN TRANSACTION;

        DECLARE @ProductoId INT, @Precio DECIMAL(10,2), @Categoria VARCHAR(50);
        DECLARE @PromedioPrecioCompetencia DECIMAL(10,2);
        DECLARE @NuevoPrecio DECIMAL(10,2);
        DECLARE @Margen DECIMAL(10,2) = 0.05; -- Constante para margen del 5%
        
        -- Declarar el cursor
        DECLARE ProductoCursor CURSOR FOR
        SELECT ProductoId, Precio, Categoria
        FROM Productos;

        -- Abrir el cursor
        OPEN ProductoCursor;
        
        -- Obtener los datos del cursor
        FETCH NEXT FROM ProductoCursor INTO @ProductoId, @Precio, @Categoria;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Obtener el precio promedio de la competencia para la categoría actual
            SELECT @PromedioPrecioCompetencia = AVG(PrecioCompetencia)
            FROM CompetenciaPrecios
            WHERE Categoria = @Categoria;
            
            -- Verificar si hay datos de la competencia
            IF @PromedioPrecioCompetencia IS NOT NULL
            BEGIN
                -- Comparar el precio propio con el de la competencia
                IF @Precio > @PromedioPrecioCompetencia * (1 + @Margen)
                BEGIN
                    -- Reducir el precio en un 5%
                    SET @NuevoPrecio = @Precio * (1 - @Margen);
                END
                ELSE IF @Precio < @PromedioPrecioCompetencia * (1 - @Margen)
                BEGIN
                    -- Aumentar el precio en un 5%
                    SET @NuevoPrecio = @Precio * (1 + @Margen);
                END
                ELSE
                BEGIN
                    -- Mantener el precio sin cambios
                    SET @NuevoPrecio = @Precio;
                END
                
                -- Actualizar el precio en la tabla Productos
                UPDATE Productos
                SET Precio = @NuevoPrecio
                WHERE ProductoId = @ProductoId;
            END
            
            -- Obtener el siguiente registro del cursor
            FETCH NEXT FROM ProductoCursor INTO @ProductoId, @Precio, @Categoria;
        END

        -- Cerrar y liberar el cursor
        CLOSE ProductoCursor;
        DEALLOCATE ProductoCursor;

        -- Confirmar la transacción
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        ROLLBACK TRANSACTION;
        PRINT ERROR_MESSAGE();
    END CATCH;
END;
