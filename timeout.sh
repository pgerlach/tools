#!/bin/bash

# enable job control
set -m

# get args
TIMEOUT=$1
shift ; # shift first args (timeout value)
CMD="$@"

echo "Will launch cmd $CMD, timeout at $TIMEOUT seconds."

# temporary file to 
PIDFILE=$(mktemp /tmp/maxtime-pid.XXXXX)

# launch "watcher"
(sleep ${TIMEOUT} && kill $(cat ${PIDFILE})) &
SLEEPPID=$!

# launch real cmd, remembering the PID
($CMD) &
echo $! > $PIDFILE
fg

# if process exited naturally, kill sleep 
kill ${SLEEPPID} 2> /dev/null || echo "Process has been killed"

# cleanup
rm ${PIDFILE}
