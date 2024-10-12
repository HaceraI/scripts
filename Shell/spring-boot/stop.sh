# Author: Haceral <haceral@163.com>
# Version: 1.0.0
# Last update date: 2024/10/12
#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

# Initialize JAR name
SPRINGBOOT_JAR_NAME=''

# Automatically find and configure JAR name
if [ -z "$SPRINGBOOT_JAR_NAME" ]; then
  echo -e "\e[32mDetected that you have not configured the service file name, the system is automatically configuring it....\e[0m"
  SPRINGBOOT_JAR_NAME=$(find "$SCRIPT_DIR" -name "*.jar" -print -quit)  # Find the first JAR file
  if [ -z "$SPRINGBOOT_JAR_NAME" ]; then
    echo -e "\e[31mNo JAR file found, exiting...\e[0m"
    exit 1
  fi
  SPRINGBOOT_JAR_NAME=${SPRINGBOOT_JAR_NAME##*/}  # Extract the file name
  echo -e "\e[32mInitialization complete, your service file name is:\e[31m$SPRINGBOOT_JAR_NAME\e[0m"
fi

# Get the PID of the running service
PIDS=$(pgrep -f "$SPRINGBOOT_JAR_NAME")

# Check if the service is running
if [ -z "$PIDS" ]; then
  echo -e "\e[31mWarning: $SPRINGBOOT_JAR_NAME is not running!\e[0m"
  exit 1
fi

# Stop the service
echo -e "Stopping $SPRINGBOOT_JAR_NAME process [$PIDS] ...\c"
for PID in $PIDS; do
  kill "$PID" > /dev/null 2>&1
  if [ $? -ne 0 ]; then
    echo -e "\e[31mFailed to stop process $PID!\e[0m"
  fi
done

# Wait for the process to stop
while true; do
  sleep 2
  if ! ps -p $PIDS > /dev/null; then
    break
  fi
  echo -e "......\c"
done

echo "$SPRINGBOOT_JAR_NAME process [$PIDS] has been stopped!"