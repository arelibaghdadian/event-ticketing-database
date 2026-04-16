using System;

namespace EventTicketingWPF
{
    public class User
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public string Role { get; set; }
        public DateTime RegistrationDate { get; set; }
        public int? AttendeeId { get; set; }
        public int? OrganizerId { get; set; }
    }

    // You can keep other model classes if needed, but the above is enough for MainWindow.
}