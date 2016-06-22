#!/bin/bash
# Starts the http-server and runs mocha-phantomjs-based tests
# Note that you must run `npm run build` or `npm run watch` before running this.
set -o errexit

# compile files for test
./scripts/quick-build.sh

# Run http-server and save its PID
http-server -p 8081 > /dev/null &
SERVER_PID=$!
function finish() {
  kill -TERM $SERVER_PID
}
trap finish EXIT

# the following sleep step is not really necessary
# as http-server starts almost instantenously;
# but letting the server settle might help prevent
# possible racing conditions
sleep 1

# Start the tests
mocha-phantomjs http://localhost:8081/src/test/runner.html