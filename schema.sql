-- createdb todos

CREATE TABLE lists (
  id SERIAL PRIMARY KEY,
  name TEXT UNIQUE NOT NULL
);

CREATE TABLE todos (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  completed BOOLEAN NOT NULL DEFAULT false,
  list_id INTEGER NOT NULL REFERENCES lists(id) ON DELETE CASCADE
);
