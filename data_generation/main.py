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
    year_of_production = datetime.year()
    films = [(text.title(), year_of_production, text.quote(), random.randint(10**6, 10**9), random.randint(10**6, 10**10),
               datetime.date(start=year_of_production), datetime.date(start=year_of_production), datetime.formatted_time()) for _ in range(count)]
    execute_batch(cur, f"INSERT INTO {table} (name, year_of_production, slogan, budget, world_fees, world_primiere, primiere_in_russia, duration) 
                  VALUES (%s, %s, %s, %s)", films, page_size=batch_size)

@run
def generate_production_countries(cur, table, conn):
    film_production_countries = [(i, random.randint(1, count)) for i in range(1, count + 1)]
    random.shuffle(film_production_countries)
    execute_batch(cur, f"INSERT INTO {table} (film_id, country_id) VALUES (%s, %s)", film_production_countries, page_size=batch_size)

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
    execute_batch(cur, f"INSERT INTO {table} (name, film_id, number_in_the_top) VALUES (%s, %s, %s)", tops, page_size=batch_size)

@run
def generate_persons(cur, table, conn):
    person = mimesis.Person()
    persons = []
    for _ in range(count):
        sex = person.sex()
        persons.append(person.first_name(gender=sex), person.last_name(gender=sex), 
                       sex[:1], person.height(), person.birthdate(), random.randint(1, count))
    execute_batch(cur, f"INSERT INTO persons (first_name, last_name, sex, height, date_of_birth, city_of_birth_id, date_of_death, partner_id)
                   VALUES (%s, %s, %s, %s, %s, %s, NULL, NULL)", persons, page_size=batch_size)
    
@run
def generate_producers(cur, table, conn):
    producers = [(i, random.randint(1, count)) for i in range(1, count + 1)]
    random.shuffle(producers)
    execute_batch(cur, f"INSERT INTO {table} (person_id, film_id) VALUES (%s, %s)", producers, page_size=batch_size)

@run
def generate_actors(cur, table, conn):
    actors = [(i, random.randint(1, count)) for i in range(1, count + 1)]
    random.shuffle(actors)
    execute_batch(cur, f"INSERT INTO {table} (person_id, film_id) VALUES (%s, %s)", actors, page_size=batch_size)

@run
def generate_directors(cur, table, conn):
    directors = [(i, random.randint(1, count)) for i in range(1, count + 1)]
    random.shuffle(directors)
    execute_batch(cur, f"INSERT INTO {table} (person_id, film_id) VALUES (%s, %s)", directors, page_size=batch_size)

@run
def generate_writers(cur, table, conn):
    writers = [(i, random.randint(1, count)) for i in range(1, count + 1)]
    random.shuffle(writers)
    execute_batch(cur, f"INSERT INTO {table} (person_id, film_id) VALUES (%s, %s)", writers, page_size=batch_size)

@run
def generate_composers(cur, table, conn):
    composers = [(i, random.randint(1, count)) for i in range(1, count + 1)]
    random.shuffle(composers)
    execute_batch(cur, f"INSERT INTO {table} (person_id, film_id) VALUES (%s, %s)", composers, page_size=batch_size)

@run
def generate_operators(cur, table, conn):
    operators = [(i, random.randint(1, count)) for i in range(1, count + 1)]
    random.shuffle(operators)
    execute_batch(cur, f"INSERT INTO {table} (person_id, film_id) VALUES (%s, %s)", operators, page_size=batch_size)

@run
def generate_artists(cur, table, conn):
    artists = [(i, random.randint(1, count)) for i in range(1, count + 1)]
    random.shuffle(artists)
    execute_batch(cur, f"INSERT INTO {table} (person_id, film_id) VALUES (%s, %s)", artists, page_size=batch_size)

@run
def generate_users(cur, table, conn):
    person = mimesis.Person()
    users = []
    for _ in range(count):
        sex = person.sex()
        users.append(person.username(), person.first_name(gender=sex), person.last_name(gender=sex),
                     person.email(), sex[:1], person.birthdate(), random.randint(1, count))
    execute_batch(cur, f"INSERT INTO {table} (nickname, first_name, last_name, email_address, sex, date_of_birth, city_id) 
                   VALUES (%s, %s, %s, %s, %s, %s, %s)", users, page_size=batch_size)