-- DROP EXTENSION IF EXISTS postgis;
-- CREATE EXTENSION IF NOT EXISTS postgis;

/* task №1 */
DROP TABLE IF EXISTS users CASCADE;
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  name    VARCHAR(35)  NOT NULL,
  surname VARCHAR(35)  NOT NULL,
  email   VARCHAR(254) NOT NULL,
  phone   VARCHAR(16)  NOT NULL
);

DROP TABLE IF EXISTS users_extra CASCADE;
CREATE TABLE users_extra (
  user_id       SERIAL REFERENCES users (user_id) ON DELETE CASCADE,
  sex           BIT,
  date_of_birth DATE,
  photo         BYTEA
);

DROP TABLE IF EXISTS country_to_fee CASCADE;
CREATE TABLE country_to_fee (
  country_id  SERIAL PRIMARY KEY,
  name        VARCHAR(52),
  fee_percent FLOAT NOT NULL
);
CREATE UNIQUE INDEX IF NOT EXISTS country_name_to_id_fast
  ON country_to_fee USING BTREE (name);

DROP TABLE IF EXISTS houses CASCADE;
CREATE TABLE houses (
  house_id      SERIAL PRIMARY KEY,
  country_id    SERIAL REFERENCES country_to_fee (country_id) ON DELETE CASCADE,
  address_extra VARCHAR(100) NOT NULL,
  house_name    VARCHAR(100) NOT NULL,
  rooms_number  SMALLINT     NOT NULL CHECK (rooms_number >= 0),
  beds_number   SMALLINT     NOT NULL CHECK (beds_number >= 0),
  max_residents SMALLINT     NOT NULL CHECK (beds_number >= 0),
  gps_longitude FLOAT        NOT NULL CHECK (gps_latitude >= -90 AND gps_latitude <= 90),
  gps_latitude  FLOAT        NOT NULL CHECK (gps_longitude >= -180 AND gps_longitude <= 180)
);
CREATE INDEX IF NOT EXISTS country_gps_fast
  ON houses USING BTREE (gps_longitude, gps_latitude);

DROP TABLE IF EXISTS houses_extra CASCADE;
CREATE TABLE houses_extra (
  house_id        SERIAL REFERENCES houses (house_id) ON DELETE CASCADE,
  wi_fi           BIT,
  iron            BIT,
  kitchenware     BIT,
  electric_kettle BIT,
  smoking_free    BIT
);

DROP TABLE IF EXISTS houses_prices CASCADE;
CREATE TABLE houses_prices (
  house_id       SERIAL REFERENCES houses (house_id) ON DELETE CASCADE,
  prices         MONEY [53] NOT NULL,
  cleaning_price MONEY
);

DROP TABLE IF EXISTS applications CASCADE;
CREATE TABLE applications (
  application_id   SERIAL PRIMARY KEY,
  date_begin       DATE    NOT NULL,
  date_end         DATE    NOT NULL,
  residents_number INTEGER NOT NULL CHECK (residents_number >= 0),
  commentary       VARCHAR(1000),
  is_accepted      BIT,
  house_id         SERIAL REFERENCES houses (house_id) ON DELETE CASCADE,
  user_id          SERIAL REFERENCES users (user_id) ON DELETE CASCADE
);
CREATE INDEX IF NOT EXISTS applications_for_user_fast
  ON applications USING BTREE (user_id);
CREATE INDEX IF NOT EXISTS applications_for_house_fast
  ON applications USING BTREE (house_id);

/* task №2 */
DROP TABLE IF EXISTS user_comments CASCADE;
CREATE TABLE user_comments (
  comment_id               SERIAL PRIMARY KEY,
  house_id                 SERIAL REFERENCES houses (house_id) ON DELETE CASCADE,
  comment_text             VARCHAR(1000) NOT NULL,
  convenient_location_rate SMALLINT      NOT NULL CHECK (convenient_location_rate IN (1, 2, 3, 4, 5)),
  cleanliness_rate         SMALLINT      NOT NULL CHECK (cleanliness_rate IN (1, 2, 3, 4, 5)),
  friendliness_rate        SMALLINT      NOT NULL CHECK (friendliness_rate IN (1, 2, 3, 4, 5))
);
CREATE INDEX IF NOT EXISTS comments_for_house_fast
  ON user_comments USING BTREE (house_id);

DROP TABLE IF EXISTS host_comments CASCADE;
CREATE TABLE host_comments (
  comment_id   SERIAL PRIMARY KEY,
  user_id      SERIAL REFERENCES users (user_id) ON DELETE CASCADE,
  comment_text VARCHAR(1000) NOT NULL,
  rate         SMALLINT      NOT NULL CHECK (rate IN (1, 2, 3, 4, 5))
);
CREATE INDEX IF NOT EXISTS comments_for_user_fast
  ON host_comments USING BTREE (user_id);

/* task №3 */
DROP TYPE IF EXISTS GENRE CASCADE;
CREATE TYPE GENRE AS ENUM ('beach', 'festival', 'sport');

DROP TABLE IF EXISTS entertainmets CASCADE;
CREATE TABLE entertainmets (
  entertainmet_id SERIAL PRIMARY KEY,
  name            VARCHAR(100) NOT NULL,
  time_begin      TIMESTAMP    NOT NULL,
  time_end        TIMESTAMP    NOT NULL,
  genre           GENRE        NOT NULL,
  gps_longitude   FLOAT        NOT NULL CHECK (gps_latitude >= -90 AND gps_latitude <= 90),
  gps_latitude    FLOAT        NOT NULL CHECK (gps_longitude >= -180 AND gps_longitude <= 180)
);
CREATE INDEX IF NOT EXISTS entertainmets_gps_fast
  ON entertainmets USING BTREE (gps_longitude, gps_latitude);
