using System;
using System.Data;
using Microsoft.Data.SqlClient;

namespace EventTicketingWPF
{
    public static class DbHelper
    {
        // Update with your connection string
        private static readonly string connectionString =
            "Server=localhost\\SQLEXPRESS;Database=EventTicketing;Integrated Security=True;TrustServerCertificate=True;";

        public static SqlConnection GetConnection()
        {
            var conn = new SqlConnection(connectionString);
            conn.Open();
            return conn;
        }

        public static int ExecuteNonQuery(string commandText, CommandType commandType, params SqlParameter[] parameters)
        {
            using (var conn = GetConnection())
            using (var cmd = new SqlCommand(commandText, conn))
            {
                cmd.CommandType = commandType;
                cmd.Parameters.AddRange(parameters);
                return cmd.ExecuteNonQuery();
            }
        }

        public static object ExecuteScalar(string commandText, CommandType commandType, params SqlParameter[] parameters)
        {
            using (var conn = GetConnection())
            using (var cmd = new SqlCommand(commandText, conn))
            {
                cmd.CommandType = commandType;
                cmd.Parameters.AddRange(parameters);
                return cmd.ExecuteScalar();
            }
        }

        public static DataTable ExecuteDataTable(string commandText, CommandType commandType, params SqlParameter[] parameters)
        {
            using (var conn = GetConnection())
            using (var cmd = new SqlCommand(commandText, conn))
            {
                cmd.CommandType = commandType;
                cmd.Parameters.AddRange(parameters);
                using (var adapter = new SqlDataAdapter(cmd))
                {
                    var dt = new DataTable();
                    adapter.Fill(dt);
                    return dt;
                }
            }
        }
    }
}