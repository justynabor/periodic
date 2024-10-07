#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"


OUTPUT=$1

if [[ $OUTPUT =~ ^[0-9]+$ ]]
then 
ATOM_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$OUTPUT;")

  if [[ -z $ATOM_NUM ]]
  then
  echo "I could not find that element in the database."
  else
   SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$OUTPUT;")  
  NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$OUTPUT;")
  MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$OUTPUT;")
  TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$OUTPUT;")
  TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID;")
  MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$OUTPUT;")
  BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$OUTPUT;")

  echo "The element with atomic number $ATOM_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  fi
elif [[ -z $OUTPUT ]]
then
  echo -e "Please provide an element as an argument."
else
SYMBOL=$($PSQL "SELECT symbol FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number WHERE symbol='$OUTPUT';")  
NAME=$($PSQL "SELECT name FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number WHERE name ='$OUTPUT';")  
if [[ -z $SYMBOL ]] && [[ -z $NAME ]]
then 
echo "I could not find that element in the database."
elif [[ -z $SYMBOL ]]
then
ATOM_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME';")
SYMBOL=$($PSQL "SELECT symbol FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number WHERE name='$OUTPUT';") 
MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOM_NUM;")
TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOM_NUM;")
TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID;")
MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOM_NUM;")
BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOM_NUM;")
echo "The element with atomic number $ATOM_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
elif [[ -z $NAME ]]
then
NAME=$($PSQL "SELECT name FROM elements INNER JOIN properties ON elements.atomic_number=properties.atomic_number WHERE symbol ='$OUTPUT';")  
ATOM_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL';")
MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOM_NUM;")
TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=$ATOM_NUM;")
TYPE=$($PSQL "SELECT type FROM types WHERE type_id=$TYPE_ID;")
MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOM_NUM;")
BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOM_NUM;")
echo "The element with atomic number $ATOM_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
else 
echo "I could not find that element in the database."
fi

fi
