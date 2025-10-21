#!/bin/bash
sudo docker run --rm -it \
  --gpus all \
  --ipc=host \
  --ulimit memlock=-1 --ulimit stack=67108864 \
  -p 5000:5000 \
  mathiaspm/p9-reficr:local
