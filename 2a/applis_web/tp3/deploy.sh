source comp.sh annuaire
cp annuaire.war $TOMCAT_HOME/webapps/.
cd facade
./mvnw package
cd -
cp facade/target/facade-0.0.1-SNAPSHOT.war $TOMCAT_HOME/webapps/facade.war
$TOMCAT_HOME/bin/shutdown.sh
$TOMCAT_HOME/bin/startup.sh
