
---

## 🎯 Objectives & Insights
This project answers important business questions such as:

- Categorizing restaurants based on ratings (Excellent / Good / Average / Bad)
- Identifying top restaurant areas with highest ratings
- Displaying cuisine trends and restaurant types
- Creating views for top restaurants
- Automatically logging messages when new records are inserted (Trigger)
- Updating and rolling back data safely (Transactions)
- Generating customized restaurant names using functions

---

## 🛠 SQL Concepts Used
| Concept | Usage |
|---------|-------|
| User-Defined Functions | Create customized values |
| Stored Procedures | Reusable logic |
| Views | Store top results |
| Triggers | Message after insert |
| Window Functions | Ranking & ordering |
| Transactions | Update + rollback |
| CASE statements | Rating classification |

---

## 🧾 Sample Business Insights (Queries Included)

- Top 5 highest-rated restaurant areas  
- Rating status for each restaurant using `CASE`
- Restaurant type total cost analysis using `ROLLUP`
- Auto-message after insert using `TRIGGER`
- Row numbering to find best performing locations
- View storing top-rated restaurants for reporting

> Full SQL script available in **`case_study_queries.sql`**

---

## 🚀 How to Run
1. Install **SQL Server** or **SSMS**
2. Create a database:
```sql
CREATE DATABASE ZomatoDB;
USE ZomatoDB;
