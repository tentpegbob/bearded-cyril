#!/bin/bash

# Install GDB-Peda
perl -e 'print "# Source all settings from the peda dir\n" . "source ~/peda/peda.py\n\n" . "# These are other settings I have found useful\n\n" . "# Intel syntax is more readable\n" . "set disassembly-flavor intel\n\n" . "# When inspecting large portions of code the scrollbar works better than \"less\"\n" . "set pagination off\n\n" . "# Keep a history of all the commands typed. Search is possible using ctrl-r\n" . "set history save on\n" . "set history filename ~/.gdb_history\n" . "set history size 32768\n" . "set history expansion on"' > ~/.gdbinit
cd /opt/ && git clone https://github.com/longld/peda && sed -i 's/: (\"off\"/: (\"on\"/g' /opt/peda/lib/config.py

# Setup Custom VIM Config
wget https://raw.githubusercontent.com/tentpegbob/bearded-cyril/master/default-vim-cfg -O ~/.vimrc

# Setup Smart Aliases
wget https://raw.githubusercontent.com/tentpegbob/bearded-cyril/master/bash_aliases -O ~/.bash_aliases

# Install ROPgadget
sudo pip install capstone --upgrade
cd /opt
git clone https://github.com/JonathanSalwan/ROPgadget
cd ROPgadget
python setup.py install

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
git clone https://github.com/leebaird/discover && cd discover && cd ..

# PowerSploit
cd /opt
git clone https://github.com/mattifestation/PowerSploit && cd PowerSploit && wget https://raw.github.com/obscuresec/random/master/StartListener.py && wget https://raw.github.com/darkoperator/powershell_scripts/master/ps_encoder.py

# Burp Fuzz Parameters
cd /opt
git clone https://github.com/danielmiessler/SecLists

# Enhanced NMAP Scripts
cd /usr/share/nmap/scripts
wget https://raw.github.com/hdm/scan-tools/master/nse/banner-plus.nse

# Firmware Mod Kit (FMK)
cd /opt
wget https://firmware-mod-kit.googlecode.com/files/fmk_099.tar.gz
tar -xzf fmk_099.tar.gz
sudo apt-get install -y --fix-missing git build-essential zlib1g-dev liblzma-dev python-magic

# Install Foremost Data Carving Tool
cd /opt
wget http://foremost.sourceforge.net/pkg/foremost-1.5.7.tar.gz
tar -xzf foremost-1.5.7.tar.gz

# Extra Installs
## Install pwntools
sudo pip install pwntools --upgrade
## BeEF
sudo apt-get install --fix-missing -y beef-xss
## Flawfinder
sudo apt-get install --fix-missing -y flawfinder
## Install 32-bit Support
sudo apt-get install --fix-missing -y lib32z1 lib32z1-dev libc6 libc6-dbg libc6-dev libc6-dev-i386 libc6-i386
## Install ARM support
# Not Tested Yet
# sudo apt-get install --fix-missing -y libc6-armel-cross libc6-armel-armhf-cross libc6-arm64-cross

# Update the VM
sudo apt-get update -y; sudo apt-get dist-upgrade -y

# Cleanup
rm /opt/fmk_099.tar.gz /opt/foremost-1.5.7.tar.gz
