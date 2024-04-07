DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO production_countries (country_id, film_id)
    VALUES (
        1 + random() * (n - 1),
        1 + random() * (n - 1)
    );
    i := i + 1;
END LOOP;
END $$;