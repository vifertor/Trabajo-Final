-------medida

CREATE PROCEDURE sp_AgregarMedida
    @NombreMedida VARCHAR(50),
    @Dimensiones VARCHAR(50),
    @Estado BIT
AS
BEGIN
    INSERT INTO Medida (NombreMedida, Dimensiones, Estado)
    VALUES (@NombreMedida, @Dimensiones, @Estado);
END;


CREATE PROCEDURE sp_ActualizarMedida
    @IdMedida INT,
    @NombreMedida VARCHAR(50),
    @Dimensiones VARCHAR(50),
    @Estado BIT
AS
BEGIN
    UPDATE Medida
    SET NombreMedida = @NombreMedida,
        Dimensiones = @Dimensiones,
        Estado = @Estado
    WHERE IdMedida = @IdMedida;
END;



CREATE PROCEDURE sp_ListarMedidasActivas
AS
BEGIN
    SELECT IdMedida, NombreMedida, Dimensiones, Estado
    FROM Medida
    WHERE Estado = 1;
END;


CREATE PROCEDURE sp_MostrarMedida
    @IdMedida INT
AS
BEGIN
    SELECT IdMedida, NombreMedida, Dimensiones, Estado
    FROM Medida
    WHERE IdMedida = @IdMedida;
END;


CREATE PROCEDURE sp_EliminarMedida
    @IdMedida INT
AS
BEGIN
    UPDATE Medida
    SET Estado = 0
    WHERE IdMedida = @IdMedida;
END;



---------------------------------------------------------------------

-- Procedimiento para Agregar una Versión
CREATE PROCEDURE AgregarVersionn
    @NombreVersionn VARCHAR(50),
    @Descripcion VARCHAR(100),
    @Estado BIT
AS
BEGIN
    INSERT INTO Versionn (NombreVersionn, Descripcion, Estado)
    VALUES (@NombreVersionn, @Descripcion, @Estado);
END;

-- Procedimiento para Actualizar una Versión
CREATE PROCEDURE ActualizarVersionn
    @IdVersionn INT,
    @NombreVersionn VARCHAR(50),
    @Descripcion VARCHAR(100),
    @Estado BIT
AS
BEGIN
    UPDATE Versionn
    SET NombreVersionn = @NombreVersionn,
        Descripcion = @Descripcion,
        Estado = @Estado
    WHERE IdVersionn = @IdVersionn;
END;

-- Procedimiento para Listar Versiones Activas
CREATE PROCEDURE ListarVersionesActivas
AS
BEGIN
    SELECT * FROM Versionn WHERE Estado = 1;
END;

-- Procedimiento para Mostrar una Versión por ID (si está activa)
CREATE PROCEDURE MostrarVersionn
    @IdVersionn INT
AS
BEGIN
    SELECT * FROM Versionn WHERE IdVersionn = @IdVersionn AND Estado = 1;
END;

-- Procedimiento para Eliminar una Versión (cambia Estado a 0)
CREATE PROCEDURE EliminarVersionn
    @IdVersionn INT
AS
BEGIN
    UPDATE Versionn
    SET Estado = 0
    WHERE IdVersionn = @IdVersionn;
END;




