export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/
export PATH=$JAVA_HOME/bin:$PATH
javac -cp ./storm-3-2.jar $1.java
java -cp .:./storm-3-2.jar programme.programme