$objShell = New-Object -ComObject Shell.Application
$objFolder = $objShell.Namespace(0xA)

#1# Empty Recycler Bin #
    Write-Host "Emptying Recycle Bin." -ForegroundColor Cyan
    $objFolder.items() | %{Remove-Item $_/path -Recurse -Confirm:$false}

#2# Remove Temp #
    Write-Host "Removing Temporary Files" -ForegroundColor Green
    Set-Location "C:\Windows\Temp"
    Remove-Item * -Recurse -Force -ErrorAction SilentlyContinue

    Set-Location "C:\Windows\Prefetch"
    Remove-Item * -Recurse -Force -ErrorAction SilentlyContinue

    Set-Location "C:\Documents and Settings"
    Remove-Item ".\*\Local Settings\temp\*" -Recurse -Force -ErrorAction SilentlyContinue

    Set-Location "C:\Users"
    Remove-Item ".\*\Appdata\Local\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue

#3# Running Disk Tool #
    Write-Host "Finaly Now, Running Windows Disk Cleanup Tool" -ForegroundColor Cyan
    cleanmgr /sagerun:1 | Out-Null

    $([char]7)
    Sleep 3
    Write-Host "You Have Succesfully Completed the Cleanup Task, Now Enjoy Your Super Computer with Super Speed" -ForegroundColor Green
  
    Sleep 3

### END SCRIPT