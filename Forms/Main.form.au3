#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func Main()
	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 720
	Local $HEIGHT = 480

	Local $hWnd = GUICreate($APP_NAME, $WIDTH + 2, $HEIGHT + 51, -1, -1, BitOR($WS_POPUP, $WS_MINIMIZEBOX), 0)
	GUISetBkColor(0xEFEFF2, $hWnd)
	GUISetFont(8.5, $FW_NORMAL, Default, 'Tahoma', $hWnd, $DEFAULT_QUALITY)
	GUISetOnEvent($GUI_EVENT_CLOSE, Main_btnClose_MouseClick, $hWnd)

	GUICtrlCreateLabel('', 0, 0, $WIDTH + 2, 1)
	GUICtrlSetBkColor(-1, 0x007ACC)

	GUICtrlCreateLabel('', $WIDTH + 1, 1, 1, $HEIGHT + 26)
	GUICtrlSetBkColor(-1, 0x007ACC)

	GUICtrlCreateLabel('', 0, $HEIGHT + 27, $WIDTH + 2, 24)
	GUICtrlSetBkColor(-1, 0x007ACC)

	GUICtrlCreateLabel('', 0, 1, 1, $HEIGHT + 26)
	GUICtrlSetBkColor(-1, 0x007ACC)

	GUICtrlCreatePicEx('ICON_PNG', 8, 8, 20, 16)

	GUICtrlCreateLabel($APP_NAME, 35, 1, $WIDTH - 353, 26 + 3, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetColor(-1, 0x717171)
	GUICtrlSetFont(-1, 12)

	GUICtrlCreateLabel('', $WIDTH - 33, 1, 34, 26)
	GUICtrlSetTip(-1, 'Close')
	GUICtrlSetMouseClick(-1, Main_btnClose_MouseClick)
	GUICtrlSetMouseDown(-1, Main_Button_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_Button_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Button_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_Button_MouseUp)
	GUICtrlCreatePicEx('CLOSE_PNG', $WIDTH - 33, 1, 34, 26)

	GUICtrlCreateLabel('', $WIDTH - 67, 1, 34, 26)
	GUICtrlSetTip(-1, 'Minimize to Tray')
	GUICtrlSetMouseClick(-1, Main_btnMinimizeToTray_MouseClick)
	GUICtrlSetMouseDown(-1, Main_Button_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_Button_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Button_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_Button_MouseUp)
	GUICtrlCreatePicEx('MINIMIZE_TO_TRAY_PNG', $WIDTH - 67, 1, 34, 26)

	GUICtrlCreateLabel('', $WIDTH - 101, 1, 34, 26)
	GUICtrlSetTip(-1, 'Minimize')
	GUICtrlSetMouseClick(-1, Main_btnMinimize_MouseClick)
	GUICtrlSetMouseDown(-1, Main_Button_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_Button_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Button_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_Button_MouseUp)
	GUICtrlCreatePicEx('MINIMIZE_PNG', $WIDTH - 101, 1, 34, 26)

	Local $txtSearch = GUICtrlCreateInput('', $WIDTH - 311, 5, 200, 20)
	GUICtrlSetLimit(-1, 16)
	GUICtrlSendMsg(-1, $EM_SETCUEBANNER, True, 'Username...')

	Local $lblStatusBar = GUICtrlCreateLabel('Ready', 11, $HEIGHT + 28, $WIDTH - 270, 22, $SS_CENTERIMAGE)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)

	Local $lblExpiryDateReminder = GUICtrlCreateLabel('', $WIDTH - 259, $HEIGHT + 28, 250, 22, BitOR($SS_RIGHT, $SS_CENTERIMAGE))
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $avMenuItem = 0, $iNextMenuItemX = 2

	$avMenuItem = GetStringSize('    ' & 'FILE' & '    ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avMenuItem[0], $iNextMenuItemX, 32, $avMenuItem[1], 16, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseDown(-1, Main_Menu_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_Menu_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Menu_MouseLeave)
	$iNextMenuItemX += $avMenuItem[1]

	Local $dumFile = GUICtrlCreateDummy()
	Local $mnuFile = GUICtrlCreateContextMenu($dumFile)
	GUICtrlCreateMenuItem('New Account' & @TAB & 'Ctrl+N', $mnuFile)
	GUICtrlSetOnEvent(-1, Main_mnuNewAccount_MouseClick)
	GUICtrlCreateMenuItem('', $mnuFile)
	GUICtrlCreateMenuItem('Save Account List' & @TAB & 'Ctrl+S', $mnuFile)
	GUICtrlSetOnEvent(-1, Main_mnuSaveAccountList_MouseClick)
	GUICtrlCreateMenuItem('Load Account List' & @TAB & 'Ctrl+O', $mnuFile)
	GUICtrlSetOnEvent(-1, Main_mnuLoadAccountList_MouseClick)
	GUICtrlCreateMenuItem('', $mnuFile)
	GUICtrlCreateMenuItem('Minimize to Tray', $mnuFile)
	GUICtrlSetOnEvent(-1, Main_btnMinimizeToTray_MouseClick)
	GUICtrlCreateMenuItem('Exit', $mnuFile)
	GUICtrlSetOnEvent(-1, Main_btnClose_MouseClick)

	$avMenuItem = GetStringSize('    ' & 'VIEW' & '    ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avMenuItem[0], $iNextMenuItemX, 32, $avMenuItem[1], 16, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseDown(-1, Main_Menu_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_Menu_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Menu_MouseLeave)
	$iNextMenuItemX += $avMenuItem[1]

	Local $dumView = GUICtrlCreateDummy()
	Local $mnuView = GUICtrlCreateContextMenu($dumView)
	GUICtrlCreateMenuItem('All Accounts', $mnuView, -1, 1)
	GUICtrlSetOnEvent(-1, Main_mnuAllAccounts_MouseClick)
	GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateMenuItem('Expired Accounts', $mnuView, -1, 1)
	GUICtrlSetOnEvent(-1, Main_mnuExpiredAccounts_MouseClick)
	GUICtrlCreateMenuItem('Unexpired Accounts', $mnuView, -1, 1)
	GUICtrlSetOnEvent(-1, Main_mnuUnexpiredAccounts_MouseClick)

	$avMenuItem = GetStringSize('    ' & 'TOOLS' & '    ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avMenuItem[0], $iNextMenuItemX, 32, $avMenuItem[1], 16, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseDown(-1, Main_Menu_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_Menu_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Menu_MouseLeave)
	$iNextMenuItemX += $avMenuItem[1]

	Local $dumTools = GUICtrlCreateDummy()
	Local $mnuTools = GUICtrlCreateContextMenu($dumTools)
	GUICtrlCreateMenuItem('Run Talk', $mnuTools)
	GUICtrlSetOnEvent(-1, Main_mnuRunTalk_MouseClick)
	GUICtrlCreateMenuItem('', $mnuTools)
	GUICtrlCreateMenuItem('EXP Calculator', $mnuTools)
	GUICtrlSetOnEvent(-1, Main_mnuExpCalculator_MouseClick)

	$avMenuItem = GetStringSize('    ' & 'MY ACCOUNT' & '    ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avMenuItem[0], $iNextMenuItemX, 32, $avMenuItem[1], 16, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseClick(-1, Main_mnuMyAccount_MouseClick)
	GUICtrlSetMouseEnter(-1, Main_Menu_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Menu_MouseLeave)
	$iNextMenuItemX += $avMenuItem[1]

	$avMenuItem = GetStringSize('    ' & 'HELP' & '    ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avMenuItem[0], $iNextMenuItemX, 32, $avMenuItem[1], 16, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseDown(-1, Main_Menu_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_Menu_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_Menu_MouseLeave)
	$iNextMenuItemX += $avMenuItem[1]

	Local $dumHelp = GUICtrlCreateDummy()
	Local $mnuHelp = GUICtrlCreateContextMenu($dumHelp)
	GUICtrlCreateMenuItem('View Help' & @TAB & 'F1', $mnuHelp)
	GUICtrlSetOnEvent(-1, Main_mnuViewHelp_MouseClick)
	GUICtrlCreateMenuItem('', $mnuHelp)
	GUICtrlCreateMenuItem('About AFK Manager', $mnuHelp)
	GUICtrlSetOnEvent(-1, Main_mnuAboutAfkManager_MouseClick)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlCreatePicEx('TOOLBAR_STRIP_PNG', 11, 55, 5, 17)

	Local $avToolbarItem = 0, $iNextToolbarItemX = 21

	GUICtrlCreateLabel('', $iNextToolbarItemX, 53, 22, 22, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetTip(-1, 'New Account')
	GUICtrlSetMouseClick(-1, Main_mnuNewAccount_MouseClick)
	GUICtrlSetMouseDown(-1, Main_ToolbarItem_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_ToolbarItem_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_ToolbarItem_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_ToolbarItem_MouseUp)
	GUICtrlCreatePicEx('NEW_ACCOUNT_PNG', $iNextToolbarItemX + 3, 53 + 3, 16, 16)
	$iNextToolbarItemX += 22 + 5

	GUICtrlCreatePicEx('TOOLBAR_SEPARATOR_PNG', $iNextToolbarItemX, 53 + 1, 2, 20)
	$iNextToolbarItemX += 2 + 5

	$avToolbarItem = GetStringSize('        ' & 'Garena Messenger' & ' ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avToolbarItem[0], $iNextToolbarItemX, 53, $avToolbarItem[1], 22, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseClick(-1, Main_lblGarenaMessenger_MouseClick)
	GUICtrlSetMouseDown(-1, Main_ToolbarItem_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_ToolbarItem_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_ToolbarItem_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_ToolbarItem_MouseUp)
	GUICtrlCreatePicEx('GARENA_MESSENGER_PNG', $iNextToolbarItemX + 3, 53 + 3, 16, 16)
	$iNextToolbarItemX += $avToolbarItem[1] + 5

	GUICtrlCreatePicEx('TOOLBAR_SEPARATOR_PNG', $iNextToolbarItemX, 53 + 1, 2, 20)
	$iNextToolbarItemX += 2 + 5

	$avToolbarItem = GetStringSize('        ' & 'Room Auto AFK' & ' ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avToolbarItem[0], $iNextToolbarItemX, 53, $avToolbarItem[1], 22, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseClick(-1, Main_lblRoomAutoAfk_MouseClick)
	GUICtrlSetMouseDown(-1, Main_ToolbarItem_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_ToolbarItem_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_ToolbarItem_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_ToolbarItem_MouseUp)
	GUICtrlCreatePicEx('ROOM_AUTO_AFK_PNG', $iNextToolbarItemX + 3, 53 + 3, 16, 16)
	$iNextToolbarItemX += $avToolbarItem[1] + 5

	GUICtrlCreateLabel('', $iNextToolbarItemX, 53, 22, 22, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetTip(-1, 'Room Client Manager')
	GUICtrlSetMouseClick(-1, Main_lblRoomClientManager_MouseClick)
	GUICtrlSetMouseDown(-1, Main_ToolbarItem_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_ToolbarItem_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_ToolbarItem_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_ToolbarItem_MouseUp)
	GUICtrlCreatePicEx('CLIENT_MANAGER_PNG', $iNextToolbarItemX + 3, 53 + 3, 16, 16)
	$iNextToolbarItemX += 22 + 5

	GUICtrlCreateLabel('', $iNextToolbarItemX, 53, 22, 22, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetTip(-1, 'Close All Room Clients')
	GUICtrlSetMouseClick(-1, Main_lblCloseAllRoomClients_MouseClick)
	GUICtrlSetMouseDown(-1, Main_ToolbarItem_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_ToolbarItem_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_ToolbarItem_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_ToolbarItem_MouseUp)
	GUICtrlCreatePicEx('CLOSE_ALL_CLIENTS_PNG', $iNextToolbarItemX + 3, 53 + 3, 16, 16)
	$iNextToolbarItemX += 22 + 5

	GUICtrlCreatePicEx('TOOLBAR_SEPARATOR_PNG', $iNextToolbarItemX, 53 + 1, 2, 20)
	$iNextToolbarItemX += 2 + 5

	$avToolbarItem = GetStringSize('        ' & 'Talk Auto AFK' & ' ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avToolbarItem[0], $iNextToolbarItemX, 53, $avToolbarItem[1], 22, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseClick(-1, Main_lblTalkAutoAfk_MouseClick)
	GUICtrlSetMouseDown(-1, Main_ToolbarItem_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_ToolbarItem_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_ToolbarItem_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_ToolbarItem_MouseUp)
	GUICtrlCreatePicEx('TALK_AUTO_AFK_PNG', $iNextToolbarItemX + 3, 53 + 3, 16, 16)
	$iNextToolbarItemX += $avToolbarItem[1] + 5

	GUICtrlCreateLabel('', $iNextToolbarItemX, 53, 22, 22, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetTip(-1, 'Talk Client Manager')
	GUICtrlSetMouseClick(-1, Main_lblTalkClientManager_MouseClick)
	GUICtrlSetMouseDown(-1, Main_ToolbarItem_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_ToolbarItem_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_ToolbarItem_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_ToolbarItem_MouseUp)
	GUICtrlCreatePicEx('CLIENT_MANAGER_PNG', $iNextToolbarItemX + 3, 53 + 3, 16, 16)
	$iNextToolbarItemX += 22 + 5

	GUICtrlCreateLabel('', $iNextToolbarItemX, 53, 22, 22, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetTip(-1, 'Close All Talk Clients')
	GUICtrlSetMouseClick(-1, Main_lblCloseAllTalkClients_MouseClick)
	GUICtrlSetMouseDown(-1, Main_ToolbarItem_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_ToolbarItem_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_ToolbarItem_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_ToolbarItem_MouseUp)
	GUICtrlCreatePicEx('CLOSE_ALL_CLIENTS_PNG', $iNextToolbarItemX + 3, 53 + 3, 16, 16)
	$iNextToolbarItemX += 22 + 5

	GUICtrlCreatePicEx('TOOLBAR_SEPARATOR_PNG', $iNextToolbarItemX, 53 + 1, 2, 20)
	$iNextToolbarItemX += 2 + 5

	$avToolbarItem = GetStringSize('        ' & 'SpamBot' & ' ', 8.5, $FW_NORMAL, 0, 'Tahoma')
	GUICtrlCreateLabel($avToolbarItem[0], $iNextToolbarItemX, 53, $avToolbarItem[1], 22, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0x1E1E1E)
	GUICtrlSetMouseClick(-1, Main_lblSpamBot_MouseClick)
	GUICtrlSetMouseDown(-1, Main_ToolbarItem_MouseDown)
	GUICtrlSetMouseEnter(-1, Main_ToolbarItem_MouseEnter)
	GUICtrlSetMouseLeave(-1, Main_ToolbarItem_MouseLeave)
	GUICtrlSetMouseUp(-1, Main_ToolbarItem_MouseUp)
	GUICtrlCreatePicEx('SPAMBOT_PNG', $iNextToolbarItemX + 3, 53 + 3, 16, 16)
	$iNextToolbarItemX += $avToolbarItem[1] + 5
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $lvwAccountList = GUICtrlCreateListView('', 1, 85, $WIDTH, $HEIGHT - 58, _
			$LVS_SHOWSELALWAYS, _
			BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_CHECKBOXES, $LVS_EX_INFOTIP))
	GUICtrlSetState(-1, $GUI_FOCUS)
	GUICtrlSetOnEvent(-1, Main_lvwAccountListHeader_MouseClick)

	Local $hAccountList = GUICtrlGetHandle(-1)

	Local $iX = 6, $iY = 3
	If @OSBuild >= 6000 Then
		_WinAPI_SetWindowTheme($hAccountList, 'Explorer')
		$iX = 4
		$iY = 4
	EndIf

	_GUICtrlListView_AddColumn($lvwAccountList, '', 25)
	_GUICtrlListView_AddColumn($lvwAccountList, 'Username', 145)
	_GUICtrlListView_AddColumn($lvwAccountList, 'Room Servers', 80)
	_GUICtrlListView_AddColumn($lvwAccountList, 'Room Name', 300)
	_GUICtrlListView_AddColumn($lvwAccountList, 'Talk Servers', 75)
	_GUICtrlListView_AddColumn($lvwAccountList, 'Expiry Date', 75)
	_GUICtrlListView_RegisterSortCallBack($lvwAccountList)

	Local $hHeader = _GUICtrlListView_GetHeader($lvwAccountList)
	Local $chkCheckAll = _GUICtrlButton_Create($hHeader, '', $iX, $iY, 13, 13, $BS_AUTOCHECKBOX)
	GUICtrlSetMouseClick($chkCheckAll, Main_chkCheckAll_MouseClick)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $keySearch = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, Main_keySearch)

	Local $keyViewHelp = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, Main_keyViewHelp)

	Local $keyNewAccount = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, Main_keyNewAccount)

	Local $keySaveAccountList = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, Main_mnuSaveAccountList_MouseClick)

	Local $keyLoadAccountList = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, Main_mnuLoadAccountList_MouseClick)

	Local $keySelectOrCheckAll = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, Main_keySelectOrCheckAll)

	Local $keyUncheckAll = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, Main_keyUncheckAll)

	Local $keyMoveUp = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, Main_keyMoveUp)

	Local $keyMoveDown = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, Main_keyMoveDown)

	Local $keyDelete = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, Main_keyDelete)

	Local $avAccelerators[][] = [['^f', $keySearch], _
			['{F1}', $keyViewHelp], _
			['^n', $keyNewAccount], _
			['^s', $keySaveAccountList], _
			['^o', $keyLoadAccountList], _
			['^a', $keySelectOrCheckAll], _
			['^d', $keyUncheckAll], _
			['!{UP}', $keyMoveUp], _
			['!{DOWN}', $keyMoveDown], _
			['^{DELETE}', $keyDelete]]
	GUISetAccelerators($avAccelerators, $hWnd)

	Local $oCheckInTimer = Timer(Main_CheckIn, $TIME_25_MINUTES)
	If @error Then
		Debug('Main.form | Timer() failed.', @ScriptLineNumber)
	EndIf

	Local $oTalkExpiryTimer = Timer(Main_TalkExpiryTimer, $TIME_8_HOURS)
	If @error Then
		Debug('Main.form | Timer() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('Main_Destructor')

		; --- Properties | Read-only
		.AddProperty('Handle', $ELSCOPE_READONLY, $hWnd)
		.AddProperty('lblStatusBar', $ELSCOPE_READONLY, $lblStatusBar)
		.AddProperty('txtSearch', $ELSCOPE_READONLY, $txtSearch)
		.AddProperty('txtSearchHandle', $ELSCOPE_READONLY, GUICtrlGetHandle($txtSearch))
		.AddProperty('lblExpiryDateReminder', $ELSCOPE_READONLY, $lblExpiryDateReminder)
		.AddProperty('lvwAccountList', $ELSCOPE_READONLY, $lvwAccountList)
		.AddProperty('lvwAccountListHandle', $ELSCOPE_READONLY, $hAccountList)
		.AddProperty('chkCheckAllHandle', $ELSCOPE_READONLY, $chkCheckAll)
		.AddProperty('StatusTimer', $ELSCOPE_READONLY, 0)
		.AddProperty('StatusDuration', $ELSCOPE_READONLY, 0)
		.AddProperty('CheckInTimer', $ELSCOPE_READONLY, $oCheckInTimer)
		.AddProperty('TalkExpiryTimer', $ELSCOPE_READONLY, $oTalkExpiryTimer)

		; --- Properties | Public
		.AddProperty('StatusReset', $ELSCOPE_PUBLIC, False)
		.AddProperty('AccountType', $ELSCOPE_PUBLIC, $oAccounts.Type['All'])

		; --- Methods | Public
		.AddMethod('LoadAccounts', 'Main_LoadAccounts', False)
		.AddMethod('AddAccount', 'Main_AddAccount', False)
		.AddMethod('CheckedAccounts', 'Main_CheckedAccounts', False)
		.AddMethod('ExpiryDateReminder', 'Main_ExpiryDateReminder', False)
		.AddMethod('Status', 'Main_Status', False)
	EndWith
	Local $this = $oClass.Object
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	$this.LoadAccounts($this.AccountType)
	$this.ExpiryDateReminder()

	GUIRegisterMsg($WM_COMMAND, Main_WM_COMMAND)
	GUIRegisterMsg($WM_CONTEXTMENU, Main_WM_CONTEXTMENU)
	GUIRegisterMsg($WM_HSCROLL, Main_WM_HSCROLL)
	GUIRegisterMsg($WM_NOTIFY, Main_WM_NOTIFY)

	AdlibRegister(Main_StatusClean, 1000)
	GUISetState(@SW_SHOW, $hWnd)
	$frmLogin = Null

	Return $this
	;
	;---------------------------------------------------------------------------
EndFunc

Func Main_Destructor($this)
	_GUICtrlListView_UnRegisterSortCallBack($this.lvwAccountList)
	$this.TalkExpiryTimer.Enabled = False
	$this.CheckInTimer.Enabled = False
	AdlibUnRegister(Main_StatusClean)
	GUIUnsetMouseEvents($this.Handle)
	GUIDelete($this.Handle)

	For $iPid In $mTalkProcessId
		If ProcessExists($iPid) Then
			ProcessClose($iPid)
		EndIf
	Next

	Exit
EndFunc

Func Main_Button_MouseDown($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0x007ACC)
EndFunc

Func Main_Button_MouseEnter($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xFEFEFE)
EndFunc

Func Main_Button_MouseLeave($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xEFEFF2)
EndFunc

Func Main_Button_MouseUp($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xFEFEFE)
EndFunc

Func Main_btnClose_MouseClick()
	If IsObj($frmMain) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	If $oGarenaRoom.Count Or $oGarenaTalk.Count Then
		If $oMessage.YesNo('All clients will be closed. Continue?', $frmMain, True) Then
			; --- Nothing to do
		Else
			Return
		EndIf
	EndIf

	$frmMain.Status('Logging out...')

	Local $iRetryCount = 1
	While True
		If $oServer.Logout() = $oServer.Result.Success Then
			ExitLoop
		EndIf

		If $iRetryCount < 5 Then
			Sleep($iRetryCount * 1000)
			$iRetryCount += 1
		Else
			ExitLoop
		EndIf
	WEnd

	$oGarenaRoom.CloseAll()
	$oGarenaTalk.CloseAll()
	$frmMain = Null
EndFunc

Func Main_btnMinimizeToTray_MouseClick()
	GUISetState(@SW_HIDE, $frmMain.Handle)
	Opt('TrayIconHide', 0)

	TraySetToolTip($APP_NAME)
	TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, Main_TrayIcon_MouseClick)
EndFunc

Func Main_btnMinimize_MouseClick()
	GUISetState(@SW_MINIMIZE, $frmMain.Handle)
EndFunc

Func Main_TrayIcon_MouseClick()
	Opt('TrayIconHide', 1)
	GUISetState(@SW_SHOW, $frmMain.Handle)

	TraySetOnEvent($TRAY_EVENT_PRIMARYDOWN, Null)
EndFunc

Func Main_Menu_MouseDown($mParam)
	Local $aiCtrlPos = ControlGetPos($mParam['hWnd'], '', $mParam['Id'])

	Local $tPoint = DllStructCreate($tagPOINT)
	$tPoint.X = $aiCtrlPos[0]
	$tPoint.Y = $aiCtrlPos[1] + $aiCtrlPos[3]

	_WinAPI_ClientToScreen($mParam['hWnd'], $tPoint)

	DllCall('user32.dll', 'BOOL', 'TrackPopupMenuEx', _
			'HANDLE', GUICtrlGetHandle($mParam['Id'] + 2), _
			'UINT', 0, _
			'INT', $tPoint.X, _
			'INT', $tPoint.Y, _
			'HWND', $mParam['hWnd'], _
			'PTR', 0)
EndFunc

Func Main_Menu_MouseEnter($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xFEFEFE)
EndFunc

Func Main_Menu_MouseLeave($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xEFEFF2)
EndFunc

Func Main_mnuNewAccount_MouseClick()
	$frmNewAccount = NewAccount()
EndFunc

Func Main_mnuSaveAccountList_MouseClick()
	If $oAccounts.Count Then
		; --- Nothing to do
	Else
		$oMessage.Warning('Account list is empty.', $frmMain)
		Return
	EndIf

	Local $sWorkingDirectory = @WorkingDir
	Local $sFileName = StringFormat('Accounts %u%02u%02u%02u%02u%02u', @YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC)

	Local $sFilePath = FileSaveDialog('Save Account List', '', $APP_NAME & ' Accounts (*.gpd)', BitOR($FD_PATHMUSTEXIST, $FD_PROMPTOVERWRITE), $sFileName, $frmMain.Handle)
	If @error Then
		Return
	EndIf

	FileChangeDir($sWorkingDirectory)

	If FileCopy($oAccounts.DatabasePath, $sFilePath) Then
		$frmMain.Status('Account list saved.')
	Else
		$oMessage.Error('Unable to save the file.' & @CRLF & 'Make sure you have selected a valid path.', $frmMain)
	EndIf
EndFunc

Func Main_mnuLoadAccountList_MouseClick()
	Local $sWorkingDirectory = @WorkingDir

	Local $sDatabasePath = FileOpenDialog('Load Account List', '', $APP_NAME & ' Accounts (*.gpd)', BitOR($FD_FILEMUSTEXIST, $FD_PATHMUSTEXIST), '', $frmMain.Handle)
	If @error Then
		Return
	EndIf

	FileChangeDir($sWorkingDirectory)

	Local $fReplace = True
	If $oAccounts.Count Then
		$fReplace = $oMessage.YesNo('Do you want to replace duplicate accounts?', $frmMain, True)
	EndIf

	Local $iCount = $oAccounts.Import($sDatabasePath, $fReplace)
	If $iCount Then
		$frmMain.LoadAccounts($oAccounts.Type['All'], GUICtrlRead($frmMain.txtSearch))
		$frmMain.Status($iCount & ' account(s) successfully loaded.')
	Else
		Switch $oAccounts.LastError
			Case 1
				$oMessage.Warning('The selected database is invalid.', $frmMain)

			Case 2
				$oMessage.Warning('The selected database is empty.', $frmMain)
		EndSwitch
	EndIf
EndFunc

Func Main_mnuAllAccounts_MouseClick()
	$frmMain.AccountType = $oAccounts.Type['All']
	$frmMain.LoadAccounts($frmMain.AccountType, GUICtrlRead($frmMain.txtSearch))
EndFunc

Func Main_mnuExpiredAccounts_MouseClick()
	$frmMain.AccountType = $oAccounts.Type['Expired']
	$frmMain.LoadAccounts($frmMain.AccountType, GUICtrlRead($frmMain.txtSearch))
EndFunc

Func Main_mnuUnexpiredAccounts_MouseClick()
	$frmMain.AccountType = $oAccounts.Type['Unexpired']
	$frmMain.LoadAccounts($frmMain.AccountType, GUICtrlRead($frmMain.txtSearch))
EndFunc

Func Main_mnuRunTalk_MouseClick()
	Local $sGarenaPlusPath = GarenaPlusPath()

	Local $sWorkingDirectory = $sGarenaPlusPath & '\bbtalk'
	Local $sFileName = $sWorkingDirectory & '\BBTalk.exe'
	Local $sParameters = '-ignoreupdate -ignoreautologin -multiinstance'

	Local $iPid = ShellExecute($sFileName, $sParameters, $sWorkingDirectory)
	If @error Then
		$oMessage.Error('Unable to run BBTalk.exe', $frmMain)
	EndIf

	MapAppend($mTalkProcessId, $iPid)
EndFunc

Func Main_mnuExpCalculator_MouseClick()
	$frmExpCalculator = ExpCalculator()
EndFunc

Func Main_mnuMyAccount_MouseClick()
	$frmMyAccount = MyAccount()
EndFunc

Func Main_mnuViewHelp_MouseClick()
	ShellExecute($URL_FAQ)
EndFunc

Func Main_mnuAboutAfkManager_MouseClick()
	$frmAbout = About()
EndFunc

Func Main_ToolbarItem_MouseDown($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0x007ACC)
	GUICtrlSetColor($mParam['Id'], 0xFFFFFF)
EndFunc

Func Main_ToolbarItem_MouseEnter($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xFEFEFE)
EndFunc

Func Main_ToolbarItem_MouseLeave($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xEFEFF2)
	GUICtrlSetColor($mParam['Id'], 0x1E1E1E)
EndFunc

Func Main_ToolbarItem_MouseUp($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xFEFEFE)
	GUICtrlSetColor($mParam['Id'], 0x1E1E1E)
EndFunc

Func Main_lblGarenaMessenger_MouseClick()
	If GarenaPlusPath() Then
		; --- Nothing to do
	Else
		$oMessage.Error('Unable to find Garena Plus path.', $frmMain)
		Return
	EndIf

	If $oGarena.RunMessenger() Then
		$frmMain.Status('Garena Messenger successfully launched.')
	Else
		$oMessage.Error('Unable to run Garena Messenger.' & @CRLF & @CRLF & _
				'- Make sure you have specified a valid path to Garena Plus.' & @CRLF & _
				"- Make sure 'GarenaMessenger.exe' exists in the specified path." & @CRLF & _
				'- Make sure your computer has enough available memory (Ram) to run Garena Messenger.' & @CRLF & _
				'- Reinstall both AFK Manager and Garena Plus and make sure you have the latest version of them.' & @CRLF & @CRLF & _
				'If none of the above statements help, please contact support.', $frmMain)
	EndIf
EndFunc

Func Main_lblRoomAutoAfk_MouseClick()
	If IsObj($frmMain) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	If GarenaPlusPath() Then
		; --- Nothing to do
	Else
		$oMessage.Error('Unable to find Garena Plus path.', $frmMain)
		Return
	EndIf

	Local $asCheckedUsernames = $frmMain.CheckedAccounts()
	If $asCheckedUsernames = -1 Then
		$oMessage.Warning('Account list is empty.', $frmMain)
		Return
	ElseIf $asCheckedUsernames = -2 Then
		$oMessage.Warning('Please select account(s) for Room Auto AFK.', $frmMain)
		Return
	EndIf

	$frmAutoAfkProgress = Null
	$frmAutoAfkProgress = AutoAfkProgress($frmMain, 'Room Auto AFK')

	Local $sToday = @YEAR & '-' & @MON & '-' & @MDAY

	Local $mAccount[], $oClient = Null
	Local $iRoomServers = 0, $iResult = 1

	UpdateGarenaRoom()

	For $sUsername In $asCheckedUsernames
		If $frmAutoAfkProgress.Interrupt Then
			$oClient.Close()
			$iResult = 2
			ExitLoop 3
		EndIf

		$frmAutoAfkProgress.Log($sUsername, False)

		$mAccount = $oAccounts.GetByUsername($sUsername)
		If IsMap($mAccount) Then
			; --- Nothing to do
		Else
			$frmAutoAfkProgress.Log('Unable to read account: ' & $oAccounts.LastError)
			ContinueLoop
		EndIf

		If $mAccount['ExpiryDate'] And $mAccount['ExpiryDate'] < $sToday Then
			$frmAutoAfkProgress.Log('This account has passed its expiry date.')
			ContinueLoop
		EndIf

		$iRoomServers = $oServer.GarenaRoomServerCount < $mAccount['RoomServers'] ? $oServer.GarenaRoomServerCount : $mAccount['RoomServers']

		For $iServer = 1 To $iRoomServers
			If $frmAutoAfkProgress.Interrupt Then
				$iResult = 2
				ExitLoop 2
			EndIf

			If $oGarenaRoom.IsRunningInServer($sUsername, $iServer) Then
				$frmAutoAfkProgress.Log($iServer & '/' & $iRoomServers & ' already running...')
				ContinueLoop
			EndIf

			$oClient = $oGarena.RunRoom($mAccount, $iServer)
			If $oClient = Null Then
				$iResult = 3
				ExitLoop 2
			EndIf

			Do
				If $frmAutoAfkProgress.Interrupt Then
					$oClient.Close()
					$iResult = 2
					ExitLoop 3
				EndIf

				If $oClient.IsAlive() Then
					; --- Nothing to do
				Else
					$oClient.Close()
					$iResult = 3
					ExitLoop 3
				EndIf

				If $oClient.IsPasswordWrong Then
					$oClient.Close()
					$frmAutoAfkProgress.Log('Invalid username and/or password.')
					ExitLoop 2
				EndIf

				Sleep(250)
			Until $oClient.IsLoggedIn

			$frmAutoAfkProgress.Log($iServer & '/' & $iRoomServers)
		Next
	Next

	If $iResult = 1 Then
		$frmAutoAfkProgress.Log('Room Auto AFK finished.', False)
		$frmAutoAfkProgress.Finilize()
	ElseIf $iResult = 2 Then
		$frmAutoAfkProgress = 0
		$oMessage.Warning('Room Auto AFK has been interrupted by user.', $frmMain)
	ElseIf $iResult = 3 Then
		$frmAutoAfkProgress.Log('Room Auto AFK failed.', False)
		$frmAutoAfkProgress.Finilize()
		$oMessage.Error('Unable to run Garena Room.' & @CRLF & @CRLF & _
				'- Make sure you have specified a valid path to Garena Plus.' & @CRLF & _
				"- Make sure 'garena_room.exe' exists in the specified path (In the 'Room' folder)." & @CRLF & _
				'- Make sure your computer has enough available memory (Ram) to run Garena Room.' & @CRLF & _
				'- Reinstall both AFK Manager and Garena Plus and make sure you have the latest version of them.' & @CRLF & @CRLF & _
				'If none of the above statements help, please contact support.', $frmMain)
	EndIf
EndFunc

Func Main_lblRoomClientManager_MouseClick()
	Local $sUsername = ''
	If _GUICtrlListView_GetSelectedCount($frmMain.lvwAccountList) Then
		Local $aiSelectedItems = _GUICtrlListView_GetSelectedIndices($frmMain.lvwAccountList, True)
		If $aiSelectedItems[0] Then
			$sUsername = _GUICtrlListView_GetItemText($frmMain.lvwAccountList, $aiSelectedItems[1], 1)
		EndIf
	EndIf

	$frmRoomClientManager = RoomClientManager($sUsername)
EndFunc

Func Main_lblCloseAllRoomClients_MouseClick()
	If IsObj($frmMain) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	If $oGarenaRoom.Count Then
		If $oMessage.YesNo('All clients will be closed. Continue?', $frmMain, True) Then
			; --- Nothing to do
		Else
			Return
		EndIf
	Else
		$oMessage.Warning('No client found.', $frmMain)
		Return
	EndIf

	$frmMain.Status('Closing all room clients...')
	Local $iClosedClients = $oGarenaRoom.CloseAll()
	$frmMain.Status($iClosedClients & ' client(s) successfully closed.')
EndFunc

Func Main_lblTalkAutoAfk_MouseClick()
	If IsObj($frmMain) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $asCheckedUsernames = $frmMain.CheckedAccounts()
	If $asCheckedUsernames = -1 Then
		$oMessage.Warning('Account list is empty.', $frmMain)
		Return
	ElseIf $asCheckedUsernames = -2 Then
		$oMessage.Warning('Please select account(s) for Talk Auto AFK.', $frmMain)
		Return
	EndIf

	Run('ipconfig /flushdns', '', @SW_HIDE)
	Local $sTalkAuthServerIp = TCPNameToIP('auth.gtalk.garenanow.com')
	If @error Then
		$oMessage.Error('Unable to resolve host name.', $frmMain)
		Return
	EndIf

	$frmAutoAfkProgress = Null
	$frmAutoAfkProgress = AutoAfkProgress($frmMain, 'Talk Auto AFK')

	Local $sToday = @YEAR & '-' & @MON & '-' & @MDAY

	Local $mAccount[], $iSocket, $iUsernameLen, $tLoginRequest, $iBufferLen, $tBuffer, $iMessageLen
	Local $dMessageLen, $dBuffer, $dMessageType, $iTokenLen, $dToken, $iNicknameLen, $tChannelRequest
	Local $iTalkServers = 0, $iResult = 1

	For $sUsername In $asCheckedUsernames
		If $frmAutoAfkProgress.Interrupt Then
			$iResult = 2
			ExitLoop
		EndIf

		$frmAutoAfkProgress.Log($sUsername, False)

		$mAccount = $oAccounts.GetByUsername($sUsername)
		If IsMap($mAccount) Then
			; --- Nothing to do
		Else
			$frmAutoAfkProgress.Log('Unable to read account: ' & $oAccounts.LastError)
			ContinueLoop
		EndIf

		If $mAccount['ExpiryDate'] And $mAccount['ExpiryDate'] < $sToday Then
			$frmAutoAfkProgress.Log('This account has passed its expiry date.')
			ContinueLoop
		EndIf

		$iSocket = TCPConnect($sTalkAuthServerIp, 9200)
		If @error Then
			$frmAutoAfkProgress.Log('Unable to connect to auth server.')
			ContinueLoop
		EndIf

		If $frmAutoAfkProgress.Interrupt Then
			TCPCloseSocket($iSocket)
			$iResult = 2
			ExitLoop
		EndIf

		$iUsernameLen = StringLen($sUsername)

		$tLoginRequest = DllStructCreate( _
				'DWORD MessageLen;' & _
				'BYTE MessageType[2];' & _
				'BYTE UsernameLen;' & _
				'CHAR Username[' & $iUsernameLen & '];' & _
				'BYTE Unknown1[2];' & _
				'CHAR Password[32];' & _
				'BYTE Unknown2[8]')

		DllStructSetData($tLoginRequest, 'MessageLen', 45 + $iUsernameLen)
		DllStructSetData($tLoginRequest, 'MessageType', Binary('0x020A'))
		DllStructSetData($tLoginRequest, 'UsernameLen', $iUsernameLen)
		DllStructSetData($tLoginRequest, 'Username', $sUsername)
		DllStructSetData($tLoginRequest, 'Unknown1', Binary('0x1220'))
		DllStructSetData($tLoginRequest, 'Password', $mAccount['Password'])
		DllStructSetData($tLoginRequest, 'Unknown2', Binary('0x180122013128E44F'))

		$iBufferLen = DllStructGetSize($tLoginRequest)
		$tBuffer = DllStructCreate('BYTE[' & $iBufferLen & ']', DllStructGetPtr($tLoginRequest))

		If TCPSend($iSocket, DllStructGetData($tBuffer, 1)) <> $iBufferLen Then
			TCPCloseSocket($iSocket)
			$frmAutoAfkProgress.Log('Unable to send request.')
			ContinueLoop
		EndIf

		If $frmAutoAfkProgress.Interrupt Then
			TCPCloseSocket($iSocket)
			$iResult = 2
			ExitLoop
		EndIf

		$dMessageLen = TCPRecv($iSocket, 4, 1)
		If @error Then
			TCPCloseSocket($iSocket)
			$frmAutoAfkProgress.Log('Unable to receive response length.')
			ContinueLoop
		EndIf

		If $frmAutoAfkProgress.Interrupt Then
			TCPCloseSocket($iSocket)
			$iResult = 2
			ExitLoop
		EndIf

		$iMessageLen = Int($dMessageLen, 1)

		If $iMessageLen = 3 Then
			TCPCloseSocket($iSocket)
			$frmAutoAfkProgress.Log($sUsername & ' - Invalid username and/or password.')
			ContinueLoop
		EndIf

		$dBuffer = TCPRecv($iSocket, $iMessageLen, 1)
		If @error Then
			TCPCloseSocket($iSocket)
			$frmAutoAfkProgress.Log('Unable to receive response.')
			ContinueLoop
		EndIf

		If $frmAutoAfkProgress.Interrupt Then
			TCPCloseSocket($iSocket)
			$iResult = 2
			ExitLoop
		EndIf

		If BinaryLen($dBuffer) <> $iMessageLen Then
			TCPCloseSocket($iSocket)
			$frmAutoAfkProgress.Log('Invalid response received.')
			ContinueLoop
		EndIf

		$dMessageLen = TCPRecv($iSocket, 4, 1)
		If @error Then
			TCPCloseSocket($iSocket)
			$frmAutoAfkProgress.Log('Unable to receive final response length.')
			ContinueLoop
		EndIf

		If $frmAutoAfkProgress.Interrupt Then
			TCPCloseSocket($iSocket)
			$iResult = 2
			ExitLoop
		EndIf

		$dMessageType = TCPRecv($iSocket, 2, 1)
		If @error Then
			TCPCloseSocket($iSocket)
			$frmAutoAfkProgress.Log('Unable to receive response type.')
			ContinueLoop
		EndIf

		If $frmAutoAfkProgress.Interrupt Then
			TCPCloseSocket($iSocket)
			$iResult = 2
			ExitLoop
		EndIf

		If $dMessageType <> Binary('0x300A') Then
			TCPCloseSocket($iSocket)
			$frmAutoAfkProgress.Log('Invalid response type received.')
			ContinueLoop
		EndIf

		$iTokenLen = Int($dMessageLen, 1) - 2

		$dToken = TCPRecv($iSocket, $iTokenLen, 1)
		If @error Then
			TCPCloseSocket($iSocket)
			$frmAutoAfkProgress.Log('Unable to receive token.')
			ContinueLoop
		EndIf

		TCPCloseSocket($iSocket)

		If $frmAutoAfkProgress.Interrupt Then
			$iResult = 2
			ExitLoop
		EndIf

		$iTalkServers = $oServer.GarenaTalkServerCount < $mAccount['TalkServers'] ? $oServer.GarenaTalkServerCount : $mAccount['TalkServers']

		For $iServer = 1 To $iTalkServers
			If $frmAutoAfkProgress.Interrupt Then
				$iResult = 2
				ExitLoop 2
			EndIf

			If $oGarenaTalk.IsRunning($sUsername, $iServer) Then
				$frmAutoAfkProgress.Log($iServer & '/' & $iTalkServers & ' already running...')
				ContinueLoop
			EndIf

			$iSocket = TCPConnect($oServer.GarenaTalkServers[$iServer - 1], 30000)
			If @error Then
				$frmAutoAfkProgress.Log('Unable to connect to channel server.')
				ContinueLoop
			EndIf

			$iNicknameLen = StringLen('AFK Manager')
			$iMessageLen = 32 + $iTokenLen + $iNicknameLen

			$tChannelRequest = DllStructCreate( _
					'DWORD MessageLen;' & _
					'BYTE MessageType[2];' & _
					'BYTE Token[' & $iTokenLen & '];' & _
					'BYTE Unknown1[11];' & _
					'BYTE NicknameLen;' & _
					'CHAR Nickname[' & $iNicknameLen & '];' & _
					'BYTE Unknown2[18]')

			DllStructSetData($tChannelRequest, 'MessageLen', $iMessageLen)
			DllStructSetData($tChannelRequest, 'MessageType', Binary('0x010A'))
			DllStructSetData($tChannelRequest, 'Token', $dToken)
			DllStructSetData($tChannelRequest, 'Unknown1', Binary('0x10EF9B870418E44F20013A'))
			DllStructSetData($tChannelRequest, 'NicknameLen', $iNicknameLen)
			DllStructSetData($tChannelRequest, 'Nickname', 'AFK Manager')
			DllStructSetData($tChannelRequest, 'Unknown2', Binary('0x421033313361383762393662643366383032'))

			$iBufferLen = DllStructGetSize($tChannelRequest)
			$tBuffer = DllStructCreate('BYTE[' & $iBufferLen & ']', DllStructGetPtr($tChannelRequest))

			If TCPSend($iSocket, DllStructGetData($tBuffer, 1)) <> $iBufferLen Then
				TCPCloseSocket($iSocket)
				$frmAutoAfkProgress.Log('Unable to send channel request.')
				ContinueLoop
			EndIf

			$dMessageLen = TCPRecv($iSocket, 4, 1)
			If @error Then
				TCPCloseSocket($iSocket)
				$frmAutoAfkProgress.Log('Unable to receive channel response length.')
				ContinueLoop
			EndIf

			$iMessageLen = Int($dMessageLen, 1)

			$dBuffer = TCPRecv($iSocket, $iMessageLen, 1)
			If @error Then
				TCPCloseSocket($iSocket)
				$frmAutoAfkProgress.Log('Unable to receive channel response.')
				ContinueLoop
			EndIf

			If BinaryLen($dBuffer) <> $iMessageLen Then
				TCPCloseSocket($iSocket)
				$frmAutoAfkProgress.Log('Invalid channel response received.')
				ContinueLoop
			EndIf

			$oGarenaTalk.Add($iSocket, $mAccount, $iServer)
			$frmAutoAfkProgress.Log($iServer & '/' & $iTalkServers)
		Next
	Next

	If $iResult = 1 Then
		$frmAutoAfkProgress.Log('Talk Auto AFK finished.', False)
		$frmAutoAfkProgress.Finilize()
	ElseIf $iResult = 2 Then
		$frmAutoAfkProgress = 0
		$oMessage.Warning('Talk Auto AFK has been interrupted by user.', $frmMain)
	EndIf
EndFunc

Func Main_lblTalkClientManager_MouseClick()
	Local $sUsername = ''
	If _GUICtrlListView_GetSelectedCount($frmMain.lvwAccountList) Then
		Local $aiSelectedItems = _GUICtrlListView_GetSelectedIndices($frmMain.lvwAccountList, True)
		If $aiSelectedItems[0] Then
			$sUsername = _GUICtrlListView_GetItemText($frmMain.lvwAccountList, $aiSelectedItems[1], 1)
		EndIf
	EndIf

	$frmTalkClientManager = TalkClientManager($sUsername)
EndFunc

Func Main_lblCloseAllTalkClients_MouseClick()
	If IsObj($frmMain) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	If $oGarenaTalk.Count Then
		If $oMessage.YesNo('All clients will be closed. Continue?', $frmMain, True) Then
			; --- Nothing to do
		Else
			Return
		EndIf
	Else
		$oMessage.Warning('No client found.', $frmMain)
		Return
	EndIf

	$frmMain.Status('Closing all talk clients...')
	Local $iClosedClients = $oGarenaTalk.CloseAll()
	$frmMain.Status($iClosedClients & ' client(s) successfully closed.')
EndFunc

Func Main_lblSpamBot_MouseClick()
	$frmSpamBot = SpamBot()
EndFunc

Func Main_chkCheckAll_MouseClick()
	Local $iCount = _GUICtrlListView_GetItemCount($frmMain.lvwAccountList)
	If $iCount Then
		Local $bCheck = _GUICtrlButton_GetCheck(HWnd($frmMain.chkCheckAllHandle)) = $BST_CHECKED

		_GUICtrlListView_BeginUpdate($frmMain.lvwAccountList)
		For $i = 0 To $iCount - 1
			_GUICtrlListView_SetItemChecked($frmMain.lvwAccountList, $i, $bCheck)
		Next
		_GUICtrlListView_EndUpdate($frmMain.lvwAccountList)
	EndIf
EndFunc

Func Main_lvwAccountListHeader_MouseClick()
	_GUICtrlListView_SortItems($frmMain.lvwAccountList, GUICtrlGetState($frmMain.lvwAccountList))
EndFunc

Func Main_keySearch()
	GUICtrlSetState($frmMain.txtSearch, $GUI_FOCUS)
EndFunc

Func Main_keyViewHelp()
	Main_mnuViewHelp_MouseClick()
EndFunc

Func Main_keyNewAccount()
	Main_mnuNewAccount_MouseClick()
EndFunc

Func Main_keySelectOrCheckAll()
	If _WinAPI_GetFocus() = $frmMain.txtSearchHandle Then
		_GUICtrlEdit_SetSel($frmMain.txtSearch, 0, -1)
	Else
		Local $iCount = _GUICtrlListView_GetItemCount($frmMain.lvwAccountList)
		If $iCount Then
			_GUICtrlButton_SetCheck(HWnd($frmMain.chkCheckAllHandle), $BST_CHECKED)

			_GUICtrlListView_BeginUpdate($frmMain.lvwAccountList)
			For $i = 0 To $iCount - 1
				_GUICtrlListView_SetItemChecked($frmMain.lvwAccountList, $i, True)
			Next
			_GUICtrlListView_EndUpdate($frmMain.lvwAccountList)
		EndIf
	EndIf
EndFunc

Func Main_keyUncheckAll()
	Local $iCount = _GUICtrlListView_GetItemCount($frmMain.lvwAccountList)
	If $iCount Then
		_GUICtrlButton_SetCheck(HWnd($frmMain.chkCheckAllHandle), $BST_UNCHECKED)

		_GUICtrlListView_BeginUpdate($frmMain.lvwAccountList)
		For $i = 0 To $iCount - 1
			_GUICtrlListView_SetItemChecked($frmMain.lvwAccountList, $i, False)
		Next
		_GUICtrlListView_EndUpdate($frmMain.lvwAccountList)
	EndIf
EndFunc

Func Main_keyMoveUp()
	If IsObj($frmMain) Then
		GUICtrlListView_MoveItem($frmMain.lvwAccountList, False)
	EndIf
EndFunc

Func Main_keyMoveDown()
	If IsObj($frmMain) Then
		GUICtrlListView_MoveItem($frmMain.lvwAccountList, True)
	EndIf
EndFunc

Func Main_keyDelete()
	Main_mnuDelete_MouseClick()
EndFunc

Func Main_WM_COMMAND($hWnd, $uMsg, $wParam, $lParam)
	If IsObj($frmMain) Then
		AutoAfkProgress_WM_COMMAND($hWnd, $uMsg, $wParam, $lParam)
		RoomClientManager_WM_COMMAND($hWnd, $uMsg, $wParam, $lParam)
		SpamBot_WM_COMMAND($hWnd, $uMsg, $wParam, $lParam)
		TalkClientManager_WM_COMMAND($hWnd, $uMsg, $wParam, $lParam)

		If $hWnd = $frmMain.Handle Then
			If _WinAPI_HiWord($wParam) = $EN_CHANGE And _WinAPI_LoWord($wParam) = $frmMain.txtSearch Then
				$frmMain.LoadAccounts($frmMain.AccountType, GUICtrlRead($frmMain.txtSearch))
			EndIf
		EndIf

		Return $GUI_RUNDEFMSG
	EndIf
EndFunc

Func Main_WM_CONTEXTMENU($hWnd, $uMsg, $wParam, $lParam)
	If IsObj($frmMain) Then
		; --- Nothing to do
	Else
		Return $GUI_RUNDEFMSG
	EndIf

	Enum $MNU_EDIT = 1000, $MNU_DELETE, $MNU_CLOSE_ROOM_CLIENTS, $MNU_CLOSE_TALK_CLIENTS

	RoomClientManager_WM_CONTEXTMENU($hWnd, $uMsg, $wParam, $lParam)
	TalkClientManager_WM_CONTEXTMENU($hWnd, $uMsg, $wParam, $lParam)

	Local $tPoint = DllStructCreate($tagPOINT)
	$tPoint.X = MouseGetPos(0)
	$tPoint.Y = MouseGetPos(1)

	Local $hCtrl = _WinAPI_WindowFromPoint($tPoint)
	If $hCtrl <> $frmMain.lvwAccountListHandle Then
		Return $GUI_RUNDEFMSG
	EndIf

	Local $hMenu = _GUICtrlMenu_CreatePopup($MNS_AUTODISMISS)

	Local $aHit = _GUICtrlListView_HitTest($hCtrl)
	If $aHit[1] Or Not $aHit[3] Then
		Return $GUI_RUNDEFMSG
	EndIf

	_GUICtrlMenu_AddMenuItem($hMenu, 'Edit', $MNU_EDIT)
	_GUICtrlMenu_AddMenuItem($hMenu, 'Delete' & @TAB & 'Ctrl+Delete', $MNU_DELETE)
	_GUICtrlMenu_AddMenuItem($hMenu, '')
	_GUICtrlMenu_AddMenuItem($hMenu, 'Close Room Clients', $MNU_CLOSE_ROOM_CLIENTS)
	_GUICtrlMenu_AddMenuItem($hMenu, 'Close Talk Clients', $MNU_CLOSE_TALK_CLIENTS)

	Local $iMenuItem = _GUICtrlMenu_TrackPopupMenu($hMenu, $hCtrl, -1, -1, 1, 1, 3, 1)
	_GUICtrlMenu_DestroyMenu($hMenu)

	Switch $iMenuItem
		Case $MNU_EDIT
			Main_mnuEdit_MouseClick($aHit[0])

		Case $MNU_DELETE
			Main_mnuDelete_MouseClick()

		Case $MNU_CLOSE_ROOM_CLIENTS
			Main_mnuCloseClients_MouseClick(True)

		Case $MNU_CLOSE_TALK_CLIENTS
			Main_mnuCloseClients_MouseClick(False)
	EndSwitch

	Return $GUI_RUNDEFMSG
EndFunc

Func Main_WM_HSCROLL($hWnd, $uMsg, $wParam, $lParam)
	If IsObj($frmMain) Then
		EditAccount_WM_HSCROLL($hWnd, $uMsg, $wParam, $lParam)
		ExpCalculator_WM_HSCROLL($hWnd, $uMsg, $wParam, $lParam)
		NewAccount_WM_HSCROLL($hWnd, $uMsg, $wParam, $lParam)
	EndIf

	Return $GUI_RUNDEFMSG
EndFunc

Func Main_WM_NOTIFY($hWnd, $uMsg, $wParam, $lParam)
	If IsObj($frmMain) Then
		RoomList_WM_NOTIFY($hWnd, $uMsg, $wParam, $lParam)

		Local $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
		If $tNMHDR.hWndFrom = $frmMain.lvwAccountListHandle And $tNMHDR.Code = $NM_DBLCLK Then
			Local $aHit = _GUICtrlListView_HitTest($tNMHDR.hWndFrom)
			If Not $aHit[1] And $aHit[3] Then
				Main_mnuEdit_MouseClick($aHit[0])
			EndIf
		EndIf
	EndIf

	Return $GUI_RUNDEFMSG
EndFunc

Func Main_mnuEdit_MouseClick($iIndex)
	If IsObj($frmMain) Then
		Local $sUsername = _GUICtrlListView_GetItemText($frmMain.lvwAccountList, $iIndex, 1)
		$frmEditAccount = EditAccount($sUsername)
	EndIf
EndFunc

Func Main_mnuDelete_MouseClick()
	If IsObj($frmMain) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $aiSelectedItems = _GUICtrlListView_GetSelectedIndices($frmMain.lvwAccountList, True)
	If $aiSelectedItems[0] Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $sUsername = ''
	Local $iCount = 0

	_GUICtrlListView_BeginUpdate($frmMain.lvwAccountList)
	For $i = $aiSelectedItems[0] To 1 Step -1
		$sUsername = _GUICtrlListView_GetItemText($frmMain.lvwAccountList, $aiSelectedItems[$i], 1)
		If $oAccounts.Delete($sUsername) Then
			_GUICtrlListView_DeleteItem($frmMain.lvwAccountList, $aiSelectedItems[$i])
			$iCount += 1
		EndIf
	Next
	_GUICtrlListView_EndUpdate($frmMain.lvwAccountList)

	$frmMain.Status($iCount & '/' & $aiSelectedItems[0] & ' selected account(s) successfully deleted.')
EndFunc

Func Main_mnuCloseClients_MouseClick($bGarenaRoom)
	If IsObj($frmMain) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $aiSelectedItems = _GUICtrlListView_GetSelectedIndices($frmMain.lvwAccountList, True)
	If $aiSelectedItems[0] Then
		; --- Nothing to do
	Else
		Return
	EndIf

	$frmMain.Status('Closing all clients of selected account(s)...')

	Local $sUsername, $iClosedClients = 0
	For $i = $aiSelectedItems[0] To 1 Step -1
		$sUsername = _GUICtrlListView_GetItemText($frmMain.lvwAccountList, $aiSelectedItems[$i], 1)
		If $bGarenaRoom Then
			If $oGarenaRoom.CloseByUsername($sUsername) Then
				$iClosedClients += 1
			EndIf
		Else
			If $oGarenaTalk.CloseByUsername($sUsername) Then
				$iClosedClients += 1
			EndIf
		EndIf
	Next

	If $iClosedClients Then
		$frmMain.Status('All clients of selected account(s) successfully closed.')
	Else
		$frmMain.Status('Ready')
		$oMessage.Warning('No client found.', $frmMain)
	EndIf
EndFunc

Func Main_LoadAccounts($this, $iType, $sSearch = '')
	Local $amAccounts = $oAccounts.GetByCondition($iType, $sSearch)
	If $oAccounts.LastError Then
		$oMessage.Error('Unable to read account(s): ' & $oAccounts.LastError, $frmMain)
		Return
	EndIf

	_GUICtrlListView_BeginUpdate($this.lvwAccountList)
	_GUICtrlListView_DeleteAllItems($this.lvwAccountList)

	$this.Status('Loading account(s)...')
	For $mAccount In $amAccounts
		$this.AddAccount($mAccount['Username'], $mAccount['RoomServers'], $mAccount['RoomName'], $mAccount['TalkServers'], $mAccount['ExpiryDate'])
	Next
	$this.Status('Ready')

	_GUICtrlListView_EndUpdate($this.lvwAccountList)
EndFunc

Func Main_AddAccount($this, $sUsername, $iRoomServers, $sRoomName, $iTalkServers, $sExpiryDate)
	If $sRoomName Then
		; --- Nothing to do
	Else
		$sRoomName = 'N/A'
	EndIf

	If $sExpiryDate Then
		; --- Nothing to do
	Else
		$sExpiryDate = 'N/A'
	EndIf

	Local $iItemCount = _GUICtrlListView_GetItemCount($this.lvwAccountList)
	If $iItemCount Then
		For $i = 0 To $iItemCount - 1
			If _GUICtrlListView_GetItemText($this.lvwAccountList, $i, 1) = $sUsername Then
				_GUICtrlListView_SetItemText($this.lvwAccountList, $i, $iRoomServers, 2)
				_GUICtrlListView_SetItemText($this.lvwAccountList, $i, $sRoomName, 3)
				_GUICtrlListView_SetItemText($this.lvwAccountList, $i, $iTalkServers, 4)
				_GUICtrlListView_SetItemText($this.lvwAccountList, $i, $sExpiryDate, 5)
				Return
			EndIf
		Next
	EndIf

	Local $iIndex = _GUICtrlListView_AddItem($this.lvwAccountList, '')
	_GUICtrlListView_AddSubItem($this.lvwAccountList, $iIndex, $sUsername, 1)
	_GUICtrlListView_AddSubItem($this.lvwAccountList, $iIndex, $iRoomServers, 2)
	_GUICtrlListView_AddSubItem($this.lvwAccountList, $iIndex, $sRoomName, 3)
	_GUICtrlListView_AddSubItem($this.lvwAccountList, $iIndex, $iTalkServers, 4)
	_GUICtrlListView_AddSubItem($this.lvwAccountList, $iIndex, $sExpiryDate, 5)
EndFunc

Func Main_CheckedAccounts($this)
	Local $iCount = _GUICtrlListView_GetItemCount($this.lvwAccountList)
	If $iCount Then
		; --- Nothing to do
	Else
		Return -1
	EndIf

	Local $asCheckedUsernames[0]
	For $i = 0 To $iCount - 1
		If _GUICtrlListView_GetItemChecked($this.lvwAccountList, $i) Then
			ReDim $asCheckedUsernames[UBound($asCheckedUsernames) + 1]
			$asCheckedUsernames[UBound($asCheckedUsernames) - 1] = _GUICtrlListView_GetItemText($this.lvwAccountList, $i, 1)
		EndIf
	Next

	Return UBound($asCheckedUsernames) ? $asCheckedUsernames : -2
EndFunc

Func Main_ExpiryDateReminder($this)
	Local $sMessage = ''

	If $oServer.RemainingDays >= 7 Then
		$sMessage = $oServer.RemainingDays & ' days remaining of your AFK Manager account'
	ElseIf $oServer.RemainingDays < 7 Then
		If $oServer.RemainingDays Then
			$sMessage = 'Your AFK Manager account will expire in ' & $oServer.RemainingDays & ' days'
		Else
			$sMessage = 'Your AFK Manager account will expire soon'
		EndIf
	EndIf

	GUICtrlSetData($this.lblExpiryDateReminder, $sMessage)
EndFunc

Func Main_Status($this, $sStatus, $iDuration = 3)
	GUICtrlSetData($this.lblStatusBar, $sStatus)

	$this.StatusDuration = $iDuration * 1000
	$this.StatusTimer = TimerInit()
	$this.StatusReset = True
EndFunc

Func Main_StatusClean()
	If IsObj($frmMain) Then
		If $frmMain.StatusReset And TimerDiff($frmMain.StatusTimer) > $frmMain.StatusDuration Then
			$frmMain.StatusReset = False
			GUICtrlSetData($frmMain.lblStatusBar, 'Ready')
		EndIf
	EndIf
EndFunc

Func Main_CheckIn($hWnd, $uMsg, $uTimerId, $dwTime)
	#forceref $hWnd, $uMsg, $uTimerId, $dwTime

	Local Static $iRetryCount = 0

	$frmMain.CheckInTimer.Enabled = False

	$frmMain.Status('Checking in...')
	Local $iResult = $oServer.CheckIn()
	$frmMain.Status('Ready')

	Local $sTime = StringFormat('\n\n%s-%s-%s %s:%s:%s', @YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC)
	Switch $iResult
		Case $oServer.Result.Success
			$frmMain.ExpiryDateReminder()
			$iRetryCount = 0
			$frmMain.CheckInTimer.Enabled = True
			Return

		Case $oServer.Result.Invalid
			$oSettings.Username = ''
			$oSettings.Password = ''
			$oGarenaRoom.CloseAll()
			$oGarenaTalk.CloseAll()
			$oMessage.Error('Sorry, we have to close AFK Manager.' & @CRLF & 'Your password has been changed.' & $sTime)

		Case $oServer.Result.Expired
			$oGarenaRoom.CloseAll()
			$oGarenaTalk.CloseAll()
			$oMessage.Error('Sorry, we have to close AFK Manager.' & @CRLF & 'Your account has expired.' & $sTime)

		Case $oServer.Result.UserLimit
			$oGarenaRoom.CloseAll()
			$oGarenaTalk.CloseAll()
			$oMessage.Error('Sorry, we have to close AFK Manager.' & @CRLF & 'Your account has reached its online users limit.' & $sTime)

		Case $oServer.Result.Locked
			$oGarenaRoom.CloseAll()
			$oGarenaTalk.CloseAll()
			$oMessage.Error('Sorry, we have to close AFK Manager.' & @CRLF & 'Your account has been locked.' & $sTime)

		Case Else
			$iRetryCount += 1
			If $iRetryCount = 10 Then
				$oGarenaRoom.CloseAll()
				$oGarenaTalk.CloseAll()
				$oMessage.Error('Check in failed.' & @CRLF & 'Unable to connect to server.' & $sTime)
			Else
				Sleep(5000)
				Main_CheckIn($hWnd, $uMsg, $uTimerId, $dwTime)
				Return
			EndIf
	EndSwitch

	$frmMain = 0
EndFunc

Func Main_TalkExpiryTimer($hWnd, $uMsg, $uTimerId, $dwTime)
	#forceref $hWnd, $uMsg, $uTimerId, $dwTime

	$frmMain.TalkExpiryTimer.Enabled = False

	Local $aoTalkClients = $oGarenaTalk.GetAll()
	If $aoTalkClients = Null Then
		$frmMain.TalkExpiryTimer.Enabled = True
		Return
	EndIf

	Local $sToday = @YEAR & '-' & @MON & '-' & @MDAY

	For $oTalkClient In $aoTalkClients
		If $oTalkClient.ExpiryDate And $oTalkClient.ExpiryDate < $sToday Then
			$oTalkClient.Close()
		EndIf
	Next

	$frmMain.TalkExpiryTimer.Enabled = True
EndFunc