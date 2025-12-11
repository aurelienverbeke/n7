#!/bin/sh

# this script try to autodetect a java version that satisfy a minimum major
# version
#
# usage: detect-jdk.sh <version_number>
#
# Author: Teo Pisenti

# run java -version and parse output to get only major version number
java_major_version() {
  $1 -version 2>&1 | awk -F '"' \
    '/version/ {
      ver=$2
      sub(/^1\./, "", ver)
      split(ver, a, ".")
      print a[1]
    }'
}

# try to autodetect all java versions installed on the current system
all_java_versions() {
  for j in /usr/lib/jvm/*openjdk*/bin/java
  do
    # run each java command in a parallel process for speed
    (
      echo "$j $(java_major_version "$j")"
    ) &
  done
  # wait for the end of all parallel processes
  wait
}

# choose a java version that satisfy the minimum version required
choose_java() {
  # prefer the version in $PATH if it works
  default_java=$(which java)
  if [ "$(java_major_version "$default_java")" -ge "$1" ]
  then
    echo "$default_java"
  else
    >&2 echo "Java version in PATH is too old, trying to detect newer versions"
    choosen_java=$(all_java_versions | sort -rn -k2 | awk 'NR==1 { print $1 }')
    >&2 echo "Most recent java detected is $choosen_java"
    echo "$choosen_java"
  fi
}

choose_java "$@"
