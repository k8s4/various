#!/bin/bash

bashrc="~/.bashrc"

echo "alias ll='ls -la'" > $bashrc
echo "alias dc='docker'" > $bashrc
echo "alias temp='sensors && sudo hddtemp /dev/sd? | grep -v "not available" && nvidia-smi -q -d temperature'" > $bashrc
echo "cat /proc/mdstat | grep md0"

apt update apt upgrade -y

apt install apt-transport-https mc htop vim nmap screen mdadm tmux hddtemp lm-sensors smartmontools whois lsscsi procinfo procinfo sg3-utils sg3-utils-udev traceroute nvme-cli dos2unix -y
apt install audacity shutter virtualbox zoom pidgin skypeforlinux fbreader vlc gimp steam firefox sweethome3d simplescreenrecorder remmina teamviewer sublime-text imagemagick -y
apt install jackd qjackctl supercollider-server transmission nut nut-client nut-server nvidia-kernel-common nvidia-driver nvidia-settings sonic-pi -y

