#RequireAdmin
#include <file.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <StaticConstants.au3>
#include "Bin\CreateControl.au3" 
#Region
#PRE_Icon=LD64.ico															
#PRE_OutFile=WinPE启动盘制作工具.exe														
#PRE_UseUpx=n														
#PRE_UseX64=n														
#PRE_Res_Comment=2016.01.31					        						
#PRE_Res_Description=WinPE启动盘制作工具												
#PRE_Res_Fileversion=0.0.0.1					    						
#PRE_Res_ProductVersion=0.0.0.1					    						
#PRE_Res_Field=Productname|WinPE启动盘制作工具                  						
#PRE_Res_Field=CompanyName|OpenSource                  						
#PRE_Res_Language=2052												
#PRE_Res_LegalCopyright=OpenSource												
#PRE_Res_Field=LegalTrademarks|LD            						
#PRE_Res_Field=OriginalFilename|WinPE启动盘制作工具.exe             						
#PRE_Res_Field=InternalName|0.0.0.1         						
#EndRegion
If WinExists(@ScriptName) Then Exit MsgBox(0,"友情提示",@ScriptName&" 正在运行 ...")
AutoItWinSetTitle(@ScriptName)
Global $temp=EnvGet("Temp"),$systemdrive=EnvGet("systemdrive"),$SystemRoot=EnvGet("SystemRoot")
If ProcessExists('PartAssist.exe') Then Exit MsgBox(4096,'友情提示','PartAssist.exe 正在运行。'&@CR&'请等待程序运行完毕或手动结束该进程后再次运行本程序！')
If ProcessExists('fbinst.exe') Then Exit MsgBox(4096,'友情提示','fbinst.exe 正在运行。'&@CR&'请等待程序运行完毕或手动结束该进程后再次运行本程序！')
Opt('TrayIconDebug',1)
Opt('MustDeclareVars',1)

Opt("GUIOnEventMode", 1)
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",3)
RunWait(@ComSpec&' /c rd /s /q %temp%\WinpeInToDisk&md %temp%\WinpeInToDisk','',@SW_HIDE)

TrayCreateItem("退出")
TrayItemSetOnEvent(-1,"_Exit")
TraySetState()
Global Const $DBT_DEVICEARRIVAL = 0x8000 
Global Const $DBT_DEVICEREMOVECOMPLETE = 0x8004 
GUIRegisterMsg($WM_DEVICECHANGE, 'My_Message_Test')  
Global $AllFbaFile,$AllIsoFile,$AllItem,$AllUefiIsoFile,$Button_Format,$Button_Write,$BianJie,$ChsCheckbox,$Command,$DefaultDisk,$DeviceCombo,$DataPartID,$EfiPartID,$EfiPartSize,$EfiSize,$EfiSizeInput,$EfiIsoCombo,$ExitButton
Global $FbaFile,$GUI,$GUI1,$GUI2,$GUIProgress,$HddZipCombo,$HideModeCombo,$Height=365,$LabelH1,$LabelH2,$LabelTitle,$LabelW1,$LabelW2,$LookupEfiIso,$LookupFba,$LookupAllIso,$MiniButton,$NoCreateUD,$Pic,$Progress=385
Global $DefaultDisk,$ReadChsCheckbox,$ReadEfiSizeInput,$ReadHddZipCombo,$ReadUDSizeInput,$ReadUltraISOCombo,$ReadHideModeCombo,$ReadWriteModeCombo1,$ReadWriteModeCombo2,$Run
Global $SplitUsbDisk,$Stop,$TempLabel2,$TempLabel3,$TempLabel4,$Time,$Titleh=120
Global $UDSize,$UDSizeInput,$UDFileCombo,$UdPartSize,$UefiIsoFile,$UltraISOCombo,$UltraIsoFile,$UnknownPartSize,$UsbDiskExist,$UsbDrvSize,$Width=450,$WriteError,$WriteModeCombo1,$WriteModeCombo2,$WuSun
$Run = Run(@ComSpec & ' /c dir /b %windir%|find /i ".exe"', '', @SW_HIDE,15)
If ProcessWaitClose($Run) And StringInStr(StdoutRead($Run),'.exe')='' Then Exit MsgBox(4096,'友情提示','find.exe缺失，程序无法正常运行！')
GUI()
Func GUI()
	RunWait(@ComSpec&' /c del /q %temp%\WinpeInToDisk\*.log','',@SW_HIDE)
	$GUI=GUICreate("WinPE启动盘制作工具",$Width,$Height,-1,-1,$WS_POPUP,$WS_EX_ACCEPTFILES)
    GUISetFont('9','','','Segoe UI')
	GUISetState()
	CreateControl($Width,$Height,$Titleh)
	Dim $TempLabel1=GUICtrlCreateLabel('扫描可移动磁盘...',2,$Height*0.55,$Width-4,25,$SS_CENTERIMAGE+$SS_CENTER)
	GUICtrlSetFont(-1,10)
	OemFileinstall()
	GetUsbDisk()
	GUICtrlSetData($TempLabel1,'分析WINPE文件...')
	GetWinpeFile()
	GUICtrlDelete($TempLabel1)
	$Button_Format=GUICtrlCreateButton('还原空间',250,$Height-57,80,25)
	GUICtrlSetOnEvent(-1,"MsgGet")
	GUICtrlSetCursor(-1,0)
	$Button_Write=GUICtrlCreateButton('一键写入',335,$Height-57,80,25)
	GUICtrlSetOnEvent(-1,"MsgGet")
	GUICtrlSetCursor(-1,0)
	
	If StringReplace($UsbDiskExist,'|','')='' Then
		GUICtrlSetState($Button_Format,$GUI_DISABLE)
		GUICtrlSetState($Button_Write,$GUI_DISABLE)
    EndIf
    GUI1()
EndFunc
Func GUI1()
	$GUIProgress=GUICreate("GUIProgress",$Progress,20,30,$Height-27,$WS_CHILD,'',$GUI)
	GUISetFont('9','','','Segoe UI')
	GUISetState()
	$TempLabel4=GUICtrlCreateLabel('',0,2,$Progress,16)
    GUICtrlSetBkColor(-1,0xc4c4c4)
	GUICtrlSetState(-1,$GUI_HIDE)
    $TempLabel3=GUICtrlCreateLabel('',0,2,1,16)
    GUICtrlSetBkColor(-1,0x00cc00)
	GUICtrlSetState(-1,$GUI_HIDE)
    $TempLabel2=GUICtrlCreateLabel('',0,2,$Progress,16,$SS_CENTERIMAGE)
    GUICtrlSetColor(-1,0xFF0000)
	GUICtrlSetBkColor ( -1,$GUI_BKCOLOR_TRANSPARENT)
	
	$GUI1=GUICreate("GUI1",$Width-4,80,2,$Titleh,$WS_CHILD,'',$GUI)
	If FileExists($SystemRoot&'\fonts\segoeui.ttf') Then GUISetFont('9','','','Segoe UI')
	GUISetState()
	GUICtrlCreateLabel("选择设备:",2,15,80,25,$SS_CENTERIMAGE+$SS_RIGHT)
	
	$DeviceCombo=GUICtrlCreateCombo("",95,15,260,25,$CBS_DROPDOWNLIST)
	GUICtrlSetOnEvent(-1,"MsgGet")
	If $UsbDiskExist Then $DefaultDisk=$SplitUsbDisk[1]
	GUICtrlSetData($DeviceCombo,$UsbDiskExist,$DefaultDisk)
	GUICtrlSetTip($DeviceCombo,GUICtrlRead($DeviceCombo))
			
	FileInstall('bin\updat3.bmp',$temp&'\WinpeInToDisk\updata.bmp')
	GUICtrlCreateLabel("部署方式:",2,50,80,25,$SS_CENTERIMAGE+$SS_RIGHT)
	$WriteModeCombo1=GUICtrlCreateCombo("",95,50,80,25,$CBS_DROPDOWNLIST)
	GUICtrlSetOnEvent(-1,"MsgGet")
	$WriteModeCombo2=GUICtrlCreateCombo("",185,50,80,25,$CBS_DROPDOWNLIST)
	GUICtrlSetOnEvent(-1,"MsgGet")
	$HideModeCombo=GUICtrlCreateCombo("",185,50,80,25,$CBS_DROPDOWNLIST)
	GUICtrlSetData(-1,'无|隐藏|高端隐藏|深度隐藏','高端隐藏')
	$HddZipCombo=GUICtrlCreateCombo("",275,50,80,25,$CBS_DROPDOWNLIST)
	GUICtrlSetData($HddZipCombo,"USB-HDD|USB-ZIP",'USB-HDD')
	$ChsCheckbox=GUICtrlCreateCheckbox('CHS',365,50,50,25)
	
	If FileExists(@ScriptDir&'\Menu\grldr') And FileExists(@ScriptDir&'\Menu\fb.cfg')='' Then FileInstall('fb.cfg',@ScriptDir&'\Menu\fb.cfg',1)
		
	$NoCreateUD=''
	If FileExists(@ScriptDir&'\Menu\fb.cfg') Then
		For $i = 1 To _FileCountLines(@ScriptDir&'\Menu\fb.cfg')
			If StringInStr(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),'menu ') And StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[0]>3 Then
				Dim $Split=StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[0]
				If FileExists(@ScriptDir&'\Menu\'&StringReplace(StringReplace(StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[$Split],'"',''),"'",""))='' Then $NoCreateUD=1
			EndIf
		Next
	EndIf
	If FileExists(@ScriptDir&'\Menu\fb.cfg')='' Then $NoCreateUD=1
	
	GUICtrlSetData($WriteModeCombo1,'')
	Dim $DefaultWriteMode=''
	If $AllIsoFile Then $DefaultWriteMode='ISO模式'
	If $FbaFile Or $NoCreateUD='' Then  $DefaultWriteMode='UD二分区'
	
	If $NoCreateUD='' Then 
	    If $UefiIsoFile Or FileExists(@ScriptDir&'\EFI\EFI\BOOT\*.EFI') Then $DefaultWriteMode='UD三分区'
	EndIf
	If $FbaFile Then
	    If $UefiIsoFile Or FileExists(@ScriptDir&'\EFI\EFI\BOOT\*.EFI') Then $DefaultWriteMode='UD三分区'
	EndIf
	If $DefaultWriteMode='' Then $DefaultWriteMode='UD三分区'
	GUICtrlSetData($WriteModeCombo1,'UD三分区|UD二分区|ISO模式',$DefaultWriteMode)
	
	
	CreateGui2()
	ShowWriteMode(1)
EndFunc
Func CreateGui2()
	If $GUI2 Then GUIDelete($GUI2)
	$GUI2=GUICreate("GUI2",$Width-4,100,2,$Titleh+85,$WS_CHILD,'',$GUI)
	If FileExists($SystemRoot&'\fonts\segoeui.ttf') Then GUISetFont('9','','','Segoe UI')
	GUISetState()
	GUISetOnEvent($GUI_EVENT_DROPPED, "GUI_Drop")
	
	FileInstall('bin\lookup3.bmp',$temp&'\WinpeInToDisk\lookup2.bmp')
	If GUICtrlRead($WriteModeCombo1)='ISO模式' Then
		GUICtrlSetState($WriteModeCombo2,$GUI_HIDE)
		GUICtrlSetState($HideModeCombo,$GUI_SHOW)
	Else
		GUICtrlSetState($HideModeCombo,$GUI_HIDE)
		GUICtrlSetState($WriteModeCombo2,$GUI_SHOW)
	EndIf
	If StringInStr(GUICtrlRead($WriteModeCombo1),'UD') Then 
		GetFileSize(1,'')
		GUICtrlSetState($ChsCheckbox,$GUI_SHOW)
		GUICtrlCreateLabel("UD区:",2,0,80,25,$SS_CENTERIMAGE+$SS_RIGHT)
		$UDSizeInput=GUICtrlCreateInput("",95,3,50,20)
		GUICtrlSetBkColor(-1,0xe0e0e0)
		If $UDSize Then 
			    If Ceiling($UDSize*1.02)<8 Then
				    GUICtrlSetData($UDSizeInput,8)
				Else
		            GUICtrlSetData($UDSizeInput,8*Ceiling($UDSize*1.02/8)+8)
				EndIf
		EndIf
		GUICtrlCreateLabel("MB",155,0,25,25,$SS_CENTERIMAGE)
		
		GUICtrlCreateLabel('FBA文件:',2,35,80,25,$SS_CENTERIMAGE+$SS_RIGHT)
		$UDFileCombo=GUICtrlCreateCombo('',95,35,260,25,$CBS_DROPDOWNLIST)
		GUICtrlSetOnEvent(-1,"MsgGet")
		GUICtrlSetState ( -1, $GUI_DROPACCEPTED)
		GUICtrlSetData($UDFileCombo,'')
		GUICtrlSetData($UDFileCombo,$AllFbaFile,$FbaFile)
		GUICtrlSetTip($UDFileCombo,GUICtrlRead($UDFileCombo))
		
		$LookupFba=GUICtrlCreatePic($temp&'\WinpeInToDisk\lookup2.bmp',365,35,45,25)
		GUICtrlSetOnEvent(-1,"LookupFba")
		GUICtrlSetCursor(-1,0)
	EndIf
		
	If GUICtrlRead($WriteModeCombo1)='ISO模式' Then 
		GUICtrlSetState($ChsCheckbox,$GUI_HIDE)
		GUICtrlCreateLabel("镜像文件:",2,0,80,25,$SS_CENTERIMAGE+$SS_RIGHT)
		$UltraISOCombo=GUICtrlCreateCombo("",95,0,260,25,$CBS_DROPDOWNLIST)
		GUICtrlSetState ( -1, $GUI_DROPACCEPTED)
		GUICtrlSetOnEvent(-1,"MsgGet")
		GUICtrlSetData($UltraISOCombo,'')
		GUICtrlSetData($UltraISOCombo,$AllIsoFile,$UltraIsoFile)
		GUICtrlSetTip($UltraISOCombo,GUICtrlRead($UltraISOCombo))
	    $LookupAllIso=GUICtrlCreatePic($temp&'\WinpeInToDisk\lookup2.bmp',365,0,45,25)
		GUICtrlSetOnEvent(-1,"LookupAllIso")
		GUICtrlSetCursor(-1,0)
	EndIf
	
	If GUICtrlRead($WriteModeCombo1)='UD三分区' Then
		GetFileSize('',1)
		GUICtrlCreateLabel("EFI区:",195,0,70,25,$SS_CENTERIMAGE+$SS_RIGHT)
		$EfiSizeInput=GUICtrlCreateInput("",275,3,50,20)
		GUICtrlSetBkColor(-1,0xe0e0e0)
		If $EfiSize Then
			If $EfiSize*1.02<48 Then
			    GUICtrlSetData($EfiSizeInput,48)
			Else
			    GUICtrlSetData($EfiSizeInput,8*Ceiling($EfiSize/8)+8)
			EndIf
		EndIf
		GUICtrlCreateLabel("MB",335,0,25,25,$SS_CENTERIMAGE)
		GUICtrlCreateLabel('UEFI镜像:',2,70,80,25,$SS_CENTERIMAGE+$SS_RIGHT)
		$EfiIsoCombo=GUICtrlCreateCombo('',95,70,260,25,$CBS_DROPDOWNLIST)
		GUICtrlSetOnEvent(-1,"MsgGet")
		GUICtrlSetState ( -1, $GUI_DROPACCEPTED)
		GUICtrlSetData($EfiIsoCombo,'')
		GUICtrlSetData($EfiIsoCombo,$AllUefiIsoFile,$UefiIsoFile)
		GUICtrlSetTip($EfiIsoCombo,GUICtrlRead($EfiIsoCombo))
		
		$LookupEfiIso=GUICtrlCreatePic($temp&'\WinpeInToDisk\lookup2.bmp',365,70,45,25)
		GUICtrlSetOnEvent(-1,"LookupEfiIso")
		GUICtrlSetCursor(-1,0)
	EndIf
	RunWait(@ComSpec&' /c del /q %temp%\WinpeInToDisk\*.bmp','',@SW_HIDE)
EndFunc
While 1
	Sleep(5)
	If FileExists($temp&'\WinpeInToDisk')='' Then 
	    DirCreate($temp&'\WinpeInToDisk')
		OemFileinstall()
	EndIf
	If $Command Then
		If $Command='FmtForce' Then 
	    	FmtForce()
			$Command=''
		EndIf
		If $command='NewMode' Then
			NewMode()
			$Command=''
		EndIf
		If $command='BianJieMode' Then
			BianJieMode()
			$Command=''
		EndIf
		If $command='WuSunMode' Then
			WuSunMode()
			$Command=''
		EndIf
		If $command='IsoMode' Then
			IsoMode()
			$Command=''
		EndIf
	EndIf
WEnd
Func MsgGet()
	Select
		Case @GUI_CtrlId = $MiniButton Or @GUI_CtrlId = $ExitButton 
		    If @GUI_CtrlId = $MiniButton Then WinSetState($GUI,"",@SW_MINIMIZE)
			If @GUI_CtrlId = $ExitButton Then 
			    If $command And MsgBox(4097,'友情提示','程序正在运行，您确定要退出？')=1 Then _Exit()
			    If $command='' Then _Exit()
			EndIf
		Case @GUI_CtrlId = $DeviceCombo
			$DefaultDisk=GUICtrlRead($DeviceCombo)
			GUICtrlSetTip($DeviceCombo,$DefaultDisk)
			If GUICtrlRead($WriteModeCombo1)<>'ISO模式' Then ShowWriteMode(1)
		Case @GUI_CtrlId = $WriteModeCombo1
			$DefaultDisk=GUICtrlRead($DeviceCombo)
			CreateGui2()
			If GUICtrlRead($WriteModeCombo1)<>'ISO模式' Then ShowWriteMode(1)
		Case @GUI_CtrlId = $UDFileCombo
			$DefaultDisk=GUICtrlRead($DeviceCombo)
			$FbaFile=GUICtrlRead($UDFileCombo)
			If $FbaFile Then GetFileSize(1,'')
			If $UDSize Then 
			    If Ceiling($UDSize*1.02)<8 Then
				    GUICtrlSetData($UDSizeInput,8)
				Else
		            GUICtrlSetData($UDSizeInput,8*Ceiling($UDSize*1.02/8)+8)
				EndIf
		    EndIf
			GUICtrlSetTip($UdFileCombo,GUICtrlRead($UdFileCombo))
		    ShowWriteMode(1)
		Case @GUI_CtrlId = $EfiIsoCombo
			$DefaultDisk=GUICtrlRead($DeviceCombo)
			$UefiIsoFile=GUICtrlRead($EfiIsoCombo)
			If $UefiIsoFile Then GetFileSize('',1)
			If $EfiSize Then
			    If $EfiSize*1.02<48 Then
				    GUICtrlSetData($EfiSizeInput,48)
				Else
			        GUICtrlSetData($EfiSizeInput,8*Ceiling($EfiSize/8)+8)
				EndIf
			EndIf
			GUICtrlSetTip($EfiIsoCombo,GUICtrlRead($EfiIsoCombo))
			ShowWriteMode(1)
		Case @GUI_CtrlId = $UltraISOCombo
			
			GUICtrlSetTip($UltraISOCombo,GUICtrlRead($UltraISOCombo))
			
		Case @GUI_CtrlId = $Button_Format
			$DefaultDisk=GUICtrlRead($DeviceCombo)
			If StringRegExp($DefaultDisk,'hd[0-9]') And MsgBox(4097,'友情提示',$DefaultDisk&@CR&'继续执行该设备中所有数据都将丢失！')=1 Then $Command='FmtForce'
		Case @GUI_CtrlId = $Button_Write
			RunWait(@ComSpec&' /c del /q %temp%\WinpeInToDisk\*.log','',@SW_HIDE)
			DISABLE()
			
			$DefaultDisk=GUICtrlRead($DeviceCombo)
			$ReadWriteModeCombo1=GUICtrlRead($WriteModeCombo1)
			$ReadWriteModeCombo2=GUICtrlRead($WriteModeCombo2)
			$ReadHddZipCombo=GUICtrlRead($HddZipCombo)
			$ReadChsCheckbox=GUICtrlRead($ChsCheckbox)
			$ReadUDSizeInput=GUICtrlRead($UDSizeInput)
			$ReadEfiSizeInput=GUICtrlRead($EfiSizeInput)
			
			If StringInStr($ReadEfiSizeInput/8,'.') Then $ReadEfiSizeInput=8*Ceiling($ReadEfiSizeInput/8)+8
			$ReadHideModeCombo=GUICtrlRead($HideModeCombo)
			$UltraIsoFile=GUICtrlRead($UltraISOCombo)
			$FbaFile=GUICtrlRead($UdFileCombo)
			$UefiIsoFile=GUICtrlRead($EfiIsoCombo)
			
			ListUsb()
			$UsbDrvSize=''
			If StringReplace(StringReplace(IniRead($temp&'\WinpeInToDisk\Disk.ini','DISK',StringLeft($DefaultDisk,5),''),'MB',''),' ','') Then $UsbDrvSize=StringReplace(StringReplace(IniRead($temp&'\WinpeInToDisk\Disk.ini','DISK',StringLeft($DefaultDisk,5),''),'MB',''),' ','')
			
			If StringInStr($DefaultDisk,'(hd') And $UsbDrvSize Then
				ShowWriteMode('')
				ENABLE()
				If $ReadWriteModeCombo1='ISO模式' Then
					If FileExists($UltraIsoFile) Then
						If $Stop Then
							MsgBox(4096,'',$Stop)
						Else
				        	$command='IsoMode'
						EndIf
					Else
						MsgBox(4096,'友情提示','ISO镜像文件未发现！')
					EndIf
				EndIf
				If StringInStr($ReadWriteModeCombo1,'UD') Then
					$NoCreateUD=''
					If FileExists(@ScriptDir&'\Menu\fb.cfg') Then
						For $i = 1 To _FileCountLines(@ScriptDir&'\Menu\fb.cfg')
							If StringInStr(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),'menu ') And StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[0]>3 Then
								Dim $Split=StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[0]
								If FileExists(@ScriptDir&'\Menu\'&StringReplace(StringReplace(StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[$Split],'"',''),"'",""))='' Then $NoCreateUD=1
							EndIf
						Next
					EndIf
					If FileExists(@ScriptDir&'\Menu\fb.cfg')='' Then $NoCreateUD=1
					
					If FileExists($FbaFile)='' And $NoCreateUD=1 Then $Stop=$Stop&'Fba文件或菜单文件未发现！'&@CR
					If $ReadWriteModeCombo1='UD三分区' Then
				    	If FileExists($UefiIsoFile)='' And FileExists(@ScriptDir&'\EFI\EFI\BOOT\*.EFI')='' Then $Stop=$Stop&'UEFI镜像未发现！'&@CR
					EndIf
					
					If $ReadWriteModeCombo2='全新写入' Then
						If $Stop Then 
							MsgBox(4096,'友情提示',$Stop)
						Else
							$command='NewMode'
						EndIf
					EndIf
					If $ReadWriteModeCombo2='无损写入' And $WuSun Then
						If $Stop Then 
							MsgBox(4096,'友情提示',$Stop)
						Else
							$command='WuSunMode'
						EndIf
					EndIf
					If $ReadWriteModeCombo2='便捷写入' And $BianJie Then
						If $Stop Then 
							MsgBox(4096,'友情提示',$Stop)
						Else
							$command='BianJieMode'
						EndIf
					EndIf
					If $ReadWriteModeCombo2='无损写入' And $WuSun='' Then MsgBox(4096,'友情提示','条件不具备，不支持无损写入！')
					If $ReadWriteModeCombo2='便捷写入' And $BianJie='' Then MsgBox(4096,'友情提示','条件不具备，不支持便捷写入！')
				EndIf
			Else
				ENABLE()
				MsgBox(4096,'友情提示','没有选择可移动磁盘或没有返回可移动磁盘容量！')
			EndIf
	EndSelect
EndFunc
Func WuSunMode()
						DISABLE()
						$WriteError=''
						If StringMid($DefaultDisk,8,1)=':' And FileExists(StringMid($DefaultDisk,7,2)) Then 
							$AllItem=2 
							If DriveGetFileSystem(StringMid($DefaultDisk,7,2))='fat16' Or DriveGetFileSystem(StringMid($DefaultDisk,7,2))='fat32' Then $AllItem=$AllItem+1 
							If $EfiPartID Then $AllItem=$AllItem+1 
							If $EfiPartID Or $UnknownPartSize Then $AllItem=$AllItem+1 
							If $ReadWriteModeCombo1='UD三分区' Then 
							    $AllItem=$AllItem+2 
								If $UefiIsoFile Then $AllItem=$AllItem+2 
						        If DirGetSize(@ScriptDir&'\EFI')>0 Then $AllItem=$AllItem+1 
						    EndIf
							If $FbaFile Then $AllItem=$AllItem+1
						    If DirGetSize(@ScriptDir&'\UD')>0 Then $AllItem=$AllItem+1 
							
							If DriveGetFileSystem(StringMid($DefaultDisk,7,2))='fat16' Or DriveGetFileSystem(StringMid($DefaultDisk,7,2))='fat32' Then
								RunWait(@ComSpec&' /c CONVERT.exe /?|find /i "NoSecurity">%temp%\WinpeInToDisk\CONVERT.log', "", @SW_HIDE)
								If StringInStr(FileRead($temp&'\WinpeInToDisk\CONVERT.log'),'NoSecurity')="" Then $WriteError='CONVERT.EXE未发现，无法对可见区进行无损转换！'
								If $WriteError='' Then
								    $Run=Run(@ComSpec&' /c CONVERT.exe '&StringMid($DefaultDisk,7,2)&' /FS:NTFS /V /NoSecurity', "", @SW_HIDE)
							        $Time=TimerInit()
								    RunWhile($Progress*2,$AllItem,'可见区无损转换...')
								    GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
								    If DriveGetFileSystem(StringMid($DefaultDisk,7,2))<>'NTFS' Then $WriteError='可见区无损转换失败。'&@CR&'原因可能是可见区空间不足或设备被占用！'
								EndIf
							EndIf
							
							If $EfiPartID And $WriteError='' Then
								$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /del:'&$EfiPartID, "", @SW_HIDE)
								$Time=TimerInit()
								RunWhile(30, $AllItem, '删除EFI区...')
								GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
							EndIf
							If $WriteError='' Then
							    If $EfiPartID Or $UnknownPartSize Then 
								    
								    
								    $Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /resize:'&$DataPartID&' /extend:auto /align', "", @SW_HIDE)
								    $Time=TimerInit()
									RunWhile(100+(DriveSpaceTotal(StringMid($DefaultDisk,7,2))-DriveSpaceFree(StringMid($DefaultDisk,7,2)))/24, $AllItem, '恢复单一分区...')
								    GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
							    EndIf
							
								Dim $Zip='',$CHS=''
			    				If $ReadHddZipCombo='USB-ZIP' Then $Zip='--zip'
								If $ReadChsCheckbox=1 Then $CHS='--chs'
								
								
								$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /resize:0 /reduce-left:'&$ReadUDSizeInput+8&' /align', "", @SW_HIDE)
								$Time=TimerInit()
								RunWhile(200+(DriveSpaceTotal(StringMid($DefaultDisk,7,2))-DriveSpaceFree(StringMid($DefaultDisk,7,2)))/24, $AllItem, '分配UD区...')
								GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
								
								$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' format --extended '&Ceiling($ReadUDSizeInput)&'m '&$Zip&' '&$CHS&' --fat32 --primary 8m --align', "", @SW_HIDE)
								$Time=TimerInit()
								RunWhile(30, $AllItem, '创建UD区...')
								GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
								RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' info|find /i "data size:" >%temp%\WinpeInToDisk\UDInfo.log', "", @SW_HIDE)
								FileDelete($temp&'\WinpeInToDisk\UDInfos.log')
								FileWrite($temp&'\WinpeInToDisk\UDInfos.log',StringReplace(StringReplace(StringReplace(FileRead($temp&'\WinpeInToDisk\UDInfo.log'),'primary data size:',''),'extended data size:',''),' ',''))
								If FileReadLine($temp&'\WinpeInToDisk\UDInfos.log',1)/2048<8-1 Or FileReadLine($temp&'\WinpeInToDisk\UDInfos.log',2)/2048<$ReadUDSizeInput-1 Then $WriteError='UD区创建失败！'
								Menu()
								RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' restore', "", @SW_HIDE)
							EndIf
							
							If $ReadWriteModeCombo1='UD三分区' And $WriteError='' Then
								
								$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /resize:0 /reduce-right:'&$ReadEfiSizeInput&' /align', "", @SW_HIDE)
								$Time=TimerInit()
								RunWhile(80, $AllItem, '分配EFI区...')
								GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
								
								$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\partassist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /cre /pri /size:auto /end /fs:fat16 /align', "", @SW_HIDE)
								$Time=TimerInit()
								RunWhile(30, $AllItem, '创建EFI区...')
								GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
								
								RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /list:'&StringMid($DefaultDisk,4,1)&' /out:%temp%\WinpeInToDisk\usbsize.log', "", @SW_HIDE)
								Dim $Lines=''
						    	For $i= 1 To _FileCountLines($temp&'\WinpeInToDisk\usbsize.log') Step 1
							    	If StringInStr(FileReadLine($temp&'\WinpeInToDisk\usbsize.log',$i),'|') Then $Lines=$Lines+1
								Next
								If $Lines<3 Or StringInStr(FileRead($temp&'\WinpeInToDisk\usbsize.log'),'未分配空间','',2) Then $WriteError='给可移动磁盘分区失败！' 
								
								If StringInStr(FileRead($temp&'\WinpeInToDisk\usbsize.log'),'*:')='' And $WriteError='' Then RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /hide:1', "", @SW_HIDE)
							
							EndIf
							
							If $ReadWriteModeCombo1='UD三分区' And $WriteError='' Then WriteEfi()
							If $WriteError='' Then WriteUd()
							
						    GetUsbDisk()
							GetWinpeFile()
					    	ShowWriteMode(1)
							If $WriteError Then
								MsgBox(4096,'友情提示',$WriteError)
							Else
								If FileExists(StringMid($DefaultDisk,7,2)) Then
									MsgBox(4096,'友情提示','制作完成！',3)
								Else
									MsgBox(4096,'友情提示','制作完成！但可移动磁盘盘符无法分配，设备可能被占用。'&@CR&'请手动在“磁盘管理”中为可移动磁盘指定盘符！')
					    		EndIf
							EndIf
						Else
							MsgBox(4096,'友情提示','可移动磁盘无盘符，请手动在“磁盘管理”中给可见区分配盘符！')
						EndIf
					    ENABLE()
						GUICtrlSetPos($TempLabel3,Default,Default,2,Default)
						GUICtrlSetState($TempLabel3,$GUI_HIDE)
						GUICtrlSetState($TempLabel4,$GUI_HIDE)
						GUICtrlSetData($TempLabel2,'')
EndFunc
Func IsoMode()
	            DISABLE()
	            If FileExists(StringMid($DefaultDisk,7,2)) Then
					
						Dim $UHide='2',$USBMode='4' 
						If $ReadHddZipCombo='USB-ZIP' Then $USBMode='5' 
						If $ReadHideModeCombo="无" Then $UHide='0'
						If $ReadHideModeCombo="隐藏" Then $UHide='1'
						If $ReadHideModeCombo="高端隐藏" Then $UHide='2'
						If $ReadHideModeCombo="深度隐藏" Then $UHide='3'
						RunWait(@ComSpec&' /c reg.exe export "HKEY_CURRENT_USER\Software\EasyBoot Systems\UltraISO\5.0" '&$temp&'\WinpeInToDisk\UltraISO.reg', "", @SW_HIDE)
						RegDelete("HKEY_CURRENT_USER\Software\EasyBoot Systems\UltraISO\5.0")
						RegWrite("HKEY_CURRENT_USER\Software\EasyBoot Systems\UltraISO\5.0","UserName","REG_SZ","王涛")
						RegWrite("HKEY_CURRENT_USER\Software\EasyBoot Systems\UltraISO\5.0","Registration","REG_SZ","69414b170e136f766a32471009176109")
						RegWrite("HKEY_CURRENT_USER\Software\EasyBoot Systems\UltraISO\5.0","Language","REG_SZ","2052")
						RegWrite("HKEY_CURRENT_USER\Software\EasyBoot Systems\UltraISO\5.0","SoundEffect","REG_SZ","0")
						RegWrite("HKEY_CURRENT_USER\Software\EasyBoot Systems\UltraISO\5.0","USBBootPart","REG_SZ",$UHide)
				    	RegWrite("HKEY_CURRENT_USER\Software\EasyBoot Systems\UltraISO\5.0","UPlusV2Level","REG_SZ","3")
				    	RegWrite("HKEY_CURRENT_USER\Software\EasyBoot Systems\UltraISO\5.0","USBMode","REG_SZ",$USBMode)
				    	RegWrite("HKEY_CURRENT_USER\Software\EasyBoot Systems\UltraISO\5.0","UseSkins","REG_SZ","1")
				
				    	FileInstall('bin\UltraISO9653237.exe',$temp&'\WinpeInToDisk\UltraISO9653237.exe',1)
				    	$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\UltraISO9653237.exe -input "'&$UltraIsoFile&'" -writeusb','',@SW_HIDE)
				    	$Time=TimerInit()
						While 1
							If TimerDiff($Time)/1000>5 Then ExitLoop 
							If WinMove('写入硬盘映像','',5,5) Then ExitLoop
						WEnd
						If WinWait('写入硬盘映像','',5) Then
							WinWaitActive('写入硬盘映像','',5)
							$Time=TimerInit()
							While 1
								If StringInStr(ControlGetText("写入硬盘映像","写入", "TComboBox4"),StringMid($DefaultDisk,7,2))="" Then
									WinActivate("写入硬盘映像")
									ControlClick ("写入硬盘映像","写入", "TComboBox4")
									For $i=1 To StringSplit($UsbDiskExist,'|')[0]
										Sleep(100)
										Send("{DOWN}")
										If StringInStr(ControlGetText("写入硬盘映像","写入", "TComboBox4"),StringMid($DefaultDisk,7,2)) Then
											ControlCommand ("写入硬盘映像","写入", "TComboBox4", "HideDropDown", "")
											ControlClick ("写入硬盘映像","写入", "TProgressBar1")
											$i=StringSplit($UsbDiskExist,'|')[0]
											ExitLoop
										EndIf
									Next
								EndIf
								If StringInStr(ControlGetText("写入硬盘映像","写入", "TComboBox4"),StringMid($DefaultDisk,7,2))="" Then
									WinActivate("写入硬盘映像")
									ControlClick ("写入硬盘映像","写入", "TComboBox4")
									For $i=StringSplit($UsbDiskExist,'|')[0] To 1 Step -1
										Sleep(100)
										Send("{UP}")
										If StringInStr(ControlGetText("写入硬盘映像","写入", "TComboBox4"),StringMid($DefaultDisk,7,2)) Then
											ControlCommand ("写入硬盘映像","写入", "TComboBox4", "HideDropDown", "")
											ControlClick ("写入硬盘映像","写入", "TProgressBar1")
											$i=1
											ExitLoop
										EndIf
									Next
								EndIf
								If StringInStr(ControlGetText("写入硬盘映像","写入", "TComboBox4"),StringMid($DefaultDisk,7,2)) Then ExitLoop
								If TimerDiff($Time)/1000>10 Then ExitLoop
								If WinExists("写入硬盘映像")='' Then 
									MsgBox(4096,'友情提示','程序被强行关闭，制作未完成！')
								    ExitLoop
								EndIf
							WEnd
							Dim $sf=''
							If StringInStr(ControlGetText("写入硬盘映像","写入", "TComboBox4"),StringMid($DefaultDisk,7,2))="" Then $sf=MsgBox(4097,'友情提示','设备无法锁定，请手动选择后按“确定”按钮继续！')
							If $sf<>2 Then
							    WinActivate("写入硬盘映像")
								Sleep(100)
							    ControlClick ("写入硬盘映像","写入","写入")
								$Time=TimerInit()
							    While 1
									If TimerDiff($Time)/1000>5 Then ExitLoop 
								    If WinSetTrans ("提示","是(&Y)", 5) Then ExitLoop
								WEnd
								If WinExists("提示","是(&Y)")='' Then
									WinActivate("写入硬盘映像")
								    Sleep(100)
							        ControlClick ("写入硬盘映像","写入","写入")
								    $Time=TimerInit()
							        While 1
									    If TimerDiff($Time)/1000>5 Then ExitLoop
								        If WinSetTrans ("提示","是(&Y)", 5) Then ExitLoop
										If WinExists("写入硬盘映像")='' Then 
									        MsgBox(4096,'友情提示','程序被强行关闭，制作未完成！')
								            ExitLoop
								        EndIf
								    WEnd
								EndIf
							    $Time=TimerInit()
								While 1
									WinActivate("提示","是(&Y)")
								    Sleep(100)
							        ControlClick ("提示","是(&Y)","是(&Y)")
								    If WinExists("提示","是(&Y)")='' Then  ExitLoop
									If TimerDiff($Time)/1000>5 Then ExitLoop
									If WinExists("写入硬盘映像")='' Then 
									    MsgBox(4096,'友情提示','程序被强行关闭，制作未完成！')
								        ExitLoop
								    EndIf
								WEnd
							    If WinExists("提示","是(&Y)") Then WinSetTrans ("提示","是(&Y)", 255)
							    While 1
								    Sleep(100)
								    If ControlCommand ("写入硬盘映像","写入", "写入", "IsEnabled", "")=1 Then 
									    WinClose("写入硬盘映像")
									    ProcessClose("UltraISO9653237.exe")
										If StringInStr($ReadHideModeCombo,"隐藏") Then
											$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /fmt:'&StringMid($DefaultDisk,7,1)&' /fs:NTFS', "", @SW_HIDE)
			    						    $Time=TimerInit()
										    RunWhile(100,'','可见区格式化NTFS...')
										EndIf
										GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
									    MsgBox(4096,'友情提示','制作完成！',3)
									    ExitLoop
								    EndIf
									If WinExists("写入硬盘映像")='' Then 
									    MsgBox(4096,'友情提示','程序被强行关闭，制作未完成！')
								        ExitLoop
								    EndIf
								WEnd
							Else
								WinClose("写入硬盘映像")
								ProcessClose("UltraISO9653237.exe")
							EndIf	
						
						    If FileExists($temp&'\WinpeInToDisk\UltraISO.reg') Then 
							    RegDelete("HKEY_CURRENT_USER\Software\EasyBoot Systems\UltraISO\5.0")
							    RunWait('REGEDIT /S '&$temp&'\WinpeInToDisk\UltraISO.reg')
							    FileDelete($temp&'\WinpeInToDisk\UltraISO.reg')
						    EndIf
				        Else
					        MsgBox(4096,'友情提示','UltraISO 未能启动！')
				        EndIf
                    
				Else
					MsgBox(4096,'友情提示','可移动磁盘无盘符，请手动在“磁盘管理”中给可见区分配盘符！')
				EndIf
				ENABLE()
				GetUsbDisk()
				GetWinpeFile()
				ShowWriteMode(1)
				WinSetState ($GUI1, "", @SW_ENABLE )
				WinSetState ($GUI2, "", @SW_ENABLE )
				GUICtrlSetState($Button_Format,$GUI_ENABLE)
				GUICtrlSetState($Button_Write,$GUI_ENABLE)
				
EndFunc
Func BianJieMode()
					DISABLE()    
					If StringMid($DefaultDisk,8,1)<>':' Or FileExists(StringMid($DefaultDisk,7,2))='' Then $WriteError='可移动磁盘无盘符，请手动在“磁盘管理”中给可见区分配盘符！'
						If $WriteError='' Then
							$AllItem=1 
							If $FbaFile Then $AllItem=$AllItem+1
						    If DirGetSize(@ScriptDir&'\UD')>0 Then $AllItem=$AllItem+1 
							If $ReadWriteModeCombo1='UD三分区' Then 
								 $AllItem=$AllItem+1 
						        If $UefiIsoFile Then $AllItem=$AllItem+2 
						        If DirGetSize(@ScriptDir&'\EFI')>0 Then $AllItem=$AllItem+1 
						    EndIf
							
							Dim $Zip='',$CHS=''
			    			If $ReadHddZipCombo='USB-ZIP' Then $Zip='--zip'
							If $ReadChsCheckbox=1 Then $CHS='--chs'
							$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' format --extended '&Ceiling($UDSize*1.01)&'m --align '&$Zip&' '&$CHS&' --fat32 --primary 8m', "", @SW_HIDE)
            				$Time=TimerInit()
							RunWhile(60, $AllItem, '创建UD区...') 
							GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
							RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' info|find /i "data size:" >%temp%\WinpeInToDisk\UDInfo.log', "", @SW_HIDE)
						    FileDelete($temp&'\WinpeInToDisk\UDInfos.log')
						    FileWrite($temp&'\WinpeInToDisk\UDInfos.log',StringReplace(StringReplace(StringReplace(FileRead($temp&'\WinpeInToDisk\UDInfo.log'),'primary data size:',''),'extended data size:',''),' ',''))
						    If FileReadLine($temp&'\WinpeInToDisk\UDInfos.log',1)/2048<8-1 Or FileReadLine($temp&'\WinpeInToDisk\UDInfos.log',2)/2048<Ceiling($UDSize*1.01)-1 Then $WriteError='UD区创建失败！'
							Menu()
							RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' restore', "", @SW_HIDE)
						EndIf
						
						If $ReadWriteModeCombo1='UD三分区' And $WriteError='' Then
							
							$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /whide:'&$EfiPartID&' /delfiles', "", @SW_HIDE)
							$Time=TimerInit()
							RunWhile(30, $AllItem, '清空EFI区...') 
						    GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
							WriteEfi()
						EndIf
						If $WriteError='' Then WriteUd()
						
						GetUsbDisk()
						GetWinpeFile()
					    ShowWriteMode(1)
						If $WriteError Then
							MsgBox(4096,'友情提示',$WriteError)
						Else
							If FileExists(StringMid($DefaultDisk,7,2)) Then
								MsgBox(4096,'友情提示','制作完成！',3)
							Else
								MsgBox(4096,'友情提示','制作完成！'&@CR&'但可移动磁盘盘符无法分配，设备可能被占用。'&@CR&'请手动在“磁盘管理”中为可移动磁盘指定盘符！')
							EndIf
						EndIf
					ENABLE()
					GUICtrlSetPos($TempLabel3,Default,Default,2,Default)
					GUICtrlSetState($TempLabel3,$GUI_HIDE)
					GUICtrlSetState($TempLabel4,$GUI_HIDE)
					GUICtrlSetData($TempLabel2,'')
					
EndFunc
Func NewMode()
					    DISABLE()
						$WriteError=''
						Dim $Zip='',$CHS=''
			    		If $ReadHddZipCombo='USB-ZIP' Then $Zip='--zip'
						If $ReadChsCheckbox=1 Then $CHS='--chs'
                        $AllItem=2  
						If $FbaFile Then $AllItem=$AllItem+1
						If DirGetSize(@ScriptDir&'\UD')>0 Then $AllItem=$AllItem+1 
						If $ReadWriteModeCombo1='UD三分区' Then 
						    $AllItem=$AllItem+2 
						    If $UefiIsoFile Then $AllItem=$AllItem+2 
						    If DirGetSize(@ScriptDir&'\EFI')>0 Then $AllItem=$AllItem+1 
						EndIf
						
						$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' format --extended '&Ceiling($ReadUDSizeInput)&'m --force --align '&$Zip&' '&$CHS&' --fat32 --primary 8m', "", @SW_HIDE)
            			$Time=TimerInit()
						RunWhile(60, $AllItem, '创建UD区...') 
						GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
						RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' info|find /i "data size:" >%temp%\WinpeInToDisk\UDInfo.log', "", @SW_HIDE)
						FileDelete($temp&'\WinpeInToDisk\UDInfos.log')
						FileWrite($temp&'\WinpeInToDisk\UDInfos.log',StringReplace(StringReplace(StringReplace(FileRead($temp&'\WinpeInToDisk\UDInfo.log'),'primary data size:',''),'extended data size:',''),' ',''))
						If FileReadLine($temp&'\WinpeInToDisk\UDInfos.log',1)/2048<8-1 Or FileReadLine($temp&'\WinpeInToDisk\UDInfos.log',2)/2048<$ReadUDSizeInput-1 Then $WriteError='UD区创建失败！'
						Menu()
						RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' restore', "", @SW_HIDE)
						If StringMid($DefaultDisk,8,1)<>':' Or FileExists(StringMid($DefaultDisk,7,2))='' Then $WriteError='可移动磁盘盘符无法分配，设备可能被占用。'&@CR&'请手动在“磁盘管理”中为可移动磁盘指定盘符！'
						If $WriteError='' Then
							
							$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /fmt:0 /fs:NTFS', "", @SW_HIDE)
							$Time=TimerInit()
							RunWhile(100, $AllItem, '可见区格式化NTFS...')
							GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
						EndIf
						
						If $ReadWriteModeCombo1='UD三分区' And $WriteError='' Then
							
							$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /resize:0 /reduce-right:'&$ReadEfiSizeInput+2&' /align', "", @SW_HIDE)
							$Time=TimerInit()
							RunWhile(60, $AllItem, '分配EFI区...')
							GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
							
							
							$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /cre /pri /size:auto /end /fs:fat16 /align', "", @SW_HIDE)
							$Time=TimerInit()
							RunWhile(30, $AllItem, '创建EFI区...')
							GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
							
							RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /list:'&StringMid($DefaultDisk,4,1)&' /out:%temp%\WinpeInToDisk\usbsize.log', "", @SW_HIDE)
							Dim $Lines=''
						    For $i= 1 To _FileCountLines($temp&'\WinpeInToDisk\usbsize.log') Step 1
							    If StringInStr(FileReadLine($temp&'\WinpeInToDisk\usbsize.log',$i),'|') Then $Lines=$Lines+1
							Next
							If $Lines<3 Or StringInStr(FileRead($temp&'\WinpeInToDisk\usbsize.log'),'未分配空间','',2) Then $WriteError='给可移动磁盘分区失败！' 
							
							If StringInStr(FileRead($temp&'\WinpeInToDisk\usbsize.log'),'*:')='' And $WriteError='' Then RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /hide:1', "", @SW_HIDE)
							If $ReadWriteModeCombo1='UD三分区' And $WriteError='' Then WriteEfi()
						EndIf
						If $WriteError='' Then WriteUd()
						
						GetUsbDisk()
						GetWinpeFile()
					    ShowWriteMode(1)
						If $WriteError Then
							MsgBox(4096,'友情提示',$WriteError)
						Else
							If FileExists(StringMid($DefaultDisk,7,2)) Then
								MsgBox(4096,'友情提示','制作完成！',3)
							Else
								MsgBox(4096,'友情提示','制作完成！但可移动磁盘盘符无法分配，设备可能被占用。'&@CR&'请手动在“磁盘管理”中为可移动磁盘指定盘符！')
					    	EndIf
						EndIf
				        ENABLE()
					    GUICtrlSetPos($TempLabel3,Default,Default,2,Default)
					    GUICtrlSetState($TempLabel3,$GUI_HIDE)
					    GUICtrlSetState($TempLabel4,$GUI_HIDE)
					    GUICtrlSetData($TempLabel2,'')
EndFunc
Func Menu()
						If FileExists(@ScriptDir&'\Menu\*.*') Then
							If FileExists(@ScriptDir&'\Menu\fb.cfg') Then
								$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' add-menu fb.cfg "'&@ScriptDir&'\Menu\fb.cfg"', "", @SW_HIDE,15)
								ProcessWaitClose($Run)
								If StringInStr(StdoutRead($Run),'error:') And $FbaFile='' Then $WriteError='UD区fbinst菜单文件导入失败！'
								Dim $grldrmenu=''
								For $i= 1 To _FileCountLines(@ScriptDir&'\Menu\fb.cfg')
									If StringInStr(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),'menu ') And StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[0]>3 Then
										$grldrmenu=$grldrmenu+1
										Dim $Split=StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[0]
									    $Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' add '&StringReplace(StringReplace(StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[$Split],'"',''),"'","")&' "'&@ScriptDir&'\Menu\'&StringReplace(StringReplace(StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[$Split],'"',''),"'","")&'"', "", @SW_HIDE,15)
									    ProcessWaitClose($Run)
										If StringInStr(StdoutRead($Run),'error:') And $FbaFile='' Then $WriteError='UD区grldr菜单文件导入失败！'
										
										
									EndIf
								Next
							EndIf
							If FileExists(@ScriptDir&'\Menu\grldr') And StringInStr(FileRead(@ScriptDir&'\Menu\fb.cfg'),'grldr')='' Then
								RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' add grldr "'&@ScriptDir&'\Menu\grldr"', "", @SW_HIDE)
							EndIf						
						EndIf
						RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' filelist>%temp%\WinpeInToDisk\UDFilelist.log', '', @SW_HIDE)
						If _FileCountLines($temp&'\WinpeInToDisk\UDFilelist.log')<>$grldrmenu+1 Then  $WriteError='UD区菜单文件导入失败'
					
EndFunc
# 分析winpe文件
Func GetWinpeFile()
	Global $UefiIsoFile='',$ALLUefi86IsoFile='',$FbaFile='',$EfiSize='',$UDSize='',$AllIsoFile='',$AllFbaFile='',$AllUefiIsoFile='',$UltraIsoFile=''
	Dim $uefi_x,$uefi_xx,$uefi_xxx='',$uefi_xxxx='',$uefi_xxxxx='',$OtherIso=''
	RunWait(@ComSpec &' /c attrib -r -a -s -h "'&@ScriptDir&'\*.fba" /s','',@SW_HIDE)
	Dim $FileList=_FileListToArrayRec ( @ScriptDir, "*.iso;*.fba|Exclude_Folders" , 1, -3 )
	If @error Then
	Else
		For $i=1 To $FileList[0]
			
			If StringRight($FileList[$i],4)=".iso" Then 
					If StringInStr($FileList[$i],"efi") And StringInStr($FileList[$i],"8") Then 
					    $uefi_x=$uefi_x&@ScriptDir&'\'&$FileList[$i]&'|'
					Else
						If StringInStr($FileList[$i],"efi") And StringInStr($FileList[$i],"7") Then 
						    $uefi_xx=$uefi_xx&@ScriptDir&'\'&$FileList[$i]&'|'
						Else
							If StringInStr($FileList[$i],"64") And StringInStr($FileList[$i],"8") Then 
							    $uefi_xxx=$uefi_xxx&@ScriptDir&'\'&$FileList[$i]&'|'
							Else
								If StringInStr($FileList[$i],"64") And StringInStr($FileList[$i],"7") Then 
								    $uefi_xxxx=$uefi_xxxx&@ScriptDir&'\'&$FileList[$i]&'|'
								Else
									If StringInStr($FileList[$i],"64") Then 
									    $uefi_xxxxx=$uefi_xxxxx&@ScriptDir&'\'&$FileList[$i]&'|'
									Else
										$OtherIso=$OtherIso&@ScriptDir&'\'&$FileList[$i]&'|'
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
			EndIf
			If StringRight($FileList[$i],4)=".fba" Then
				    $Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe "'&StringReplace(@ScriptDir&'\'&$FileList[$i],'\\','\')&'" filelist','',@SW_HIDE,15)
					If ProcessWaitClose($Run) And StringInStr(StdoutRead($Run),'error:')='' Then $AllFbaFile=$AllFbaFile&@ScriptDir&'\'&$FileList[$i]&'|'
			EndIf
		Next
	EndIf
	$AllIsoFile=$uefi_x&$uefi_xx&$uefi_xxx&$uefi_xxxx&$uefi_xxxxx&$OtherIso
	If $AllIsoFile Then $AllIsoFile=StringReplace($AllIsoFile,'\\','\')
	If $AllFbaFile Then $AllFbaFile=StringReplace($AllFbaFile,'\\','\')
	If $AllFbaFile Then $FbaFile=StringMid($AllFbaFile,1,StringInStr($AllFbaFile,'|','',1)-1)
	If $AllIsoFile Then
		RunWait(@ComSpec&' /c del /q %temp%\WinpeInToDisk\*iso*.log','',@SW_HIDE)
		If StringRight($AllIsoFile,1)='|' Then $AllIsoFile=StringTrimRight($AllIsoFile,1)
		Dim $SplitAllIsoFile=StringSplit($AllIsoFile,'|')
		FileWrite($temp&'\WinpeInToDisk\allisofile.log',StringReplace($AllIsoFile,'|',@CRLF))
		Dim $Isolist=''
		
		For $i = 1 To $SplitAllIsoFile[0]
			If $SplitAllIsoFile[$i] And FileExists($SplitAllIsoFile[$i]) Then 
				
				RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\7z938.exe l "'&$SplitAllIsoFile[$i]&'"|find /i /v "D.."|find /i /v "[BOOT]"|find /i "..">%temp%\WinpeInToDisk\'&StringMid($SplitAllIsoFile[$i],StringInStr($SplitAllIsoFile[$i],'\','',-1)+1)&'.log', '', @SW_HIDE,15)
				$Isolist=FileRead($temp&'\WinpeInToDisk\'&StringMid($SplitAllIsoFile[$i],StringInStr($SplitAllIsoFile[$i],'\','',-1)+1)&'.log')
				If StringRegExp($Isolist,'(?i)I386.winnt32.exe') Or StringRegExp($Isolist,'(?i)sources.setup.exe') Then
				Else
					If StringRegExp($Isolist,'(?i)EFI\\BOOT\\BOOTX64\.EFI') And StringRegExp($Isolist,'(?i)\.wim') Then $AllUefiIsoFile=$AllUefiIsoFile&$SplitAllIsoFile[$i]&'|'
					If StringRegExp($Isolist,'(?i)EFI\\BOOT\\bootia32\.efi') And StringRegExp($Isolist,'(?i)\.wim') Then $ALLUefi86IsoFile=$ALLUefi86IsoFile&$SplitAllIsoFile[$i]&'|'
				EndIf
			EndIf
	    Next
		RunWait(@ComSpec&' /c del /q %temp%\WinpeInToDisk\*.log','',@SW_HIDE)
	EndIf
	$AllUefiIsoFile=$AllUefiIsoFile&$ALLUefi86IsoFile
	If $AllUefiIsoFile Then $UefiIsoFile=StringMid($AllUefiIsoFile,1,StringInStr($AllUefiIsoFile,'|','',1)-1)
	If $AllIsoFile Then $UltraIsoFile=StringMid($AllIsoFile,1,StringInStr($AllIsoFile,'|','',1)-1)
	
EndFunc
Func GetFileSize($_GetUDSize,$_GetUefiSize)
	If $_GetUDSize=1 Then
		Dim $_UD=''
		Global $UDSize='',$NoCreateUD=''
		If FileExists(@ScriptDir&'\Menu\fb.cfg') Then
			For $i = 1 To _FileCountLines(@ScriptDir&'\Menu\fb.cfg')
				If StringInStr(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),'menu ') And StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[0]>3 Then
					Dim $Split=StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[0]
					If FileExists(@ScriptDir&'\Menu\'&StringReplace(StringReplace(StringSplit(FileReadLine(@ScriptDir&'\Menu\fb.cfg',$i),' ')[$Split],'"',''),"'",""))='' Then $NoCreateUD=1
				EndIf
			Next
		EndIf
		If FileExists(@ScriptDir&'\Menu\fb.cfg')='' Then $NoCreateUD=1
		If $FbaFile Or $NoCreateUD='' Then
	    	If DirGetSize(@ScriptDir&'\UD')>0 Then $_UD=DirGetSize(@ScriptDir&'\UD') 
		EndIf
		$UDSize=Ceiling($_UD/1048576+FileGetSize($FbaFile)/1048576)
		If FileExists(@ScriptDir&'\Menu\fb.cfg') And $NoCreateUD='' And $UDSize='' Then $UDSize=1
	EndIf
	
	If $_GetUefiSize=1 Then
		Dim $_EFI=''
		$EfiSize=''
		
	    If $UefiIsoFile Or FileExists(@ScriptDir&'\EFI\EFI\BOOT\*.EFI') Then
			If DirGetSize(@ScriptDir&'\EFI')>0 Then $_EFI=DirGetSize(@ScriptDir&'\EFI')
		EndIf
		
	    If $UefiIsoFile Then
		    RunWait(@ComSpec&' /c "%temp%\WinpeInToDisk\7z938.exe l -r "'&$UefiIsoFile&'"|find /i /v "."|find /i " files" >%temp%\WinpeInToDisk\ubsizex.log"', "", @SW_HIDE)
		    FileDelete($temp&'\WinpeInToDisk\ubsize.log')
		    If StringInStr(FileReadLine($temp&'\WinpeInToDisk\ubsizex.log',1),'-','',2) And StringInStr(FileReadLine($temp&'\WinpeInToDisk\ubsizex.log',1),':','',2) Then RunWait(@ComSpec & ' /c for /f "tokens=1-9 delims= " %a in (%temp%\WinpeInToDisk\ubsizex.log) do echo %c>>%temp%\WinpeInToDisk\ubsize.log', "", @SW_HIDE)
		    If StringInStr(FileReadLine($temp&'\WinpeInToDisk\ubsizex.log',1),'-','',2)='' And StringInStr(FileReadLine($temp&'\WinpeInToDisk\ubsizex.log',1),':','',2)='' Then RunWait(@ComSpec & ' /c for /f "tokens=1-9 delims= " %a in (%temp%\WinpeInToDisk\ubsizex.log) do echo %a>>%temp%\WinpeInToDisk\ubsize.log', "", @SW_HIDE)
		    If StringInStr(FileReadLine($temp&'\WinpeInToDisk\ubsizex.log',1),'-','',2) And StringInStr(FileReadLine($temp&'\WinpeInToDisk\ubsizex.log',1),':','',2)='' Then
			    RunWait(@ComSpec & ' /c for /f "tokens=1-9 delims= " %a in (%temp%\WinpeInToDisk\ubsizex.log) do echo %b>>%temp%\WinpeInToDisk\ubsize.log', "", @SW_HIDE)
		    Else
			    If StringInStr(FileReadLine($temp&'\WinpeInToDisk\ubsizex.log',1),'-','',2)='' And StringInStr(FileReadLine($temp&'\WinpeInToDisk\ubsizex.log',1),':','',2) Then RunWait(@ComSpec & ' /c for /f "tokens=1-9 delims= " %a in (%temp%\WinpeInToDisk\ubsizex.log) do echo %b>>%temp%\WinpeInToDisk\ubsize.log', "", @SW_HIDE)
		    EndIf
	    EndIf
	    If Ceiling(FileReadLine($temp&'\WinpeInToDisk\ubsize.log',1)/1048576) Then $EfiSize=Ceiling(FileReadLine($temp&'\WinpeInToDisk\ubsize.log',1)/1048576+$_EFI/1048576)
	    If Ceiling(FileReadLine($temp&'\WinpeInToDisk\ubsize.log',1)/1048576)='' Then $EfiSize=Ceiling((FileGetSize($UefiIsoFile)/1048576)*1.02+$_EFI/1048576)
	EndIf
EndFunc
Func LookupFba()
	
	Dim $Var = FileOpenDialog("查找Fba文件","::{FF393560-C2A7-11CF-BFF4-444553540000}","Fba文件(*.Fba)",3 ,"",$GUI)
	If @error Then
	Else
		$Var = StringReplace($Var,"|",@CRLF)
		FileSetAttrib($Var,'-A-R-S-H')
		$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe "'&$Var&'" filelist','',@SW_HIDE,15)
		
		If ProcessWaitClose($Run) And StringInStr(StdoutRead($Run),'error:')='' Then 
			If StringInStr($AllFbaFile,$Var)='' Then $AllFbaFile=StringReplace($AllFbaFile&'|'&$Var,"||","|")
			GUICtrlSetData($UDFileCombo,'')
			GUICtrlSetData($UDFileCombo,$AllFbaFile,$Var)
			GUICtrlSetTip($UDFileCombo,GUICtrlRead($UDFileCombo))
			$FbaFile=GUICtrlRead($UDFileCombo)
			If $FbaFile Then GetFileSize(1,'')
			If $UDSize Then 
			    If Ceiling($UDSize*1.02)<8 Then
				    GUICtrlSetData($UDSizeInput,8)
				Else
		            GUICtrlSetData($UDSizeInput,8*Ceiling($UDSize*1.02/8)+8)
				EndIf
		    EndIf
			GUICtrlSetTip($UdFileCombo,GUICtrlRead($UdFileCombo))
			$DefaultDisk=GUICtrlRead($DeviceCombo)
			ShowWriteMode(1)
		Else
			MsgBox(4096,'友情提示','您所选择的fba文件无法识别！')
		EndIf
	EndIf
EndFunc
Func LookupAllIso()
	Dim $Var = FileOpenDialog("查找ISO镜像","::{FF393560-C2A7-11CF-BFF4-444553540000}","ISO镜像(*.Iso)",3 ,"",$GUI)
	If @error Then
	Else
		$Var = StringReplace($Var,"|",@CRLF)
		If StringInStr($AllIsoFile,$Var)='' Then $AllIsoFile=StringReplace($AllIsoFile&'|'&$Var,"||","|")
		GUICtrlSetData($UltraISOCombo,'')
		GUICtrlSetData($UltraISOCombo,$AllIsoFile,$Var)
		GUICtrlSetTip($UltraISOCombo,GUICtrlRead($UDFileCombo))
		
		
	EndIf
EndFunc
Func LookupEfiIso()
	Dim $Var = FileOpenDialog("查找UEFI镜像","::{FF393560-C2A7-11CF-BFF4-444553540000}","UEFI镜像(*.Iso)",3 ,"",$GUI)
	If @error Then
	Else
		$Var = StringReplace($Var,"|",@CRLF)
		RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\7z938.exe l "'&$Var&'"|find /i /v "D.."|find /i /v "[BOOT]"|find /i "..">%temp%\WinpeInToDisk\uefi.log', '', @SW_HIDE)
		If StringRegExp(FileRead($temp&'\WinpeInToDisk\uefi.log'),'(?i)EFI\\BOOT\\BOOTX64\.EFI') Or StringRegExp(FileRead($temp&'\WinpeInToDisk\uefi.log'),'(?i)EFI\\BOOT\\bootia32\.efi') Then 
			If StringInStr($AllUefiIsoFile,$Var)='' Then $AllUefiIsoFile=StringReplace($AllUefiIsoFile&'|'&$Var,"||","|")
			GUICtrlSetData($EfiIsoCombo,'')
			GUICtrlSetData($EfiIsoCombo,$AllUefiIsoFile,$Var)
			$UefiIsoFile=GUICtrlRead($EfiIsoCombo)
			If $UefiIsoFile Then GetFileSize('',1)
			If $EfiSize Then
			    If $EfiSize*1.02<48 Then 
				    GUICtrlSetData($EfiSizeInput,48)
				Else
			        GUICtrlSetData($EfiSizeInput,8*Ceiling($EfiSize/8)+8)
				EndIf
			EndIf
			GUICtrlSetTip($EfiIsoCombo,GUICtrlRead($EfiIsoCombo))
			$DefaultDisk=GUICtrlRead($DeviceCombo)
			ShowWriteMode(1)
		Else
			MsgBox(4096,'友情提示','您所选择的ISO镜像不支持UEFI启动！')
		EndIf
	EndIf
EndFunc
func GUI_Drop()
	If @GUI_DropId=$EfiIsoCombo And StringInStr(@GUI_DRAGFILE,'.iso') Then 
		RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\7z938.exe l "'&@GUI_DRAGFILE&'"|find /i /v "D.."|find /i /v "[BOOT]"|find /i "..">%temp%\WinpeInToDisk\uefi.log', '', @SW_HIDE)
		If StringRegExp(FileRead($temp&'\WinpeInToDisk\uefi.log'),'(?i)EFI\\BOOT\\BOOTX64\.EFI') Or StringRegExp(FileRead($temp&'\WinpeInToDisk\uefi.log'),'(?i)EFI\\BOOT\\bootia32\.efi') Then 
			If StringInStr($AllUefiIsoFile,@GUI_DRAGFILE)='' Then $AllUefiIsoFile=StringReplace($AllUefiIsoFile&'|'&@GUI_DRAGFILE,"||","|")
			GUICtrlSetData($EfiIsoCombo,'')
			GUICtrlSetData($EfiIsoCombo,$AllUefiIsoFile,@GUI_DragFile)
			$UefiIsoFile=GUICtrlRead($EfiIsoCombo)
			If $UefiIsoFile Then GetFileSize('',1)
			If $EfiSize Then
			    If $EfiSize*1.02<48 Then 
				    GUICtrlSetData($EfiSizeInput,48)
				Else
			        GUICtrlSetData($EfiSizeInput,8*Ceiling($EfiSize/8)+8)
				EndIf
			EndIf
			GUICtrlSetTip($EfiIsoCombo,GUICtrlRead($EfiIsoCombo))
			$DefaultDisk=GUICtrlRead($DeviceCombo)
			ShowWriteMode(1)
		Else
			MsgBox(4096,'友情提示','您托人的ISO镜像不支持UEFI启动！')
		EndIf
	EndIf
	
	If @GUI_DropId=$UltraISOCombo And StringInStr(@GUI_DRAGFILE,'.iso') Then 
			If StringInStr($AllIsoFile,@GUI_DRAGFILE)='' Then $AllIsoFile=StringReplace($AllIsoFile&'|'&@GUI_DRAGFILE,"||","|")
			GUICtrlSetData($UltraISOCombo,'')
			GUICtrlSetData($UltraISOCombo,$AllIsoFile,@GUI_DragFile)
			GUICtrlSetTip($UltraISOCombo,GUICtrlRead($UltraISOCombo))
			
			
	EndIf
	
	If @GUI_DropId=$UDFileCombo And StringInStr(@GUI_DRAGFILE,'.fba') Then 
		FileSetAttrib(@GUI_DRAGFILE,'-A-S-R-H')
		$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe "'&@GUI_DRAGFILE&'" filelist','',@SW_HIDE,15)
		
		If ProcessWaitClose($Run) And StringInStr(StdoutRead($Run),'error:')='' Then 
			If StringInStr($AllFbaFile,@GUI_DRAGFILE)='' Then $AllFbaFile=StringReplace($AllFbaFile&'|'&@GUI_DRAGFILE,"||","|")
			GUICtrlSetData($UDFileCombo,'')
			GUICtrlSetData($UDFileCombo,$AllFbaFile,@GUI_DragFile)
			$FbaFile=GUICtrlRead($UDFileCombo)
			If $FbaFile Then GetFileSize(1,'')
			If $UDSize Then 
			    If Ceiling($UDSize*1.02)<8 Then
				    GUICtrlSetData($UDSizeInput,8)
				Else
		            GUICtrlSetData($UDSizeInput,8*Ceiling($UDSize*1.02/8)+8)
				EndIf
		    EndIf
			GUICtrlSetTip($UdFileCombo,GUICtrlRead($UdFileCombo))
			$DefaultDisk=GUICtrlRead($DeviceCombo)
			ShowWriteMode(1)
		Else
			MsgBox(4096,'友情提示','您所选择的fba文件无法识别！')
		EndIf
	EndIf
	If StringInStr(@GUI_DRAGFILE,'.fba')='' And StringInStr(@GUI_DRAGFILE,'.iso')='' Then MsgBox(4096,'友情提示','您托人的文件不受支持！')
	
EndFunc
	
Func FmtForce()
                    GUICtrlSetState($Button_Format,$GUI_DISABLE)
				    GUICtrlSetState($Button_Write,$GUI_DISABLE)
				    WinSetState ($GUI1, "", @SW_DISABLE )
				    WinSetState ($GUI2, "", @SW_DISABLE )
				    
					
					$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' format --force --raw --fat32 --align', "", @SW_HIDE)
					$Time=TimerInit()
					RunWhile(60,'','还原磁盘空间...')
					GetUsbDisk()
					ShowWriteMode(1)
					GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
					MsgBox(4096,'友情提示','操作完成！',3)
					WinSetState ($GUI1, "", @SW_ENABLE )
					WinSetState ($GUI2, "", @SW_ENABLE )
					GUICtrlSetState($Button_Format,$GUI_ENABLE)
					GUICtrlSetState($Button_Write,$GUI_ENABLE)
					GUICtrlSetPos($TempLabel3,Default,Default,2,Default)
					GUICtrlSetState($TempLabel3,$GUI_HIDE)
					GUICtrlSetState($TempLabel4,$GUI_HIDE)
					GUICtrlSetData($TempLabel2,'')
EndFunc
Func RunWhile($SEC,$AllItem,$Word) 
	ProcessWait($Run)
	If $Command='FmtForce' Or $Command='IsoMode' Then GUICtrlSetData($TempLabel2,' '&$Word)
	If $Command<>'FmtForce' And $Command<>'IsoMode' Then 
		If StringInStr($Word,'UD目录') Then GUICtrlSetData($TempLabel2,' '&$AllItem&'/'&$AllItem&':  '&$Word)
		If StringInStr($Word,'UD目录')='' Then  GUICtrlSetData($TempLabel2,' '&StringMid(GUICtrlRead($TempLabel2),1,StringInStr(GUICtrlRead($TempLabel2),'/')-1)+1&'/'&$AllItem&':  '&$Word)
	EndIf
	GUICtrlSetState($TempLabel3,$GUI_SHOW)	
	GUICtrlSetState($TempLabel4,$GUI_SHOW)
	Dim $CtrlWidthS=$Progress/$SEC 
	If $CtrlWidthS<1 Then $CtrlWidthS=1
	
	If ControlGetPos($GUIProgress, "",$TempLabel3)[2]>=$Progress Then GUICtrlSetPos($TempLabel3,Default,Default,1,Default)
	While 1
		Sleep(1)
		If ProcessExists($Run)='' Then ExitLoop
		If TimerDiff($Time)/1000>=3 Then 
			If ControlGetPos($GUIProgress, "",$TempLabel3)[2]>=$Progress Then 
				GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
				Sleep(10)
				GUICtrlSetPos($TempLabel3,Default,Default,1,Default)
			EndIf
			If ControlGetPos($GUIProgress, "",$TempLabel3)[2]<$Progress Then GUICtrlSetPos($TempLabel3,Default,Default,ControlGetPos($GUIProgress, "",$TempLabel3)[2]+TimerDiff($Time)/1000*$CtrlWidthS,Default)
			$Time=TimerInit()
			If $Time='' Then $Time=TimerInit()
		EndIf
		If ProcessExists($Run)='' Then ExitLoop
	WEnd
EndFunc
	
Func _Exit()
	ProcessClose('UltraISO9653237.exe')
	GUIDelete($GUI)
	Exit Run(@ComSpec&' /c rd /s /q %temp%\WinpeInToDisk&rd /s /q %temp%\UDdir','',@SW_HIDE)
EndFunc
# 检测USB设备==============================================================================================================================
Func My_Message_Test($hWnd, $Msg, $wParam, $lParam)
	Switch $wParam
		Case $DBT_DEVICEARRIVAL  
			GetUsbDisk()
			If StringReplace($UsbDiskExist,'|','')='' Then GetUsbDisk()
			For $i= 1 To StringSplit($UsbDiskExist,'|')[0]
				If StringSplit($UsbDiskExist,'|')[$i] And StringInStr(StringSplit($UsbDiskExist,'|')[$i],StringLeft($DefaultDisk,5)) Then $DefaultDisk=StringSplit($UsbDiskExist,'|')[$i]
			Next
			GUICtrlSetData($DeviceCombo,'')
			GUICtrlSetData($DeviceCombo,$UsbDiskExist,$DefaultDisk)
			If GUICtrlRead($DeviceCombo)='' Then
				If $UsbDiskExist Then
					GUICtrlSetData($DeviceCombo,'')
					GUICtrlSetData($DeviceCombo,$UsbDiskExist,$SplitUsbDisk[1])
				EndIf
			EndIf
			If $command='' Then GUICtrlSetState($Button_Format,$GUI_ENABLE)
			If $command='' Then GUICtrlSetState($Button_Write,$GUI_ENABLE)
			GUICtrlSetTip($DeviceCombo,GUICtrlRead($DeviceCombo))
			$DefaultDisk=GUICtrlRead($DeviceCombo)
			If $command='' Then ShowWriteMode(1)
		Case $DBT_DEVICEREMOVECOMPLETE  
			GetUsbDisk()
			If StringReplace($UsbDiskExist,'|','')='' Then GetUsbDisk()
			For $i= 1 To StringSplit($UsbDiskExist,'|')[0]
				If StringSplit($UsbDiskExist,'|')[$i] And StringInStr(StringSplit($UsbDiskExist,'|')[$i],StringLeft($DefaultDisk,5)) Then $DefaultDisk=StringSplit($UsbDiskExist,'|')[$i]
			Next
			GUICtrlSetData($DeviceCombo,'')
			GUICtrlSetData($DeviceCombo,$UsbDiskExist,$DefaultDisk)
			If GUICtrlRead($DeviceCombo)='' Then
				If $UsbDiskExist Then
					GUICtrlSetData($DeviceCombo,'')
					GUICtrlSetData($DeviceCombo,$UsbDiskExist,$SplitUsbDisk[1])
				EndIf
			EndIf
			If StringReplace($UsbDiskExist,'|','')='' Then
				GUICtrlSetState($Button_Format,$GUI_DISABLE)
				GUICtrlSetState($Button_Write,$GUI_DISABLE)
			EndIf
			GUICtrlSetTip($DeviceCombo,GUICtrlRead($DeviceCombo))
			$DefaultDisk=GUICtrlRead($DeviceCombo)
			If $command='' Then ShowWriteMode(1)
	EndSwitch
EndFunc   
# 检测USB设备==============================================================================================================================
Func ShowWriteMode($SetDataWriteModeCombo2)
	        GUICtrlSetState($Button_Write,$GUI_DISABLE)
			If GUICtrlRead($WriteModeCombo1)='ISO模式' Then
				GUICtrlSetState($WriteModeCombo2,$GUI_HIDE)
				GUICtrlSetState($HideModeCombo,$GUI_SHOW)
			Else
				GUICtrlSetState($HideModeCombo,$GUI_HIDE)
				GUICtrlSetState($WriteModeCombo2,$GUI_SHOW)
			EndIf
			GetUsbPart($DefaultDisk)
			Global $BianJie='',$WuSun=''
			If GUICtrlRead($WriteModeCombo1)='UD二分区' And Ceiling($UDSize*1.01)+10<$UnknownPartSize Then $BianJie=1
			If GUICtrlRead($WriteModeCombo1)='UD三分区' And Ceiling($UDSize*1.01)+10<$UnknownPartSize And 8*Ceiling($EfiSize/8)+2<$EfiPartSize Then $BianJie=1
			
			Dim $DefaultDiskDirGetSize=''
			Dim $FileList=_FileListToArrayRec (StringMid($DefaultDisk,7,2), "*|Exclude_Folders" , 1, -5 )
			If @error Then
			Else
				For $i=1 To $FileList[0]
					
					If $FileList[$i] And StringInStr($FileList[$i],'IndexerVolumeGuid')='' Then 
					    $DefaultDiskDirGetSize=1
						$i=$FileList[0]+1
						ExitLoop
					EndIf
				Next
			EndIf
			If $DefaultDiskDirGetSize Then 
				Dim $FileSystem=DriveGetFileSystem(StringMid($DefaultDisk,7,2))
				If $FileSystem='NTFS' Or $FileSystem='FAT16' Or $FileSystem='FAT32' Then $WuSun=1
			EndIf
			
			If $SetDataWriteModeCombo2=1 Then
				GUICtrlSetData($WriteModeCombo2,'')
				If $BianJie Then
					GUICtrlSetData($WriteModeCombo2,'全新写入|无损写入|便捷写入','便捷写入')
				Else
					If $DefaultDiskDirGetSize Then 
						Dim $FileSystem=DriveGetFileSystem(StringMid($DefaultDisk,7,2))
						If $FileSystem='NTFS' Or $FileSystem='FAT16' Or $FileSystem='FAT32' Then
							GUICtrlSetData($WriteModeCombo2,'全新写入|无损写入|便捷写入','无损写入')
						Else
							GUICtrlSetData($WriteModeCombo2,'全新写入|无损写入|便捷写入','全新写入')
						EndIf
					Else
						GUICtrlSetData($WriteModeCombo2,'全新写入|无损写入|便捷写入','全新写入')
					EndIf
				EndIf
			EndIf
			
			If StringInStr(FileRead($temp&'\WinpeInToDisk\usbpart.log'),'未分配空间','',2) Or StringInStr(FileRead($temp&'\WinpeInToDisk\usbpart.log'),'*:','',2) Or _FileCountLines($temp&'\WinpeInToDisk\usbpart.log')>3 Then
				Global $BianJie='',$WuSun=''
				If $SetDataWriteModeCombo2=1 Then
				    GUICtrlSetData($WriteModeCombo2,'')
				    GUICtrlSetData($WriteModeCombo2,'全新写入|无损写入|便捷写入','全新制作')
				EndIf
			EndIf
			If StringInStr($DefaultDisk,':','',2) Then
				Global $BianJie='',$WuSun=''
				If $SetDataWriteModeCombo2=1 Then
				    GUICtrlSetData($WriteModeCombo2,'')
				    GUICtrlSetData($WriteModeCombo2,'全新写入|无损写入|便捷写入','全新制作')
				EndIf
			EndIf
			If GUICtrlRead($WriteModeCombo2)='' Then 
				GUICtrlSetData($WriteModeCombo2,'')
				GUICtrlSetData($WriteModeCombo2,'全新写入|无损写入|便捷写入','全新制作')
			EndIf
			
			$DefaultDiskDirGetSize=DirGetSize(StringMid($DefaultDisk,7,2)) 
			
			$Stop=''
			If StringInStr($DefaultDisk,StringMid(@ScriptDir,1,2)) Then $Stop='程序不能运行在所选择的可移动磁盘中！'&@CR
			If $ReadWriteModeCombo1='ISO模式' Then
				If FileGetSize($ReadUltraISOCombo)/1048576>4080 Then $Stop=$Stop&'Iso镜像文件太大，建议小于4080MB!'&@CR
				If FileGetSize($ReadUltraISOCombo)/1048576+96>=$UsbDrvSize Then $Stop=$Stop&'可移动磁盘预留空间不足，推荐预留96MB以上!'&@CR
			Else
			    If $ReadEfiSizeInput+$ReadUDSizeInput+8+96>$UsbDrvSize Then $Stop=$Stop&'可见区预留空间不足，推荐预留96MB以上！'&@CR
				If $ReadEfiSizeInput+$ReadUDSizeInput+8+Ceiling($DefaultDiskDirGetSize/1048576)>=$UsbDrvSize Then $Stop=$Stop&'可移动磁盘空间不足！'&@CR
				If $ReadUDSizeInput<$UDSize+1 Then $Stop=$Stop&'UD扩展区给定的太小，推荐大小'&$UDSize*1.02&'MB以上！'&@CR
			    If StringIsDigit($ReadUDSizeInput)<>1 Then $Stop=$Stop&'UD区给定的大小无效！'&@CR
				If GUICtrlRead($WriteModeCombo1)='UD三分区' Then
					If $ReadEfiSizeInput<$EfiSize+1 Or $ReadEfiSizeInput<24 Or $ReadEfiSizeInput>4088 Then $Stop=$Stop&'EFI区给定大小范围应在24MB-4080MB之间,推荐最小48MB以上！'&@CR
					If StringIsDigit($ReadEfiSizeInput)<>1 Then $Stop=$Stop&'EFI区给定的大小无效！'&@CR
				EndIf
			EndIf
			If $DefaultDisk Then GUICtrlSetState($Button_Write,$GUI_ENABLE)
EndFunc
		
Func DISABLE()
	GUICtrlSetState($Button_Format,$GUI_DISABLE)
	GUICtrlSetState($Button_Write,$GUI_DISABLE)
	WinSetState ($GUI1, "", @SW_DISABLE )
	WinSetState ($GUI2, "", @SW_DISABLE )
EndFunc
Func ENABLE()
    WinSetState ($GUI1, "", @SW_ENABLE )
	WinSetState ($GUI2, "", @SW_ENABLE )
	GUICtrlSetState($Button_Format,$GUI_ENABLE)
	GUICtrlSetState($Button_Write,$GUI_ENABLE)
EndFunc
Func WriteEfi()
							Dim $_EfiPartID
							If $command<>'BianJieMode' Then $_EfiPartID=1
							If $command='BianJieMode' Then $_EfiPartID=$EfiPartID
							If $UefiIsoFile Then
								$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\7z938.exe x "'&$UefiIsoFile&'" -o%temp%\WinpeInToDisk\EFI -aos -y', "", @SW_HIDE,15)
								$Time=TimerInit()
								RunWhile(Int(FileGetSize($UefiIsoFile)/1048576)/2, $AllItem, '解压EFI镜像...')
								GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
								If TimerDiff($Time)/1000<1 Then Sleep(500)
								If StringInStr(StdoutRead($Run),'error:') Then $WriteError='EFI镜像损坏或磁盘空间不足！'
								RunWait(@ComSpec&' /c RD /S /Q "'&$temp&'\WinpeInToDisk\EFI\[BOOT]"', "", @SW_HIDE)
								If $WriteError='' Then
									$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /whide:'&$_EfiPartID&' /src:%temp%\WinpeInToDisk\EFI /out:%temp%\WinpeInToDisk\PartAssistWrite.log', "", @SW_HIDE)
									$Time=TimerInit()
									RunWhile(Int(FileGetSize($UefiIsoFile)/1048576)/2, $AllItem, 'EFI镜像写入EFI区...')
									GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
									If StringInStr(FileRead($temp&'\WinpeInToDisk\PartAssistWrite.log'),'文件已经复制完成')='' Then $WriteError='EFI镜像写入EFI区失败！'
								EndIf
							EndIf
							Dim $_EFI=''
						    If DirGetSize(@ScriptDir&'\EFI')>0 Then $_EFI=DirGetSize(@ScriptDir&'\EFI')
							If $_EFI>0 And $WriteError='' Then
								$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\PartAssist.exe /hd:'&StringMid($DefaultDisk,4,1)&' /whide:'&$_EfiPartID&' /src:'&@ScriptDir&'\EFI /out:%temp%\WinpeInToDisk\PartAssistWrite.log', "", @SW_HIDE)
								$Time=TimerInit()
								RunWhile(Int(DirGetSize(@ScriptDir&'\EFI')/1048576)/2, $AllItem, 'EFI目录内文件写入EFI区...')
								GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
								If StringInStr(FileRead($temp&'\WinpeInToDisk\PartAssistWrite.log'),'文件已经复制完成')='' Then $WriteError='EFI目录内文件写入EFI区失败！'
							EndIf
EndFunc
Func WriteUd()
								Dim $_UD=''
								If DirGetSize(@ScriptDir&'\UD')>0 Then $_UD=DirGetSize(@ScriptDir&'\UD')
								If $FbaFile Then
							    	$Run=Run(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' load "'&$FbaFile&'"', "", @SW_HIDE,15)
							    	$Time=TimerInit()
							    	RunWhile(Int(FileGetSize($FbaFile)/1048576/2), $AllItem, 'Fba文件写入UD区...')
									If StringInStr(StdoutRead($Run),'error:') Then $WriteError='Fba文件写入UD区失败！'
									RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' filelist>%temp%\WinpeInToDisk\UDFilelist.log', '', @SW_HIDE)
								    RunWait(@ComSpec&' /c %temp%\WinpeInToDisk\fbinst.exe "'&$FbaFile&'" filelist>%temp%\WinpeInToDisk\FbaFilelist.log', '', @SW_HIDE)
								    If _FileCountLines($temp&'\WinpeInToDisk\UDFilelist.log')<>_FileCountLines($temp&'\WinpeInToDisk\FbaFilelist.log') Then $WriteError='Fba文件写入UD区失败！'
									GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
								EndIf
								If $_UD>0 And $WriteError='' Then 
									RunWait(@ComSpec&' /c dir /s /b /a-d "'&@ScriptDir&'\UD">%temp%\WinpeInToDisk\ud1.log','' ,@SW_HIDE)
									Dim $Replace=StringReplace(StringReplace(StringReplace(FileRead($temp&'\WinpeInToDisk\ud1.log'),@ScriptDir&'\UD',''),'\','/'),'//','/')
									If StringInStr($Replace,':') Then $Replace=StringReplace($Replace,StringLeft(FileReadLine($temp&'\WinpeInToDisk\ud1.log',1),2),'')
									FileWrite($temp&'\WinpeInToDisk\ud2.log',$Replace)
									$Time=TimerInit()
									For $i=1 To _FileCountLines($temp&'\WinpeInToDisk\ud1.log') Step 1
										
										If FileGetSize(FileReadLine($temp&'\WinpeInToDisk\ud1.log',$i)) And $WriteError='' Then
										    $Run=Run(@ComSpec&' /c "%temp%\WinpeInToDisk\fbinst.exe '&StringLeft($DefaultDisk,5)&' add --extended "'&FileReadLine($temp&'\WinpeInToDisk\ud2.log',$i)&'" "'&FileReadLine($temp&'\WinpeInToDisk\ud1.log',$i)&'""', "", @SW_HIDE,15)
				    					    RunWhile(Int($_UD/1048576/2), $AllItem, 'UD目录内文件写入UD区...')
								    	    If StringInStr(StdoutRead($Run),'error:') Then $WriteError='UD目录内文件写入UD区失败！'&@CR&FileReadLine($temp&'\WinpeInToDisk\ud1.log',$i)
										EndIf
									Next
									GUICtrlSetPos($TempLabel3,Default,Default,$Progress,Default)
								EndIf
								
EndFunc
