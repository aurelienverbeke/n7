#!/bin/sh

echo "Description: This script build and run the spring-boot project using the maven wrapper and the spring-boot maven plugin"
echo ""

# path to the folder where the script is installed
WORKDIR="$(realpath "$(dirname "$0")")"

# minimum major of java that is supported
MIN_JAVA=17

# update the path to force the detected java version
PATH="$(dirname "$("$(dirname "$WORKDIR")"/detect-jdk.sh $MIN_JAVA)"):$PATH"
export PATH

# Pass args to the spring-boot app. example: --server.port=8000
cd "$WORKDIR" && ./mvnw spring-boot:run -Dspring-boot.run.arguments="$*"
