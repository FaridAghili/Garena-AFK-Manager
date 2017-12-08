#include <WinAPISys.au3>
#include <TrayConstants.au3>

AutoItSetOption('MustDeclareVars', 1)
AutoItSetOption('TrayMenuMode', 1)
AutoItSetOption('TrayOnEventMode', 1)

Global Const $SWITCH_TIME = 10

Global $hInputDesktop = _WinAPI_OpenInputDesktop($DESKTOP_ALL_ACCESS)
If $hInputDesktop Then
	; --- Nothing to do
Else
	MsgBox(BitOR($MB_OK, $MB_ICONERROR), 'AFK Manager', 'OpenInputDesktop failed...')
	Exit 1
EndIf

Global $hPrivateDesktop = _WinAPI_OpenDesktop('AFK Manager: Desktop', $DESKTOP_ALL_ACCESS)
If $hPrivateDesktop Then
	; --- Nothing to do
Else
	_WinAPI_CloseDesktop($hInputDesktop)
	MsgBox(BitOR($MB_OK, $MB_ICONERROR), 'AFK Manager', 'OpenDesktop failed...')
	Exit 2
EndIf

HotKeySet('^!s', SwitchDesktop)
TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, CleanupAndExit)
TraySetToolTip('Desktop Switcher')

While True
	Sleep(1000)
WEnd

Func SwitchDesktop()
	_WinAPI_SwitchDesktop($hPrivateDesktop)
	Sleep($SWITCH_TIME * 1000)
	_WinAPI_SwitchDesktop($hInputDesktop)
EndFunc

Func CleanupAndExit()
	HotKeySet('^!s')

	_WinAPI_CloseDesktop($hPrivateDesktop)
	_WinAPI_CloseDesktop($hInputDesktop)

	Exit 0
EndFunc