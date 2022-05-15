import sqlite3 as sql

cars = [
        ('VW', 1600000),
        ('Hyundai', 2000000),
        ('Lada', 666666),
        ('Volvo', 3020000),
        ('Geely', 1023230)
]

with sql.connect("main.sqlite") as conn:
    cursor = conn.cursor()

    cursor.execute("""CREATE TABLE IF NOT EXISTS cars (
        car_id INTEGER PRIMARY KEY AUTOINCREMENT,
        model TEXT,
        price INTEGER
        )""")

#    for car in cars:
#        cursor.execute("INSERT INTO cars VALUES(NULL, ?, ?)", car)
    cursor.executemany("INSERT INTO cars VALUES(NULL, ?, ?)", cars)

    cursor.execute("UPDATE cars SET price = :Price WHERE model LIKE 'G%'", {'Price': 0})

    cursor.executescript("""DELETE FROM cars WHERE model LIKE 'L%';
        UPDATE cars SET price = price + 100000
    """)


    cursor.execute("SELECT * FROM cars")
    for row in cursor:
        print(f"For: {row}")

    # cursor.commit()
    # cursor.close()




