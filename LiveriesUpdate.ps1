# Define repository owner and name
$repoOwner = "pschilly"
$repoName = "gtfo-liveries"

# Fetch repository metadata from GitHub API to get the default branch
$repoApiUrl = "https://api.github.com/repos/$repoOwner/$repoName"
$repoData = Invoke-RestMethod -Uri $repoApiUrl -Headers @{"User-Agent"="PowerShell"}
$defaultBranch = $repoData.default_branch

# Construct the latest branch ZIP URL dynamically
$zipUrl = "https://github.com/$repoOwner/$repoName/archive/refs/heads/$defaultBranch.zip"

# Set up local paths
$downloadZip = ".\DCS_Liveries.zip"
$extractedFolder = ".\$repoName-$defaultBranch"
$finalFolder = ".\DCS_Liveries"

# Ensure no previous extraction exists (to avoid conflicts)
if (Test-Path $extractedFolder) {
    Write-Host "Removing previous extracted files..."
    Remove-Item -Path $extractedFolder -Recurse -Force
}

if (Test-Path $finalFolder) {
    Write-Host "Removing previous installation folder..."
    Remove-Item -Path $finalFolder -Recurse -Force
}

# Download the latest ZIP
Write-Host "Downloading from GitHub (Branch: $defaultBranch)"
$ProgressPreference = 'SilentlyContinue'
Invoke-WebRequest -Uri $zipUrl -OutFile $downloadZip

# Extract ZIP with overwrite protection
Write-Host "Extracting files..."
Expand-Archive -Path $downloadZip -DestinationPath .\ -Force

# Rename extracted folder to a standard name
Rename-Item -Path $extractedFolder -NewName $finalFolder

# Remove ZIP file after extraction
Remove-Item $downloadZip

# Remove README if it exists
$readmePath = "$finalFolder\Liveries\README.md"
if (Test-Path $readmePath) {
    Remove-Item $readmePath -Force
}

# Copy liveries to Saved Games
$liveriesPath = "$env:USERPROFILE\Saved Games\DCS\Liveries"
Write-Host "Copying liveries..."
Copy-Item -Path "$finalFolder\Liveries\*" -Destination $liveriesPath -Recurse -Force

# Clean up extracted folder
Remove-Item $finalFolder -Recurse -Force

Write-Host "Liveries Installed/Updated Successfully!"
pause
