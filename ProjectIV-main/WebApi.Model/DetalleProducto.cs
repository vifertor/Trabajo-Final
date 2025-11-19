using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApi.Model
{
    [Table("DetalleProducto")]
    public class DetalleProducto
    {
        [Key]
        [Column("Id_DetalleProducto")]
        public int Id_DetalleProducto { get; set; }

        [Column("Id_Producto")]
        public int Id_Producto { get; set; }

        [Column("Marca_Id")]
        public int Marca_Id { get; set; }

        [Column("Id_Categoria")]
        public int Id_Categoria { get; set; }

        [Column("Id_Modelo")]
        public int Id_Modelo { get; set; }
        
        // ¡Eliminamos PrecioUnitario!
        
        [Column("Estado")]
        public bool Estado { get; set; }

        [Column("FechaRegistro")]
        public DateTime FechaRegistro { get; set; }
    }
}
