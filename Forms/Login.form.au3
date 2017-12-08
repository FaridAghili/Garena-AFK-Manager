#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func Login()
	;---------------------------------------------------------------------------
	;
	Local $WIDTH = 350
	Local $HEIGHT = 473
	Local $LEFT = 1
	Local $TOP = 27

	Local $hWnd = GUICreate($APP_NAME, $WIDTH + 2, $HEIGHT + 51, -1, -1, BitOR($WS_POPUP, $WS_MINIMIZEBOX))
	GUISetBkColor(0xEFEFF2, $hWnd)
	GUISetFont(8.5, $FW_NORMAL, Default, 'Tahoma', $hWnd, $DEFAULT_QUALITY)
	GUISetOnEvent($GUI_EVENT_CLOSE, Login_btnClose_MouseClick, $hWnd)

	GUICtrlCreateLabel('', 0, 0, $WIDTH + 2, 1)
	GUICtrlSetBkColor(-1, 0x007ACC)

	GUICtrlCreateLabel('', $WIDTH + 1, 1, 1, $HEIGHT + 26)
	GUICtrlSetBkColor(-1, 0x007ACC)

	GUICtrlCreateLabel('', 0, $HEIGHT + 27, $WIDTH + 2, 24)
	GUICtrlSetBkColor(-1, 0x007ACC)

	GUICtrlCreateLabel('', 0, 1, 1, $HEIGHT + 26)
	GUICtrlSetBkColor(-1, 0x007ACC)

	GUICtrlCreatePicEx('ICON_PNG', 8, 8, 20, 16)

	GUICtrlCreateLabel($APP_NAME, 35, 1, $WIDTH - 109, 26 + 3, $SS_CENTERIMAGE, $GUI_WS_EX_PARENTDRAG)
	GUICtrlSetColor(-1, 0x717171)
	GUICtrlSetFont(-1, 12)

	GUICtrlCreateLabel('', $WIDTH - 33, 1, 34, 26)
	GUICtrlSetTip(-1, 'Close')
	GUICtrlSetMouseClick(-1, Login_btnClose_MouseClick)
	GUICtrlSetMouseDown(-1, Login_Button_MouseDown)
	GUICtrlSetMouseEnter(-1, Login_Button_MouseEnter)
	GUICtrlSetMouseLeave(-1, Login_Button_MouseLeave)
	GUICtrlSetMouseUp(-1, Login_Button_MouseUp)
	GUICtrlCreatePicEx('CLOSE_PNG', $WIDTH - 33, 1, 34, 26)

	GUICtrlCreateLabel('', $WIDTH - 67, 1, 34, 26)
	GUICtrlSetTip(-1, 'Minimize')
	GUICtrlSetMouseClick(-1, Login_btnMinimize_Click)
	GUICtrlSetMouseDown(-1, Login_Button_MouseDown)
	GUICtrlSetMouseEnter(-1, Login_Button_MouseEnter)
	GUICtrlSetMouseLeave(-1, Login_Button_MouseLeave)
	GUICtrlSetMouseUp(-1, Login_Button_MouseUp)
	GUICtrlCreatePicEx('MINIMIZE_PNG', $WIDTH - 67, 1, 34, 26)

	Local $lblStatusBar = GUICtrlCreateLabel('Ready', 11, $HEIGHT + 28, $WIDTH - 20, 22, $SS_CENTERIMAGE)
	GUICtrlSetBkColor(-1, 0x007ACC)
	GUICtrlSetColor(-1, 0xFFFFFF)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	GUICtrlCreatePicEx('LOGO_PNG', $LEFT + 111, $TOP + 50, 128, 128)

	GUICtrlCreateLabel('Username:', $LEFT + 50, $TOP + 228, -1, 15)

	Local $txtUsername = GUICtrlCreateInput('', $LEFT + 50, $TOP + 248, 250, 20)
	GUICtrlSetLimit(-1, 16)

	GUICtrlCreateLabel('Password:', $LEFT + 50, $TOP + 278, -1, 15)

	Local $txtPassword = GUICtrlCreateInput('', $LEFT + 50, $TOP + 298, 250, 20, BitOR($GUI_SS_DEFAULT_INPUT, $ES_PASSWORD))
	GUICtrlSetLimit(-1, 31)

	Local $chkRememberMe = GUICtrlCreateCheckbox('Remember Me', $LEFT + 50, $TOP + 338, -1, 15)

	Local $btnLogin = GUICtrlCreateButton('Login', $LEFT + 125, $TOP + 373, 100, 25, $BS_DEFPUSHBUTTON)
	GUICtrlSetOnEvent(-1, Login_btnLogin_MouseClick)

	GUICtrlCreateLabel('Forgot password?', $LEFT + 50, $TOP + 418, -1, 15)
	GUICtrlSetColor(-1, 0x007ACC)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetMouseClick(-1, Login_lnkForgotPassword_MouseClick)
	GUICtrlSetMouseEnter(-1, LinkLabel_MouseEnter)
	GUICtrlSetMouseLeave(-1, LinkLabel_MouseLeave)

	GUICtrlCreateLabel("Don't have an account?", $LEFT + 50, $TOP + 438, -1, 15)
	GUICtrlSetColor(-1, 0x007ACC)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetMouseClick(-1, Login_lnkDontHaveAnAccount_MouseClick)
	GUICtrlSetMouseEnter(-1, LinkLabel_MouseEnter)
	GUICtrlSetMouseLeave(-1, LinkLabel_MouseLeave)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $keySelectAll = GUICtrlCreateDummy()
	GUICtrlSetOnEvent(-1, GUICtrlEditOnCtrlA)

	Local $avAccelerators[][] = [['^a', $keySelectAll]]
	GUISetAccelerators($avAccelerators, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $sUsername = $oSettings.Username
	Local $sPassword = $oSettings.Password

	If $sUsername And $sPassword Then
		GUICtrlSetData($txtUsername, $sUsername)
		GUICtrlSetData($txtPassword, $sPassword)
		GUICtrlSetState($chkRememberMe, $GUI_CHECKED)
		GUICtrlSetState($btnLogin, $GUI_FOCUS)
	EndIf

	AdlibRegister(Login_StatusClean, 1000)
	GUISetState(@SW_SHOW, $hWnd)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('Login_Destructor')

		; --- Properties | Read-only
		.AddProperty('Handle', $ELSCOPE_READONLY, $hWnd)
		.AddProperty('lblStatusBar', $ELSCOPE_READONLY, $lblStatusBar)
		.AddProperty('txtUsername', $ELSCOPE_READONLY, $txtUsername)
		.AddProperty('txtPassword', $ELSCOPE_READONLY, $txtPassword)
		.AddProperty('chkRememberMe', $ELSCOPE_READONLY, $chkRememberMe)
		.AddProperty('StatusTimer', $ELSCOPE_READONLY, 0)
		.AddProperty('StatusDuration', $ELSCOPE_READONLY, 0)

		; --- Properties | Public
		.AddProperty('StatusReset', $ELSCOPE_PUBLIC, False)

		; --- Methods | Public
		.AddMethod('Status', 'Login_Status', False)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func Login_Destructor($this)
	AdlibUnRegister(Login_StatusClean)
	GUIUnsetMouseEvents($this.Handle)
	GUIDelete($this.Handle)
EndFunc

Func Login_Button_MouseDown($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0x007ACC)
EndFunc

Func Login_Button_MouseEnter($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xFEFEFE)
EndFunc

Func Login_Button_MouseLeave($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xEFEFF2)
EndFunc

Func Login_Button_MouseUp($mParam)
	GUICtrlSetBkColor($mParam['Id'], 0xFEFEFE)
EndFunc

Func Login_btnClose_MouseClick()
	$frmLogin = Null
	Exit
EndFunc

Func Login_btnMinimize_Click()
	GUISetState(@SW_MINIMIZE, $frmLogin.Handle)
EndFunc

Func Login_btnLogin_MouseClick()
	If IsObj($frmLogin) Then
		; --- Nothing to do
	Else
		Return
	EndIf

	Local $sUsername = GUICtrlRead($frmLogin.txtUsername)
	Local $sPassword = GUICtrlRead($frmLogin.txtPassword)

	If $sUsername And $sPassword Then
		; --- Nothing to do
	Else
		$oMessage.Warning('Please enter both username and password.', $frmLogin)
		GUICtrlSetState($sUsername ? $frmLogin.txtPassword : $frmLogin.txtUsername, $GUI_FOCUS)
		Return
	EndIf

	$frmLogin.Status('Authenticating...')

	Switch $oServer.Login($sUsername, $sPassword)
		Case $oServer.Result.Success
			If GUICtrlRead($frmLogin.chkRememberMe) = $GUI_CHECKED Then
				$oSettings.Username = $sUsername
				$oSettings.Password = $sPassword
			Else
				$oSettings.Username = ''
				$oSettings.Password = ''
			EndIf

			If $oServer.Version > $APP_VERSION Then
				$oServer.Logout()

				Local $sWorkingDirectory = @LocalAppDataDir & '\' & $APP_NAME
				Local $sUpdaterPath = $sWorkingDirectory & '\Updater.exe'
				Local $sModulePath = @ScriptDir & '\Modules\Updater.gpm'
				Local $sUrl = 'http://www.afk-manager.ir/downloads/AFK-Manager-' & StringFormat('%.1f', $oServer.Version) & '-Setup.exe'

				FileCopy(@ScriptFullPath, $sUpdaterPath, $FC_OVERWRITE)
				RunAutoItScript($sUpdaterPath, $sModulePath, $sUrl, $sWorkingDirectory)

				Login_btnClose_MouseClick()
			EndIf

			$frmMain = Main()
			Return

		Case $oServer.Result.Invalid
			$oMessage.Warning('Invalid username and/or password.', $frmLogin)

			$oSettings.Username = ''
			$oSettings.Password = ''
			GUICtrlSetData($frmLogin.txtUsername, '')
			GUICtrlSetData($frmLogin.txtPassword, '')
			GUICtrlSetState($frmLogin.chkRememberMe, $GUI_UNCHECKED)
			GUICtrlSetState($frmLogin.txtUsername, $GUI_FOCUS)

		Case $oServer.Result.Expired
			$oMessage.Warning('Your account has expired.', $frmLogin)

		Case $oServer.Result.UserLimit
			$oMessage.Warning('Your account has reached its online users limit.', $frmLogin)

		Case $oServer.Result.Locked
			$oMessage.Warning('Your account is locked.', $frmLogin)

		Case $oServer.Result.InternetError
			$oMessage.Warning('Unable to connect to server.' & @CRLF & 'Check your internet connection and try again.', $frmLogin)
	EndSwitch

	$frmLogin.Status('Ready')
EndFunc

Func Login_lnkForgotPassword_MouseClick()
	ShellExecute($URL_PASSWORDRESET)
EndFunc

Func Login_lnkDontHaveAnAccount_MouseClick()
	ShellExecute($URL_ACCOUNTPURCHASE)
EndFunc

Func Login_Status($this, $sStatus, $iDuration = 3)
	GUICtrlSetData($this.lblStatusBar, $sStatus)

	$this.StatusDuration = $iDuration * 1000
	$this.StatusTimer = TimerInit()
	$this.StatusReset = True
EndFunc

Func Login_StatusClean()
	If IsObj($frmLogin) Then
		If $frmLogin.StatusReset And TimerDiff($frmLogin.StatusTimer) > $frmLogin.StatusDuration Then
			$frmLogin.StatusReset = False
			GUICtrlSetData($frmLogin.lblStatusBar, 'Ready')
		EndIf
	EndIf
EndFunc