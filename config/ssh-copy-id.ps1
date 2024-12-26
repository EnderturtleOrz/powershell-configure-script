# Author: Tianci Hou (EnderturleOrz on GitHub)
# Description: a PowerShell script to copy the public key to a remote machine
# Usage: ssh-copy-id [user@]machine [-p port]

function ssh-copy-id([string]$userAtMachine, $args){   
    $publicKey = "$ENV:USERPROFILE" + "/.ssh/id_rsa.pub"
    if (!(Test-Path "$publicKey")){
        Write-Error "publicKey not found"            
    }
    else {
        & cat "$publicKey" | ssh $args $userAtMachine "umask 077; test -d .ssh || mkdir .ssh ; cat >> .ssh/authorized_keys || exit 1"      
    }
}