#!/bin/bash

# Define color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to initialize a new deployable folder
init_deployable() {
    # Check if a folder name is provided
    if [ -z "$1" ]; then
        echo -e "${RED}🚫 Error: No folder name provided.${NC}"
        echo -e "${YELLOW}📋 Usage: deploy-hub init <folder-name>${NC}"
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
    echo -e "${GREEN}📁 Initialized new deployable folder: $folder_path${NC}"
    echo -e "${GREEN}✅ Created $compose_file, README.md, and .env${NC}"
}

# Function to run a docker-compose file from a specific folder
run_deployable() {
    # Check if a folder name is provided
    if [ -z "$1" ]; then
        echo -e "${RED}🚫 Error: No folder name provided.${NC}"
        echo -e "${YELLOW}📋 Usage: deploy-hub run <folder-name>${NC}"
        exit 1
    fi

    # Define the folder name and paths
    local folder_name=$1
    local folder_path="deployable/$folder_name"
    local compose_file="$folder_path/$folder_name.yml"

    # Check if the docker-compose file exists
    if [ ! -f "$compose_file" ]; then
        echo -e "${RED}🚫 Error: $compose_file not found.${NC}"
        exit 1
    fi

    # Navigate to the folder, run docker-compose, and return to the previous directory
    cd "$folder_path"
    docker-compose -f "$compose_file" up -d
    cd - > /dev/null

    # Output success message
    echo -e "${GREEN}🚀 Deployed $folder_name using $compose_file${NC}"
}

# Function to run docker-compose files from all deployable folders
run_all_deployables() {
    local base_folder="deployable"
    
    # Iterate over all folders in the base deployable folder
    for folder in "$base_folder"/*; do
        if [ -d "$folder" ]; then
            local folder_name=$(basename "$folder")
            local compose_file="$folder/$folder_name.yml"

            # Check if the docker-compose file exists
            if [ -f "$compose_file" ]; then
                # Navigate to the folder, run docker-compose, and return to the previous directory
                cd "$folder"
                docker-compose -f "$compose_file" up -d
                cd - > /dev/null

                # Output success message
                echo -e "${GREEN}🚀 Deployed $folder_name using $compose_file${NC}"
            else
                echo -e "${RED}🚫 Error: $compose_file not found in $folder.${NC}"
            fi
        fi
    done
}

# Function to stop a docker-compose service from a specific folder
stop_deployable() {
    # Check if a folder name is provided
    if [ -z "$1" ]; then
        echo -e "${RED}🚫 Error: No folder name provided.${NC}"
        echo -e "${YELLOW}📋 Usage: deploy-hub stop <folder-name>${NC}"
        exit 1
    fi

    # Define the folder name and paths
    local folder_name=$1
    local folder_path="deployable/$folder_name"
    local compose_file="$folder_path/$folder_name.yml"

    # Check if the docker-compose file exists
    if [ ! -f "$compose_file" ]; then
        echo -e "${RED}🚫 Error: $compose_file not found.${NC}"
        exit 1
    fi

    # Navigate to the folder, stop docker-compose, and return to the previous directory
    cd "$folder_path"
    docker-compose -f "$compose_file" down
    cd - > /dev/null

    # Output success message
    echo -e "${GREEN}🛑 Stopped $folder_name using $compose_file${NC}"
}

# Function to stop all docker-compose services from all deployable folders
stop_all_deployables() {
    local base_folder="deployable"
    
    # Iterate over all folders in the base deployable folder
    for folder in "$base_folder"/*; do
        if [ -d "$folder" ]; then
            local folder_name=$(basename "$folder")
            local compose_file="$folder/$folder_name.yml"

            # Check if the docker-compose file exists
            if [ -f "$compose_file" ]; then
                # Navigate to the folder, stop docker-compose, and return to the previous directory
                cd "$folder"
                docker-compose -f "$compose_file" down
                cd - > /dev/null

                # Output success message
                echo -e "${GREEN}🛑 Stopped $folder_name using $compose_file${NC}"
            else
                echo -e "${RED}🚫 Error: $compose_file not found in $folder.${NC}"
            fi
        fi
    done
}

# Main script logic
# Check if at least one argument is provided
if [ "$#" -lt 1 ]; then
    echo -e "${RED}🚫 Error: Invalid arguments.${NC}"
    echo -e "${YELLOW}📋 Usage: deploy-hub <command> [folder-name]${NC}"
    echo -e "${YELLOW}Commands: init, run, run -a|--all, stop, stop -a|--all${NC}"
    exit 1
fi

# Get the command and optional folder name from the arguments
command=$1
folder_name=$2

# Execute the corresponding function based on the command
case $command in
    init)
        init_deployable "$folder_name"
        ;;
    run)
        if [[ "$folder_name" == "-a" || "$folder_name" == "--all" ]]; then
            run_all_deployables
        else
            run_deployable "$folder_name"
        fi
        ;;
    stop)
        if [[ "$folder_name" == "-a" || "$folder_name" == "--all" ]]; then
            stop_all_deployables
        else
            stop_deployable "$folder_name"
        fi
        ;;
    *)
        echo -e "${RED}🚫 Error: Invalid command.${NC}"
        echo -e "${YELLOW}Commands: init, run, run -a|--all, stop, stop -a|--all${NC}"
        exit 1
        ;;
esac
