#!/bin/bash

echo -e "Enter new ssh host: \c"
read -r host

echo $host >> /home/blank/Documents/Random/bashScripts/sshelper/sshHosts.txt
ssh-copy-id $host


