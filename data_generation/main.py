import psycopg2
from psycopg2.extras import execute_batch
from os import getenv
import mimesis
import random

from utils import run


database = getenv('POSTGRES_DB')
user = getenv('POSTGRES_USER')
password = getenv('POSTGRES_PASSWORD')
host = getenv('POSTGRES_HOST', 'postgres')
port = getenv('POSTGRES_PORT', 5432)
count = int(getenv('COUNT', 1000000))
batch_size = int(getenv('BATCH_SIZE', 10000))


@run
def generate_countries(cursor, table_name, connection):
    address = mimesis.Address()
    countries = [(address.country(),) for _ in range(count)]
    execute_batch(cursor, f"INSERT INTO {table_name} (name) VALUES (%s)", countries, page_size=batch_size)


@run
def generate_cities(cursor, table_name, connection):
    address = mimesis.Address()
    cities = [(address.city(), random.randint(1, count)) for _ in range(count)]
    execute_batch(cursor, f"INSERT INTO {table_name} (name, country_id) VALUES (%s, %s)", cities, page_size=batch_size)


@run
def generate_films(cursor, table_name, connection):
    text = mimesis.Text()
    datetime = mimesis.Datetime()
    year_of_production = datetime.year(minimum=1950, maximum=2000)
    world_premiere = datetime.date(start=year_of_production)
    films = [(text.title()[:150], year_of_production, text.quote(), random.randint(10 ** 6, 10 ** 9),
              random.randint(10 ** 6, 10 ** 10), world_premiere, datetime.date(start=world_premiere.year),
              datetime.formatted_time()) for _ in range(count)]
    execute_batch(cursor,
                  f"INSERT INTO {table_name} (name, year_of_production, slogan, budget, world_fees, world_primiere, "
                  f"primiere_in_russia, duration) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)",
                  films, page_size=batch_size)


@run
def generate_production_countries(cursor, table_name, connection):
    production_countries = [(i, random.randint(1, count)) for i in range(1, count + 1)]
    random.shuffle(production_countries)
    execute_batch(cursor, f"INSERT INTO {table_name} (film_id, country_id) VALUES (%s, %s)", production_countries,
                  page_size=batch_size)


@run
def generate_genres(cursor, table_name, connection, genres):
    film_genres = [(i, random.choice(genres)) for i in range(1, count + 1)]
    random.shuffle(film_genres)
    execute_batch(cursor, f"INSERT INTO {table_name} (film_id, genre) VALUES (%s, %s)", film_genres, page_size=batch_size)


@run
def generate_tops(cursor, table_name, connection):
    text = mimesis.Text()
    tops_number = random.randint(1, count)
    tops_names = [text.title()[:150] for _ in range(tops_number)]
    last_film_numbers = {}
    for name in tops_names:
        last_film_numbers[name] = 0
    tops = []
    for i in range(1, count + 1):
        name = random.choice(tops_names)
        number_in_the_top = last_film_numbers[name] + 1
        last_film_numbers[name] = number_in_the_top
        tops.append((name, i, number_in_the_top))
    random.shuffle(tops)
    execute_batch(cursor, f"INSERT INTO {table_name} (name, film_id, number_in_the_top) VALUES (%s, %s, %s)", tops,
                  page_size=batch_size)


@run
def generate_persons(cursor, table_name, connection):
    person = mimesis.Person()
    persons = []
    for _ in range(count):
        sex = random.choice(['male', 'female'])
        g = mimesis.Gender(sex)
        persons.append((person.first_name(gender=g), person.last_name(gender=g),
                        sex[:1].upper(), int(float(person.height())*100), person.birthdate(min_year=1924, max_year=1949),
                        random.randint(1, count)))
    execute_batch(cursor,
                  f"INSERT INTO {table_name} (first_name, last_name, sex, height, date_of_birth, city_of_birth_id,"
                  f" date_of_death, partner_id) VALUES (%s, %s, %s, %s, %s, %s, NULL, NULL)",
                  persons, page_size=batch_size)


@run
def generate_careers(cursor, table_name, connection):
    producers = [(i, random.randint(1, count)) for i in range(1, count + 1)]
    random.shuffle(producers)
    execute_batch(cursor, f"INSERT INTO {table_name} (person_id, film_id) VALUES (%s, %s)", producers, page_size=batch_size)


@run
def generate_users(cursor, table_name, connection):
    person = mimesis.Person()
    users = []
    for _ in range(count):
        sex = random.choice(['male', 'female'])
        g = mimesis.Gender(sex)
        users.append((person.username(), person.first_name(gender=g), person.last_name(gender=g),
                      person.email(), sex[:1].upper(), person.birthdate(min_year=2001, max_year=2015),
                      random.randint(1, count)))
    execute_batch(cursor,
                  f"INSERT INTO {table_name} (nickname, first_name, last_name, email_address, sex, date_of_birth, city_id)"
                  f" VALUES (%s, %s, %s, %s, %s, %s, %s)", users, page_size=batch_size)


@run
def generate_reviews(cursor, table_name, connection, review_types):
    text = mimesis.Text()
    reviews = [(i, random.randint(1, count), text.text(), random.choice(review_types)) for i in range(1, count + 1)]
    execute_batch(cursor, f"INSERT INTO {table_name} (user_id, film_id, review_text, review_type) VALUES (%s, %s, %s, %s)",
                  reviews, page_size=batch_size)


@run
def generate_favourite_films(cursor, table_name, connection):
    datetime = mimesis.Datetime()
    favourite_films = [(random.randint(1, count), i, datetime.date(start=2016)) for i in range(1, count + 1)]
    random.shuffle(favourite_films)
    execute_batch(cursor, f"INSERT INTO {table_name} (user_id, film_id, date_of_addition) VALUES (%s, %s, %s)", favourite_films,
                  page_size=batch_size)


@run
def generate_rated_films(cursor, table_name, connection):
    datetime = mimesis.Datetime()
    rated_films = [(i, random.randint(1, count), random.randint(1, 10), datetime.date(start=2016)) for i in range(1, count + 1)]
    random.shuffle(rated_films)
    execute_batch(cursor, f"INSERT INTO {table_name} (user_id, film_id, rate, date_of_rating) VALUES (%s, %s, %s, %s)",
                  rated_films, page_size=batch_size)


@run
def generate_viewing_information(cursor, table_name, connection):
    datetime = mimesis.Datetime()
    viewing_information = [(i, random.randint(1, count), datetime.date(start=2016), datetime.formatted_time())
                           for i in range(1, count + 1)]
    random.shuffle(viewing_information)
    execute_batch(cursor,
                  f"INSERT INTO {table_name} (user_id, film_id, last_viewing_date, timestamp_of_view_ending) VALUES (%s, %s, %s, %s)",
                  viewing_information, page_size=batch_size)


def get_enum_values(cursor, enum_name):
    cursor.execute(f"SELECT unnest(enum_range(null::{enum_name}))")
    tmp = cursor.fetchall()
    if not tmp:
        raise Exception(f"No {enum_name} found")
    return tmp

try:
    with psycopg2.connect(
            user=user,
            password=password,
            host=host,
            port=port,
            database=database
    ) as connection:
        with connection.cursor() as cursor:
            print("Data generation started")
            generate_countries(cursor, "countries", connection)
            generate_cities(cursor, "cities", connection)
            generate_films(cursor, "films", connection)
            generate_production_countries(cursor, "production_countries", connection)
            genres = get_enum_values(cursor, "genre")
            generate_genres(cursor, "genres", connection, genres)
            generate_tops(cursor, "tops", connection)
            generate_persons(cursor, "persons", connection)
            generate_careers(cursor, "producers", connection)
            generate_careers(cursor, "directors", connection)
            generate_careers(cursor, "artists", connection)
            generate_careers(cursor, "operators", connection)
            generate_careers(cursor, "writers", connection)
            generate_careers(cursor, "composers", connection)
            generate_careers(cursor, "actors", connection)
            generate_users(cursor, "users", connection)
            review_types = get_enum_values(cursor, "review_type")
            generate_reviews(cursor, "reviews", connection, review_types)
            generate_favourite_films(cursor, "favourite_films", connection)
            generate_rated_films(cursor, "rated_films", connection)
            generate_viewing_information(cursor, "viewing_information", connection)
            print("Data generated")
except Exception as e:
    print("Error: ", str(e)[:100])
    exit(1)
