#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func NewAccount()
	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 350
	Local $HEIGHT = 550
	Local $LEFT = 1
	Local $TOP = 21

	Local $hWnd = GUICreate('New Account', $WIDTH + 2, $HEIGHT + 22, -1, -1, $WS_POPUP, 0, $frmMain.Handle)
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

	GUICtrlCreateLabel('New Account', 6, 3, $WIDTH - 10, 15, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlCreateLabel('Username:', $LEFT + 50, $TOP + 50, -1, 15)

	Local $txtUsername = GUICtrlCreateInput('', $LEFT + 50, $TOP + 70, 250, 20)
	GUICtrlSetLimit(-1, 16)

	GUICtrlCreateLabel('Password:', $LEFT + 50, $TOP + 100, -1, 15)

	Local $txtPassword = GUICtrlCreateInput('', $LEFT + 50, $TOP + 120, 250, 20, BitOR($ES_LEFT, $ES_PASSWORD))

	GUICtrlCreateLabel('Room Servers:', $LEFT + 50, $TOP + 150, -1, 15)

	Local $lblRoomServers = GUICtrlCreateLabel($oServer.GarenaRoomServerCount, $LEFT + 130, $TOP + 150, -1, 15)

	Local $sldRoomServers = GUICtrlCreateSlider($LEFT + 50, $TOP + 165, 250, 30)
	GUICtrlSetBkColor(-1, 0xEFEFF2)
	GUICtrlSetLimit(-1, $oServer.GarenaRoomServerCount, 1)
	GUICtrlSetData(-1, $oServer.GarenaRoomServerCount)
	GUICtrlSetOnEvent(-1, NewAccount_sldRoomServers_MouseClick)

	GUICtrlCreateLabel('Room Name:', $LEFT + 50, $TOP + 205, -1, 15)

	Local $txtRoomName = GUICtrlCreateInput('', $LEFT + 50, $TOP + 225, 196, 20, $ES_READONLY)

	GUICtrlCreateButton('...', $LEFT + 251, $TOP + 224, 22, 22)
	GUICtrlSetTip(-1, 'Select')
	GUICtrlSetOnEvent(-1, NewAccount_btnRoom_MouseClick)

	GUICtrlCreateButton('X', $LEFT + 278, $TOP + 224, 22, 22)
	GUICtrlSetTip(-1, 'Clear')
	GUICtrlSetOnEvent(-1, NewAccount_btnClear_MouseClick)

	GUICtrlCreateLabel('Talk Servers:', $LEFT + 50, $TOP + 255, -1, 15)

	Local $lblTalkServers = GUICtrlCreateLabel($oServer.GarenaTalkServerCount, $LEFT + 120, $TOP + 255, -1, 15)

	Local $sldTalkServers = GUICtrlCreateSlider($LEFT + 50, $TOP + 270, 250, 30)
	GUICtrlSetBkColor(-1, 0xEFEFF2)
	GUICtrlSetLimit(-1, $oServer.GarenaTalkServerCount, 1)
	GUICtrlSetData(-1, $oServer.GarenaTalkServerCount)
	GUICtrlSetOnEvent(-1, NewAccount_sldTalkServers_MouseClick)

	GUICtrlCreateLabel('Expiry Date:', $LEFT + 50, $TOP + 305, -1, 15)

	Local $dtpExpiryDate = GUICtrlCreateDate('', $LEFT + 50, $TOP + 325, 250, 20, BitOR($DTS_SHOWNONE, $DTS_SHORTDATEFORMAT))
	GUICtrlSendMsg(-1, $DTM_SETFORMATW, 0, "yyyy'-'MM'-'dd")
	GUICtrlSendMsg(-1, $DTM_SETSYSTEMTIME, $GDT_NONE, 0)

	GUICtrlCreateLabel('Comments:', $LEFT + 50, $TOP + 355, -1, 15)

	Local $txtComments = GUICtrlCreateEdit('', $LEFT + 50, $TOP + 380, 250, 75, BitOR($ES_WANTRETURN, $WS_VSCROLL))

	GUICtrlCreateButton('Add', $LEFT + 200, $TOP + 475, 100, 25, $BS_DEFPUSHBUTTON)
	GUICtrlSetOnEvent(-1, NewAccount_btnAdd_MouseClick)

	Local $btnCancel = GUICtrlCreateButton('Cancel', $LEFT + 90, $TOP + 475, 100, 25)
	GUICtrlSetOnEvent(-1, NewAccount_btnCancel_MouseClick)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $keySelectAll = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, GUICtrlEditOnCtrlA)

	Local $avAccelerators[][] = [['{ESC}', $btnCancel], _
			['^a', $keySelectAll]]
	GUISetAccelerators($avAccelerators, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlSetState($txtUsername, $GUI_FOCUS)

	GUISetState(@SW_DISABLE, $frmMain.Handle)
	GUISetState(@SW_SHOW, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('NewAccount_Destructor')

		; --- Properties | Read-only
		.AddProperty('Handle', $ELSCOPE_READONLY, $hWnd)
		.AddProperty('txtUsername', $ELSCOPE_READONLY, $txtUsername)
		.AddProperty('txtPassword', $ELSCOPE_READONLY, $txtPassword)
		.AddProperty('lblRoomServers', $ELSCOPE_READONLY, $lblRoomServers)
		.AddProperty('sldRoomServers', $ELSCOPE_READONLY, $sldRoomServers)
		.AddProperty('sldRoomServersHandle', $ELSCOPE_READONLY, GUICtrlGetHandle($sldRoomServers))
		.AddProperty('txtRoomName', $ELSCOPE_READONLY, $txtRoomName)
		.AddProperty('txtRoomNameHandle', $ELSCOPE_READONLY, GUICtrlGetHandle($txtRoomName))
		.AddProperty('lblTalkServers', $ELSCOPE_READONLY, $lblTalkServers)
		.AddProperty('sldTalkServers', $ELSCOPE_READONLY, $sldTalkServers)
		.AddProperty('sldTalkServersHandle', $ELSCOPE_READONLY, GUICtrlGetHandle($sldTalkServers))
		.AddProperty('dtpExpiryDate', $ELSCOPE_READONLY, $dtpExpiryDate)
		.AddProperty('txtComments', $ELSCOPE_READONLY, $txtComments)

		; --- Properties | Public
		.AddProperty('RoomId', $ELSCOPE_PUBLIC, 0)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func NewAccount_Destructor($this)
	GUISetState(@SW_ENABLE, $frmMain.Handle)
	GUIDelete($this.Handle)
EndFunc

Func NewAccount_btnCancel_MouseClick()
	$frmNewAccount = Null
EndFunc

Func NewAccount_sldRoomServers_MouseClick()
	GUICtrlSetData($frmNewAccount.lblRoomServers, GUICtrlRead($frmNewAccount.sldRoomServers))
EndFunc

Func NewAccount_btnRoom_MouseClick()
	If IsObj($frmNewAccount) Then
		If GarenaPlusPath() Then
			$frmRoomList = RoomList($frmNewAccount)
		Else
			$oMessage.Error('Unable to find Garena Plus path.', $frmNewAccount)
		EndIf
	EndIf
EndFunc

Func NewAccount_btnClear_MouseClick()
	GUICtrlSetData($frmNewAccount.txtRoomName, '')
	$frmNewAccount.RoomId = 0
EndFunc

Func NewAccount_sldTalkServers_MouseClick()
	GUICtrlSetData($frmNewAccount.lblTalkServers, GUICtrlRead($frmNewAccount.sldTalkServers))
EndFunc

Func NewAccount_btnAdd_MouseClick()
	If IsObj($frmNewAccount) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $sUsername = StringStripWS(GUICtrlRead($frmNewAccount.txtUsername), $STR_STRIPALL)
	Local $sPassword = GUICtrlRead($frmNewAccount.txtPassword)
	Local $sRoomServers = GUICtrlRead($frmNewAccount.sldRoomServers)
	Local $sRoomName = GUICtrlRead($frmNewAccount.txtRoomName)
	Local $sTalkServers = GUICtrlRead($frmNewAccount.sldTalkServers)
	Local $sExpiryDate = ''
	Local $sComments = GUICtrlRead($frmNewAccount.txtComments)

	If $sUsername And $sPassword Then
		; --- Nothing to do
	Else
		$oMessage.Warning('Please enter both username and password.', $frmNewAccount)
		GUICtrlSetState($sUsername ? $frmNewAccount.txtPassword : $frmNewAccount.txtUsername, $GUI_FOCUS)
		Return
	EndIf

	If $oAccounts.Exists($sUsername) Then
		$oMessage.Warning('Duplicate username.', $frmNewAccount)
		Return
	Else
		If $oAccounts.LastError Then
			$oMessage.Error("Unable to check account's existance: " & $oAccounts.LastError, $frmNewAccount)
			Return
		EndIf
	EndIf

	Local $tSYSTEMTIME = DllStructCreate($tagSYSTEMTIME)
	If GUICtrlSendMsg($frmNewAccount.dtpExpiryDate, $DTM_GETSYSTEMTIME, 0, DllStructGetPtr($tSYSTEMTIME)) = $GDT_VALID Then
		$sExpiryDate = StringFormat('%u-%02u-%02u', $tSYSTEMTIME.Year, $tSYSTEMTIME.Month, $tSYSTEMTIME.Day)
	EndIf

	If $oAccounts.Add($sUsername, $sPassword, $sRoomServers, $frmNewAccount.RoomId, $sRoomName, $sTalkServers, $sExpiryDate, $sComments) Then
		$frmMain.AddAccount($sUsername, $sRoomServers, $sRoomName, $sTalkServers, $sExpiryDate)

		NewAccount_btnCancel_MouseClick()
		$frmMain.Status('Account successfully saved.')
	Else
		$oMessage.Error('Unable to add account: ' & $oAccounts.LastError, $frmNewAccount)
	EndIf
EndFunc

Func NewAccount_WM_HSCROLL($hWnd, $uMsg, $wParam, $lParam)
	#forceref $hWnd, $uMsg, $wParam

	If IsObj($frmNewAccount) Then
		Switch $lParam
			Case $frmNewAccount.sldRoomServersHandle
				NewAccount_sldRoomServers_MouseClick()

			Case $frmNewAccount.sldTalkServersHandle
				NewAccount_sldTalkServers_MouseClick()
		EndSwitch
	EndIf
EndFunc