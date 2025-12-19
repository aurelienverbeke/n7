#!/bin/sh

echo "Description: This script build and run src/Irc.java (the 'irc' gui)"
echo "INFO: This program is a graphical app, if the zoom is too small, use 'export GDK_SCALE=2' (or add -Dsun.java2d.uiScale=2 to the java command)"
echo ""

# path to the folder where the script is installed
WORKDIR="$(realpath "$(dirname "$0")")"

# class that contains the "public static void main"
ENTRYPOINT="Irc"

# dependencies that can be downloaded by maven
DEPENDENCIES="activemq-all-5.19.1.jar  log4j-api-2.25.2.jar  log4j-core-2.25.2.jar"

dependencies_classpath=""
for jar in $DEPENDENCIES
do
  if [ ! -f "$WORKDIR/target/dependency/$jar" ]; then
    # run cd in another shell to not lose current pwd
    (cd "$WORKDIR" && mvn dependency:copy-dependencies)
  fi
  dependencies_classpath="$dependencies_classpath:$WORKDIR/target/dependency/$jar"
done

# build project
javac -d "$WORKDIR/target/classes" -cp "$WORKDIR/src$dependencies_classpath" "$WORKDIR/src/$(echo "$ENTRYPOINT" | tr '.' '/').java"

# execute the entrypoint
java -cp "$WORKDIR/target/classes$dependencies_classpath" "$ENTRYPOINT" "$@"
