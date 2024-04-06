CREATE TABLE countries (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE cities (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    country_id INT NOT NULL REFERENCES countries(id)
);

CREATE TABLE films (
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

CREATE TABLE production_countries (
    film_id INT NOT NULL REFERENCES films(id),
    country_id INT NOT NULL REFERENCES countries(id),
    PRIMARY KEY(film_id, country_id)
);

CREATE TABLE genres (
    film_id INT NOT NULL REFERENCES films(id),
    genre genre NOT NULL
);

CREATE TABLE tops (
    name VARCHAR(150) NOT NULL,
    film_id INT NOT NULL REFERENCES films(id),
    number_in_the_top INT NOT NULL,
    PRIMARY KEY(name, film_id)
);

CREATE TABLE persons (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    first_name VARCHAR(106) NOT NULL,
    last_name VARCHAR(107) NOT NULL,
    sex CHAR(1) NOT NULL,
    height INT NOT NULL,
    date_of_birth DATE NOT NULL,
    city_of_birth_id INT NOT NULL REFERENCES cities(id),
    date_of_death DATE,
    partner_id INT
);

CREATE TABLE producers (
    person_id INT NOT NULL REFERENCES persons(id),
    film_id INT NOT NULL REFERENCES films(id),
    PRIMARY KEY(person_id, film_id)
);

CREATE TABLE directors (
    person_id INT NOT NULL REFERENCES persons(id),
    film_id INT NOT NULL REFERENCES films(id),
    PRIMARY KEY(person_id, film_id)
);

CREATE TABLE artists (
    person_id INT NOT NULL REFERENCES persons(id),
    film_id INT NOT NULL REFERENCES films(id),
    PRIMARY KEY(person_id, film_id)
);

CREATE TABLE operators (
    person_id INT NOT NULL REFERENCES persons(id),
    film_id INT NOT NULL REFERENCES films(id),
    PRIMARY KEY(person_id, film_id)
);

CREATE TABLE writers (
    person_id INT NOT NULL REFERENCES persons(id),
    film_id INT NOT NULL REFERENCES films(id),
    PRIMARY KEY(person_id, film_id)
);

CREATE TABLE composers (
    person_id INT NOT NULL REFERENCES persons(id),
    film_id INT NOT NULL REFERENCES films(id),
    PRIMARY KEY(person_id, film_id)
);

CREATE TABLE actors (
    person_id INT NOT NULL REFERENCES persons(id),
    film_id INT NOT NULL REFERENCES films(id),
    PRIMARY KEY(person_id, film_id)
);

CREATE TABLE users (
    id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
    nickname VARCHAR(80) NOT NULL,
    first_name VARCHAR(106),
    last_name VARCHAR(107),
    email_address VARCHAR(320) NOT NULL,
    sex CHAR(1),
    date_of_birth DATE,
    city_id INT NULL
);

CREATE TABLE reviews (
    user_id INT NOT NULL REFERENCES users(id),
    film_id INT NOT NULL REFERENCES films(id),
    text TEXT NULL,
    type review_type NOT NULL,
    PRIMARY KEY(user_id, film_id)
);

CREATE TABLE favourite_films (
    user_id INT NOT NULL REFERENCES users(id),
    film_id INT NOT NULL REFERENCES films(id),
    date_of_addition DATE NOT NULL,
    PRIMARY KEY(user_id, film_id)
);

CREATE TABLE rated_films (
    user_id INT NOT NULL REFERENCES users(id),
    film_id INT NOT NULL REFERENCES films(id),
    rate SMALLINT NOT NULL,
    date_of_rating TIMESTAMP,
    PRIMARY KEY(user_id, film_id)
);

CREATE TABLE viewing_information (
    user_id INT NOT NULL REFERENCES users(id),
    film_id INT NOT NULL REFERENCES films(id),
    last_viewing_date DATE NOT NULL,
    timestamp TIME NOT NULL,
    PRIMARY KEY(user_id, film_id)
);