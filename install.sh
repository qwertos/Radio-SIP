#!/bin/bash


# Colors
GREEN='\e[1;32m'
RED='\e[0;31m'
CYAN='\e[0;36m'
NC='\e[0m'
YELLOW='\e[1;33m'

# LIBRE Location
LIBRE_VERSION='re-0.4.7'
LIBRE_SOURCE="http://www.creytiv.com/pub/${LIBRE_VERSION}.tar.gz"

# LIBREM Location
LIBREM_VERSION='rem-0.4.5'
LIBREM_SOURCE="http://www.creytiv.com/pub/${LIBREM_VERSION}.tar.gz"

RUBY_VERSION='2.1.1'
RUBY_SOURCE="http://cache.ruby-lang.org/pub/ruby/stable/ruby-${RUBY_VERSION}.tar.gz"




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


link_urix () {
	echo -en "Linking URIx libraries..."
	ln -s dependencies/urix/urix.rb lib/urix.rb
	ln -s dependencies/urix/urix lib/urix
	echo -e " [ ${GREEN}OK${NC} ]"
}


install_ruby_gems () {
	echo -e "Running bundle install... "
	bundle install
	echo -e "Running bundle install... [ ${GREEN}OK${NC} ]"
}


install_build_tools () {
	if which yum ; then
		yum -y groupinstall 'Development Tools'
		return
	fi

	if which apt-get ; then
		apt-get -y install build-essential
		return
	fi
}

check_ruby () {
	echo -en "Checking for ruby... "
	if which ruby ; then
		echo -e "[ ${GREEN}OK${NC} ]"
		echo -en "Checking ruby for version ${CYAN}${RUBY_VERSION}${NC}... "
		if ruby --verion | grep "^ruby ${RUBY_VERSION}" > /dev/null 2> /dev/null ; then
			echo -e "[ ${GREEN}OK${NC} ]"
			return
		else
			echo -e "[${RED}FAIL${NC}]"
			install_ruby
			return
		fi
	else
		echo -e "[${RED}FAIL${NC}]"
		install_ruby
		return
	fi
}


install_ruby () {
	echo -e "Installing ruby... "
	
	pushd .
	cd dependencies
	wget $RUBY_SOURCE
	tar xvzf ruby-${RUBY_VERSION}.tar.gz
	cd ruby-${RUBY_VERSION}
	./configure
	make
	make install

	popd

	echo -e "Installing ruby... [ ${GREEN}OK${NC} ]"
}


install_init_scripts () {
	cp init-scripts/baresip /etc/init.d/baresip
}


install_dependencies () {
	install_build_tools
	check_ruby
	install_ruby_gems
	install_libre
	install_librem
	ldconfig
	install_baresip
	ldconfig
	link_urix
}


main () {
	root_check
	install_dependencies
	install_init_scripts
}


main


