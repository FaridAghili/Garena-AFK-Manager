#NoTrayIcon
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include 'Header.au3'

;---------------------------------------------------------------------------
;
#pragma compile(AutoItExecuteAllowed, true)
#pragma compile(Out, Release\AFK Manager.exe)
#pragma compile(Icon, Resources\Icon.ico)
#pragma compile(CompanyName, www.AFK-Manager.ir)
#pragma compile(FileDescription, AFK Manager)
#pragma compile(FileVersion, 6.5.0.0)
#pragma compile(InternalName, AFK Manager)
#pragma compile(LegalCopyright, Copyright © 2016 AFK-Manager.ir. All rights reserved.)
#pragma compile(OriginalFilename, AFK Manager.exe)
#pragma compile(ProductName, AFK Manager)
#pragma compile(ProductVersion, 6.5.0.0)

#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/pe /sf=1 /sv=1 /rm /rsln

#AutoIt3Wrapper_Res_File_Add=Resources\CLIENT_MANAGER_PNG.png, RT_RCDATA, CLIENT_MANAGER_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\CLOSE_2_PNG.png, RT_RCDATA, CLOSE_2_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\CLOSE_ALL_CLIENTS_PNG.png, RT_RCDATA, CLOSE_ALL_CLIENTS_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\CLOSE_PNG.png, RT_RCDATA, CLOSE_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\ICON_PNG.png, RT_RCDATA, ICON_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\GARENA_MESSENGER_PNG.png, RT_RCDATA, GARENA_MESSENGER_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\LOGO_PNG.png, RT_RCDATA, LOGO_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\MINIMIZE_PNG.png, RT_RCDATA, MINIMIZE_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\MINIMIZE_TO_TRAY_PNG.png, RT_RCDATA, MINIMIZE_TO_TRAY_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\NEW_ACCOUNT_PNG.png, RT_RCDATA, NEW_ACCOUNT_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\ROOM_AUTO_AFK_PNG.png, RT_RCDATA, ROOM_AUTO_AFK_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\SPAMBOT_PNG.png, RT_RCDATA, SPAMBOT_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\TALK_AUTO_AFK_PNG.png, RT_RCDATA, TALK_AUTO_AFK_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\TOOLBAR_SEPARATOR_PNG.png, RT_RCDATA, TOOLBAR_SEPARATOR_PNG
#AutoIt3Wrapper_Res_File_Add=Resources\TOOLBAR_STRIP_PNG.png, RT_RCDATA, TOOLBAR_STRIP_PNG

#AutoIt3Wrapper_Res_Remove=RT_ICON, 1, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 7, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 8, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 9, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 10, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 11, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 12, 2057
#AutoIt3Wrapper_Res_Remove=RT_STRING, 313, 2057
#AutoIt3Wrapper_Res_Remove=RT_GROUPICON, 169, 2057

#AutoIt3Wrapper_Run_After=Resources\Other\SignTheFile.au3
;
;---------------------------------------------------------------------------

Func EntryPoint()
	;---------------------------------------------------------------------------
	;
	$hMutex = _WinAPI_CreateMutex($APP_NAME & ': Running')

	If _WinAPI_GetLastError() = $ERROR_ALREADY_EXISTS Then
		_WinAPI_CloseHandle($hMutex)
		Exit
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sGarenaPlusPath = GarenaPlusPath()
	If $sGarenaPlusPath Then
		; --- Nothing to do
	Else
		MsgBox(BitOR($MB_OK, $MB_ICONERROR), $APP_NAME, 'Unable to find Garena Plus path.' & @CRLF & 'Please download and install Garena Plus.')
		Return SetError(1, 0, 'GarenaPlusPath()')
	EndIf

	Local $sSqlite3Dll = $sGarenaPlusPath & '\sqlite3.dll'
	If FileExists($sSqlite3Dll) Then
		; --- Nothing to do
	Else
		Return SetError(2, 0, 'FileExists()')
	EndIf

	Local $sDatabaseDirectory = @LocalAppDataDir & '\' & $APP_NAME
	If FileExists($sDatabaseDirectory) Then
		; --- Nothing to do
	Else
		If DirCreate($sDatabaseDirectory) Then
			; --- Nothing to do
		Else
			Return SetError(3, 0, 'DirCreate()')
		EndIf
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	OnAutoItExitRegister(ExitPoint)

	TCPStartup()
	If @error Then
		Return SetError(4, 0, 'TCPStartup()')
	EndIf

	If  StringInStr(TCPNameToIP('www.afk-manager.ir'), '127.0.') Then
		TCPShutdown()
		Return SetError(5, 0, 'TCPNameToIP()')
	EndIf

	_SQLite_Startup($sSqlite3Dll, False, 1)
	If @error Then
		Return SetError(6, 0, '_SQLite_Startup()')
	EndIf

	_GDIPlus_Startup()
	If @error Then
		Return SetError(7, 0, '_GDIPlus_Startup()')
	EndIf

	AutoItObject_Startup(@ScriptDir & '\Libraries\AutoItObject.dll')
	If @error Then
		Return SetError(8, 0, 'AutoItObject_Startup()')
	EndIf

	$oErrorHandler = ObjEvent('AutoIt.Error', ComErrorHandler)
	If @error Then
		Return SetError(9, 0, 'ObjEvent()')
	EndIf

	SpamBot_Initialize()
	If @error Then
		Return SetError(10, 0, 'SpamBot_Initialize()')
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	$oSettings = Settings()
	$oMessage = Message()

	$oAccounts = Accounts()
	If @error Then
		Return SetError(11, 0, 'Accounts.class')
	EndIf

	$oGarenaRoom = GarenaRoom()
	If @error Then
		Return SetError(12, 0, 'GarenaRoom.class')
	EndIf

	$oGarenaTalk = GarenaTalk()
	If @error Then
		Return SetError(13, 0, 'GarenaTalk.class')
	EndIf

	$oGarena = Garena()
	If @error Then
		Return SetError(14, 0, 'Garena.class')
	EndIf

	$oInterface = Interface()
	If @error Then
		Return SetError(15, 0, 'Interface.class')
	EndIf

	$oServer = Server()
	If @error Then
		Return SetError(16, 0, 'Server.class')
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	$frmLogin = Login()

	While True
		Sleep(1000)
	WEnd
	;
	;---------------------------------------------------------------------------
EndFunc

Func ExitPoint()
	$oAccounts = Null
	$oGarenaRoom = Null
	$oInterface = Null
	$oServer = Null

	_GDIPlus_Shutdown()
	_SQLite_Shutdown()
	TCPShutdown()
	_WinAPI_CloseHandle($hMutex)
EndFunc

Func ComErrorHandler()
	MsgBox(BitOR($MB_OK, $MB_ICONERROR), $APP_NAME, 'Unfortunately ' & $APP_NAME & ' has stopped working.' & @CRLF & @CRLF & _
			'Error Number:' & @TAB & '0x' & Hex($oErrorHandler.number, 8) & @CRLF & _
			'Line Number:' & @TAB & $oErrorHandler.scriptline & @CRLF & _
			'Description:' & @TAB & $oErrorHandler.windescription)
	Exit
EndFunc

Global $sEntryPoint = EntryPoint()
If @error Then
	Debug('AFK Manager | ' & $sEntryPoint & ' failed.', @ScriptLineNumber)
EndIf