#!/bin/bash
echo ="|\     /|(  ___  )(  ____ \| \    /\(  ____ \(  ____ )  (       )\__    _/(  ___  )| \    /\(  ____ \(  ____ )
| )   ( || (   ) || (    \/|  \  / /| (    \/| (    )|  | () () |   )  (  | (   ) ||  \  / /| (    \/| (    )|
| (___) || (___) || |      |  (_/ / | (__    | (____)|  | || || |   |  |  | |   | ||  (_/ / | (__    | (____)|
|  ___  ||  ___  || |      |   _ (  |  __)   |     __)  | |(_)| |   |  |  | |   | ||   _ (  |  __)   |     __)
| (   ) || (   ) || |      |  ( \ \ | (      | (\ (     | |   | |   |  |  | |   | ||  ( \ \ | (      | (\ (   
| )   ( || )   ( || (____/\|  /  \ \| (____/\| ) \ \__  | )   ( ||\_)  )  | (___) ||  /  \ \| (____/\| ) \ \__
|/     \||/     \|(_______/|_/    \/(_______/|/   \__/  |/     \|(____/   (_______)|_/    \/(_______/|/   \__/"

filename=$(echo $1 | cut -f 1 -d ".")

package=$(head client/AndroidManifest.xml | egrep -oh 'package=\"[A-Za-z\.0-9]*"\s' | cut -f 2 -d "\"")
echo $package
echo -e "\n\n\t1. Decompile APK and Generate Java Sources\n\t2. Build APK and Sign"

read choice

case $choice in
        1 )
        apktool d -f -o $filename/ $1
        apktool b -f -o $filename-unsigned.apk $filename/
        d2j-dex2jar -o $filename.jar $filename-unsigned.apk
        /root/Download/jadx/bin/jadx -d $filename/src/ $filename.jar
        ;;

        2 )
        rm -f /root/Desktop/$filename-signed.apk
        /root/Android/Sdk/platform-tools/adb unistall $package
        apktool b -f -o $filename-signed.apk $filename-unsigned.apk
        d2j-apk-sign -f -o $filename-signed.apk $filename-unsigned.apk
        /root/Android/Sdk/platform-tools/adb install $filename-signed.apk
        ;;
esac



rm -d /root/Desktop/$filename-unsigned.apk
rm -f /root/Desktop$filename.jar
