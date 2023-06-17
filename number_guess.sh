#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=postgres -t --no-align -c"
echo -e "\nEnter your username:"
read USERNAME

USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")

if [[ -z $USER_ID ]]
then
  echo "Welcome, $USERNAME! It looks like this is your first time here."
  INSERT_USERNAME=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
  USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(user_id) FROM games WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

RUN() {
  NUMERO_RANDOM=$(( $RANDOM % 1000 + 1 ))
  #NUMERO_RANDOM=$(( 25 ))
  INTENTOS=0

  echo "Guess the secret number between 1 and 1000:"

  while true
  do
    read NUMERO_USER
    if [[ ! $NUMERO_USER =~ ^[0-9]+$ ]]
    then
      echo -"\nThat is not an integer, guess again:"
    else
      if [[ $NUMERO_USER -gt $NUMERO_RANDOM ]]
      then
        INTENTOS=$(($INTENTOS+1))
        echo "It's lower than that, guess again:"
      fi
      if [[ $NUMERO_USER -lt $NUMERO_RANDOM ]]
      then
        INTENTOS=$(($INTENTOS+1))
        echo "It's higher than that, guess again:"
      fi
      if [ $NUMERO_USER -eq $NUMERO_RANDOM ]
      then
        INTENTOS=$(($INTENTOS+1))
        GAME_RESULT=$($PSQL "INSERT INTO games(guesses, user_id) VALUES($INTENTOS, $USER_ID)")
        echo -e "\nYou guessed it in $INTENTOS tries. The secret number was $NUMERO_RANDOM. Nice job!"
        break
      fi
    fi
  done
}

RUN
