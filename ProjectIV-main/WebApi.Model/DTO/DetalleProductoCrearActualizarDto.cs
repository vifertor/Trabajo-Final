using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace WebApi.Model.DTO
{
    public class DetalleProductoCrearActualizarDto
    {
        
        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "El campo Id_Producto es obligatorio.")]
        public int IdProducto { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "El campo Marca_Id es obligatorio.")]
        public int MarcaId { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "El campo Id_Categoria es obligatorio.")]
        public int IdCategoria { get; set; }

        [Required]
        [Range(1, int.MaxValue, ErrorMessage = "El campo Id_Modelo es obligatorio.")]
        public int IdModelo { get; set; }

        public bool Estado { get; set; } = true; // Por defecto activo
    }
}