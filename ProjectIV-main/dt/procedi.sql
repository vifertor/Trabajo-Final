-- Procedimiento para Agregar un Color
CREATE PROCEDURE AgregarColor
    @NombreColor VARCHAR(50),
    @Descripcion VARCHAR(100),
    @Estado BIT
AS
BEGIN
    INSERT INTO Color (NombreColor, Descripcion, Estado)
    VALUES (@NombreColor, @Descripcion, @Estado);
END;

-- Procedimiento para Actualizar un Color
CREATE PROCEDURE ActualizarColor
    @IdColor INT,
    @NombreColor VARCHAR(50),
    @Descripcion VARCHAR(100),
    @Estado BIT
AS
BEGIN
    UPDATE Color
    SET NombreColor = @NombreColor,
        Descripcion = @Descripcion,
        Estado = @Estado
    WHERE IdColor = @IdColor;
END;

-- Procedimiento para Listar Colores Activos
CREATE PROCEDURE ListarColoresActivos
AS
BEGIN
    SELECT * FROM Color WHERE Estado = 1;
END;

-- Procedimiento para Mostrar un Color por ID (si está activo)
CREATE PROCEDURE MostrarColor
    @IdColor INT
AS
BEGIN
    SELECT * FROM Color WHERE IdColor = @IdColor AND Estado = 1;
END;

-- Procedimiento para Eliminar un Color (cambia Estado a 0)
CREATE PROCEDURE EliminarColor
    @IdColor INT
AS
BEGIN
    UPDATE Color
    SET Estado = 0
    WHERE IdColor = @IdColor;
END;


--------------------------------------------------------------------------
--crear
EXEC AgregarColor @NombreColor = 'Rojofg', @Descripcion = 'Color rojo brillante', @Estado = 1;

---actuali
EXEC ActualizarColor @IdColor = 1, @NombreColor = 'Azulffff', @Descripcion = 'Color azul oscuro', @Estado = 1;


EXEC ListarColoresActivos;

EXEC MostrarColor @IdColor = 1;


EXEC EliminarColor @IdColor = 1;



----------------------------------------------------------------------------------------------------------------

----tamaño

-- Procedimiento para Agregar un Tamaño
CREATE PROCEDURE AgregarTamaño
    @NombreTamaño VARCHAR(50),
    @Dimensiones VARCHAR(50),
    @Estado BIT
AS
BEGIN
    INSERT INTO Tamaño (NombreTamaño, Dimensiones, Estado)
    VALUES (@NombreTamaño, @Dimensiones, @Estado);
END;

-- Procedimiento para Actualizar un Tamaño
CREATE PROCEDURE ActualizarTamaño
    @IdTamaño INT,
    @NombreTamaño VARCHAR(50),
    @Dimensiones VARCHAR(50),
    @Estado BIT
AS
BEGIN
    UPDATE Tamaño
    SET NombreTamaño = @NombreTamaño,
        Dimensiones = @Dimensiones,
        Estado = @Estado
    WHERE IdTamaño = @IdTamaño;
END;

-- Procedimiento para Listar Tamaños Activos
CREATE PROCEDURE ListarTamañosActivos
AS
BEGIN
    SELECT * FROM Tamaño WHERE Estado = 1;
END;


-- Procedimiento para Mostrar un Tamaño por ID (si está activo)
CREATE PROCEDURE MostrarTamaño
    @IdTamaño INT
AS
BEGIN
    SELECT * FROM Tamaño WHERE IdTamaño = @IdTamaño AND Estado = 1;
END;

-- Procedimiento para Eliminar un Tamaño (cambia Estado a 0)
CREATE PROCEDURE EliminarTamaño
    @IdTamaño INT
AS
BEGIN
    UPDATE Tamaño
    SET Estado = 0
    WHERE IdTamaño = @IdTamaño;
END;

--------------prueba

EXEC AgregarTamaño
    @NombreTamaño = 'Pequeño',
    @Dimensiones = '10x10 cm',
    @Estado = 1; -- Estado Activo

EXEC ListarTamañosActivos;

EXEC MostrarTamaño
    @IdTamaño = 1;


EXEC ActualizarTamaño
    @IdTamaño = 1,
    @NombreTamaño = 'Mediano',
    @Dimensiones = '15x15 cm',
    @Estado = 1;


EXEC EliminarTamaño
    @IdTamaño = 1;



------------------------------------------------------------------------------------------------------
--version

CREATE PROCEDURE AgregarVersion
    @NombreVersion VARCHAR(50),
    @Descripcion VARCHAR(100),
    @Estado BIT
AS
BEGIN
    INSERT INTO [Version] (NombreVersion, Descripcion, Estado)
    VALUES (@NombreVersion, @Descripcion, @Estado);
END;

EXEC ListarVersionesActivas;

CREATE PROCEDURE ActualizarVersion
    @IdVersion INT,
    @NombreVersion VARCHAR(50),
    @Descripcion VARCHAR(100),
    @Estado BIT
AS
BEGIN
    UPDATE [Version]
    SET NombreVersion = @NombreVersion,
        Descripcion = @Descripcion,
        Estado = @Estado
    WHERE IdVersion = @IdVersion;
END;


CREATE PROCEDURE ListarVersionesActivas
AS
BEGIN
    SELECT * FROM [Version] WHERE Estado = 1;
END;


CREATE PROCEDURE MostrarVersion
    @IdVersion INT
AS
BEGIN
    SELECT * FROM [Version] WHERE IdVersion = @IdVersion AND Estado = 1;
END;


CREATE PROCEDURE EliminarVersion
    @IdVersion INT
AS
BEGIN
    UPDATE [Version]
    SET Estado = 0
    WHERE IdVersion = @IdVersion;
END;

EXEC AgregarVersion @NombreVersion = 'Version 1', @Descripcion = 'Primera versión del sistema', @Estado = 1;