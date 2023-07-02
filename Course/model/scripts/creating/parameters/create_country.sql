CREATE TABLE country
(
    iso_code      CHAR(3) UNIQUE CHECK ( length(iso_code) = 3 ),
    country_name  VARCHAR(40)  NOT NULL,
    official_name VARCHAR(100) NOT NULL UNIQUE,
    phone_code    VARCHAR(5)   NOT NULL CHECK ( country.phone_code ~ '^[0-9]+$' ),

    CONSTRAINT PK_country PRIMARY KEY (iso_code)
);
CLUSTER country USING pk_country;
