#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games, games_game_id_seq, teams_team_id_seq;")

cat games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT W_GOAL O_GOAL
  do

    if [[ $WINNER != winner ]]
      then
        w=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
        echo $w
        if [[ $w == '' ]]
          then
            echo $($PSQL "INSERT INTO teams(name) VALUES ('$WINNER');")
            w=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
            echo $w
        fi

    fi

    if [[ $OPPONENT != opponent ]]
      then
        o=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
        echo $o
        if [[ $o == '' ]]
          then
            echo $($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT');")
            o=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")
            echo $o
        fi

    fi

  done

  cat games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT W_GOAL O_GOAL
    do
      if [[ $WINNER != winner ]]
        then
          w_id=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
          o_id=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")   

          echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $w_id, $o_id, $W_GOAL, $O_GOAL);")     

      fi
    done