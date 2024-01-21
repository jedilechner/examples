# Use the cargo-lambda image
FROM ghcr.io/cargo-lambda/cargo-lambda:latest

# Create a directory for your application
WORKDIR /usr/src/app

# Copy your source code into the container
COPY . .

# Build the project using cargo lambda
RUN cargo lambda build --release --arm64
