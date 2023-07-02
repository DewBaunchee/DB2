CREATE TABLE geo_location
(
    id        SERIAL,
    longitude DECIMAL(9, 6) NOT NULL ,
    latitude  DECIMAL(8, 6) NOT NULL ,

    CONSTRAINT PK_geo_location PRIMARY KEY (id)
);

CLUSTER geo_location USING pk_geo_location;