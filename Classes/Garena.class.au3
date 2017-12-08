#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func Garena()
	;---------------------------------------------------------------------------
	;
	Local $sLibraries = @ScriptDir & '\Libraries'
	Local $sGarenaMessenger = $sLibraries & '\Garena Messenger.dll'
	Local $sGarenaRoom = $sLibraries & '\Garena Room.dll'

	If FileExists($sGarenaMessenger) And FileExists($sGarenaRoom) Then
		; --- Nothing to do
	Else
		Debug('Garena.class | FileExists() failed.', @ScriptLineNumber)
		Return SetError(1, 0, Null)
	EndIf

	Local $tagClientInfo = 'BOOL fIsSpamBot;' & _
			'CHAR szServerIp[26];' & _
			'DWORD dwRoomId;' & _
			'UINT64 nExpiryDateTimestamp;' & _
			'HWND hWnd'

	RegDelete('HKCU\Software\Microsoft\Windows\CurrentVersion\Run', 'GarenaPlus')
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Properties | Private
		.AddProperty('GarenaMessenger', $ELSCOPE_PRIVATE, $sGarenaMessenger)
		.AddProperty('GarenaRoom', $ELSCOPE_PRIVATE, $sGarenaRoom)
		.AddProperty('tagClientInfo', $ELSCOPE_PRIVATE, $tagClientInfo)

		; --- Methods | Public
		.AddMethod('RunMessenger', 'Garena_RunMessenger', False)
		.AddMethod('RunRoom', 'Garena_RunRoom', False)

		; --- Methods | Private
		.AddMethod('DateToTimestamp', 'Garena_DateToTimestamp', True)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func Garena_RunMessenger($this)
	Return $oInterface.GarenaMessenger($this.GarenaMessenger)
EndFunc

Func Garena_RunRoom($this, $mAccount, $iServer)
	;---------------------------------------------------------------------------
	;
	Local $tClientInfo = DllStructCreate($this.tagClientInfo)
	If @error Then
		Debug('Garena.class | DllStructCreate() failed.', @ScriptLineNumber)
		Return Null
	EndIf

	If $iServer Then
		$tClientInfo.fIsSpamBot = False
		$tClientInfo.szServerIp = $oServer.GarenaRoomServers[$iServer - 1]
		$tClientInfo.nExpiryDateTimestamp = $this.DateToTimestamp($mAccount['ExpiryDate'])
	Else
		$tClientInfo.fIsSpamBot = True
		$tClientInfo.szServerIp = $oServer.GarenaRoomServers[$oServer.GarenaRoomServerCount - 1]
		$tClientInfo.nExpiryDateTimestamp = 0
	EndIf

	$tClientInfo.dwRoomId = $mAccount['RoomId']
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $hWnd = $oInterface.GarenaRoom($mAccount, $tClientInfo, $this.GarenaRoom)
	If $hWnd Then
		; --- Nothing to do
	Else
		Debug('Garena.class | Interface.GarenaRoom() failed.', @ScriptLineNumber)
		Return Null
	EndIf

	Return $oGarenaRoom.Add($hWnd, $mAccount, $iServer)
	;
	;---------------------------------------------------------------------------
EndFunc

Func Garena_DateToTimestamp($this, $sDate)
	#forceref $this

	If $sDate Then
		Local $iYear = Int(StringMid($sDate, 1, 4), 1)
		Local $iMonth = Int(StringMid($sDate, 6, 7), 1)
		Local $iDay = Int(StringMid($sDate, 9, 10), 1)

		If $iYear < 1970 Or $iMonth < 1 Or $iMonth > 12 Or $iDay < 1 Or $iDay > 31 Then
			Return 0
		EndIf
	Else
		Return 0
	EndIf

	If $iMonth < 3 Then
		$iYear -= 1
		$iMonth += 12
	EndIf

	Local $iFactorA = Int($iYear / 100, 1)
	Local $iFactorB = Int($iFactorA / 4, 1)
	Local $iFactorC = Int(1461 * ($iYear + 4716) / 4, 1)
	Local $iFactorD = Int(153 * ($iMonth + 1) / 5, 1)

	Local $iTimestamp = ($iFactorB - $iFactorA + $iDay + $iFactorC + $iFactorD - 2442110) * 86400
	Return Int($iTimestamp, 1) + 86400
EndFunc