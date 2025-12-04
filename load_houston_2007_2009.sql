-- Favorite routes
CREATE TABLE IF NOT EXISTS houston_faves_2007_2009 AS
SELECT *
FROM houston_2007_2009
WHERE destination_airport IN (
    'LAX', 'BUR', 'SNA', 'LGB',
    'SEA',
    'JFK', 'LGA', 'EWR'
);

-- Features view
CREATE OR REPLACE VIEW houston_faves_features AS
SELECT
    *,
    EXTRACT(YEAR  FROM fly_date_date)::int AS year,
    EXTRACT(MONTH FROM fly_date_date)::int AS month,
    EXTRACT(DOW   FROM fly_date_date)::int AS dow,
    CASE
        WHEN EXTRACT(DOW FROM fly_date_date) IN (0,6) THEN 1 ELSE 0
    END AS is_weekend,
    origin_airport || '-' || destination_airport AS route
FROM houston_faves_2007_2009;

-- Monthly stats per route
CREATE OR REPLACE VIEW monthly_route_stats AS
SELECT
    route,
    EXTRACT(YEAR  FROM fly_date_date)::int AS year,
    EXTRACT(MONTH FROM fly_date_date)::int AS month,
    DATE_TRUNC('month', fly_date_date)::date AS month_start,
    SUM(passengers) AS passengers,
    SUM(flights)    AS flights
FROM houston_faves_features
GROUP BY route, year, month, DATE_TRUNC('month', fly_date_date);

-- Route totals (all Houston routes)
CREATE OR REPLACE VIEW route_totals_2007_2009 AS
SELECT
    origin_airport,
    destination_airport,
    origin_airport || '-' || destination_airport AS route,
    SUM(passengers) AS total_passengers,
    SUM(flights)    AS total_flights
FROM houston_2007_2009
GROUP BY origin_airport, destination_airport;

-- 2007–2009 change per route
CREATE OR REPLACE VIEW route_change_2007_2009 AS
WITH yearly AS (
    SELECT
        route,
        EXTRACT(YEAR FROM fly_date_date)::int AS year,
        SUM(passengers) AS passengers
    FROM houston_faves_features
    GROUP BY route, EXTRACT(YEAR FROM fly_date_date)
),
pivot AS (
    SELECT
        route,
        MAX(CASE WHEN year = 2007 THEN passengers END) AS p2007,
        MAX(CASE WHEN year = 2008 THEN passengers END) AS p2008,
        MAX(CASE WHEN year = 2009 THEN passengers END) AS p2009
    FROM yearly
    GROUP BY route
)
SELECT
    route,
    p2007,
    p2008,
    p2009,
    (p2009 - p2007) AS change_passengers,
    ROUND(100.0 * (p2009 - p2007) / p2007, 1) AS pct_change_2007_2009
FROM pivot
WHERE p2007 IS NOT NULL AND p2009 IS NOT NULL;
