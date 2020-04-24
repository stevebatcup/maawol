#!/bin/bash -e

bundle check || bundle install

if [[ -a $APP_PATH/spec/dummy/tmp/pids/server.pid ]]; then
	echo "Removing stale PID file from $APP_PATH/spec/dummy/tmp/pids/server.pid...."
	rm $APP_PATH/spec/dummy/tmp/pids/server.pid
fi

rails s -b 0.0.0.0 -p 4000 -P $APP_PATH/spec/dummy/tmp/pids/server.pid