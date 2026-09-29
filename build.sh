#!/bin/bash
cd `dirname $0`/docker

docker build --cache-from pyf-automl:1.6.3 -t pyf-automl:1.6.3 .