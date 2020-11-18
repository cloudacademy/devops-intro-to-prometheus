#!/bin/bash

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS='linux'
elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS='darwin'
fi

echo "Killing Node Exporters"
pkill node_exporter
sleep 2
pkill prometheus
echo "Killing Prometheus"

sleep 2
echo "Cleaning up the clutter..."
sleep 1
echo "Clap once!"
sleep 1
echo "Clap twice!"
sleep 1
echo "Clap thrice!... Aw heck just get rid of it already!"

rm prometheus-2.22.2.$OS-amd64.tar.gz
rm -rf $PWD/prometheus-2.22.2.$OS-amd64
 