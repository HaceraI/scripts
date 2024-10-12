# Author: Haceral <haceral@163.com>
# Version: 1.0.0
# Last update date: 2024/10/12
#!/bin/bash

# Get the root directory of the current script (the starting directory of script execution)
ROOT_DIR=$(dirname "$(readlink -f "$0")")

# Log file, enforced to use the root directory path
LOG_FILE="$ROOT_DIR/restart_logger.log"

# Clear the log file
> "$LOG_FILE"

# Function to restart the application
restart_app() {
    local dir=$1
    local app_name=$(basename "$dir")

    echo "Restarting $app_name ..." | tee -a "$LOG_FILE"

    (
        # Change to the target application directory
        cd "$dir" || { echo "Cannot enter directory $dir, skipping $app_name" | tee -a "$LOG_FILE"; return; }

        # Call start.sh and run it in the background
        if [ -f "./start.sh" ]; then
            # Run start.sh in the background
            bash "./start.sh" -r > /dev/null 2>&1 &
            start_pid=$!

            # Wait for a short period to check if start.sh starts successfully
            sleep 5  # Adjust based on application startup time
            if ps -p $start_pid > /dev/null; then
                echo "$app_name started successfully, PID: $start_pid" | tee -a "$LOG_FILE"
            else
                echo "$app_name failed to start" | tee -a "$LOG_FILE"
            fi
        else
            echo "Start script does not exist, skipping $app_name" | tee -a "$LOG_FILE"
        fi

        echo "----------------------------------------" | tee -a "$LOG_FILE"
    )
}

# Get the directories that need to be restarted
if [ "$#" -eq 0 ]; then
    dirs=(*/)
else
    dirs=("$@")
fi

for dir in "${dirs[@]}"; do
    # Remove the trailing slash
    dir="${dir%/}"

    # Check if the directory exists
    if [ -d "$dir" ]; then
        # Check if start.sh script exists
        if [ -f "$dir/start.sh" ]; then
            restart_app "$dir"
        else
            echo "$dir is not a JAR application directory, skipping" | tee -a "$LOG_FILE"
        fi
    else
        echo "$dir directory does not exist, skipping" | tee -a "$LOG_FILE"
    fi
done

echo "All applications have been restarted." | tee -a "$LOG_FILE"