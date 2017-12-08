#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func Timer($fuFunction, $iInterval, $bEnabled = True)
	;---------------------------------------------------------------------------
	;
	If IsFunc($fuFunction) Then
		; --- Nothing to do
	Else
		Return SetError(1, 0, Null)
	EndIf

	Local $hFunction = DllCallbackRegister($fuFunction, 'NONE', 'HWND;UINT;UINT_PTR;DWORD')
	If $hFunction Then
		; --- Nothing to do
	Else
		Return SetError(2, 0, Null)
	EndIf

	If $iInterval < 10 Then
		$iInterval = 10
	ElseIf $iInterval > 2147483647 Then
		$iInterval = 2147483647
	Else
		; --- Nothing to do
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $iTimerId = 0

	If $bEnabled Then
		$iTimerId = _WinAPI_SetTimer(0, 0, $iInterval, DllCallbackGetPtr($hFunction))
		If $iTimerId Then
			; --- Nothing to do
		Else
			DllCallbackFree($hFunction)
			Return SetError(3, 0, Null)
		EndIf
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('Timer_Destructor')

		; --- Properties | Private
		.AddProperty('Id', $ELSCOPE_PRIVATE, $iTimerId)
		.AddProperty('FunctionHandle', $ELSCOPE_PRIVATE, $hFunction)
		.AddProperty('IsEnable', $ELSCOPE_PRIVATE, $bEnabled)
		.AddProperty('CurrentInterval', $ELSCOPE_PRIVATE, $iInterval)

		; --- Methods | Public
		.AddMethod('Enabled', 'Timer_Enabled', False)
		.AddMethod('Interval', 'Timer_Interval', False)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func Timer_Destructor($this)
	If $this.IsEnable Then
		_WinAPI_KillTimer(0, $this.Id)
	EndIf

	DllCallbackFree($this.FunctionHandle)
EndFunc

Func Timer_Enabled($this, $fEnable = True)
	If @NumParams = 2 Then
		If $fEnable = $this.IsEnable Then
			Return
		EndIf

		If $fEnable Then
			$this.Id = _WinAPI_SetTimer(0, 0, $this.CurrentInterval, DllCallbackGetPtr($this.FunctionHandle))
		Else
			_WinAPI_KillTimer(0, $this.Id)
		EndIf

		$this.IsEnable = $fEnable
	Else
		Return $this.IsEnable
	EndIf
EndFunc

Func Timer_Interval($this, $iInterval = 1000)
	If @NumParams = 2 Then
		If $iInterval < 10 Then
			$iInterval = 10
		ElseIf $iInterval > 2147483647 Then
			$iInterval = 2147483647
		Else
			; --- Nothing to do
		EndIf

		$this.CurrentInterval = $iInterval

		If $this.IsEnable Then
			_WinAPI_SetTimer(0, $this.Id, $iInterval, DllCallbackGetPtr($this.FunctionHandle))
		EndIf
	Else
		Return $this.CurrentInterval
	EndIf
EndFunc