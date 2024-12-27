# install: Install-Module -Name PowerShellGet -Force -Scope CurrentUser -AllowClobber 
# install: Install-Module PSReadLine -Force
Import-Module PSReadLine
Import-Module posh-git

Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -PredictionSource History