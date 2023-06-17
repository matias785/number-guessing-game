#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c"
###
echo "$($PSQL "drop table games")"
echo "$($PSQL "create table games()")"
echo "$($PSQL "ALTER TABLE games ADD COLUMN game_id int")"
echo "$($PSQL "ALTER TABLE games ADD COLUMN guesses int")"
echo "$($PSQL "ALTER TABLE games ADD COLUMN user_id int")"

###
echo "$($PSQL "drop table users")"
echo "$($PSQL "create table users()")"
echo "$($PSQL "ALTER TABLE users ADD COLUMN user_ID  serial PRIMARY KEY")"
echo "$($PSQL "ALTER TABLE users ADD COLUMN username varchar(22) UNIQUE not null")"

echo "$($PSQL "ALTER TABLE games ADD CONSTRAINT games_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(user_id);")"
