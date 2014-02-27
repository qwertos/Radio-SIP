#!/bin/bash


# Colors
GREEN='\e[1;32m'
RED='\e[0;31m'
CYAN='\e[0;36m'
NC='\e[0m'
YELLOW='\e[1;33m'

# LIBRE Location
LIBRE_SOURCE='http://www.creytiv.com/pub/re-0.4.7.tar.gz'
LIBRE_VERSION='re-0.4.7'

# LIBREM Location
LIBREM_SOURCE='http://www.creytiv.com/pub/rem-0.4.5.tar.gz'
LIBREM_VERSION='rem-0.4.5'



root_check () {
	echo -en "Checking for root... "
	if [[ `whoami` == 'root' ]] ; then
		echo -e "[ ${GREEN}OK${NC} ]"
	else
		echo -e "[${RED}FAIL${NC}]"
		echo "Please 'su' to root and re-run this script"
		exit 1
	fi
}


install_libre () {
	echo -e "Installing libre..."
	
	pushd .
	cd dependencies

	wget $LIBRE_SOURCE
	tar xvzf ${LIBRE_VERSION}.tar.gz
	cd $LIBRE_VERSION

	make
	make install

	popd
	echo -e "Installing libre... [ ${GREEN}OK${NC} ]"
}


install_librem () {
	echo -e "Installing librem..."
	
	pushd .
	cd dependencies

	wget $LIBREM_SOURCE
	tar xvzf ${LIBREM_VERSION}.tar.gz
	cd $LIBREM_VERSION

	make
	make install

	popd
	echo -e "Installing librem... [ ${GREEN}OK${NC} ]"
}


install_baresip () {
	echo -e "Installing baresip..."
	
	pushd .
	cd dependencies/baresip

	make
	make install

	popd
	echo -e "Installing baresip... [ ${GREEN}OK${NC} ]"
}


install_dependencies () {
	install_libre
	install_librem
	ldconfig
	install_baresip
}


main () {
	root_check
	install_dependencies
}


main


