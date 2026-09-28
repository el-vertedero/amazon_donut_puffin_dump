#!/system/bin/sh

memtotal_1gb="1024"
memtotal_512mb="512"
memtotal_256mb="256"
memtotal_na="NA"
memtotal_2gb="2048"

# Check if persist.memtotal property is already set. If already set skip
memtotal_prop=`getprop persist.memtotal`
if [[ "$memtotal_prop" == "" || "$memtotal_prop" == $memtotal_na ]]; then
    # Read memtotal from /proc/meminfo and then set it to
    # persistent system property (persist.memtotal)
    if [ -f /proc/meminfo ]; then
        read -r line < /proc/meminfo
        arr=($line)
        if [ ${arr[1]} -ge 1100000 ]; then
            setprop persist.memtotal ${memtotal_2gb}
            memtotal_prop=`getprop persist.memtotal`
            echo "Memtotal: " ${memtotal_prop}
        elif [ ${arr[1]} -ge 550000 ]; then
            setprop persist.memtotal ${memtotal_1gb}
            memtotal_prop=`getprop persist.memtotal`
            echo "Memtotal: " ${memtotal_prop}
        elif [ ${arr[1]} -ge 300000 ]; then
            setprop persist.memtotal ${memtotal_512mb}
            memtotal_prop=`getprop persist.memtotal`
            echo "Memtotal: " ${memtotal_prop}
        else
            setprop persist.memtotal ${memtotal_256mb}
            memtotal_prop=`getprop persist.memtotal`
            echo "Memtotal: " ${memtotal_prop}
        fi
    else
        echo "/proc/meminfo does not exist"
        setprop persist.memtotal ${memtotal_na}
        exit 1
    fi
fi
exit 0
