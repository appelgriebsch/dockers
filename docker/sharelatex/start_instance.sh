#!/bin/bash

function replaceInString() {

  local origString=$1
  local searchFor=$2
  local replaceWith=$3

  echo $(echo $origString | sed -e "s/$searchFor/$replaceWith/g")
}

function createInstanceDirectories() {
  # nothing to do here -> instance directories not configurable
  return 0
}

function setupInstanceNetworking() {
  # nothing to do here -> fixed port for web app 3000
  return 0
}

function configureInstance() {
  
  CONFIG_FILE=$HOME/www/web/config/settings.coffee
  
  echo Copying local settings template...$HOME/www/web/config/
  cp $HOME/www/web/config/settings.defaults.coffee $CONFIG_FILE
  
  echo Checking settings for mongodb server...$MONGO_SERVER
  if [ -n "$MONGO_SERVER" ]; then
  
  	MONGO_CONNECT="mongodb://$MONGO_SERVER/sharelatex"
  	
  	if [ -n "$MONGO_USER" ]; then
  		MONGO_CONNECT="mongodb://$MONGO_USER@$MONGO_SERVER/sharelatex"
  		if [ -n "$MONGO_PWD" ]; then		
  			MONGO_CONNECT="mongodb://$MONGO_USER:$MONGO_PWD@$MONGO_SERVER/sharelatex"
  		fi
  	fi
 
    echo MongoDB connection goes to $MONGO_CONNECT

  	MONGO_CONNECT=$(maskPath $MONGO_CONNECT)
  
  	tr '\n' ';' < $CONFIG_FILE | sed -e "s/^\(.*\)\(mongo:\W*;\W*url\W*:\W*\)'[a-z:.\/0-9]*'\(.*\)$/\1\2'$MONGO_CONNECT'\3/g" | sed -e "s/;/\n/g" > $CONFIG_FILE.new

  fi
  
  echo Checking settings for redis server...$REDIS_SERVER
  if [ -n "$REDIS_SERVER" ]; then

	  # extract ip and port from env variable
    REDIS_IP=$(replaceInString $REDIS_SERVER "^\([0-9A-Za-z._\-]*\):\([0-9]*\)$" "\1")
    REDIS_PORT=$(replaceInString $REDIS_SERVER "^\([0-9A-Za-z._\-]*\):\([0-9]*\)$" "\2")
	
  	echo Redis connection goes to $REDIS_IP:$REDIS_PORT
  	
  	tr '\n' ';' < $CONFIG_FILE.new | sed -e "s/^\(.*\)\(redis:\W*;\W*web:\W*;\W*host:\W*\)\"[a-zA-Z0-9.]*\"\(\W*;\W*port:\W*\)\"[0-9]*\"\(\W*;\W*password:\W*\)\"\"\(.*\)$/\1\2\"$REDIS_IP\"\3\"$REDIS_PORT\"\4\"$REDIS_PWD\"\5/g" | sed -e "s/;/\n/g" > $CONFIG_FILE
    
  fi
  
  if [ -f "$CONFIG_FILE.new" ]; then
	  rm $CONFIG_FILE.new	
  fi
  
  return 0
}

function startInstance() {

	CONFIG_FILE=$HOME/www/web/config/settings.coffee

	# start cache system
	SHARELATEX_CONFIG=$CONFIG_FILE NODE_ENV=production node $HOME/www/chat/app.js &

	# start clsi system
	SHARELATEX_CONFIG=$CONFIG_FILE NODE_ENV=production node $HOME/www/clsi/app.js &

	# start docstore system
	SHARELATEX_CONFIG=$CONFIG_FILE NODE_ENV=production node $HOME/www/docstore/app.js &

	# start document-updater system
	SHARELATEX_CONFIG=$CONFIG_FILE NODE_ENV=production node $HOME/www/document-updater/app.js &

	# start filestore system
	SHARELATEX_CONFIG=$CONFIG_FILE NODE_ENV=production node $HOME/www/filestore/app.js &

	# start spelling system
	SHARELATEX_CONFIG=$CONFIG_FILE NODE_ENV=production node $HOME/www/spelling/app.js &

	# start tags system
	SHARELATEX_CONFIG=$CONFIG_FILE NODE_ENV=production node $HOME/www/tags/app.js &

	# start track-changes system
	SHARELATEX_CONFIG=$CONFIG_FILE NODE_ENV=production node $HOME/www/track-changes/app.js &

	# start web system
	SHARELATEX_CONFIG=$CONFIG_FILE NODE_ENV=production node $HOME/www/web/app.js
}

createInstanceDirectories && setupInstanceNetworking && \
 configureInstance && startInstance
