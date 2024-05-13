-- Вывести среднее число актёров в каждом фильме каждый год.
WITH
    actors_number_by_film AS (
        SELECT film_id, COUNT(*) AS actors_number
        FROM actors
        GROUP BY
            film_id
    )
SELECT name, year_of_production, AVG(actors_number)
FROM
    films
    JOIN actors_number_by_film ON id = film_id
GROUP BY
    name,
    year_of_production