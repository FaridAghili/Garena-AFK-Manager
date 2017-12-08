#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func GarenaTalk()
	;---------------------------------------------------------------------------
	;
	Local $hDatabaseHandle = _SQLite_Open(':memory:')
	If $hDatabaseHandle Then
		; --- Nothing to do
	Else
		Debug('GarenaTalk.class | _SQLite_Open() failed.', @ScriptLineNumber)
		Return SetError(1, 0, Null)
	EndIf

	Local $sQuery = 'CREATE TABLE GarenaTalk(' & _
			'Socket INTEGER PRIMARY KEY,' & _
			'Username TEXT NOT NULL COLLATE NOCASE,' & _
			'Server INTEGER NOT NULL,' & _
			'ExpiryDate TEXT' & _
			');'

	If _SQLite_Exec($hDatabaseHandle, $sQuery) <> $SQLITE_OK Then
		Debug('GarenaTalk.class | _SQLite_Exec() failed.', @ScriptLineNumber)
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
		.AddDestructor('GarenaTalk_Destructor')

		; --- Properties | Private
		.AddProperty('DatabaseHandle', $ELSCOPE_PRIVATE, $hDatabaseHandle)

		; --- Properties | Read-only
		.AddProperty('LastError', $ELSCOPE_READONLY, 0)

		; --- Methods | Public
		.AddMethod('Add', 'GarenaTalk_Add', False)
		.AddMethod('CloseAll', 'GarenaTalk_CloseAll', False)
		.AddMethod('CloseBySocket', 'GarenaTalk_CloseBySocket', False)
		.AddMethod('CloseByUsername', 'GarenaTalk_CloseByUsername', False)
		.AddMethod('Count', 'GarenaTalk_Count', False)
		.AddMethod('GetAll', 'GarenaTalk_GetAll', False)
		.AddMethod('GetByUsername', 'GarenaTalk_GetByUsername', False)
		.AddMethod('IsRunning', 'GarenaTalk_IsRunning', False)

		; --- Methods | Private
		.AddMethod('Client', 'GarenaTalk_Client', True)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaTalk_Destructor($this)
	If _SQLite_Close($this.DatabaseHandle) <> $SQLITE_OK Then
		Debug('GarenaTalk.class | _SQLite_Close() failed.', @ScriptLineNumber)
	EndIf
EndFunc

Func GarenaTalk_Add($this, $iSocket, $mAccount, $iServer)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'REPLACE INTO GarenaTalk (' & _
			'Socket, Username, Server, ExpiryDate' & _
			') VALUES (' & _
			StringFormat("%u, '%s', %u, '%s'", _
			$iSocket, $mAccount['Username'], $iServer, $mAccount['ExpiryDate']) & _
			');'

	If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
		Debug('GarenaTalk.class | _SQLite_Exec() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClient = $this.Client( _
			$iSocket, _
			$mAccount['Username'], _
			$iServer, _
			$mAccount['ExpiryDate'])

	$this.LastError = 0
	Return $oClient
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaTalk_CloseAll($this)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT Socket ' & _
			'FROM GarenaTalk;'

	Local $asGarenaTalk[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($this.DatabaseHandle, $sQuery, $asGarenaTalk, $iRows, $iColumns) <> $SQLITE_OK Then
		Debug('GarenaTalk.class | _SQLite_GetTable2d() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $iSocket = 0, $iCount = 0

	For $i = 1 To $iRows
		$iSocket = Int($asGarenaTalk[$i][0], 1)

		$sQuery = 'DELETE FROM GarenaTalk ' & _
				StringFormat('WHERE Socket = %d;', $iSocket)

		If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
			Debug('GarenaTalk.class | _SQLite_Exec() failed.', @ScriptLineNumber)
		EndIf

		If TCPCloseSocket($iSocket) Then
			$iCount += 1
		Else
			Debug('GarenaTalk.class | TCPCloseSocket() failed.', @ScriptLineNumber)
		EndIf
	Next

	$this.LastError = 0
	Return $iCount
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaTalk_CloseBySocket($this, $iSocket)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'DELETE FROM GarenaTalk ' & _
			StringFormat('WHERE Socket = %d;', $iSocket)

	If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
		Debug('GarenaTalk.class | _SQLite_Exec() failed.', @ScriptLineNumber)
	EndIf

	If TCPCloseSocket($iSocket) Then
		; --- Nothing to do
	Else
		Debug('GarenaTalk.class | TCPCloseSocket() failed.', @ScriptLineNumber)
	EndIf

	$this.LastError = 0
	Return True
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaTalk_CloseByUsername($this, $sUsername)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT Socket ' & _
			'FROM GarenaTalk ' & _
			StringFormat("WHERE Username = '%s';", $sUsername)

	Local $asGarenaTalk[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($this.DatabaseHandle, $sQuery, $asGarenaTalk, $iRows, $iColumns) <> $SQLITE_OK Then
		Debug('GarenaTalk.class | _SQLite_GetTable2d() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $iSocket = 0, $iCount = 0

	For $i = 1 To $iRows
		$iSocket = Int($asGarenaTalk[$i][0], 1)

		$sQuery = 'DELETE FROM GarenaTalk ' & _
				StringFormat('WHERE Socket = %d;', $iSocket)

		If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
			Debug('GarenaTalk.class | _SQLite_Exec() failed.', @ScriptLineNumber)
		EndIf

		If TCPCloseSocket($iSocket) Then
			$iCount += 1
		Else
			Debug('GarenaTalk.class | TCPCloseSocket() failed.', @ScriptLineNumber)
			ContinueLoop
		EndIf
	Next

	$this.LastError = 0
	Return $iCount
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaTalk_Count($this)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT COUNT(Socket) ' & _
			'FROM GarenaTalk;'

	Local $asCount[0]
	If _SQLite_QuerySingleRow($this.DatabaseHandle, $sQuery, $asCount) <> $SQLITE_OK Then
		Debug('GarenaTalk.class | _SQLite_QuerySingleRow() failed.', @ScriptLineNumber)
	EndIf

	$this.LastError = 0
	Return Int($asCount[0], 1)
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaTalk_GetAll($this)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT * ' & _
			'FROM GarenaTalk;'

	Local $asGarenaTalk[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($this.DatabaseHandle, $sQuery, $asGarenaTalk, $iRows, $iColumns) <> $SQLITE_OK Then
		Debug('GarenaTalk.class | _SQLite_GetTable2d() failed.', @ScriptLineNumber)
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
	Local $aoGarenaTalk[$iRows]
	For $i = 1 To $iRows
		$aoGarenaTalk[$i - 1] = $this.Client( _
				$asGarenaTalk[$i][0], _
				$asGarenaTalk[$i][1], _
				$asGarenaTalk[$i][2], _
				$asGarenaTalk[$i][3])
	Next

	$this.LastError = 0
	Return $aoGarenaTalk
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaTalk_GetByUsername($this, $sUsername)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT * ' & _
			'FROM GarenaTalk ' & _
			StringFormat("WHERE Username = '%s';", $sUsername)

	Local $asGarenaTalk[0], $iRows = 0, $iColumns = 0
	If _SQLite_GetTable2d($this.DatabaseHandle, $sQuery, $asGarenaTalk, $iRows, $iColumns) <> $SQLITE_OK Then
		Debug('GarenaTalk.class | _SQLite_GetTable2d() failed.', @ScriptLineNumber)
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
	Local $aoGarenaTalk[$iRows]
	For $i = 1 To $iRows
		$aoGarenaTalk[$i - 1] = $this.Client( _
				$asGarenaTalk[$i][0], _
				$asGarenaTalk[$i][1], _
				$asGarenaTalk[$i][2], _
				$asGarenaTalk[$i][3])
	Next

	$this.LastError = 0
	Return $aoGarenaTalk
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaTalk_IsRunning($this, $sUsername, $iServer)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'SELECT COUNT(Socket) ' & _
			'FROM GarenaTalk ' & _
			StringFormat("WHERE Username = '%s' AND Server = %u;", $sUsername, $iServer)

	Local $asCount[0]
	If _SQLite_QuerySingleRow($this.DatabaseHandle, $sQuery, $asCount) <> $SQLITE_OK Then
		Debug('GarenaTalk.class | _SQLite_QuerySingleRow() failed.', @ScriptLineNumber)
	EndIf

	$this.LastError = 0
	Return Int($asCount[0], 1)
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaTalk_Client($this, $iSocket, $sUsername, $iServer, $sExpiryDate)
	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Properties | Private
		.AddProperty('DatabaseHandle', $ELSCOPE_PRIVATE, $this.DatabaseHandle)

		; --- Properties | Read-only
		.AddProperty('Socket', $ELSCOPE_READONLY, Int($iSocket, 1))
		.AddProperty('Username', $ELSCOPE_READONLY, $sUsername)
		.AddProperty('Server', $ELSCOPE_READONLY, Int($iServer, 1))
		.AddProperty('ExpiryDate', $ELSCOPE_READONLY, $sExpiryDate)

		; --- Methods | Public
		.AddMethod('Close', 'GarenaTalk_Client_Close', False)
	EndWith

	$this.LastError = 0
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func GarenaTalk_Client_Close($this)
	;---------------------------------------------------------------------------
	;
	Local $sQuery = 'DELETE FROM GarenaTalk ' & _
			StringFormat('WHERE Socket = %d;', $this.Socket)

	If _SQLite_Exec($this.DatabaseHandle, $sQuery) <> $SQLITE_OK Then
		Debug('GarenaTalk.class | _SQLite_Exec() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	If TCPCloseSocket($this.Socket) Then
		; --- Nothing to do
	Else
		Debug('GarenaTalk.class | TCPCloseSocket() failed.', @ScriptLineNumber)
	EndIf
	;
	;---------------------------------------------------------------------------
EndFunc