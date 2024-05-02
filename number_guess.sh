#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=<database_name> -t --no-align -c"

# create database "number_guess"
# add columns "name", "game_date" "number_of_tries"

NUMBER_OF_GUESSES=0

 # generate a number between 1 and 1000
NUMBER=$(($RANDOM % 1000 + 1))
echo -e "\nthe number is $NUMBER"
echo -e "\nEnter your username: "
read USER_NAME
# check if name is less than 23 characters

      LEN_NAME=${#USER_NAME}
       echo $LEN_NAME
      if [[ $LEN_NAME -gt 22 ]]
      then
        echo -e "\nPlease choose a name shorter than 23 characters:"
         read USER_NAME
      fi

  # else, continue game
echo "Hello $USER_NAME."
# check if return player
# if yes, greet player with number of games and best score
  #Welcome back, <username>! You have played <games_played> games, and your best game took <best_game> guesses.
  # else, geet new player with "Welcome, <username>! It looks like this is your first time here." and add new player to database



