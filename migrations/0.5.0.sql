DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO production_countries (country_id, film_id)
    VALUES (
        i,
        ceil(random() * n)
    );
    i := i + 1;
END LOOP;
END $$;