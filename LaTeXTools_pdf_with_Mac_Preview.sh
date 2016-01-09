#!/bin/bash
# Copyright 2015 by SyneArt <sa@syneart.com>
clear

OS=`uname -s`
if [ "${OS}" != "Darwin" ] ; then
    echo "Info: 本腳本只適用於 Ｍac OS"
    exit 2
fi

exp=""
case $1 in
"--keep")
    exp="keep"
        ;;
"--unkeep")
    exp="unkeep"
        ;;
esac

echo "Info: Check file Now .."
jumpToPDF_File=`find ~/ -name jumpToPDF.py 2>/dev/null | tail -n 1`
if [ $? -eq 0 ]; then
    if grep -q '"Preview"' "${jumpToPDF_File}" ; then
        echo "Info: 檔案已修改過, 無需再次修改"
    else
        sed -i '' "/if plat == 'darwin':/a\ "$'\n>.^\t\t\tsubprocess.Popen(["open", "-a", "Preview"] + [pdffile])\n' "${jumpToPDF_File}"
        sed -i '' 's/>.^//g' "${jumpToPDF_File}"
    fi
else
    echo "Error: 失敗, 您有安裝 LaTeXTools 了嗎？"
    exit 1
fi

if [[ $exp == "keep" ]]; then
    echo "Info: 設定排程中 ..."
    mkdir /Users/$USER/Library/SyAShell
if [ -z "`launchctl list | grep com.syneart.LaTeXTools_pdf_with_Mac_Preview`" ]; then
cat >> /Users/$USER/Library/LaunchAgents/com.syneart.LaTeXTools_pdf_with_Mac_Preview.plist <<EOF
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>com.syneart.LaTeXTools_pdf_with_Mac_Preview</string>
        <key>ProgramArguments</key>
        <array>
            <string>/Users/$USER/Library/SyAShell/LaTeXTools_pdf_with_Mac_Preview.sh</string>
        </array>
        <key>KeepAlive</key>
        <false/>
        <key>RunAtLoad</key>
        <true/>
        <key>StartInterval</key>
        <integer>10800</integer>
        <key>WorkingDirectory</key>
        <string>/Users/$USER/Library/SyAShell/</string>
    </dict>
    </plist>
EOF
fi
    launchctl load /Users/$USER/Library/LaunchAgents/com.syneart.LaTeXTools_pdf_with_Mac_Preview.plist
    cp "$0" /Users/$USER/Library/SyAShell/
elif [[ $exp == "unkeep" ]]; then
    echo "Info: 移除排程中 ..."
    rm -r /Users/$USER/Library/SyAShell/
    launchctl remove com.syneart.LaTeXTools_pdf_with_Mac_Preview
    rm /Users/$USER/Library/LaunchAgents/com.syneart.LaTeXTools_pdf_with_Mac_Preview.plist
fi
echo "Info: 完成！！"
exit 0
