import sqlite3 as sql

# in memory sql
#with sql.connect(":memory:") as conn:

with sql.connect("main.sqlite") as conn:
    conn.row_factory = sql.Row
    cursor = conn.cursor()

#    cursor.execute("DROP TABLE IF EXISTS users")

    cursor.execute("""CREATE TABLE IF NOT EXISTS users (
        user_id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        gender INTEGER NOT NULL DEFAULT 1,
        age INTEGER,
        score INTEGER
        )""")
    cursor.execute("""CREATE TABLE IF NOT EXISTS score (
        user_id INTEGER,
        score INTEGER,
        time INTEGER
        )""")

# =, ==, >, <, =>, <=, !=, BETWEEN
# AND, OR, NOT, IN, NOT IN

# ORDER BY col DESC
# ORDER BY col ASC
# LIMIT 1 OFFSET 5
# DISTINCT
# GROUP BY

# count(), sum(), avr(), min(), max()

# JOIN (DEFAULT INNER), LEFT JOIN, RIGHT JOIN
# UNION (unique entries)

#    INSERT INTO users VALUES(3, 'Vasiliy', 2, 34, 0)
#    INSERT INTO users (user_id, name, gender, age, score) VALUES(3, 'Vasiliy', 2, 34, 0)

#    SELECT name, score FROM users WHERE user_id = 3
#    SELECT name, score FROM users WHERE score BETWEEN 100 AND 300
#    SELECT name, score FROM users WHERE name IN ('Petra', 'Denis')
#    SELECT name, score FROM users WHERE age > 24 AND gender = 1

#    SELECT count(*) as count FROM users
#    SELECT DISTINCT user_id FROM score
#    SELECT sum(score) FROM score GROUP BY user_id ORDER BY score DESC

#    SELECT users.name, sum(games.score) as sum FROM games JOIN users ON games.user_id = users.user_id GROUP BY games.user_id ORDER BY sum DESC
#    SELECT name, age, games.score FROM games INNER JOIN users ON games.user_id = users.user_id
#    SELECT some, some2, 'table_1' as table FROM sometab UNION SELECT gsome, gsome2, 'table_2' FROM sometab2

#    UPDATE users SET name = 'Tatiana' where user_id = 3
#    UPDATE users SET score = score + 999 where user_id = 3

#    DELETE FROM users WHERE user_id = 3
#
#    ALTER TABLE score RENAME TO games;

    cursor.execute("SELECT * FROM cars LIMIT 2")
    for row in cursor:
        print(row['model'], row['price'])
        break

    cursor.execute("SELECT * FROM users LIMIT 2")
#    result = cursor.fetchone()
#    result = cursor.fetchmany(5)
    result = cursor.fetchall()
    print(result)



