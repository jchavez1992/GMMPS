#!/bin/bash
#  If no skycat libraries found from scripts/locate_libs.sh, then use macports
#to download the latest stable version from eso.
#1) Check that macports is installed
#2) Check if the eso repository needs to be configured
#3) Install the latest skycat


#Checking for macports
if  ! command -v port >/dev/null ; then
    printf "printf: Could not find macports. Please install macports first from macports.org. \n"
	  exit 1
fi

#Check if xcode command line tools installed
xpath=$( xcode-select --print-path )
if  test -d "${xpath}" &&   test -x "${xpath}" ; then
    printf "printf: xcode is installed \n"
else
	  read -p "press enter to install X11 Command Line Tools"
    xcode-select --install
	  read -p "press enter when X11 Command line tools installed"
fi

##ToDo: Should add "port selfupdate" if eso port found

#Check if esorepo already available
esoport=`port search esorepo`
esoportshort="${esoport:0:7}"
if [ "$esoportshort" = "No matc" ]; then
	  cd /tmp
	  curl https://ftp.eso.org/pub/dfs/pipelines/repositories/stable/macports/setup/Portfile -o Portfile
	  sudo port install
	  sudo port sync
	    #<< Maybe check if command-line tools are already installed before doing this
	  #Ned to make a pause here b/c a gui will pop up to download and install this
elif [ "$esoportshort" = "esorepo" ]; then
	  sudo port install esorepo
    sudo port sync
fi


sudo port selfupdate
sudo port install eso-skycat

exit 0
