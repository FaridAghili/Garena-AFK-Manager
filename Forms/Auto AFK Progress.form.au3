#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func AutoAfkProgress($frmParent, $sTitle)
	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 400
	Local $HEIGHT = 445
	Local $LEFT = 1
	Local $TOP = 21

	Local $hWnd = GUICreate($sTitle, $WIDTH + 2, $HEIGHT + 22, -1, -1, $WS_POPUP, 0, $frmParent.Handle)
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

	GUICtrlCreateLabel($sTitle, 6, 3, $WIDTH - 10, 15, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $txtLog = GUICtrlCreateEdit('', $LEFT + 50, $TOP + 50, 300, 300, BitOR($WS_VSCROLL, $ES_READONLY))
	GUICtrlSetBkColor(-1, 0xFFFFFF)

	Local $btnCancel = GUICtrlCreateButton('Cancel', $LEFT + 150, $TOP + 370, 100, 25)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUISetState(@SW_DISABLE, $frmParent.Handle)
	GUISetState(@SW_SHOW, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('AutoAfkProgress_Destructor')

		; --- Properties | Read-only
		.AddProperty('Parent', $ELSCOPE_READONLY, $frmParent)
		.AddProperty('Handle', $ELSCOPE_READONLY, $hWnd)
		.AddProperty('txtLog', $ELSCOPE_READONLY, $txtLog)
		.AddProperty('btnCancel', $ELSCOPE_READONLY, $btnCancel)

		; --- Properties | Public
		.AddProperty('Interrupt', $ELSCOPE_PUBLIC, False)

		; --- Methods | Public
		.AddMethod('Log', 'AutoAfkProgress_Log', False)
		.AddMethod('Finilize', 'AutoAfkProgress_Finilize', False)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func AutoAfkProgress_Destructor($this)
	GUISetState(@SW_ENABLE, $this.Parent.Handle)
	GUIDelete($this.Handle)
EndFunc

Func AutoAfkProgress_Close_MouseClick()
	$frmAutoAfkProgress = Null
EndFunc

Func AutoAfkProgress_WM_COMMAND($hWnd, $uMsg, $wParam, $lParam)
	#forceref $hWnd, $uMsg, $lParam

	If IsObj($frmAutoAfkProgress) Then
		If _WinAPI_LoWord($wParam) = $frmAutoAfkProgress.btnCancel And _WinAPI_HiWord($wParam) = $BN_CLICKED Then
			$frmAutoAfkProgress.Interrupt = True
		EndIf
	EndIf
EndFunc

Func AutoAfkProgress_Log($this, $sText, $bTime = True)
	If $bTime Then
		$sText = StringFormat('[%02i:%02i:%02i] %s', @HOUR, @MIN, @SEC, $sText)
		If GUICtrlRead($this.txtLog) Then
			$sText = @CRLF & $sText
		EndIf
	Else
		If GUICtrlRead($this.txtLog) Then
			$sText = @CRLF & @CRLF & $sText
		EndIf
	EndIf

	_GUICtrlEdit_AppendText($this.txtLog, $sText)
EndFunc

Func AutoAfkProgress_Finilize($this)
	GUICtrlSetData($this.btnCancel, 'Close')
	GUICtrlSetOnEvent($this.btnCancel, AutoAfkProgress_Close_MouseClick)

	GUISetState(@SW_ENABLE, $this.Parent.Handle)
	WinActivate($this.Handle)
EndFunc