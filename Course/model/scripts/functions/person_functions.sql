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

