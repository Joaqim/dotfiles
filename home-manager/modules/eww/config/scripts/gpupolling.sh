#!/usr/bin/env bash

while true; do
    gpu_util=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits)
    echo "$gpu_util"
done
