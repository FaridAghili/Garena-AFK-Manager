#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func RoomClientManager($sUsername)
	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 640
	Local $HEIGHT = 300
	Local $LEFT = 1
	Local $TOP = 21

	Local $hWnd = GUICreate('Room Client Manager', $WIDTH + 2, $HEIGHT + 22, -1, -1, $WS_POPUP, 0, $frmMain.Handle)
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

	GUICtrlCreateLabel('Room Client Manager', 6, 3, $WIDTH - 25, 15, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)

	GUICtrlCreatePicEx('CLOSE_2_PNG', $WIDTH - 17, 3, 15, 15)
	GUICtrlSetTip(-1, 'Close')
	GUICtrlSetMouseClick(-1, RoomClientManager_btnClose_MouseClick)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;

	Local $cboUsernames = GUICtrlCreateCombo('', $LEFT + 10, $TOP + 10, $WIDTH - 20, 21, BitOR($CBS_DROPDOWN, $CBS_SORT, $WS_VSCROLL))
	Local $hUsernames = GUICtrlGetHandle(-1)

	_GUICtrlComboBox_LimitText($hUsernames, 16)
	_GUICtrlComboBox_SetCueBanner($hUsernames, 'Username...')
	GUICtrlSetOnEvent(-1, RoomClientManager_cboUsernames_ItemSelect)

	Local $lvwRoomClientManager = GUICtrlCreateListView('', $LEFT, $TOP + 40, $WIDTH, $HEIGHT - 40, _
			BitOR($LVS_SHOWSELALWAYS, $LVS_SORTASCENDING), _
			BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_INFOTIP))
	GUICtrlSetOnEvent(-1, RoomClientManager_lvwRoomClientManagerHeader_MouseClick)

	Local $hRoomClientManager = GUICtrlGetHandle(-1)
	If @OSBuild >= 6000 Then
		_WinAPI_SetWindowTheme($hRoomClientManager, 'Explorer')
	EndIf

	_GUICtrlListView_AddColumn($hRoomClientManager, 'Server', 55)
	_GUICtrlListView_AddColumn($hRoomClientManager, 'Level', 40)
	_GUICtrlListView_AddColumn($hRoomClientManager, '%', 30)
	_GUICtrlListView_AddColumn($hRoomClientManager, 'EXP', 100)
	_GUICtrlListView_AddColumn($hRoomClientManager, 'Room Name', 240)
	_GUICtrlListView_AddColumn($hRoomClientManager, 'Expiry Date', 75)
	_GUICtrlListView_AddColumn($hRoomClientManager, 'Status', 100)
	_GUICtrlListView_RegisterSortCallBack($hRoomClientManager)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $keyClose = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, RoomClientManager_btnClose_MouseClick)

	Local $keySelectAll = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, GUICtrlEditOnCtrlA)

	Local $keyRefresh = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, RoomClientManager_keyRefresh)

	Local $avAccelerators[][] = [['{ESC}', $keyClose], _
			['^a', $keySelectAll], _
			['{F5}', $keyRefresh]]
	GUISetAccelerators($avAccelerators, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('RoomClientManager_Destructor')

		; --- Properties | Read-only
		.AddProperty('Handle', $ELSCOPE_READONLY, $hWnd)
		.AddProperty('cboUsernames', $ELSCOPE_READONLY, $cboUsernames)
		.AddProperty('lvwRoomClientManager', $ELSCOPE_READONLY, $lvwRoomClientManager)
		.AddProperty('lvwRoomClientManagerHandle', $ELSCOPE_READONLY, $hRoomClientManager)

		; --- Methods | Public
		.AddMethod('LoadRoomClientManager', 'RoomClientManager_LoadRoomClientManager', False)
		.AddMethod('AddItem', 'RoomClientManager_AddItem', False)
	EndWith
	Local $this = $oClass.Object
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUISetState(@SW_DISABLE, $frmMain.Handle)
	$this.LoadRoomClientManager($sUsername)
	GUISetState(@SW_SHOW, $hWnd)

	Return $this
	;
	;---------------------------------------------------------------------------
EndFunc

Func RoomClientManager_Destructor($this)
	_GUICtrlListView_UnRegisterSortCallBack($this.lvwRoomClientManager)
	GUIUnsetMouseEvents($this.Handle)
	GUISetState(@SW_ENABLE, $frmMain.Handle)
	GUIDelete($this.Handle)
EndFunc

Func RoomClientManager_btnClose_MouseClick()
	$frmRoomClientManager = Null
EndFunc

Func RoomClientManager_cboUsernames_ItemSelect()
	_GUICtrlListView_BeginUpdate($frmRoomClientManager.lvwRoomClientManager)
	_GUICtrlListView_DeleteAllItems($frmRoomClientManager.lvwRoomClientManager)

	Local $sUsername = GUICtrlRead($frmRoomClientManager.cboUsernames)

	Local $aoRoomClients = $oGarenaRoom.GetByUsername($sUsername)

	If $aoRoomClients = Null Then
		Local $iIndex = _GUICtrlComboBox_FindStringExact($frmRoomClientManager.cboUsernames, $sUsername)
		_GUICtrlComboBox_DeleteString($frmRoomClientManager.cboUsernames, $iIndex)

		If _GUICtrlComboBox_GetCount($frmRoomClientManager.cboUsernames) Then
			; --- Nothing to do
		Else
			_GUICtrlComboBox_ResetContent($frmRoomClientManager.cboUsernames)
		EndIf

		_GUICtrlListView_EndUpdate($frmRoomClientManager.lvwRoomClientManager)
		Return
	EndIf

	For $oRoomClient In $aoRoomClients
		$frmRoomClientManager.AddItem($oRoomClient)
	Next

	_GUICtrlListView_EndUpdate($frmRoomClientManager.lvwRoomClientManager)
EndFunc

Func RoomClientManager_lvwRoomClientManagerHeader_MouseClick()
	If IsObj($frmRoomClientManager) Then
		_GUICtrlListView_SortItems($frmRoomClientManager.lvwRoomClientManager, GUICtrlGetState($frmRoomClientManager.lvwRoomClientManager))
	EndIf
EndFunc

Func RoomClientManager_keyRefresh()
	RoomClientManager_mnuRefresh_MouseClick()
EndFunc

Func RoomClientManager_WM_COMMAND($hWnd, $uMsg, $wParam, $lParam)
	#forceref $hWnd, $uMsg, $lParam

	If IsObj($frmRoomClientManager) Then
		If _WinAPI_LoWord($wParam) = $frmRoomClientManager.cboUsernames And _WinAPI_HiWord($wParam) = $CBN_EDITCHANGE Then
			_GUICtrlComboBox_AutoComplete($frmRoomClientManager.cboUsernames)
		EndIf
	EndIf
EndFunc

Func RoomClientManager_WM_CONTEXTMENU($hWnd, $uMsg, $wParam, $lParam)
	#forceref $hWnd, $uMsg, $wParam, $lParam

	If IsObj($frmRoomClientManager) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local Static $bLock = False
	If $bLock Then
		Return
	EndIf

	Local $MNU_REFRESH = 2000
	Local $MNU_CLOSE = 2001

	Local $tPOINT = DllStructCreate($tagPOINT)
	$tPOINT.X = MouseGetPos(0)
	$tPOINT.Y = MouseGetPos(1)

	Local $hCtrl = _WinAPI_WindowFromPoint($tPOINT)
	If $hCtrl <> $frmRoomClientManager.lvwRoomClientManagerHandle Then
		Return
	EndIf

	Local $hMenu = _GUICtrlMenu_CreatePopup($MNS_AUTODISMISS)

	_GUICtrlMenu_AddMenuItem($hMenu, 'Refresh' & @TAB & 'F5', $MNU_REFRESH)

	If _GUICtrlListView_HitTest($hCtrl)[0] <> -1 Then
		_GUICtrlMenu_AddMenuItem($hMenu, '')
		_GUICtrlMenu_AddMenuItem($hMenu, 'Close', $MNU_CLOSE)
	EndIf

	Local $iIndex = _GUICtrlMenu_TrackPopupMenu($hMenu, $hCtrl, -1, -1, 1, 1, 3, 1)
	_GUICtrlMenu_DestroyMenu($hMenu)

	Switch $iIndex
		Case $MNU_REFRESH
			$bLock = True
			RoomClientManager_mnuRefresh_MouseClick()
			$bLock = False

		Case $MNU_CLOSE
			RoomClientManager_mnuClose_MouseClick()
	EndSwitch
EndFunc

Func RoomClientManager_mnuRefresh_MouseClick()
	If IsObj($frmRoomClientManager) Then
		RoomClientManager_cboUsernames_ItemSelect()
	EndIf
EndFunc

Func RoomClientManager_mnuClose_MouseClick()
	If IsObj($frmRoomClientManager) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $aiSelectedItems = _GUICtrlListView_GetSelectedIndices($frmRoomClientManager.lvwRoomClientManager, True)
	If $aiSelectedItems[0] Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $iProcessId = 0

	_GUICtrlListView_BeginUpdate($frmRoomClientManager.lvwRoomClientManager)
	For $i = $aiSelectedItems[0] To 1 Step -1
		$iProcessId = _GUICtrlListView_GetItemParam($frmRoomClientManager.lvwRoomClientManager, $aiSelectedItems[$i])
		_GUICtrlListView_DeleteItem($frmRoomClientManager.lvwRoomClientManager, $aiSelectedItems[$i])
		$oGarenaRoom.CloseByProcessId($iProcessId)
	Next
	_GUICtrlListView_EndUpdate($frmRoomClientManager.lvwRoomClientManager)

	If _GUICtrlListView_GetItemCount($frmRoomClientManager.lvwRoomClientManager) Then
		; --- Nothing to do
	Else
		Local $sUsername = GUICtrlRead($frmRoomClientManager.cboUsernames)
		Local $iIndex = _GUICtrlComboBox_FindStringExact($frmRoomClientManager.cboUsernames, $sUsername)
		_GUICtrlComboBox_DeleteString($frmRoomClientManager.cboUsernames, $iIndex)
		If _GUICtrlComboBox_GetCount($frmRoomClientManager.cboUsernames) Then
			; --- Nothing to do
		Else
			_GUICtrlComboBox_ResetContent($frmRoomClientManager.cboUsernames)
		EndIf
	EndIf
EndFunc

Func RoomClientManager_LoadRoomClientManager($this, $sUsername)
	Local $aoRoomClients = $oGarenaRoom.GetAll()
	If $aoRoomClients = Null Then
		Return
	EndIf

	_GUICtrlComboBox_BeginUpdate($this.cboUsernames)
	For $oRoomClient In $aoRoomClients
		If _GUICtrlComboBox_FindStringExact($this.cboUsernames, $oRoomClient.Username) = -1 Then
			_GUICtrlComboBox_AddString($this.cboUsernames, $oRoomClient.Username)
		EndIf
	Next
	_GUICtrlComboBox_EndUpdate($this.cboUsernames)

	If $sUsername Then
		_GUICtrlComboBox_SelectString($this.cboUsernames, $sUsername)
		$frmRoomClientManager = $this
		RoomClientManager_cboUsernames_ItemSelect()
	EndIf
EndFunc

Func RoomClientManager_AddItem($this, $oRoomClient)
	Local $sStatus = 'Connecting...'
	If $oRoomClient.IsInRoom Then
		$sStatus = $oRoomClient.IsConnected ? 'Connected' : 'Disconnected'
	EndIf

	Local $sRoomName = $oRoomClient.RoomName
	If $sRoomName Then
		; --- Nothing to do
	Else
		$sRoomName = $oRoomClient.CurrentRoomName
		If $sRoomName Then
			; --- Nothing to do
		Else
			$sRoomName = '-'
		EndIf
	EndIf

	Local $vServer = $oRoomClient.Server
	If $vServer Then
		; --- Nothing to do
	Else
		$vServer = 'SpamBot'
	EndIf

	Local $sExpiryDate = $oRoomClient.ExpiryDate
	If $sExpiryDate Then
		; --- Nothing to do
	Else
		$sExpiryDate = 'N/A'
	EndIf

	Local $iCurrentExp = '-'
	Local $iExpPercent = '-'
	Local $iLevel = '-'
	Local $iRequiredExp = '-'

	Local $oAccountInfo = $oRoomClient.AccountInfo()
	If IsMap($oAccountInfo) Then
		$iCurrentExp = $oAccountInfo['CurrentExp']
		$iExpPercent = $oAccountInfo['ExpPercent']
		$iLevel = $oAccountInfo['Level']
		$iRequiredExp = $oAccountInfo['RequiredExp']
	EndIf

	Local $iIndex = _GUICtrlListView_AddItem($this.lvwRoomClientManager, $vServer, -1, $oRoomClient.ProcessId)
	_GUICtrlListView_AddSubItem($this.lvwRoomClientManager, $iIndex, $iLevel, 1)
	_GUICtrlListView_AddSubItem($this.lvwRoomClientManager, $iIndex, $iExpPercent, 2)
	_GUICtrlListView_AddSubItem($this.lvwRoomClientManager, $iIndex, $iCurrentExp & '/' & $iRequiredExp, 3)
	_GUICtrlListView_AddSubItem($this.lvwRoomClientManager, $iIndex, $sRoomName, 4)
	_GUICtrlListView_AddSubItem($this.lvwRoomClientManager, $iIndex, $sExpiryDate, 5)
	_GUICtrlListView_AddSubItem($this.lvwRoomClientManager, $iIndex, $sStatus, 6)
EndFunc