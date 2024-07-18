# Define variables
$sshpassUrl = "https://github.com/kevinburke/sshpass/releases/download/1.09/sshpass-1.09-windows-64bit.zip"
$sshpassZip = "$env:TEMP\sshpass.zip"
$sshpassExtractedDir = "$env:TEMP\sshpass_dir"
$sshpassExe = "C:\ProgramData\sshpass\sshpass.exe"
$publicKeyPath = "$env:USERPROFILE\.ssh\id_ed25519_tensor.pub"
$privateKeyPath = "$env:USERPROFILE\.ssh\id_ed25519_tensor"
$serverUsername = "KnowlesTensor1991"
$serverIP = "100.11.125.215"
$sshPort = "20004"
$serverPassword = "Love1991$"

# Function to download and install sshpass manually
function Install-Sshpass {
    Write-Output "Manually downloading sshpass..."
    Invoke-WebRequest -Uri $sshpassUrl -OutFile $sshpassZip
    Expand-Archive -Path $sshpassZip -DestinationPath $sshpassExtractedDir
    Move-Item -Path "$sshpassExtractedDir\sshpass.exe" -Destination $sshpassExe -Force
    Write-Output "sshpass installed successfully."
}

# Ensure Chocolatey is installed
if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Install sshpass
if (-Not (Test-Path $sshpassExe)) {
    Install-Sshpass
} else {
    Write-Output "sshpass is already installed."
}

# Generate SSH key pair
Write-Output "Generating SSH key pair..."
ssh-keygen -t ed25519 -f $privateKeyPath -N "" -C "your_email@example.com"

# Copy public key to server
Write-Output "Copying public key to the server..."
& $sshpassExe -p $serverPassword ssh-copy-id -i $publicKeyPath -p $sshPort "$serverUsername@$serverIP"

Write-Output "SSH key setup complete."
