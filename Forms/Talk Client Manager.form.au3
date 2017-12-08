#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func TalkClientManager($sUsername)
	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 640
	Local $HEIGHT = 300
	Local $LEFT = 1
	Local $TOP = 21

	Local $hWnd = GUICreate('Talk Client Manager', $WIDTH + 2, $HEIGHT + 22, -1, -1, $WS_POPUP, 0, $frmMain.Handle)
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

	GUICtrlCreateLabel('Talk Client Manager', 6, 3, $WIDTH - 25, 15, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)

	GUICtrlCreatePicEx('CLOSE_2_PNG', $WIDTH - 17, 3, 15, 15)
	GUICtrlSetTip(-1, 'Close')
	GUICtrlSetMouseClick(-1, TalkClientManager_btnClose_MouseClick)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $cboUsernames = GUICtrlCreateCombo('', $LEFT + 10, $TOP + 10, $WIDTH - 20, 21, BitOR($CBS_DROPDOWN, $CBS_SORT, $WS_VSCROLL))
	Local $hUsernames = GUICtrlGetHandle(-1)

	_GUICtrlComboBox_LimitText($hUsernames, 16)
	_GUICtrlComboBox_SetCueBanner($hUsernames, 'Username...')
	GUICtrlSetOnEvent(-1, TalkClientManager_cboUsernames_ItemSelect)

	Local $lvwTalkClientManager = GUICtrlCreateListView('', $LEFT, $TOP + 40, $WIDTH, $HEIGHT - 40, _
			BitOR($LVS_SHOWSELALWAYS, $LVS_SORTASCENDING), _
			BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_INFOTIP))
	GUICtrlSetOnEvent(-1, TalkClientManager_lvwTalkClientManagerHeader_MouseClick)

	Local $hTalkClientManager = GUICtrlGetHandle(-1)
	If @OSBuild >= 6000 Then
		_WinAPI_SetWindowTheme($hTalkClientManager, 'Explorer')
	EndIf

	_GUICtrlListView_AddColumn($hTalkClientManager, 'Server', 55)
	_GUICtrlListView_AddColumn($hTalkClientManager, 'Talk Name', 390)
	_GUICtrlListView_AddColumn($hTalkClientManager, 'Expiry Date', 75)
	_GUICtrlListView_AddColumn($hTalkClientManager, 'Status', 100)
	_GUICtrlListView_RegisterSortCallBack($hTalkClientManager)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $keyClose = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, TalkClientManager_btnClose_MouseClick)

	Local $keySelectAll = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, GUICtrlEditOnCtrlA)

	Local $keyRefresh = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, TalkClientManager_keyRefresh)

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
		.AddDestructor('TalkClientManager_Destructor')

		; --- Properties | Read-only
		.AddProperty('Handle', $ELSCOPE_READONLY, $hWnd)
		.AddProperty('cboUsernames', $ELSCOPE_READONLY, $cboUsernames)
		.AddProperty('lvwTalkClientManager', $ELSCOPE_READONLY, $lvwTalkClientManager)
		.AddProperty('lvwTalkClientManagerHandle', $ELSCOPE_READONLY, $hTalkClientManager)

		; --- Methods | Public
		.AddMethod('LoadTalkClientManager', 'TalkClientManager_LoadTalkClientManager', False)
		.AddMethod('AddItem', 'TalkClientManager_AddItem', False)
	EndWith
	Local $this = $oClass.Object
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUISetState(@SW_DISABLE, $frmMain.Handle)
	$this.LoadTalkClientManager($sUsername)
	GUISetState(@SW_SHOW, $hWnd)

	Return $this
	;
	;---------------------------------------------------------------------------
EndFunc

Func TalkClientManager_Destructor($this)
	_GUICtrlListView_UnRegisterSortCallBack($this.lvwTalkClientManager)
	GUIUnsetMouseEvents($this.Handle)
	GUISetState(@SW_ENABLE, $frmMain.Handle)
	GUIDelete($this.Handle)
EndFunc

Func TalkClientManager_btnClose_MouseClick()
	$frmTalkClientManager = Null
EndFunc

Func TalkClientManager_cboUsernames_ItemSelect()
	_GUICtrlListView_BeginUpdate($frmTalkClientManager.lvwTalkClientManager)
	_GUICtrlListView_DeleteAllItems($frmTalkClientManager.lvwTalkClientManager)

	Local $sUsername = GUICtrlRead($frmTalkClientManager.cboUsernames)

	Local $aoTalkClients = $oGarenaTalk.GetByUsername($sUsername)

	If $aoTalkClients = Null Then
		Local $iIndex = _GUICtrlComboBox_FindStringExact($frmTalkClientManager.cboUsernames, $sUsername)
		_GUICtrlComboBox_DeleteString($frmTalkClientManager.cboUsernames, $iIndex)

		If _GUICtrlComboBox_GetCount($frmTalkClientManager.cboUsernames) Then
			; --- Nothing to do
		Else
			_GUICtrlComboBox_ResetContent($frmTalkClientManager.cboUsernames)
		EndIf

		_GUICtrlListView_EndUpdate($frmTalkClientManager.lvwTalkClientManager)
		Return
	EndIf

	For $oTalkClient In $aoTalkClients
		$frmTalkClientManager.AddItem($oTalkClient)
	Next

	_GUICtrlListView_EndUpdate($frmTalkClientManager.lvwTalkClientManager)
EndFunc

Func TalkClientManager_lvwTalkClientManagerHeader_MouseClick()
	If IsObj($frmTalkClientManager) Then
		_GUICtrlListView_SortItems($frmTalkClientManager.lvwTalkClientManager, GUICtrlGetState($frmTalkClientManager.lvwTalkClientManager))
	EndIf
EndFunc

Func TalkClientManager_keyRefresh()
	TalkClientManager_mnuRefresh_MouseClick()
EndFunc

Func TalkClientManager_WM_COMMAND($hWnd, $uMsg, $wParam, $lParam)
	#forceref $hWnd, $uMsg, $lParam

	If IsObj($frmTalkClientManager) Then
		If _WinAPI_LoWord($wParam) = $frmTalkClientManager.cboUsernames And _WinAPI_HiWord($wParam) = $CBN_EDITCHANGE Then
			_GUICtrlComboBox_AutoComplete($frmTalkClientManager.cboUsernames)
		EndIf
	EndIf
EndFunc

Func TalkClientManager_WM_CONTEXTMENU($hWnd, $uMsg, $wParam, $lParam)
	#forceref $hWnd, $uMsg, $wParam, $lParam

	If IsObj($frmTalkClientManager) Then
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
	If $hCtrl <> $frmTalkClientManager.lvwTalkClientManagerHandle Then
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
			TalkClientManager_mnuRefresh_MouseClick()
			$bLock = False

		Case $MNU_CLOSE
			TalkClientManager_mnuClose_MouseClick()
	EndSwitch
EndFunc

Func TalkClientManager_mnuRefresh_MouseClick()
	If IsObj($frmTalkClientManager) Then
		TalkClientManager_cboUsernames_ItemSelect()
	EndIf
EndFunc

Func TalkClientManager_mnuClose_MouseClick()
	If IsObj($frmTalkClientManager) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $aiSelectedItems = _GUICtrlListView_GetSelectedIndices($frmTalkClientManager.lvwTalkClientManager, True)
	If $aiSelectedItems[0] Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $iSocket = 0

	_GUICtrlListView_BeginUpdate($frmTalkClientManager.lvwTalkClientManager)
	For $i = $aiSelectedItems[0] To 1 Step -1
		$iSocket = _GUICtrlListView_GetItemParam($frmTalkClientManager.lvwTalkClientManager, $aiSelectedItems[$i])
		_GUICtrlListView_DeleteItem($frmTalkClientManager.lvwTalkClientManager, $aiSelectedItems[$i])
		$oGarenaTalk.CloseBySocket($iSocket)
	Next
	_GUICtrlListView_EndUpdate($frmTalkClientManager.lvwTalkClientManager)

	If _GUICtrlListView_GetItemCount($frmTalkClientManager.lvwTalkClientManager) Then
		; --- Nothing to do
	Else
		Local $sUsername = GUICtrlRead($frmTalkClientManager.cboUsernames)
		Local $iIndex = _GUICtrlComboBox_FindStringExact($frmTalkClientManager.cboUsernames, $sUsername)
		_GUICtrlComboBox_DeleteString($frmTalkClientManager.cboUsernames, $iIndex)
		If _GUICtrlComboBox_GetCount($frmTalkClientManager.cboUsernames) Then
			; --- Nothing to do
		Else
			_GUICtrlComboBox_ResetContent($frmTalkClientManager.cboUsernames)
		EndIf
	EndIf
EndFunc

Func TalkClientManager_LoadTalkClientManager($this, $sUsername)
	Local $aoTalkClients = $oGarenaTalk.GetAll()
	If $aoTalkClients = Null Then
		Return
	EndIf

	_GUICtrlComboBox_BeginUpdate($this.cboUsernames)
	For $oTalkClient In $aoTalkClients
		If _GUICtrlComboBox_FindStringExact($this.cboUsernames, $oTalkClient.Username) = -1 Then
			_GUICtrlComboBox_AddString($this.cboUsernames, $oTalkClient.Username)
		EndIf
	Next
	_GUICtrlComboBox_EndUpdate($this.cboUsernames)

	If $sUsername Then
		_GUICtrlComboBox_SelectString($this.cboUsernames, $sUsername)
		$frmTalkClientManager = $this
		TalkClientManager_cboUsernames_ItemSelect()
	EndIf
EndFunc

Func TalkClientManager_AddItem($this, $oTalkClient)
	Local $sServer = StringFormat('%02i', $oTalkClient.Server)

	Local $sTalkName = 'AFK Manager'

	Local $sExpiryDate = $oTalkClient.ExpiryDate
	If $sExpiryDate Then
		; --- Nothing to do
	Else
		$sExpiryDate = 'N/A'
	EndIf

	Local $sStatus = 'Connected'

	Local $iIndex = _GUICtrlListView_AddItem($this.lvwTalkClientManager, $sServer, -1, $oTalkClient.Socket)
	_GUICtrlListView_AddSubItem($this.lvwTalkClientManager, $iIndex, $sTalkName, 1)
	_GUICtrlListView_AddSubItem($this.lvwTalkClientManager, $iIndex, $sExpiryDate, 2)
	_GUICtrlListView_AddSubItem($this.lvwTalkClientManager, $iIndex, $sStatus, 3)
EndFunc