using WebApi.Api;
using WebApi.Model;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;
using Microsoft.OpenApi.Models;

using Interface;
using Implementation;
using WebApi.Services.Interface;
using WebApi.Services.Implementation;
using WebApi.Api.Services;
using Microsoft.Extensions.Diagnostics.HealthChecks; 
using WebApi.ETL.Interface;
using WebApi.ETL.Implementation;
using WebApi.Api.Middleware;
using MongoDB.Driver;
using WebApi.Services;

var builder = WebApplication.CreateBuilder(args);

builder.Configuration.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);

builder.Services.AddScoped<IUsuarioService, UsuarioService>();
builder.Services.AddScoped<IProductoService, ProductoService>();
builder.Services.AddScoped<IDetalleProductoService, DetalleProductoService>();
builder.Services.AddScoped<IVistaDetalleProductoService, VistaDetalleProductoService>();
builder.Services.AddScoped<ICompraService, CompraService>();

builder.Services.AddScoped<IRolService, RolService>();
builder.Services.AddScoped<IModeloService, ModeloService>();
builder.Services.AddScoped<IProductoService, ProductoService>();
builder.Services.AddScoped<ICategoriaService, CategoriaService>();
builder.Services.AddScoped<IProductoService, ProductoService>();
builder.Services.AddScoped<IMarcaService, MarcaService>();

builder.Services.AddScoped<IProveedorService, ProveedorService>();
builder.Services.AddScoped<IClienteService, ClienteService>();
builder.Services.AddScoped<IVentaService, VentaService>();
builder.Services.AddScoped<IEmpleadoService, EmpleadoService>();

builder.Services.AddScoped<IUsuarioService, UsuarioService>();
builder.Services.AddScoped<IInventarioService, InventarioService>();
builder.Services.AddScoped<IDetalleProductoService, DetalleProductoService>();

// ETL Services
builder.Services.AddSingleton<ETLClienteService>();
builder.Services.AddScoped<ETLProductoService>();
builder.Services.AddScoped<ETLEmpleadoService>();
builder.Services.AddScoped<ETLTiempoService>();
builder.Services.AddScoped<ETLVentasService>();
builder.Services.AddScoped<ETLMasterService>();

// Servicio Token Usage
builder.Services.AddScoped<ITokenUsageService, TokenUsageService>();

// ⬅️ AGREGADO: Servicio de usuarios activos
builder.Services.AddScoped<IUserActivityService, UserActivityService>();

// JWT
builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.ASCII.GetBytes(builder.Configuration["Jwt:Key"])),
            ValidateIssuer = false,
            ValidateAudience = false
        };
    });

builder.Services.AddAuthorization();
builder.Services.AddControllers();

// CORS
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.WithOrigins("http://localhost")
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials();
    });

    options.AddPolicy("AllowAll", policy =>
    {
        policy.AllowAnyOrigin()
              .AllowAnyHeader()
              .AllowAnyMethod();
    });
});

// Swagger
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo { Title = "Sistema_cellshopcenter", Version = "v1" });
    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
    });
    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            Array.Empty<string>()
        }
    });
});

// Health Check
builder.Services.AddHealthChecks()
    .AddCheck<MemoryHealthCheck>("memory_check");

// MongoDB
builder.Services.Configure<MongoDbSettings>(builder.Configuration.GetSection("MongoDbSettings"));
builder.Services.AddScoped<IMemoryMetricsRepository, MemoryMetricsRepository>();

builder.Services.Configure<MemoryMetricsSettings>(
    builder.Configuration.GetSection("MemoryMetrics"));

builder.Services.AddHostedService<MemoryMetricsService>();

// Registro de tiempos de respuesta
builder.Services.AddSingleton<IResponseTimeLogRepository, MongoResponseTimeLogRepository>();

// Cliente Mongo
var mongoSettings = builder.Configuration.GetSection("MongoDbSettings");
var mongoConnectionString = mongoSettings.GetValue<string>("ConnectionString");

builder.Services.AddSingleton<IMongoClient>(_ => new MongoClient(mongoConnectionString));

// Métricas BD
builder.Services.AddSingleton<DatabaseMetricsService>();

// Métricas CPU
builder.Services.AddSingleton<ISystemMetricsService, SystemMetricsService>();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors(policy => policy
    .AllowAnyOrigin()
    .AllowAnyMethod()
    .AllowAnyHeader()
);

app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

// Middleware de tiempos de respuesta
app.UseResponseTimeMiddleware();

// ⬅️ AGREGADO: Middleware de actividad de usuario
app.UseUserActivityMiddleware();

app.UseCors("AllowFrontend");

app.MapControllers();

// Health
app.MapHealthChecks("/health");

app.UseSwagger();
app.UseSwaggerUI();

app.Run();
