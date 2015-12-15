#!/bin/bash

# Install GDB-Peda
perl -e 'print "# Source all settings from the peda dir\n" . "source ~/peda/peda.py\n\n" . "# These are other settings I have found useful\n\n" . "# Intel syntax is more readable\n" . "set disassembly-flavor intel\n\n" . "# When inspecting large portions of code the scrollbar works better than \"less\"\n" . "set pagination off\n\n" . "# Keep a history of all the commands typed. Search is possible using ctrl-r\n" . "set history save on\n" . "set history filename ~/.gdb_history\n" . "set history size 32768\n" . "set history expansion on"' > ~/.gdbinit
cd /opt/ && git clone https://github.com/longld/peda && sed -i 's/: (\"off\"/: (\"on\"/g' /opt/peda/lib/config.py

# VIM Config File
wget https://github.com/tentpegbob/bearded-cyril -O ~/.vimrc

# Install Network Miner
sudo apt-get install -y --fix-missing libmono-winforms2.0-cil
wget sf.net/projects/networkminer/files/latest -O /tmp/nm.zip
sudo unzip /tmp/nm.zip -d /opt/
cd /opt/NetworkMiner*
sudo chmod +x NetworkMiner.exe
sudo chmod -R go+w AssembledFiles/
sudo chmod -R go+w Captures/

# Discover Scripts
cd /opt
git clone https://github.com/leebaird/discover && cd discover && ./setup.sh && cd ..

# PowerSploit
cd /opt
git clone https://github.com/mattifestation/PowerSploit && cd PowerSploit && wget https://raw.github.com/obscuresec/random/master/StartListener.py && wget https://raw.github.com/darkoperator/powershell_scripts/master/ps_encoder.py

# Burp Fuzz Parameters
cd /opt
git clone https://github.com/danielmiessler/SecLists

# Enhanced NMAP Scripts
cd /usr/share/nmap/scripts
wget https://raw.github.com/hdm/scan-tools/master/nse/banner-plus.nse

# Extra Installs
## Install pwntools
sudo pip install pwntools
## BeEF
sudo apt-get install --fix-missing -y beef-xss
## Flawfinder
sudo apt-get install --fix-missing -y flawfinder


# Update the VM
sudo apt-get update -y; sudo apt-get dist-upgrade -y
