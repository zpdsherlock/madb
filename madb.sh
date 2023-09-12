#!/usr/bin/env bash
CUSTOM_CMD="$*"
options=()
while IFS= read -r line; do
if [[ $line == *device ]]; then
    serial=${line%%[[:space:]]*}
    options+=("$serial")
fi
done <<< "$(adb devices)"
if [[ $1 == "-s" ]]; then
    for e in "${options[@]}"
    do
        if [ "$e" = "$2" ]; then
            SPECIFIC_DEVICE="-s $e"
        fi
    done
    if [ -z "${SPECIFIC_DEVICE}" ]; then
        exit 1
    fi
    CODE=$3
    # remove space and '-s'
    CUSTOM_CMD=${CUSTOM_CMD// /}
    CUSTOM_CMD=${CUSTOM_CMD/"-s"/""}
    # remove serial number
    CUSTOM_CMD=${CUSTOM_CMD/$2/""}
else
    if [ ${#options[@]} -eq 0 ]; then
        echo "No devices!"
        exit 1
    elif [ ${#options[@]} -eq 1 ]; then
        SPECIFIC_DEVICE="-s ${options[0]}"
    else
        select choice in "${options[@]}"; do
        case $choice in
            *)
                SPECIFIC_DEVICE="-s $choice"
                break
                ;;
        esac
        done
    fi
    CODE=$1
fi

if [[ "${CUSTOM_CMD}" == "${CODE}" ]]; then
    CUSTOM_CMD=""
else
    CUSTOM_CMD=${CUSTOM_CMD/${CODE} /""}
fi
CUSTOM_CMD_ARR=(${CUSTOM_CMD//\\s/})

case ${CODE} in
"help" | "-h" | "--help")
    echo "Usage: madb [-s SERIAL] [CODE] [COMMAND...]"
    echo ""
    echo "global options:"
    echo "-s SERIAL\tuse device with given serial (overrides \$ANDROID_SERIAL)"
    echo ""
    echo "CODE:"
    echo -e "\tversion"
    echo -e "\t\tDescription: Show version of madb"
    echo ""
    echo -e "\tcinstall URL [PACKAGE]"
    echo -e "\t\tDescription: Install apk through url from network."
    echo -e "\t\tURL: url for apk"
    echo -e "\t\tPACKAGE: package name for target app"
    echo ""
    echo -e "\tapps"
    echo -e "\t\tDescription: list all apps on device."
    echo ""
    echo -e "\tpmclear [PACKAGE]"
    echo -e "\t\tDescription: Clear all cache of package on device."
    echo -e "\t\tPACKAGE: package name for target app"
    echo ""
    echo -e "\tgrantall [PACKAGE]"
    echo -e "\t\tDescription: Grant all permission of package on device."
    echo -e "\t\tPACKAGE: package name for target app"
    echo ""
    echo -e "\twakeup [PACKAGE]"
    echo -e "\t\tDescription: Launch app of package on device."
    echo -e "\t\tPACKAGE: package name for target app"
    echo ""
    echo -e "\twstart [PACKAGE]/[ACTIVITY]"
    echo -e "\t\tDescription: Launch app of package with activity on device."
    echo -e "\t\tPACKAGE: package name for target app"
    echo -e "\t\tACTIVITY: activity name for target app"
    echo ""
    echo -e "\tamstart [SCHEME]"
    echo -e "\t\tDescription: Launch app of package with scheme on device."
    echo -e "\t\tSCHEME: route scheme for target business"
    echo ""
    echo -e "\tamstop [PACKAGE]"
    echo -e "\t\tDescription: Stop app of package on device."
    echo -e "\t\tPACKAGE: package name for target app"
    echo ""
    echo -e "\tevent KEYCODE"
    echo -e "\t\tDescription: Inject event to device."
    echo -e "\t\tKEYCODE:"
    echo -e "\t\t\t4\tAction for back"
    echo -e "\t\t\t82\tAction for screen-locking"
    echo -e "\t\t\t26\tAction for clear"
    echo ""
    echo -e "\tswipe <x1> <y1> <x2> <y2> [duration(ms)] (Default: touchscreen)"
    echo -e "\t\tDescription: Swipe Action."
    echo ""
    echo -e "\ttap <x> <y> (Default: touchscreen)"
    echo -e "\t\tDescription: Tap Action."
    echo ""
    echo -e "\tintext <string> (Default: touchscreen)"
    echo -e "\t\tDescription: Input Action."
    echo ""
    echo -e "\tscreencap [FILE_NAME]"
    echo -e "\t\tDescription: Take screencap of device."
    echo ""
    echo -e "\tdump [FILE_NAME]"
    echo -e "\t\tDescription: Dump ui structure info."
    echo ""
    echo -e "\trecord [--time-limit TIME] [options] <filename>"
    echo -e "\t\tDescription: Records the device's display to a .mp4 file."
    echo -e "\t\tTIME"
    echo -e "\t\t\tSet the maximum recording time, in seconds.  Default / maximum is 180."
    echo ""
    echo -e "\t\tOptions:"
    echo -e "\t\t--size WIDTHxHEIGHT"
    echo -e "\t\t\tSet the video size, e.g. \"1280x720\".  Default is the device's main"
    echo -e "\t\t\tdisplay resolution (if supported), 1280x720 if not.  For best results,"
    echo -e "\t\t\tuse a size supported by the AVC encoder."
    echo -e "\t\t--bit-rate RATE"
    echo -e "\t\t\tSet the video bit rate, in megabits per second.  Default 4Mbps."
    echo -e "\t\t--rotate"
    echo -e "\t\t\tRotate the output 90 degrees."
    echo -e "\t\t--verbose"
    echo -e "\t\t\tDisplay interesting information on stdout."
    echo -e "\t\t--help"
    echo -e "\t\t\tShow this message."
    echo ""
    echo -e "\ttop"
    echo -e "\t\tDescription: Show top process."
    echo ""
    echo -e "\tatop"
    echo -e "\t\tDescription: Show top activity."
    echo ""
    echo -e "\twtop"
    echo -e "\t\tDescription: Show top window."
    echo ""
    echo -e "\tsocket"
    echo -e "\t\tDescription: Show all socket name on device."
    echo ""
    echo -e "\tdevtool"
    echo -e "\t\tDescription: Show all devtool socket name on device."
    echo ""
    echo -e "\trotate DIRECTION"
    echo -e "\t\tDescription: Rotate device."
    echo -e "\t\tDIRECTION:"
    echo -e "\t\t\t0\tPORTRAIT"
    echo -e "\t\t\t1\tLANDSCAPE"
    echo ""
    echo -e "\time"
    echo -e "\t\tDescription: Show input method on device."
    echo ""
    echo -e "\tsime METHOD"
    echo -e "\t\tDescription: Set input method on device."
    echo -e "\t\tMETHOD:"
    echo -e "\t\t\tInput Method on device. Get it from \`madb ime\`"
    ;;
"version")
    echo "[madb]"
    echo "madb version 2023.09.12"
    echo "[adb]"
    adb version
    ;;
"test")
    echo "\${CODE}: [${CODE}]"
    echo "\${CUSTOM_CMD}: [${CUSTOM_CMD}]"
    echo "params amount: ${#CUSTOM_CMD_ARR[*]}"
    for ((i = 0; i < ${#CUSTOM_CMD_ARR[*]}; i++)); do
        echo "param ${i}: [${CUSTOM_CMD_ARR[i]}]"
    done
    if [[ ${#CUSTOM_CMD_ARR[*]} > 1 ]]; then
        echo "params from 2: [${CUSTOM_CMD_ARR[*]:1:(${#CUSTOM_CMD_ARR[*]} - 1)}]"
    fi
    if [[ ${#CUSTOM_CMD_ARR[*]} > 2 ]]; then
        echo "params from 2: [${CUSTOM_CMD_ARR[*]:2:(${#CUSTOM_CMD_ARR[*]} - 1)}]"
    fi
    ;;
*)
    adb $@
    ;;
esac
