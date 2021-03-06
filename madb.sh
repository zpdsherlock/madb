#!/usr/bin/env bash
# save origin command
CUSTOM_CMD="$*"
if [[ $1 == "-s" ]]; then
    # record serial number
    SPECIFIC_DEVICE="-s $2"
    CODE=$3
    # remove '-s'
    CUSTOM_CMD=${CUSTOM_CMD/"-s"/""}
    # remove serial number
    CUSTOM_CMD=${CUSTOM_CMD/$2/""}
else
    SPECIFIC_DEVICE=""
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
    echo "madb version 2020.11.26"
    echo "[adb]"
    adb version
    ;;
"wifi")
    adb kill-server
    sleep 1
    adb devices
    adb ${SPECIFIC_DEVICE} tcpip 5555
    sleep 2
    TARGET_IP=$(adb ${SPECIFIC_DEVICE} shell netstat -a | grep -v tcp6 | grep -v 127.0.0.1 | grep -v 0.0.0.0 | grep tcp | awk '{print $4}' | sed 's/:.*$//g' | sed -n '1p')
    adb connect ${TARGET_IP}:5555
    ;;
"cinstall")
    curl ${CUSTOM_CMD} >ztemp.apk
    if [[ ! -z "${CUSTOM_CMD_ARR[1]}" ]]; then
        adb ${SPECIFIC_DEVICE} uninstall ${CUSTOM_CMD_ARR[1]}
    fi
    adb ${SPECIFIC_DEVICE} install -r ztemp.apk
    rm -rf ztemp.apk
    ;;
"apps")
    adb ${SPECIFIC_DEVICE} shell pm list packages
    ;;
"pmclear")
    adb ${SPECIFIC_DEVICE} shell pm clear ${CUSTOM_CMD}
    ;;
"grantall")
    adb ${SPECIFIC_DEVICE} shell pm grant ${CUSTOM_CMD} android.permission.READ_PHONE_STATE
    adb ${SPECIFIC_DEVICE} shell pm grant ${CUSTOM_CMD} android.permission.READ_CONTACTS
    adb ${SPECIFIC_DEVICE} shell pm grant ${CUSTOM_CMD} android.permission.WRITE_EXTERNAL_STORAGE
    adb ${SPECIFIC_DEVICE} shell pm grant ${CUSTOM_CMD} android.permission.ACCESS_COARSE_LOCATION
    adb ${SPECIFIC_DEVICE} shell pm grant ${CUSTOM_CMD} android.permission.ACCESS_FINE_LOCATION
    ;;
"wakeup")
    adb ${SPECIFIC_DEVICE} shell monkey -p ${CUSTOM_CMD} -c android.intent.category.LAUNCHER 1
    ;;
"wstart")
    adb ${SPECIFIC_DEVICE} shell am start -n ${CUSTOM_CMD}
    ;;
"amstart")
    adb ${SPECIFIC_DEVICE} shell am start -a android.intent.action.VIEW -d ${CUSTOM_CMD}
    ;;
"amstop")
    adb ${SPECIFIC_DEVICE} shell am force-stop ${CUSTOM_CMD}
    ;;
"event")
    adb ${SPECIFIC_DEVICE} shell input keyevent ${CUSTOM_CMD}
    ;;
"tap")
    adb ${SPECIFIC_DEVICE} shell input tap ${CUSTOM_CMD}
    ;;
"swipe")
    adb ${SPECIFIC_DEVICE} shell input swipe ${CUSTOM_CMD}
    ;;
"scroll")
    if [[ "${CUSTOM_CMD_ARR[0]}" == "down" ]]; then
        DEV_SIZE=$(adb ${SPECIFIC_DEVICE} shell wm size | sed 's/ //g' | sed 's/\r//g')
        DEV_WIDTH=$(echo ${DEV_SIZE} | sed 's/.*:\([[:digit:]]*\)x\([0-9]*\)/\1/g')
        DEV_HEIGHT=$(echo ${DEV_SIZE} | sed 's/.*:\([[:digit:]]*\)x\([0-9]*\)/\2/g')
        FROM_X=$(expr ${DEV_WIDTH} \/ 2)
        FROM_Y=$(expr ${DEV_HEIGHT} \/ 4)
        TO_X=$(expr ${DEV_WIDTH} \/ 2)
        TO_Y=$(expr ${DEV_HEIGHT} \/ 4 \* 3)
        adb ${SPECIFIC_DEVICE} shell input swipe ${FROM_X} ${FROM_Y} ${TO_X} ${TO_Y} 1000
    elif [[ "${CUSTOM_CMD_ARR[0]}" == "up" ]]; then
        DEV_SIZE=$(adb ${SPECIFIC_DEVICE} shell wm size | sed 's/ //g' | sed 's/\r//g')
        DEV_WIDTH=$(echo ${DEV_SIZE} | sed 's/.*:\([[:digit:]]*\)x\([0-9]*\)/\1/g')
        DEV_HEIGHT=$(echo ${DEV_SIZE} | sed 's/.*:\([[:digit:]]*\)x\([0-9]*\)/\2/g')
        FROM_X=$(expr ${DEV_WIDTH} \/ 2)
        FROM_Y=$(expr ${DEV_HEIGHT} \/ 4 \* 3)
        TO_X=$(expr ${DEV_WIDTH} \/ 2)
        TO_Y=$(expr ${DEV_HEIGHT} \/ 4)
        adb ${SPECIFIC_DEVICE} shell input swipe ${FROM_X} ${FROM_Y} ${TO_X} ${TO_Y} 1000
    elif [[ "${CUSTOM_CMD_ARR[0]}" == "left" ]]; then
        DEV_SIZE=$(adb ${SPECIFIC_DEVICE} shell wm size | sed 's/ //g' | sed 's/\r//g')
        DEV_WIDTH=$(echo ${DEV_SIZE} | sed 's/.*:\([[:digit:]]*\)x\([0-9]*\)/\1/g')
        DEV_HEIGHT=$(echo ${DEV_SIZE} | sed 's/.*:\([[:digit:]]*\)x\([0-9]*\)/\2/g')
        FROM_X=$(expr ${DEV_WIDTH} \/ 4)
        FROM_Y=$(expr ${DEV_HEIGHT} \/ 2)
        TO_X=$(expr ${DEV_WIDTH} \/ 4 \* 3)
        TO_Y=$(expr ${DEV_HEIGHT} \/ 2)
        adb ${SPECIFIC_DEVICE} shell input swipe ${FROM_X} ${FROM_Y} ${TO_X} ${TO_Y} 1000
    elif [[ "${CUSTOM_CMD_ARR[0]}" == "right" ]]; then
        DEV_SIZE=$(adb ${SPECIFIC_DEVICE} shell wm size | sed 's/ //g' | sed 's/\r//g')
        DEV_WIDTH=$(echo ${DEV_SIZE} | sed 's/.*:\([[:digit:]]*\)x\([0-9]*\)/\1/g')
        DEV_HEIGHT=$(echo ${DEV_SIZE} | sed 's/.*:\([[:digit:]]*\)x\([0-9]*\)/\2/g')
        FROM_X=$(expr ${DEV_WIDTH} \/ 4 \* 3)
        FROM_Y=$(expr ${DEV_HEIGHT} \/ 2)
        TO_X=$(expr ${DEV_WIDTH} \/ 4)
        TO_Y=$(expr ${DEV_HEIGHT} \/ 2)
        adb ${SPECIFIC_DEVICE} shell input swipe ${FROM_X} ${FROM_Y} ${TO_X} ${TO_Y} 1000
    else
        echo "Not supported"
    fi
    ;;
"intext")
    adb ${SPECIFIC_DEVICE} shell input text ${CUSTOM_CMD}
    ;;
"content")
    echo ${CUSTOM_CMD}
    adb ${SPECIFIC_DEVICE} shell am broadcast -a ADB_INPUT_TEXT --es msg "${CUSTOM_CMD}"
    ;;
"del")
    adb ${SPECIFIC_DEVICE} shell am broadcast -a ADB_INPUT_CODE --ei code 67
    ;;
"clear")
    adb ${SPECIFIC_DEVICE} shell am broadcast -a ADB_CLEAR_TEXT
    ;;
"screencap")
    if [[ ! -z "${CUSTOM_CMD}" ]]; then
        SAVE_FILE=$(echo ${CUSTOM_CMD} | sed 's/ //g')
    else
        SAVE_FILE="screencap.png"
    fi
    adb ${SPECIFIC_DEVICE} shell screencap -p /sdcard/${SAVE_FILE}
    adb ${SPECIFIC_DEVICE} pull /sdcard/${SAVE_FILE} .
    adb ${SPECIFIC_DEVICE} shell rm -rf /sdcard/${SAVE_FILE}
    ;;
"dump")
    SAVE_FILE="pageview"
    if [[ ${CUSTOM_CMD_ARR[0]} == "-f" ]]; then
        SAVE_FILE=${CUSTOM_CMD_ARR[1]}
    fi
    adb ${SPECIFIC_DEVICE} shell uiautomator dump /sdcard/${SAVE_FILE}.uix
    adb ${SPECIFIC_DEVICE} pull /sdcard/${SAVE_FILE}.uix .
    adb ${SPECIFIC_DEVICE} shell rm -rf /sdcard/${SAVE_FILE}.uix
    ;;
"record")
    REC_CMP=$(grep '^[[:digit:]]*$' <<<"${CUSTOM_CMD_ARR[0]}")
    SAVE_FILE="madb-record"
    OFFSET_CMD=1
    if [[ ${CUSTOM_CMD_ARR[1]} == "-f" ]]; then
        SAVE_FILE=${CUSTOM_CMD_ARR[2]}
        OFFSET_CMD=3
    fi
    if [[ ! -z "${REC_CMP}" ]]; then
        adb ${SPECIFIC_DEVICE} shell screenrecord --time-limit ${CUSTOM_CMD_ARR[0]} ${CUSTOM_CMD_ARR[*]:${OFFSET_CMD}:(${#CUSTOM_CMD_ARR[*]} - 1)} /sdcard/${SAVE_FILE}.mp4
    else
        adb ${SPECIFIC_DEVICE} shell screenrecord --time-limit 10 ${CUSTOM_CMD} /sdcard/${SAVE_FILE}.mp4
    fi
    adb ${SPECIFIC_DEVICE} pull /sdcard/${SAVE_FILE}.mp4 ./${SAVE_FILE}.mp4
    adb ${SPECIFIC_DEVICE} shell rm -rf /sdcard/${SAVE_FILE}.mp4
    ;;
"top")
    adb ${SPECIFIC_DEVICE} shell dumpsys activity | grep -a "top-activity"
    ;;
"screen")
    adb ${SPECIFIC_DEVICE} shell dumpsys activity | grep -a "mResumedActivity"
    ;;
"atop")
    adb ${SPECIFIC_DEVICE} shell dumpsys activity top | grep -a "ACTIVITY"
    ;;
"wtop")
    adb ${SPECIFIC_DEVICE} shell dumpsys window windows | grep -a "Window #"
    ;;
"socket")
    adb ${SPECIFIC_DEVICE} shell cat /proc/net/unix
    ;;
"devtool")
    adb ${SPECIFIC_DEVICE} shell cat /proc/net/unix | grep -a "devtool"
    ;;
"rotate")
    adb ${SPECIFIC_DEVICE} shell content insert --uri content://settings/system --bind name:s:accelerometer_rotation --bind value:i:${CUSTOM_CMD}
    ;;
"ime")
    adb ${SPECIFIC_DEVICE} shell ime list -s
    ;;
"sime")
    adb ${SPECIFIC_DEVICE} shell ime set ${CUSTOM_CMD}
    ;;
"map")
    adb ${SPECIFIC_DEVICE} push ${CUSTOM_CMD_ARR[1]} /data/local/tmp/${CUSTOM_CMD_ARR[0]}_map.txt
    adb ${SPECIFIC_DEVICE} push ${CUSTOM_CMD_ARR[2]} /data/local/tmp/${CUSTOM_CMD_ARR[0]}_resmap.txt
    ;;
"img")
    adb ${SPECIFIC_DEVICE} shell am broadcast -a android.intent.action.MEDIA_SCANNER_SCAN_FILE -d file://${CUSTOM_CMD}
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
