#!/bin/bash

set -xe

# List of packages to add dependencies to
PACKAGES=(
    "http_lambda_1"
    "http_lambda_2"
)

# Define the dependencies
DEPENDENCIES=(
    "lambda_http"
    "lambda_runtime"
    "serde --features derive"
    "serde_json"
    "tokio --features full"
    "tracing"
    "tracing-subscriber --features json"
)

# Function to add dependencies to a package
add_dependencies_to_package() {
    local package=$1
    echo "Adding dependencies to package: $package"
    
    for dep in "${DEPENDENCIES[@]}"; do
        echo "Adding dependency: $dep to $package"
        cargo add $dep --package $package
    done
}

# Loop through each specified package and add dependencies
for package in "${PACKAGES[@]}"; do
    add_dependencies_to_package $package
done

# Add dependencies to the common library
cargo add tracing  --package common
cargo add tracing-subscriber --features json  --package common
