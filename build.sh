#!/bin/bash
cd `dirname $0`/docker

docker build -t pyf-automl:1.6.3 .