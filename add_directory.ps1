# Get the directory of the current script (AddCustomDirectory.ps1)
$currentScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Definition
$mainScriptPath = Join-Path -Path $currentScriptDirectory -ChildPath "clean.ps1"

# Function to add custom directory to the main script
function Add-CustomDirectory {
    param (
        [string]$directory
    )

    # Check if the directory exists
    if (Test-Path -Path $directory) {
        # Read the content of the main script
        $scriptContent = Get-Content -Path $mainScriptPath -Raw

        # Check if the directory path already exists in the script content
        if ($scriptContent -match [regex]::Escape("Remove-Files -Path `"$directory\*`"")) {
            Write-Host "The directory '$directory' is already added to clean.ps1." -ForegroundColor Yellow
            return
        }

        # Find the position to insert the custom directory
        $insertIndex = $scriptContent.IndexOf("# 3. Running Disk Tool")
        if ($insertIndex -eq -1) {
            Write-Host "Could not find the insertion point. Aborting." -ForegroundColor Red
            return
        }

        # Insert the custom directory command before the specified line
        $customDirectoryCommand = "`r`nRemove-Files -Path `"$directory\*`""
        $scriptContent = $scriptContent.Insert($insertIndex, $customDirectoryCommand)

        # Add two blank lines after the inserted line
        $insertIndex += $customDirectoryCommand.Length
        $additionalLines = "`r`n`r`n"
        $scriptContent = $scriptContent.Insert($insertIndex, $additionalLines)

        # Write the updated content back to the main script
        Set-Content -Path $mainScriptPath -Value $scriptContent -Force

        Write-Host "Directory added successfully to clean.ps1." -ForegroundColor Green
    } else {
        Write-Host "The directory '$directory' does not exist." -ForegroundColor Red
    }
}

# Ask the user for a new directory to clean
$newDirectory = Read-Host -Prompt "Please enter the full path of the directory you want to add for cleaning"

# Add the custom directory
Add-CustomDirectory -directory $newDirectory
