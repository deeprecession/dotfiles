#!/bin/bash


function battery_meter() {

    if [ "$(which acpi)" ]; then

        local battery_icon='󰁿'

        case $batt0 in
            # From 100% to 75% display color grey.
            100%|9[0-9]%|8[0-9]%|7[5-9]%)
                ;;

            # From 74% to 50% display color green.
            7[0-4]%|6[0-9]%|5[0-9]%)
                ;;

            # From 49% to 25% display color yellow.
            4[0-9]%|3[0-9]%|2[5-9]%)
                ;;

            # From 24% to 0% display color red.
            2[0-4]%|1[0-9]%|[0-9]%)
                ;;
        esac

        if [ "$(cat /sys/class/power_supply/AC/online)" == 1 ] ; then

            local battery_icon='󰂄'

        fi

        # Check for existence of a battery.
        if [ -x /sys/class/power_supply/BAT1 ] ; then

            local batt0=$(acpi -b 2> /dev/null | awk '/Battery 0/{print $4}' | cut -d, -f1)

            # Display the percentage of charge the battery has.
            printf "%s " "${battery_icon}${batt0}"

        fi
    fi
}

function load_average() {

    printf "%s " "$(uptime | awk -F: '{printf $NF}' | tr -d ',')"

}

function date_time() {

    printf "%s" "$(date +'%Y-%m-%d %H:%M:%S')"

}

function separator() {

    printf " | "

}

function memory_usage() {

    if [ "$(which bc)" ]; then

        # Display used, total, and percentage of memory using the free command.
        read used total <<< $(free -m | awk '/Mem/{printf $2" "$3}')
        # Calculate the percentage of memory used with bc.
        # percent=$(bc -l <<< "100 * $total / $used")
        # Feed the variables into awk and print the values with formating.
        awk -v u=$used -v t=$total -v p=$percent 'BEGIN {printf "Mem: %sMi/%sMi", t, u}'

    fi

}

function main() {

    separator
    memory_usage
    separator
    battery_meter
    # load_average

}

# Calling the main function which will call the other functions.
main
