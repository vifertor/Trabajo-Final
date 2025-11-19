namespace WebApi.Models.ETL
{
    public class DimTiempo
    {
        public DateTime Fecha { get; set; }
        public int Año { get; set; }
        public int Mes { get; set; }
        public int Día { get; set; }
        public string Trimestre { get; set; }
    }
}
