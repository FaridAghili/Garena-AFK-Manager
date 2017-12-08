#NoTrayIcon
#RequireAdmin
#AutoIt3Wrapper_AU3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7

;---------------------------------------------------------------------------
;
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/pe /sf=1 /sv=1 /rm /rsln
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
AutoItSetOption('GUICloseOnESC', 0)
AutoItSetOption('GUIOnEventMode', 1)
AutoItSetOption('MustDeclareVars', 1)
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
#include <ButtonConstants.au3>
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>
#include <InetConstants.au3>
#include <MsgBoxConstants.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
Global $sUrl = ''
Global $sFileName = ''
Global $btnCancel = 0
Global $hInet = 0
Global $bInterrupt = False

If $CmdLine[0] Then
	$sUrl = $CmdLine[1]
	$sFileName = StringSplit($sUrl, '/')[5]
Else
	Exit
EndIf
;
;---------------------------------------------------------------------------

Form()

While True
	Sleep(1000)

	If $bInterrupt Then
		Form()
		InetClose($hInet)
		FileDelete($sFileName)

		Exit
	EndIf

	If InetGetInfo($hInet, $INET_DOWNLOADCOMPLETE) Then
		Form()

		If InetGetInfo($hInet, $INET_DOWNLOADSUCCESS) Then
			InetClose($hInet)

			Clean()
			Install()
		Else
			InetClose($hInet)
			FileDelete($sFileName)

			MsgBox(BitOR($MB_OK, $MB_ICONERROR), 'AFK Manager', 'Unable to update to the latest version.')
		EndIf

		Exit
	EndIf
WEnd

Func Form()
	;---------------------------------------------------------------------------
	;
	Local Static $hWnd = 0

	If $hWnd Then
		GUIRegisterMsg($WM_COMMAND, '')
		GUIDelete($hWnd)
		$hWnd = 0
		Return
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 350
	Local $HEIGHT = 190
	Local $LEFT = 1
	Local $TOP = 21

	$hWnd = GUICreate('AFK Manager', $WIDTH + 2, $HEIGHT + 22, -1, -1, $WS_POPUP)
	GUISetBkColor(0xEFEFF2, $hWnd)
	GUISetFont(8.5, $FW_NORMAL, Default, 'Tahoma', $hWnd, $DEFAULT_QUALITY)

	GUICtrlCreateLabel('', 0, 0, $WIDTH + 2, 21)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetState(-1, $GUI_DISABLE)

	GUICtrlCreateLabel('', $WIDTH + 1, 21, 1, $HEIGHT)
	GUICtrlSetBkColor(-1, 0x007ACC)

	GUICtrlCreateLabel('', 0, $HEIGHT + 21, $WIDTH + 2, 1)
	GUICtrlSetBkColor(-1, 0x007ACC)

	GUICtrlCreateLabel('', 0, 21, 1, $HEIGHT)
	GUICtrlSetBkColor(-1, 0x007ACC)

	GUICtrlCreateLabel('AFK Manager', 6, 3, $WIDTH - 10, 15, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlCreateLabel('Updating AFK Manager, please wait...', $LEFT + 50, $TOP + 50, -1, 15)

	GUICtrlCreateProgress($LEFT + 50, $TOP + 70, 250, 25, $PBS_MARQUEE)
	GUICtrlSendMsg(-1, $PBM_SETMARQUEE, True, 50)

	$btnCancel = GUICtrlCreateButton('Cancel', $LEFT + 125, $TOP + 115, 100, 25)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	$hInet = InetGet($sUrl, $sFileName, BitOR($INET_FORCERELOAD, $INET_IGNORESSL, $INET_FORCEBYPASS), $INET_DOWNLOADBACKGROUND)

	GUIRegisterMsg($WM_COMMAND, WM_COMMAND)
	GUISetState(@SW_SHOW, $hWnd)
	;
	;---------------------------------------------------------------------------
EndFunc

Func Clean()
	ProcessClose('AFK Manager.exe')

	Local $avGarenaRoom = ProcessList('garena_room.exe')
	If @error Then
		; --- Nothing to do
	Else
		For $i = 1 To $avGarenaRoom[0][0]
			ProcessClose($avGarenaRoom[$i][1])
		Next
	EndIf

	Local $avGarenaMessenger = ProcessList('GarenaMessenger.exe')
	If @error Then
		; --- Nothing to do
	Else
		For $i = 1 To $avGarenaMessenger[0][0]
			ProcessClose($avGarenaMessenger[$i][1])
		Next
	EndIf
EndFunc

Func Install()
	Local $iProcessId = 0, $hWnd = 0

	$iProcessId = Run($sFileName)

	$hWnd = WinWait('AFK Manager Setup', 'Welcome to AFK Manager Setup')
	ControlClick($hWnd, '', 'Button2')

	$hWnd = WinWait('AFK Manager Setup ', 'Choose the folder in which to install AFK Manager.')
	ControlClick($hWnd, '', 'Button2')

	$hWnd = WinWait('AFK Manager Setup ', 'AFK Manager has been installed on your computer.')
	ControlClick($hWnd, '', 'Button2')

	ProcessWaitClose($iProcessId)

	FileDelete($sFileName)
EndFunc

Func WM_COMMAND($hWnd, $uMsg, $wParam, $lParam)
	#forceref $hWnd, $uMsg, $lParam

	If BitAND($wParam, 0xFFFF) = $btnCancel And BitShift($wParam, 16) = $BN_CLICKED Then
		$bInterrupt = True
	EndIf
EndFunc