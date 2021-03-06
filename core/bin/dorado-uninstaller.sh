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
 
 
if [ "$1" != "" ]; then
	export JAVA_HOME=$1
fi

PRG="$0"
while [ -h "$PRG" ]; do
  ls=`ls -ld "$PRG"`
  link=`expr "$ls" : '.*-> \(.*\)$'`
  if expr "$link" : '.*/.*' > /dev/null; then
    PRG="$link"
  else
    PRG=`dirname "$PRG"`/"$link"
  fi
done
PRGDIR=`dirname "$PRG"`

$PRGDIR/../ant/bin/ant -f $PRGDIR/../conf/dorado-install.xml uninstall
