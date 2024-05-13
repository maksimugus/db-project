-- Active: 1711916919543@@127.0.0.1@5432@kinopoisk@public
-- Вывести топ 10 фильмов для каждого жанра по средней оценке.
WITH
    film_ratings AS (
        SELECT film_id, AVG(rate)::DECIMAL(3, 1) AS rating
        FROM rated_films
        GROUP BY
            film_id
    ),
    top_films_in_genre AS (
        SELECT *, row_number() OVER w AS rn
        FROM film_ratings
            JOIN genres USING (film_id)
        WINDOW w AS (
                PARTITION BY
                    genre
                ORDER BY rating DESC
            )
    )
SELECT genre, name, rating
FROM
    top_films_in_genre
    JOIN films ON id = film_id
WHERE
    rn <= 10