#!/bin/bash

declare -a hosts
index=0

echo "***********************************************"
echo "************* SSH Helper **********************"
echo "***********************************************"

getHosts () 
{
  index=0
  unset hosts
  while read i; do
      hosts[$index]=$i
      ((index=index+1))
  done < /home/blank/Documents/Random/bashScripts/sshelper/sshHosts.txt
  hostsLength=${#hosts[@]}
  lastHostIndex=$((hostsLength-1))
}

print () 
{
  echo 
  echo 
  for i in "${!hosts[@]}"
  do 
    echo \[$i\] ${hosts[$i]}
  done
  echo 
  echo \[E\] Edit hosts.
  echo \[A\] Add host.
  echo \[X\] Exit.
}

getInput ()
{
  read -r -p "Enter Selection: " input
}

connect () 
{
  hostip=$(echo $1 | awk -F'@' '{print $2}')
  isUnReachable=$(ping $hostip -c 1 |  grep Unreachable | wc -l)
  if [ $isUnReachable = "1" ]
  then
    clear
    echo Host is unreachable.
    echo
    read -p "Press enter to continue..."
  else
    echo Connecting to $1
    ssh $1
    exit 1
  fi

}

addHost () 
{
  read -r -p "Enter new ssh host: " host

  echo $host >> /home/blank/Documents/Random/bashScripts/sshelper/sshHosts.txt
  ssh-copy-id $host
}


while [ true ]
do
  clear
  getHosts
  print
  getInput

  case $input in
    [Xx] ) clear;exit 1;;
    [Aa] ) addHost;;
    [Ee] ) vim /home/blank/Documents/Random/bashScripts/sshelper/sshHosts.txt;;
    [0-$lastHostIndex] ) connect ${hosts[$input]};;
    * ) echo Please enter a valid option.
  esac

done