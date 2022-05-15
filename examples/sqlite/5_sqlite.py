import sqlite3 as sql

def readAvatar(file):
    try:
        with open(f"avatars/{file}.png", "rb") as f:
            return f.read()
    except IOError as e:
        print(e)
        return False

def writeAvatar(file, data):
    try:
        with open(file, "wb") as f:
            f.write(data)
    except IOError as e:
        print(e)
        return False

with sql.connect("main.sqlite") as conn:
    conn.row_factory = sql.Row
    cursor = conn.cursor()

    cursor.executescript("""CREATE TABLE IF NOT EXISTS users2 (
        name TEXT,
        avatar BLOB,
        score INTEGER
        );
        """)

    cursor.execute("SELECT avatar FROm users2 LIMIT 1")
    img2 = cursor.fetchone()['avatar']
    writeAvatar('avatars/wow.png', img2)

    img = readAvatar(1)
    if img:
        binary = sql.Binary(img)
        cursor.execute("INSERT INTO users2 VALUES('Derec', ?, 1200)", (binary,))

# FOR get full DUMP of database
    with open("full_dump.sql", "w") as f:
        for sql in conn.iterdump():
            f.write(sql)

# Reover Dump
    with open("full_dump.sql", "r") as f:
        sql f.read()
        cursor.executescript(sql)




