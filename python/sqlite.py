#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sqlite3

#création de base
conn = sqlite3.connect('ma_base.db')

#création de table
cursor = conn.cursor()
cursor.execute("""
CREATE TABLE IF NOT EXISTS users(
     id INTEGER PRIMARY KEY AUTOINCREMENT UNIQUE,
     name TEXT,
     age INTERGER
)
""")
conn.commit()

#ajout des données
cursor.execute("""
INSERT INTO users(name, age) VALUES(?, ?)""", ("olivier", 30))
id = cursor.lastrowid
print('dernier id: %d' % id)

#par dictionnaire
data = {"name" : "martin", "age" : 30}
cursor.execute("""
INSERT INTO users(name, age) VALUES(:name, :age)""", data)

#récupération une donnée
cursor.execute("""SELECT name, age FROM users""")
user1 = cursor.fetchone()
print(user1)

#récupération des données
cursor.execute("""SELECT id, name, age FROM users""")
rows = cursor.fetchall()
for row in rows:
    print('{0} : {1} - {2}'.format(row[0], row[1], row[2]))

#fermeture
conn.close()


