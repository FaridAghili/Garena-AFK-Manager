#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func ExpCalculator()
	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 530
	Local $HEIGHT = 255
	Local $LEFT = 1
	Local $TOP = 21

	Local $hWnd = GUICreate('EXP Calculator', $WIDTH + 2, $HEIGHT + 22, -1, -1, $WS_POPUP, 0, $frmMain.Handle)
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

	GUICtrlCreateLabel('EXP Calculator', 6, 3, $WIDTH - 10, 15, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlCreateLabel('Current level:', $LEFT + 50, $TOP + 50, -1, 15)

	Local $txtCurrentLevel = GUICtrlCreateInput('1', $LEFT + 50, $TOP + 70, 100, 20, $ES_NUMBER)
	GUICtrlSetLimit(-1, 3)
	GUICtrlCreateUpdown(-1, $UDS_ARROWKEYS)
	GUICtrlSetLimit(-1, 998, 1)

	GUICtrlCreateLabel('Desired level:', $LEFT + 160, $TOP + 50, -1, 15)

	Local $txtDesiredLevel = GUICtrlCreateInput('2', $LEFT + 160, $TOP + 70, 100, 20, $ES_NUMBER)
	GUICtrlSetLimit(-1, 3)
	GUICtrlCreateUpdown(-1, $UDS_ARROWKEYS)
	GUICtrlSetLimit(-1, 999, 2)

	GUICtrlCreateLabel('Required time:', $LEFT + 50, $TOP + 110, -1, 15)

	Local $lblRequiredTime = GUICtrlCreateLabel('', $LEFT + 50, $TOP + 135, 210, 15)

	GUICtrlCreateButton('Calculate', $LEFT + 160, $TOP + 180, 100, 25, $BS_DEFPUSHBUTTON)
	GUICtrlSetOnEvent(-1, ExpCalculator_btnCalculate_MouseClick)

	Local $btnClose = GUICtrlCreateButton('Close', $LEFT + 50, $TOP + 180, 100, 25)
	GUICtrlSetOnEvent(-1, ExpCalculator_btnClose_MouseClick)

	GUICtrlCreateLabel('Account type:', $LEFT + 280, $TOP + 50, -1, 15)

	Local $cboAccountType = GUICtrlCreateCombo('Basic Member', $LEFT + 280, $TOP + 69, 200, 21, $CBS_DROPDOWNLIST)
	GUICtrlSetData(-1, 'Premium Member½Platinum Member½Channel Admin½League Admin½Admin½Super Admin½Gold Member')

	GUICtrlCreateLabel('AFK server(s):', $LEFT + 280, $TOP + 110, -1, 15)

	Local $lblAfkServers = GUICtrlCreateLabel($oServer.GarenaRoomServerCount, $LEFT + 365, $TOP + 110, -1, 15)

	Local $sldAfkServers = GUICtrlCreateSlider($LEFT + 280, $TOP + 125, 200, 30)
	GUICtrlSetBkColor(-1, 0xEFEFF2)
	GUICtrlSetLimit(-1, $oServer.GarenaRoomServerCount, 1)
	GUICtrlSetData(-1, $oServer.GarenaRoomServerCount)
	GUICtrlSetOnEvent(-1, ExpCalculator_sldAfkServers_MouseClick)

	GUICtrlCreateLabel('AFK hour(s) per day:', $LEFT + 280, $TOP + 165, -1, 15)

	Local $txtAfkHoursPerDay = GUICtrlCreateInput('24', $LEFT + 280, $TOP + 185, 200, 20, $ES_NUMBER)
	GUICtrlSetLimit(-1, 2)
	GUICtrlCreateUpdown(-1, $UDS_ARROWKEYS)
	GUICtrlSetLimit(-1, 24, 1)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $keySelectAll = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, GUICtrlEditOnCtrlA)

	Local $avAccelerators[][] = [['{ESC}', $btnClose], _
			['^a', $keySelectAll]]
	GUISetAccelerators($avAccelerators, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlSetState($txtCurrentLevel, $GUI_FOCUS)

	GUISetState(@SW_DISABLE, $frmMain.Handle)
	GUISetState(@SW_SHOW, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('ExpCalculator_Destructor')

		; --- Properties | Read-only
		.AddProperty('Handle', $ELSCOPE_READONLY, $hWnd)
		.AddProperty('txtCurrentLevel', $ELSCOPE_READONLY, $txtCurrentLevel)
		.AddProperty('txtDesiredLevel', $ELSCOPE_READONLY, $txtDesiredLevel)
		.AddProperty('lblRequiredTime', $ELSCOPE_READONLY, $lblRequiredTime)
		.AddProperty('cboAccountType', $ELSCOPE_READONLY, $cboAccountType)
		.AddProperty('lblAfkServers', $ELSCOPE_READONLY, $lblAfkServers)
		.AddProperty('sldAfkServers', $ELSCOPE_READONLY, $sldAfkServers)
		.AddProperty('sldAfkServersHandle', $ELSCOPE_READONLY, GUICtrlGetHandle($sldAfkServers))
		.AddProperty('txtAfkHoursPerDay', $ELSCOPE_READONLY, $txtAfkHoursPerDay)

		; --- Methods | Public
		.AddMethod('ShowResult', 'ExpCalculator_ShowResult', False)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func ExpCalculator_Destructor($this)
	GUISetState(@SW_ENABLE, $frmMain.Handle)
	GUIDelete($this.Handle)
EndFunc

Func ExpCalculator_btnClose_MouseClick()
	$frmExpCalculator = Null
EndFunc

Func ExpCalculator_btnCalculate_MouseClick()
	If IsObj($frmExpCalculator) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $iCurrentLevel = Int(GUICtrlRead($frmExpCalculator.txtCurrentLevel), 1) - 1
	Local $iDesiredLevel = Int(GUICtrlRead($frmExpCalculator.txtDesiredLevel), 1) - 1

	If $iDesiredLevel < $iCurrentLevel Then
		$oMessage.Warning('Current level cannot be lower than the desired level.', $frmExpCalculator)
		Return
	EndIf

	Local $iAfkHoursPerDay = Int(GUICtrlRead($frmExpCalculator.txtAfkHoursPerDay), 1)
	If $iAfkHoursPerDay < 1 Or $iAfkHoursPerDay > 24 Then
		$oMessage.Warning('AFK hour(s) per day should be between 1 and 24.', $frmExpCalculator)
		Return
	EndIf

	Local $iExpRate = 50

	Local $sAccountType = GUICtrlRead($frmExpCalculator.cboAccountType)
	If $sAccountType = 'Premium Member' Then
		$iExpRate = 75
	ElseIf $sAccountType = 'Gold Member' Then
		$iExpRate = 100
	EndIf

	Local $iAfkServers = Int(GUICtrlRead($frmExpCalculator.sldAfkServers), 1)

	Local $iExp = ($iDesiredLevel * ($iDesiredLevel + 1) * ($iDesiredLevel + 2) + 16 * $iDesiredLevel) * 10 - ($iCurrentLevel * ($iCurrentLevel + 1) * ($iCurrentLevel + 2) + 16 * $iCurrentLevel) * 10
	Local $iHours = Ceiling($iExp / ($iExpRate * 4 * $iAfkServers))

	$frmExpCalculator.ShowResult($iHours, $iAfkHoursPerDay)
EndFunc

Func ExpCalculator_sldAfkServers_MouseClick()
	If IsObj($frmExpCalculator) Then
		GUICtrlSetData($frmExpCalculator.lblAfkServers, GUICtrlRead($frmExpCalculator.sldAfkServers))
	EndIf
EndFunc

Func ExpCalculator_WM_HSCROLL($hWnd, $uMsg, $wParam, $lParam)
	#forceref $hWnd, $uMsg, $wParam

	If IsObj($frmExpCalculator) Then
		If $lParam = $frmExpCalculator.sldAfkServersHandle Then
			ExpCalculator_sldAfkServers_MouseClick()
		EndIf
	EndIf
EndFunc

Func ExpCalculator_ShowResult($this, $iHours, $iHoursPerDay)
	Local $sRequiredTime = ''
	If $iHours < $iHoursPerDay Then
		$sRequiredTime = $iHours & ' hour'
	Else
		Local $iDays = Floor($iHours / $iHoursPerDay)
		Local $iRemainingHours = $iHours - $iDays * $iHoursPerDay

		If $iRemainingHours Then
			$sRequiredTime = StringFormat('%d %s %s %d %s', $iDays, 'day', 'and', $iRemainingHours, 'hour')
		Else
			$sRequiredTime = $iDays & ' day'
		EndIf
	EndIf

	GUICtrlSetData($this.lblRequiredTime, $sRequiredTime)
EndFunc