#!/bin/bash


PSQL="psql --username=postgres --dbname=number_guess -t --no-align -c"


# create database "number_guess"
# add columns "name", "game_date" "number_of_tries"

NUMBER_OF_GUESSES=0

 # generate a number between 1 and 1000
NUMBER=$(($RANDOM % 1000 + 1))
echo -e "\nthe number is $NUMBER"
echo -e "\nEnter your username: "
GET_USER () {

  
read USER_NAME

# check if user name < 23 3characters
LEN_NAME=${#USER_NAME}
 echo "your name is $LEN_NAME characters long."
if [[ $LEN_NAME -gt 22 ]]
then
  echo -e "\nPlease choose a name shorter than 23 characters:"
  GET_USER
fi
# check if user exists
IS_USER=$($PSQL "SELECT name FROM players WHERE name = '$USER_NAME'" )
#echo -e "you are $USER"

if [[ -z $IS_USER ]]
then
  INSERT_RESULT=$($PSQL "INSERT INTO players(name) values('$USER_NAME')")
  PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name = '$USER_NAME'")

  echo "Welcome, $USER_NAME! It looks like this is your first time here."
else
   
  PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name = '$USER_NAME'")
  NUM_OF_GAMES=$($PSQL "SELECT count(g.game_date) FROM games as g join players as p using(player_id) WHERE p.name = '$USER_NAME'")
  NUM_OF_GUESSES=$($PSQL "SELECT g.num_guesses FROM games as g join players as p using(player_id) WHERE p.name = '$USER_NAME'")
  BEST_GAME=$($PSQL "SELECT min(g.num_guesses) FROM games as g join players as p using(player_id) WHERE (p.name = '$USER_NAME' AND g.num_guesses != 0)")
   echo  "Welcome back, $USER_NAME! You have played $NUM_OF_GAMES games, and your best game took $BEST_GAME guesses."
 fi

   echo -e "\nGuess the secret number between 1 and 1000:"
   
  # echo -e "\nyour id is $PLAYER_ID"
   BEGIN_GAME=$($PSQL "INSERT INTO games(player_id) values($PLAYER_ID) ")
 
}
GET_USER



GUESS_NUM () {
  
  read GUESS
    let NUMBER_OF_GUESSES+=1
    UPDATE_GUESSES=$($PSQL "update games set num_guesses = $NUMBER_OF_GUESSES WHERE player_id = $PLAYER_ID")
 # echo $NUMBER_OF_GUESSES
   
  if [[ ! $GUESS =~ ^[0-9]+$ ]]
  then
    echo  "That is not an integer, guess again:"
    GUESS_NUM 
  fi
  
  # 1 number correct
    if [[ $GUESS == $NUMBER ]]
    then
      echo -e "\nYou guessed it in $NUMBER_OF_GUESSES tries. The secret number was $NUMBER. Nice job!" 
  # 2 number low
    elif [[ $GUESS > $NUMBER ]]
    then
      echo -e "\nIt's lower than that, guess again:"
      GUESS_NUM
  # 3 number high 
    elif [[ $GUESS < $NUMBER ]]
    then
      echo -e "\nIt's higher than that, guess again:"
      GUESS_NUM      
  fi
  
}
GUESS_NUM
