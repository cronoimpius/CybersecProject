#!/bin/sh
ollama serve &
sleep 3
echo "ok"
ollama pull llama2 &
PID=$!
echo $PID
wait $PID
/init/slapd-init.sh

/init/run.sh
