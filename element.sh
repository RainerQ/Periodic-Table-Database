#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_PRO() {
#Getting an argument and sending it to a function
if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  GET_INFO $1
fi

}
#Getting the Atomic number (ID)
GET_INFO() {
  ELEMENT=$1

  if [[ ! $ELEMENT =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE symbol='$ELEMENT' OR name='$ELEMENT';"))
    #echo $ATOMIC_NUMBER
  else
    ATOMIC_NUMBER=$(echo $($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$ELEMENT;"))
    #echo $ATOMIC_NUMBER
  fi

  if [[ -z $ATOMIC_NUMBER ]]
then 
  echo "I could not find that element in the database."
else
  NAME=$(echo $($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER;"))
  SYMBOL=$(echo $($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER;"))
  TYPE=$(echo $($PSQL "SELECT type FROM types FUL JOIN properties using(type_id) WHERE atomic_number=$ATOMIC_NUMBER;"))
  ATOMIC_MASS=$(echo $($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER;"))
  MELTING_POINT=$(echo $($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;"))
  BOILING_POINT=$(echo $($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER;"))


  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
fi

}




MAIN_PRO $1
