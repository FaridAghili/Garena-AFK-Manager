#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7

;---------------------------------------------------------------------------
;
AutoItSetOption('GUICloseOnESC', 0)
AutoItSetOption('GUIDataSeparatorChar', '½')
AutoItSetOption('GUIOnEventMode', 1)
AutoItSetOption('MustDeclareVars', 1)
AutoItSetOption('TCPTimeout', 10000)
AutoItSetOption('TrayMenuMode', 1)
AutoItSetOption('TrayOnEventMode', 1)
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
Global Const $APP_NAME = 'AFK Manager'
Global Const $APP_VERSION = 6.5

Global Const $URL_HOMEPAGE = 'http://www.afk-manager.ir/'
Global Const $URL_ACCOUNTPURCHASE = $URL_HOMEPAGE & 'AccountPurchase'
Global Const $URL_ACCOUNTRENEW = $URL_HOMEPAGE & 'AccountRenew'
Global Const $URL_PASSWORDCHANGE = $URL_HOMEPAGE & 'PasswordChange'
Global Const $URL_PASSWORDRESET = $URL_HOMEPAGE & 'PasswordReset'
Global Const $URL_FAQ = $URL_HOMEPAGE & 'FAQ'

Global Const $TIME_25_MINUTES = 1500000
Global Const $TIME_8_HOURS = 28800000
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
Global $oErrorHandler = Null

Global $oAccounts = Null
Global $oGarenaRoom = Null
Global $oGarenaTalk = Null
Global $oGarena = Null
Global $oInterface = Null
Global $oMessage = Null
Global $oServer = Null
Global $oSettings = Null

Global $frmAbout = Null
Global $frmAutoAfkProgress = Null
Global $frmEditAccount = Null
Global $frmExpCalculator = Null
Global $frmLogin = Null
Global $frmMain = Null
Global $frmMyAccount = Null
Global $frmNewAccount = Null
Global $frmRoomClientManager = Null
Global $frmRoomList = Null
Global $frmSpamBot = Null
Global $frmTalkClientManager = Null

Global $hMutex = 0
Global $mTalkProcessId[]
;
;---------------------------------------------------------------------------

;---------------------------------------------------------------------------
;
#include <Date.au3>
#include <GuiButton.au3>
#include <GuiComboBox.au3>
#include <GuiMenu.au3>
#include <SQLite.au3>
#include <WinAPIFiles.au3>
#include <WinAPIProc.au3>
#include <WinAPISys.au3>
#include <WinAPITheme.au3>

#include <APIErrorsConstants.au3>
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <TrayConstants.au3>
#include <UpDownConstants.au3>

#include 'Includes\AutoItObject.au3'
#include 'Includes\Curl.au3'
#include 'Includes\Functions.au3'
#include 'Includes\Json.au3'
#include 'Includes\MouseEventHandler.au3'

#include 'Classes\Accounts.class.au3'
#include 'Classes\Garena Room.class.au3'
#include 'Classes\Garena Talk.class.au3'
#include 'Classes\Garena.class.au3'
#include 'Classes\Interface.class.au3'
#include 'Classes\Message.class.au3'
#include 'Classes\Server.class.au3'
#include 'Classes\Settings.class.au3'
#include 'Classes\Timer.class.au3'

#include 'Forms\About.form.au3'
#include 'Forms\Auto AFK Progress.form.au3'
#include 'Forms\Edit Account.form.au3'
#include 'Forms\EXP Calculator.form.au3'
#include 'Forms\Login.form.au3'
#include 'Forms\Main.form.au3'
#include 'Forms\My Account.form.au3'
#include 'Forms\New Account.form.au3'
#include 'Forms\Room Client Manager.form.au3'
#include 'Forms\Room List.form.au3'
#include 'Forms\SpamBot.form.au3'
#include 'Forms\Talk Client Manager.form.au3'
;
;---------------------------------------------------------------------------