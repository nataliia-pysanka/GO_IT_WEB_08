from os import getenv
from dotenv import load_dotenv
import psycopg2
from psycopg2.extensions import connection as ConnectionType
from faker import Faker
from random import choice


load_dotenv()
POSTGRES_DB = getenv('POSTGRES_DB')
POSTGRES_USER = getenv('POSTGRES_USER')
POSTGRES_PASSWORD = getenv('POSTGRES_PASSWORD')
DB_HOST = getenv('DB_HOST')
DB_PORT = getenv('DB_PORT')


fake = Faker()

GROUPS = []
ID_GROUPS = []
STUDENTS = []
ID_STUDENTS = []
PROFESSORS = []
ID_PROFESSORS = []
SUBJECTS = []
ID_SUBJECTS = []
RATE = []
ID_RATES = []
ST_RATE = []
PR_SUBJECT = []


def db_connect():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            database=POSTGRES_DB,
            user=POSTGRES_USER,
            password=POSTGRES_PASSWORD)
        conn.autocommit = True
        return conn
    except (Exception, psycopg2.DatabaseError) as error:
        print(error)


def drop_tables(con: ConnectionType):
    cursor = con.cursor()
    with open('drop_tables.sql', 'r') as f:
        while True:
            sql = f.readline()
            if not sql:
                break
            cursor.execute(sql)
    con.commit()
    cursor.close()
    print('Tables were dropped')


def create_tables(con: ConnectionType):
    cursor = con.cursor()
    with open('create_tables.sql', 'r') as f:
        while True:
            sql = f.readline()
            if not sql:
                break
            cursor.execute(sql)
    con.commit()
    cursor.close()
    print('Tables were created')


def prepare_group_table(num_group: int):
    groups = []
    num = 0
    while num < num_group:
        name = 'GR-' + fake.aba()[:3]
        description = fake.paragraph(nb_sentences=2)
        created = fake.date_between(start_date='-6y')
        enabled = fake.pybool()
        group = (name, description, created, enabled)
        if group in groups:
            continue
        groups.append(group)
        num += 1
    return groups


def prepare_student_table(num_student: int):
    students = []
    for _ in range(num_student):
        name = fake.first_name()
        surname = fake.last_name()
        date_birth = fake.date_between(start_date='-22y', end_date='-18y')
        id_group = choice(ID_GROUPS)
        students.append((name, surname, date_birth, id_group))
    return students


def prepare_prof_table(num_prof: int):
    professors = []
    num = 0
    while num < num_prof:
        name = fake.name_female()
        surname = fake.last_name()
        date_birth = fake.date_between(start_date='-60y', end_date='-30y')
        title = fake.suffix_female()
        professor = (name, surname, date_birth, title)
        if professor in professors:
            continue
        professors.append(professor)
        num += 1
    return professors


def prepare_subject_table(num_subject: int):
    subjects = []
    num = 0
    while num < num_subject:
        name = fake.catch_phrase()
        description = fake.paragraph(nb_sentences=2)
        subject = (name, description)
        if subject in subjects:
            continue
        subjects.append(subject)
        num += 1
    return subjects


def prepare_rate_table(num_rate: int):
    rates = []
    for num in range(num_rate):
        value = num
        description = fake.paragraph(nb_sentences=2)
        rates.append((value, description))
    return rates


def prepare_student_rate_table(num_st_rate: int):
    st_rates = []
    for id_st in ID_STUDENTS:
        for id_subject in ID_SUBJECTS:
            for _ in range(num_st_rate):
                date_rate = fake.date_between(start_date='-2y')
                id_rate = choice(ID_RATES)
                st_rates.append((id_st, id_subject, id_rate, date_rate))
    return st_rates


def prepare_prof_subject_table(num_prof_subject: int):
    prof_subject = []
    for id_subject in ID_SUBJECTS:
        for _ in range(num_prof_subject):
            id_prof = choice(ID_PROFESSORS)
            prof_subject.append((id_prof, id_subject))
    return prof_subject


def fill_table_group(con: ConnectionType):
    cursor = con.cursor()
    query = '''INSERT INTO group_ (name, description, created_at, enabled)
               VALUES (%s, %s, %s, %s)'''
    cursor.executemany(query, GROUPS)
    con.commit()
    cursor.close()
    print('Table group_ was filled')


def fill_table_student(con: ConnectionType):
    cursor = con.cursor()
    # Fill table students
    query = '''INSERT INTO student (name, surname, date_birth, id_group)
               VALUES (%s, %s, %s, %s)'''
    cursor.executemany(query, STUDENTS)
    con.commit()
    cursor.close()
    print('Table student was filled')


def fill_table_professor(con: ConnectionType):
    cursor = con.cursor()
    # Fill table professor
    query = '''INSERT INTO professor (name, surname, date_birth, title)
               VALUES (%s, %s, %s, %s)'''
    cursor.executemany(query, PROFESSORS)
    con.commit()
    cursor.close()
    print('Table professor was filled')


def fill_table_subject(con: ConnectionType):
    cursor = con.cursor()
    # Fill table subject
    query = '''INSERT INTO subject (name, description)
               VALUES (%s, %s)'''
    cursor.executemany(query, SUBJECTS)
    con.commit()
    cursor.close()
    print('Table subject was filled')


def fill_table_rate(con: ConnectionType):
    cursor = con.cursor()
    # Fill table rate
    query = '''INSERT INTO rate (val, description)
               VALUES (%s, %s)'''
    cursor.executemany(query, RATE)
    con.commit()
    cursor.close()
    print('Table rate was filled')


def fill_table_st_rate(con: ConnectionType):
    cursor = con.cursor()
    # Fill table student_rate
    query = '''INSERT INTO student_rating 
               (id_student, id_subject, id_rate, date_rate)
               VALUES (%s, %s, %s, %s)'''
    cursor.executemany(query, ST_RATE)
    con.commit()
    cursor.close()
    print('Table student_rate was filled')


def fill_table_prof_subject(con: ConnectionType):
    cursor = con.cursor()
    # Fill table prof_subject
    query = '''INSERT INTO professor_subject 
               (id_professor, id_subject)
               VALUES (%s, %s)'''
    cursor.executemany(query, PR_SUBJECT)
    con.commit()
    cursor.close()
    print('Table professor_subject was filled')


def read_id(con: ConnectionType, column_name: str, table_name: str):
    cursor = con.cursor()
    query = f'SELECT {column_name} FROM {table_name}'
    cursor.execute(query)
    ids = [id_[0] for id_ in cursor.fetchall()]
    cursor.close()
    return ids


def read_file(name):
    with open(name, 'r') as f:
        comment = f.readline()
        sql = ''
        while True:
            line = f.readline()
            if not line:
                break
            sql += line
    return comment[2:], sql


def make_queries(con: ConnectionType):
    cursor = con.cursor()
    num = 1
    while num < 13:
        comment, query = read_file(f'query {num}.sql')
        print(comment)
        cursor.execute(query)
        sql = cursor.fetchall()
        for line in sql:
            str = ''

            for item in line:
                if isinstance(item, type(str)):
                    str += f'{item:<50} '
                else:
                    str += f'{item} '
            print(str)
        print()
        input('Please press Enter to continue >> ')
        print()
        num += 1
    con.commit()
    cursor.close()


if __name__ == '__main__':
    connection = db_connect()
    if connection:
        drop_tables(connection)
        create_tables(connection)

        GROUPS = prepare_group_table(num_group=3)
        fill_table_group(connection)
        ID_GROUPS = read_id(connection, 'id_group', 'group_')

        STUDENTS = prepare_student_table(num_student=30)
        fill_table_student(connection)
        ID_STUDENTS = read_id(connection, 'id_student', 'student')

        PROFESSORS = prepare_prof_table(num_prof=3)
        fill_table_professor(connection)
        ID_PROFESSORS = read_id(connection, 'id_professor', 'professor')

        SUBJECTS = prepare_subject_table(num_subject=5)
        fill_table_subject(connection)
        ID_SUBJECTS = read_id(connection, 'id_subject', 'subject')

        RATE = prepare_rate_table(num_rate=12)
        fill_table_rate(connection)
        ID_RATES = read_id(connection, 'id_rate', 'rate')

        ST_RATE = prepare_student_rate_table(num_st_rate=20)
        fill_table_st_rate(connection)

        PR_SUBJECT = prepare_prof_subject_table(num_prof_subject=1)
        fill_table_prof_subject(connection)

        make_queries(connection)
    connection.close()





