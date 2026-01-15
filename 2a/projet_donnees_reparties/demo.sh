#!/bin/bash
set -euo pipefail

############################
# Helpers
############################

PIDS=()

build_jar() {
  local jar_name="$1"
  local main_class="$2"
  shift 2

  cat > manifest.txt <<EOF
Main-Class: $main_class
EOF

  jar cfm "$jar_name" manifest.txt "$@"
  rm -f manifest.txt
}


start_server() {
  local label=$1
  shift
  echo "Starting server [$label]..."
  "$@" > >(sed "s/^/[$label] /") 2>&1 &
  PIDS+=($!)
}

stop_servers() {
  echo "Stopping servers..."
  for pid in "${PIDS[@]:-}"; do
    kill "$pid" 2>/dev/null || true
  done
  PIDS=()
}

time_command() {
  local label=$1
  shift
  echo ""
  echo ">>> $label"
  local start end elapsed
  start=$(($(date +%s%N)/1000000))
  "$@"
  end=$(($(date +%s%N)/1000000))
  elapsed=$((end - start))
  echo "Elapsed time: $elapsed ms"
}

trap stop_servers EXIT

############################
# Build
############################

echo "###"
echo "Compiling source files..."
echo "###"
rm -rf build
mkdir -p build
javac -d build src/**/*.java
cd build

# Create JARs (with only necessary classes)
build_jar server_agents.jar agents.Server agents/Agent.class agents/Service*.class agents/Server*.class agents/Loader.class agents/Worker*.class 
build_jar agent_fast.jar agents.AgentFast agents
build_jar agent_slow.jar agents.AgentSlow agents

build_jar server_rmi.jar rmi.Server rmi/Server.class rmi/RmiService.class rmi/RmiServiceImpl.class
build_jar rmi_client_fast.jar rmi.ClientFast rmi/ClientFast.class rmi/RmiService.class
build_jar rmi_client_slow.jar rmi.ClientSlow rmi/ClientSlow.class rmi/RmiService.class


############################
# Agent-based test
############################

echo ""
echo "###"
echo "Running agents example..."
echo "###"

start_server SRV-8082 java -jar server_agents.jar stringgenerator 8082
start_server SRV-8083 java -jar server_agents.jar lengthcalculator 8083
sleep 2

time_command "Fast agent" java -jar agent_fast.jar
sleep 2
time_command "Slow agent" java -jar agent_slow.jar

stop_servers
sleep 2

############################
# RMI test
############################

echo ""
echo "###"
echo "Running RMI example..."
echo "###"

start_server RMI-8082 java -jar server_rmi.jar 8082
start_server RMI-8083 java -jar server_rmi.jar 8083
sleep 2

time_command "Fast RMI client" java -jar rmi_client_fast.jar
sleep 2
time_command "Slow RMI client" java -jar rmi_client_slow.jar
