#!/bin/bash
cd `dirname $0`

docker run -d --gpus all \
-v $PWD/code/:/opt/code/test/ \
-v /mnt/e/workspace/tmp/price-spread-forecasting/:/opt/code/price-spread-forecasting/ \
--shm-size=16G \
--rm -p 8888:8888 \
--name pyf-automl \
pyf-automl:1.6.3