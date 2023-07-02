/* 1. Создать предстваление, позволяющее получать список читателей
   с количеством находящихся у каждого читателя на руках книг,
   но отобращающее только таких читателей, по которым
   имеются задолженности, т.е. на руках у читателя есть хотя
   бы одна книга, которую он должен был вернуть до наступления
   текущей даты */

CREATE OR ALTER VIEW reader_with_book
AS
SELECT s_id, s_name, book_count
FROM subscribers
         JOIN (SELECT sb_subscriber, COUNT(*) as book_count
               FROM subscriptions
               WHERE sb_is_active = 'Y'
               GROUP BY sb_subscriber) as counts ON subscribers.s_id = counts.sb_subscriber
WHERE book_count > 0;

SELECT *
FROM reader_with_book;

/* 5. Создать представление, возвращающее всю информацию из таблицы
   subscriptions, преобразуя даты из полей sb_start и sb_finish
   в формат "ГГГГ-ММ-ДД НН", где "НН" - день недели в виде
   своего полного названия (т.е. "Понедельник", "Вторник" и т.д.)*/

CREATE OR ALTER VIEW modified_date
AS
SELECT sb_id,
       sb_subscriber,
       sb_book,
       CONCAT(CONVERT(varchar, sb_start, 23), ' ', (SELECT CASE DATEPART(dw, sb_start)
                                                               WHEN 1 THEN N'Воскресенье'
                                                               WHEN 2 THEN N'Понедельник'
                                                               WHEN 3 THEN N'Вторник'
                                                               WHEN 4 THEN N'Среда'
                                                               WHEN 5 THEN N'Четверг'
                                                               WHEN 6 THEN N'Пятница'
                                                               WHEN 7 THEN N'Суббота'
                                                               ELSE N'Неизвестно'
                                                               END)) AS sb_start,
       CONCAT(CONVERT(varchar, sb_start, 23), ' ', (SELECT CASE DATEPART(dw, sb_start)
                                                               WHEN 1 THEN N'Воскресенье'
                                                               WHEN 2 THEN N'Понедельник'
                                                               WHEN 3 THEN N'Вторник'
                                                               WHEN 4 THEN N'Среда'
                                                               WHEN 5 THEN N'Четверг'
                                                               WHEN 6 THEN N'Пятница'
                                                               WHEN 7 THEN N'Суббота'
                                                               ELSE N'Неизвестно'
                                                               END)) AS sb_finish,
       sb_is_active
FROM subscriptions;

SELECT *
FROM modified_date;

/* 13. Создать триггер, не позволяющий добавить в базу данных
   информацию о выдаче книги, если выполняется хотя бы одно из условий */

CREATE OR ALTER TRIGGER task_13
    ON subscriptions
    FOR INSERT
    AS
BEGIN
    IF ((SELECT COUNT(*)
         FROM inserted
         WHERE DATEPART(dw, sb_start) = 1
            OR DATEPART(dw, sb_finish = 1)
            OR (SELECT COUNT(*)
                FROM subscriptions as nested
                WHERE nested.sb_start > DATEADD(MONTH, GETDATE(), -6)
                  AND nested.sb_subscriber = inserted.sb_subscriber) > 100
            OR (SELECT COUNT(*)
                FROM subscriptions as nested
                WHERE DATEDIFF(DAY, sb_start, inserted.sb_finish)) < 3) > 0)
        BEGIN
            RAISERROR ('Error', 0, 0)
        END;
END;

/* 14. Создать триггер, не позволяющий
   выдать книгу читателю, у которого на руках
   находится пять и более книг, при условии, что суммарное время,
   оставшееся до возврата всех выданных ему книг, составляет менее
   одного месяца */

    CREATE OR ALTER TRIGGER task_14
        ON subscriptions
        FOR INSERT
        AS
    BEGIN
        IF ((SELECT COUNT(*)
             FROM inserted
             WHERE (SELECT COUNT(*)
                    FROM subscriptions AS nested
                    WHERE nested.sb_is_active = 'Y'
                      AND nested.sb_subscriber = inserted.sb_subscriber) > 4
               AND (SELECT SUM(DATEDIFF(SECOND, GETDATE(), nested.sb_finish)) FROM subscriptions as nested) <
                   30 * 24 * 3600) > 0)
            BEGIN
                RAISERROR ('Error', 0, 0)
            END;
    END;


/* 15. Создать триггер, допускающий регистрацию в библиотеке только таких
   авторов, имя которых не содержит никаких символов кроме букв,
   цифр, знаков - (минус), ' (апостраф) и пробелов (не допускается два и более
   идущих подряд пробела) */

        CREATE OR ALTER TRIGGER task_15
            ON authors
            FOR INSERT
            AS
        BEGIN
            IF ((SELECT COUNT(*)
                 FROM inserted
                 WHERE inserted.a_name NOT LIKE '[\w\d-'' ]*'
                    OR inserted.a_name LIKE '%  %') > 0)
                BEGIN
                    RAISERROR ('Error', 0, 0)
                END;
        END;