DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO countries (name)
    VALUES (
        'country' || i
    );
    i := i + 1;
END LOOP;
END $$;