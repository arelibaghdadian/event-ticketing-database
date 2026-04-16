using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Windows;
using System.Windows.Controls;
using Microsoft.Data.SqlClient;

namespace EventTicketingWPF
{
    public partial class MainWindow : Window
    {
        // ========== Fields ==========
        private User currentUser = null;
        private int selectedEventId = 0;
        private DataTable currentTicketTypes = null;

        // ========== Constructor ==========
        public MainWindow()
        {
            InitializeComponent();
        }

        // ========== Helper Methods ==========
        private void ShowPanel(string panelName)
        {
            LoginPanel.Visibility = panelName == "Login" ? Visibility.Visible : Visibility.Collapsed;
            RegisterPanel.Visibility = panelName == "Register" ? Visibility.Visible : Visibility.Collapsed;
            AttendeePanel.Visibility = panelName == "Attendee" ? Visibility.Visible : Visibility.Collapsed;
            OrganizerPanel.Visibility = panelName == "Organizer" ? Visibility.Visible : Visibility.Collapsed;
            AdminPanel.Visibility = panelName == "Admin" ? Visibility.Visible : Visibility.Collapsed;
        }

        // ========== Login & Register ==========
        private void Login_Click(object sender, RoutedEventArgs e)
        {
            string email = LoginEmail.Text.Trim();
            string password = LoginPassword.Password;

            try
            {
                using (var conn = DbHelper.GetConnection())
                using (var cmd = new SqlCommand("usp_Login", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@email", email);
                    cmd.Parameters.AddWithValue("@password", password);

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            currentUser = new User
                            {
                                UserId = reader.GetInt32(0),
                                FirstName = reader.GetString(1),
                                LastName = reader.GetString(2),
                                Email = reader.GetString(3),
                                Role = reader.GetString(4),
                                RegistrationDate = reader.GetDateTime(5),
                                AttendeeId = reader.IsDBNull(6) ? (int?)null : reader.GetInt32(6),
                                OrganizerId = reader.IsDBNull(7) ? (int?)null : reader.GetInt32(7)
                            };

                            switch (currentUser.Role)
                            {
                                case "attendee":
                                    ShowPanel("Attendee");
                                    AttendeeName.Text = $"{currentUser.FirstName} {currentUser.LastName}";
                                    LoadAttendeeEvents();
                                    break;
                                case "organizer":
                                    ShowPanel("Organizer");
                                    OrganizerName.Text = $"{currentUser.FirstName} {currentUser.LastName}";
                                    LoadOrganizerEvents();
                                    break;
                                case "admin":
                                    ShowPanel("Admin");
                                    break;
                                default:
                                    MessageBox.Show("Unknown role.");
                                    break;
                            }
                        }
                        else
                        {
                            LoginError.Text = "Invalid email or password.";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                LoginError.Text = ex.Message;
            }
        }

        private void GoToRegister_Click(object sender, RoutedEventArgs e)
        {
            ShowPanel("Register");
        }

        private void BackToLogin_Click(object sender, RoutedEventArgs e)
        {
            ShowPanel("Login");
            ClearRegisterFields();
        }

        private void Register_Click(object sender, RoutedEventArgs e)
        {
            string firstName = RegFirstName.Text.Trim();
            string lastName = RegLastName.Text.Trim();
            string email = RegEmail.Text.Trim();
            string password = RegPassword.Password;
            string role = ((ComboBoxItem)RegRole.SelectedItem).Content.ToString();

            try
            {
                var parameters = new[]
                {
                    new SqlParameter("@first_name", firstName),
                    new SqlParameter("@last_name", lastName),
                    new SqlParameter("@email", email),
                    new SqlParameter("@password_hash", password),
                    new SqlParameter("@role", role),
                    new SqlParameter("@phone", DBNull.Value),
                    new SqlParameter("@address", DBNull.Value)
                };
                DbHelper.ExecuteNonQuery("usp_RegisterUser", CommandType.StoredProcedure, parameters);
                MessageBox.Show("Registration successful! Please login.");
                ShowPanel("Login");
                ClearRegisterFields();
            }
            catch (SqlException ex) when (ex.Number == 2627)
            {
                RegError.Text = "Email already registered.";
            }
            catch (Exception ex)
            {
                RegError.Text = ex.Message;
            }
        }

        private void ClearRegisterFields()
        {
            RegFirstName.Text = "";
            RegLastName.Text = "";
            RegEmail.Text = "";
            RegPassword.Password = "";
            RegRole.SelectedIndex = 0;
            RegError.Text = "";
        }

        // ========== Logout ==========
        private void Logout_Click(object sender, RoutedEventArgs e)
        {
            currentUser = null;
            ShowPanel("Login");
            LoginEmail.Text = "";
            LoginPassword.Password = "";
            LoginError.Text = "";
        }

        // ========== Attendee Methods ==========
        private void LoadAttendeeEvents()
        {
            try
            {
                DataTable dt = DbHelper.ExecuteDataTable("usp_BrowseEvents", CommandType.StoredProcedure);
                EventsGrid.ItemsSource = dt.DefaultView;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading events: {ex.Message}");
            }
        }

        private void BrowseEvents_Click(object sender, RoutedEventArgs e)
        {
            LoadAttendeeEvents();
        }

        private void EventsGrid_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (EventsGrid.SelectedItem != null)
            {
                DataRowView row = (DataRowView)EventsGrid.SelectedItem;
                selectedEventId = Convert.ToInt32(row["event_id"]);
                LoadTicketTypesForEvent(selectedEventId);
            }
            else
            {
                TicketTypesPanel.Visibility = Visibility.Collapsed;
            }
        }

        private void LoadTicketTypesForEvent(int eventId)
        {
            try
            {
                var param = new SqlParameter("@event_id", eventId);
                currentTicketTypes = DbHelper.ExecuteDataTable("usp_GetAvailableTickets", CommandType.StoredProcedure, param);
                if (currentTicketTypes.Rows.Count == 0)
                {
                    TicketTypesPanel.Visibility = Visibility.Collapsed;
                    MessageBox.Show("No ticket types available for this event.", "Information", MessageBoxButton.OK, MessageBoxImage.Information);
                    return;
                }

                // Populate ListBox with a friendly display
                var items = new List<TicketTypeDisplay>();
                foreach (DataRow row in currentTicketTypes.Rows)
                {
                    items.Add(new TicketTypeDisplay
                    {
                        TicketTypeId = Convert.ToInt32(row["ticket_type_id"]),
                        DisplayText = $"{row["name"]} - ${row["price"]:F2} ({row["available_quantity"]} available)"
                    });
                }
                TicketTypesListBox.ItemsSource = items;
                TicketTypesListBox.SelectedValuePath = "TicketTypeId";
                TicketTypesListBox.DisplayMemberPath = "DisplayText";
                TicketTypesPanel.Visibility = Visibility.Visible;
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error loading ticket types: {ex.Message}");
                TicketTypesPanel.Visibility = Visibility.Collapsed;
            }
        }

        private void PurchaseSelectedTickets_Click(object sender, RoutedEventArgs e)
        {
            if (TicketTypesListBox.SelectedItem == null)
            {
                MessageBox.Show("Please select a ticket type.");
                return;
            }
            int ticketTypeId = (int)TicketTypesListBox.SelectedValue;
            if (!int.TryParse(QuantityBox.Text, out int quantity) || quantity <= 0)
            {
                MessageBox.Show("Please enter a valid quantity (positive integer).");
                return;
            }

            var items = new List<(int ticketTypeId, int quantity)>();
            items.Add((ticketTypeId, quantity));

            string paymentMethod = Microsoft.VisualBasic.Interaction.InputBox("Payment Method (CreditCard/PayPal):", "Payment", "CreditCard");
            if (string.IsNullOrEmpty(paymentMethod)) return;

            try
            {
                DataTable itemsTable = new DataTable();
                itemsTable.Columns.Add("ticket_type_id", typeof(int));
                itemsTable.Columns.Add("quantity", typeof(int));
                foreach (var item in items)
                    itemsTable.Rows.Add(item.ticketTypeId, item.quantity);

                using (var conn = DbHelper.GetConnection())
                using (var cmd = new SqlCommand("usp_PurchaseTickets", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@attendee_id", currentUser.AttendeeId);
                    cmd.Parameters.AddWithValue("@items", itemsTable);
                    cmd.Parameters.AddWithValue("@payment_method", paymentMethod);

                    using (var reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            int orderId = reader.GetInt32(0);
                            decimal total = reader.GetDecimal(1);
                            MessageBox.Show($"Purchase successful!\nOrder ID: {orderId}\nTotal: ${total:F2}", "Success", MessageBoxButton.OK, MessageBoxImage.Information);
                            // Refresh ticket availability
                            LoadTicketTypesForEvent(selectedEventId);
                        }
                        else
                        {
                            MessageBox.Show("Purchase failed: No response from server.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Purchase failed: {ex.Message}", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
            }
        }

        private void ViewOrders_Click(object sender, RoutedEventArgs e)
        {
            if (currentUser.AttendeeId == null)
            {
                MessageBox.Show("You are not registered as an attendee.");
                return;
            }
            var ordersWindow = new OrdersWindow(currentUser.AttendeeId.Value);
            ordersWindow.Owner = this;
            ordersWindow.ShowDialog();
        }

        private void CancelOrder_Click(object sender, RoutedEventArgs e)
        {
            string input = Microsoft.VisualBasic.Interaction.InputBox("Enter Order ID to cancel:", "Cancel Order", "");
            if (int.TryParse(input, out int orderId))
            {
                try
                {
                    var param = new SqlParameter("@order_id", orderId);
                    DbHelper.ExecuteNonQuery("usp_CancelOrder", CommandType.StoredProcedure, param);
                    MessageBox.Show("Order cancelled successfully.");
                }
                catch (Exception ex)
                {
                    MessageBox.Show($"Cancellation failed: {ex.Message}");
                }
            }
            else
            {
                MessageBox.Show("Invalid Order ID.");
            }
        }

        // ========== Organizer Methods ==========
        private void LoadOrganizerEvents()
        {
            if (currentUser.UserId == 0) return;
            string query = @"
                SELECT e.event_id, e.title, e.start_date_time, e.status, v.name as venue
                FROM Event e
                JOIN Venue v ON e.venue_id = v.venue_id
                WHERE e.organizer_id = @orgId
                ORDER BY e.start_date_time DESC";
            var param = new SqlParameter("@orgId", currentUser.UserId);
            DataTable dt = DbHelper.ExecuteDataTable(query, CommandType.Text, param);
            OrganizerEventsGrid.ItemsSource = dt.DefaultView;
        }

        private void MyEvents_Click(object sender, RoutedEventArgs e)
        {
            LoadOrganizerEvents();
        }

        private void CreateEvent_Click(object sender, RoutedEventArgs e)
        {
            // Simplified creation dialog – you can expand as needed
            string title = Microsoft.VisualBasic.Interaction.InputBox("Title:", "Create Event", "");
            if (string.IsNullOrEmpty(title)) return;
            string desc = Microsoft.VisualBasic.Interaction.InputBox("Description:", "Create Event", "");
            string startStr = Microsoft.VisualBasic.Interaction.InputBox("Start (yyyy-mm-dd HH:MM):", "Create Event", "");
            if (!DateTime.TryParse(startStr, out DateTime start)) return;
            string endStr = Microsoft.VisualBasic.Interaction.InputBox("End (yyyy-mm-dd HH:MM):", "Create Event", "");
            if (!DateTime.TryParse(endStr, out DateTime end)) return;
            string category = Microsoft.VisualBasic.Interaction.InputBox("Category:", "Create Event", "");
            string venueIdStr = Microsoft.VisualBasic.Interaction.InputBox("Venue ID:", "Create Event", "");
            if (!int.TryParse(venueIdStr, out int venueId)) return;

            // Collect ticket types
            var ticketTypes = new List<(string name, decimal price, int quantityTotal, string description, DateTime? salesStart, DateTime? salesEnd)>();
            while (true)
            {
                string ttName = Microsoft.VisualBasic.Interaction.InputBox("Ticket Type Name (empty to finish):", "Add Ticket Type", "");
                if (string.IsNullOrEmpty(ttName)) break;
                string priceStr = Microsoft.VisualBasic.Interaction.InputBox("Price:", "Add Ticket Type", "");
                if (!decimal.TryParse(priceStr, out decimal price)) continue;
                string qtyStr = Microsoft.VisualBasic.Interaction.InputBox("Total Quantity:", "Add Ticket Type", "");
                if (!int.TryParse(qtyStr, out int qty)) continue;
                string ttDesc = Microsoft.VisualBasic.Interaction.InputBox("Description (optional):", "Add Ticket Type", "");
                string startDateStr = Microsoft.VisualBasic.Interaction.InputBox("Sales Start Date (yyyy-mm-dd, optional):", "Add Ticket Type", "");
                DateTime? salesStart = string.IsNullOrEmpty(startDateStr) ? (DateTime?)null : DateTime.Parse(startDateStr);
                string endDateStr = Microsoft.VisualBasic.Interaction.InputBox("Sales End Date (yyyy-mm-dd, optional):", "Add Ticket Type", "");
                DateTime? salesEnd = string.IsNullOrEmpty(endDateStr) ? (DateTime?)null : DateTime.Parse(endDateStr);
                ticketTypes.Add((ttName, price, qty, ttDesc ?? "", salesStart, salesEnd));
            }
            if (ticketTypes.Count == 0)
            {
                MessageBox.Show("At least one ticket type required.");
                return;
            }

            DataTable ttTable = new DataTable();
            ttTable.Columns.Add("name", typeof(string));
            ttTable.Columns.Add("price", typeof(decimal));
            ttTable.Columns.Add("quantity_total_", typeof(int));
            ttTable.Columns.Add("description", typeof(string));
            ttTable.Columns.Add("sales_start_date", typeof(DateTime));
            ttTable.Columns.Add("sales_end_date", typeof(DateTime));

            foreach (var tt in ticketTypes)
            {
                ttTable.Rows.Add(tt.name, tt.price, tt.quantityTotal, tt.description,
                    tt.salesStart.HasValue ? (object)tt.salesStart.Value : DBNull.Value,
                    tt.salesEnd.HasValue ? (object)tt.salesEnd.Value : DBNull.Value);
            }

            try
            {
                var parameters = new[]
                {
                    new SqlParameter("@title", title),
                    new SqlParameter("@description", desc),
                    new SqlParameter("@start_date_time", start),
                    new SqlParameter("@end_date_time", end),
                    new SqlParameter("@category", category),
                    new SqlParameter("@organizer_id", currentUser.UserId),
                    new SqlParameter("@venue_id", venueId),
                    new SqlParameter("@ticket_types", ttTable) { SqlDbType = SqlDbType.Structured, TypeName = "dbo.TicketTypeTableType" }
                };
                DbHelper.ExecuteNonQuery("usp_CreateEvent", CommandType.StoredProcedure, parameters);
                MessageBox.Show("Event created successfully!");
                LoadOrganizerEvents();
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Error: {ex.Message}");
            }
        }

        private void SalesReport_Click(object sender, RoutedEventArgs e)
        {
            string startInput = Microsoft.VisualBasic.Interaction.InputBox("Start date (yyyy-mm-dd) or empty:", "Sales Report", "");
            DateTime? startDate = string.IsNullOrEmpty(startInput) ? (DateTime?)null : DateTime.Parse(startInput);
            string endInput = Microsoft.VisualBasic.Interaction.InputBox("End date (yyyy-mm-dd) or empty:", "Sales Report", "");
            DateTime? endDate = string.IsNullOrEmpty(endInput) ? (DateTime?)null : DateTime.Parse(endInput);

            var parameters = new[]
            {
                new SqlParameter("@organizer_id", currentUser.UserId),
                new SqlParameter("@start_date", startDate ?? (object)DBNull.Value),
                new SqlParameter("@end_date", endDate ?? (object)DBNull.Value)
            };
            DataTable dt = DbHelper.ExecuteDataTable("usp_GenerateOrganizerReport", CommandType.StoredProcedure, parameters);
            if (dt.Rows.Count == 0)
            {
                MessageBox.Show("No sales data found.");
            }
            else
            {
                string report = "Sales Report:\n\n";
                foreach (DataRow row in dt.Rows)
                {
                    report += $"{row["title"]}\t{row["tickets_sold"]}\t${row["total_revenue"]:F2}\n";
                }
                MessageBox.Show(report, "Sales Report");
            }
        }

        private void CheckIn_Click(object sender, RoutedEventArgs e)
        {
            string code = Microsoft.VisualBasic.Interaction.InputBox("Scan Ticket QR Code:", "Check-in", "");
            if (string.IsNullOrEmpty(code)) return;
            var param = new SqlParameter("@unique_code", code);
            try
            {
                DbHelper.ExecuteNonQuery("usp_CheckInTicket", CommandType.StoredProcedure, param);
                MessageBox.Show("Check-in successful.");
            }
            catch (Exception ex)
            {
                MessageBox.Show($"Check-in failed: {ex.Message}");
            }
        }

        // ========== Admin Methods ==========
        private void ManageUsers_Click(object sender, RoutedEventArgs e)
        {
            DataTable dt = DbHelper.ExecuteDataTable("SELECT user_id, first_name, last_name, email, role FROM [User]", CommandType.Text);
            AdminDataGrid.ItemsSource = dt.DefaultView;
        }

        private void AdminAllEvents_Click(object sender, RoutedEventArgs e)
        {
            string query = @"
                SELECT e.event_id, e.title, e.start_date_time, v.name as venue
                FROM Event e
                JOIN Venue v ON e.venue_id = v.venue_id
                ORDER BY e.start_date_time DESC";
            DataTable dt = DbHelper.ExecuteDataTable(query, CommandType.Text);
            AdminDataGrid.ItemsSource = dt.DefaultView;
        }

        private void SystemReports_Click(object sender, RoutedEventArgs e)
        {
            object result = DbHelper.ExecuteScalar("SELECT SUM(amount) FROM Payment WHERE status = 'success'", CommandType.Text);
            MessageBox.Show($"Total Revenue from successful payments: ${result ?? 0:F2}", "System Report");
        }
    }

    // ========== Helper class for ListBox items ==========
    public class TicketTypeDisplay
    {
        public int TicketTypeId { get; set; }
        public string DisplayText { get; set; }
    }
}