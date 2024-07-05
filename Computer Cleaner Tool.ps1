# Initialize the Shell.Application COM object
$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace(0xA)

# 1. Empty Recycler Bin
Write-Host "Emptying Recycle Bin..."
try {
    $objFolder.items() | ForEach-Object {
        try {
            $filePath = $_.path
            Remove-Item $filePath -Recurse -Force -Confirm:$false -ErrorAction Stop
            Write-Host "Removed: $filePath" -ForegroundColor Green
        } catch {
            Write-Host "Failed to remove: $filePath - $_" -ForegroundColor Red
        }
    }
} catch {
    Write-Host "Failed to empty recycle bin: $_" -ForegroundColor Red
}

# 2. Remove Temporary Files
Write-Host "Removing Temporary Files..."

# Define a function to remove files from a specific directory
function Remove-Files {
    param (
        [string]$path
    )
    try {
        Get-ChildItem -Path $path -Recurse -Force -ErrorAction Stop | ForEach-Object {
            $filePath = $_.FullName
            try {
                Remove-Item $filePath -Force -ErrorAction Stop -Recurse
                Write-Host "Removed: $filePath" -ForegroundColor Green
            } catch {
                if ($_.Exception.GetType().Name -eq "IOException") {
                    Write-Host "File in use: $filePath" -ForegroundColor Red
                } elseif ($_.Exception.GetType().Name -eq "UnauthorizedAccessException") {
                    Write-Host "Access denied: $filePath" -ForegroundColor Red
                } elseif ($_.Exception.GetType().Name -eq "FileNotFoundException") {
                    Write-Host "File not found: $filePath" -ForegroundColor Red
                } else {
                    Write-Host "Failed to remove file: $filePath - $_" -ForegroundColor Red
                }
            }
        }
    } catch {
        Write-Host "Failed to list files in ${path}: $_" -ForegroundColor Red
    }
}

# Remove files from specific directories
Remove-Files -Path "C:\Windows\Temp\*"
Remove-Files -Path "C:\Windows\Prefetch\*"
Remove-Files -Path "C:\Documents and Settings\*\Local Settings\temp\*"
Remove-Files -Path "C:\Users\*\AppData\Local\Temp\*"

# 3. Running Disk Tool
Write-Host "Running Windows Disk Cleanup Tool..."
try {
    cleanmgr /sagerun:1 | Out-Null
} catch {
    Write-Host "Failed to run Disk Cleanup Tool: $_" -ForegroundColor Red
}

$([char]7)
Write-Host "...Cleanup Completed!" -ForegroundColor Green

# Pause for 3 seconds before ending the script
Sleep 3

### END SCRIPT





