-- Вывести число фильмов, снятых в каждой стране, и их средний рейтинг.
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
            production_countries
            JOIN film_ratings USING (film_id)
        GROUP BY
            country_id
    )
SELECT name, films_number, avg_rating
FROM
    countries
    LEFT JOIN films_by_country ON id = country_id