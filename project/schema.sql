CREATE TABLE gambler (
    id INTEGER PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    age INTEGER NOT NULL CHECK(age >= 18),
    address TEXT NOT NULL CHECK(LENGTH(address) <= 255),
    date_of_birth DATE NOT NULL,
    phone_number TEXT NOT NULL
);

CREATE TABLE account (
    id INTEGER PRIMARY KEY,
    gambler_id INTEGER REFERENCES gambler(id),
    balance REAL DEFAULT 0 CHECK(balance >= 0),
    username TEXT NOT NULL UNIQUE,
    password TEXT NOT NULL CHECK(LENGTH(password) >= 8)
);

CREATE TABLE betting_slip (
    id INTEGER PRIMARY KEY,
    series TEXT NOT NULL UNIQUE,
    total_odd REAL CHECK(total_odd > 1)
);

CREATE TABLE slip_history (
    id INTEGER PRIMARY KEY,
    account_id INTEGER REFERENCES account(id),
    betting_slip_id INTEGER REFERENCES betting_slip(id),
    stake REAL NOT NULL CHECK(stake > 0),
    date_placed DATETIME DEFAULT CURRENT_TIMESTAMP,
    active_status INTEGER CHECK(active_status IN (0, 1)),
    win_status INTEGER CHECK(win_status IN (NULL, 0, 1))
);

CREATE TABLE bet (
    id INTEGER PRIMARY KEY,
    result_id INTEGER REFERENCES results(id),
    odd REAL NOT NULL CHECK(odd > 1),
    type TEXT NOT NULL,
    win_status INTEGER CHECK(win_status IN (NULL,0,1))
);

CREATE TABLE betting_slip_bets(
    id INTEGER PRIMARY KEY,
    betting_slip_id INTEGER REFERENCES betting_slip(id),
    bet_id INTEGER REFERENCES bet(id)
);

CREATE TABLE results (
    id INTEGER PRIMARY KEY,
    winner TEXT NOT NULL CHECK(winner IN ('1','X','2')),
    score TEXT NOT NULL CHECK(score LIKE '_-_')
);

CREATE TABLE matches (
    id INTEGER PRIMARY KEY,
    date DATE,
	sport_id TEXT REFERENCES sports(id),
	home_team_id INTEGER REFERENCES teams(id),
	away_team_id INTEGER REFERENCES teams(id)
);

CREATE TABLE competitions (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    year TEXT NOT NULL CHECK(LENGTH(year) = 4),
    country TEXT NOT NULL CHECK(LENGTH(country) <= 255),
    sport_id INTEGER REFERENCES sports(id),
    type TEXT CHECK(type IN ('Internationalities','Interclubs'))
);

CREATE TABLE match_record (
	id INTEGER PRIMARY KEY,
    competition_id INTEGER REFERENCES competitions(id),
	match_id INTEGER REFERENCES matches(id),
	result_id INTEGER REFERENCES results(id)
);


CREATE TABLE teams (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    country TEXT NOT NULL CHECK(LENGTH(country) <= 255),
    sport_id INTEGER REFERENCES sports(id)
);


CREATE TABLE transactions (
    id INTEGER PRIMARY KEY,
    account_id INTEGER NOT NULL REFERENCES account(id),
    sum REAL NOT NULL CHECK(sum > 0),
    type TEXT NOT NULL CHECK(type IN ('deposit','withdraw','placing_slip')),
    date_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sports (
	id INTEGER PRIMARY KEY,
	name TEXT NOT NULL UNIQUE
);

-- V1: This view contains all the important information about a betting slip:
CREATE VIEW betting_slip_info AS
SELECT
    bs.total_odd,
    s.name,
    c.name AS competition_name,
    t1.name AS home_team_name,
    t2.name AS away_team_name,
    b.type AS bet_type
FROM
    betting_slip bs
JOIN
    betting_slip_bets sb ON bs.id = sb.betting_slip_id
JOIN
    bet b ON sb.bet_id = b.id
JOIN
    match_record mr ON m.id = mr.match_id
JOIN
    competitions c ON mr.competition_id = c.id
JOIN
    teams t1 ON t1.id = m.home_team_id
JOIN
    teams t2 ON t2.id = m.away_team_id
JOIN
    sports s ON s.id = t1.sport_id
JOIN
    matches m on m.id = mr.match_id
GROUP BY
    bs.total_odd, s.name, c.name, t1.name, t2.name;

-- V2: A view that contains all the matches that are planned:
CREATE VIEW following_matches AS
SELECT
    s.name AS sport,
    c.name AS competition_name,
    t1.name AS home_team_name,
    t2.name AS away_team_name
FROM
    match_record mr
JOIN
    competitions c ON mr.competition_id = c.id
JOIN
    teams t1 ON t1.id = m.home_team_id
JOIN
    teams t2 ON t2.id = m.away_team_id
JOIN
    sports s ON s.id = c.sport_id
JOIN
    matches m on m.id=mr.id;

-- V3: A view that contains all the results with score:
CREATE VIEW past_results AS
SELECT
    c.name AS competition_name,
    t1.name AS home_team_name,
    t2.name AS away_team_name,
    r.winner AS result,
    r.score AS match_score
FROM
    match_record mr
JOIN
    competitions c ON mr.competition_id = c.id
JOIN
    teams t1 ON t1.id = m.home_team_id
JOIN
    teams t2 ON t2.id = m.away_team_id
JOIN
    results r ON mr.result_id = r.id
JOIN
    matches m on m.id=mr.id;

-- V4: A view that contains the history of betting:
CREATE VIEW history_of_betting AS
SELECT
    sh.date_placed,
    sh.active_status,
    sh.win_status,
    sh.stake,
    bs.total_odd
FROM
    slip_history sh
JOIN
    betting_slip bs ON sh.betting_slip_id = bs.id;


-- Index for betting_slip table:
CREATE INDEX idx_betting_slip_series ON betting_slip (series);

-- Index for active betting slips:
CREATE INDEX idx_active_betting_slips_account_id ON slip_history (account_id, active_status);

-- Indexes for transactions table:
CREATE INDEX idx_transactions_date_time ON transactions (date_time);
CREATE INDEX idx_transactions_account_id ON transactions (account_id);

-- Index for account table:
CREATE INDEX idx_account_gambler_id ON account (gambler_id);
