CREATE PROCEDURE USP_CrearRol
    @Nombre NVARCHAR(50),
    @Descripcion NVARCHAR(250) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO Roles (Nombre, Descripcion)
    VALUES (@Nombre, @Descripcion);

    -- Devuelve el Id del rol creado
    SELECT SCOPE_IDENTITY() AS IdRol;
END;
GO

ALTER PROCEDURE USP_CrearRol
    @Nombre NVARCHAR(50),
    @Descripcion NVARCHAR(250)
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO Roles (Nombre, Descripcion)
    VALUES (@Nombre, @Descripcion);

    -- Conviértelo a INT explícitamente
    SELECT CAST(SCOPE_IDENTITY() AS INT) AS IdRol;
END;


----------------------
CREATE PROCEDURE USP_InsertarUsuario
    @Username NVARCHAR(50),
    @PasswordHash NVARCHAR(255),
    @Email NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    -- Verificar si el correo electrónico ya está registrado
    IF EXISTS (
        SELECT 1
        FROM Usuarios
        WHERE Email = @Email
    )
    BEGIN
        PRINT 'El correo electrónico ya está registrado.';
        RETURN;
    END

    -- Insertar un nuevo usuario
    INSERT INTO Usuarios (Username, PasswordHash, Email)
    VALUES (@Username, @PasswordHash, @Email);

    PRINT 'Usuario registrado exitosamente.';
END;
GO
EXEC USP_InsertarUsuario 
    @Username = 'ifffgf', 
    @PasswordHash = 'hashed_password_example', 
    @Email = 'ggd.perdddegz@fexample.com';


-----------------------
CREATE PROCEDURE USP_ListarRoles
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        IdRol,
        Nombre,
        Descripcion
    FROM 
        Roles
    ORDER BY 
        Nombre ASC; -- Ordenar alfabéticamente por Nombre
END;
GO



EXEC USP_CrearRol @Nombre = 'Administrador', @Descripcion = 'Rol con permisos completos';


EXEC USP_ListarRoles;
select *from usuario
-----------------
CREATE PROCEDURE USP_AsignarUsuarioRol
    @IdUsuario INT,
    @IdRol INT
AS
BEGIN
    SET NOCOUNT ON;

    
    IF NOT EXISTS (
        SELECT 1
        FROM UsuariosRoles
        WHERE IdUsuario = @IdUsuario AND IdRol = @IdRol
    )
    BEGIN
        INSERT INTO UsuariosRoles (IdUsuario, IdRol)
        VALUES (@IdUsuario, @IdRol);
    END
    ELSE
    BEGIN
        PRINT 'La relación entre el usuario y el rol ya existe.';
    END
END;
GO
--




---------------------------------------------

CREATE PROCEDURE USP_ListarUsuariosRoles
AS
BEGIN
    SET NOCOUNT ON;

    -- Listar usuarios y sus roles
    SELECT 
        u.IdUsuario,
        u.Username,
        u.Email,
        r.IdRol,
        r.Nombre AS RolNombre,
        r.Descripcion AS RolDescripcion
    FROM 
        Usuarios u
    INNER JOIN 
        UsuariosRoles ur ON u.IdUsuario = ur.IdUsuario
    INNER JOIN 
        Roles r ON ur.IdRol = r.IdRol
    ORDER BY 
        u.IdUsuario, r.Nombre;
END;
GO

EXEC USP_ListarUsuariosRoles;


EXEC USP_AsignarUsuarioRol @IdUsuario = 1, @IdRol = 2;


select * from Usuarios


----------------------------

EXEC USP_AsignarUsuarioRol @IdUsuario = 2, @IdRol = 2;


CREATE PROCEDURE sp_AgregarUsuario
    @Username NVARCHAR(50),
    @PasswordHash NVARCHAR(255),
    @Email NVARCHAR(100)
AS
BEGIN
    -- Insertar el nuevo usuario en la tabla Usuarios
    INSERT INTO Usuarios (Username, PasswordHash, Email)
    VALUES (@Username, @PasswordHash, @Email);
    
    -- Devolver el IdUsuario del nuevo registro insertado
    SELECT SCOPE_IDENTITY() AS IdUsuario;
END;
