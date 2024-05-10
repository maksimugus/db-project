-- Active: 1711916919543@@127.0.0.1@5432@kinopoisk@public
-- Вывести топ 250 фильмов по оценке.
WITH film_ratings AS (
    SELECT film_id AS id, AVG(rate)::DECIMAL(3,1) AS rating
    FROM rated_films
    GROUP BY film_id
    ORDER BY rating DESC
    FETCH FIRST 250 ROWS ONLY
)
SELECT name AS "Film name", rating AS "Rating"
FROM films RIGHT JOIN film_ratings USING (id)