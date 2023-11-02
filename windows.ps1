# Absolute path to your storage directory
$REPO_DIR = "C:\path\to\repo_storage\dir"
$REPO_NAME = "repo"
$DIST_DIR = "C:\path\to\dist"

# Navigate to the storage directory
Set-Location $REPO_DIR

# Clone the private repository
if (!(git clone git@github.com:username/$REPO_NAME.git)) {
    Write-Output "Git clone failed!"
    exit 1
}

# Navigate to the cloned repository directory
Set-Location "$REPO_DIR\$REPO_NAME"

# Use the cargo package manager to compile the project with optimizations
if (!(cargo build --release)) {
    Write-Output "Cargo build failed!"
    exit 1
}

# Navigate to the dist directory
Set-Location $DIST_DIR

# Get the filename, extract the unique identifier, and copy it to the clipboard
(Get-ChildItem -Filter "projectname*.wasm" | 
 ForEach-Object { $_.BaseName -replace '^projectname-', '' -replace '_bg$', '' }) | Set-Clipboard
