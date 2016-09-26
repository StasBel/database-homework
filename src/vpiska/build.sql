/* task #1 */
CREATE TABLE users (
  user_id SERIAL PRIMARY KEY,
  name    VARCHAR(35)  NOT NULL,
  surname VARCHAR(35)  NOT NULL,
  email   VARCHAR(254) NOT NULL,
  phone   VARCHAR(16)  NOT NULL
);

CREATE TABLE users_extra (
  user_id       SERIAL REFERENCES users (user_id) ON DELETE CASCADE,
  sex           BIT,
  date_of_birth DATE,
  photo         BYTEA
);

CREATE TABLE country_to_fee (
  name        VARCHAR(52) PRIMARY KEY,
  fee_percent FLOAT NOT NULL
);

CREATE TABLE houses (
  house_id      SERIAL PRIMARY KEY,
  country_name  VARCHAR(52) REFERENCES country_to_fee (name) ON DELETE CASCADE,
  address_extra VARCHAR(100) NOT NULL,
  house_name    VARCHAR(52)  NOT NULL,
  rooms_number  SMALLINT     NOT NULL,
  beds_number   SMALLINT     NOT NULL,
  max_residents SMALLINT     NOT NULL,
  gps_longitude FLOAT        NOT NULL,
  gps_latitude  FLOAT        NOT NULL
);

CREATE TABLE houses_gps (
  gps_longitude FLOAT NOT NULL,
  gps_latitude  FLOAT NOT NULL,
  PRIMARY KEY (gps_longitude, gps_latitude),
  house_id      SERIAL REFERENCES houses (house_id) ON DELETE CASCADE
);

CREATE TABLE houses_extra (
  house_id        SERIAL REFERENCES houses (house_id) ON DELETE CASCADE,
  wi_fi           BIT,
  iron            BIT,
  kitchenware     BIT,
  electric_kettle BIT,
  smoking_free    BIT
);

CREATE TABLE houses_prices (
  house_id       SERIAL REFERENCES houses (house_id) ON DELETE CASCADE,
  prices         MONEY [53],
  cleaning_price MONEY
);

CREATE TABLE applications (
  application_id SERIAL PRIMARY KEY,
  date_begin     DATE NOT NULL,
  date_end       DATE NOT NULL,
  house_id       SERIAL REFERENCES houses (house_id) ON DELETE CASCADE,
  user_id        SERIAL REFERENCES users (user_id) ON DELETE CASCADE,
  commentary     VARCHAR(1000)
);

/* task #2 */
CREATE TABLE user_comments (
  comment_id               SERIAL,
  house_id                 SERIAL REFERENCES houses (house_id) ON DELETE CASCADE,
  PRIMARY KEY (house_id, comment_id),
  comment_text             VARCHAR(1000) NOT NULL,
  convenient_location_rate SMALLINT      NOT NULL,
  CHECK (convenient_location_rate >= 1 AND convenient_location_rate <= 5),
  cleanliness_rate         SMALLINT      NOT NULL,
  CHECK (cleanliness_rate >= 1 AND cleanliness_rate <= 5),
  host_friendliness_rate   SMALLINT      NOT NULL,
  CHECK (host_friendliness_rate >= 1 AND host_friendliness_rate <= 5)
);

CREATE TABLE host_comments (
  comment_id   SERIAL,
  user_id      SERIAL REFERENCES users (user_id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, comment_id),
  comment_text VARCHAR(1000) NOT NULL,
  rate         SMALLINT      NOT NULL,
  CHECK (rate >= 1 AND rate <= 5)
);

/* task #3 */
CREATE TYPE genre AS ENUM ('beach', 'festival', 'sport');

CREATE TABLE entertainmets (
  entertainmet_id SERIAL PRIMARY KEY,
  name            VARCHAR(100) NOT NULL,
  gps_longitude   FLOAT        NOT NULL,
  gps_latitude    FLOAT        NOT NULL,
  time_begin      TIMESTAMP    NOT NULL,
  time_end        TIMESTAMP    NOT NULL,
  genre           genre        NOT NULL
);

CREATE TABLE entertainmets_gps (
  gps_longitude   FLOAT NOT NULL,
  gps_latitude    FLOAT NOT NULL,
  PRIMARY KEY (gps_longitude, gps_latitude),
  entertainmet_id SERIAL REFERENCES entertainmets (entertainmet_id) ON DELETE CASCADE
);
