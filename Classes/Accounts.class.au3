#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func Accounts()
	;---------------------------------------------------------------------------
	;
	Local $sDatabasePath = @LocalAppDataDir & '\' & $APP_NAME & '\Accounts 1.1.gpd'
	Local $iDatabaseExists = FileExists($sDatabasePath)

	Local $hDatabaseHandle = _SQLite_Open($sDatabasePath)
	If $hDatabaseHandle Then
		; --- Nothing to do
	Else
		Debug('Accounts.class | _SQLite_Open() failed.', @ScriptLineNumber)
		Return SetError(1, 0, Null)
	EndIf

	If $iDatabaseExists Then
		; --- Nothing to do
	Else
		Local $sQuery = 'CREATE TABLE Accounts(' & _
				'Username TEXT PRIMARY KEY COLLATE NOCASE,' & _
				'Password TEXT NOT NULL,' & _
				'RoomServers INTEGER NOT NULL,' & _
				'RoomId INTEGER,' & _
				'RoomName TEXT,' & _
				'TalkServers INTEGER NOT NULL,' & _
				'ExpiryDate TEXT,' & _
				'Comments TEXT' & _
				');'

		If _SQLite_Exec($hDatabaseHandle, $sQuery) <> $SQLITE_OK Then
			Debug('Accounts.class | _SQLite_Exec() failed.', @ScriptLineNumber)
			_SQLite_Close($hDatabaseHandle)
			Return SetError(2, 0, Null)
		EndIf
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $mType[]
	$mType['All'] = 1
	$mType['Expired'] = 2
	$mType['Unexpired'] = 3
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('Accounts_Destructor')

		; --- Properties | Private
		.AddProperty('DatabaseHandle', $ELSCOPE_PRIVATE, $hDatabaseHandle)

		; --- Properties | Read-only
		.AddProperty('DatabasePath', $ELSCOPE_READONLY, $sDatabasePath)
		.AddProperty('Type', $ELSCOPE_READONLY, $mType)
		.AddProperty('LastError', $ELSCOPE_READONLY, 0)

		; --- Methods | Public
		.AddMethod('Add', 'Accounts_Add', False)
		.AddMethod('Count', 'Accounts_Count', False)
		.AddMethod('Delete', 'Accounts_Delete', False)
		.AddMethod('Exists', 'Accounts_Exists', False)
		.AddMethod('GetByCondition', 'Accounts_GetByCondition', False)
		.AddMethod('GetByUsername', 'Accounts_GetByUsername', False)
		.AddMethod('Import', 'Accounts_Import', False)
		.AddMethod('Update', 'Accounts_Update', False)

		; --- Methods | Private
		.AddMethod('Account', 'Accounts_Account', True)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func Accounts_Destructor($this)
	If _SQLite_Close($this.DatabaseHandle) <> $SQLITE_OK Then
		Debug('Accounts.class | _SQLite_Close() failed.', @ScriptLineNumber)
	EndIf
EndFunc

Func Accounts_Add($this, $sUsername, $sPassword, $sRoomServers, $sRoomId, $sRoomName, $sTalkServers, $sExpiryDate, $sComments, $bImport = False)
	;---------------------------------------------------------------------------
	;
	If $bImport Then
		; --- Nothing to do
	Else
		$sPassword = $oInterface.MD5($sPassword)
		If @error Then
			Debug('Accounts.class | MD5() failed.', @ScriptLineNumber)
			$this.LastError = 1
			Return False
		EndIf
	EndIf

	Local $iRoomServers = Int($sRoomServers, 1)
	Local $iRoomId = Int($sRoomId, 1)
	Local $iTalkServers = Int($sTalkServers, 1)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'REPLACE INTO Accounts (' & _
			'Username, Password, RoomServers, RoomId, RoomName, TalkServers, ExpiryDate, Comments' & _
			') VALUES (' & _
			StringFormat("'%s', '%s', %u, %u, '%s', %u, '%s', '%s'", _
			$sUsername, $sPassword, $iRoomServers, $iRoomId, $sRoomName, $iTalkServers, $sExpiryDate, $sComments) & _
			');'

	If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
		Debug('Accounts.class | _SQLite_Exec() failed.', @ScriptLineNumber)
		$this.LastError = 2
		Return False
	EndIf

	$this.LastError = 0
	Return True
	;
	;---------------------------------------------------------------------------
EndFunc

Func Accounts_Count($this)
	Local $sQuery = 'SELECT Username ' & _
			'FROM Accounts;'

	Local $asAccounts[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($this.DatabaseHandle, $sQuery, $asAccounts, $iRows, $iColumns) <> $SQLITE_OK Then
		Debug('Accounts.class | _SQLite_GetTable2d() failed.', @ScriptLineNumber)
		$this.LastError = 1
		Return 0
	EndIf

	$this.LastError = 0
	Return $iRows
EndFunc

Func Accounts_Delete($this, $sUsername)
	Local $sQuery = 'DELETE FROM Accounts ' & _
			StringFormat("WHERE Username = '%s';", $sUsername)

	If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
		Debug('Accounts.class | _SQLite_Exec() failed.', @ScriptLineNumber)
		$this.LastError = 1
		Return False
	EndIf

	$this.LastError = 0
	Return True
EndFunc

Func Accounts_Exists($this, $sUsername)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT COUNT(Username) ' & _
			'FROM Accounts ' & _
			StringFormat("WHERE Username = '%s';", $sUsername)

	Local $asCount[0]
	If _SQLite_QuerySingleRow($this.DatabaseHandle, $sQuery, $asCount) <> $SQLITE_OK Then
		Debug('Accounts.class | _SQLite_QuerySingleRow() failed.', @ScriptLineNumber)
		$this.LastError = 1
		Return False
	EndIf

	$this.LastError = 0
	Return Int($asCount[0], 1) = 1
	;
	;---------------------------------------------------------------------------
EndFunc

Func Accounts_GetByCondition($this, $iType, $sSearch = '')
	;---------------------------------------------------------------------------
	;
	Local $sToday = @YEAR & '-' & @MON & '-' & @MDAY

	Local $sQuery = 'SELECT * ' & _
			'FROM Accounts'
	Switch $iType
		Case $this.Type['All']
			If $sSearch Then
				$sQuery &= StringFormat(" WHERE Username LIKE '%%%s%'", $sSearch)
			EndIf

		Case $this.Type['Expired']
			$sQuery &= StringFormat(" WHERE ExpiryDate != '' AND ExpiryDate < '%s'", $sToday)
			If $sSearch Then
				$sQuery &= StringFormat(" AND Username LIKE '%%%s%'", $sSearch)
			EndIf

		Case $this.Type['Unexpired']
			$sQuery &= StringFormat(" WHERE (ExpiryDate = '' OR ExpiryDate >= '%s')", $sToday)
			If $sSearch Then
				$sQuery &= StringFormat(" AND Username LIKE '%%%s%'", $sSearch)
			EndIf

		Case Else
			Debug('Accounts.class | Switch Case Else', @ScriptLineNumber)
			$this.LastError = 1
			Return Null
	EndSwitch
	$sQuery &= ';'

	Local $asAccounts[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($this.DatabaseHandle, $sQuery, $asAccounts, $iRows, $iColumns) <> $SQLITE_OK Then
		Debug('Accounts.class | _SQLite_GetTable2d() failed.', @ScriptLineNumber)
		$this.LastError = 2
		Return Null
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $asAccount[8], $amAccounts[0]
	Local $iCount = 0

	For $i = 1 To $iRows
		For $j = 0 To 7
			$asAccount[$j] = $asAccounts[$i][$j]
		Next

		$iCount += 1
		ReDim $amAccounts[$iCount]
		$amAccounts[$iCount - 1] = $this.Account($asAccount)
	Next

	$this.LastError = 0
	Return $amAccounts
	;
	;---------------------------------------------------------------------------
EndFunc

Func Accounts_GetByUsername($this, $sUsername)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT * ' & _
			'FROM Accounts ' & _
			StringFormat("WHERE Username = '%s';", $sUsername)

	Local $asAccount[0]
	If _SQLite_QuerySingleRow($this.DatabaseHandle, $sQuery, $asAccount) <> $SQLITE_OK Then
		Debug('Accounts.class | _SQLite_QuerySingleRow() failed.', @ScriptLineNumber)
		$this.LastError = 1
		Return Null
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	If UBound($asAccount) <> 8 Then
		$this.LastError = 2
		Return Null
	EndIf

	$this.LastError = 0
	Return $this.Account($asAccount)
	;
	;---------------------------------------------------------------------------
EndFunc

Func Accounts_Import($this, $sDatabasePath, $fReplace)
	;---------------------------------------------------------------------------
	;
	Local $hDatabaseHandle = _SQLite_Open($sDatabasePath)
	If $hDatabaseHandle Then
		; --- Nothing to do
	Else
		$this.LastError = 1
		Return 0
	EndIf

	Local $sQuery = 'SELECT * ' & _
			'FROM Accounts;'

	Local $asAccounts[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($hDatabaseHandle, $sQuery, $asAccounts, $iRows, $iColumns) <> $SQLITE_OK Then
		_SQLite_Close($hDatabaseHandle)
		$this.LastError = 1
		Return 0
	EndIf

	_SQLite_Close($hDatabaseHandle)

	If $iColumns <> 8 Then
		$this.LastError = 1
		Return 0
	EndIf

	If $iRows Then
		; --- Nothing to do
	Else
		$this.LastError = 2
		Return 0
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $fSkipDuplicates = Not $fReplace
	Local $iCount = 0
	Local $iTalkServers = 0

	For $i = 1 To $iRows
		If $this.Exists($asAccounts[$i][0]) And $fSkipDuplicates Then
			ContinueLoop
		Else
			If $this.LastError Then
				Debug('Accounts.class | .Exists() failed.', @ScriptLineNumber)
				ContinueLoop
			EndIf

			$iTalkServers = Int($asAccounts[$i][5], 1)
			If $iTalkServers < 1 Or $iTalkServers > $oServer.GarenaTalkServerCount Then
				$iTalkServers = 1
			EndIf

			$this.Add( _
					$asAccounts[$i][0], _
					$asAccounts[$i][1], _
					$asAccounts[$i][2], _
					$asAccounts[$i][3], _
					$asAccounts[$i][4], _
					$iTalkServers, _
					$asAccounts[$i][6], _
					$asAccounts[$i][7], _
					True)
			If $this.LastError Then
				Debug('Accounts.class | .Add() failed.', @ScriptLineNumber)
			Else
				$iCount += 1
			EndIf
		EndIf
	Next

	$this.LastError = 0
	Return $iCount
	;
	;---------------------------------------------------------------------------
EndFunc

Func Accounts_Update($this, $sUsername, $sPassword, $sRoomServers, $sRoomId, $sRoomName, $sTalkServers, $sExpiryDate, $sComments)
	;---------------------------------------------------------------------------
	;
	If StringLen($sPassword) <> 32 Then
		$sPassword = $oInterface.MD5($sPassword)
		If @error Then
			Debug('Accounts.class | MD5() failed.', @ScriptLineNumber)
			$this.LastError = 1
			Return False
		EndIf
	EndIf

	Local $iRoomServers = Int($sRoomServers, 1)
	Local $iRoomId = Int($sRoomId, 1)
	Local $iTalkServers = Int($sTalkServers, 1)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'UPDATE Accounts ' & _
			StringFormat("SET Password = '%s', ", $sPassword) & _
			StringFormat('RoomServers = %u, ', $iRoomServers) & _
			StringFormat('RoomId = %u, ', $iRoomId) & _
			StringFormat("RoomName = '%s', ", $sRoomName) & _
			StringFormat("TalkServers = %u, ", $iTalkServers) & _
			StringFormat("ExpiryDate = '%s', ", $sExpiryDate) & _
			StringFormat("Comments = '%s' ", $sComments) & _
			StringFormat("WHERE Username = '%s';", $sUsername)

	If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
		Debug('Accounts.class | _SQLite_Exec() failed.', @ScriptLineNumber)
		$this.LastError = 2
		Return False
	EndIf

	$this.LastError = 0
	Return True
	;
	;---------------------------------------------------------------------------
EndFunc

Func Accounts_Account($this, $asAccount)
	#forceref $this

	Local $mAccount[]
	$mAccount['Username'] = $asAccount[0]
	$mAccount['Password'] = $asAccount[1]
	$mAccount['RoomServers'] = Int($asAccount[2], 1)
	$mAccount['RoomId'] = $asAccount[4] ? Int($asAccount[3], 1) : $oServer.RoomId
	$mAccount['RoomName'] = $asAccount[4]
	$mAccount['TalkServers'] = Int($asAccount[5], 1)
	$mAccount['ExpiryDate'] = $asAccount[6]
	$mAccount['Comments'] = $asAccount[7]

	Return $mAccount
EndFunc