Global $temp=EnvGet("Temp")
Func CreateControl($Width,$Height,$Titleh)
	Dim $LogBkColor=0x070307&','&0x5E1331
	FileInstall('bin\2.bmp',$temp&'\WinpeInToDisk\2.bmp',1)
	$Pic=GUICtrlCreatePic($temp&'\WinpeInToDisk\2.bmp',0,0,$Width,$Titleh,$WS_CLIPSIBLINGS)
	$LabelW1=GUICtrlCreateLabel('',0,0,$Width,2)
	GUICtrlSetBkColor(-1,StringSplit($LogBkColor,',')[1])
	GUICtrlSetState(-1,$GUI_DISABLE)
	$LabelW2=GUICtrlCreateLabel('',0,$Height-2,$Width,2)
	GUICtrlSetBkColor(-1,StringSplit($LogBkColor,',')[1])
	GUICtrlSetState(-1,$GUI_DISABLE)
	$LabelH1=GUICtrlCreateLabel('',0,0,2,$Height)
	GUICtrlSetBkColor(-1,StringSplit($LogBkColor,',')[1])
	GUICtrlSetState(-1,$GUI_DISABLE)
	$LabelH2=GUICtrlCreateLabel('',$Width-2,0,2,$Height)
	GUICtrlSetBkColor(-1,StringSplit($LogBkColor,',')[1])
	GUICtrlSetState(-1,$GUI_DISABLE)
	
	$ExitButton=GUICtrlCreateGraphic($Width-29,5,25,25)
    GUICtrlSetOnEvent(-1,"MsgGet")
    GUICtrlSetCursor(-1,0)
    GUICtrlSetGraphic(-1,$GUI_GR_PENSIZE,2)
    If StringSplit($LogBkColor,',')[0]>1 Then GUICtrlSetBkColor(-1, StringSplit($LogBkColor,',')[2])
    GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xffffff)
    GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 18, 7)
    GUICtrlSetGraphic(-1, $GUI_GR_LINE, 7, 18)
    GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 7, 7)
    GUICtrlSetGraphic(-1, $GUI_GR_LINE, 18, 18)

    $MiniButton=GUICtrlCreateGraphic($Width-55,5,25,25)
    GUICtrlSetOnEvent(-1,"MsgGet")
    GUICtrlSetCursor(-1,0)
	GUICtrlSetGraphic(-1,$GUI_GR_PENSIZE,2)
    If StringSplit($LogBkColor,',')[0]>1 Then GUICtrlSetBkColor(-1, StringSplit($LogBkColor,',')[2])
    GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xffffff)
    GUICtrlSetGraphic(-1, $GUI_GR_MOVE, 18, 16)
    GUICtrlSetGraphic(-1, $GUI_GR_LINE, 7, 16)
    GUICtrlDelete($Pic)
	$Pic=GUICtrlCreatePic($temp&'\WinpeInToDisk\2.bmp',0,0,$Width,$Titleh,$WS_CLIPSIBLINGS)
	GuiCtrlSetState(-1,$GUI_DISABLE)
	$LabelTitle=GUICtrlCreateLabel("   老段USB启动盘制作工具",0,0,$Width-55,45,$SS_CENTERIMAGE,$GUI_WS_EX_PARENTDRAG)
    GUICtrlSetColor(-1,0xffffff)
    GUICtrlSetFont(-1,11)
	GUICtrlSetBkColor ( -1,$GUI_BKCOLOR_TRANSPARENT)
	
	GUICtrlCreateLabel('EFI分区：'&@CR&'EFI镜像或散开到“EFI”目录。附加文件放“EFI”目录。'&@CR&'UD分区：'&@CR&'FBA或菜单文件。菜单文件放“MENU”目录、附加文件放“UD”目录。',12,45,$Width-24,$Titleh-45,'',$GUI_WS_EX_PARENTDRAG);拖动窗口
	GUICtrlSetColor(-1,0xffffff)
    GUICtrlSetBkColor ( -1,$GUI_BKCOLOR_TRANSPARENT)
	RunWait(@ComSpec&' /c del /q %temp%\WinpeInToDisk\*.bmp','',@SW_HIDE)
EndFunc

Func OemFileinstall()
	DirCreate($temp&'\WinpeInToDisk\lang')
    DirCreate($temp&'\WinpeInToDisk\native\wlh\amd64\fre')
    DirCreate($temp&'\WinpeInToDisk\native\wlh\x86\fre')
    
	FileInstall('bin\fbinst.exe',$temp&'\WinpeInToDisk\fbinst.exe')
	FileInstall('bin\7z.dll',$temp&'\WinpeInToDisk\7z.dll')
	FileInstall('bin\7z938.exe',$temp&'\WinpeInToDisk\7z938.exe')
	FileInstall('bin\cfg.ini',$temp&'\WinpeInToDisk\cfg.ini')
	FileInstall('bin\LoadDrv_Win32.exe',$temp&'\WinpeInToDisk\LoadDrv_Win32.exe')
	FileInstall('bin\LoadDrv_x64.exe',$temp&'\WinpeInToDisk\LoadDrv_x64.exe')
	FileInstall('bin\mfc80.dll',$temp&'\WinpeInToDisk\mfc80.dll')
	FileInstall('bin\mfc80u.dll',$temp&'\WinpeInToDisk\mfc80u.dll')
	FileInstall('bin\mfcm80.dll',$temp&'\WinpeInToDisk\mfcm80.dll')
	FileInstall('bin\mfcm80u.dll',$temp&'\WinpeInToDisk\mfcm80u.dll')
	FileInstall('bin\Microsoft.VC80.CRT.manifest',$temp&'\WinpeInToDisk\Microsoft.VC80.CRT.manifest')
	FileInstall('bin\Microsoft.VC80.MFC.manifest',$temp&'\WinpeInToDisk\Microsoft.VC80.MFC.manifest')
	FileInstall('bin\msvcm80.dll',$temp&'\WinpeInToDisk\msvcm80.dll')
	FileInstall('bin\msvcp80.dll',$temp&'\WinpeInToDisk\msvcp80.dll')
	FileInstall('bin\msvcr80.dll',$temp&'\WinpeInToDisk\msvcr80.dll')
	FileInstall('bin\PartAssist.exe',$temp&'\WinpeInToDisk\PartAssist.exe')
	FileInstall('bin\ScanPartition.dll',$temp&'\WinpeInToDisk\ScanPartition.dll')
	FileInstall('bin\SetupGreen32.exe',$temp&'\WinpeInToDisk\SetupGreen32.exe')
	FileInstall('bin\SetupGreen64.exe',$temp&'\WinpeInToDisk\SetupGreen64.exe')
	FileInstall('bin\lang\cn.txt',$temp&'\WinpeInToDisk\lang\cn.txt')
	FileInstall('bin\native\wlh\amd64\fre\ampa.sys',$temp&'\WinpeInToDisk\native\wlh\amd64\fre\ampa.sys')
	FileInstall('bin\native\wlh\x86\fre\ampa.sys',$temp&'\WinpeInToDisk\native\wlh\x86\fre\ampa.sys')
	
EndFunc

Func GetUsbDisk()
	RunWait(@ComSpec&' /c del /q %temp%\WinpeInToDisk\*disk.log','',@SW_HIDE)
    ListUsb()
	RunWait(@ComSpec & ' /c %temp%\WinpeInToDisk\fbinst.exe --hdlist "(hd%N) %P %I %U">%temp%\WinpeInToDisk\UsbDisk.log', '', @SW_HIDE,15);原来是:$STDOUT_CHILD   15=1+2+4+8
    If FileRead($temp&'\WinpeInToDisk\UsbDisk.log') Then
		$UsbDiskExist=''
		For $i= 1 To _FileCountLines($temp&'\WinpeInToDisk\UsbDisk.log')
			If StringInStr(FileRead($temp&'\WinpeInToDisk\Disk.ini'),StringLeft(FileReadLine($temp&'\WinpeInToDisk\UsbDisk.log',$i),5)) Then $UsbDiskExist=$UsbDiskExist&FileReadLine($temp&'\WinpeInToDisk\UsbDisk.log',$i)&' '&IniRead($temp&'\WinpeInToDisk\Disk.ini','DISK',StringLeft(FileReadLine($temp&'\WinpeInToDisk\UsbDisk.log',$i),5),'')&'|'
		Next
	EndIf
	If StringRight($UsbDiskExist,1)='|' Then $UsbDiskExist=StringTrimRight($UsbDiskExist,1)
	$SplitUsbDisk=StringSplit($UsbDiskExist,'|')
EndFunc

Func GetUsbPart($DefaultDisk)
	Global $EfiPartID='',$EfiPartSize='',$UnknownPartSize='',$UdPartSize='',$DataPartID=''
	RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /list:'&StringMid($DefaultDisk,4,1)&' /out:%temp%\WinpeInToDisk\usbsize.log', "", @SW_HIDE)
	FileDelete($temp&'\WinpeInToDisk\usbpart.log')
	For $i= 1 To _FileCountLines($temp&'\WinpeInToDisk\usbsize.log') Step 1
		If StringInStr(FileReadLine($temp&'\WinpeInToDisk\usbsize.log',$i),'|') Then FileWrite($temp&'\WinpeInToDisk\usbpart.log',FileReadLine($temp&'\WinpeInToDisk\usbsize.log',$i)&@CRLF)
		If StringInStr(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',$i),'|') And StringSplit(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',$i),'|')[0]>1 Then
			If StringRegExp(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',$i),'|')[2],'(?i)[c-z]:') Then $DataPartID=StringReplace(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',$i),'|')[1],' ','')
		EndIf	
	Next
	If StringInStr(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',2),'|') And StringInStr(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',2),'*:') And StringSplit(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',2),'|')[0]>2 Then 
		$EfiPartID=StringReplace(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',2),'|')[1],' ','')
	    $EfiPartSize=StringReplace(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',2),'|')[3],' ','')
	EndIf
	If StringInStr(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',3),'|') And StringInStr(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',3),'*:') And StringSplit(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',3),'|')[3]>2 Then 
		$EfiPartID=StringReplace(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',3),'|')[1],' ','')
	    $EfiPartSize=StringReplace(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',3),'|')[3],' ','')
	EndIf
	If $EfiPartSize Then 
		If StringInStr($EfiPartSize,'GB') Then $EfiPartSize=Int(StringReplace(StringReplace($EfiPartSize,'GB',''),' ','')*1024)
		If StringInStr($EfiPartSize,'MB') Then $EfiPartSize=Int(StringReplace(StringReplace($EfiPartSize,'MB',''),' ',''))
	EndIf
	
	If StringInStr(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',1),'|') And StringInStr(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',1),'未分配空间') And StringSplit(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',1),'|')[0]>2 Then $UnknownPartSize=StringSplit(FileReadLine($temp&'\WinpeInToDisk\usbpart.log',1),'|')[3]
	If $UnknownPartSize Then
		If StringInStr($UnknownPartSize,'GB') Then $UnknownPartSize=Int(StringReplace(StringReplace($UnknownPartSize,'GB',''),' ','')*1024)
		If StringInStr($UnknownPartSize,'MB') Then $UnknownPartSize=Int(StringReplace(StringReplace($UnknownPartSize,'MB',''),' ',''))
	EndIf
	If StringInStr($DefaultDisk,'*') Then
		RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' info|find /i "extended data size:">%temp%\WinpeInToDisk\udsize.log', "", @SW_HIDE)
		If StringInStr(FileReadLine($temp&'\WinpeInToDisk\udsize.log',1),":") And StringSplit(FileReadLine($temp&'\WinpeInToDisk\udsize.log',1),":")[0]>1 Then $UdPartSize=StringSplit(FileReadLine($temp&'\WinpeInToDisk\udsize.log',1),":")[2]/2048
	EndIf
EndFunc

Func ListUsb()
	FileDelete($temp&'\WinpeInToDisk\usb.log')
    RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\partassist.exe /list /usb /out:%temp%\WinpeInToDisk\usb.log', "", @SW_HIDE)
    FileDelete($temp&'\WinpeInToDisk\Disk.ini')
    Dim $_size=''
    For $i=1 To _FileCountLines($temp&'\WinpeInToDisk\usb.log') Step 1
	    If FileReadLine($temp&'\WinpeInToDisk\usb.log',$i) And StringInStr(FileReadLine($temp&'\WinpeInToDisk\usb.log',$i),'|') And StringSplit(FileReadLine($temp&'\WinpeInToDisk\usb.log',$i),'|')[0]>1 Then
		    If StringInStr(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usb.log',$i),'|')[2],'MB') Then $_size=Int(StringReplace(StringReplace(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usb.log',$i),'|')[2],'MB',''),' ','')-5)
		    If StringInStr(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usb.log',$i),'|')[2],'GB') Then $_size=Int(StringReplace(StringReplace(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usb.log',$i),'|')[2],'GB',''),' ','')*1024-5)
		    If StringInStr(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usb.log',$i),'|')[2],'TB') Then $_size=Int(StringReplace(StringReplace(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usb.log',$i),'|')[2],'TB',''),' ','')*1024*1024-5)
		    IniWrite($temp&'\WinpeInToDisk\Disk.ini','DISK','(hd'&StringReplace(StringReplace(StringSplit(FileReadLine($temp&'\WinpeInToDisk\usb.log',$i),'|')[1],' ',''),'	','')&')',$_size&' MB') 
	    EndIf
    Next
EndFunc