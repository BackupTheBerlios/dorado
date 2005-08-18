'
' Copyright 1999-2004 The Apache Software Foundation
'
' Licensed under the Apache License, Version 2.0 (the "License");
' you may not use this file except in compliance with the License.
' You may obtain a copy of the License at
'
'    http://www.apache.org/licenses/LICENSE-2.0
'
' Unless required by applicable law or agreed to in writing, software
' distributed under the License is distributed on an "AS IS" BASIS,
' WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
' See the License for the specific language governing permissions and
' limitations under the License.
'

' =========================================================================
' Description: Install script for Tomcat ISAPI redirector                              
' Author:      Peter S. Horne <horneps@yahoo.com.au>                           
' Version:     $Revision: 1.1 $                                           
' =========================================================================
'
' This script automatically installs the tomcat isapi_redirector for use in
' both out-of and in-process installations on IIS/Win2K. See the command line
' usage section for usage instructions.

'
'  Check the command line
'
set args = wscript.arguments
'if args.count <> 6 then 
'	info ""
'	info "Tomcat ISAPI Redirector Installation Utility"
'	info "usage: isapi_install <server> <fdir> <worker> <mount> <log> <level>"
'	info "	server:	The Web Server Name (for example 'Default Web Site')"
'	info "	fdir:	the full path to the directory that contains the isapi filter"
'	info "	worker:	Full path and file name of the worker properties file"
'	info "	mount:	Full path and file name of the worker mount properties file"
'	info "	log:	Full path and file name of the log file"
'	info "	level:	The log level emerg | info"
'	info "(Re-runs are ok and will change/reset settings)"
'	info ""
'	fail "Incorrect Arguments"
'end if

' Setup the args
serverName = args(0)
filterDir = "dorado.tomcat.home\tomcat-connector\lib"
filterName = "jakarta"
filterLib = "\isapi_redirect.dll"
workerFile = "dorado.tomcat.home\tomcat-connector\workers.properties"
mountFile = "dorado.tomcat.home\tomcat-connector\uriworkermap.properties"
logFile = "dorado.tomcat.home\tomcat-connector\logs\jk.log"
logLevel = "debug"

if args.count > 1 then
	if args(1) = "uninstall" then
		remove = true	
	end if
end if

if serverName = "all" or serverName = "0" then
	dim servers
	dim s

	set service = GetObject("IIS://LocalHost/W3SVC" )
	serverId = ""
	for each thing in service
		if thing.Class = "IIsWebServer" then
			servers = servers & ";" & thing.name
		end if
	next
	s = split(servers, ";")
	dim i
	for i=0 to ubound(s)
		if s(i) > " " then
			serverName = s(i)
			exec
		end if
	next
else
	exec
end if
wscript.quit(0)

sub exec()

	'
	' Get a shell
	'
	dim shell
	set shell = WScript.CreateObject("WScript.Shell")


	'
	' Find the indicated server from all the servers in the service 
	' Note: they aren't all Web!
	'
	set service = GetObject("IIS://LocalHost/W3SVC" )
	serverId = ""
	for each thing in service
		if thing.Class = "IIsWebServer" then
			if thing.ServerComment = serverName or thing.name = serverName then 
				set server = thing
				serverId = thing.name
				exit for
			end if
		end if
	next
	if serverId = "" then fail "Server " + serverName + " not found."
	info "Found Server <" + serverName + "> at index [" + serverId + "]."

	'
	' Stop everything to release any dlls - needed for a re-install
	'
	' info "Stopping server <" + serverName + ">..."
	' server.stop
	' info "Done"

	'
	' Get a handle to the filters for the server - we process all errors
	'
	On Error Resume Next
	dim filters
	set filters = GetObject("IIS://LocalHost/W3SVC/" + serverId + "/Filters")
	if err then 
		err.clear
		info "Filters not found for server - creating"
		set filters = server.create( "IIsFilters", "Filters" )
		filters.setInfo
		if err then fail "Error Creating Filters"
	end if
	info "Got Filters"

	'
	' Create the filter - if it fails then delete it and try again
	'
	name = filterName
	info "Creating Filter  - " + filterName
	dim filter
	set filter = filters.Create( "IISFilter", filterName )
	if err then
		err.clear
		info "Filter exists - deleting"
		filters.delete "IISFilter", filterName
		if err then fail "Error Deleting Filter"
		if not remove then
			set filter = filters.Create( "IISFilter", filterName )
			if err then fail "Error Creating Filter"
		end if
	end if
	if remove then
		info "Removed Filter"
	else
		info "Created Filter"
	end if

	'
	' Set the filter info and save it
	'
	if not remove then
		filter.FilterPath = filterDir + filterLib  
		filter.FilterEnabled=true
		filter.description = filterName
		filter.notifyOrderHigh = true
		filter.setInfo
	end if

	'
	' Set the load order - only if it's not in the list already
	'
	if not remove then
		on error goto 0
		loadOrders = filters.FilterLoadOrder
		list = Split( loadOrders, "," )
		found = false
		for each item in list
			if Trim( item ) = filterName then found = true
		next
	
		if found = false then 
			info "Filter is not in load order - adding now."
			if len(loadOrders) <> 0  then loadOrders = loadOrders + ","
			filters.FilterLoadOrder = loadOrders + filterName
			filters.setInfo
			info "Filter added."
		else
			info "Filter already exists in load order - no update required."
		end if
	end if


	'
	' Set the registry up
	' 
	regRoot = "HKEY_LOCAL_MACHINE\SOFTWARE\Apache Software Foundation\Jakarta Isapi Redirector\1.0\"
	err.clear
	on error resume next
	shell.RegDelete( regRoot )
	if not remove then
		if err then 
			info "Entering Registry Information for the first time"
		else 
			info "Deleted existing Registry Setting"
		end if
	
		on error goto 0
		info "Updating Registry"
		shell.RegWrite regRoot + "extension_uri", "/jakarta/isapi_redirect.dll"
		shell.RegWrite regRoot + "log_file", logFile
		shell.RegWrite regRoot + "log_level", logLevel
		shell.RegWrite regRoot + "worker_file", workerFile
		shell.RegWrite regRoot + "worker_mount_file", mountFile
		info "Registry Settings Created"
	else
		info "Registry settings removed"
	end if

	'
	' Finally, create the virtual directory matching th extension uri
	' 
	on error goto 0
	set root = GetObject( "IIS://LocalHost/W3SVC/" + serverID + "/ROOT" )
	on error resume next
	set vdir = root.Create("IISWebVirtualDir", filterName )
	if err then
		info "Directory exists - deleting"
		on error resume next
		root.delete "IISWebVirtualDir", filterName
		root.setInfo
		if err then fail "Error Deleting Directory"
		if not remove then
			set vdir = root.create("IISWebVirtualDir", filterName )
			if err then fail "Error Creating Directory"
		end if
	end if
	if remove then
		info "Directory removed"
	else
		info "Directory Created"
	end if
	
	' Set the directory information - make it an application directory
	if not remove then
		info "Setting Directory Information"
		vdir.AppCreate2 1
		vdir.AccessExecute = TRUE
		vdir.AppFriendlyName = filterName
		vdir.AccessRead = false
		vdir.ContentIndexed = false
		vdir.Path = filterDir
		vdir.setInfo
		if err then fail "Error saving new directory"
		info "Directory Saved"
	end if
	
	info "All done... Bye."
end sub

' 
' Helper function for snafus
'
function fail( message )
	wscript.echo "E: " + message
	wscript.quit(1)
end function

'
' Helper function for info
'
function info( message )
	wscript.echo " " + message
end function 
