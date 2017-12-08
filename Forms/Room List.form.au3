#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func RoomList($frmParent)
	;---------------------------------------------------------------------------
	;
	Local $hDatabase = _SQLite_Open(GarenaPlusPath() & '\Room\Roomen.dat')
	If $hDatabase Then
		; --- Nothing to do
	Else
		$oMessage.Error('Unable to open rooms database.', $frmParent)
		Return Null
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 440
	Local $HEIGHT = 505
	Local $LEFT = 1
	Local $TOP = 21

	Local $hWnd = GUICreate('Room List', $WIDTH + 2, $HEIGHT + 22, -1, -1, $WS_POPUP, 0, $frmParent.Handle)
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

	GUICtrlCreateLabel('Room List', 6, 3, $WIDTH - 10, 15, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlCreateLabel('Search:', $LEFT + 50, $TOP + 50, -1, 15)

	Local $txtSearch = GUICtrlCreateInput('', $LEFT + 50, $TOP + 70, 340, 20)
	GUICtrlSetOnEvent(-1, RoomList_txtSearch_Enter)

	Local $lvwRoomList = GUICtrlCreateListView('', $LEFT + 50, $TOP + 110, 340, 300, _
			BitOR($LVS_NOSORTHEADER, $LVS_SINGLESEL, $LVS_SHOWSELALWAYS), _
			BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_FULLROWSELECT, $LVS_EX_INFOTIP, $WS_EX_CLIENTEDGE))

	Local $hRoomList = GUICtrlGetHandle($lvwRoomList)
	If @OSBuild >= 6000 Then
		_WinAPI_SetWindowTheme($hRoomList, 'Explorer')
	EndIf

	_GUICtrlListView_AddColumn($hRoomList, 'Level', 40)
	_GUICtrlListView_AddColumn($hRoomList, 'Room Name', 275)

	GUICtrlCreateButton('Select', $LEFT + 290, $TOP + 430, 100, 25)
	GUICtrlSetOnEvent(-1, RoomList_btnSelect_MouseClick)

	Local $btnCancel = GUICtrlCreateButton('Cancel', $LEFT + 180, $TOP + 430, 100, 25)
	GUICtrlSetOnEvent(-1, RoomList_btnCancel_MouseClick)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $keySelectAll = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, GUICtrlEditOnCtrlA)

	Local $keySearch = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, RoomList_keySearch)

	Local $avAccelerators[][] = [['{ESC}', $btnCancel], _
			['^a', $keySelectAll], _
			['^f', $keySearch]]
	GUISetAccelerators($avAccelerators, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('RoomList_Destructor')

		; --- Properties | Private
		.AddProperty('DatabaseHandle', $ELSCOPE_PRIVATE, $hDatabase)

		; --- Properties | Read-only
		.AddProperty('Parent', $ELSCOPE_READONLY, $frmParent)
		.AddProperty('Handle', $ELSCOPE_READONLY, $hWnd)
		.AddProperty('txtSearch', $ELSCOPE_READONLY, $txtSearch)
		.AddProperty('lvwRoomList', $ELSCOPE_READONLY, $lvwRoomList)
		.AddProperty('lvwRoomListHandle', $ELSCOPE_READONLY, $hRoomList)

		; --- Methods | Public
		.AddMethod('LoadRooms', 'RoomList_LoadRooms', False)
	EndWith
	Local $this = $oClass.Object
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUISetState(@SW_DISABLE, $frmParent.Handle)

	$this.LoadRooms()
	GUISetState(@SW_SHOW, $hWnd)

	Return $this
	;
	;---------------------------------------------------------------------------
EndFunc

Func RoomList_Destructor($this)
	_SQLite_Close($this.DatabaseHandle)
	GUISetState(@SW_ENABLE, $this.Parent.Handle)
	GUIDelete($this.Handle)
EndFunc

Func RoomList_btnCancel_MouseClick()
	$frmRoomList = Null
EndFunc

Func RoomList_txtSearch_Enter()
	If IsObj($frmRoomList) Then
		$frmRoomList.LoadRooms(GUICtrlRead($frmRoomList.txtSearch))
	EndIf
EndFunc

Func RoomList_btnSelect_MouseClick()
	If IsObj($frmRoomList) Then
		Local $sIndex = _GUICtrlListView_GetSelectedIndices($frmRoomList.lvwRoomList)
		If $sIndex Then
			Local $iIndex = Int($sIndex, 1)
			Local $sRoomName = StringStripWS(_GUICtrlListView_GetItemText($frmRoomList.lvwRoomList, $iIndex, 1), BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))
			GUICtrlSetData($frmRoomList.Parent.txtRoomName, $sRoomName)
			$frmRoomList.Parent.RoomId = _GUICtrlListView_GetItemParam($frmRoomList.lvwRoomList, $iIndex)

			RoomList_btnCancel_MouseClick()
		EndIf
	EndIf
EndFunc

Func RoomList_keySearch()
	GUICtrlSetState($frmRoomList.txtSearch, $GUI_FOCUS)
EndFunc

Func RoomList_WM_NOTIFY($hWnd, $uMsg, $wParam, $lParam)
	#forceref $hWnd, $uMsg, $wParam

	If IsObj($frmRoomList) Then
		Local $tNMHDR = DllStructCreate($tagNMHDR, $lParam)
		If $tNMHDR.hWndFrom = $frmRoomList.lvwRoomListHandle And $tNMHDR.Code = $NM_DBLCLK Then
			RoomList_btnSelect_MouseClick()
		EndIf
	EndIf
EndFunc

Func RoomList_LoadRooms($this, $sSearch = '')
	Local $sQuery = ''
	$sQuery &= 'SELECT RoomId, RoomName, EntryLevel '
	$sQuery &= 'FROM RoomTab '
	$sQuery &= 'WHERE GameId = 1001 '
	$sQuery &= $sSearch ? StringFormat("AND RoomName LIKE '%%%s%' ", GUICtrlRead($this.txtSearch)) : ''
	$sQuery &= 'ORDER BY RoomName;'

	Local $asResult[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($this.DatabaseHandle, $sQuery, $asResult, $iRows, $iColumns) <> $SQLITE_OK Then
		Debug('_SQLite_GetTable2d() failed.', @ScriptLineNumber)
		Return False
	EndIf

	_GUICtrlListView_BeginUpdate($this.lvwRoomList)
	_GUICtrlListView_DeleteAllItems($this.lvwRoomList)

	Local $iIndex = 0
	For $i = 1 To $iRows
		$iIndex = _GUICtrlListView_InsertItem($this.lvwRoomList, $asResult[$i][2], -1, -1, Int($asResult[$i][0], 1))
		_GUICtrlListView_AddSubItem($this.lvwRoomList, $iIndex, $asResult[$i][1], 1)
	Next

	_GUICtrlListView_EndUpdate($this.lvwRoomList)

	If GUICtrlRead($this.Parent.txtRoomName) Then
		$iIndex = _GUICtrlListView_FindParam($this.lvwRoomList, $this.Parent.RoomId)
		If $iIndex <> -1 Then
			_GUICtrlListView_SetItemSelected($this.lvwRoomList, $iIndex, True, True)
			_GUICtrlListView_EnsureVisible($this.lvwRoomList, $iIndex, True)
			GUICtrlSetState($this.lvwRoomList, $GUI_FOCUS)
		EndIf
	EndIf

	Return True
EndFunc