-- SELECT Queries

-- Get information about a specific betting slip:
SELECT *
FROM betting_slip_info
WHERE slip_id = X;

-- Show upcoming matches for a specific team:
SELECT *
FROM following_matches m
WHERE home_team_id = 'X' OR away_team_id = 'X';

-- Show matches for a particular sport and date:
SELECT *
FROM following_matches m
WHERE m.date = 'tomorrow'
AND m.sport_id = 'X';

-- Show upcoming matches for a certain competition:
SELECT *
FROM following_matches m
WHERE m.competition_id = X;

-- Show past results for a specific team:
SELECT *
FROM past_results
WHERE home_team_id = 'X' OR away_team_id = 'X';

-- Show past match results for a sport and date:
SELECT *
FROM past_results pr
WHERE pr.date = 'yesterday'
AND pr.sport_id = 'X';

-- Show past match results for a specific competition:
SELECT *
FROM past_results pr
WHERE pr.competition_id = 'X';

-- Show betting history for a specific gambler:
SELECT *
FROM history_of_betting
WHERE gambler_id = X;

-- Show active betting slips for a specific gambler:
SELECT bs.*
FROM betting_slip bs
JOIN slip_history sh ON bs.id = sh.betting_slip_id
WHERE sh.active_status = 1 AND sh.account_id = X;

-- Show match scores for a sport:
SELECT m.*, r.winner, r.score
FROM matches m
JOIN match_record mr ON m.id = mr.match_id
JOIN results r ON mr.result_id = r.id
WHERE m.sport_id = 'X';

-- Show account balance for a specific gambler:
SELECT balance
FROM account
WHERE gambler_id = X;

-- Show top 10 highest earning gamblers:
SELECT g.*, SUM(t.sum) AS total_earnings
FROM gambler g
JOIN account a ON g.id = a.gambler_id
JOIN transactions t ON a.id = t.account_id
WHERE t.type = 'deposit'
GROUP BY g.id
ORDER BY total_earnings DESC
LIMIT 10;

-- Show transactions within a specific date range:
SELECT *
FROM transactions
WHERE date_time BETWEEN 'start_date' AND 'end_date';

-- INSERT Queries

-- Insert a betting slip:
INSERT INTO betting_slip (series, total_odd)
VALUES ('ABC123', 2.5);

-- Insert a deposit transaction:
INSERT INTO transactions (account_id, sum, type)
VALUES (1, 50.00, 'deposit');

-- Register a new gambler:
INSERT INTO gambler (first_name, last_name, age, address, date_of_birth, phone_number)
VALUES ('John', 'Doe', 25, '123 Main St', '1999-05-20', '+1234567890');

-- Insert multiple bets into a betting slip:
INSERT INTO betting_slip_bets (betting_slip_id, bet_id)
VALUES
    (1, 101),  -- Bet ID 101
    (1, 102),  -- Bet ID 102
    (1, 103);  -- Bet ID 103

-- Insert a betting slip into slip history:
INSERT INTO slip_history (account_id, betting_slip_id, stake, date_placed, active_status, win_status)
VALUES
    (1, 1, 50.0, '2024-02-25 08:30:00', 1, NULL);

-- DELETE Queries

-- Delete a specific betting slip:
DELETE FROM betting_slip
WHERE id = X;

-- Delete all bets associated with a betting slip:
DELETE FROM betting_slip_bets
WHERE betting_slip_id = X;

-- Cancel a placed betting slip:
DELETE FROM slip_history
WHERE betting_slip_id = X
AND active_status = 1;

-- Cancel a specific transaction:
DELETE FROM transactions
WHERE id = Y
AND account_id = X;

-- Withdraw funds from account:
DELETE FROM transactions
WHERE account_id = X
AND type = 'withdraw'
AND sum = Y;

-- UPDATE Queries

-- Update account information:
UPDATE account
SET address = 'New Address', phone_number = 'New Phone Number'
WHERE gambler_id = X;

-- Update betting slip stake:
UPDATE slip_history
SET stake = Y
WHERE betting_slip_id = X
AND active_status = 1;

-- Update password:
UPDATE account
SET password = 'New Password'
WHERE gambler_id = X;

-- Mark betting slip as inactive:
UPDATE slip_history
SET active_status = 0
WHERE betting_slip_id = X
AND active_status = 1;
