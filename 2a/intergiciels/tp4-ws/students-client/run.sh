#!/bin/sh

echo "Description: This script build and run src/TestClient.java (the resteasy client)"
echo ""

# path to the folder where the script is installed
WORKDIR="$(realpath "$(dirname "$0")")"

# minimum major of java that is supported
MIN_JAVA=17

# update the path to force the detected java version
PATH="$(dirname "$("$(dirname "$WORKDIR")"/detect-jdk.sh $MIN_JAVA)"):$PATH"
export PATH

# class that contains the "public static void main"
ENTRYPOINT="TestClient"

# dependencies that can be downloaded by maven
DEPENDENCIES="angus-activation-2.0.3.jar asyncutil-0.1.0.jar btf-1.3.jar commons-codec-1.19.0.jar commons-logging-1.2.jar httpclient-4.5.14.jar httpcore-4.4.16.jar jackson-annotations-2.20.jar jackson-core-2.20.0.jar jackson-coreutils-2.0.jar jackson-databind-2.20.0.jar jackson-datatype-jdk8-2.20.0.jar jackson-datatype-jsr310-2.20.0.jar jackson-jakarta-rs-base-2.20.0.jar jackson-jakarta-rs-json-provider-2.20.0.jar jackson-module-jakarta-xmlbind-annotations-2.20.0.jar jakarta.activation-api-2.1.4.jar jakarta.annotation-api-2.1.1.jar jakarta.validation-api-3.1.1.jar jakarta.ws.rs-api-4.0.0.jar jakarta.xml.bind-api-3.0.1.jar jandex-3.4.0.jar jboss-logging-3.6.1.Final.jar json-patch-1.13.jar msg-simple-1.2.jar reactive-streams-1.0.4.jar resteasy-client-7.0.0.Final.jar resteasy-client-api-7.0.0.Final.jar resteasy-core-7.0.0.Final.jar resteasy-core-spi-7.0.0.Final.jar resteasy-jackson2-provider-7.0.0.Final.jar"

dependencies_classpath=""
for jar in $DEPENDENCIES
do
  if [ ! -f "$WORKDIR/target/dependency/$jar" ]; then
    # run cd in another shell to not lose current pwd
    (cd "$WORKDIR" && ./mvnw dependency:copy-dependencies)
  fi
  dependencies_classpath="$dependencies_classpath:$WORKDIR/target/dependency/$jar"
done

# build project
javac -d "$WORKDIR/target/classes" -cp "$WORKDIR/src$dependencies_classpath" "$WORKDIR/src/$(echo "$ENTRYPOINT" | tr '.' '/').java"

# execute the entrypoint
java -cp "$WORKDIR/target/classes$dependencies_classpath" "$ENTRYPOINT" "$@"
