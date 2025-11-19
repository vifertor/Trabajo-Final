CREATE TABLE Inventario (
    idInventario INT PRIMARY KEY IDENTITY(1,1),
    IdDetalleProducto INT NOT NULL,
    Movimiento_Id INT NOT NULL,
    stonk int,
    -- Relaciones con claves foráneas
    FOREIGN KEY (IdDetalleProducto) REFERENCES DetalleProducto(IdDetalleProducto),
    FOREIGN KEY (Movimiento_Id) REFERENCES MovimientoInterno(Movimiento_Id)
);


