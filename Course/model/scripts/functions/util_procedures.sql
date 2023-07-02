CREATE PROCEDURE add_city(
    city_name_arg VARCHAR(40),
    region_key_arg VARCHAR(40),
    longitude_arg DECIMAL(9, 6),
    latitude_arg DECIMAL(8, 6)
)
AS
$$
DECLARE
    new_geo_location_id INT;
BEGIN
    INSERT INTO geo_location(longitude, latitude)
    VALUES (longitude_arg, latitude_arg)
    RETURNING id INTO new_geo_location_id;

    INSERT INTO city(city_name, region_key, geo_location_id)
    VALUES (city_name_arg, region_key_arg, new_geo_location_id);
END
$$ LANGUAGE plpgsql;