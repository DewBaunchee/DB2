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