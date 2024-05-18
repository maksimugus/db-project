-- Вывести название фильма; число всех людей, работавших над ним;
-- жанр; среднюю оценку; страну производства; количество рецензий.
EXPLAIN ANALYSE
WITH
    all_persons AS (
        SELECT *
        FROM producers
        UNION
        SELECT *
        FROM directors
        UNION
        SELECT *
        FROM artists
        UNION
        SELECT *
        FROM operators
        UNION
        SELECT *
        FROM writers
        UNION
        SELECT *
        FROM composers
        UNION
        SELECT *
        FROM actors
    ),
    film_ratings AS (
        SELECT film_id, AVG(rate)::DECIMAL(3, 1) AS rating
        FROM rated_films
        GROUP BY
            film_id
    )
SELECT
    f.name,
    (
        SELECT COUNT(*)
        FROM all_persons ap
        WHERE
            ap.film_id = f.id
    ) AS "filming group quantity",
    genre,
    c.name AS "country",
    rating,
    (
        SELECT COUNT(*)
        FROM reviews r
        WHERE
            r.film_id = f.id
    )
FROM
    films f
    JOIN genres g ON f.id = g.film_id
    JOIN production_countries pc ON f.id = pc.film_id
    JOIN countries c ON pc.country_id = c.id
    LEFT JOIN film_ratings fr ON f.id = fr.film_id
WHERE
    f.id = 1341