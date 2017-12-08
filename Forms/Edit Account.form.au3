#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func EditAccount($sUsername)
	;---------------------------------------------------------------------------
	;
	Local $mAccount = $oAccounts.GetByUsername($sUsername)
	If IsMap($mAccount) Then
		; --- Nothing to do
	Else
		$oMessage.Error('Unable to read account: ' & $oAccounts.LastError, $frmMain)
		Return Null
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 350
	Local $HEIGHT = 550
	Local $LEFT = 1
	Local $TOP = 21

	Local $hWnd = GUICreate('Edit Account', $WIDTH + 2, $HEIGHT + 22, -1, -1, $WS_POPUP, 0, $frmMain.Handle)
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

	GUICtrlCreateLabel('Edit Account', 6, 3, $WIDTH - 10, 15, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlCreateLabel('Username:', $LEFT + 50, $TOP + 50, -1, 15)

	Local $txtUsername = GUICtrlCreateInput($sUsername, $LEFT + 50, $TOP + 70, 250, 20, $ES_READONLY)

	GUICtrlCreateLabel('Password:', $LEFT + 50, $TOP + 100, -1, 15)

	Local $txtPassword = GUICtrlCreateInput($mAccount['Password'], $LEFT + 50, $TOP + 120, 250, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_PASSWORD))
	GUICtrlSetLimit(-1, 31)

	GUICtrlCreateLabel('Room Servers:', $LEFT + 50, $TOP + 150, -1, 15)

	Local $iRoomServers = $oServer.GarenaRoomServerCount < $mAccount['RoomServers'] ? $oServer.GarenaRoomServerCount : $mAccount['RoomServers']
	Local $lblRoomServers = GUICtrlCreateLabel($iRoomServers, $LEFT + 130, $TOP + 150, -1, 15)

	Local $sldRoomServers = GUICtrlCreateSlider($LEFT + 50, $TOP + 165, 250, 30)
	GUICtrlSetBkColor(-1, 0xEFEFF2)
	GUICtrlSetLimit(-1, $oServer.GarenaRoomServerCount, 1)
	GUICtrlSetData(-1, $iRoomServers)
	GUICtrlSetOnEvent(-1, EditAccount_sldRoomServers_MouseClick)

	GUICtrlCreateLabel('Room Name:', $LEFT + 50, $TOP + 205, -1, 15)

	Local $txtRoomName = GUICtrlCreateInput($mAccount['RoomName'], $LEFT + 50, $TOP + 225, 196, 20, $ES_READONLY)

	GUICtrlCreateButton('...', $LEFT + 251, $TOP + 224, 22, 22)
	GUICtrlSetTip(-1, 'Select')
	GUICtrlSetOnEvent(-1, EditAccount_btnRoom_MouseClick)

	GUICtrlCreateButton('X', $LEFT + 278, $TOP + 224, 22, 22)
	GUICtrlSetTip(-1, 'Clear')
	GUICtrlSetOnEvent(-1, EditAccount_btnClear_MouseClick)

	GUICtrlCreateLabel('Talk Servers:', $LEFT + 50, $TOP + 255, -1, 15)

	Local $iTalkServers = $oServer.GarenaTalkServerCount < $mAccount['TalkServers'] ? $oServer.GarenaTalkServerCount : $mAccount['TalkServers']
	Local $lblTalkServers = GUICtrlCreateLabel($iTalkServers, $LEFT + 120, $TOP + 255, -1, 15)

	Local $sldTalkServers = GUICtrlCreateSlider($LEFT + 50, $TOP + 270, 250, 30)
	GUICtrlSetBkColor(-1, 0xEFEFF2)
	GUICtrlSetLimit(-1, $oServer.GarenaTalkServerCount, 1)
	GUICtrlSetData(-1, $iTalkServers)
	GUICtrlSetOnEvent(-1, EditAccount_sldTalkServers_MouseClick)

	GUICtrlCreateLabel('Expiry Date:', $LEFT + 50, $TOP + 305, -1, 15)

	Local $dtpExpiryDate = GUICtrlCreateDate('', $LEFT + 50, $TOP + 325, 250, 20, BitOR($DTS_SHOWNONE, $DTS_SHORTDATEFORMAT))
	GUICtrlSendMsg(-1, $DTM_SETFORMATW, 0, "yyyy'-'MM'-'dd")

	GUICtrlCreateLabel('Comments:', $LEFT + 50, $TOP + 355, -1, 15)

	Local $txtComments = GUICtrlCreateEdit($mAccount['Comments'], $LEFT + 50, $TOP + 380, 250, 75, BitOR($ES_WANTRETURN, $WS_VSCROLL))

	GUICtrlCreateButton('Save', $LEFT + 200, $TOP + 475, 100, 25, $BS_DEFPUSHBUTTON)
	GUICtrlSetOnEvent(-1, EditAccount_btnSave_MouseClick)

	Local $btnCancel = GUICtrlCreateButton('Cancel', $LEFT + 90, $TOP + 475, 100, 25)
	GUICtrlSetOnEvent(-1, EditAccount_btnCancel_MouseClick)
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
	If $mAccount['ExpiryDate'] Then
		GUICtrlSetData($dtpExpiryDate, $mAccount.ExpiryDate)
	Else
		GUICtrlSendMsg($dtpExpiryDate, $DTM_SETSYSTEMTIME, $GDT_NONE, 0)
	EndIf

	GUISetState(@SW_DISABLE, $frmMain.Handle)
	GUISetState(@SW_SHOW, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('EditAccount_Destructor')

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
		.AddProperty('RoomId', $ELSCOPE_PUBLIC, $mAccount['RoomId'])
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func EditAccount_Destructor($this)
	GUISetState(@SW_ENABLE, $frmMain.Handle)
	GUIDelete($this.Handle)
EndFunc

Func EditAccount_btnCancel_MouseClick()
	$frmEditAccount = Null
EndFunc

Func EditAccount_sldRoomServers_MouseClick()
	GUICtrlSetData($frmEditAccount.lblRoomServers, GUICtrlRead($frmEditAccount.sldRoomServers))
EndFunc

Func EditAccount_btnRoom_MouseClick()
	If IsObj($frmEditAccount) Then
		If GarenaPlusPath() Then
			$frmRoomList = RoomList($frmEditAccount)
		Else
			$oMessage.Error('Unable to find Garena Plus path.', $frmEditAccount)
		EndIf
	EndIf
EndFunc

Func EditAccount_btnClear_MouseClick()
	GUICtrlSetData($frmEditAccount.txtRoomName, '')
	$frmEditAccount.RoomId = 0
EndFunc

Func EditAccount_sldTalkServers_MouseClick()
	GUICtrlSetData($frmEditAccount.lblTalkServers, GUICtrlRead($frmEditAccount.sldTalkServers))
EndFunc

Func EditAccount_btnSave_MouseClick()
	If IsObj($frmEditAccount) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $sUsername = GUICtrlRead($frmEditAccount.txtUsername)
	Local $sPassword = GUICtrlRead($frmEditAccount.txtPassword)
	Local $sRoomServers = GUICtrlRead($frmEditAccount.sldRoomServers)
	Local $sRoomName = GUICtrlRead($frmEditAccount.txtRoomName)
	Local $sTalkServers = GUICtrlRead($frmEditAccount.sldTalkServers)
	Local $sExpiryDate = ''
	Local $sComments = GUICtrlRead($frmEditAccount.txtComments)

	If $sPassword Then
		; --- Nothing to do
	Else
		$oMessage.Warning('Please enter password.', $frmEditAccount)
		GUICtrlSetState($frmEditAccount.txtPassword, $GUI_FOCUS)
		Return
	EndIf

	Local $tSYSTEMTIME = DllStructCreate($tagSYSTEMTIME)
	If GUICtrlSendMsg($frmEditAccount.dtpExpiryDate, $DTM_GETSYSTEMTIME, 0, DllStructGetPtr($tSYSTEMTIME)) = $GDT_VALID Then
		$sExpiryDate = StringFormat('%u-%02u-%02u', $tSYSTEMTIME.Year, $tSYSTEMTIME.Month, $tSYSTEMTIME.Day)
	EndIf

	If $oAccounts.Update($sUsername, $sPassword, $sRoomServers, $frmEditAccount.RoomId, $sRoomName, $sTalkServers, $sExpiryDate, $sComments) Then
		$frmMain.AddAccount($sUsername, $sRoomServers, $sRoomName, $sTalkServers, $sExpiryDate)

		EditAccount_btnCancel_MouseClick()
		$frmMain.Status('Account successfully saved.')
	Else
		$oMessage.Error('Unable to update account:' & $oAccounts.LastError, $frmEditAccount)
	EndIf
EndFunc

Func EditAccount_WM_HSCROLL($hWnd, $uMsg, $wParam, $lParam)
	#forceref $hWnd, $uMsg, $wParam

	If IsObj($frmEditAccount) Then
		Switch $lParam
			Case $frmEditAccount.sldRoomServersHandle
				EditAccount_sldRoomServers_MouseClick()

			Case $frmEditAccount.sldTalkServersHandle
				EditAccount_sldTalkServers_MouseClick()
		EndSwitch
	EndIf
EndFunc