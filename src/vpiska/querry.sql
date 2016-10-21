/* querry # 1 */
CREATE OR REPLACE VIEW HousesWithCountries AS
  SELECT
    h.*,
    c.name AS country_name,
    c.fee_percent
  FROM house h INNER JOIN countryfee c ON h.country_id = c.country_id;

CREATE OR REPLACE VIEW FullFacilities AS
  SELECT
    f.name,
    fh.house_id
  FROM facility f INNER JOIN facilityinhouse fh ON f.id = fh.facility_id;
WITH housesWithPrices AS (
    SELECT h.*
    FROM HousesWithCountries h INNER JOIN houseprice p ON h.id = p.house_id
    WHERE p.week_num = 1 AND h.country_name = 'Spain' AND h.max_residents >= 6)
SELECT h.*
FROM
  housesWithPrices h INNER JOIN
  (SELECT *
   FROM
     FullFacilities f
   WHERE
     f.name = 'Wi-Fi') f
    ON
      f.house_id = h.id;

/* querry # 2 */
CREATE OR REPLACE VIEW UserInApplication AS
  SELECT DISTINCT h.host_id
  FROM house h INNER JOIN application a ON h.id = a.house_id
  WHERE a.is_accepted = 'Accepted';
CREATE OR REPLACE VIEW BothUserAndHost AS
  SELECT DISTINCT u.host_id
  FROM UserInApplication u INNER JOIN application a ON u.host_id = a.user_id;
SELECT u.*
FROM us3r u INNER JOIN BothUserAndHost b ON u.id = b.host_id;

/* querry # 3 */
CREATE OR REPLACE VIEW NotLessThan10Visitors AS
  SELECT h.host_id
  FROM house h INNER JOIN application a ON h.id = a.house_id
  WHERE a.is_accepted = 'Accepted'
  GROUP BY h.host_id
  HAVING sum(a.residents_number) >= 10;

SELECT u.*
FROM us3r u INNER JOIN NotLessThan10Visitors n ON u.id = n.host_id;

/* querry # 4 */

/* querry # 5 */
SELECT
  h.id,
  avg(u.convenient_location_rate) AS avg_convenient_location_rate,
  avg(u.cleanliness_rate)         AS avg_cleanliness_rate,
  avg(u.friendliness_rate)        AS avg_friendliness_rate
FROM
  house h INNER JOIN usercomment u ON h.id = u.house_id
GROUP BY h.id;

/* querry # 6 */
SELECT
  c.country_id,
  count(*)
FROM house h INNER JOIN countryfee c ON h.country_id = c.country_id
GROUP BY C.country_id;

/* querry # 7 */
CREATE OR REPLACE FUNCTION _final_median(NUMERIC [])
  RETURNS NUMERIC AS
$$
SELECT AVG(val)
FROM (
       SELECT val
       FROM unnest($1) val
       ORDER BY 1
       LIMIT 2 - MOD(array_upper($1, 1), 2)
       OFFSET CEIL(array_upper($1, 1) / 2.0) - 1
     ) sub;
$$
LANGUAGE 'sql' IMMUTABLE;

CREATE AGGREGATE median( NUMERIC ) (
SFUNC = array_append,
STYPE = NUMERIC [],
FINALFUNC = _final_median,
INITCOND = '{}'
);

CREATE OR REPLACE VIEW MedianPriceOverCounrtyAndWeek AS
  SELECT
    h.country_name,
    p.week_num,
    median((((h.fee_percent + 100) / 100) * 7 * p.price + c.cleaning_price) :: NUMERIC) AS median_price
  FROM HousesWithCountries h INNER JOIN houseprice p ON h.id = p.house_id
    INNER JOIN cleaningprice c ON h.id = c.id
  GROUP BY (h.country_name, p.week_num);

/* querry # 8 */
SELECT
  m.country_name,
  m.week_num
FROM MedianPriceOverCounrtyAndWeek
     m INNER JOIN (SELECT
                     m.country_name,
                     max(m.median_price) AS max_price
                   FROM MedianPriceOverCounrtyAndWeek m
                   GROUP BY m.country_name) t ON m.country_name = t.country_name
WHERE m.median_price <= 2 * t.max_price;

/* querry # 9 */

/* querry # 10 */
