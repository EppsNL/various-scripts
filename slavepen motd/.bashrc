#Add the following to your bashrc
#Dependencies: catimg, sensors, wget and probably some other stuff I’m missing.

# Get the tempurature from the probe
cur_temperature=$(cat /sys/class/thermal/thermal_zone2/temp)
cur_temperature="$(echo "$cur_temperature / 1000" | bc -l | xargs printf "%1.0f")°C"
# Get your remote IP address using external resource ipinfo.io
remote_ip="$(wget http://ipinfo.io/ip -qO -)"
# Get your local IP address
local_ip="$(ip addr list "enp2s0" | grep "inet " | cut -d' ' -f6| cut -d/ -f1)"
# Get the total machine uptime in specific dynamic format 0 days, 0 hours, 0 minutes
machine_uptime="$(uptime | sed -E 's/^[^,]*up *//; s/, *[[:digit:]]* user.*//; s/min/minutes/; s/([[:digit:]]+):0?([[:digit:]]+)/\1 hours, \2 minutes/')"
# Get your linux distro name
distro_pretty_name="$(grep "PRETTY_NAME" /etc/*release | cut -d "=" -f 2- | sed 's/"//g')"
# Get the brand and model of your CPU
cpu_model_name="$(grep "model name" /proc/cpuinfo | cut -d ' ' -f3- | awk '{print $1,$2,$3,$4,$5,$6,$7,$8,$9,$10}' | head -1)"
# Get memory usage to be displayed
memory_percent="$(free -m | awk '/Mem/ { if($2 ~ /^[1-9]+/) memm=$3/$2*100; else memm=0; printf("%3.1f%%", memm) }')"
memory_free_mb="$(free -t -m | grep "Mem" | awk '{print $4}')"
memory_used_mb="$(free -t -m | grep "Mem" | awk '{print $3}')"
memory_available_mb="$(free -t -m | grep "Mem" | awk '{print $2}')"
# Get SWAP usage to be displayed
swap_percent="$(free -m | awk '/Swap/ { if($2 ~ /^[1-9]+/) swapm=$3/$2*100; else swapm=0; printf("%3.1f%%", swapm) }')"
swap_free_mb="$(free -t -m | grep "Swap" | awk '{print $4}')"
swap_used_mb="$(free -t -m | grep "Swap" | awk '{print $3}')"
swap_available_mb="$(free -t -m | grep "Swap" | awk '{print $2}')"

#Get last login information (user, ip)
last_login_user="$(last -a "$USER" | head -2 | awk 'NR==2{print $3,$4,$5,$6}')"
last_login_ip="$(last -a "$USER" | head -2 | awk 'NR==2{print $10}')"

# Get the 3 load averages
read -r loadavg_one loadavg_five loadavg_fifteen rest < /proc/loadavg

# Get the current usergroup and translate it to something human readable
if [[ "$GROUPZ" == *"sudo"* ]]; then
    USERGROUP="Administrator"
elif [[ "$USER" == "root" ]]; then
    USERGROUP="Root"
elif [[ "$USER" == "$USER" ]]; then
    USERGROUP="Regular User"
else
    USERGROUP="$GROUPZ"
fi

# Clear the screen and reset the scrollback
clear
catimg ~/scripts/welcome.png
# Print out all of the information collected using the script
echo -e "${C1} ++++++++++++++++++++++++: ${C3}System Data${C1} :+++++++++++++++++++++++++++
${C1} + ${C3}Hostname       ${C1}=  ${C4}$(hostname)
${C1} + ${C3}IPv4 Address   ${C1}=  ${C4}$remote_ip ${C0}($local_ip)
${C1} + ${C3}Uptime         ${C1}=  ${C4}$machine_uptime
${C1} + ${C3}Time           ${C1}=  ${C0}$(date)
${C1} + ${C3}CPU Temp       ${C1}=  ${C0}$cur_temperature
${C1} + ${C3}Load Averages  ${C1}=  ${C4}${loadavg_one}, ${loadavg_five}, ${loadavg_fifteen} ${C0}(1, 5, 15 min)
${C1} + ${C3}Memory         ${C1}=  ${C4}$memory_percent ${C0}(${memory_free_mb}MB Free, ${memory_used_mb}MB/${memory_available_mb}MB Used)
${C1} ++++++++++++++++++++++++: ${C3}User Data${C1} :+++++++++++++++++++++++++++++
${C1} + ${C3}Username       ${C1}=  ${C4}$USER ${C0}($USERGROUP)
${C1} + ${C3}Last Login     ${C1}=  ${C4}$last_login_user from $last_login_ip
${C1} + ${C3}Sessions       ${C1}=  ${C4}$(who | grep -c "$USER")
${C1} ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++${CNC}
"
