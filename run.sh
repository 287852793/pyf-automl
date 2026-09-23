#!/bin/bash
cd `dirname $0`

docker run -d --gpus all \
-v $PWD/code/:/opt/code/ \
--shm-size=16G \
--rm -p 8888:8888 \
--name pyf-automl \
pyf-automl:1.6.3