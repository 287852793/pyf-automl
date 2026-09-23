#!/bin/bash
cd `dirname $0`

docker run --rm --gpus all \
-v $PWD/code/:/opt/code/ \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /usr/bin/docker:/usr/bin/docker \
--shm-size=16G \
--rm -p 8888:8888 \
--name pyf-automl \
-i -t pyf-automl:1.6.3 \
bash
