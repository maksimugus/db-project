CREATE TABLE IF NOT EXISTS countries (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS cities (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    country_id INT NOT NULL REFERENCES countries (id)
);

CREATE TABLE IF NOT EXISTS films (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(200),
    year_of_production INT,
    slogan TEXT,
    budget MONEY,
    world_fees MONEY,
    world_primiere DATE,
    primiere_in_russia DATE,
    duration TIME
);

CREATE TABLE IF NOT EXISTS production_countries (
    film_id INT NOT NULL REFERENCES films (id),
    country_id INT NOT NULL REFERENCES countries (id),
    PRIMARY KEY (film_id, country_id)
);

CREATE TABLE IF NOT EXISTS genres (
    film_id INT NOT NULL REFERENCES films (id),
    genre genre NOT NULL
);

CREATE TABLE IF NOT EXISTS tops (
    name VARCHAR(150) NOT NULL,
    film_id INT NOT NULL REFERENCES films (id),
    number_in_the_top INT NOT NULL,
    PRIMARY KEY (name, film_id)
);

CREATE TABLE IF NOT EXISTS persons (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(106) NOT NULL,
    last_name VARCHAR(107) NOT NULL,
    sex CHAR(1) NOT NULL,
    height INT NOT NULL,
    date_of_birth DATE NOT NULL,
    city_of_birth_id INT NOT NULL REFERENCES cities (id),
    date_of_death DATE,
    partner_id INT REFERENCES persons (id)
);

CREATE TABLE IF NOT EXISTS producers (
    person_id INT NOT NULL REFERENCES persons (id),
    film_id INT NOT NULL REFERENCES films (id),
    PRIMARY KEY (person_id, film_id)
);

CREATE TABLE IF NOT EXISTS directors (
    person_id INT NOT NULL REFERENCES persons (id),
    film_id INT NOT NULL REFERENCES films (id),
    PRIMARY KEY (person_id, film_id)
);

CREATE TABLE IF NOT EXISTS artists (
    person_id INT NOT NULL REFERENCES persons (id),
    film_id INT NOT NULL REFERENCES films (id),
    PRIMARY KEY (person_id, film_id)
);

CREATE TABLE IF NOT EXISTS operators (
    person_id INT NOT NULL REFERENCES persons (id),
    film_id INT NOT NULL REFERENCES films (id),
    PRIMARY KEY (person_id, film_id)
);

CREATE TABLE IF NOT EXISTS writers (
    person_id INT NOT NULL REFERENCES persons (id),
    film_id INT NOT NULL REFERENCES films (id),
    PRIMARY KEY (person_id, film_id)
);

CREATE TABLE IF NOT EXISTS composers (
    person_id INT NOT NULL REFERENCES persons (id),
    film_id INT NOT NULL REFERENCES films (id),
    PRIMARY KEY (person_id, film_id)
);

CREATE TABLE IF NOT EXISTS actors (
    person_id INT NOT NULL REFERENCES persons (id),
    film_id INT NOT NULL REFERENCES films (id),
    PRIMARY KEY (person_id, film_id)
);

CREATE TABLE IF NOT EXISTS users (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nickname VARCHAR(80) NOT NULL,
    first_name VARCHAR(106),
    last_name VARCHAR(107),
    email_address VARCHAR(320) NOT NULL,
    sex CHAR(1),
    date_of_birth DATE,
    city_id INT REFERENCES cities (id)
);

CREATE TABLE IF NOT EXISTS reviews (
    user_id INT NOT NULL REFERENCES users (id),
    film_id INT NOT NULL REFERENCES films (id),
    review_text TEXT NULL,
    review_type review_type NOT NULL,
    PRIMARY KEY (user_id, film_id)
);

CREATE TABLE IF NOT EXISTS favourite_films (
    user_id INT NOT NULL REFERENCES users (id),
    film_id INT NOT NULL REFERENCES films (id),
    date_of_addition DATE NOT NULL,
    PRIMARY KEY (user_id, film_id)
);

CREATE TABLE IF NOT EXISTS rated_films (
    user_id INT NOT NULL REFERENCES users (id),
    film_id INT NOT NULL REFERENCES films (id),
    rate SMALLINT NOT NULL,
    date_of_rating DATE NOT NULL,
    PRIMARY KEY (user_id, film_id)
);

CREATE TABLE IF NOT EXISTS viewing_information (
    user_id INT NOT NULL REFERENCES users (id),
    film_id INT NOT NULL REFERENCES films (id),
    last_viewing_date DATE NOT NULL,
    timestamp_of_view_ending TIME NOT NULL,
    PRIMARY KEY (user_id, film_id)
);