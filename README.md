# Sports Betting Database

A relational database design for an **online sports betting platform**.  
It manages gamblers, accounts, matches, bets, and transactions, while providing optimized queries and views.  

📺 [Project Video](https://youtu.be/85W9haHjSCA)

---

## Features

- 👤 Gamblers can register, authenticate, and manage accounts.  
- ⚽ Matches & Competitions storage with results and teams.  
- 💸 Transactions for deposits, withdrawals, and slip placements.  
- 🧾 Betting Slips & History to track bets and outcomes.  
- 📊 Views & Queries for upcoming matches, past results, and gambler statistics.  

---

## Database Schema

Main entities:  
- **gambler** – personal data of users (age, name, phone).  
- **account** – linked to gamblers, stores credentials and balance.  
- **betting_slip** – slip with total odds.  
- **slip_history** – records placed betting slips.  
- **bet** – individual bets with odds.  
- **results** – match outcomes (1, X, 2).  
- **matches** – sporting events with home/away teams.  
- **competitions** – competitions where matches take place.  
- **teams** – participating teams.  
- **transactions** – deposits, withdrawals, slip placements.  
- **sports** – type of sport.  

📐 Junction tables:  
- `betting_slip_bets` (slips ↔ bets)  
- `match_record` (matches ↔ results ↔ competitions)  

---

## Views

- **betting_slip_info** – details about a betting slip.  
- **following_matches** – upcoming matches.  
- **past_results** – results with scores.  
- **history_of_betting** – betting history per gambler.  

Indexes are included for fast queries on accounts, slips, and transactions.  

---

## Example Queries

```sql
-- Show betting history for a gambler
SELECT *
FROM history_of_betting
WHERE gambler_id = X;

-- Upcoming matches for a specific team
SELECT *
FROM following_matches
WHERE home_team_id = 'X' OR away_team_id = 'X';

-- Top 10 highest earning gamblers
SELECT g.*, SUM(t.sum) AS total_earnings
FROM gambler g
JOIN account a ON g.id = a.gambler_id
JOIN transactions t ON a.id = t.account_id
WHERE t.type = 'deposit'
GROUP BY g.id
ORDER BY total_earnings DESC
LIMIT 10;
```

---

## Setup

1. Clone repository:
   ```bash
   git clone https://github.com/your-username/sports-betting-database.git
   cd sports-betting-database
   ```
2. Run schema in your DBMS (SQLite/Postgres/MySQL):
   ```sql
   .read schema.sql
   ```
3. Insert sample data from `queries.sql`.  
4. Explore the views and queries.  

---

## Limitations

- No real-time odds or external payment gateway integration.  
- No detailed player statistics.  
- Limited compliance handling.  

---

## Author

**Diaconescu Rares-Theodor**  

