#!/usr/bin/env bash

script="$(readlink -f ${@})"

if [ -z "${script}" ]; then
		echo "Usage: $0 <script>"
		exit 1
fi

# taken from https://unix.stackexchange.com/questions/115084/how-can-i-run-a-kwin-script-from-the-command-line

num=$(dbus-send --print-reply --dest=org.kde.KWin /Scripting org.kde.kwin.Scripting.loadScript string:"$script" | awk 'END {print $2}' )

echo "num: ${num}"
dbus-send --print-reply --dest=org.kde.KWin   /${num}   org.kde.kwin.Scripting.run
#dbus-send --print-reply --dest=org.kde.KWin \
#	/${num} \
#	org.kde.kwin.Scripting.run


