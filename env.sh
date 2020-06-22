#!/bin/bash

# Geoscripting project 2019
# Team: "Hello World!"
# Members: Pim Arendsen & Michel Kroeze
# date: 30.01.2019


# this will install an environment with the right Python packages
read -p "This will install a new conda environment to run our script. Do you want to continue? (y/n)" CONT
if [ "$CONT" == "n" ]; then
  echo "exit";
else
  echo "Creating the environment: 'team_hello_world'"
  conda env create -f environment.yml
fi

echo 'Please manually activate the environment by using: "source activate team_hello_world"'
echo 'And run our main.sh afterwards' 



