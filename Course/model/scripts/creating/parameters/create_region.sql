CREATE TABLE region
(
    key          VARCHAR(40)  NOT NULL,
    name         VARCHAR(100) NOT NULL,
    country_code CHAR(3)      NOT NULL CHECK ( length(country_code) = 3 ),

    CONSTRAINT PK_region PRIMARY KEY (key),

    CONSTRAINT FK_region_country
        FOREIGN KEY (country_code) REFERENCES country (iso_code)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CLUSTER region USING pk_region;