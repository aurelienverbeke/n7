#!/bin/sh

echo "Description: This script build and run src/LoadBalancer.java"
echo "             For testing, you may start a 2 http servers on ports 8081 and 8082 using comanche.sh first."

# chemin du dossier ou est installe le script
WORKDIR="$(realpath "$(dirname "$0")")"

# compiler LoadBalancer.java
javac -d "$WORKDIR/target/classes/" -cp "$WORKDIR/src" "$WORKDIR/src/LoadBalancer.java"

# executer la classe LoadBalancer
java -cp "$WORKDIR/target/classes/" LoadBalancer "$@"
