-- Should fail
CALL add_person_interest(1, 'tennis');
CALL add_person_interest(1, 'football');
CALL add_person_interest(1, 'basketball');
CALL add_person_interest(1, 'racing');

SELECT * FROM select_person_interests(1);
TRUNCATE person_interest;

-- Should fail
CALL add_person_locale(1, 'be_BY');
CALL add_person_locale(1, 'en_US');
CALL add_person_locale(1, 'ru_RU');
CALL add_person_locale(1, 'be_BY');

SELECT * FROM select_person_locales(1);
TRUNCATE person_locale;

-- Should fail
CALL add_person_programming_language(1, 'java');
CALL add_person_programming_language(1, 'kotlin');
CALL add_person_programming_language(1, 'c');
CALL add_person_programming_language(1, 'java');

SELECT * FROM select_person_programming_languages(1);
TRUNCATE person_programming_language;