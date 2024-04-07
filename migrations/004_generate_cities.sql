DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO cities (name, country_id)
    VALUES (
        'city' || i,
        ceil(random() * n)
    );
    i := i + 1;
END LOOP;
END $$;