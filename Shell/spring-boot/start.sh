# Author: Haceral <haceral@163.com>
# Version: 1.0.0
# Last update date: 2024/10/12
#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Define Java startup parameters
JAVA_MEMORY_OPTIONS="-Xms256m -Xmx256m -Xmn128m"
JAVA_VM_OPTIONS="-DNACOS_HOST=localhost -DNACOS_NAMESPACE=60fc076a-b03e-4e17-af31-b22485e734e4 -DNACOS_GROUP=DEFAULT_GROUP"
SPRING_PROFILE=""
JAVA_EXEC="/usr/local/java/jdk8u422/bin/java"

SPRINGBOOT_JAR_NAME=''

# Check for parameters
RESTART_FLAG=false
while getopts ":r" opt; do
  case ${opt} in
    r )
      RESTART_FLAG=true
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done

# If JAR name is not configured, automatically find and configure it
if [ -z "$SPRINGBOOT_JAR_NAME" ]; then
  echo -e "\e[32mDetected that you have not configured the service file name, the system is automatically configuring it....\e[0m"
  SPRINGBOOT_JAR_NAME=$(find "$SCRIPT_DIR" -name "*.jar" -print -quit)  # Find the first JAR file
  if [ -z "$SPRINGBOOT_JAR_NAME" ]; then
    echo -e "\e[31mNo JAR file found, exiting...\e[0m"
    exit 1
  fi
  SPRINGBOOT_JAR_NAME=${SPRINGBOOT_JAR_NAME##*/}  # Extract the file name
  echo -e "\e[32mInitialization complete, your service file name is:\e[31m$SPRINGBOOT_JAR_NAME\e[0m"
  sleep 2
fi

# Get the PID of the running service
PIDS=$(pgrep -f "$SPRINGBOOT_JAR_NAME")

# If a restart is detected
if [ "$RESTART_FLAG" = true ]; then
  if [ -n "$PIDS" ]; then
    echo -e "\e[33mStopping $SPRINGBOOT_JAR_NAME (PID: $PIDS)...\e[0m"
    kill -9 $PIDS
    sleep 2
    echo -e "\e[32m$SPRINGBOOT_JAR_NAME has stopped.\e[0m"
  else
    echo -e "\e[33mNo running instance of $SPRINGBOOT_JAR_NAME detected, preparing to start...\e[0m"
  fi
  # Start the service
  nohup $JAVA_EXEC -jar $JAVA_MEMORY_OPTIONS $JAVA_VM_OPTIONS "$SCRIPT_DIR/$SPRINGBOOT_JAR_NAME" $SPRING_PROFILE > "$SCRIPT_DIR/run.log" 2>&1 &
  sleep 2
  echo -e "\e[32m$SPRINGBOOT_JAR_NAME started successfully!\e[0m"
  tail -f "$SCRIPT_DIR/run.log"
  exit 0
fi

# If a restart is not needed, check if the service is already running
if [ -z "$PIDS" ]; then
  nohup $JAVA_EXEC -jar $JAVA_MEMORY_OPTIONS $JAVA_VM_OPTIONS "$SCRIPT_DIR/$SPRINGBOOT_JAR_NAME" $SPRING_PROFILE > "$SCRIPT_DIR/run.log" 2>&1 &
  sleep 2
  echo -e "\e[32m$SPRINGBOOT_JAR_NAME started successfully!\e[0m"
  tail -f "$SCRIPT_DIR/run.log"
  exit 0
fi

echo -e "\e[31mWarning: $SPRINGBOOT_JAR_NAME is already running!\e[0m"
exit 1