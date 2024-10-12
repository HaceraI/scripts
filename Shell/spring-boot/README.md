# Application Management Scripts

This repository contains a set of shell scripts for managing Java Spring Boot applications. The scripts are designed to help with starting, stopping, and restarting applications, along with logging functionalities.

## Table of Contents

- [Scripts Overview](#scripts-overview)
- [Usage Instructions](#usage-instructions)
  - [1. start.sh](#1-startsh)
  - [2. stop.sh](#2-stopsh)
  - [3. restart.sh](#3-restartsh)
  - [4. stopall.sh](#4-stopallsh)
- [Requirements](#requirements)
- [License](#license)
- [Author](#author)

## Scripts Overview

### 1. `start.sh`

This script is used to start a specified Spring Boot application. It checks if the application is already running and handles the initialization of the application jar file.

#### Key Features:
- Automatically finds the jar file if not specified.
- Logs the startup process.
- Supports a restart option to stop and then start the application.

### 2. `stop.sh`

This script stops a running Spring Boot application.

#### Key Features:
- Checks if the application is running before attempting to stop it.
- Logs the stopping process.
- Handles errors during the stopping process.

### 3. `restart.sh`

This script restarts a specified Spring Boot application by first stopping it and then starting it again.

#### Key Features:
- Uses the `stop.sh` script to stop the application.
- Uses the `start.sh` script to start the application.
- Logs the restart process.

### 4. `stopall.sh`

This script stops all specified Spring Boot applications within the subdirectories of the current directory.

#### Key Features:
- Iterates through directories and calls the `stop.sh` script for each application.
- Logs the stopping process for each application.

## Usage Instructions

### 1. start.sh

To start an application:

```bash
./start.sh [options]
```

**Options:**
- `-r`: Restart the application if it is already running.

**Example:**

```bash
./start.sh
```

### 2. stop.sh

To stop an application:

```bash
./stop.sh
```

### 3. restart.sh

To restart an application:

```bash
./restart.sh
```

### 4. stopall.sh

To stop all applications in the subdirectories:

```bash
./stopall.sh [directory1 directory2 ...]
```

If no directories are specified, it will attempt to stop applications in all subdirectories of the current directory.

## Requirements

- Bash shell
- Java Runtime Environment (JRE)
- Proper permissions to execute scripts

## License

This project is licensed under the Apache 2.0 License. See the [LICENSE](LICENSE) file for details.

## Author

- **Haceral** - [haceral@163.com](mailto:haceral@163.com)

Feel free to contribute to this project or reach out if you have any questions or suggestions!