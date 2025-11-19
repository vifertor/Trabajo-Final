using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using WebApi.Model;
using Interface;

namespace Implementation
{
    public class ClienteService : IClienteService
    {
        private readonly string _connectionString;

        public ClienteService(IConfiguration configuration)
        {
            _connectionString = configuration.GetConnectionString("DefaultConnection");
        }

        public async Task AgregarCliente(Cliente cliente)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_CRUD_CLIENTE", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@Opcion", 1);
                command.Parameters.AddWithValue("@N_Cliente", cliente.N_Cliente);
                command.Parameters.AddWithValue("@A_Cliente", cliente.A_Cliente);
                command.Parameters.AddWithValue("@FechaRegistro", cliente.FechaRegistro);

                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task ActualizarCliente(Cliente cliente)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_CRUD_CLIENTE", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@Opcion", 2);
                command.Parameters.AddWithValue("@IdCliente", cliente.IdCliente);
                command.Parameters.AddWithValue("@N_Cliente", cliente.N_Cliente);
                command.Parameters.AddWithValue("@A_Cliente", cliente.A_Cliente);
                command.Parameters.AddWithValue("@FechaRegistro", cliente.FechaRegistro);

                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task EliminarCliente(int idCliente)
        {
            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_CRUD_CLIENTE", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@Opcion", 3);
                command.Parameters.AddWithValue("@IdCliente", idCliente);

                await command.ExecuteNonQueryAsync();
            }
        }

        public async Task<List<Cliente>> ListarClientes()
        {
            var clientes = new List<Cliente>();

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_CRUD_CLIENTE", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@Opcion", 4);

                using (var reader = await command.ExecuteReaderAsync())
                {
                    while (await reader.ReadAsync())
                    {
                        clientes.Add(new Cliente
                        {
                            IdCliente = (int)reader["IdCliente"],
                            N_Cliente = reader["N_Cliente"].ToString(),
                            A_Cliente = reader["A_Cliente"].ToString(),
                            FechaRegistro = Convert.ToDateTime(reader["FechaRegistro"])
                        });
                    }
                }
            }

            return clientes;
        }

        public async Task<Cliente> MostrarCliente(int idCliente)
        {
            Cliente cliente = null;

            using (SqlConnection connection = new SqlConnection(_connectionString))
            {
                await connection.OpenAsync();
                SqlCommand command = new SqlCommand("sp_CRUD_CLIENTE", connection)
                {
                    CommandType = System.Data.CommandType.StoredProcedure
                };
                command.Parameters.AddWithValue("@Opcion", 5);
                command.Parameters.AddWithValue("@IdCliente", idCliente);

                using (var reader = await command.ExecuteReaderAsync())
                {
                    if (await reader.ReadAsync())
                    {
                        cliente = new Cliente
                        {
                            IdCliente = (int)reader["IdCliente"],
                            N_Cliente = reader["N_Cliente"].ToString(),
                            A_Cliente = reader["A_Cliente"].ToString(),
                            FechaRegistro = Convert.ToDateTime(reader["FechaRegistro"])
                        };
                    }
                }
            }

            return cliente;
        }
    }
}
