#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func Settings()
	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Properties | Private
		.AddProperty('KeyName', $ELSCOPE_PRIVATE, 'HKCU\Software\' & $APP_NAME)

		; --- Methods | Public
		.AddMethod('Username', 'Settings_Username', False)
		.AddMethod('Password', 'Settings_Password', False)

		.AddMethod('SpamBotUsername', 'Settings_SpamBotUsername', False)
		.AddMethod('SpamBotPassword', 'Settings_SpamBotPassword', False)
		.AddMethod('SpamBotRooms', 'Settings_SpamBotRooms', False)
		.AddMethod('SpamBotInterval', 'Settings_SpamBotInterval', False)
		.AddMethod('SpamBotMessage1', 'Settings_SpamBotMessage1', False)
		.AddMethod('SpamBotMessage2', 'Settings_SpamBotMessage2', False)
		.AddMethod('SpamBotMessage3', 'Settings_SpamBotMessage3', False)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func Settings_Username($this, $sUsername = '')
	If @NumParams = 2 Then
		RegWrite($this.KeyName, 'Username', 'REG_SZ', $sUsername)
	Else
		Return RegRead($this.KeyName, 'Username')
	EndIf
EndFunc

Func Settings_Password($this, $sPassword = '')
	If @NumParams = 2 Then
		If StringLen($sPassword) And StringLen($sPassword) <> 32 Then
			$sPassword = $oInterface.MD5($sPassword)
			If @error Then
				Debug('Settings.class | MD5() failed.', @ScriptLineNumber)
				Return
			EndIf
		EndIf

		RegWrite($this.KeyName, 'Password', 'REG_SZ', $sPassword)
	Else
		Return RegRead($this.KeyName, 'Password')
	EndIf
EndFunc

Func Settings_SpamBotUsername($this, $sUsername = '')
	If @NumParams = 2 Then
		RegWrite($this.KeyName, 'SpamBot Username', 'REG_SZ', $sUsername)
	Else
		Return RegRead($this.KeyName, 'SpamBot Username')
	EndIf
EndFunc

Func Settings_SpamBotPassword($this, $sPassword = '')
	If @NumParams = 2 Then
		If $sPassword Then
			$sPassword = $oInterface.MD5($sPassword)
		EndIf

		RegWrite($this.KeyName, 'SpamBot Password', 'REG_SZ', $sPassword)
	Else
		Return RegRead($this.KeyName, 'SpamBot Password')
	EndIf
EndFunc

Func Settings_SpamBotRooms($this, $aiCheckedRoom = '')
	Local $sCheckedRooms = ''

	If @NumParams = 2 Then
		For $iCheckedRoom In $aiCheckedRoom
			$sCheckedRooms &= $iCheckedRoom & ','
		Next

		If $sCheckedRooms Then
			$sCheckedRooms = StringTrimRight($sCheckedRooms, 1)
		EndIf

		RegWrite($this.KeyName, 'SpamBot Rooms', 'REG_SZ', $sCheckedRooms)
	Else
		$sCheckedRooms = RegRead($this.KeyName, 'SpamBot Rooms')
		If $sCheckedRooms Then
			Return StringSplit($sCheckedRooms, ',', $STR_NOCOUNT)
		EndIf

		Local $aiEmpty[0]
		Return $aiEmpty
	EndIf
EndFunc

Func Settings_SpamBotInterval($this, $iInterval = 1)
	If @NumParams = 2 Then
		RegWrite($this.KeyName, 'SpamBot Interval', 'REG_DWORD', $iInterval)
	Else
		$iInterval = RegRead($this.KeyName, 'SpamBot Interval')

		If $iInterval < 1 Then
			$iInterval = 1
			$this.SpamBotInterval = $iInterval
		ElseIf $iInterval > 720 Then
			$iInterval = 720
			$this.SpamBotInterval = $iInterval
		Else
			; --- Nothing to do
		EndIf

		Return $iInterval
	EndIf
EndFunc

Func Settings_SpamBotMessage1($this, $sMessage = '')
	If @NumParams = 2 Then
		RegWrite($this.KeyName, 'SpamBot Message 1', 'REG_SZ', $sMessage)
	Else
		Return RegRead($this.KeyName, 'SpamBot Message 1')
	EndIf
EndFunc

Func Settings_SpamBotMessage2($this, $sMessage = '')
	If @NumParams = 2 Then
		RegWrite($this.KeyName, 'SpamBot Message 2', 'REG_SZ', $sMessage)
	Else
		Return RegRead($this.KeyName, 'SpamBot Message 2')
	EndIf
EndFunc

Func Settings_SpamBotMessage3($this, $sMessage = '')
	If @NumParams = 2 Then
		RegWrite($this.KeyName, 'SpamBot Message 3', 'REG_SZ', $sMessage)
	Else
		Return RegRead($this.KeyName, 'SpamBot Message 3')
	EndIf
EndFunc