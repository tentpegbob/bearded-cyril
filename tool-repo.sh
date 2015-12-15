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
