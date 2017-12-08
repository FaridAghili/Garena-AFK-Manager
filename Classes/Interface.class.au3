#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func Interface()
	;---------------------------------------------------------------------------
	;
	Local $sInterface = @ScriptDir & '\Libraries\Interface.dll'

	If FileExists($sInterface) Then
		; --- Nothing to do
	Else
		Debug('Interface.class | FileExists() failed.', @ScriptLineNumber)
		Return SetError(1, 0, Null)
	EndIf

	Local $hInterface = DllOpen($sInterface)
	If $hInterface = -1 Then
		Debug('Interface.class | DllOpen() failed.', @ScriptLineNumber)
		Return SetError(2, 0, Null)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('Interface_Destructor')

		; --- Properties | Private
		.AddProperty('Interface', $ELSCOPE_PRIVATE, $hInterface)

		; --- Methods | Public
		.AddMethod('GarenaMessenger', 'Interface_GarenaMessenger', False)
		.AddMethod('GarenaRoom', 'Interface_GarenaRoom', False)
		.AddMethod('IsClientConnectedToRoomServer', 'Interface_IsClientConnectedToRoomServer', False)
		.AddMethod('IsRoomPasswordWrong', 'Interface_IsRoomPasswordWrong', False)
		.AddMethod('MD5', 'Interface_MD5', False)
		.AddMethod('ProcessGetFileName', 'Interface_ProcessGetFileName', False)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func Interface_Destructor($this)
	DllClose($this.Interface)
EndFunc

Func Interface_GarenaMessenger($this, $sGarenaMessengerDll)
	;---------------------------------------------------------------------------
	;
	Local $sCurrentDirectory = GarenaPlusPath()
	Local $sApplicationName = $sCurrentDirectory & '\GarenaMessenger.exe'
	Local $sCommandLine = '-ignoreupdate'
	;
	;---------------------------------------------------------------------------

	Local $avResult = DllCall($this.Interface, 'BOOL:cdecl', 'GarenaMessenger', _
			'STR', $sApplicationName, _
			'STR', StringFormat('"%s" %s', $sApplicationName, $sCommandLine), _
			'STR', $sCurrentDirectory, _
			'STR', $sGarenaMessengerDll)
	If @error Then
		Debug('Interface.class | DllCall() failed.', @ScriptLineNumber)
		Return SetError(1, 0, False)
	EndIf

	Return $avResult[0]
EndFunc

Func Interface_GarenaRoom($this, $mAccount, $tClientInfo, $sGarenaRoomDll)
	;---------------------------------------------------------------------------
	;
	Local $sCurrentDirectory = GarenaPlusPath() & '\Room'
	Local $sApplicationName = $sCurrentDirectory & '\garena_room.exe'
	Local $sCommandLine = StringFormat('--u%s,--p%s,--r%s,', $mAccount['Username'], $mAccount['Password'], $mAccount['RoomId'])
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $avResult = DllCall($this.Interface, 'HWND:cdecl', 'GarenaRoom', _
			'STR', $sApplicationName, _
			'STR', $sCommandLine, _
			'STR', $sCurrentDirectory, _
			'STR', $sGarenaRoomDll, _
			'STRUCT*', $tClientInfo)
	If @error Then
		Debug('Interface.class | DllCall() failed.', @ScriptLineNumber)
		Return SetError(1, 0, 0)
	EndIf

	Return $avResult[0]
	;
	;---------------------------------------------------------------------------
EndFunc

Func Interface_IsClientConnectedToRoomServer($this, $iProcessId)
	If IsInt($iProcessId) And ProcessExists($iProcessId) Then
		; --- Nothing to do
	Else
		Return SetError(1, 0, False)
	EndIf

	Local $avResult = DllCall($this.Interface, 'BOOL:cdecl', '_IsClientConnectedToRoomServer', _
			'DWORD', $iProcessId)
	If @error Then
		Debug('Interface.class | DllCall() failed.', @ScriptLineNumber)
		Return SetError(2, 0, False)
	EndIf

	Return $avResult[0]
EndFunc

Func Interface_IsRoomPasswordWrong($this, $iProcessId)
	If IsInt($iProcessId) And ProcessExists($iProcessId) Then
		; --- Nothing to do
	Else
		Return SetError(1, 0, False)
	EndIf

	Local $avResult = DllCall($this.Interface, 'BOOL:cdecl', 'IsRoomPasswordWrong', _
			'DWORD', $iProcessId)
	If @error Then
		Debug('Interface.class | DllCall() failed.', @ScriptLineNumber)
		Return SetError(2, 0, False)
	EndIf

	Return $avResult[0]
EndFunc

Func Interface_MD5($this, $sInput)
	If IsString($sInput) And StringLen($sInput) Then
		; --- Nothing to do
	Else
		Debug('Interface.class | IsString() or StringLen() failed.', @ScriptLineNumber)
		Return SetError(1, 0, '')
	EndIf

	Local $tBuffer = DllStructCreate('BYTE[16]')
	If @error Then
		Debug('Interface.class | DllStructCreate() failed.', @ScriptLineNumber)
		Return SetError(2, 0, '')
	EndIf

	Local $avResult = DllCall($this.Interface, 'BOOL:cdecl', '_MD5', _
			'STR', $sInput, _
			'STRUCT*', $tBuffer)
	If @error Or Not $avResult[0] Then
		Debug('Interface.class | DllCall() failed.', @ScriptLineNumber)
		Return SetError(3, 0, '')
	EndIf

	Local $dResult = DllStructGetData($tBuffer, 1)
	Local $sResult = StringLower(StringTrimLeft($dResult, 2))

	Return $sResult
EndFunc

Func Interface_ProcessGetFileName($this, $iProcessId)
	Local Const $MAX_PATH = 260

	If IsInt($iProcessId) And ProcessExists($iProcessId) Then
		; --- Nothing to do
	Else
		Return SetError(1, 0, '')
	EndIf

	Local $tBuffer = DllStructCreate('CHAR[' & $MAX_PATH & ']')
	If @error Then
		Debug('Interface.class | DllStructCreate() failed.', @ScriptLineNumber)
		Return SetError(2, 0, '')
	EndIf

	Local $avResult = DllCall($this.Interface, 'DWORD:cdecl', '_ProcessGetFileName', _
			'DWORD', $iProcessId, _
			'STRUCT*', $tBuffer, _
			'DWORD', $MAX_PATH)
	If @error Or Not $avResult[0] Then
		Debug('Interface.class | DllCall() failed.', @ScriptLineNumber)
		Return SetError(3, 0, '')
	EndIf

	Return DllStructGetData($tBuffer, 1)
EndFunc