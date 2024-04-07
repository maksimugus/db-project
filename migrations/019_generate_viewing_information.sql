-- Active: 1711916919543@@127.0.0.1@5432@kinopoisk
DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO viewing_information (user_id, film_id, last_viewing_date, timestamp_of_view_ending)
    VALUES (
        i / 100 + 1,
        ceil((i % 100 + random()) * 10000),
        TIMESTAMP '2003-11-07' + random() * (CURRENT_DATE - TIMESTAMP '2003-11-07'),
        TIMESTAMP '00:00:00' + random() * TIMESTAMP '02:00:00'
    );
    i := i + 1;
END LOOP;
END $$;