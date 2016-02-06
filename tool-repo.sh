#!/bin/bash
# This script will install some typical tools that are useful when playing in CTFs / hacking competitions.
# It is very geared towards making sure the user can RE or focus on pwnable tasks, but also includes a little
# bit of everything.
#
## [UNRELEASED]
### ADDED/removed/changed/fixed
# - TODO - change this to a python script so that it interacts with the output from apt-get and other stuff. Should also print errors in any case ...
# - Added Xortool - common xor cracking tool for CTFs
## 1.0.4 - 2016-FEB-04
### ADDED/removed/changed/FIXED
# - Added Atom text editor and some pre-installed languages / APMs
# - Added vivisect, a static analysis engine for rebuilding stripped binaries
# - Fixed peda sed instruction so that it only turns on debuging and leaves verbosity off
# - Fixed directories for git clone to work properly
# - Added DTRX extractor for easy archive extraction
#
## 1.0.0 - 2016-JAN-18
### ADDED/removed/changed/fixed
# - Created public release and version for team to use for VM setup.
# - Ensured that the script was as streamlined as possible and required as little interaction as possible.
# - Adds symbolic links for some programs so that the user doesn't have to use /opt/...
#

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Install GDB-Peda
perl -e 'print "# Source all settings from the peda dir\n" . "source ~/peda/peda.py\n\n" . "# These are other settings I have found useful\n\n" . "# Intel syntax is more readable\n" . "set disassembly-flavor intel\n\n" . "# When inspecting large portions of code the scrollbar works better than \"less\"\n" . "set pagination off\n\n" . "# Keep a history of all the commands typed. Search is possible using ctrl-r\n" . "set history save on\n" . "set history filename ~/.gdb_history\n" . "set history size 32768\n" . "set history expansion on"' > ~/.gdbinit
cd /opt/ && git clone https://github.com/longld/peda &&  sed -i 's/\"debug\"     : (\"off\"/\"debug\"     : (\"on\"/g' /opt/peda/lib/config.py && sed -i 's/~\/peda\/peda.py/\/opt\/peda\/peda.py/g' ~/.gdbinit

# Setup Custom VIM Config
wget https://raw.githubusercontent.com/tentpegbob/bearded-cyril/master/default-vim-cfg -O ~/.vimrc

# Setup Smart Aliases
wget https://raw.githubusercontent.com/tentpegbob/bearded-cyril/master/bash_aliases -O ~/.bash_aliases

# Install ROPgadget
pip install capstone --upgrade
git clone https://github.com/JonathanSalwan/ROPgadget /opt/ROPgadget
cd ROPgadget
python setup.py install

# Install Network Miner
apt-get install -y --fix-missing libmono-winforms2.0-cil
wget sf.net/projects/networkminer/files/latest -O /tmp/nm.zip
unzip /tmp/nm.zip -d /opt/
cd /opt/NetworkMiner*
chmod +x NetworkMiner.exe
chmod -R go+w AssembledFiles/
chmod -R go+w Captures/

# Discover Scripts
git clone https://github.com/leebaird/discover /opt/discover
ln -s /opt/discover/discover.sh /usr/local/bin/discover.sh

# Vivisect, VDB, and Vtrace
git clone https://github.com/vivisect/vivisect /opt/vivisect
ln -s /opt/vivisect/vdbbin /usr/local/bin/vdbbin
ln -s /opt/vivisect/vivbin /usr/local/bin/vivbin

# Install Atom.io text editor @ http://atom.io
# Comes pre-loaded with syntax marking for lots of different  languages and includes markdown previewing
wget https://github.com/atom/atom/releases/download/v1.4.0/atom-amd64.deb -O /tmp/atom.deb && dpkg --install /tmp/atom.deb
apm install minimap vim-mode

# PowerSploit
cd /opt
git clone https://github.com/mattifestation/PowerSploit && cd PowerSploit && wget https://raw.github.com/obscuresec/random/master/StartListener.py && wget https://raw.github.com/darkoperator/powershell_scripts/master/ps_encoder.py

# Burp Fuzz Parameters
git clone https://github.com/danielmiessler/SecLists /opt/SecLists

# Enhanced NMAP Scripts
wget https://raw.github.com/hdm/scan-tools/master/nse/banner-plus.nse -O /usr/share/nmap/scripts

# Firmware Mod Kit (FMK)
wget https://firmware-mod-kit.googlecode.com/files/fmk_099.tar.gz -O /tmp/fmk.tar.gz && tar -xzf /tmp/fmk.tar.gz -C /opt
apt-get install -y --fix-missing git build-essential zlib1g-dev liblzma-dev python-magic
ln -s /opt/fmk/extract-firmware.sh /usr/local/bin/fmk_extract-firmware.sh
ln -s /opt/fmk/unsquashfs_all.sh /usr/local/bin/fmk_unsquashfs_all.sh
ln -s /opt/fmk/uncramfs_all.sh /usr/local/bin/fmk_uncramfs_all.sh

# Install Foremost Data Carving Tool
wget http://foremost.sourceforge.net/pkg/foremost-1.5.7.tar.gz -O /tmp/fm.tar.gz && tar -xzf /tmp/fm.tar.gz -C /opt

# Xortool
git clone https://github.com/hellman/xortool /opt/xortool && cd /opt/xortool
python setup.py build && python setup.py install

# Extra Installs
## Install pwntools
pip install pwntools --upgrade
## BeEF, flawfinder, exiftool
apt-get install --fix-missing -y beef-xss flawfinder exiftool
## Install 32-bit Support
apt-get install --fix-missing -y lib32z1 lib32z1-dev libc6 libc6-dbg libc6-dev libc6-dev-i386 libc6-i386
## Install ARM support
# Not Tested Yet
# apt-get install --fix-missing -y libc6-armel-cross libc6-armel-armhf-cross libc6-arm64-cross
## strace & valgrind
apt-get install -y --fix-missing strace valgrind
## Do The Right Extration tool
apt-get install -y --fix-missing dtrx

## If you need to fix pip use this:
# apt-get remove python-pip
# easy_install pip
# apt-get install -y python-pip

# Update the VM
apt-get update -y; apt-get dist-upgrade -y; apt-get autoremove -y
