#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func MyAccount()
	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 350
	Local $HEIGHT = 280
	Local $LEFT = 1
	Local $TOP = 21

	Local $hWnd = GUICreate('My Account', $WIDTH + 2, $HEIGHT + 22, -1, -1, $WS_POPUP, 0, $frmMain.Handle)
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

	GUICtrlCreateLabel('My Account', 6, 3, $WIDTH - 10, 15, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlCreateLabel('My Account:', $LEFT + 50, $TOP + 50, -1, 15)

	Local $sMyAccount = '' & _
			'Username:' & @TAB & $oServer.Username & @CRLF & _
			'Max Users:' & @TAB & $oServer.MaxUsers & @CRLF & _
			'Online Users:' & @TAB & $oServer.OnlineUsers & ' (Including you)' & @CRLF & _
			'Proxy:' & @TAB & @TAB & (DllStructGetData($oServer.ProxyServer, 'fEnable') ? 'Yes' : 'No')

	GUICtrlCreateEdit($sMyAccount, $LEFT + 50, $TOP + 70, 235, 60, $ES_READONLY)

	GUICtrlCreateLabel('Renew account', $LEFT + 50, $TOP + 150, -1, 15)
	GUICtrlSetColor(-1, 0x007ACC)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetMouseClick(-1, MyAccount_lnkRenewAccount_MouseClick)
	GUICtrlSetMouseEnter(-1, LinkLabel_MouseEnter)
	GUICtrlSetMouseLeave(-1, LinkLabel_MouseLeave)

	GUICtrlCreateLabel('Change password', $LEFT + 50, $TOP + 170, -1, 15)
	GUICtrlSetColor(-1, 0x007ACC)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetMouseClick(-1, MyAccount_lnkChangePassword_MouseClick)
	GUICtrlSetMouseEnter(-1, LinkLabel_MouseEnter)
	GUICtrlSetMouseLeave(-1, LinkLabel_MouseLeave)

	Local $btnClose = GUICtrlCreateButton('Close', $LEFT + 125, $TOP + 205, 100, 25, $BS_DEFPUSHBUTTON)
	GUICtrlSetOnEvent(-1, MyAccount_btnClose_MouseClick)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $keySelectAll = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, GUICtrlEditOnCtrlA)

	Local $avAccelerators[][] = [['{ESC}', $btnClose], _
			['^a', $keySelectAll]]
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
		.AddDestructor('MyAccount_Destructor')

		; --- Properties | Read-only
		.AddProperty('Handle', $ELSCOPE_READONLY, $hWnd)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func MyAccount_Destructor($this)
	GUIUnsetMouseEvents($this.Handle)
	GUISetState(@SW_ENABLE, $frmMain.Handle)
	GUIDelete($this.Handle)
EndFunc

Func MyAccount_btnClose_MouseClick()
	$frmMyAccount = Null
EndFunc

Func MyAccount_lnkRenewAccount_MouseClick()
	ShellExecute($URL_ACCOUNTRENEW)
EndFunc

Func MyAccount_lnkChangePassword_MouseClick()
	ShellExecute($URL_PASSWORDCHANGE)
EndFunc