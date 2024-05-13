-- Вывести число фильмов, снятых в каждой стране, и их средний рейтинг.
EXPLAIN ANALYSE
WITH
    film_ratings AS (
        SELECT film_id, AVG(rate)::DECIMAL(3, 1) AS rating
        FROM rated_films
        GROUP BY
            film_id
    ),
    films_by_country AS (
        SELECT
            country_id,
            COUNT(*) AS films_number,
            AVG(rating)::DECIMAL(3, 1) AS avg_rating
        FROM
            film_ratings
            JOIN production_countries USING (film_id)
        GROUP BY
            country_id
    )
SELECT name, films_number, avg_rating
FROM
    films_by_country
    RIGHT JOIN countries ON country_id = id