/*
1. Добавить в базу данных информацию о троих новых читателях:
"Орлов О.О.", "Соколов С.С.", "Беркутов Б.Б."
*/

/* ROLLBACK */
DELETE
FROM subscribers
WHERE s_name IN (N'Орлов О.О.',
                 N'Соколов С.С.',
                 N'Беркутов Б.Б.');
/* ROLLBACK END */

INSERT INTO subscribers (s_name)
VALUES (N'Орлов О.О.'),
       (N'Соколов С.С.'),
       (N'Беркутов Б.Б.');

/*
2. Отразить в базе данных информацию о том,
что каждый из троих добавленных читателей
20-го января 2016-го года на месяц взял в
библиотеке книгу «Курс теоретической физики».
*/

/* ROLLBACK */
DELETE
FROM subscriptions
WHERE sb_book = (SELECT b_id FROM books WHERE b_name = N'Курс теоретической физики');
/* ROLLBACK END */

WITH vals as (SELECT (SELECT b_id
                      FROM books
                      WHERE b_name = N'Курс теоретической физики')         as book_id,
                     (SELECT {d '2016-01-20'})                             as start_date,
                     (SELECT DATEADD(MONTH, 1, (SELECT {d '2016-01-20'}))) as finish_date,
                     'Y'                                                   as activity)
INSERT
INTO subscriptions (sb_subscriber, sb_book, sb_start, sb_finish, sb_is_active)
VALUES ((SELECT s_id FROM subscribers WHERE s_name = N'Орлов О.О.'), (SELECT book_id FROM vals),
        (SELECT start_date FROM vals),
        (SELECT finish_date FROM vals),
        (SELECT activity FROM vals)),
       ((SELECT s_id FROM subscribers WHERE s_name = N'Соколов С.С.'), (SELECT book_id FROM vals),
        (SELECT start_date FROM vals),
        (SELECT finish_date FROM vals),
        (SELECT activity FROM vals)),
       ((SELECT s_id FROM subscribers WHERE s_name = N'Беркутов Б.Б.'), (SELECT book_id FROM vals),
        (SELECT start_date FROM vals),
        (SELECT finish_date FROM vals),
        (SELECT activity FROM vals));

/* 5. Для всех выдач, произведённых до 1-го января 2012-го года, уменьшить значение дня выдачи на 3 */
/* ROLLBACK */
UPDATE subscriptions
SET sb_start = DATEADD(DAY, 3, sb_start)
WHERE sb_start < (SELECT {d '2012-01-01'});
/* ROLLBACK END */

UPDATE subscriptions
SET sb_start = DATEADD(DAY, -3, sb_start)
WHERE sb_start < (SELECT {d '2012-01-01'});

/* 8. Удалить все книги, относящиеся к жанру «Классика». */

DELETE
FROM books
WHERE b_id IN (SELECT b_id FROM m2m_books_genres WHERE g_id = (SELECT g_id FROM genres WHERE g_name = N'Классика'))

/* 10. Добавить в базу данных жанры «Политика», «Психология», «История». */

IF NOT EXISTS (SELECT 1 FROM genres WHERE g_name = N'Политика')
BEGIN
    INSERT INTO genres (g_name)VALUES (N'Политика');
END;

IF NOT EXISTS (SELECT 1 FROM genres WHERE g_name = N'Психология')
BEGIN
    INSERT INTO genres (g_name)VALUES (N'Психология');
END;

IF NOT EXISTS (SELECT 1 FROM genres WHERE g_name = N'История')
BEGIN
    INSERT INTO genres (g_name)VALUES (N'История');
END;


