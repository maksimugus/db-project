DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO rated_films (user_id, film_id, rate, date_of_rating)
    VALUES (
        ceil((i % 100 + random()) * 10000),
        i / 100 + 1,
        ceil(random() * 10),
        TIMESTAMP '2003-11-07' + random() * (CURRENT_DATE - TIMESTAMP '2003-11-07')
    );
    i := i + 1;
END LOOP;
END $$;