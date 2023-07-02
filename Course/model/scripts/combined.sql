CREATE TABLE country
(
    iso_code      CHAR(3) UNIQUE CHECK ( length(iso_code) = 3 ),
    country_name  VARCHAR(40)  NOT NULL,
    official_name VARCHAR(100) NOT NULL UNIQUE,
    phone_code    VARCHAR(5)   NOT NULL CHECK ( country.phone_code ~ '^[0-9]+$' ),

    CONSTRAINT PK_country PRIMARY KEY (iso_code)
);
CLUSTER country USING pk_country;

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

CREATE TABLE geo_location
(
    id        SERIAL,
    longitude DECIMAL(9, 6) NOT NULL ,
    latitude  DECIMAL(8, 6) NOT NULL ,

    CONSTRAINT PK_geo_location PRIMARY KEY (id)
);

CLUSTER geo_location USING pk_geo_location;

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

CREATE TABLE interest_category
(
    key VARCHAR(40) NOT NULL,

    CONSTRAINT PK_interest_category PRIMARY KEY (key)
);
CLUSTER interest_category USING pk_interest_category;

CREATE TABLE interest
(
    key          VARCHAR(40) NOT NULL,
    category_key VARCHAR(40) NOT NULL,

    CONSTRAINT PK_interest PRIMARY KEY (key),

    CONSTRAINT FK_interest_category
        FOREIGN KEY (category_key) REFERENCES interest_category (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CLUSTER interest USING pk_interest;

CREATE PROCEDURE add_interest(
    interest_key VARCHAR(40),
    interest_category_key VARCHAR(40)
)
AS
$$
BEGIN
    INSERT INTO interest_category(key)
    VALUES (interest_category_key)
    ON CONFLICT DO NOTHING;

    INSERT INTO interest(key, category_key)
    VALUES (interest_key, interest_category_key);
END;
$$ LANGUAGE plpgsql;

CREATE TABLE locale
(
    key   CHAR(5)     NOT NULL,
    label VARCHAR(40) NOT NULL UNIQUE,

    CONSTRAINT PK_locale PRIMARY KEY (key)
);
CLUSTER locale USING pk_locale;

CREATE TABLE locale_picture
(
    locale_key CHAR(5) UNIQUE,
    picture    BYTEA NOT NULL,

    CONSTRAINT FK_locale_picture
        FOREIGN KEY (locale_key) REFERENCES locale (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX locale_picture_index ON locale_picture (locale_key);
CLUSTER locale_picture USING locale_picture_index;

CREATE TABLE marital_status
(
    key CHAR(10) NOT NULL ,

    CONSTRAINT PK_marital_status PRIMARY KEY (key)
);
CLUSTER marital_status USING pk_marital_status;

CREATE TABLE programming_language
(
    key VARCHAR(20) NOT NULL,

    CONSTRAINT PK_programming_language PRIMARY KEY (key)
);
CLUSTER programming_language USING pk_programming_language;

CREATE TABLE sex
(
    key CHAR(10) NOT NULL,

    CONSTRAINT PK_sex PRIMARY KEY (key)
);
CLUSTER sex USING pk_sex;

CREATE TABLE person
(
    id           SERIAL,
    name         VARCHAR(40)  NOT NULL,
    email        VARCHAR(255) NOT NULL UNIQUE,
    phone_number CHAR(15)     NOT NULL UNIQUE,

    CONSTRAINT PK_person PRIMARY KEY (id)
);
CLUSTER person USING pk_person;

CREATE TABLE person_credentials
(
    person_id INT      NOT NULL UNIQUE,
    password  CHAR(60) NOT NULL,

    CONSTRAINT FK_person_credentials
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX person_credentials_index ON person_credentials (person_id);
CLUSTER person_credentials USING person_credentials_index;

CREATE TABLE person_locale
(
    person_id  INT     NOT NULL,
    locale_key CHAR(5) NOT NULL,

    CONSTRAINT FK_person_locale_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_locale_locale
        FOREIGN KEY (locale_key) REFERENCES locale (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX person_locale_index ON person_locale (person_id);
CLUSTER person_locale USING person_locale_index;

CREATE TABLE person_programming_language
(
    person_id                INT         NOT NULL,
    programming_language_key VARCHAR(20) NOT NULL,

    CONSTRAINT FK_person_programming_language_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_programming_language_language
        FOREIGN KEY (programming_language_key) REFERENCES programming_language (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX person_programming_language_index ON person_programming_language (person_id);
CLUSTER person_programming_language USING person_programming_language_index;

CREATE TABLE person_interest
(
    person_id    INT         NOT NULL,
    interest_key VARCHAR(40) NOT NULL,

    CONSTRAINT FK_person_interest_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_interest_interest
        FOREIGN KEY (interest_key) REFERENCES interest (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX person_interest_index ON person_interest (person_id);
CLUSTER person_interest USING person_interest_index;

CREATE TABLE photo
(
    id   BIGINT NOT NULL,
    data BYTEA  NOT NULL,

    CONSTRAINT PK_photo PRIMARY KEY (id)
);
CLUSTER photo USING PK_photo;

CREATE TABLE person_photo
(
    person_id INT    NOT NULL,
    photo_id  BIGINT NOT NULL,

    CONSTRAINT FK_person_photo_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_photo_photo
        FOREIGN KEY (photo_id) REFERENCES photo (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX person_photo_index ON person_photo (person_id);
CLUSTER person_photo USING person_photo_index;

CREATE TABLE person_public_info
(
    person_id          INT NOT NULL UNIQUE,
    marital_status_key CHAR(10),
    sex_key            CHAR(5),
    birthday           DATE CHECK ( birthday < now() - interval '18 years' ),
    city_id            INT,
    height             SMALLINT,
    main_photo         BIGINT,

    CONSTRAINT FK_person_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_marital_status
        FOREIGN KEY (marital_status_key) REFERENCES marital_status (key)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_sex
        FOREIGN KEY (sex_key) REFERENCES sex (key)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_city
        FOREIGN KEY (city_id) REFERENCES city (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_main_photo
        FOREIGN KEY (main_photo) REFERENCES photo (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX person_public_info_index ON person_public_info (person_id);
CREATE INDEX person_public_info_city_index ON person_public_info (city_id);
CLUSTER person_public_info USING person_public_info_index;

CREATE TABLE visited_person
(
    person_id         INT     NOT NULL,
    visited_person_id INT     NOT NULL,
    accepted          BOOLEAN NOT NULL,

    CONSTRAINT FK_visited_person_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_visited_person_visited
        FOREIGN KEY (visited_person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX visited_person_index ON visited_person (person_id);
CREATE INDEX visited_person_index2 ON visited_person (visited_person_id);
CLUSTER visited_person USING visited_person_index;

CREATE TABLE group_type
(
    key CHAR(40) NOT NULL ,

    CONSTRAINT PK_group_type PRIMARY KEY (key)
);
CLUSTER group_type USING pk_group_type;

CREATE TABLE "group"
(
    id            BIGINT,
    label         VARCHAR(40) NOT NULL,
    type          CHAR(40)    NOT NULL,
    creation_date TIMESTAMP   NOT NULL,

    CONSTRAINT PK_group PRIMARY KEY (id),

    CONSTRAINT FK_group_type
        FOREIGN KEY (type) REFERENCES group_type (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CLUSTER "group" USING pk_group;

CREATE TABLE group_member
(
    person_id INT    NOT NULL,
    group_id  BIGINT NOT NULL,

    CONSTRAINT FK_group_name_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_group_member_group
        FOREIGN KEY (group_id) REFERENCES "group" (id)
            ON DELETE CASCADE ON UPDATE RESTRICT
);
CREATE INDEX group_member_person_index ON group_member (person_id);
CREATE INDEX group_member_group_index ON group_member (group_id);
CLUSTER group_member USING group_member_person_index;

CREATE TABLE objective
(
    id          SERIAL,
    title       VARCHAR(40) NOT NULL,
    description TEXT        NOT NULL,
    template    TEXT,

    CONSTRAINT PK_objective PRIMARY KEY (id)
);
CLUSTER objective USING pk_objective;

CREATE TABLE solved_objective
(
    person_id                INT         NOT NULL,
    objective_id             INT         NOT NULL,
    programming_language_key VARCHAR(20) NOT NULL,
    solving                  TEXT        NOT NULL,

    CONSTRAINT FK_solved_objective_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_solved_objective_objective
        FOREIGN KEY (objective_id) REFERENCES objective (id)
            ON DELETE CASCADE ON UPDATE RESTRICT,

    CONSTRAINT FK_solved_objective_programming_language
        FOREIGN KEY (programming_language_key) REFERENCES programming_language (key)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX solved_objective_index ON solved_objective (person_id);
CLUSTER solved_objective USING solved_objective_index;

CREATE TABLE favorite_solved
(
    person_id           INT NOT NULL,
    solver_id           INT NOT NULL,
    solved_objective_id INT NOT NULL,

    CONSTRAINT FK_favorite_solved_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_favorite_solved_solver
        FOREIGN KEY (solver_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_favorite_solved_objective
        FOREIGN KEY (solved_objective_id) REFERENCES objective (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX favorite_solved_index ON favorite_solved (person_id);
CREATE INDEX favorite_solved_index2 ON favorite_solved (solver_id);
CREATE INDEX favorite_solved_index3 ON favorite_solved (solved_objective_id);
CLUSTER favorite_solved USING favorite_solved_index;

CREATE PROCEDURE like_solving(who_likes INT, solver_id_ INT, objective_id INT)
AS
$$
BEGIN
    INSERT INTO favorite_solved
    VALUES (who_likes, solver_id_, objective_id);
END;
$$ LANGUAGE plpgsql;

CREATE TABLE programming_language_filter
(
    person_id                INT         NOT NULL,
    programming_language_key VARCHAR(20) NOT NULL,

    CONSTRAINT FK_programming_language_filter_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_programming_language_filter_language
        FOREIGN KEY (programming_language_key) REFERENCES programming_language (key)
            ON DELETE RESTRICT ON UPDATE CASCADE
);
CREATE INDEX programming_language_filter_index ON programming_language_filter (person_id);
CLUSTER programming_language_filter USING programming_language_filter_index;

CREATE TABLE person_filter
(
    person_id          INT NOT NULL UNIQUE,
    marital_status_key CHAR(10),
    sex_key            CHAR(5),
    age                SMALLINT,
    city_id            INT,
    height             SMALLINT,

    CONSTRAINT FK_person_person
        FOREIGN KEY (person_id) REFERENCES person (id)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_marital_status
        FOREIGN KEY (marital_status_key) REFERENCES marital_status (key)
            ON DELETE RESTRICT ON UPDATE RESTRICT,

    CONSTRAINT FK_person_sex
        FOREIGN KEY (sex_key) REFERENCES sex (key)
            ON DELETE RESTRICT ON UPDATE RESTRICT
);
CREATE INDEX person_filter_index ON person_filter (person_id);
CLUSTER person_filter USING person_filter_index;

CREATE VIEW person_full_info_view AS
SELECT person.id,
       name,
       email,
       phone_number,
       password,
       marital_status_key,
       sex_key,
       birthday,
       city_id,
       height
FROM person
         INNER JOIN person_credentials pc on person.id = pc.person_id
         INNER JOIN person_public_info ppi on person.id = ppi.person_id;

CREATE VIEW solved_objective_view AS
SELECT person_id,
       objective_id,
       programming_language_key,
       solving,
       title,
       description,
       template
FROM solved_objective
         INNER JOIN objective o on o.id = solved_objective.objective_id;

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

CREATE PROCEDURE create_person(
    name_arg VARCHAR(40),
    email_arg VARCHAR(255),
    phone_number_arg CHAR(15),
    birthday_arg DATE
)
AS
$$
DECLARE
    person_id INT;
BEGIN
    INSERT INTO person(name, email, phone_number)
    VALUES (name_arg, email_arg, phone_number_arg)
    RETURNING id INTO person_id;

    CALL create_person_relations(person_id, birthday_arg);
END
$$ LANGUAGE plpgsql;

CREATE FUNCTION get_person_id(phone_number_arg CHAR(15))
    RETURNS INT
AS
$$
DECLARE
    person_id INT;
BEGIN
    SELECT INTO person_id id
    FROM person
    WHERE person.phone_number = phone_number_arg;
    RETURN person_id;
END
$$ LANGUAGE plpgsql;

CREATE FUNCTION get_person_full_info(person_id INT)
    RETURNS SETOF person_full_info_view
AS
$$
BEGIN
    RETURN QUERY SELECT *
                 FROM person_full_info_view
                 WHERE person_full_info_view.id = person_id;
END
$$ LANGUAGE plpgsql;

CREATE PROCEDURE create_person_relations(person_id_arg INT, birthday_arg DATE)
AS
$$
BEGIN
    INSERT INTO person_public_info(person_id, marital_status_key, sex_key, birthday, city_id, height)
    VALUES (person_id_arg, NULL, NULL, birthday_arg, NULL, NULL);

    INSERT INTO person_filter(person_id, marital_status_key, sex_key, age, city_id, height)
    VALUES (person_id_arg, NULL, NULL, NULL, NULL, NULL);
END ;
$$ LANGUAGE plpgsql;

CREATE FUNCTION select_person_filter(person_id_arg INT)
    RETURNS SETOF person_filter
AS
$$
BEGIN
    RETURN QUERY SELECT person_id,
                        marital_status_key,
                        sex_key,
                        age,
                        city_id,
                        height
                 FROM person_filter
                 WHERE person_filter.person_id = person_id_arg;
END
$$ LANGUAGE plpgsql;

CREATE FUNCTION select_person_interests(person_id_arg INT)
    RETURNS TABLE
            (
                key VARCHAR(40)
            )
AS
$$
DECLARE
BEGIN
    RETURN QUERY
        SELECT interest_key
        FROM person_interest
        WHERE person_interest.person_id = person_id_arg;
END
$$ LANGUAGE plpgsql;

CREATE FUNCTION select_person_locales(person_id_arg INT)
    RETURNS TABLE
            (
                key CHAR(5)
            )
AS
$$
DECLARE
BEGIN
    RETURN QUERY
        SELECT locale_key
        FROM person_locale
        WHERE person_locale.person_id = person_id_arg;
END
$$ LANGUAGE plpgsql;

CREATE FUNCTION select_person_programming_languages(person_id_arg INT)
    RETURNS TABLE
            (
                key VARCHAR(20)
            )
AS
$$
DECLARE
BEGIN
    RETURN QUERY
        SELECT programming_language_key
        FROM person_programming_language
        WHERE person_programming_language.person_id = person_id_arg;
END
$$ LANGUAGE plpgsql;

CREATE FUNCTION select_person_photos(person_id_arg INT)
    RETURNS TABLE
            (
                key BYTEA
            )
AS
$$
DECLARE
BEGIN
    RETURN QUERY
        SELECT photo
        FROM person_photo
        WHERE person_photo.person_id = person_id_arg;
END
$$ LANGUAGE plpgsql;

CREATE FUNCTION select_person_solved_objectives(person_id_arg INT)
    RETURNS SETOF solved_objective_view
AS
$$
DECLARE
BEGIN
    RETURN QUERY SELECT *
                 FROM solved_objective_view
                 WHERE person_id = person_id_arg;
END
$$ LANGUAGE plpgsql;

CREATE PROCEDURE add_person_interest(person_id_arg INT, interest_key_arg VARCHAR(40))
AS
$$
BEGIN
    INSERT INTO person_interest
    VALUES (person_id_arg, interest_key_arg);
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE add_person_programming_language(person_id_arg INT, programming_language_arg VARCHAR(20))
AS
$$
BEGIN
    INSERT INTO person_programming_language
    VALUES (person_id_arg, programming_language_arg);
END;
$$ LANGUAGE plpgsql;

CREATE PROCEDURE add_person_locale(person_id_arg INT, locale CHAR(5))
AS
$$
BEGIN
    INSERT INTO person_locale
    VALUES (person_id_arg, locale);
END;
$$ LANGUAGE plpgsql;

CREATE FUNCTION create_person_relations_trigger()
    RETURNS trigger AS
$$
BEGIN
    --     CALL create_person_relations(NEW.id, NULL);
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER person_insert_trigger
    AFTER INSERT
    ON person
    FOR EACH ROW
EXECUTE PROCEDURE create_person_relations_trigger();

CREATE FUNCTION person_photo_limit_trigger()
    RETURNS trigger AS
$$
BEGIN
    IF ((SELECT count(*) FROM person_photo) = 5) THEN
        RAISE EXCEPTION 'Maximum count of photos is 5!';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER person_photo_limit_trigger
    BEFORE INSERT
    ON person_photo
    FOR EACH ROW
EXECUTE PROCEDURE person_photo_limit_trigger();


CREATE FUNCTION add_person_interest_trigger()
    RETURNS trigger AS
$$
BEGIN
    IF (NEW.interest_key IN (SELECT * FROM select_person_interests(NEW.person_id)))
    THEN
        RAISE EXCEPTION 'Duplicated person interest!';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER person_interest_insert_trigger
    BEFORE INSERT
    ON person_interest
    FOR EACH ROW
EXECUTE PROCEDURE add_person_interest_trigger();


CREATE FUNCTION add_person_programming_language_trigger()
    RETURNS trigger AS
$$
BEGIN
    IF (NEW.programming_language_key IN (SELECT * FROM select_person_programming_languages(NEW.person_id)))
    THEN
        RAISE EXCEPTION 'Duplicated person programming language!';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER person_programming_language_insert_trigger
    BEFORE INSERT
    ON person_programming_language
    FOR EACH ROW
EXECUTE PROCEDURE add_person_programming_language_trigger();


CREATE FUNCTION add_person_locale_trigger()
    RETURNS trigger AS
$$
BEGIN
    IF (NEW.locale_key IN (SELECT * FROM select_person_locales(NEW.person_id)))
    THEN
        RAISE EXCEPTION 'Duplicated person locale!';
    END IF;
    RETURN NEW;
END
$$ LANGUAGE plpgsql;

CREATE TRIGGER person_locale_insert_trigger
    BEFORE INSERT
    ON person_locale
    FOR EACH ROW
EXECUTE PROCEDURE add_person_locale_trigger();