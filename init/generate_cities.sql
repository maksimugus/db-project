DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO cities (name, country_id)
    VALUES (
        'city' || i,
        1 + random() * 999999
    );
    i := i + 1;
END LOOP;
END $$;