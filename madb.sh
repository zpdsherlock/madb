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

CUSTOM_CMD=${CUSTOM_CMD/${CODE}/""}

case ${CODE} in
	"help"|"-h"|"--help")
		echo "Usage: madb [-s DEVICE] [CODE] [COMMAND...]"
		echo "[CODE: event]"
		echo -e "\t4\tAction for back"
		echo -e "\t82\tAction for screen-locking"
		echo -e "\t26\tAction for clear"
		;;
	"pmclear")
		adb ${SPECIFIC_DEVICE} shell pm clear ${CUSTOM_CMD}
		;;
	"wakeup")
		adb ${SPECIFIC_DEVICE} shell monkey -p ${CUSTOM_CMD} -c android.intent.category.LAUNCHER 1
		;;
	"wstart" )
		adb ${SPECIFIC_DEVICE} shell am start -n ${CUSTOM_CMD}
		;;
	"amstart" )
		adb ${SPECIFIC_DEVICE} shell am start -a android.intent.action.VIEW -d ${CUSTOM_CMD}
		;;
	"amstop")
		adb ${SPECIFIC_DEVICE} shell am force-stop ${CUSTOM_CMD}
		;;
	"event")
		adb ${SPECIFIC_DEVICE} shell input keyevent ${CUSTOM_CMD}
		;;
	"swipe")
		adb ${SPECIFIC_DEVICE} shell input swipe ${CUSTOM_CMD}
		;;
	"tap")
		adb ${SPECIFIC_DEVICE} shell input tap ${CUSTOM_CMD}
		;;
	"intext")
		adb ${SPECIFIC_DEVICE} shell input text ${CUSTOM_CMD}
		;;
	"screencap")
		adb ${SPECIFIC_DEVICE} shell screencap -p /sdcard/screencap.png
		adb ${SPECIFIC_DEVICE} pull /sdcard/screencap.png .
		adb ${SPECIFIC_DEVICE} shell rm -rf /sdcard/screencap.png
		;;	
	"record")
		;;
	"atop")
		adb ${SPECIFIC_DEVICE} shell dumpsys activity top | grep ACTIVITY
		;;
	"wtop")
		adb ${SPECIFIC_DEVICE} shell dumpsys window windows | grep "Window #"
		;;
	"socket")
		adb ${SPECIFIC_DEVICE} shell cat /proc/net/unix
		;;
	"devtool")
		adb ${SPECIFIC_DEVICE} shell cat /proc/net/unix | grep "devtool"
		;;
		*)
		adb $@
		;;
esac