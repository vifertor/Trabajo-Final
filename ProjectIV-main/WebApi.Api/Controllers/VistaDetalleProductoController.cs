using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using Interface;
using WebApi.Model;

namespace WebApi.Api.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class VistaDetalleProductoController : ControllerBase
    {
        private readonly IVistaDetalleProductoService _vistaDetalleProductoService;

        public VistaDetalleProductoController(IVistaDetalleProductoService vistaDetalleProductoService)
        {
            _vistaDetalleProductoService = vistaDetalleProductoService;
        }

        [HttpGet]
        public ActionResult<List<VistaDetalleProducto>> Get()
        {
            var lista = _vistaDetalleProductoService.ListarVistaDetalleProducto();
            return Ok(lista);
        }
    }
}
