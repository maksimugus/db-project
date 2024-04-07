DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO artists (person_id, film_id)
    VALUES (
        i / 100 + 1,
        ceil((i % 100 + random()) * 10000)
    );
    i := i + 1;
END LOOP;
END $$;