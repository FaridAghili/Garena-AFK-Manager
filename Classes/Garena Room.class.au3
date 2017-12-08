#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func GarenaRoom()
	;---------------------------------------------------------------------------
	;
	Local $hDatabaseHandle = _SQLite_Open(':memory:')
	If $hDatabaseHandle Then
		; --- Nothing to do
	Else
		Debug('GarenaRoom.class | _SQLite_Open() failed.', @ScriptLineNumber)
		Return SetError(1, 0, Null)
	EndIf

	Local $sQuery = 'CREATE TABLE GarenaRoom(' & _
			'ProcessId INTEGER PRIMARY KEY,' & _
			'hWnd INTEGER NOT NULL,' & _
			'Username TEXT NOT NULL COLLATE NOCASE,' & _
			'Server INTEGER NOT NULL,' & _
			'RoomId INTEGER NOT NULL,' & _
			'RoomName TEXT NOT NULL,' & _
			'ExpiryDate TEXT' & _
			');'

	If _SQLite_Exec($hDatabaseHandle, $sQuery) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_Exec() failed.', @ScriptLineNumber)
		_SQLite_Close($hDatabaseHandle)
		Return SetError(2, 0, Null)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('GarenaRoom_Destructor')

		; --- Properties | Private
		.AddProperty('DatabaseHandle', $ELSCOPE_PRIVATE, $hDatabaseHandle)

		; --- Properties | Read-only
		.AddProperty('LastError', $ELSCOPE_READONLY, 0)

		; --- Methods | Public
		.AddMethod('Add', 'GarenaRoom_Add', False)
		.AddMethod('CloseAll', 'GarenaRoom_CloseAll', False)
		.AddMethod('CloseByProcessId', 'GarenaRoom_CloseByProcessId', False)
		.AddMethod('CloseByUsername', 'GarenaRoom_CloseByUsername', False)
		.AddMethod('Count', 'GarenaRoom_Count', False)
		.AddMethod('GetAll', 'GarenaRoom_GetAll', False)
		.AddMethod('GetByUsername', 'GarenaRoom_GetByUsername', False)
		.AddMethod('IsRunningInRoom', 'GarenaRoom_IsRunningInRoom', False)
		.AddMethod('IsRunningInServer', 'GarenaRoom_IsRunningInServer', False)

		; --- Methods | Private
		.AddMethod('Clean', 'GarenaRoom_Clean', True)
		.AddMethod('Client', 'GarenaRoom_Client', True)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_Destructor($this)
	If _SQLite_Close($this.DatabaseHandle) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_Close() failed.', @ScriptLineNumber)
	EndIf
EndFunc

Func GarenaRoom_Add($this, $hWnd, $mAccount, $iServer)
	;---------------------------------------------------------------------------
	;
	Local $iProcessId = WinGetProcess(Ptr($hWnd))
	Local $sExpiryDate = $iServer ? $mAccount['ExpiryDate'] : ''
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'REPLACE INTO GarenaRoom (' & _
			'ProcessId, hWnd, Username, Server, RoomId, RoomName, ExpiryDate' & _
			') VALUES (' & _
			StringFormat("%u, %u, '%s', %u, %u, '%s', '%s'", _
			$iProcessId, $hWnd, $mAccount['Username'], $iServer, $mAccount['RoomId'], $mAccount['RoomName'], $sExpiryDate) & _
			');'

	If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_Exec() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClient = $this.Client( _
			$iProcessId, _
			$hWnd, _
			$mAccount['Username'], _
			$iServer, _
			$mAccount['RoomId'], _
			$mAccount['RoomName'], _
			$sExpiryDate)

	$this.LastError = 0
	Return $oClient
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_CloseAll($this)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT ProcessId ' & _
			'FROM GarenaRoom;'

	Local $asGarenaRoom[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($this.DatabaseHandle, $sQuery, $asGarenaRoom, $iRows, $iColumns) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_GetTable2d() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $iProcessId = 0, $iCount = 0

	For $i = 1 To $iRows
		$iProcessId = Int($asGarenaRoom[$i][0], 1)

		$sQuery = 'DELETE FROM GarenaRoom ' & _
				StringFormat('WHERE ProcessId = %d;', $iProcessId)

		If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
			Debug('GarenaRoom.class | _SQLite_Exec() failed.', @ScriptLineNumber)
		EndIf

		If $oInterface.ProcessGetFileName($iProcessId) <> 'garena_room.exe' Then
			Debug("GarenaRoom.class | ProcessGetFileName() doesn't match.", @ScriptLineNumber)
			ContinueLoop
		EndIf

		If ProcessClose($iProcessId) Then
			$iCount += 1
		Else
			Debug('GarenaRoom.class | ProcessClose() failed.', @ScriptLineNumber)
		EndIf
	Next

	$this.LastError = 0
	Return $iCount
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_CloseByProcessId($this, $iProcessId)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'DELETE FROM GarenaRoom ' & _
			StringFormat('WHERE ProcessId = %d;', $iProcessId)

	If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_Exec() failed.', @ScriptLineNumber)
	EndIf

	If $oInterface.ProcessGetFileName($iProcessId) = 'garena_room.exe' Then
		If ProcessClose($iProcessId) Then
			; --- Nothing to do
		Else
			Debug('GarenaRoom.class | ProcessClose() failed.', @ScriptLineNumber)
		EndIf
	Else
		Debug("GarenaRoom.class | ProcessGetFileName() doesn't match.", @ScriptLineNumber)
	EndIf

	$this.LastError = 0
	Return True
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_CloseByUsername($this, $sUsername)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT ProcessId ' & _
			'FROM GarenaRoom ' & _
			StringFormat("WHERE Username = '%s';", $sUsername)

	Local $asGarenaRoom[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($this.DatabaseHandle, $sQuery, $asGarenaRoom, $iRows, $iColumns) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_GetTable2d() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $iProcessId = 0, $iCount = 0

	For $i = 1 To $iRows
		$iProcessId = Int($asGarenaRoom[$i][0], 1)

		$sQuery = 'DELETE FROM GarenaRoom ' & _
				StringFormat('WHERE ProcessId = %d;', $iProcessId)

		If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
			Debug('GarenaRoom.class | _SQLite_Exec() failed.', @ScriptLineNumber)
		EndIf

		If $oInterface.ProcessGetFileName($iProcessId) <> 'garena_room.exe' Then
			Debug("GarenaRoom.class | ProcessGetFileName() doesn't match.", @ScriptLineNumber)
			ContinueLoop
		EndIf

		If ProcessClose($iProcessId) Then
			$iCount += 1
		Else
			Debug('GarenaRoom.class | ProcessClose() failed.', @ScriptLineNumber)
			ContinueLoop
		EndIf
	Next

	$this.LastError = 0
	Return $iCount
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_Count($this)
	;---------------------------------------------------------------------------
	;
	$this.Clean()
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT COUNT(ProcessId) ' & _
			'FROM GarenaRoom;'

	Local $asCount[0]
	If _SQLite_QuerySingleRow($this.DatabaseHandle, $sQuery, $asCount) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_QuerySingleRow() failed.', @ScriptLineNumber)
	EndIf

	$this.LastError = 0
	Return Int($asCount[0], 1)
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_GetAll($this)
	;---------------------------------------------------------------------------
	;
	$this.Clean()
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT * ' & _
			'FROM GarenaRoom;'

	Local $asGarenaRoom[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($this.DatabaseHandle, $sQuery, $asGarenaRoom, $iRows, $iColumns) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_GetTable2d() failed.', @ScriptLineNumber)
	EndIf

	If $iRows Then
		; --- Nothing to do
	Else
		$this.LastError = 0
		Return Null
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $aoGarenaRoom[$iRows]
	For $i = 1 To $iRows
		$aoGarenaRoom[$i - 1] = $this.Client( _
				$asGarenaRoom[$i][0], _
				$asGarenaRoom[$i][1], _
				$asGarenaRoom[$i][2], _
				$asGarenaRoom[$i][3], _
				$asGarenaRoom[$i][4], _
				$asGarenaRoom[$i][5], _
				$asGarenaRoom[$i][6])
	Next

	$this.LastError = 0
	Return $aoGarenaRoom
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_GetByUsername($this, $sUsername)
	;---------------------------------------------------------------------------
	;
	$this.Clean()
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT * ' & _
			'FROM GarenaRoom ' & _
			StringFormat("WHERE Username = '%s';", $sUsername)

	Local $asGarenaRoom[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($this.DatabaseHandle, $sQuery, $asGarenaRoom, $iRows, $iColumns) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_GetTable2d() failed.', @ScriptLineNumber)
	EndIf

	If $iRows Then
		; --- Nothing to do
	Else
		$this.LastError = 0
		Return Null
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $aoGarenaRoom[$iRows]
	For $i = 1 To $iRows
		$aoGarenaRoom[$i - 1] = $this.Client( _
				$asGarenaRoom[$i][0], _
				$asGarenaRoom[$i][1], _
				$asGarenaRoom[$i][2], _
				$asGarenaRoom[$i][3], _
				$asGarenaRoom[$i][4], _
				$asGarenaRoom[$i][5], _
				$asGarenaRoom[$i][6])
	Next

	$this.LastError = 0
	Return $aoGarenaRoom
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_IsRunningInRoom($this, $sUsername, $iRoom)
	;---------------------------------------------------------------------------
	;
	$this.Clean()
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT COUNT(ProcessId) ' & _
			'FROM GarenaRoom ' & _
			StringFormat("WHERE Username = '%s' AND Server = 0 AND RoomId = %u;", $sUsername, $iRoom)

	Local $asCount[0]
	If _SQLite_QuerySingleRow($this.DatabaseHandle, $sQuery, $asCount) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_QuerySingleRow() failed.', @ScriptLineNumber)
	EndIf

	$this.LastError = 0
	Return Int($asCount[0], 1)
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_IsRunningInServer($this, $sUsername, $iServer)
	;---------------------------------------------------------------------------
	;
	$this.Clean()
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT COUNT(ProcessId) ' & _
			'FROM GarenaRoom ' & _
			StringFormat("WHERE Username = '%s' AND Server = %u;", $sUsername, $iServer)

	Local $asCount[0]
	If _SQLite_QuerySingleRow($this.DatabaseHandle, $sQuery, $asCount) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_QuerySingleRow() failed.', @ScriptLineNumber)
	EndIf

	$this.LastError = 0
	Return Int($asCount[0], 1)
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_Clean($this)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT ProcessId ' & _
			'FROM GarenaRoom;'

	Local $asGarenaRoom[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($this.DatabaseHandle, $sQuery, $asGarenaRoom, $iRows, $iColumns) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_GetTable2d() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $iProcessId = 0
	Local $sProcessName = ''

	For $i = 1 To $iRows
		$iProcessId = Int($asGarenaRoom[$i][0], 1)

		$sProcessName = $oInterface.ProcessGetFileName($iProcessId)
		If @error Then
			Debug('GarenaRoom.class | ProcessGetFileName() failed.', @ScriptLineNumber)
		EndIf

		If $sProcessName <> 'garena_room.exe' Then
			$sQuery = 'DELETE FROM GarenaRoom ' & _
					StringFormat('WHERE ProcessId = %d;', $iProcessId)

			If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
				Debug('GarenaRoom.class | _SQLite_Exec() failed.', @ScriptLineNumber)
			EndIf
		EndIf
	Next
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_Client($this, $iProcessId, $hWnd, $sUsername, $iServer, $iRoomId, $sRoomName, $sExpiryDate)
	;---------------------------------------------------------------------------
	;
	$hWnd = Ptr($hWnd)

	Local $hTitle = _WinAPI_GetDlgItem($hWnd, 1135)
	If $hTitle Then
		; --- Nothing to do
	Else
		Debug('GarenaRoom.class | _WinAPI_GetDlgItem() failed.', @ScriptLineNumber)
	EndIf

	Local $hLevel = _WinAPI_GetDlgItem($hWnd, 1139)
	If $hLevel Then
		; --- Nothing to do
	Else
		Debug('GarenaRoom.class | _WinAPI_GetDlgItem() failed.', @ScriptLineNumber)
	EndIf

	Local $hRoom = _WinAPI_GetDlgItem($hWnd, 1152)
	If $hRoom Then
		; --- Nothing to do
	Else
		Debug('GarenaRoom.class | _WinAPI_GetDlgItem() failed.', @ScriptLineNumber)
	EndIf

	Local $hExperience = _WinAPI_GetDlgItem($hWnd, 1410)
	If $hExperience Then
		; --- Nothing to do
	Else
		Debug('GarenaRoom.class | _WinAPI_GetDlgItem() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Properties | Private
		.AddProperty('DatabaseHandle', $ELSCOPE_PRIVATE, $this.DatabaseHandle)
		.AddProperty('lblTitle', $ELSCOPE_PRIVATE, $hTitle)
		.AddProperty('btnLevel', $ELSCOPE_PRIVATE, $hLevel)
		.AddProperty('btnRoom', $ELSCOPE_PRIVATE, $hRoom)
		.AddProperty('prgExperience', $ELSCOPE_PRIVATE, $hExperience)

		; --- Properties | Read-only
		.AddProperty('ProcessId', $ELSCOPE_READONLY, Int($iProcessId, 1))
		.AddProperty('Username', $ELSCOPE_READONLY, $sUsername)
		.AddProperty('Server', $ELSCOPE_READONLY, Int($iServer, 1))
		.AddProperty('RoomId', $ELSCOPE_READONLY, Int($iRoomId, 1))
		.AddProperty('RoomName', $ELSCOPE_READONLY, $sRoomName)
		.AddProperty('ExpiryDate', $ELSCOPE_READONLY, $sExpiryDate)

		; --- Methods | Public
		.AddMethod('AccountInfo', 'GarenaRoom_Client_AccountInfo', False)
		.AddMethod('Close', 'GarenaRoom_Client_Close', False)
		.AddMethod('CurrentRoomName', 'GarenaRoom_Client_CurrentRoomName', False)
		.AddMethod('IsAlive', 'GarenaRoom_Client_IsAlive', False)
		.AddMethod('IsConnected', 'GarenaRoom_Client_IsConnected', False)
		.AddMethod('IsInRoom', 'GarenaRoom_Client_IsInRoom', False)
		.AddMethod('IsLoggedIn', 'GarenaRoom_Client_IsLoggedIn', False)
		.AddMethod('IsPasswordWrong', 'GarenaRoom_Client_IsPasswordWrong', False)
	EndWith

	$this.LastError = 0
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_Client_AccountInfo($this)
	;---------------------------------------------------------------------------
	;
	If $this.IsLoggedIn Then
		; --- Nothing to do
	Else
		Return Null
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $iCurrentExp = _SendMessage($this.prgExperience, $PBM_GETPOS, 0, 0) * 10
	Local $iLevel = Int(ControlGetText('', '', Ptr($this.btnLevel)), 1)
	Local $iRequiredExp = _SendMessage($this.prgExperience, $PBM_GETRANGE, False, 0) * 10
	Local $iExpPercent = Floor($iCurrentExp / ($iRequiredExp / 100))
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $mAccountInfo[]
	$mAccountInfo['CurrentExp'] = $iCurrentExp
	$mAccountInfo['ExpPercent'] = $iExpPercent
	$mAccountInfo['Level'] = $iLevel
	$mAccountInfo['RequiredExp'] = $iRequiredExp
	Return $mAccountInfo
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_Client_Close($this)
	;---------------------------------------------------------------------------
	;
	If $this.IsAlive Then
		; --- Nothing to do
	Else
		Return
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'DELETE FROM GarenaRoom ' & _
			StringFormat('WHERE ProcessId = %d;', $this.ProcessId)

	If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_Exec() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	If ProcessClose($this.ProcessId) Then
		; --- Nothing to do
	Else
		Debug('GarenaRoom.class | ProcessClose() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_Client_CurrentRoomName($this)
	;---------------------------------------------------------------------------
	;
	If $this.IsInRoom Then
		; --- Nothing to do
	Else
		Return ''
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sRoomName = ControlGetText('', '', Ptr($this.lblTitle))
	$sRoomName = StringRegExpReplace($sRoomName, '(\V+)\s*\(\w*\)$', '\1')

	Return StringStripWS($sRoomName, BitOR($STR_STRIPLEADING, $STR_STRIPTRAILING))
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_Client_IsAlive($this)
	;---------------------------------------------------------------------------
	;
	If $oInterface.ProcessGetFileName($this.ProcessId) = 'garena_room.exe' Then
		Return True
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'DELETE FROM GarenaRoom ' & _
			StringFormat('WHERE ProcessId = %d;', $this.ProcessId)

	If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
		Debug('GarenaRoom.class | _SQLite_Exec() failed.', @ScriptLineNumber)
	EndIf

	Return False
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_Client_IsConnected($this)
	;---------------------------------------------------------------------------
	;
	If $this.IsInRoom Then
		; --- Nothing to do
	Else
		Return False
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Return $oInterface.IsClientConnectedToRoomServer($this.ProcessId)
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaRoom_Client_IsInRoom($this)
	Return $this.IsLoggedIn ? _WinAPI_IsWindowEnabled($this.btnRoom) : False
EndFunc

Func GarenaRoom_Client_IsLoggedIn($this)
	Return $this.IsAlive ? _WinAPI_IsWindowVisible($this.btnRoom) : False
EndFunc

Func GarenaRoom_Client_IsPasswordWrong($this)
	Return $oInterface.IsRoomPasswordWrong($this.ProcessId)
EndFunc