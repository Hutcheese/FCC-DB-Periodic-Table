#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN () {
    if [[ -z $1 ]]
    then
        echo "Please provide an element as an argument."
    else
        PRINT_ELEMENT $1
    fi
}

PRINT_ELEMENT () {
    # echo $1 was your arguement.
    
    # Check for number
    if [[ $1 =~ ^[1-9]+$ ]]
    then
        ELEMENT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where atomic_number = '$1'")
    else
        ELEMENT=$($PSQL "select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius from elements join properties using(atomic_number) join types using(type_id) where name = '$1' or symbol = '$1'")
    fi

    if [[ -z $ELEMENT ]]
    then
        echo -e "I could not find that element in the database."
        exit
    fi

    # Seperate the IFS by " |"
    echo $ELEMENT | while IFS=" |" read atomic_number name symbol type mass melting_point boiling_point 
    do
        echo -e "The element with atomic number $atomic_number is $name ($symbol). It's a $type, with a mass of $mass amu. $name has a melting point of $melting_point celsius and a boiling point of $boiling_point celsius."
    done
}

MAIN $1