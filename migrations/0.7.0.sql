DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO tops (name, film_id, number_in_the_top)
    VALUES (
        'top' || (i / 1000 + 1),
        ceil((i % 1000 + random()) * 1000),
        i % 1000 + 1
    );
    i := i + 1;
END LOOP;
END $$;