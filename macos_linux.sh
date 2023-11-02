#!/bin/bash

# Absolute path to your storage directory
REPO_DIR="/absolute/path/to/repo_storage/dir"
REPO_NAME="repo"
DIST_DIR="/absolute/path/to/dist"

# Navigate to the storage directory
cd "$REPO_DIR"

# Clone the private repository
if ! git clone git@github.com:username/$REPO_NAME.git; then
    echo "Git clone failed!"
    exit 1
fi

# Navigate to the cloned repository directory
cd "$REPO_DIR/$REPO_NAME"

# Use cargo package manager to compile the project with optimizations
if ! cargo build --release; then
    echo "Cargo build failed!"
    exit 1
fi

if ! trunk build --release; then
    echo "Trunk build failed!"
    exit 1
fi

# Navigate to the dist directory
cd "$DIST_DIR"

# Get the filename and extract the unique identifier
unique_id=$(ls projectname*.wasm | sed -E 's/^projectname-(.+)_bg\.wasm/\1/')

# Copy the unique identifier to the clipboard based on OS
case "$(uname)" in
    Darwin)
        echo $unique_id | pbcopy
        ;;
    Linux)
        echo $unique_id | xclip -selection clipboard
        ;;
    *)
        echo "Unsupported operating system"
        exit 1
        ;;
esac
