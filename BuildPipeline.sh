#!/bin/bash

clear
START=$(date +"%s")
PROJECT_PATH="$(dirname "$(PWD)")"

BRANCH='master'

BOT_TOKEN='1319154477:AAE0WQ6rRCI5x6_Iev8fanCFPJP2Ypjk7Hs'
CHAT_ID='-419319501'

LOGS_PATH=$PROJECT_PATH'/Logs'

UNITY='D:/Program Files/Unity/2019.4.9f1/Editor/Unity.exe'

[ -d "$LOGS_PATH" ] || mkdir "$LOGS_PATH"

function SendTelegramMessage
{
curl https://api.telegram.org/bot$BOT_TOKEN/sendMessage -m 60 -s -X POST -d chat_id=$CHAT_ID -d text="$1" > "$LOGS_PATH/bot.log"
}

function UpdateRepo
{
echo "Updating branch $BRANCH"
git fetch > "$LOGS_PATH/git.log" 2>&1
git reset --hard HEAD >> "$LOGS_PATH/git.log" 2>&1
git checkout $BRANCH >> "$LOGS_PATH/git.log" 2>&1
git pull >> "$LOGS_PATH/git.log" 2>&1
SendTelegramMessage "Successfully updated repo $BRANCH..."
}

function AndroidDevelopment {
echo '' 
echo '|||||||||||||||||||||||||||||||' 
echo '|                             |' 
echo '|     Android development     |' 
echo '|                             |' 
echo '|||||||||||||||||||||||||||||||' 
echo ''
echo ''
echo 'build unity and archive APK...' 
echo '' 
'D:/Program Files/Unity/2019.4.9f1/Editor/Unity.exe' -batchmode -quit -projectPath 'D:\Unity\Projects\AR_Mall' -executeMethod Game.BuildActions.AndroidDevelopment -buildTarget android -logFile "$LOGS_PATH/android_development.log"
if [ $? -ne 0 ]; then
echo ''
echo 'Operation failed!'
SendTelegramMessage 'Operation failed!'
echo '' 
exit 1
fi
echo ''
echo 'build completed' 
SendTelegramMessage 'Build completed'
echo '' 
}

echo '' 
echo '' 
echo '' 
echo '|||||||||||||||||||||||||||||||' 
echo '|                             |' 
echo '|       Build pipeline        |' 
echo '|                             |' 
echo '|||||||||||||||||||||||||||||||' 
echo ''
echo ''
echo ''
echo "0 - Update branch $BRANCH"
echo '1 - Android development'
echo ''
echo ''
read -n 1 -s -r -p 'Select build type, ESC to cancel...' key
echo ''
if [ "$key" == $'\e' ]; then
echo ''
echo ''
echo 'Operation canceled!'
echo ''
echo ''
exit 1
fi
clear
case $key in
0)
UpdateRepo
;;
1)
AndroidDevelopment
;;
*)
echo ''
echo 'Unknown operation type! Logging out...'
echo ''
;;
esac