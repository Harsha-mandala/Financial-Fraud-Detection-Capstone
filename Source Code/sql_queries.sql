-- ================================================================
--  FINANCIAL FRAUD DETECTION  |  SQL TASKS 3, 4, 5
--  SecureGuard Financial Solutions | Simplilearn Capstone
--  Run each section one at a time in MySQL Workbench
-- ================================================================


-- ────────────────────────────────────────────────────────────────
--  TASK 3: DATA LOADING
-- ────────────────────────────────────────────────────────────────

-- Step 1: Create schema and set as default
CREATE SCHEMA IF NOT EXISTS finance;
USE finance;

-- Step 2: Create cc_data table
DROP TABLE IF EXISTS cc_data;
CREATE TABLE cc_data (
    row_id                INT,
    trans_date_trans_time DATETIME,
    cc_num                VARCHAR(25),
    merchant              VARCHAR(200),
    category              VARCHAR(50),
    amt                   DECIMAL(10,2),
    first_name            VARCHAR(50),
    last_name             VARCHAR(50),
    gender                CHAR(1),
    street                VARCHAR(200),
    city                  VARCHAR(100),
    state                 CHAR(2),
    zip                   VARCHAR(10),
    lat                   DECIMAL(10,6),
    lon                   DECIMAL(10,6),
    city_pop              INT,
    job                   VARCHAR(150),
    dob                   DATE,
    trans_num             VARCHAR(50),
    unix_time             BIGINT,
    merch_lat             DECIMAL(10,6),
    merch_long            DECIMAL(10,6),
    is_fraud              TINYINT(1)
);

-- Step 3: Create location_data table
DROP TABLE IF EXISTS location_data;
CREATE TABLE location_data (
    cc_num  VARCHAR(25),
    lat     DECIMAL(10,6),
    lon     DECIMAL(10,6)
);

-- Step 4: Load cc_data.csv
--  File path: C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cc_data.csv
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cc_data.csv'
INTO TABLE cc_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(@col1, @trans_dt, cc_num, merchant, category, amt,
 first_name, last_name, gender, street, city, state, zip,
 lat, lon, city_pop, job, @dob_str,
 trans_num, unix_time, merch_lat, merch_long, is_fraud)
SET
    row_id                = @col1,
    trans_date_trans_time = STR_TO_DATE(@trans_dt, '%d-%m-%Y %H:%i'),
    dob                   = STR_TO_DATE(@dob_str,  '%d-%m-%Y');

SELECT CONCAT('cc_data loaded: ', FORMAT(COUNT(*),0), ' rows') AS load_status FROM cc_data;

-- Step 5: Load location_data.csv
--  File path: C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/location_data.csv
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/location_data.csv'
INTO TABLE location_data
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(cc_num, lat, lon);

SELECT CONCAT('location_data loaded: ', FORMAT(COUNT(*),0), ' rows') AS load_status FROM location_data;


-- ────────────────────────────────────────────────────────────────
--  TASK 4: DATA EXPLORATION WITH SQL
-- ────────────────────────────────────────────────────────────────

-- Q4.1: Total number of transactions in cc_data
SELECT
    FORMAT(COUNT(*), 0) AS total_transactions
FROM cc_data;

-- Q4.2: Top 10 most frequent merchants in cc_data
SELECT
    merchant,
    COUNT(*) AS transaction_count
FROM cc_data
GROUP BY merchant
ORDER BY transaction_count DESC
LIMIT 10;

-- Q4.3: Average transaction amount for each category
SELECT
    category,
    FORMAT(COUNT(*), 0)        AS total_transactions,
    ROUND(AVG(amt), 2)         AS avg_amount_usd,
    ROUND(MIN(amt), 2)         AS min_amount_usd,
    ROUND(MAX(amt), 2)         AS max_amount_usd
FROM cc_data
GROUP BY category
ORDER BY avg_amount_usd DESC;

-- Q4.4: Fraudulent transaction count and percentage of total
SELECT
    FORMAT(SUM(is_fraud), 0)                        AS fraudulent_transactions,
    FORMAT(COUNT(*), 0)                             AS total_transactions,
    ROUND(SUM(is_fraud) / COUNT(*) * 100, 4)        AS fraud_percentage
FROM cc_data;

-- Q4.5: Join cc_data and location_data to get lat/long of each transaction
--  Note: location_data cc_num is in scientific notation from CSV export.
--  We use ROUND(..., -10) to normalise both values before joining.
SELECT
    c.trans_num,
    c.trans_date_trans_time,
    c.merchant,
    c.category,
    c.amt,
    c.is_fraud,
    l.lat   AS home_lat,
    l.lon   AS home_long,
    c.merch_lat,
    c.merch_long
FROM cc_data c
INNER JOIN location_data l
    ON ROUND(c.cc_num + 0, -10) = ROUND(l.cc_num + 0, -10)
LIMIT 100;

-- Q4.6: City with the highest population in location_data
SELECT
    city,
    state,
    FORMAT(city_pop, 0) AS city_population
FROM cc_data
ORDER BY city_pop DESC
LIMIT 1;

-- Q4.7: Earliest and latest transaction dates in cc_data
SELECT
    MIN(trans_date_trans_time)                                       AS earliest_transaction,
    MAX(trans_date_trans_time)                                       AS latest_transaction,
    DATEDIFF(MAX(trans_date_trans_time), MIN(trans_date_trans_time)) AS span_days
FROM cc_data;


-- ────────────────────────────────────────────────────────────────
--  TASK 5: DATA AGGREGATION WITH SQL
-- ────────────────────────────────────────────────────────────────

-- Q5.1: Total amount spent across all transactions
SELECT
    FORMAT(COUNT(*), 0)        AS total_transactions,
    ROUND(SUM(amt), 2)         AS total_amount_spent_usd,
    ROUND(AVG(amt), 2)         AS avg_transaction_amount_usd,
    ROUND(MIN(amt), 2)         AS min_transaction_usd,
    ROUND(MAX(amt), 2)         AS max_transaction_usd
FROM cc_data;

-- Q5.2: Number of transactions in each category
SELECT
    category,
    FORMAT(COUNT(*), 0)        AS transaction_count,
    ROUND(SUM(amt), 2)         AS total_amount_usd,
    ROUND(AVG(amt), 2)         AS avg_amount_usd
FROM cc_data
GROUP BY category
ORDER BY transaction_count DESC;

-- Q5.3: Average transaction amount for each gender
SELECT
    CASE gender WHEN 'M' THEN 'Male' WHEN 'F' THEN 'Female' ELSE gender END AS gender,
    FORMAT(COUNT(*), 0)        AS total_transactions,
    ROUND(AVG(amt), 2)         AS avg_transaction_amount_usd,
    ROUND(SUM(amt), 2)         AS total_amount_usd
FROM cc_data
GROUP BY gender
ORDER BY avg_transaction_amount_usd DESC;

-- Q5.4: Day of week with highest average transaction amount
SELECT
    DAYNAME(trans_date_trans_time)   AS day_of_week,
    FORMAT(COUNT(*), 0)              AS total_transactions,
    ROUND(AVG(amt), 2)               AS avg_transaction_amount_usd
FROM cc_data
GROUP BY
    DAYNAME(trans_date_trans_time),
    DAYOFWEEK(trans_date_trans_time)
ORDER BY avg_transaction_amount_usd DESC;

-- ================================================================
--  END OF SQL SCRIPT
-- ================================================================
