#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

;---------------------------------------------------------------------------
;
Global $mSpamBot[]
$mSpamBot['tSpamBotInfo'] = Null
$mSpamBot['hSpamBotFileMapping'] = Null
$mSpamBot['pSpamBotInfo'] = Null
$mSpamBot['bIsRunning'] = False
;
;---------------------------------------------------------------------------

Func SpamBot()
	;---------------------------------------------------------------------------
	;
	Local $hDatabase = _SQLite_Open(GarenaPlusPath() & '\Room\Roomen.dat')
	If $hDatabase Then
		; --- Nothing to do
	Else
		$oMessage.Error('Unable to open rooms database.', $frmMain.Handle)
		Return Null
	EndIf

	Local $sQuery = ''
	$sQuery &= 'SELECT RoomId, RoomName, EntryLevel '
	$sQuery &= 'FROM RoomTab '
	$sQuery &= "WHERE GameId = 1001 AND RoomName LIKE '%Iran%'"
	$sQuery &= 'ORDER BY RoomName;'

	Local $asResult[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($hDatabase, $sQuery, $asResult, $iRows, $iColumns) <> $SQLITE_OK Then
		$oMessage.Error('Unable to get rooms.', $frmMain.Handle)
		Return Null
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 860
	Local $HEIGHT = 530
	Local $LEFT = 1
	Local $TOP = 21

	Local $hWnd = GUICreate('SpamBot', $WIDTH + 2, $HEIGHT + 22, -1, -1, $WS_POPUP, 0, $frmMain.Handle)
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

	GUICtrlCreateLabel('SpamBot', 6, 3, $WIDTH - 10, 15, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlCreateLabel('Username:', $LEFT + 50, $TOP + 50, -1, 15)

	Local $txtUsername = GUICtrlCreateInput($oSettings.SpamBotUsername, $LEFT + 50, $TOP + 70, 175, 20, $ES_LEFT)
	GUICtrlSetLimit(-1, 16)

	GUICtrlCreateLabel('Password:', $LEFT + 235, $TOP + 50, -1, 15)

	Local $txtPassword = GUICtrlCreateInput($oSettings.SpamBotPassword, $LEFT + 235, $TOP + 70, 175, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_PASSWORD))
	GUICtrlSetLimit(-1, 31)

	Local $lvwRoomList = GUICtrlCreateListView('', $LEFT + 50, $TOP + 110, 360, 325, _
			BitOR($LVS_NOSORTHEADER, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS), _
			BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_INFOTIP, $WS_EX_CLIENTEDGE))

	Local $hRoomList = GUICtrlGetHandle($lvwRoomList)
	If @OSBuild >= 6000 Then
		_WinAPI_SetWindowTheme($hRoomList, 'Explorer')
	EndIf

	_GUICtrlListView_AddColumn($hRoomList, '', 25)
	_GUICtrlListView_AddColumn($hRoomList, 'Level', 40)
	_GUICtrlListView_AddColumn($hRoomList, 'Room Name', 270)

	Local $iIndex = 0
	Local $iRoomId = 0
	Local $asCheckedRoom = $oSettings.SpamBotRooms

	_GUICtrlListView_BeginUpdate($lvwRoomList)
	For $i = 1 To $iRows
		$iRoomId = Int($asResult[$i][0], 1)

		$iIndex = _GUICtrlListView_InsertItem($hRoomList, '', -1, -1, $iRoomId)
		_GUICtrlListView_AddSubItem($hRoomList, $iIndex, $asResult[$i][2], 1)
		_GUICtrlListView_AddSubItem($hRoomList, $iIndex, $asResult[$i][1], 2)

		For $sCheckedRoom In $asCheckedRoom
			If $sCheckedRoom == $iRoomId Then
				_GUICtrlListView_SetItemChecked($hRoomList, $iIndex)
			EndIf
		Next
	Next
	_GUICtrlListView_EndUpdate($hRoomList)

	_SQLite_Close($hDatabase)

	Local $btnAutoRun = GUICtrlCreateButton('Auto Run', 310, $TOP + 455, 100, 25)
	GUICtrlSetOnEvent(-1, SpamBot_btnbtnAutoRun_MouseClick)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlCreateLabel('Send message(s) every', $LEFT + 460, $TOP + 70, 115, 20, $SS_CENTERIMAGE)

	Local $txtInterval = GUICtrlCreateInput($oSettings.SpamBotInterval, $LEFT + 585, $TOP + 70, 50, 20, $ES_NUMBER)
	GUICtrlSetLimit(-1, 3)
	If $mSpamBot['bIsRunning'] Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf
	GUICtrlCreateUpdown(-1, $UDS_ARROWKEYS)
	GUICtrlSetLimit(-1, 720, 1)

	GUICtrlCreateLabel('minute(s).', $LEFT + 645, $TOP + 70, -1, 20, $SS_CENTERIMAGE)

	GUICtrlCreateLabel('First Message:', $LEFT + 460, $TOP + 110, -1, 15)

	Local $txtFirstMessage = GUICtrlCreateEdit($oSettings.SpamBotMessage1, $LEFT + 460, $TOP + 130, 350, 75, $ES_LEFT)
	GUICtrlSetLimit(-1, 130)
	If $mSpamBot['bIsRunning'] Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf

	GUICtrlCreateLabel('Second Message:', $LEFT + 460, $TOP + 225, -1, 15)

	Local $txtSecondMessage = GUICtrlCreateEdit($oSettings.SpamBotMessage2, $LEFT + 460, $TOP + 245, 350, 75, $ES_LEFT)
	GUICtrlSetLimit(-1, 130)
	If $mSpamBot['bIsRunning'] Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf

	GUICtrlCreateLabel('Third Message:', $LEFT + 460, $TOP + 340, -1, 15)

	Local $txtThirdMessage = GUICtrlCreateEdit($oSettings.SpamBotMessage3, $LEFT + 460, $TOP + 360, 350, 75, $ES_LEFT)
	GUICtrlSetLimit(-1, 130)
	If $mSpamBot['bIsRunning'] Then
		GUICtrlSetState(-1, $GUI_DISABLE)
	EndIf

	Local $btnStartStop = GUICtrlCreateButton($mSpamBot['bIsRunning'] ? 'Stop' : 'Start', $WIDTH - 150, $TOP + 455, 100, 25)
	GUICtrlSetOnEvent(-1, SpamBot_btnStartStop_MouseClick)

	Local $btnHide = GUICtrlCreateButton('Hide', $WIDTH - 260, $TOP + 455, 100, 25)
	GUICtrlSetOnEvent(-1, SpamBot_btnHide_MouseClick)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $keySelectAll = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, GUICtrlEditOnCtrlA)

	Local $avAccelerators[][] = [['{ESC}', $btnHide], _
			['^a', $keySelectAll]]
	GUISetAccelerators($avAccelerators, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('SpamBot_Destructor')

		; --- Properties | Private
		.AddProperty('KeyName', $ELSCOPE_PRIVATE, 'HKCU\Software\' & $APP_NAME)

		; --- Properties | Read-only
		.AddProperty('Handle', $ELSCOPE_READONLY, $hWnd)
		.AddProperty('txtUsername', $ELSCOPE_READONLY, $txtUsername)
		.AddProperty('txtPassword', $ELSCOPE_READONLY, $txtPassword)
		.AddProperty('lvwRoomList', $ELSCOPE_READONLY, $lvwRoomList)
		.AddProperty('btnAutoRun', $ELSCOPE_READONLY, $btnAutoRun)
		.AddProperty('txtInterval', $ELSCOPE_READONLY, $txtInterval)
		.AddProperty('txtFirstMessage', $ELSCOPE_READONLY, $txtFirstMessage)
		.AddProperty('txtSecondMessage', $ELSCOPE_READONLY, $txtSecondMessage)
		.AddProperty('txtThirdMessage', $ELSCOPE_READONLY, $txtThirdMessage)
		.AddProperty('btnStartStop', $ELSCOPE_READONLY, $btnStartStop)

		; --- Methods | Public
		.AddMethod('CheckedRooms', 'SpamBot_CheckedRooms', False)
		.AddMethod('GetRoomName', 'SpamBot_GetRoomName', False)
	EndWith
	Local $this = $oClass.Object
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUISetState(@SW_DISABLE, $frmMain.Handle)

	If GUICtrlRead($txtFirstMessage) Then
		GUICtrlSetState($btnStartStop, $GUI_FOCUS)
	EndIf

	GUISetState(@SW_SHOW, $hWnd)

	Return $this
	;
	;---------------------------------------------------------------------------
EndFunc

Func SpamBot_Destructor($this)
	$oSettings.SpamBotRooms = $this.CheckedRooms()
	GUIUnsetMouseEvents($this.Handle)
	GUISetState(@SW_ENABLE, $frmMain.Handle)
	GUIDelete($this.Handle)
EndFunc

Func SpamBot_btnbtnAutoRun_MouseClick()
	If IsObj($frmSpamBot) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $sUsername = GUICtrlRead($frmSpamBot.txtUsername)
	Local $sPassword = GUICtrlRead($frmSpamBot.txtPassword)

	If $sUsername And $sPassword Then
		If StringLen($sPassword) <> 32 Then
			$sPassword = $oInterface.MD5($sPassword)
		EndIf
	Else
		$oMessage.Warning('Please enter both username and password.', $frmSpamBot)
		GUICtrlSetState($sUsername ? $frmSpamBot.txtPassword : $frmSpamBot.txtUsername, $GUI_FOCUS)
		Return
	EndIf

	Local $asCheckedRooms = $frmSpamBot.CheckedRooms()
	Local $iRoomCount = UBound($asCheckedRooms)

	If $iRoomCount Then
		; --- Nothing to do
	Else
		$oMessage.Warning('Please select room(s) for SpamBot.', $frmSpamBot)
		Return
	EndIf

	$frmAutoAfkProgress = Null
	$frmAutoAfkProgress = AutoAfkProgress($frmSpamBot, 'SpamBot Auto Run')

	Local $mAccount[]
	$mAccount['Username'] = $sUsername
	$mAccount['Password'] = $sPassword
	$mAccount['RoomName'] = ''

	Local $iResult = 1
	Local $oClient = Null
	Local $sRoomName = ''

	UpdateGarenaRoom()

	$frmAutoAfkProgress.Log($sUsername, False)

	For $i = 0 To $iRoomCount - 1
		If $frmAutoAfkProgress.Interrupt Then
			$iResult = 2
			ExitLoop
		EndIf

		$mAccount['RoomId'] = $asCheckedRooms[$i]
		$sRoomName = $frmSpamBot.GetRoomName($mAccount['RoomId'])

		If $oGarenaRoom.IsRunningInRoom($sUsername, $mAccount['RoomId']) Then
			$frmAutoAfkProgress.Log($sRoomName & ' already running...')
			ContinueLoop
		EndIf

		$oClient = $oGarena.RunRoom($mAccount, 0)
		If $oClient = Null Then
			$iResult = 3
			ExitLoop
		EndIf

		Do
			If $frmAutoAfkProgress.Interrupt Then
				$oClient.Close()
				$iResult = 2
				ExitLoop 2
			EndIf

			If $oClient.IsAlive() Then
				; --- Nothing to do
			Else
				$oClient.Close()
				$iResult = 3
				ExitLoop 2
			EndIf

			If $oClient.IsPasswordWrong Then
				$oClient.Close()
				$frmAutoAfkProgress.Log('Invalid username and/or password.')
				ExitLoop 2
			EndIf

			Sleep(250)
		Until $oClient.IsLoggedIn

		$frmAutoAfkProgress.Log($sRoomName & ' done...')
	Next

	If $iResult = 1 Then
		$frmAutoAfkProgress.Log('SpamBot Auto Run finished.', False)
		$frmAutoAfkProgress.Finilize()
	ElseIf $iResult = 2 Then
		$frmAutoAfkProgress = 0
		$oMessage.Warning('SpamBot Auto Run has been interrupted by user.', $frmSpamBot)
	ElseIf $iResult = 3 Then
		$frmAutoAfkProgress.Log('SpamBot Auto Run failed.', False)
		$frmAutoAfkProgress.Finilize()
		$oMessage.Error('Unable to run Garena Room.' & @CRLF & @CRLF & _
				'- Make sure you have specified a valid path to Garena Plus.' & @CRLF & _
				"- Make sure 'garena_room.exe' exists in the specified path (In the 'Room' folder)." & @CRLF & _
				'- Make sure your computer has enough available memory (Ram) to run Garena Room.' & @CRLF & _
				'- Reinstall both AFK Manager and Garena Plus and make sure you have the latest version of them.' & @CRLF & @CRLF & _
				'If none of the above statements help, please contact support.', $frmSpamBot)
	EndIf
EndFunc

Func SpamBot_btnStartStop_MouseClick()
	If IsObj($frmSpamBot) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	If $mSpamBot['bIsRunning'] Then
		DllStructSetData($mSpamBot['tSpamBotInfo'], 'fState', False)

		GUICtrlSetState($frmSpamBot.txtInterval, $GUI_ENABLE)
		GUICtrlSetState($frmSpamBot.txtFirstMessage, $GUI_ENABLE)
		GUICtrlSetState($frmSpamBot.txtSecondMessage, $GUI_ENABLE)
		GUICtrlSetState($frmSpamBot.txtThirdMessage, $GUI_ENABLE)
		GUICtrlSetData($frmSpamBot.btnStartStop, 'Start')
	Else
		Local $iInterval = Int(GUICtrlRead($frmSpamBot.txtInterval), 1)
		If $iInterval < 1 Or $iInterval > 720 Then
			$oMessage.Warning('Interval value is out of range.', $frmSpamBot)
			Return
		EndIf

		Local $asMessages[3]
		$asMessages[0] = GUICtrlRead($frmSpamBot.txtFirstMessage)
		$asMessages[1] = GUICtrlRead($frmSpamBot.txtSecondMessage)
		$asMessages[2] = GUICtrlRead($frmSpamBot.txtThirdMessage)
		If StringStripWS($asMessages[0], $STR_STRIPALL) Or StringStripWS($asMessages[1], $STR_STRIPALL) Or StringStripWS($asMessages[2], $STR_STRIPALL) Then
			; --- Nothing to do
		Else
			$oMessage.Warning('Please enter at least one message.', $frmSpamBot)
			Return
		EndIf

		For $i = 0 To 2
			If StringInStr($asMessages[$i], 'http://') Or StringInStr($asMessages[$i], 'www.') Or StringInStr($asMessages[$i], 'https://') Then
				If $oMessage.YesNo("'www.', 'http://' and 'https://' are not allowed in Garena chat and your messages won't send." & @CRLF & 'Continue?', $frmSpamBot, True) Then
					ExitLoop
				Else
					Return
				EndIf
			EndIf
		Next

		GUICtrlSetState($frmSpamBot.txtInterval, $GUI_DISABLE)
		GUICtrlSetState($frmSpamBot.txtFirstMessage, $GUI_DISABLE)
		GUICtrlSetState($frmSpamBot.txtSecondMessage, $GUI_DISABLE)
		GUICtrlSetState($frmSpamBot.txtThirdMessage, $GUI_DISABLE)
		GUICtrlSetData($frmSpamBot.btnStartStop, 'Stop')

		DllStructSetData($mSpamBot['tSpamBotInfo'], 'fState', True)
		DllStructSetData($mSpamBot['tSpamBotInfo'], 'dwInterval', $iInterval)
		DllStructSetData($mSpamBot['tSpamBotInfo'], 'szFirstMessage', $asMessages[0])
		DllStructSetData($mSpamBot['tSpamBotInfo'], 'szSecondMessage', $asMessages[1])
		DllStructSetData($mSpamBot['tSpamBotInfo'], 'szThirdMessage', $asMessages[2])
	EndIf

	$mSpamBot['bIsRunning'] = Not $mSpamBot['bIsRunning']
EndFunc

Func SpamBot_btnHide_MouseClick()
	$frmSpamBot = Null
EndFunc

Func SpamBot_WM_COMMAND($hWnd, $uMsg, $wParam, $lParam)
	#forceref $uMsg, $lParam

	If IsObj($frmSpamBot) Then
		If $hWnd = $frmSpamBot.Handle And _WinAPI_HiWord($wParam) = $EN_CHANGE Then
			Switch _WinAPI_LoWord($wParam)
				Case $frmSpamBot.txtUsername
					$oSettings.SpamBotUsername = GUICtrlRead($frmSpamBot.txtUsername)

				Case $frmSpamBot.txtPassword
					$oSettings.SpamBotPassword = GUICtrlRead($frmSpamBot.txtPassword)

				Case $frmSpamBot.txtInterval
					$oSettings.SpamBotInterval = GUICtrlRead($frmSpamBot.txtInterval)

				Case $frmSpamBot.txtFirstMessage
					$oSettings.SpamBotMessage1 = GUICtrlRead($frmSpamBot.txtFirstMessage)

				Case $frmSpamBot.txtSecondMessage
					$oSettings.SpamBotMessage2 = GUICtrlRead($frmSpamBot.txtSecondMessage)

				Case $frmSpamBot.txtThirdMessage
					$oSettings.SpamBotMessage3 = GUICtrlRead($frmSpamBot.txtThirdMessage)
			EndSwitch
		EndIf
	EndIf
EndFunc

Func SpamBot_CheckedRooms($this)
	Local $asCheckedRoom[0]

	For $i = 0 To _GUICtrlListView_GetItemCount($this.lvwRoomList) - 1
		If _GUICtrlListView_GetItemChecked($this.lvwRoomList, $i) Then
			ReDim $asCheckedRoom[UBound($asCheckedRoom) + 1]
			$asCheckedRoom[UBound($asCheckedRoom) - 1] = _GUICtrlListView_GetItemParam($this.lvwRoomList, $i)
		EndIf
	Next

	Return $asCheckedRoom
EndFunc

Func SpamBot_GetRoomName($this, $iRoomId)
	For $i = 0 To _GUICtrlListView_GetItemCount($this.lvwRoomList) - 1
		If _GUICtrlListView_GetItemParam($this.lvwRoomList, $i) == $iRoomId Then
			Return _GUICtrlListView_GetItemText($this.lvwRoomList, $i, 2)
		EndIf
	Next
EndFunc

Func SpamBot_Initialize()
	Local $tagSpamBotInfo = 'BOOL fState;' & _
			'CHAR szFirstMessage[131];' & _
			'CHAR szSecondMessage[131];' & _
			'CHAR szThirdMessage[131];' & _
			'DWORD dwInterval'

	$mSpamBot['tSpamBotInfo'] = DllStructCreate($tagSpamBotInfo)
	If @error Then
		Debug('DllStructCreate() failed.', @ScriptLineNumber)
		Return SetError(1, 0, 0)
	EndIf

	$mSpamBot['hSpamBotFileMapping'] = _WinAPI_CreateFileMapping($INVALID_HANDLE_VALUE, DllStructGetSize($mSpamBot['tSpamBotInfo']), $APP_NAME & ': SpamBot', $PAGE_READWRITE)
	If $mSpamBot['hSpamBotFileMapping'] Then
		; --- Nothing to do
	Else
		Debug('_WinAPI_CreateFileMapping() failed.', @ScriptLineNumber)
		Return SetError(2, 0, 0)
	EndIf

	$mSpamBot['pSpamBotInfo'] = _WinAPI_MapViewOfFile($mSpamBot['hSpamBotFileMapping'], 0, DllStructGetSize($mSpamBot['tSpamBotInfo']), $FILE_MAP_ALL_ACCESS)
	If $mSpamBot['pSpamBotInfo'] Then
		; --- Nothing to do
	Else
		Debug('_WinAPI_MapViewOfFile() failed.', @ScriptLineNumber)
		_WinAPI_CloseHandle($mSpamBot['hSpamBotFileMapping'])
		Return SetError(3, 0, 0)
	EndIf

	$mSpamBot['tSpamBotInfo'] = Null

	$mSpamBot['tSpamBotInfo'] = DllStructCreate($tagSpamBotInfo, $mSpamBot['pSpamBotInfo'])
	If @error Then
		Debug('DllStructCreate() failed.', @ScriptLineNumber)
		_WinAPI_UnmapViewOfFile($mSpamBot['pSpamBotInfo'])
		_WinAPI_CloseHandle($mSpamBot['hSpamBotFileMapping'])
		Return SetError(4, 0, 0)
	EndIf

	_WinAPI_ZeroMemory(DllStructGetPtr($mSpamBot['tSpamBotInfo']), DllStructGetSize($mSpamBot['tSpamBotInfo']))
	If @error Then
		Debug('_WinAPI_ZeroMemory() failed.', @ScriptLineNumber)
		_WinAPI_UnmapViewOfFile($mSpamBot['pSpamBotInfo'])
		_WinAPI_CloseHandle($mSpamBot['hSpamBotFileMapping'])
		Return SetError(5, 0, 0)
	EndIf

	OnAutoItExitRegister(SpamBot_Uninitialize)
EndFunc

Func SpamBot_Uninitialize()
	_WinAPI_UnmapViewOfFile($mSpamBot['pSpamBotInfo'])
	_WinAPI_CloseHandle($mSpamBot['hSpamBotFileMapping'])
EndFunc