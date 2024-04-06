DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO users (nickname, first_name, last_name, email_address, sex, date_of_birth, city_id)
    VALUES (
        'clone' || i,
        'Jango' || i,
        'Fett' || i,
        'clone' || i || '@mail.ru',
        CASE round(random())
            WHEN 0 THEN 'M'
            WHEN 1 THEN 'F'
        END,
        TIMESTAMP '1900-01-01' + random() * (TIMESTAMP '2024-04-06' - TIMESTAMP '1900-01-01'),
        1 + random() * 999999
    );
    i := i + 1;
END LOOP;
END $$;
