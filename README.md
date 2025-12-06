# Student CI/CD Challenge (Go)

This project demonstrates a complete end-to-end CI/CD (Continuous Integration/Continuous Deployment) pipeline for a simple Go application. The workflow automates building, testing, containerizing with Docker, and deploying the application.

## Table of Contents

1.  [Application Overview](#application-overview)
2.  [CI/CD Pipeline](#cicd-pipeline)
3.  [Dockerization](#dockerization)
4.  [Deployment](#deployment)
5.  [Assignment Outputs](#assignment-outputs)
6.  [Local Development](#local-development)

---

## Application Overview

The application is a basic Go program that prints a greeting to the console.

-   **Language**: Go 1.23
-   **Functionality**: Prints "Hello, CI/CD World!" upon execution.

---

## CI/CD Pipeline

This project uses **GitHub Actions** to automate the software delivery lifecycle. The pipeline is defined in `.github/workflows/ci.yml`.

### Workflow Triggers

The pipeline runs automatically on:
-   **Push** to the `main` branch.
-   **Pull Request** targeting the `main` branch.

### Pipeline Steps

1.  **Checkout Code**: Downloads the repository source code.
2.  **Set up Go**: Sets up the specified Go version (`1.23`) in the runner environment.
3.  **Build**: Compiles the Go source code into a binary executable.
4.  **Test**: Runs any unit tests in the project. (Optional for this simple app).
5.  **Login to Docker Hub**: Authenticates with Docker Hub using securely stored secrets.
6.  **Build and Push Docker Image**: Builds a Docker image for the application and pushes it to Docker Hub. This step only runs on pushes to the `main` branch.

---

## Dockerization

The application is containerized using a multi-stage `Dockerfile` for an optimized and secure final image.

-   **Stage 1 (Builder)**: Uses the official `golang:1.23-alpine` image to compile the Go application into a static binary.
-   **Stage 2 (Final)**: Uses a minimal `alpine:latest` image, copying only the compiled binary from the builder stage. This results in a very small production image.

### Dockerfile

```dockerfile
# Stage 1: Build the Go application
FROM golang:1.23-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Stage 2: Create the final lightweight image
FROM alpine:latest

# Set the working directory
WORKDIR /root/

# Copy the pre-built binary from the builder stage
COPY --from=builder /app/main .

# Command to run the executable
CMD ["./main"]
```

---

## Deployment

The application is deployed as a Docker container. The container image is hosted on Docker Hub.

### Container Registry URL

The Docker image is publicly available at:
`https://hub.docker.com/repository/docker/imetroduck/student-ci-challenge/general`

### How to Run the Application

To run the deployed application, you need Docker installed on your machine. Execute the following command:

```bash
docker run --rm imetroduck/student-ci-challenge:latest
```

You should see the output: `Hello, CI/CD World!`

---

## Task Outputs

This section provides the specific outputs required for the task submission.

1.  **Repository Link**:
    `https://github.com/AdebayoEmmanuel/student-ci-challenge-EmmanuelAdebayo`

2.  **Functional CI Pipeline + Screenshot**:
    -   The pipeline is configured in `.github/workflows/ci.yml`.
    -   A successful Pipeline run.

3.  **Dockerfile**:
    -   The `Dockerfile` is located in the root of the repository. The content is shown in the [Dockerization](#dockerization) section.

4.  **Container Registry URL**:
    `https://hub.docker.com/repository/docker/imetroduck/student-ci-challenge/general`

5.  **Pull Request**:
    `https://github.com/AdebayoEmmanuel/student-ci-challenge-EmmanuelAdebayo/pull/2`

6.  **Deployment Manifest (Optional)**:
    For this challenge, a simple `docker run` command is used for deployment, as described in the [Deployment](#deployment) section. A more complex deployment could be managed with a `docker-compose.yml` or a Kubernetes manifest, but is not required here.

---

## Local Development

To run and modify this application locally:

1.  **Prerequisites**:
    -   Go 1.23 or later installed.
    -   Git installed.

2.  **Setup**:
    ```bash
    # Clone the repository
    git clone https://github.com/AdebayoEmmanuel/student-ci-challenge-EmmanuelAdebayo.git
    cd student-ci-challenge-EmmanuelAdebayo

    # Download dependencies
    go mod tidy
    ```

3.  **Run the application**:
    ```bash
    go run main.go
    ```

4.  **Build the application**:
    ```bash
    go build -o app .
    ./app
    ```