INSERT INTO programming_language
VALUES ('java'),
       ('c_plus_plus'),
       ('c_sharp'),
       ('delphi'),
       ('pascal'),
       ('visual_basic'),
       ('kotlin'),
       ('sql'),
       ('python'),
       ('c');

INSERT INTO locale
VALUES ('ru_RU', 'Russian'),
       ('en_US', 'English (USA)'),
       ('en_GB', 'English (Great Britain)'),
       ('be_BY', 'Belarusian'),
       ('eu_ES', 'Basque (Spain)'),
       ('da', 'Danish'),
       ('cs', 'Czech'),
       ('fr_FR', 'France'),
       ('de_DE', 'Germany'),
       ('el', 'Greek');

CALL add_interest('tennis', 'sport');
CALL add_interest('football', 'sport');
CALL add_interest('basketball', 'sport');
CALL add_interest('ping_pong', 'sport');
CALL add_interest('biathlon', 'sport');
CALL add_interest('travelling', 'time_spending');
CALL add_interest('computer_games', 'time_spending');
CALL add_interest('racing', 'extreme');
CALL add_interest('surfing', 'extreme');
CALL add_interest('parkour', 'extreme');

INSERT INTO sex
VALUES ('male'),
       ('female');

INSERT INTO country
VALUES ('AND', 'Andorra', 'The Principality of Andorra', '376'),
       ('AUT', 'Austria', 'The Republic of Austria', '43'),
       ('BLR', 'Belarus', 'The Republic of Belarus', '375'),
       ('BEL', 'Belgium', 'The Kingdom of Belgium', '32'),
       ('CAN', 'Canada', 'Canada', '1'),
       ('CHN', 'China', 'The People''s Republic of China', '86'),
       ('CUB', 'Cuba', 'The Republic of Cuba', '53'),
       ('FRA', 'France', 'The French Republic', '33'),
       ('RUS', 'Russian Federation', 'The Russian Federation', '7'),
       ('USA', 'United States of America', 'The United States of America', '1');

INSERT INTO region
VALUES ('mogilev.region', 'Могилевская Область', 'BLR'),
       ('grodno.region', 'Гродненская Область', 'BLR'),
       ('vitebsk.region', 'Витебская Область', 'BLR'),
       ('brest.region', 'Бресткая Область', 'BLR'),
       ('minsk.region', 'Минская Область', 'BLR'),
       ('gomel.region', 'Гомельская Область', 'BLR'),
       ('minsk', 'Минск', 'BLR');

CALL add_city('Могилев', 'mogilev.region', 53.894549, 30.330654);
CALL add_city('Гродно', 'grodno.region', 53.677839, 23.829529);
CALL add_city('Витебск', 'vitebsk.region', 55.184217, 30.202878);
CALL add_city('Брест', 'brest.region', 52.093754, 23.685107);
CALL add_city('Минск', 'minsk', 53.902284, 27.561831);
CALL add_city('Гомель', 'gomel.region', 52.424160, 31.014281);
CALL add_city('Солигорск', 'minsk.region', 52.792919, 27.543748);
CALL add_city('Старобин', 'minsk.region', 52.730060, 27.451805);
CALL add_city('Полоцк', 'vitebsk.region', 55.485576, 28.768349);
CALL add_city('Орша', 'vitebsk.region', 54.510741, 30.429586);
CALL add_city('Бобруйск', 'mogilev.region', 53.145597, 29.225538);

INSERT INTO group_type
VALUES ('private');

INSERT INTO objective (title, description, template)
VALUES ('Find min', 'Find min description', 'Find min template'),
       ('Find max', 'Find max description', 'Find max template'),
       ('Sort', 'Sort description', 'Sort template'),
       ('Filter', 'Filter description', 'Filter template'),
       ('Calculate', 'Calculate description', 'Calculate template'),
       ('Map', 'Map description', 'Map template');

CALL create_person('Matt1', 'qwe1@gmail.com', '1', '2002-04-20');
CALL create_person('Matt2', 'qwe2@gmail.com', '2', '2002-04-20');
CALL create_person('Matt3', 'qwe3@gmail.com', '3', '2002-04-20');
CALL create_person('Matt4', 'qwe4@gmail.com', '4', '2002-04-20');
CALL create_person('Matt5', 'qwe5@gmail.com', '5', '2002-04-20');
CALL create_person('Matt6', 'qwe6@gmail.com', '6', '2002-04-20');
CALL create_person('Matt7', 'qwe7@gmail.com', '7', '2002-04-20');
CALL create_person('Matt8', 'qwe8@gmail.com', '8', '2002-04-20');
CALL create_person('Matt9', 'qwe9@gmail.com', '9', '2002-04-20');
CALL create_person('Matt10', 'qwe10@gmail.com', '10', '2002-04-20');
CALL create_person('Matt10', 'qwe11@gmail.com', '11', '2000-04-20');

INSERT INTO solved_objective
VALUES (1, 1, 'java', 'd;sad;sa'),
       (2, 2, 'java', 'bvcbvcbcva'),
       (1, 3, 'java', 'bcvbvcbcvsa');

SELECT * FROM solved_objective_view;