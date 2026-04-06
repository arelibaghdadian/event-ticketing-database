# 🎟️ Event Ticketing Database

SQL Server database for an Event Management and Ticketing System – group project.

---

## 📁 Files (run in order)

| File | Purpose |
|------|---------|
| `01_EventTicketing_Create.sql` | Creates all tables, keys, constraints |
| `02_EventTicketing_Insert_Data.sql` | Inserts realistic sample data (>40 records/table) |
| `03_EventTicketing_DQL_queries.sql` | 25+ SELECT queries (relational algebra equivalents) |
| `04_EventTicketing_Create_Views.sql` | Stores queries as views |
| `05_EventTicketing_Create_Indexes.sql` | Adds indexes for performance |
| `06_EventTicketing_Create_Triggers.sql` | Enforces business rules (overlaps, payments, etc.) |
| `07_EventTicketing_Stored_Procedures.sql` | Reusable logic (register, buy tickets, cancel, reports) |
| `08_EventTicketing_DCL_AccessControl.sql` | User permissions (attendee, organizer, admin) |

---

## 🚀 How to Deploy

1. Open **SQL Server Management Studio** (SQL Server 2022).
2. Run the files **in the order listed above**.
3. The database `EventTicketing` will be created and populated.

No additional setup required.

---

## 👥 Authors

- Areli Baghdadian  
- Nelli Hakobyan  

---

## 📌 Technologies

- Microsoft SQL Server 2022 (T‑SQL)
- Git & GitHub