CREATE VIEW located_city_view AS
SELECT city.id, city_name, region_key, geo_location_id, longitude, latitude
FROM city
         INNER JOIN geo_location gl on gl.id = city.geo_location_id;

CREATE VIEW full_located_city_view AS
SELECT city.id,
       city_name,
       region_key,
       geo_location_id,
       longitude,
       latitude,
       key,
       country_code,
       iso_code,
       country_name,
       official_name,
       phone_code
FROM city
         INNER JOIN geo_location gl on gl.id = city.geo_location_id
         INNER JOIN region r on city.region_key = r.key
         INNER JOIN country c on r.country_code = c.iso_code;