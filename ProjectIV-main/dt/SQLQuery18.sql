USE [Cellshopcenter112024]
GO

/****** Object:  Table [dbo].[Inventario]    Script Date: 2/12/2024 18:03:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Inventario](
	[idInventario] [int] IDENTITY(1,1) NOT NULL,
	[IdDetalleProducto] [int] NOT NULL,
	[Movimiento_Id] [int] NOT NULL,
	[stonk] [varchar](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[idInventario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Inventario]  WITH CHECK ADD FOREIGN KEY([IdDetalleProducto])
REFERENCES [dbo].[DetalleProducto] ([IdDetalleProducto])
GO

ALTER TABLE [dbo].[Inventario]  WITH CHECK ADD FOREIGN KEY([Movimiento_Id])
REFERENCES [dbo].[MovimientoInterno] ([Movimiento_Id])
GO


