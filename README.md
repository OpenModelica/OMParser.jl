# OMParser.jl

A parser for Modelica in Julia based on the OpenModelica parser.

## Build the parser library

### Linux / Mac

If you have your own Julia installation you need to set the path to it
````
export PATH=$PATH:/path/to/julia/bin
````
Then clone OMParser.jl (we assume you have git installed, if not, install it)
````
git clone https://github.com/OpenModelica/OMParser.jl
````
Then just build the library using this script.
````
cd OMParser.jl/lib/parser
autoconf
./configure
make
````
The library will be built in OMParser.jl/lib/build/

### MSYS2/MinGW

If you already have it just start MSYS2 MinGW terminal and follow the Linux/Mac instructions.
If not, install MSYS2 from: https://www.msys2.org/ and follow the instructions:
````
# start MSYS2 MSYS if not already started by the installer
pacman -Syu
# kill all terminals and processes and then start MSYS2 MSYS
pacman -Su
# install the needed packages
pacman -S --needed base-devel mingw-w64-x86_64-toolchain
````

If your computer is part of a domain things are rather slow in MSYS2 until you do these commands while connected to the domain controller (directly or via VPN):
````
mkpasswd -l -c > /etc/passwd
mkgroup -l -c > /etc/group
# make sure db is commented out from /etc/nsswitch.conf
sed -i.bak 's/ db/ # db/g' /etc/nsswitch.conf
# if something went wrong the original /etc/nsswitch.conf is kept in /etc/nsswitch.conf.bak
````

Then start MSYS2 MinGW terminal and then follow the instructions for Linux/Mac.








