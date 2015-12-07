#!/bin/bash
echo 'Start init'

cd /root
if [ -d /root/compilation-multiplateforme ]; then
	rm -rf /root/compilation-multiplateforme
fi
git clone git@github.com:jeedom/compilation-multiplateforme.git
cd compilation-multiplateforme/
./compile-enocean.sh