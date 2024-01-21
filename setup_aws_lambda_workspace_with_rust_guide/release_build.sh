#!/bin/bash

# '-e' option causes the script to exit immediately if any command exits with a non-zero status.
# '-x' option causes the script to print each command to standard output (with a few exceptions) before executing it, useful for debugging.
set -xe

# This command removes any previously built artifacts in your Rust project. This ensures that your Docker build starts with a clean state.
cargo clean

# This command builds a Docker image from the Dockerfile in the current directory ('.').
# The '-t' flag tags the resulting image with the name 'rust-lambda'.
docker build -t rust-lambda .

# This command creates a new Docker container named 'temp-container' from the 'rust-lambda' image.
# However, it does not start the container. It's used to prepare the container for copying files out of it.
docker create --name temp-container rust-lambda

# This command copies the '/usr/src/app/target/' directory from the 'temp-container' container into the current directory on the host machine.
# This is typically used to retrieve build artifacts from a build container.
docker cp temp-container:/usr/src/app/target/ ./

# This command removes the 'temp-container' container. 
# It's a cleanup step to ensure that the temporary container does not persist after the script is done.
docker rm temp-container

