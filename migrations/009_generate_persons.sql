-- Active: 1711916919543@@127.0.0.1@5432@kinopoisk
DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
    date_of_birth DATE;
BEGIN
WHILE i <= n LOOP
    date_of_birth := TIMESTAMP '1900-01-01' + random() * (CURRENT_DATE - TIMESTAMP '1900-01-01');
    INSERT INTO persons (first_name, last_name, sex, height, date_of_birth, city_of_birth_id, date_of_death, partner_id)
    VALUES (
        'Firstname' || i,
        'Lastname' || i,
        CASE round(random())
            WHEN 0 THEN 'M'
            WHEN 1 THEN 'F'
        END,
        100 * (1 + random()),
        date_of_birth,
        1 + random() * (n - 1),
        CASE round(random())
            WHEN 0 THEN date_of_birth + random() * INTERVAL '1 year'
            WHEN 1 THEN NULL
        END,
        NULL
    );
    i := i + 1;
END LOOP;
END $$;