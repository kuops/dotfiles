#!/bin/bash
# AppleScript from http://stackoverflow.com/questions/4309087/cancel-button-on-osascript-in-a-bash-script

FILE=$(osascript -e 'tell application "iTerm2" to activate' -e 'tell application "iTerm2" to set thefile to choose folder with prompt "Choose a folder to place received files in"' -e "do shell script (\"echo \"&(quoted form of POSIX path of thefile as Unicode text)&\"\")")

if [[ $FILE = "" ]]; then
  echo Cancelled.
  # Send ZModem cancel
  echo -e \\x18\\x18\\x18\\x18\\x18
  sleep 1
  echo
  echo \# Cancelled transfer
else
  cd "$FILE"
  /usr/local/bin/rz -E -e -b --bufsize 4096
  sleep 1
  echo
  echo
  echo \# Sent \-\> $FILE
fi
