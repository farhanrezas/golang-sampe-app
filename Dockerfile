# Use an official Golang runtime as a parent image
FROM golang:1.18

# Set the working directory inside the container
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . .

# Build the Go application
RUN go build -o go-sample-app 

# Test the Go application
RUN go test ./...

# Expose a port for the application (adjust as needed)
EXPOSE 8070

# Define the command to run your application
CMD ["./go-sample-app"]
