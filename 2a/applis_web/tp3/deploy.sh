source comp.sh Annuaire
cp Annuaire.war $TOMCAT_HOME/webapps/.
cd facade
./mvnw package
cd -
cp facade/target/facade-0.0.1-SNAPSHOT.war $TOMCAT_HOME/webapps/facade.war

