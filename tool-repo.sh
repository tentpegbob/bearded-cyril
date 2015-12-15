#!/bin/bash

# Install GDB-Peda
echo '# Source all settings from the peda dir' >> ~/.gdbinit
echo 'source ~/peda/peda.py' >> ~/.gdbinit
echo '' >> ~/.gdbinit
echo '# These are other settings I have found useful' >> ~/.gdbinit
echo '' >> ~/.gdbinit
echo '# Intel syntax is more readable' >> ~/.gdbinit
echo 'set disassembly-flavor intel' >> ~/.gdbinit
echo ''
echo '# When inspecting large portions of code the scrollbar works better than \'less\''>> ~/.gdbinit
echo 'set pagination off' >> ~/.gdbinit
echo '' >> ~/.gdbinit
echo '# Keep a history of all the commands typed. Search is possible using ctrl-r' >> ~/.gdbinit
echo 'set history save on' >> ~/.gdbinit
echo 'set history filename ~/.gdb_history' >> ~/.gdbinit
echo 'set history size 32768' >> ~/.gdbinit
echo 'set history expansion on' >> ~/.gdbinit
cd /opt/ && git clone https://github.com/longld/peda && sed -i 's/: (\"off\"/: (\"on\"/g' /opt/peda/lib/config.py

# Install Network Miner
sudo apt-get install -y --fix-missing libmono-winforms2.0-cil
wget sf.net/projects/networkminer/files/latest -O /tmp/nm.zip
sudo unzip /tmp/nm.zip -d /opt/
cd /opt/NetworkMiner*
sudo chmod +x NetworkMiner.exe
sudo chmod -R go+w AssembledFiles/
sudo chmod -R go+w Captures/

# Update the VM
sudo apt-get update -y; sudo apt-get dist-upgrade -y

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
