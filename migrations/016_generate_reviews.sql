DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO reviews (user_id, film_id, review_text, review_type)
    VALUES (
        i / 10000 + 1,
        (i % 100 + random()) * 10000,
        'Review text',
        CASE round(random() * 2)
            WHEN 0 THEN 'positive'
            WHEN 1 THEN 'negative'
            WHEN 2 THEN 'neutral'
        END
    );
    i := i + 1;
END LOOP;
END $$;