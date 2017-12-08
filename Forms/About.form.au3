#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func About()
	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 350
	Local $HEIGHT = 418
	Local $LEFT = 1
	Local $TOP = 21

	Local $hWnd = GUICreate('About ' & $APP_NAME, $WIDTH + 2, $HEIGHT + 22, -1, -1, $WS_POPUP, 0, $frmMain.Handle)
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

	GUICtrlCreateLabel('About ' & $APP_NAME, 6, 3, $WIDTH - 10, 15, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlCreatePicEx('LOGO_PNG', $LEFT + 111, $TOP + 50, 128, 128)

	GUICtrlCreateLabel(StringFormat('%s %.1f', $APP_NAME, $APP_VERSION), $LEFT + 50, $TOP + 228, 250, 15, $SS_CENTER)

	GUICtrlCreateLabel('Copyright © 2016 AFK-Manager.ir. All rights reserved.', $LEFT + 25, $TOP + 253, 300, 15, $SS_CENTER)

	GUICtrlCreateLabel('www.AFK-Manager.ir', $LEFT + 122, $TOP + 278, 106, 15)
	GUICtrlSetColor(-1, 0x007ACC)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetMouseClick(-1, About_lnkHomePage_MouseClick)
	GUICtrlSetMouseEnter(-1, LinkLabel_MouseEnter)
	GUICtrlSetMouseLeave(-1, LinkLabel_MouseLeave)

	Local $btnClose = GUICtrlCreateButton('Close', $LEFT + 125, $TOP + 343, 100, 25, $BS_DEFPUSHBUTTON)
	GUICtrlSetOnEvent(-1, About_btnClose_MouseClick)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $avAccelerators[][] = [['{ESC}', $btnClose]]
	GUISetAccelerators($avAccelerators, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUISetState(@SW_DISABLE, $frmMain.Handle)
	GUISetState(@SW_SHOW, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('About_Destructor')

		; --- Properties | Read-only
		.AddProperty('Handle', $ELSCOPE_READONLY, $hWnd)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func About_Destructor($this)
	GUIUnsetMouseEvents($this.Handle)
	GUISetState(@SW_ENABLE, $frmMain.Handle)
	GUIDelete($this.Handle)
EndFunc

Func About_btnClose_MouseClick()
	$frmAbout = Null
EndFunc

Func About_lnkHomePage_MouseClick()
	ShellExecute($URL_HOMEPAGE)
EndFunc