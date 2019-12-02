#!/bin/bash

GPU_THERMAL=/sys/class/thermal/thermal_zone1/temp
SOC_THERMAL=/sys/class/thermal/thermal_zone0/temp

CPUFREQ0=/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq
CPUFREQ1=/sys/devices/system/cpu/cpu1/cpufreq/cpuinfo_cur_freq
CPUFREQ2=/sys/devices/system/cpu/cpu2/cpufreq/cpuinfo_cur_freq
CPUFREQ3=/sys/devices/system/cpu/cpu3/cpufreq/cpuinfo_cur_freq
CPUFREQ4=/sys/devices/system/cpu/cpu4/cpufreq/cpuinfo_cur_freq
CPUFREQ5=/sys/devices/system/cpu/cpu5/cpufreq/cpuinfo_cur_freq

BAT_VOLTS=/sys/class/power_supply/rk-bat/voltage_now

LOG=$HOME/compile-test.log

KERN_SRC=$HOME/sources/mrfixit2001/rockchip-kernel/
USECORES=6

if ! cd $KERN_SRC
then
    echo kernel source directory missing
    exit 1
fi

make mrproper
make rockchip_linux_defconfig 
time make -j$USECORES &
pid=$!

trap "kill $pid 2>/dev/null" EXIT

while kill -0 $pid 2>/dev/null
do
    time_now=$(date +"%T")
    gpu_temp=$(cat $GPU_THERMAL)
    soc_temp=$(cat $SOC_THERMAL)
    cpufreq0=$(cat $CPUFREQ0)
    cpufreq1=$(cat $CPUFREQ1)
    cpufreq2=$(cat $CPUFREQ2)
    cpufreq3=$(cat $CPUFREQ3)
    cpufreq4=$(cat $CPUFREQ4)
    cpufreq5=$(cat $CPUFREQ5)
    batvolts=$(cat $BAT_VOLTS)
    echo "$time_now $gpu_temp $soc_temp $cpufreq0 $cpufreq1 $cpufreq2 $cpufreq3 $cpufreq4 $cpufreq5 $batvolts" >> $LOG
    sleep 2
done

trap - EXIT

exit

# execute bash loop while command is running
cp SOURCE DEST &
pid=$!

# if this script is killed, kill the cp command
trap "kill $pid 2>/dev/null" EXIT

# while copy is running
while kill -0 $pid 2>/dev/null
do
    # do stuff
    sleep 1
done

# disable the trap on a normal exit
trap - EXIT
