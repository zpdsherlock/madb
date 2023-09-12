# madb

---

A simplified script for enhanced adb-command of android

# Usage

> madb help

```
Usage: madb [-s SERIAL] [CODE] [COMMAND...]

global options:
    -s SERIAL
        use device with given serial (overrides $ANDROID_SERIAL)

CODE:
    version
        Description: Show version of madb
    wifi
    cinstall URL [PACKAGE]
        Description: Install apk through url from network.
        URL: url for apk
        PACKAGE: package name for target app
    apps
        Description: list all apps on device.
    pmclear [PACKAGE]
        Description: Clear all cache of package on device.
        PACKAGE: package name for target app
    grantall [PACKAGE]
        Description: Grant all permission of package on device.
        PACKAGE: package name for target app
    wakeup [PACKAGE]
        Description: Launch app of package on device.
        PACKAGE: package name for target app
    wstart [PACKAGE]/[ACTIVITY]
        Description: Launch app of package with activity on device.
        PACKAGE: package name for target app
        ACTIVITY: activity name for target app
    amstart [SCHEME]
        Description: Launch app of package with scheme on device.
        SCHEME: route scheme for target business
    amstop [PACKAGE]
        Description: Stop app of package on device.
        PACKAGE: package name for target app
    event KEYCODE
        Description: Inject event to device.
        KEYCODE:
            4    Action for back
            82    Action for screen-locking
            26    Action for clear
    tap <x> <y> (Default: touchscreen)
        Description: Tap Action.
    swipe <x1> <y1> <x2> <y2> [duration(ms)] (Default: touchscreen)
        Description: Swipe Action.
    scroll DIRECTION
        DIRECTION:
            down    Scroll down on screen
            up    Scroll up on screen
            left    Scroll left on screen
            right    Scroll right on screen
    intext <string> (Default: touchscreen)
        Description: Input Action.
    content
        Description: Input Action for ADBKeyBoard.
    del
        Description: Text deleting.
    clear
        Description: Text clearing.
    screencap [FILE_NAME]
        Description: Take screencap of device.
    dump [FILE_NAME]
        Description: Dump ui structure info.
    record [--time-limit TIME] [options] <filename>
        Description: Records the device's display to a .mp4 file.
        TIME
            Set the maximum recording time, in seconds.  Default / maximum is 180.
        Options:
        --size WIDTHxHEIGHT
            Set the video size, e.g. "1280x720".  Default is the device's main
            display resolution (if supported), 1280x720 if not.  For best results,
            use a size supported by the AVC encoder.
        --bit-rate RATE
            Set the video bit rate, in megabits per second.  Default 4Mbps.
        --rotate
            Rotate the output 90 degrees.
        --verbose
            Display interesting information on stdout.
        --help
            Show this message.
    img IMAGE_PATH
        Description: Broadcast to notify the image path.
    topa
        Description: Show top activities.
    screen
        Description: Show mResumedActivity.
    topad
        Description: Show detail top activities.
    wtop
        Description: Show top windows.
    socket
        Description: Show all socket name on device.
    devtool
        Description: Show all devtool socket name on device.
    rotate DIRECTION
        Description: Rotate device.
        DIRECTION:
            0    PORTRAIT
            1    LANDSCAPE
    ime
        Description: Show input method on device.
    sime METHOD
        Description: Set input method on device.
        METHOD:
            Input Method on device. Get it from `madb ime`
```

# Install

## MacOS/Linux

Clone this repository

```shell
$ git clone git@github.com:zpdsherlock/madb.git
```

Open madb directory and simply execute the `install.sh` script.

```shell
$ cd madb
$ ./install.sh
```

## Windows

Under development...
