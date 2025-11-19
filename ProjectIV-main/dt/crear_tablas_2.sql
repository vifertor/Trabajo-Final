-- Crear base de datos
create database Cellshopcenter112024;
-- Seleccionar la base de datos
USE Cellshopcenter112024;

------------Tablas de administracion de usuarios------------------------------------------------------------------------

--JUAN
-- Tabla Usuarios
CREATE TABLE Usuarios (
    IdUsuario INT PRIMARY KEY IDENTITY(1,1),
    Username NVARCHAR(50) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    FechaCreacion DATETIME DEFAULT GETDATE(),
    UltimoLogin DATETIME
);

-- Tabla Roles
CREATE TABLE Roles (
    IdRol INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(250)
);
--catalogo
CREATE TABLE Catalogos (
    IdCatalogo INT PRIMARY KEY IDENTITY(1,1),
    Tipo NVARCHAR(50) NOT NULL,          
    Valor NVARCHAR(50) NOT NULL,         
    Descripcion NVARCHAR(250)            
);

-- Tabla Permisos
CREATE TABLE Permisos (
    IdPermiso INT PRIMARY KEY IDENTITY(1,1),
    Nombre NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(250)
);

--Tabla Empleados
CREATE TABLE EMPLEADO (
    IdEmpleado INT PRIMARY KEY IDENTITY(1,1),
    Nombres VARCHAR(100) NOT NULL,           
    Apellidos VARCHAR(100),                 
    Correo VARCHAR(100) NOT NULL,           
    Direccion VARCHAR(255),                  
    Telefono VARCHAR(50),                    
    Genero VARCHAR(20),                     
    FechaNacimiento DATE,                   
    Estado BIT,                              
    FechaRegistro DATETIME DEFAULT GETDATE() 
);

-- Tabla UsuariosRoles (relaci�n muchos a muchos entre Usuarios y Roles)
CREATE TABLE UsuariosRoles (
    IdUsuario INT NOT NULL,
    IdRol INT NOT NULL,
    PRIMARY KEY (IdUsuario, IdRol),
    CONSTRAINT FK_UsuariosRoles_Usuario 
        FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario) ,
    CONSTRAINT FK_UsuariosRoles_Rol 
        FOREIGN KEY (IdRol) REFERENCES Roles(IdRol) 
);

-- Tabla PermisoRoles (relaci�n muchos a muchos entre Permisos y Roles)
CREATE TABLE PermisoRoles (
    IdPermiso INT NOT NULL,
    IdRol INT NOT NULL,
    PRIMARY KEY (IdPermiso, IdRol),
    CONSTRAINT FK_PermisoRoles_Permiso 
        FOREIGN KEY (IdPermiso) REFERENCES Permisos(IdPermiso) ,
    CONSTRAINT FK_PermisoRoles_Rol 
        FOREIGN KEY (IdRol) REFERENCES Roles(IdRol) 
);

-- Tabla Tokens (para manejar tokens de autenticaci�n de usuarios)
CREATE TABLE Tokens (
    IdToken INT PRIMARY KEY IDENTITY(1,1),
    IdUsuario INT NOT NULL,
    Token NVARCHAR(255) NOT NULL,
    FechaExpiracion DATETIME NOT NULL,
    CONSTRAINT FK_Tokens_Usuario 
        FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario) 
);

-- Tabla UsuarioEmpleado
CREATE TABLE UsuarioEmpleado (
    IdUsuario INT NOT NULL,  -- ID del usuario
    IdEmpleado INT NOT NULL,  -- ID del empleado
    PRIMARY KEY (IdUsuario),
    CONSTRAINT FK_UsuarioEmpleado_Usuario
        FOREIGN KEY (IdUsuario) REFERENCES Usuarios(IdUsuario) ,
    CONSTRAINT FK_UsuarioEmpleado_Empleado
        FOREIGN KEY (IdEmpleado) REFERENCES EMPLEADO(IdEmpleado) 
);







-------------------------tablas proveedor y cliente y empleado--------------------------------
--ANGELO
-- Crear tabla Empresas para almacenar la informaci�n de cada empresa
CREATE TABLE Empresas (
    IdEmpresa INT PRIMARY KEY IDENTITY(1,1),
    NombreEmpresa VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(250)
);

-- Modificar la tabla Proveedor
CREATE TABLE Proveedor (
    IdProveedor INT PRIMARY KEY IDENTITY(1,1),
    IdEmpresa INT NOT NULL,  -- Clave for�nea hacia Empresas
    EncargadoNombre VARCHAR(50),
    EncargadoApellido1 VARCHAR(50),
    EncargadoApellido2 VARCHAR(50),
    Correo VARCHAR(50),
    Telefono VARCHAR(50),
    Estado BIT,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Proveedor_Empresa FOREIGN KEY (IdEmpresa) REFERENCES Empresas(IdEmpresa) 
);

--cliente--
create table CLIENTE(
IdCliente int primary key identity,
NombreCliente varchar(50),
NombreApellido_1 varchar(50),
NombreApellido_2 varchar(50),
Correo varchar (50),
Telefono varchar (50),
Estado bit,
FechaRegistro datetime default getdate()
)

go



-------------------------llaves foraneas del catalogo----------------------------

create table CATEGORIA(
idCategoria int primary key identity,
NombreCategoria varchar (50),
Descripcion varchar (100),
Estado bit,

)
go

--GONZALO
create table MARCA(
idMarca int primary key identity,
Nombre varchar (50),
Estado bit,

)

create table MODELO(
idModelo int primary key identity,
Nombre varchar (50),
Estado bit,

)

create table Lote(
IdLote int primary key identity,
Num_lote varchar (50),
Estado bit,
FechaRegistro datetime default getdate()
)

create table PRODUCTO(
idProducto int primary key identity,
Nombre varchar (50),
Descripcion varchar (50),
Estado bit,

)


CREATE TABLE Color (
    IdColor INT PRIMARY KEY IDENTITY(1,1),
    NombreColor VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(100),
    Estado BIT,  
   
);

--ISAIAS
-- Tabla Tamano

CREATE TABLE Medida (
    IdMedida INT PRIMARY KEY IDENTITY(1,1),
    NombreMedida VARCHAR(50) NOT NULL,
    Dimensiones VARCHAR(50),  -- Ejemplo: "10x15 cm"
    Estado BIT  
);



-- Tabla Version
CREATE TABLE versionn (
    IdVersionn INT PRIMARY KEY IDENTITY(1,1),
    NombreVersionn VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(100),
    Estado BIT, 
   
);


--------------------------------------------articulos-inventario-----------------------------------------

-- Tabla Inventario
CREATE TABLE Inventario (
    IdInventario INT PRIMARY KEY IDENTITY(1,1),
    IdProducto INT NOT NULL,
    IdLote VARCHAR(50) NOT NULL,
    Descripcion VARCHAR(50),
    IdCategoria INT NOT NULL,
    IdMarca INT NOT NULL,
    IdModelo INT NULL,
    IdColor INT NULL,
    IdMedida INT NULL,
    IdVersionn INT NULL,
    Stock INT NOT NULL DEFAULT 0,
    PrecioCompra DECIMAL(10,2) DEFAULT 0,
    PrecioVenta DECIMAL(10,2) DEFAULT 0,
    Estado BIT,
    FechaRegistro DATETIME DEFAULT GETDATE(),
    
    -- Claves for�neas
    CONSTRAINT FK_Inventario_Lote FOREIGN KEY (IdLote) REFERENCES Lote(IdLote),
    CONSTRAINT FK_Inventario_Producto FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto) ,
    CONSTRAINT FK_Inventario_Categoria FOREIGN KEY (IdCategoria) REFERENCES Categoria(IdCategoria) ,
    CONSTRAINT FK_Inventario_Marca FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca),
    CONSTRAINT FK_Inventario_Modelo FOREIGN KEY (IdModelo) REFERENCES Modelo(IdModelo) ,
    CONSTRAINT FK_Inventario_Color FOREIGN KEY (IdColor) REFERENCES Color(IdColor) ,
  CONSTRAINT FK_Inventario_Medida FOREIGN KEY (IdMedida) REFERENCES Medida(IdMedia),
    CONSTRAINT FK_Inventario_Versionn FOREIGN KEY (IdVersionn) REFERENCES Versionn(IdVersionn)
);




------------------ proceso de compra-------------


CREATE TABLE COMPRA (
    IdCompra INT PRIMARY KEY IDENTITY(1,1),
    IdProveedor INT NOT NULL,
	IdEmpleado INT NOT NULL,    
    MontoTotal DECIMAL(10,2),
    FechaCompra DATETIME DEFAULT GETDATE(),  
    Observaciones VARCHAR(255),
    -- Relaciones con claves for�neas
    FOREIGN KEY (IdProveedor) REFERENCES PROVEEDOR(IdProveedor) ,
	 FOREIGN KEY (IdEmpleado) REFERENCES EMPLEADO(IdEmpleado)
);

CREATE TABLE DETALLECOMPRA (
    IdDetalleCompra INT PRIMARY KEY IDENTITY(1,1),
    IdCompra INT NOT NULL,                
    IdInventario INT NOT NULL,            
    PrecioCompra DECIMAL(10,2) DEFAULT 0, 
    PrecioVenta DECIMAL(10,2) DEFAULT 0,  
    Cantidad INT NOT NULL,                
    MontoTotal DECIMAL(10,2),             -- Monto total de la compra (Cantidad * PrecioCompra)
    -- Relaciones con claves for�neas
    FOREIGN KEY (IdCompra) REFERENCES COMPRA(IdCompra),
    FOREIGN KEY (IdInventario) REFERENCES INVENTARIO(IdInventario) 
);

------------------------------devolucion de compra--------------------------------------
CREATE TABLE DEVOLUCION_COMPRA (
    IdDevolucionCompra INT PRIMARY KEY IDENTITY,         
    IdCompra INT NOT NULL,                              
    Motivo VARCHAR(255),                                  
    MontoDevuelto DECIMAL(10,2),                         
    FechaDevolucion DATETIME DEFAULT GETDATE(),           
    Estado BIT,                                          
    -- Relaciones con claves for�neas
    FOREIGN KEY (IdCompra) REFERENCES COMPRA(IdCompra) 
);

CREATE TABLE DETALLE_DEVOLUCION_COMPRA (
    IdDetalleDevolucionCompra INT PRIMARY KEY IDENTITY,          
    IdDevolucionCompra INT NOT NULL,                              
    IdInventario INT NOT NULL,                                   
    Cantidad INT NOT NULL,                                        
    SubTotal DECIMAL(10,2) NOT NULL,                              
    FechaRegistro DATETIME DEFAULT GETDATE(),                     
    -- Relaciones con claves for�neas
    FOREIGN KEY (IdDevolucionCompra) REFERENCES DEVOLUCION_COMPRA(IdDevolucionCompra) ON DELETE CASCADE,
    FOREIGN KEY (IdInventario) REFERENCES INVENTARIO(IdInventario) ON DELETE CASCADE
);



-------------------------------proceso venta--------------------------------------------

CREATE TABLE VENTA (
    IdVenta INT PRIMARY KEY IDENTITY(1,1),            
    FechaVenta DATETIME DEFAULT GETDATE(),             
    TipoPago VARCHAR(50),                                                       
    IdEmpleado INT NOT NULL,                           
    IdCliente INT NOT NULL,                            
    MontoPago DECIMAL(10,2),                          
    MontoCambio DECIMAL(10,2),                         
    MontoTotal DECIMAL(10,2),                         
       
    -- Relaciones con claves for�neas

    FOREIGN KEY (IdEmpleado) REFERENCES EMPLEADO(IdEmpleado),
    FOREIGN KEY (IdCliente) REFERENCES CLIENTE(IdCliente)
)


CREATE TABLE DETALLEVENTA (
    IdDetalleVenta INT PRIMARY KEY IDENTITY(1,1),         
    IdVenta INT NOT NULL,                                   
    IdInventario INT NOT NULL,                               
    PrecioVenta DECIMAL(10,2) DEFAULT 0,                     
    Cantidad INT,                                          
    SubTotal DECIMAL(10,2),                                  
    -- Relaciones con claves for�neas
    FOREIGN KEY (IdVenta) REFERENCES VENTA(IdVenta) ,
    FOREIGN KEY (IdInventario) REFERENCES PRODUCTO(IdProducto) 
);


---------------------------------------------devolucion de venta-----------------------------


CREATE TABLE DEVOLUCION_VENTA (
    IdDevolucionVenta INT PRIMARY KEY IDENTITY,             
    IdVenta INT NOT NULL,                                   
    Motivo VARCHAR(255) NOT NULL,                            
    MontoDevuelto DECIMAL(10,2) NOT NULL,                    
    FechaDevolucion DATETIME DEFAULT GETDATE(),             
    Estado BIT DEFAULT 1,                                    
    -- Relaciones con claves for�neas
    FOREIGN KEY (IdVenta) REFERENCES VENTA(IdVenta)

);

CREATE TABLE DETALLE_DEVOLUCION_VENTA (
    IdDetalleDevolucionVenta INT PRIMARY KEY IDENTITY,           
    IdDevolucionVenta INT NOT NULL,                              
    IdInventario INT NOT NULL,                                    
    Cantidad INT NOT NULL,                                       
    SubTotal DECIMAL(10,2) NOT NULL,                              
    FechaRegistro DATETIME DEFAULT GETDATE(),                     
    -- Relaciones con claves for�neas
    FOREIGN KEY (IdDevolucionVenta) REFERENCES DEVOLUCION_VENTA(IdDevolucionVenta) ON DELETE CASCADE,
    FOREIGN KEY (IdInventario) REFERENCES INVENTARIO(idInventario) ON DELETE CASCADE
);