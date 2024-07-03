#!/bin/bash

# Function to initialize a new deployable folder
init_deployable() {
    # Check if a folder name is provided
    if [ -z "$1" ]; then
        echo "🚫 Error: No folder name provided."
        echo "📋 Usage: deploy-hub init <folder-name>"
        exit 1
    fi

    # Define the folder name and paths
    local folder_name=$1
    local folder_path="deployable/$folder_name"
    local compose_file="$folder_path/$folder_name.yml"

    # Create the folder and necessary files
    mkdir -p "$folder_path"
    touch "$compose_file" "$folder_path/README.md" "$folder_path/.env"

    # Output success message
    echo "📁 Initialized new deployable folder: $folder_path"
    echo "✅ Created $compose_file, README.md, and .env"
}

# Function to run a docker-compose file from a specific folder
run_deployable() {
    # Check if a folder name is provided
    if [ -z "$1" ]; then
        echo "🚫 Error: No folder name provided."
        echo "📋 Usage: deploy-hub run <folder-name>"
        exit 1
    fi

    # Define the folder name and paths
    local folder_name=$1
    local folder_path="deployable/$folder_name"
    local compose_file="$folder_path/$folder_name.yml"

    # Check if the docker-compose file exists
    if [ ! -f "$compose_file" ]; then
        echo "🚫 Error: $compose_file not found."
        exit 1
    fi

    # Navigate to the folder, run docker-compose, and return to the previous directory
    cd "$folder_path"
    docker-compose -f "$compose_file" up -d
    cd - > /dev/null

    # Output success message
    echo "🚀 Deployed $folder_name using $compose_file"
}

# Function to stop a docker-compose service from a specific folder
stop_deployable() {
    # Check if a folder name is provided
    if [ -z "$1" ]; then
        echo "🚫 Error: No folder name provided."
        echo "📋 Usage: deploy-hub stop <folder-name>"
        exit 1
    fi

    # Define the folder name and paths
    local folder_name=$1
    local folder_path="deployable/$folder_name"
    local compose_file="$folder_path/$folder_name.yml"

    # Check if the docker-compose file exists
    if [ ! -f "$compose_file" ]; then
        echo "🚫 Error: $compose_file not found."
        exit 1
    fi

    # Navigate to the folder, stop docker-compose, and return to the previous directory
    cd "$folder_path"
    docker-compose -f "$compose_file" down
    cd - > /dev/null

    # Output success message
    echo "🛑 Stopped $folder_name using $compose_file"
}

# Main script logic
# Check if at least two arguments are provided
if [ "$#" -lt 2 ]; then
    echo "🚫 Error: Invalid arguments."
    echo "📋 Usage: deploy-hub <command> <folder-name>"
    echo "Commands: init, run, stop"
    exit 1
fi

# Get the command and folder name from the arguments
command=$1
folder_name=$2

# Execute the corresponding function based on the command
case $command in
    init)
        init_deployable "$folder_name"
        ;;
    run)
        run_deployable "$folder_name"
        ;;
    stop)
        stop_deployable "$folder_name"
        ;;
    *)
        echo "🚫 Error: Invalid command."
        echo "Commands: init, run, stop"
        exit 1
        ;;
esac
