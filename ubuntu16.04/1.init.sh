#!/bin/bash

sudo mv /etc/apt/sources.list /etc/apt/sources.list.bk
sudo cp ./apt.sources.list /etc/apt/sources.list
sudo apt-get update -y

cd tools
sudo ./install.sh
