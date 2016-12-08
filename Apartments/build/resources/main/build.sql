-- DROP EXTENSION IF EXISTS postgis;
-- CREATE EXTENSION IF NOT EXISTS postgis;

/* task №1 */
DROP TABLE IF EXISTS Us3r CASCADE;
CREATE TABLE Us3r (
  id      SERIAL PRIMARY KEY,
  name    VARCHAR(35)  NOT NULL,
  surname VARCHAR(35)  NOT NULL,
  email   VARCHAR(254) NOT NULL UNIQUE,
  phone   VARCHAR(16)  NOT NULL UNIQUE
);

DROP TYPE IF EXISTS SEX CASCADE;
CREATE TYPE SEX AS ENUM ('Male', 'Female');

DROP TABLE IF EXISTS UserExtra CASCADE;
CREATE TABLE UserExtra (
  id            INTEGER REFERENCES Us3r (id) ON DELETE CASCADE PRIMARY KEY,
  sex           SEX,
  date_of_birth DATE,
  photo         BYTEA
);

DROP TABLE IF EXISTS CountryFee CASCADE;
CREATE TABLE CountryFee (
  country_id  SERIAL PRIMARY KEY,
  name        VARCHAR(52) NOT NULL UNIQUE,
  fee_percent FLOAT       NOT NULL CHECK (fee_percent >= 0)
);

DROP TABLE IF EXISTS House CASCADE;
CREATE TABLE House (
  id            SERIAL PRIMARY KEY,
  host_id       INTEGER REFERENCES Us3r (id) ON DELETE CASCADE,
  country_id    INTEGER REFERENCES CountryFee (country_id) ON DELETE CASCADE,
  address_extra VARCHAR(100),
  house_name    VARCHAR(100) NOT NULL,
  rooms_number  SMALLINT     NOT NULL CHECK (rooms_number >= 0),
  beds_number   SMALLINT     NOT NULL CHECK (beds_number >= 0),
  max_residents SMALLINT     NOT NULL CHECK (beds_number >= 0),
  gps_longitude FLOAT,
  gps_latitude  FLOAT,
  UNIQUE (gps_latitude, gps_longitude, house_name)
);

DROP TABLE IF EXISTS Facility CASCADE;
CREATE TABLE Facility (
  id   SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS facilityinhouse CASCADE;
CREATE TABLE FacilityInHouses (
  id          SERIAL PRIMARY KEY,
  house_id    INTEGER REFERENCES House (id) ON DELETE CASCADE,
  facility_id INTEGER REFERENCES Facility (id) ON DELETE CASCADE,
  UNIQUE (house_id, facility_id)
);

DROP TABLE IF EXISTS HousePrice CASCADE;
CREATE TABLE HousePrice (
  id       SERIAL PRIMARY KEY,
  house_id INTEGER REFERENCES House (id) ON DELETE CASCADE,
  week_num SMALLINT NOT NULL CHECK (week_num >= 1 AND week_num <= 53),
  UNIQUE (house_id, week_num),
  price    FLOAT    NOT NULL CHECK (price >= 0)
);

DROP TABLE IF EXISTS CleaningPrice CASCADE;
CREATE TABLE CleaningPrice (
  id             INTEGER REFERENCES House (id) ON DELETE CASCADE PRIMARY KEY,
  cleaning_price FLOAT NOT NULL CHECK (cleaning_price >= 0)
);

DROP TYPE IF EXISTS APPLICATIONSTATUS CASCADE;
CREATE TYPE APPLICATIONSTATUS AS ENUM ('Unreviewed', 'Accepted', 'Rejected');

DROP TABLE IF EXISTS Application CASCADE;
CREATE TABLE Application (
  id               SERIAL PRIMARY KEY,
  date_begin       DATE              NOT NULL,
  date_end         DATE              NOT NULL,
  CHECK (date_begin <= date_end),
  residents_number SMALLINT          NOT NULL CHECK (residents_number >= 0),
  commentary       VARCHAR(1000),
  is_accepted      APPLICATIONSTATUS NOT NULL,
  house_id         INTEGER REFERENCES House (id) ON DELETE CASCADE,
  user_id          INTEGER REFERENCES Us3r (id) ON DELETE CASCADE
);


/* task №2 */
DROP TABLE IF EXISTS UserComment CASCADE;
CREATE TABLE UserComment (
  id                       SERIAL PRIMARY KEY,
  house_id                 INTEGER REFERENCES House (id) ON DELETE CASCADE,
  user_id                  INTEGER REFERENCES Us3r (id),
  comment_text             VARCHAR(1000) NOT NULL,
  convenient_location_rate SMALLINT      NOT NULL CHECK (convenient_location_rate IN (1, 2, 3, 4, 5)),
  cleanliness_rate         SMALLINT      NOT NULL CHECK (cleanliness_rate IN (1, 2, 3, 4, 5)),
  friendliness_rate        SMALLINT      NOT NULL CHECK (friendliness_rate IN (1, 2, 3, 4, 5))
);

DROP TABLE IF EXISTS HostComment CASCADE;
CREATE TABLE HostComment (
  comment_id   SERIAL PRIMARY KEY,
  user_id      INTEGER REFERENCES Us3r (id) ON DELETE CASCADE,
  host_id      INTEGER REFERENCES Us3r (id),
  CHECK (host_id != user_id),
  comment_text VARCHAR(1000) NOT NULL,
  rate         SMALLINT      NOT NULL CHECK (rate IN (1, 2, 3, 4, 5))
);

/* task №3 */
DROP TABLE IF EXISTS Genre CASCADE;
CREATE TABLE Genre (
  id   SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE
);

DROP TABLE IF EXISTS Entertainmets CASCADE;
CREATE TABLE Entertainmets (
  id            SERIAL PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  time_begin    TIMESTAMP    NOT NULL,
  time_end      TIMESTAMP    NOT NULL,
  CHECK (time_begin <= time_end),
  genre         INTEGER REFERENCES Genre (id) ON DELETE CASCADE,
  gps_longitude FLOAT        NOT NULL CHECK (gps_latitude >= -90 AND gps_latitude <= 90),
  gps_latitude  FLOAT        NOT NULL CHECK (gps_longitude >= -180 AND gps_longitude <= 180),
  UNIQUE (gps_latitude, gps_longitude, name)
);
