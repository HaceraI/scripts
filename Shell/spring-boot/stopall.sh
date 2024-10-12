# Author: Haceral <haceral@163.com>
# Version: 1.0.0
# Last update date: 2024/10/12
#!/bin/bash

# Get the root directory of the current script (the starting directory of the script execution)
ROOT_DIR=$(dirname "$(readlink -f "$0")")

# Log file, using the root directory path
LOG_FILE="$ROOT_DIR/stopall_logger.log"

# Clear the log file
> "$LOG_FILE"

# Function to stop applications
stop_app() {
    local dir=$1
    local app_name=$(basename "$dir")

    echo "Stopping $app_name ..." | tee -a "$LOG_FILE"

    (
        # Change to the target application directory
        cd "$dir" || { echo "Cannot enter directory $dir, skipping $app_name" | tee -a "$LOG_FILE"; return; }

        # Call stop.sh
        if [ -f "./stop.sh" ]; then
            bash "./stop.sh"
            if [ $? -eq 0 ]; then
                echo "$app_name has been stopped" | tee -a "$LOG_FILE"
            else
                echo "$app_name failed to stop" | tee -a "$LOG_FILE"
            fi
        else
            echo "Stop script does not exist, skipping $app_name" | tee -a "$LOG_FILE"
        fi

        echo "----------------------------------------" | tee -a "$LOG_FILE"
    )
}

# Get the directories to stop
if [ "$#" -eq 0 ]; then
    dirs=(*/)
else
    dirs=("$@")
fi

# Iterate over each directory and call stop_app
for dir in "${dirs[@]}"; do
    # Remove the trailing slash
    dir="${dir%/}"

    # Check if the directory exists
    if [ -d "$dir" ]; then
        # Check if stop.sh script exists
        if [ -f "$dir/stop.sh" ]; then
            stop_app "$dir"
        else
            echo "$dir does not contain stop.sh script, skipping" | tee -a "$LOG_FILE"
        fi
    else
        echo "$dir directory does not exist, skipping" | tee -a "$LOG_FILE"
    fi
done

echo "All specified applications have been stopped." | tee -a "$LOG_FILE"