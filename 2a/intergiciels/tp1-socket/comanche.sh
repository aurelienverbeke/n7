#!/bin/sh

echo "Description: This script build and run Comanche HTTP server on given port number in the current directory."

if [ $# -ne 1 ]; then
  echo "ERROR: Wrong number of passed arguments"
  echo "Usage: $0 <numero du port>"
  exit
fi

# chemin du dossier ou est installe le script
WORKDIR="$(realpath "$(dirname "$0")")"

# compiler Comanche.java
javac -d "$WORKDIR/target/classes/" -cp "$WORKDIR/src" "$WORKDIR/src/Comanche.java"

# executer Comanche
java -cp "$WORKDIR/target/classes/" Comanche "$@"
