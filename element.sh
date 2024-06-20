#!/bin/bash
# Program to query periodic_table.sql

PSQL="psql --username=freecodecamp --dbname=periodic_table -t -c"

if [[ $# -eq 0 ]]
then
  echo "Please provide an element as an argument."
  exit 0
fi

# Query table 'elements' for atomic_number
if [[ $1 =~ ^[0-9]+$ ]]
then
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1")
else
  # Query table 'elements' for symbol or name
  ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$1' OR symbol = '$1'")
fi

# No matching element found in database
if [[ -z $ATOMIC_NUMBER ]]
then
  echo "I could not find that element in the database."
  exit 0
fi

# Get all relevant properties of element and print to stdout
ELEMENT=$($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $ATOMIC_NUMBER")
echo $ELEMENT | while read NUMBER BAR SYMBOL BAR NAME BAR TYPE BAR MASS BAR MELT BAR BOIL
do
  echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
done
