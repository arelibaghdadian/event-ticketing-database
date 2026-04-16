using System;
using System.Data;
using System.Windows;
using Microsoft.Data.SqlClient;

namespace EventTicketingWPF
{
    public partial class OrdersWindow : Window
    {
        private int attendeeId;

        public OrdersWindow(int attendeeId)
        {
            InitializeComponent();
            this.attendeeId = attendeeId;
            LoadOrders();
        }

        private void LoadOrders()
        {
            try
            {
                string query = @"
                    SELECT o.order_id, o.order_date, o.status_ as Status,
                           t.ticket_id, t.unique_code_ as TicketCode, e.title as Event,
                           e.start_date_time as EventStart, t.status_ as TicketStatus
                    FROM Orders o
                    JOIN OrderItem oi ON o.order_id = oi.order_id
                    JOIN Ticket t ON oi.order_item_id = t.order_item_id
                    JOIN TicketType tt ON oi.ticket_type_id = tt.ticket_type_id
                    JOIN Event e ON tt.event_id = e.event_id
                    WHERE o.attendee_id = @attendeeId
                    ORDER BY o.order_date DESC, t.ticket_id";
                var param = new SqlParameter("@attendeeId", attendeeId);
                DataTable dt = DbHelper.ExecuteDataTable(query, CommandType.Text, param);
                OrdersDataGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading orders: {ex.Message}");
            }
        }
    }
}