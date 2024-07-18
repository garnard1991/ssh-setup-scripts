# setup_ssh_key_automated.ps1
# Script to automatically set up SSH keys and copy the public key to the server

# Install Chocolatey if it is not already installed
if (-not (Get-Command choco.exe -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force;
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072;
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'));
}

# Install sshpass using Chocolatey
Write-Host "Installing sshpass..."
choco install sshpass -y

# Variables
$sshpassUrl = "https://downloads.sourceforge.net/project/sshpass/sshpass/1.09/sshpass-1.09.zip"
$sshpassExe = "$env:TEMP\sshpass.zip"
$sshpassExtractedDir = "$env:TEMP\sshpass_dir"

# Download and extract sshpass
Write-Host "Manually downloading sshpass..."
Invoke-WebRequest -Uri $sshpassUrl -OutFile $sshpassExe
Expand-Archive -Path $sshpassExe -DestinationPath $sshpassExtractedDir
Move-Item -Path "$sshpassExtractedDir\sshpass.exe" -Destination "C:\ProgramData\chocolatey\bin\sshpass.exe" -Force

# Generate SSH key pair
Write-Host "Generating SSH key pair..."
$sshKeyPath = "$env:USERPROFILE\.ssh\id_ed25519_tensor"
ssh-keygen -t ed25519 -f $sshKeyPath -N ""

# Copy the public key to the server
$serverUser = "KnowlesTensor1991"
$serverIP = "100.11.125.215"
$sshPort = 20004
$serverPassword = "Love1991$"
$publicKeyPath = "$sshKeyPath.pub"

Write-Host "Copying public key to the server..."
sshpass -p $serverPassword ssh-copy-id -i $publicKeyPath -p $sshPort $serverUser@$serverIP

Write-Host "SSH key setup complete."
