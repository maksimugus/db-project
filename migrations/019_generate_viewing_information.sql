-- Active: 1711916919543@@127.0.0.1@5432@kinopoisk
DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
    user_id INT;
    film_id INT;
BEGIN
WHILE i <= n LOOP
    user_id := i / 10000 + 1;
    film_id := (i % 100 + random()) * 10000;
    INSERT INTO viewing_information (user_id, film_id, last_viewing_date, timestamp_of_view_ending)
    VALUES (
        user_id,
        film_id,
        TIMESTAMP '2003-11-07' + random() * (CURRENT_DATE - TIMESTAMP '2003-11-07'),
        TIMESTAMP '00:00:00' + random() * TIMESTAMP '02:00:00'
    );
    i := i + 1;
END LOOP;
END $$;