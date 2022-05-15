import sqlite3 as sql

cars = [
        ('VW', 1600000),
        ('Hyundai', 2000000),
        ('Lada', 666666),
        ('Volvo', 3020000),
        ('Geely', 1023230)
]

conn = None
try:
    conn = sql.connect("main.sqlite")
    cursor = conn.cursor()

    cursor.execute("""CREATE TABLE IF NOT EXISTS cars (
        car_id INTEGER PRIMARY KEY AUTOINCREMENT,
        model TEXT,
        price INTEGER
        )""")

    cursor.executescript("""DELETE FROM cars WHERE model LIKE 'L%';
        BEGIN;
        UPDATE c222ars SET price = price + 100000
    """)

    conn.commit()

except sql.Error as e:
    if conn: conn.rollback()
    print("Failed to execute request.")

finally:
    if conn: conn.close()



