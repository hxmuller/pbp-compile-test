#!/bin/bash

CORES="0 1 2 3 4 5"

for core in $CORES
do
    /bin/chmod 0444 /sys/devices/system/cpu/cpu${core}/cpufreq/cpuinfo_cur_freq
done
