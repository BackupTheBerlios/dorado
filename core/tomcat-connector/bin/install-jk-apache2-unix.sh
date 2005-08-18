#!/bin/sh

##
 # Copyright (c) 2005, dorado.planetes.de
 # All rights reserved.
 #
 # Redistribution and use in source and binary forms, with
 # or without modification, are permitted provided that the
 # following conditions are met:
 #
 #     # Redistributions of source code must retain the a
 #        bove copyright notice, this list of conditions and the
 #        following disclaimer.
 #     # Redistributions in binary form must reproduce the
 #        above copyright notice, this list of conditions and
 #        the following disclaimer in the documentation and/
 #        or other materials provided with the distribution.
 #     # Neither the name of the planetes.de, centaurus nor the
 #        names of its contributors may be used to endorse
 #        or promote products derived from this software
 #        without specific prior written permission.
 #
 # THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT
 # HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 # EXPRESS OR IMPLIED WARRANTIES, INCLUDING,
 # BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 # MERCHANTABILITY AND FITNESS FOR A PARTICULAR P
 # URPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 # COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR
 # ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 # EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 # (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 # SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
 # OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 # CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
 # IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 # NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 # OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 # THE POSSIBILITY OF SUCH DAMAGE.
 ##
 
 # This Shell Script connects Tomcat 5.5 with the Apache2 Webserver.
 #
 
TOMCAT_USER=dorado.tomcat.user
TOMCAT_BASE=dorado.tomcat.base
TOMCAT_HOME=dorado.tomcat.home
DORADO_INSTALLER_DIR=dorado.installer.dir
JAVA_HOME=java.home
 
#You must be root to do this
USER_NAME=`id -un`

if [ $USER_NAME != "root" ]; then
	echo "You must be root to do this. Now we change to root."
	echo "Please enter your root password."
	su -c $DORADO_INSTALLER_DIR/tomcat-connector/bin/install-jk-apache2-unix.sh
	exit
fi

#Now we try to find apxs2
APXS2=`which apxs2`
if [ "$APXS2" == "" ]; then
	echo "Please enter the absolute path to the apxs2 [/usr/sbin/apxs2]:"
	read $APXS2
	if [ "$APXS2" == "" ]; then
		APXS2=/usr/sbin/apxs2
	fi
fi

if [ "$APXS2" == "" ]; then
	echo "No apxs2 was found. Please install the apache2-devel package and restart this installer."
	exit
fi

mkdir -p $DORADO_INSTALLER_DIR/tmp/tomcat-connector
cp -R $DORADO_INSTALLER_DIR/tomcat-connector/* -t $DORADO_INSTALLER_DIR/tmp/tomcat-connector

cd $DORADO_INSTALLER_DIR/tmp/tomcat-connector/jk/native

echo "Starting the compile-process. Please wait..."
chmod u+x ./configure
./configure --with-apxs=$APXS2
make

if [ -f ./apache-2.0/mod_jk.so ]; then
	mkdir -p $TOMCAT_HOME/tomcat-connector/lib
	cp ./apache-2.0/mod_jk.so $TOMCAT_HOME/tomcat-connector/lib/mod_jk.so	
else
	echo "The installation failed. Please check all messages printed during the compile-process."
fi

#Removing the temporary files
echo "Removing the temporary files. Please wait..."
rm -Rf $DORADO_INSTALLER_DIR/tmp/tomcat-connector


#Execute the configurator
echo "Now the configurator will be starting..."
cd $DORADO_INSTALLER_DIR
export JAVA_HOME=$JAVA_HOME
export ANT_HOME=$DORADO_INSTALLER_DIR/ant
$DORADO_INSTALLER_DIR/ant/bin/ant -f $DORADO_INSTALLER_DIR/conf/dorado-install.xml install-jk-apache2-unix

#Apache2
if [ -d /etc/apache2/conf.d ]; then
	APACHE_CONF=/etc/apache2/conf.d
elif [ -d /etc/apache/conf.d ]; then
	APACHE_CONF=/etc/apache/conf.d
elif [ -d /etc/httpd2/conf.d ]; then
	APACHE_CONF=/etc/httpd2/conf.d
elif [ -d /etc/httpd/conf.d ]; then
	APACHE_CONF=/etc/httpd/conf.d
fi

if [ "$APACHE_CONF" == "" ]; then
	echo "Could not found the conf.d folder of your apache configuration."
	echo "Please enter the path to the conf.d folder [/etc/apache2/conf.d]:"
	read $APACHE_CONF
	if [ "$APACHE_CONF" == "" ]; then
		APACHE_CONF=/etc/apache2/conf.d
	fi

	if [ ! -d $APACHE_CONF ]; then
		echo "Could not found the conf.d folder of your apache configuration."
		echo "You must copy the file $TOMCAT_HOME/conf/jk.conf manually to this folder and restart Apache to finish the installation."
		exit
	fi
fi

rm -f $APACHE_CONF/jk.conf
cd $APACHE_CONF
ln -s $TOMCAT_HOME/tomcat-connector/jk.conf
mkdir -p $TOMCAT_HOME/tomcat-connector/logs
chown -R $TOMCAT_USER $TOMCAT_HOME/tomcat-connector

if [ -f /etc/init.d/apache2 ]; then
	APACHE_EXEC=/etc/init.d/apache2
elif [ -f /etc/init.d/apache ]; then
	APACHE_EXEC=/etc/init.d/apache
elif [ -f /etc/init.d/httpd2 ]; then
	APACHE_EXEC=/etc/init.d/httpd2
elif [ -f /etc/init.d/httpd ]; then
	APACHE_EXEC=/etc/init.d/httpd
fi

if [ "$APACHE_EXEC" == "" ]; then
	echo "Could not found the apache script to restart the server."
	echo "Please enter the path to this script [/etc/init.d/apache2]:"
	read $APACHE_EXEC
	if [ "$APACHE_EXEC" == "" ]; then
		APACHE_EXEC=/etc/init.d/apache2
	fi
	if [ ! -f $APACHE_EXEC ]; then
		echo "Could not found the script to restart the apache webserver."
		echo "You must restart Apache manually to finish the installation."
		exit
	fi
fi

$TOMCAT_BASE/bin/tomcat_service.sh restart
$APACHE_EXEC restart
	
echo "The installation of the JK-Connector has successfully finished."
	