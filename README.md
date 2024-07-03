# Deploy-Hub

## Description

**Deploy-Hub** is a powerful command-line tool designed to streamline the management of Docker Compose deployments. With a few simple commands, you can easily initialize new deployable Docker Compose folders, run services in the background, and shut them down when needed. Deploy-Hub enhances your DevOps workflow by simplifying the deployment and management of containerized applications.

## Features

- **Initialize Deployable Folders**: Quickly create new folders with a Docker Compose file, README.md, and .env file using a single command.
- **Run Services**: Deploy services defined in your Docker Compose files effortlessly and run them in the background.
- **Stop Services**: Easily shut down running services with a simple command.
- **User-Friendly**: Enjoy a delightful user experience with informative messages.

## Usage

1. **Initialize a new deployable folder**:
    ```sh
    deploy-hub init <folder-name>
    ```
    This will create a new folder under the `deployable` directory with the necessary files.

2. **Run a specific deployment**:
    ```sh
    deploy-hub run <folder-name>
    ```
    This command will navigate to the specified folder and run the Docker Compose file in the background.

3. **Stop a specific deployment**:
    ```sh
    deploy-hub stop <folder-name>
    ```
    This command will shut down the services defined in the Docker Compose file.

## Installation

To install Deploy-Hub via Homebrew, follow these steps:

1. Add the custom tap:
    ```sh
    brew tap cs4alhaider/deploy-hub
    ```

2. Install Deploy-Hub:
    ```sh
    brew install deploy-hub
    ```

## Contributing

Contributions are welcome! Please feel free to submit a pull request or open an issue to improve Deploy-Hub.

## Author

- **Abdullah Alhaider**
- Email: [cs.alhaider@gmail.com](mailto:cs.alhaider@gmail.com)

## License

Deploy-Hub is released under the MIT License.
