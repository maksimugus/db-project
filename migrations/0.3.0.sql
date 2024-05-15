CREATE TABLE IF NOT EXISTS tmp_films (
    id INT GENERATED ALWAYS AS IDENTITY,
    name VARCHAR(200),
    year_of_production INT,
    slogan TEXT,
    budget MONEY,
    world_fees MONEY,
    world_primiere DATE,
    primiere_in_russia DATE,
    duration TIME
) PARTITION BY LIST (year_of_production);

CREATE TABLE IF NOT EXISTS film_1 PARTITION OF tmp_films FOR VALUES IN ('1');
CREATE TABLE IF NOT EXISTS film_2 PARTITION OF tmp_films FOR VALUES IN ('2');
CREATE TABLE IF NOT EXISTS film_3 PARTITION OF tmp_films FOR VALUES IN ('3');
CREATE TABLE IF NOT EXISTS film_4 PARTITION OF tmp_films FOR VALUES IN ('4');
CREATE TABLE IF NOT EXISTS film_5 PARTITION OF tmp_films FOR VALUES IN ('5');

INSESRT INTO tmp_films SELECT * FROM films;

ALTER TABLE films RENAME TO old_films;
ALTER TABLE tmp_films RENAME TO films;

ALTER TABLE film_1 ADD CONSTRAINT film_1_pkey PRIMARY KEY (id);
ALTER TABLE film_2 ADD CONSTRAINT film_2_pkey PRIMARY KEY (id);
ALTER TABLE film_3 ADD CONSTRAINT film_3_pkey PRIMARY KEY (id);
ALTER TABLE film_4 ADD CONSTRAINT film_4_pkey PRIMARY KEY (id);
ALTER TABLE film_5 ADD CONSTRAINT film_5_pkey PRIMARY KEY (id);