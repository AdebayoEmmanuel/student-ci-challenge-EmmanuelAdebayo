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