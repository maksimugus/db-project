DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO favourite_films (user_id, film_id, date_of_addition)
    VALUES (
        i / 10000 + 1,
        (i % 100 + random()) * 10000,
        TIMESTAMP '2003-11-07' + random() * (CURRENT_DATE - TIMESTAMP '2003-11-07')
    );
    i := i + 1;
END LOOP;
END $$;