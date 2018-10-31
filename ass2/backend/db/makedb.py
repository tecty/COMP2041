import sqlite3

conn = sqlite3.connect("test.sqlite3")
c = conn.cursor()
c.execute("CREATE TABLE USERS(id INTEGER PRIMARY KEY, username text, name text, password text, email text, curr_token text, following text, followed_num integer default 0)")
c.execute("CREATE TABLE COMMENTS(id INTEGER PRIMARY KEY, author TEXT, published TEXT, comment TEXT)")
c.execute("CREATE TABLE POSTS(id INTEGER PRIMARY KEY, author TEXT, description TEXT, published TEXT, likes TEXT, thumbnail TEXT, src TEXT, comments TEXT)")
conn.commit();
conn.close()