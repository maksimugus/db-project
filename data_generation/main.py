from operator import ge
import psycopg2
from psycopg2.extras import execute_batch
import sys, argparse

import mimesis
import random

from utils import run

parser = argparse.ArgumentParser()

parser.add_argument("--user", "-u", required=True)
parser.add_argument("--password", "-p", required=True)
parser.add_argument("--database", "-d", required=True)
parser.add_argument("--host", "-H", default="localhost")
parser.add_argument("--port", "-P", default="5432")
parser.add_argument("--count", "-c", default=1000000)
parser.add_argument("--batch_size", "-b", default=10000)

args = parser.parse_args()

user = args.user
password = args.password
database = args.database
host = args.host
port = args.port
batch_size = int(args.batch_size)
count = int(args.count)


@run
def generate_countries(cur, table, conn):
    address = mimesis.Address()
    countries = [(address.country()) for _ in range(count)]
    execute_batch(cur, f"INSERT INTO {table} (name) VALUES (%s)", countries, page_size=batch_size)


@run
def generate_cities(cur, table, conn):
    address = mimesis.Address()
    cities = [(address.city(), random.randint(1, count)) for _ in range(count)]
    execute_batch(cur, f"INSERT INTO {table} (name, country_id) VALUES (%s, %s)", cities, page_size=batch_size)


@run
def generate_films(cur, table, conn):
    text = mimesis.Text()
    datetime = mimesis.Datetime()
    year_of_production = datetime.year(minimum=2000, maximum=2020)
    world_premiere = datetime.date(start=year_of_production)
    films = [(text.title(), year_of_production, text.quote(), random.randint(10 ** 6, 10 ** 9),
              random.randint(10 ** 6, 10 ** 10), world_premiere, datetime.date(start=world_premiere.year),
              datetime.formatted_time()) for _ in range(count)]
    execute_batch(cur,
                  f"INSERT INTO {table} (name, year_of_production, slogan, budget, world_fees, world_primiere, "
                  f"primiere_in_russia, duration) VALUES (%s, %s, %s, %s)",
                  films, page_size=batch_size)


@run
def generate_production_countries(cur, table, conn):
    production_countries = [(i, random.randint(1, count)) for i in range(1, count + 1)]
    random.shuffle(production_countries)
    execute_batch(cur, f"INSERT INTO {table} (film_id, country_id) VALUES (%s, %s)", production_countries,
                  page_size=batch_size)


@run
def generate_genres(cur, table, conn, genres):
    film_genres = [(i, random.choice(genres)) for i in range(1, count + 1)]
    random.shuffle(film_genres)
    execute_batch(cur, f"INSERT INTO {table} (film_id, genre) VALUES (%s, %s)", film_genres, page_size=batch_size)


@run
def generate_tops(cur, table, conn):
    text = mimesis.Text()
    tops_number = random.randint(1, count)
    tops_names = [text.title() for _ in range(tops_number)]
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
    execute_batch(cur, f"INSERT INTO {table} (name, film_id, number_in_the_top) VALUES (%s, %s, %s)", tops,
                  page_size=batch_size)


@run
def generate_persons(cur, table, conn):
    person = mimesis.Person()
    persons = []
    for _ in range(count):
        sex = random.choice(['male', 'female'])
        g = mimesis.Gender(sex)
        persons.append((person.first_name(gender=g), person.last_name(gender=g),
                        sex[:1].upper(), person.height(), person.birthdate(min_year=1924, max_year=1999),
                        random.randint(1, count)))
    execute_batch(cur,
                  f"INSERT INTO {table} (first_name, last_name, sex, height, date_of_birth, city_of_birth_id,"
                  f" date_of_death, partner_id) VALUES (%s, %s, %s, %s, %s, %s, NULL, NULL)",
                  persons, page_size=batch_size)


@run
def generate_careers(cur, table, conn):
    producers = [(i, random.randint(1, count)) for i in range(1, count + 1)]
    random.shuffle(producers)
    execute_batch(cur, f"INSERT INTO {table} (person_id, film_id) VALUES (%s, %s)", producers, page_size=batch_size)


@run
def generate_users(cur, table, conn):
    person = mimesis.Person()
    users = []
    for _ in range(count):
        sex = random.choice(['male', 'female'])
        g = mimesis.Gender(sex)
        users.append((person.username(), person.first_name(gender=g), person.last_name(gender=g),
                      person.email(), sex[:1].upper(), person.birthdate(min_year=1924, max_year=1999),
                      random.randint(1, count)))
    execute_batch(cur,
                  f"INSERT INTO {table} (nickname, first_name, last_name, email_address, sex, date_of_birth, city_id)"
                  f" VALUES (%s, %s, %s, %s, %s, %s, %s)",
                  users, page_size=batch_size)


@run
def generate_reviews(cur, table, conn, review_types):
    text = mimesis.Text()
    reviews = [(i, random.randint(1, count), text.text(), random.choice(review_types)) for i in range(count)]
    execute_batch(cur, f"INSERT INTO {table} (user_id, film_id, review_text, review_type) VALUES (%s, %s, %s, %s)",
                  reviews, page_size=batch_size)


@run
def generate_favourite_films(cur, table, conn):
    datetime = mimesis.Datetime()
    favourite_films = [(random.randint(1, count), i, datetime.date()) for i in range(1, count + 1)]
    random.shuffle(favourite_films)
    execute_batch(cur, f"INSERT INTO {table} (user_id, film_id, date_of_addition) VALUES (%s, %s)", favourite_films,
                  page_size=batch_size)


@run
def generate_rated_films(cur, table, conn):
    rated_films = [(i, random.randint(1, count), random.randint(1, 10)) for i in range(1, count + 1)]
    random.shuffle(rated_films)
    execute_batch(cur, f"INSERT INTO {table} (user_id, film_id, rate, date_of_rating) VALUES (%s, %s, %s, %s)",
                  rated_films, page_size=batch_size)


@run
def generate_viewing_information(cur, table, conn):
    datetime = mimesis.Datetime()
    viewing_information = [(i, random.randint(1, count), datetime.date(start=2021), datetime.formatted_time())
                           for i in range(1, count + 1)]
    random.shuffle(viewing_information)
    execute_batch(cur,
                  f"INSERT INTO {table} (user_id, film_id, date_of_viewing, time_of_viewing) VALUES (%s, %s, %s, %s)",
                  viewing_information, page_size=batch_size)
    

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
            genres = ["action", "comedy", "drama", "fantasy", "horror", "mystery", "romance", "sci-fi", "thriller"]
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
            review_types = ["positive", "neutral", "negative"]
            generate_reviews(cursor, "reviews", connection, review_types)
            generate_favourite_films(cursor, "favourite_films", connection)
            generate_rated_films(cursor, "rated_films", connection)
            generate_viewing_information(cursor, "viewing_information", connection)
            print("Data generated")
except Exception as e:
    print("Error: ", e)
    sys.exit(1)
