import sqlite3 as sql

with sql.connect("main.sqlite") as conn:
    cursor = conn.cursor()

    cursor.executescript("""CREATE TABLE IF NOT EXISTS cars (
        car_id INTEGER PRIMARY KEY AUTOINCREMENT,
        model TEXT,
        price INTEGER
        );
        CREATE TABLE IF NOT EXISTS cust(name TEXT, tr_n INTEGER, buy INTEGER);
        """)

    cursor.execute("INSERT INTO cars VALUES(NULL, 'Shitcar', 1200)")
    last_row_id = cursor.lastrowid
    buy_car_id = 2
    cursor.execute("INSERT INTO cust VALUES('Anton', ?, ?)", (last_row_id, buy_car_id))

