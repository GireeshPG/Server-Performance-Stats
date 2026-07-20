#!/bin/bash

echo "======================================"
echo "      Server Performance Stats"
echo "======================================"
echo "Hostname      : $(hostname)"
echo "Date          : $(date)"
echo

#########################################
# CPU Usage
#########################################
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
CPU_USAGE=$((100 - CPU_IDLE))

echo "========== CPU =========="
echo "Total CPU Usage : ${CPU_USAGE}%"
echo

#########################################
# Memory Usage
#########################################
read TOTAL USED FREE <<< $(free -m | awk '/^Mem:/ {print $2, $3, $4}')

MEM_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($USED/$TOTAL)*100}")

echo "========== Memory =========="
echo "Total Memory : ${TOTAL} MB"
echo "Used Memory  : ${USED} MB"
echo "Free Memory  : ${FREE} MB"
echo "Usage        : ${MEM_PERCENT}%"
echo

#########################################
# Disk Usage
#########################################
DISK_TOTAL=$(df -h / | awk 'NR==2 {print $2}')
DISK_USED=$(df -h / | awk 'NR==2 {print $3}')
DISK_FREE=$(df -h / | awk 'NR==2 {print $4}')
DISK_PERCENT=$(df -h / | awk 'NR==2 {print $5}')

echo "========== Disk =========="
echo "Total Disk : $DISK_TOTAL"
echo "Used Disk  : $DISK_USED"
echo "Free Disk  : $DISK_FREE"
echo "Usage      : $DISK_PERCENT"
echo

#########################################
# Top 5 Processes by CPU
#########################################
echo "========== Top 5 Processes by CPU =========="
ps -eo pid,user,comm,%cpu --sort=-%cpu | head -n 6
echo

#########################################
# Top 5 Processes by Memory
#########################################
echo "========== Top 5 Processes by Memory =========="
ps -eo pid,user,comm,%mem --sort=-%mem | head -n 6
echo

#########################################
# Stretch Goals
#########################################
echo "========== Additional Information =========="
echo "OS Version:"
grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"'
echo

echo "Uptime:"
uptime -p
echo

echo "Load Average:"
uptime | awk -F'load average:' '{print $2}'
echo

echo "Logged-in Users:"
who
echo

echo "Failed Login Attempts:"
lastb 2>/dev/null | head -5
