# Author: Tianci Hou (EnderturleOrz on GitHub)
# Description: PowerShell configuration script to install and configure modules and append content to $PROFILE.
# Usage: Run this script in PowerShell to install and configure modules and append content to $PROFILE.

# If you cannot run this script, you may need to change the execution policy.
# Run command in PowerShell as an administrator: Set-ExecutionPolicy RemoteSigned

function Append-ContentToProfile {
    param (
        [string]$filePath
    )
    Get-Content -Path $filePath | Add-Content -Path $PROFILE
}

function Install-ModuleIfSelected {
    param (
        [string]$moduleName,
        [string]$installCommand
    )
    Invoke-Expression $installCommand
}

Write-Host "Welcome to the PowerShell configuration script!"
Write-Host "This script will install and configure modules and append content to your PowerShell profile."
Write-Host "You can always run this script again to update or customize your configuration."
Write-Host "To enable all features, please install Nerd Fonts https://www.nerdfonts.com/font-downloads."
Write-Host "If you want to change the startup configuration including themes, you can manually $PROFILE."
Write-Host ""

$initialMode = Read-Host "Select initial mode: (Y)es for install and configure all, (C)ustomize, (N)o for exit"
$configFiles = Get-ChildItem -Path "./config" -Filter "*.ps1"

switch ($initialMode.ToUpper()) {
    "Y" {
        # Install all modules and append all content to $PROFILE
        foreach ($file in $configFiles) {
            Write-Host "$file is installing and configuring..."
            $lines = Get-Content -Path $file.FullName
            foreach ($line in $lines) {
                if ($line -match "^# install: ") {
                    $installCommand = $line -replace "^# install: \s*", ""
                    $moduleName = $installCommand -split " " | Select-Object -First 1
                    Install-ModuleIfSelected -moduleName $moduleName -installCommand $installCommand
                }
            }
            Append-ContentToProfile -filePath $file.FullName
        }
    }
    "C" {
        # Custom settings
        Write-Host ""
        $customMode = Read-Host "Select custom mode: (S)elective install and configure, (U)pdate selected modules, (N)o for exit"

        switch ($customMode.ToUpper()) {
            "S" {
                # Selective install and configure
                try {
                    $fileNames = $configFiles | ForEach-Object { $_.Name }
                    $selectedFiles = $fileNames | fzf --multi --prompt "Select files to install: " --header "Use TAB to select multiple files"
                    $selectedFilesArray = $selectedFiles -split "`n"
                } catch {
                    Write-Host "fzf not found, falling back to manual selection"
                    $selectedFilesArray = @()
                    foreach ($file in $configFiles) {
                        $fileName = $file.Name
                        $install = Read-Host "Do you want to install and configure ${fileName}? (Y/N)"
                        if ($install.ToUpper() -eq "Y") {
                            $selectedFilesArray += $fileName
                        }
                    }
                }
                foreach ($fileName in $selectedFilesArray) {
                    $fileName = $fileName.Trim()
                    $file = $configFiles | Where-Object { $_.Name -eq $fileName }
                    if ($file) {
                        Write-Host "$fileName is installing and configuring..."
                        $lines = Get-Content -Path $file.FullName
                        foreach ($line in $lines) {
                            if ($line -match "^# install") {
                                $installCommand = $line -replace "^# install\s*", ""
                                $moduleName = $installCommand -split " " | Select-Object -First 1
                                Install-ModuleIfSelected -moduleName $moduleName -installCommand $installCommand
                            }
                        }
                        Append-ContentToProfile -filePath $file.FullName
                    } else {
                        Write-Host "File $fileName not found."
                    }
                }
            }
            "U" {
                # Update selected modules
                try {
                    $fileNames = $configFiles | ForEach-Object { $_.Name }
                    $selectedFiles = $fileNames | fzf --multi --prompt "Select files to install: " --header "Use TAB to select multiple files"
                    $selectedFilesArray = $selectedFiles -split "`n"
                } catch {
                    Write-Host "fzf not found, falling back to manual selection"
                    foreach ($file in $configFiles) {
                        $fileName = $file.Name
                        $install = Read-Host "Do you want to update ${fileName}? (Y/N)"
                        if ($install.ToUpper() -eq "Y") {
                            $selectedFilesArray += $fileName
                        }
                    }
                }

                foreach ($fileName in $selectedFilesArray) {
                    $fileName = $fileName.Trim()
                    $file = $configFiles | Where-Object { $_.Name -eq $fileName }
                    if ($file) {
                        Write-Host "$fileName is updating..."
                        $lines = Get-Content -Path $file.FullName
                        foreach ($line in $lines) {
                            if ($line -match "^# install") {
                                $installCommand = $line -replace "^# install\s*", ""
                                $moduleName = $installCommand -split " " | Select-Object -First 1
                                Install-ModuleIfSelected -moduleName $moduleName -installCommand $installCommand
                            }
                        }
                    } else {
                        Write-Host "File $fileName not found."
                    }
                }
            }
            "N" {
                Write-Host "Exiting."
            }
            default {
                Write-Host "Invalid selection. Please run the script again and select a valid mode."
            }
        }
    }
    "N" {
        Write-Host "Exiting."
    }
    default {
        Write-Host "Invalid selection. Please run the script again and select a valid mode."
    }
}