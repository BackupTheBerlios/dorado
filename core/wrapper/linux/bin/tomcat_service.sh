#!/bin/sh

# Copyright (c) 2003 planetes.de
#
# Authors: Thorsten Kamann <thorsten.kamann@planetes.de>, 2004
#
# /etc/init.d/tomcat_service
#
### BEGIN INIT INFO
# Provides:			@dorado.name.service@
# Required-Start:		$local_fs $remote_fs $network $apache $httpd $apache2 $httpd2
# X-UnitedLinux-Should-Start:	$named $time $apache $httpd $apache2 $httpd2
# Required-Stop:		$local_fs $remote_fs $network
# X-UnitedLinux-Should-Stop:
# Default-Start:		3 5
# Default-Stop:			0 1 2 6
# Short-Description:		@dorado.name@
# Description:			@dorado.description@
### END INIT INFO

test -s /etc/rc.status && . /etc/rc.status

TOMCAT_DIR=@dorado.tomcat.base@
TOMCAT_USER=@dorado.tomcat.user@
RC_INST=`which chkconfig`
MODUS=0
if [ "$RC_INST" = "" ]; then
	MODUS=1
	RC_INST=`which update-rc.d`
fi

if [ "$RC_INST" = "" ]; then
	echo "No install script for services found."
	exit 1
fi

case "$1" in
	start)
		# Start Tomcat
		if [ "`id -un`" = "root" ]; then
			chown -R $TOMCAT_USER $TOMCAT_DIR
			chmod -R u+rw $TOMCAT_DIR
			su $TOMCAT_USER -c ''$TOMCAT_DIR'/bin/wrapper.sh start'
		else
			$TOMCAT_DIR/bin/wrapper.sh start
		fi
		
		exit 0
	;;

	stop)
		# Stop Tomcat
		if [ "`id -un`" = "root" ]; then
			su $TOMCAT_USER -c ''$TOMCAT_DIR'/bin/wrapper.sh stop'
		else
			$TOMCAT_DIR/bin/wrapper.sh stop
		fi
		exit 0
	;;

	console)
		# Start Tomcat in console mode
		if [ "`id -un`" = "root" ]; then
			chown -R $TOMCAT_USER $TOMCAT_DIR
			chmod -R u+rw $TOMCAT_DIR
			su $TOMCAT_USER -c ''$TOMCAT_DIR'/bin/wrapper.sh console'
		else
			$TOMCAT_DIR/bin/wrapper.sh console
		fi
		exit 0
	;;

	restart)
		#Restarts the Tomcat
		$0 stop
		$0 start
		exit 0
	;;

	status)
		# Returns the status of Tomcat
		if [ $MODUS = 0 ]; then
			echo -n "Checking for service Tomcat: "
			checkproc $TOMCAT_DIR/bin/wrapper
			rc_status -v
		else
			echo "Cannot get the status of Tomcat"
		fi
		exit 0
	;;

	install)
		#installs this script as init-script
		cp $TOMCAT_DIR/bin/tomcat_service.sh /etc/init.d/@dorado.name.service@
		if [ $MODUS = 0 ]; then
			$RC_INST -a @dorado.name.service@
		else
			$RC_INST @dorado.name.service@ defaults
		fi
		exit 0
	;;

	uninstall)
		#delete the init-script
		$0 stop
		if [ $MODUS = 0 ]; then
			$RC_INST -d @dorado.name.service@
		else
			$RC_INST -f @dorado.name.service@ remove
		fi
		rm -f /etc/rc.d/@dorado.name.service@
		exit 0
	;;

	update)
		#updates the init-script
		$0 stop
		$0 uninstall
		$0 install
		exit 0
	;;



	*)
		cat >&2 <<-EOF
			Usage: $0 <command>

			where <command> is one of:
				start			- starts the Tomcat-Server
				stop			- stops the Tomcat-Server
				console			- starts the Tomcat-Server in console-mode
				restart			- restarts the Tomcat-Server
				status			- prints the current status of the Tomcat-Server
				install			- installs this script as Tomcat-Server Init-Script
				uninstall		- uninstalls the Tomcat-Server Init-Script
				update			- update the Tomcat-Server Init-Script
				help			- prints this screen
		EOF
		exit 0
	;;
esac