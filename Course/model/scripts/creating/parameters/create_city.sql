CREATE TABLE city
(
    id              SERIAL,
    city_name       VARCHAR(40) NOT NULL,
    region_key      VARCHAR(40) NOT NULL,
    geo_location_id INT         NOT NULL UNIQUE,

    CONSTRAINT PK_city PRIMARY KEY (id),

    CONSTRAINT FK_city_region
        FOREIGN KEY (region_key) REFERENCES region (key)
            ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT FK_city_geo_location
        FOREIGN KEY (geo_location_id) REFERENCES geo_location (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);

CLUSTER city USING pk_city;