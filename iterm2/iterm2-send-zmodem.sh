#!/bin/bash
# AppleScript from http://stackoverflow.com/questions/4309087/cancel-button-on-osascript-in-a-bash-script

FILE=$(osascript -e 'tell application "iTerm2" to activate' -e 'tell application "iTerm2" to set thefile to choose file with prompt "Choose a file to send"' -e "do shell script (\"echo \"&(quoted form of POSIX path of thefile as Unicode text)&\"\")")

if [[ $FILE = "" ]]; then
  echo Cancelled.
  # Send ZModem cancel
  echo -e \\x18\\x18\\x18\\x18\\x18
  sleep 1
  echo
  echo \# Cancelled transfer
else
  /usr/local/bin/sz "$FILE" -e -b
  sleep 1
  echo
  echo \# Received $FILE
fi
