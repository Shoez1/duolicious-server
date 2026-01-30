def create_dbs():
    # All this stuff just to run `CREATE DATABASE IF NOT EXISTS DB_NAME`
    import os
    import psycopg
    import time

    DB_HOST = os.getenv('DUO_DB_HOST') or 'localhost'
    DB_PORT = os.getenv('DUO_DB_PORT') or '5432'
    DB_USER = os.getenv('DUO_DB_USER') or 'postgres'
    DB_PASS = os.getenv('DUO_DB_PASS') or 'postgres'

    _conninfo = psycopg.conninfo.make_conninfo(
        host=DB_HOST,
        port=DB_PORT,
        user=DB_USER,
        password=DB_PASS,
    )

    def create_db(name):
        for _ in range(10):
            try:
                with psycopg.connect(_conninfo, autocommit=True) as conn:
                    with conn.cursor() as cur:
                        cur.execute(f"CREATE DATABASE {name}")
                print(f'Created database: {name}')
                break
            except (
                psycopg.errors.DuplicateDatabase,
                psycopg.errors.UniqueViolation,
            ):
                print(f'Database already exists: {name}')
                break
            except psycopg.errors.OperationalError:
                print(
                    'Creating database(s) failed; waiting and trying again:',
                    e
                )
                time.sleep(1)

    create_db('duo_api')

def init_db():
    # Now DB_NAME exists, we do do the rest of the init.
    from service import (
        api,
        location,
        person,
        question,
    )

    init_funcs = [
        api.init_db,
        location.init_db,
        person.init_db,
        question.init_db,
    ]

    print('Initializing api DB...')
    for i, init_func in enumerate(init_funcs, start=1):
        print(f'  * {i} of {len(init_funcs)}')
        init_func()
    print('Finished initializing api DB')

create_dbs()
init_db()
