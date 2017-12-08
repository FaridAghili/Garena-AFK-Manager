#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7

#include <GDIPlus.au3>
#include <GuiEdit.au3>
#include <GuiListView.au3>
#include <WinAPIRes.au3>
#include <FontConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>

Func Debug($sOutput, $iScriptLineNumber)
	Local $sDateTime = StringFormat('%04u-%02u-%02u %02u:%02u:%02u', @YEAR, @MON, @MDAY, @HOUR, @MIN, @SEC)
	Local $sError = StringFormat('[%s] %u: %s\r\n', $sDateTime, $iScriptLineNumber, $sOutput)

	If @Compiled Then
		Local $hFile = FileOpen(@ScriptDir & '\Errors.txt', $FO_APPEND)
		FileWrite($hFile, $sError)
		FileClose($hFile)
	Else
		ConsoleWrite('!' & $sError)
	EndIf
EndFunc

Func GarenaPlusPath()
	Local $sGarenaMessenger = '\GarenaMessenger.exe'
	Local $sGarenaRoom = '\Room\garena_room.exe'

	Local $sPath = RegRead('HKCU\Software\AFK Manager', 'Garena Plus Path')
	If $sPath Then
		If FileExists($sPath & $sGarenaMessenger) And FileExists($sPath & $sGarenaRoom) Then
			Return $sPath
		EndIf
	EndIf

	$sPath = @ProgramFilesDir & '\Garena Plus'
	If FileExists($sPath & $sGarenaMessenger) And FileExists($sPath & $sGarenaRoom) Then
		RegWrite('HKCU\Software\AFK Manager', 'Garena Plus Path', 'REG_SZ', $sPath)
		Return $sPath
	EndIf

	$sPath = RegRead('HKLM\SOFTWARE\Garena\im', 'Path')
	If $sPath Then
		If FileExists($sPath & $sGarenaMessenger) And FileExists($sPath & $sGarenaRoom) Then
			RegWrite('HKCU\Software\AFK Manager', 'Garena Plus Path', 'REG_SZ', $sPath)
			Return $sPath
		EndIf
	EndIf

	RegWrite('HKCU\Software\AFK Manager', 'Garena Plus Path', 'REG_SZ', '')
	Return ''
EndFunc

Func GetStringSize($sText, $iSize, $iWeight, $iAttribute, $sName)
	Local $hDC = _WinAPI_GetDC(Null)
	If $hDC Then
		; --- Nothing to do
	Else
		Return SetError(1, 0, Null)
	EndIf

	Local $iInfo = _WinAPI_GetDeviceCaps($hDC, $LOGPIXELSY)
	If $iInfo Then
		; --- Nothing to do
	Else
		_WinAPI_ReleaseDC(Null, $hDC)
		Return SetError(2, 0, Null)
	EndIf

	Local $hFont = _WinAPI_CreateFont(-$iInfo * $iSize / 72, 0, 0, 0, $iWeight, BitAND($iAttribute, 2), BitAND($iAttribute, 4), BitAND($iAttribute, 8), 0, 0, 0, 5, 0, $sName)
	If $hFont Then
		; --- Nothing to do
	Else
		_WinAPI_ReleaseDC(Null, $hDC)
		Return SetError(3, 0, Null)
	EndIf

	Local $hPreviousFont = _WinAPI_SelectObject($hDC, $hFont)
	If $hPreviousFont <= 0 Then
		_WinAPI_DeleteObject($hFont)
		_WinAPI_ReleaseDC(Null, $hDC)
		Return SetError(4, 0, Null)
	EndIf

	Local $tSize = _WinAPI_GetTextExtentPoint32($hDC, $sText)
	If @error Then
		_WinAPI_SelectObject($hDC, $hPreviousFont)

		_WinAPI_DeleteObject($hFont)
		_WinAPI_ReleaseDC(Null, $hDC)
		Return SetError(5, 0, Null)
	EndIf

	_WinAPI_SelectObject($hDC, $hPreviousFont)

	_WinAPI_DeleteObject($hFont)
	_WinAPI_ReleaseDC(Null, $hDC)

	Local $avSizeInfo[] = [$sText, DllStructGetData($tSize, 'X'), DllStructGetData($tSize, 'Y')]
	Return $avSizeInfo
EndFunc

Func GUICtrlCreatePicEx($sResourceName, $iX, $iY, $iWidth, $iHeight, $iStyle = -1, $iExStyle = -1)
	Local $hBitmap = 0, $hPreviousBitmap = 0
	Local $iCtrlId = 0

	If @Compiled Then
		Local $hModule = _WinAPI_GetModuleHandle(Null)
		If $hModule Then
			; --- Nothing to do
		Else
			Return SetError(1, 0, 0)
		EndIf

		Local $hResourceInfo = _WinAPI_FindResource($hModule, $RT_RCDATA, $sResourceName)
		If $hResourceInfo Then
			; --- Nothing to do
		Else
			Return SetError(2, 0, 0)
		EndIf

		Local $hResourceData = _WinAPI_LoadResource($hModule, $hResourceInfo)
		If $hResourceData Then
			; --- Nothing to do
		Else
			Return SetError(3, 0, 0)
		EndIf

		Local $pResourceData = _WinAPI_LockResource($hResourceData)
		If $pResourceData Then
			; --- Nothing to do
		Else
			Return SetError(4, 0, 0)
		EndIf

		Local $iResourceSize = _WinAPI_SizeOfResource($hModule, $hResourceInfo)
		If $iResourceSize Then
			; --- Nothing to do
		Else
			Return SetError(5, 0, 0)
		EndIf

		Local $hMemory = _MemGlobalAlloc($iResourceSize, $GMEM_MOVEABLE)
		If $hMemory Then
			; --- Nothing to do
		Else
			Return SetError(6, 0, 0)
		EndIf

		Local $pMemory = _MemGlobalLock($hMemory)
		If $pMemory Then
			; --- Nothing to do
		Else
			_MemGlobalFree($hMemory)
			Return SetError(7, 0, 0)
		EndIf

		_MemMoveMemory($pResourceData, $pMemory, $iResourceSize)
		If @error Then
			_MemGlobalUnlock($hMemory)
			_MemGlobalFree($hMemory)
			Return SetError(8, 0, 0)
		EndIf

		_MemGlobalUnlock($hMemory)

		Local $pStream = _WinAPI_CreateStreamOnHGlobal($hMemory)
		If $pStream Then
			; --- Nothing to do
		Else
			_MemGlobalFree($hMemory)
			Return SetError(9, 0, 0)
		EndIf

		Local $hBitmapFromStream = _GDIPlus_BitmapCreateFromStream($pStream)
		If $hBitmapFromStream Then
			; --- Nothing to do
		Else
			_WinAPI_ReleaseStream($pStream)
			_MemGlobalFree($hMemory)
			Return SetError(10, 0, 0)
		EndIf

		$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hBitmapFromStream)
		If $hBitmap Then
			; --- Nothing to do
		Else
			_GDIPlus_BitmapDispose($hBitmapFromStream)
			_WinAPI_ReleaseStream($pStream)
			_MemGlobalFree($hMemory)
			Return SetError(11, 0, 0)
		EndIf

		$iCtrlId = GUICtrlCreatePic('', $iX, $iY, $iWidth, $iHeight, $iStyle, $iExStyle)
		If $iCtrlId Then
			; --- Nothing to do
		Else
			_WinAPI_DeleteObject($hBitmap)
			_GDIPlus_BitmapDispose($hBitmapFromStream)
			_WinAPI_ReleaseStream($pStream)
			_MemGlobalFree($hMemory)
		EndIf

		$hPreviousBitmap = GUICtrlSendMsg($iCtrlId, $STM_SETIMAGE, $IMAGE_BITMAP, $hBitmap)
		If $hPreviousBitmap Then
			_WinAPI_DeleteObject($hPreviousBitmap)
		EndIf

		_WinAPI_DeleteObject($hBitmap)
		_GDIPlus_BitmapDispose($hBitmapFromStream)
		_WinAPI_ReleaseStream($pStream)
		_MemGlobalFree($hMemory)

		Return $iCtrlId
	Else
		Local $hImage = _GDIPlus_ImageLoadFromFile('Resources\' & $sResourceName & '.png')
		If @error Then
			Return SetError(1, 0, 0)
		EndIf

		$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
		If @error Then
			_GDIPlus_ImageDispose($hImage)
			Return SetError(2, 0, 0)
		EndIf

		_GDIPlus_ImageDispose($hImage)

		$iCtrlId = GUICtrlCreatePic('', $iX, $iY, $iWidth, $iHeight, $iStyle, $iExStyle)

		$hPreviousBitmap = GUICtrlSendMsg($iCtrlId, $STM_SETIMAGE, $IMAGE_BITMAP, $hBitmap)
		If $hPreviousBitmap Then
			_WinAPI_DeleteObject($hPreviousBitmap)
		EndIf

		_WinAPI_DeleteObject($hBitmap)

		Return $iCtrlId
	EndIf
EndFunc

Func GUICtrlEditOnCtrlA()
	Local $hCtrl = _WinAPI_GetFocus()
	If $hCtrl Then
		If _WinAPI_GetClassName($hCtrl) = 'Edit' Then
			_GUICtrlEdit_SetSel($hCtrl, 0, -1)
		EndIf
	EndIf
EndFunc

Func GUICtrlListView_MoveItem($hWnd, $bMoveDown)
	Local $iItemCount = _GUICtrlListView_GetItemCount($hWnd)
	If $iItemCount < 2 Then
		Return
	EndIf

	Local $iSelectedItemIndex = _GUICtrlListView_GetNextItem($hWnd)
	If $iSelectedItemIndex = -1 Then
		Return
	EndIf

	Local $iColumnCount = _GUICtrlListView_GetColumnCount($hWnd)

	Local $asSelectedItemText[$iColumnCount]
	For $i = 0 To $iColumnCount - 1
		$asSelectedItemText[$i] = _GUICtrlListView_GetItemText($hWnd, $iSelectedItemIndex, $i)
	Next

	Local $iNextItemIndex = -1
	If $bMoveDown And $iSelectedItemIndex < $iItemCount - 1 Then
		$iNextItemIndex = $iSelectedItemIndex + 1
	ElseIf Not $bMoveDown And $iSelectedItemIndex > 0 Then
		$iNextItemIndex = $iSelectedItemIndex - 1
	EndIf

	If $iNextItemIndex = -1 Then
		Return
	EndIf

	Local $asNextItemText[$iColumnCount]
	For $i = 0 To $iColumnCount - 1
		$asNextItemText[$i] = _GUICtrlListView_GetItemText($hWnd, $iNextItemIndex, $i)
	Next

	For $i = 0 To $iColumnCount - 1
		_GUICtrlListView_SetItemText($hWnd, $iNextItemIndex, $asSelectedItemText[$i], $i)
		_GUICtrlListView_SetItemText($hWnd, $iSelectedItemIndex, $asNextItemText[$i], $i)
	Next

	_GUICtrlListView_SetItemSelected($hWnd, $iSelectedItemIndex, False, False)
	_GUICtrlListView_SetItemSelected($hWnd, $iNextItemIndex, True, True)
	_GUICtrlListView_EnsureVisible($hWnd, $iNextItemIndex)
EndFunc

Func LinkLabel_MouseEnter($mParam)
	GUICtrlSetFont($mParam['Id'], 8.5, $FW_NORMAL, $GUI_FONTUNDER)
EndFunc

Func LinkLabel_MouseLeave($mParam)
	GUICtrlSetFont($mParam['Id'], 8.5, $FW_NORMAL, 0)
EndFunc

Func RunAutoItScript($sHostPath, $sScriptPath, $sCommandLine, $sWorkingDirectory)
	Return Run('"' & $sHostPath & '" /AutoIt3ExecuteScript "' & $sScriptPath & '" ' & $sCommandLine, $sWorkingDirectory)
EndFunc

Func UpdateGarenaRoom()
	Local Static $bIsFirstTime = False

	If ProcessExists('GarenaMessenger.exe') Then
		Return
	EndIf

	If $bIsFirstTime Then
		Return
	Else
		$bIsFirstTime = True
	EndIf

	Local $sCurrentDirectory = GarenaPlusPath()
	Local $sPath = $sCurrentDirectory & '\Room'

	Local $iPid = Run($sPath & '\garena_room.exe', $sPath)
	If @error Then
		Return
	EndIf

	Local $hWnd = 0

	While True
		$hWnd = WinWait('[Class:SkinDialog]', 'Garena Updater', 1)
		If $hWnd Then
			ExitLoop
		EndIf

		$hWnd = WinWait('Error', 'Please log in to Garena Plus to launch LAN Game.', 1)
		If $hWnd Then
			ProcessClose($iPid)
			Return
		EndIf

		Sleep(250)
	WEnd

	ControlClick($hWnd, '', 'Button1', 'Primary')

	While True
		If ControlGetText($hWnd, '', 'Button1') = 'OK' Then
			ExitLoop
		EndIf

		Sleep(250)
	WEnd

	ControlClick($hWnd, '', 'Button2', 'Primary')
	ProcessClose($iPid)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: htons
; Description ...: The htons function converts a u_short from host to TCP/IP network byte order (which is big-endian).
; Syntax ........: htons($hostshort)
; Parameters ....: $hostshort -
; Return values .:
; Author ........: FaridAgl
; Modified ......:
; Remarks .......:
; Related .......: inet_addr, inet_ntoa, ntohs
; Link ..........: http://msdn.microsoft.com/en-us/library/windows/desktop/ms738557.aspx
; Example .......: No
; ===============================================================================================================================
Func htons($hostshort)
	Return DllCall('ws2_32.dll', 'USHORT', 'htons', _
			'USHORT', $hostshort)[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: inet_addr
; Description ...: The inet_addr function converts a string containing an IPv4 dotted-decimal address into a proper address for
;                  the IN_ADDR structure.
; Syntax ........: inet_addr($cp)
; Parameters ....: $cp -
; Return values .:
; Author ........: FaridAgl
; Modified ......:
; Remarks .......:
; Related .......: inet_ntoa
; Link ..........: http://msdn.microsoft.com/en-us/library/windows/desktop/ms738563.aspx
; Example .......: No
; ===============================================================================================================================
Func inet_addr($cp)
	Return DllCall('ws2_32.dll', 'ULONG', 'inet_addr', _
			'STR', $cp)[0]
EndFunc