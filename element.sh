#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ ! $1 ]]
then
  echo "Please provide an element as an argument."
  exit
fi

KEY=$1

if [[ ! $KEY =~ ^[0-9]+$ ]]
then
  QUERY=$($PSQL "SELECT atomic_number , symbol , name , type , atomic_mass , boiling_point_celsius , melting_point_celsius 
  FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) 
  WHERE symbol='$KEY' OR name='$KEY'")
else
  QUERY=$($PSQL "SELECT atomic_number, symbol,name, type, atomic_mass, boiling_point_celsius, melting_point_celsius 
  FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) 
  WHERE atomic_number=$KEY")
fi

if [[ -z $QUERY ]]
then
  echo -e "I could not find that element in the database."
  exit
fi

echo "$QUERY" > element_details.txt
ig
cat element_details.txt | while IFS="|" read EL SYM NAME TYPE AM BP MP
do
  echo "The element with atomic number $EL is $NAME ($SYM). It's a $TYPE, with a mass of $AM amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
done
