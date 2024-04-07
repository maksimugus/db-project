DO $$
DECLARE
    n INT := 1000000;
    i INT := 1;
BEGIN
WHILE i <= n LOOP
    INSERT INTO genres (film_id, genre)
    VALUES (
        1 + random() * (n - 1),
        CASE round(random() * 17)
            WHEN 0 THEN 'action'
            WHEN 1 THEN 'adventure'
            WHEN 2 THEN 'animation'
            WHEN 3 THEN 'comedy'
            WHEN 4 THEN 'crime'
            WHEN 5 THEN 'documentary'
            WHEN 6 THEN 'drama'
            WHEN 7 THEN 'family'
            WHEN 8 THEN 'fantasy'
            WHEN 9 THEN 'historical'
            WHEN 10 THEN 'horror'
            WHEN 11 THEN 'musical'
            WHEN 12 THEN 'mystery'
            WHEN 13 THEN 'romance'
            WHEN 14 THEN 'science'
            WHEN 15 THEN 'thriller'
            WHEN 16 THEN 'war'
            WHEN 17 THEN 'western'
        END::genre
    );
    i := i + 1;
END LOOP;
END $$;