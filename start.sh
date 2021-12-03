#!/usr/bin/env bash
set -e

ping_test_endpoint="www.google.com"
# upload_speed_test_endpoint="https://api.formant.io/v1/speed-test"
# download_speed_test_endpoint="https://formant-speed-test.s3-us-west-2.amazonaws.com/5mb.file"


get_ros_version() {
    if [ -d /opt/ros ] && [ "$(find /opt/ros -maxdepth 1 -type d | wc -l)" -gt 1 ]; then
        echo $(ls -d /opt/ros/*/ | cut -d'/' -f4)
    else
        echo "Not found"
    fi
}


upload_speed_test() {
    pushd $(mktemp -d) >/dev/null
    local bs
    if [[ "$OSTYPE" == "darwin"* ]]; then
        bs=2m
    else
        bs=2M
    fi
    dd if=/dev/urandom of=speedtest bs=${bs} count=1 2>/dev/null
    wget --header="Content-type: multipart/form-data" --post-file speedtest ${upload_speed_test_endpoint} -O /dev/null 2>&1 | grep -o "[0-9.]\+ [KM]*B/s"
    rm speedtest
    popd >/dev/null
}

download_speed_test() {
    wget -O /dev/null $download_speed_test_endpoint 2>&1 | grep -o "[0-9.]\+ [KM]*B/s"
}

speed_test_avg() {
    local num_tests=5
    local total=0
    for ((i = 0; i < $num_tests; i++)); do
        if [[ "$1" = "upload" ]]; then
            local speed_test=$(upload_speed_test)
        elif [[ "$1" = "download" ]]; then
            local speed_test=$(download_speed_test)
        else
            return 1
        fi
        local number=$(echo $speed_test | cut -d' ' -f1)
        local units=$(echo $speed_test | cut -d' ' -f2)
        # Standardize on MB/s
        if [[ "$units" = "MB/s" ]]; then
            number=$(echo $number 1000 | awk '{print $1 * $2}')
        fi
        total=$(echo $number $total | awk '{print $1 + $2}')
    done
    # Average
    KBs=$(echo $total $num_tests | awk '{print $1 / $2}') # KB/s
    echo $(echo $KBs 125 | awk '{print $1 / $2}') Mbit/s
}

# System info
system_os_name=$NAME
system_os_version=$VERSION
system_os_kernel=$(uname -r)
system_arch=$(uname -m)
system_total_memory=$(awk '/MemTotal/ { printf "%.3f", $2/1024 }' /proc/meminfo) # mb
system_cpu_name=$(lscpu | sed -nr '/Model name/ s/.*:\s*(.*) @ .*/\1/p')
system_cpu_num_processors=$(nproc)
# Network info
# echo "Measuring download speed..." && network_download_speed=$(speed_test_avg download)
# echo "Measuring upload speed..." && network_upload_speed=$(speed_test_avg upload)
echo "Measuring ping..." && network_ping=$(ping -c 4 "${ping_test_endpoint}" | tail -1 | awk '{print $4}' | cut -d '/' -f 2)
# GPU info
system_gpus=$(lspci | grep -i "VGA" | awk 'BEGIN{FS=": "} {print $2}')
# Installed package info
ros_version=$(get_ros_version)
python_version=$(python --version)

# Output
cat <<EOF

    Operating System: $system_os_name $system_os_version
    Architecture: $system_arch
    Kernel: $system_os_kernel
    Total Memory: $system_total_memory mb

    CPU: $system_cpu_name
    Processors: $system_cpu_num_processors

    GPUs: $system_gpus

    Download speed: $network_download_speed
    Upload speed: $network_upload_speed
    Ping: $network_ping ms

    ROS version: $ros_version
    Python version: $python_version


EOF