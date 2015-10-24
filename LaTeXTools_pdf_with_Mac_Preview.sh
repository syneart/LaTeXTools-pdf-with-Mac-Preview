#!/bin/bash
# Copyright 2015 by SyneArt <sa@syneart.com>
clear
echo "Info: 修改檔案需要權限, 請先輸入密碼 .."
sudo -v
if [ $? -eq 1 ]; then
	clear
	echo "Error: 未輸入正確密碼, 無法繼續執行"
	exit 0
fi
clear

OS=`uname -s`
if [ "${OS}" == "Darwin" ] ; then
	echo "Info: Check file Now .."
	jumpToPDF_File=`sudo find ~/ -name jumpToPDF.py`
	if [ $? -eq 0 ]; then
		if grep -q '"Preview"' "${jumpToPDF_File}" ; then
			echo "Info: 已修改過, 無需再次修改"
			exit 0
		fi
		sed -i '' "/if plat == 'darwin':/a\ "$'\n>.^\t\t\tsubprocess.Popen(["open", "-a", "Preview"] + [pdffile])\n' "${jumpToPDF_File}"
		sed -i '' 's/>.^//g' "${jumpToPDF_File}"
		echo "Info: 完成！！"
	else
		echo "Error: 失敗, 您有安裝 LaTeXTools 了嗎？"
	fi
else
	echo "Info: 本腳本只適用於 Ｍac OS"
fi
exit 0
