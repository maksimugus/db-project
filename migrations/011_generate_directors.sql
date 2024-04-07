DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO directors (person_id, film_id)
    VALUES (
        i / 10000 + 1,
        (i % 100 + random()) * 10000
    );
    i := i + 1;
END LOOP;
END $$;