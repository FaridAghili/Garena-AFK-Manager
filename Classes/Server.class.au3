#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#include '..\Header.au3'

Func Server()
	;---------------------------------------------------------------------------
	;
	Local $sMachineId = $oInterface.MD5(DriveGetSerial(@HomeDrive) & _
			@CPUArch & _
			@OSArch & _
			@OSVersion & _
			@OSBuild & _
			@IPAddress1)
	If @error Then
		Debug('Server.class | MD5() failed.', @ScriptLineNumber)
		Return SetError(1, 0, Null)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $tagProxyServer = 'BOOL fEnable;' & _
			'ULONG uAddress;' & _
			'USHORT uPort'

	Local $tProxyServer = DllStructCreate($tagProxyServer)
	If @error Then
		Debug('Server.class | DllStructCreate() failed.', @ScriptLineNumber)
		Return SetError(2, 0, Null)
	EndIf

	Local $hFileMapping = _WinAPI_CreateFileMapping($INVALID_HANDLE_VALUE, DllStructGetSize($tProxyServer), $APP_NAME & ': ProxyServer', $PAGE_READWRITE)
	If $hFileMapping Then
		; --- Nothing to do
	Else
		Debug('Server.class | _WinAPI_CreateFileMapping() failed.', @ScriptLineNumber)
		Return SetError(3, 0, Null)
	EndIf

	Local $pViewOfFile = _WinAPI_MapViewOfFile($hFileMapping, 0, DllStructGetSize($tProxyServer), $FILE_MAP_ALL_ACCESS)
	If $pViewOfFile Then
		; --- Nothing to do
	Else
		Debug('Server.class | _WinAPI_MapViewOfFile() failed.', @ScriptLineNumber)
		_WinAPI_CloseHandle($hFileMapping)
		Return SetError(4, 0, Null)
	EndIf

	$tProxyServer = 0

	$tProxyServer = DllStructCreate($tagProxyServer, $pViewOfFile)
	If @error Then
		Debug('Server.class | DllStructCreate() failed.', @ScriptLineNumber)
		_WinAPI_UnmapViewOfFile($pViewOfFile)
		_WinAPI_CloseHandle($hFileMapping)
		Return SetError(5, 0, Null)
	EndIf

	_WinAPI_ZeroMemory(DllStructGetPtr($tProxyServer), DllStructGetSize($tProxyServer))
	If @error Then
		Debug('Server.class | _WinAPI_ZeroMemory() failed.', @ScriptLineNumber)
		_WinAPI_UnmapViewOfFile($pViewOfFile)
		_WinAPI_CloseHandle($hFileMapping)
		Return SetError(6, 0, Null)
	EndIf
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $pCurl = Curl_Easy_Init()
	If $pCurl Then
		; --- Nothing to do
	Else
		Debug('Server.class | Curl_Easy_Init() failed.', @ScriptLineNumber)
		_WinAPI_UnmapViewOfFile($pViewOfFile)
		_WinAPI_CloseHandle($hFileMapping)
		Return SetError(7, 0, Null)
	EndIf

	Curl_Easy_Setopt($pCurl, $CURLOPT_URL, 'https://www.afk-manager.ir/server/')
	Curl_Easy_Setopt($pCurl, $CURLOPT_SSL_VERIFYPEER, 0)
	Curl_Easy_Setopt($pCurl, $CURLOPT_FORBID_REUSE, 1)
	Curl_Easy_Setopt($pCurl, $CURLOPT_USERAGENT, 'AFK Manager')
	Curl_Easy_Setopt($pCurl, $CURLOPT_WRITEFUNCTION, Curl_DataWriteCallback())
	Curl_Easy_Setopt($pCurl, $CURLOPT_WRITEDATA, $pCurl)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $mResult[]
	$mResult['Success'] = 200
	$mResult['Invalid'] = 201
	$mResult['Expired'] = 202
	$mResult['UserLimit'] = 203
	$mResult['Locked'] = 204
	$mResult['InternetError'] = 205

	Local $mRequest[]
	$mRequest['Login'] = '20'
	$mRequest['CheckIn'] = '21'
	$mRequest['Logout'] = '22'
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	Local $oClass = AutoItObject_Class()
	With $oClass
		; --- Destructor
		.AddDestructor('Server_Destructor')

		; --- Properties | Private
		.AddProperty('FileMapping', $ELSCOPE_PRIVATE, $hFileMapping)
		.AddProperty('ViewOfFile', $ELSCOPE_PRIVATE, $pViewOfFile)
		.AddProperty('Curl', $ELSCOPE_PRIVATE, $pCurl)
		.AddProperty('MachineId', $ELSCOPE_PRIVATE, $sMachineId)
		.AddProperty('Password', $ELSCOPE_PRIVATE, '')

		; --- Properties | Read-only
		.AddProperty('ProxyServer', $ELSCOPE_READONLY, $tProxyServer)
		.AddProperty('Result', $ELSCOPE_READONLY, $mResult)
		.AddProperty('Request', $ELSCOPE_READONLY, $mRequest)
		.AddProperty('Username', $ELSCOPE_READONLY, '')
		.AddProperty('Version', $ELSCOPE_READONLY, 0.0)
		.AddProperty('RoomId', $ELSCOPE_READONLY, 0.0)
		.AddProperty('ChannelId', $ELSCOPE_READONLY, 0.0)
		.AddProperty('RemainingDays', $ELSCOPE_READONLY, 0)
		.AddProperty('MaxUsers', $ELSCOPE_READONLY, 0)
		.AddProperty('OnlineUsers', $ELSCOPE_READONLY, 0)
		.AddProperty('GarenaRoomServerCount', $ELSCOPE_READONLY, 0)
		.AddProperty('GarenaRoomServers', $ELSCOPE_READONLY, Null)
		.AddProperty('GarenaTalkServerCount', $ELSCOPE_READONLY, 0)
		.AddProperty('GarenaTalkServers', $ELSCOPE_READONLY, Null)

		; --- Methods | Public
		.AddMethod('Login', 'Server_Login', False)
		.AddMethod('CheckIn', 'Server_CheckIn', False)
		.AddMethod('Logout', 'Server_Logout', False)
		.AddMethod('IsGarenaLanAvailable', 'Server_IsGarenaLanAvailable', True)
	EndWith
	Return $oClass.Object
	;
	;---------------------------------------------------------------------------
EndFunc

Func Server_Destructor($this)
	; Curl_Easy_Cleanup($this.Curl)
	_WinAPI_UnmapViewOfFile($this.ViewOfFile)
	_WinAPI_CloseHandle($this.FileMapping)
EndFunc

Func Server_Login($this, $sUsername, $sPassword)
	;---------------------------------------------------------------------------
	;
	If StringLen($sPassword) <> 32 Then
		$sPassword = $oInterface.MD5($sPassword)
		If @error Then
			Debug('Server.class | MD5() failed.', @ScriptLineNumber)
			Return $this.Result['InternetError']
		EndIf
	EndIf

	Local $sRequest = StringFormat('r=%s|%s|%s|%s', $this.Request['Login'], $sUsername, $sPassword, $this.MachineId)
	Curl_Easy_Setopt($this.Curl, $CURLOPT_COPYPOSTFIELDS, $sRequest)

	If Curl_Easy_Perform($this.Curl) = $CURLE_OK Then
		; --- Nothing to do
	Else
		Debug('Server.class | Curl_Easy_Perform() failed.', @ScriptLineNumber)
		Return $this.Result['InternetError']
	EndIf

	Local $dResponse = Curl_Data_Get($this.Curl)
	Local $sResponse = BinaryToString($dResponse)

	Curl_Data_Cleanup($this.Curl)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oResponse = Json_Decode($sResponse)
	If IsObj($oResponse) And $oResponse.Exists('Result') Then
		; --- Nothing to do
	Else
		Return $this.Result['InternetError']
	EndIf

	If $oResponse.Item('Result') = $this.Result['Success'] Then
		; --- Nothing to do
	Else
		Switch $oResponse.Item('Result')
			Case $this.Result['Invalid'], $this.Result['Expired'], $this.Result['UserLimit'], $this.Result['Locked']
				Return $oResponse.Item('Result')

			Case Else
				Return $this.Result['InternetError']
		EndSwitch
	EndIf

	If _WinAPI_CreateMutex($APP_NAME & ': Authenticated') Then
		; --- Nothing to do
	Else
		Debug('Server.class | _WinAPI_CreateMutex() failed.', @ScriptLineNumber)
		Return $this.Result['InternetError']
	EndIf

	$this.Username = $sUsername
	$this.Password = $sPassword

	$this.Version = $oResponse.Item('Program').Item('Version')
	$this.RoomId = $oResponse.Item('Program').Item('RoomId')
	$this.ChannelId = $oResponse.Item('Program').Item('ChannelId')

	$this.RemainingDays = $oResponse.Item('Account').Item('RemainingDays')
	$this.MaxUsers = $oResponse.Item('Account').Item('MaxUsers')
	$this.OnlineUsers = $oResponse.Item('Account').Item('OnlineUsers')

	If $oResponse.Item('Proxy').Item('IsEnabled') Then
		If $this.IsGarenaLanAvailable() Then
			DllStructSetData($this.ProxyServer, 'fEnable', False)
			DllStructSetData($this.ProxyServer, 'uAddress', 0)
			DllStructSetData($this.ProxyServer, 'uPort', 0)
		Else
			DllStructSetData($this.ProxyServer, 'fEnable', True)
			DllStructSetData($this.ProxyServer, 'uAddress', inet_addr($oResponse.Item('Proxy').Item('IP')))
			DllStructSetData($this.ProxyServer, 'uPort', htons($oResponse.Item('Proxy').Item('Port')))
		EndIf
	Else
		DllStructSetData($this.ProxyServer, 'fEnable', False)
		DllStructSetData($this.ProxyServer, 'uAddress', 0)
		DllStructSetData($this.ProxyServer, 'uPort', 0)
	EndIf

	$this.GarenaRoomServerCount = UBound($oResponse.Item('RoomServers'))
	$this.GarenaRoomServers = $oResponse.Item('RoomServers')

	$this.GarenaTalkServerCount = UBound($oResponse.Item('TalkServers'))
	$this.GarenaTalkServers = $oResponse.Item('TalkServers')

	Return $this.Result['Success']
	;
	;---------------------------------------------------------------------------
EndFunc

Func Server_CheckIn($this)
	;---------------------------------------------------------------------------
	;
	Local $sRequest = StringFormat('r=%s|%s|%s|%s', $this.Request['CheckIn'], $this.Username, $this.Password, $this.MachineId)
	Curl_Easy_Setopt($this.Curl, $CURLOPT_COPYPOSTFIELDS, $sRequest)

	If Curl_Easy_Perform($this.Curl) = $CURLE_OK Then
		; --- Nothing to do
	Else
		Debug('Server.class | Curl_Easy_Perform() failed.', @ScriptLineNumber)
		Return $this.Result['InternetError']
	EndIf

	Local $dResponse = Curl_Data_Get($this.Curl)
	Local $sResponse = BinaryToString($dResponse)

	Curl_Data_Cleanup($this.Curl)
	;
	;---------------------------------------------------------------------------

	;---------------------------------------------------------------------------
	;
	Local $oResponse = Json_Decode($sResponse)
	If IsObj($oResponse) And $oResponse.Exists('Result') Then
		; --- Nothing to do
	Else
		Return $this.Result['InternetError']
	EndIf

	If $oResponse.Item('Result') = $this.Result['Success'] Then
		; --- Nothing to do
	Else
		Switch $oResponse.Item('Result')
			Case $this.Result['Invalid'], $this.Result['Expired'], $this.Result['UserLimit'], $this.Result['Locked']
				Return $oResponse.Item('Result')

			Case Else
				Return $this.Result['InternetError']
		EndSwitch
	EndIf

	$this.Version = $oResponse.Item('Program').Item('Version')
	$this.RoomId = $oResponse.Item('Program').Item('RoomId')
	$this.ChannelId = $oResponse.Item('Program').Item('ChannelId')

	$this.RemainingDays = $oResponse.Item('Account').Item('RemainingDays')
	$this.MaxUsers = $oResponse.Item('Account').Item('MaxUsers')
	$this.OnlineUsers = $oResponse.Item('Account').Item('OnlineUsers')

	If $oResponse.Item('Proxy').Item('IsEnabled') Then
		If $this.IsGarenaLanAvailable() Then
			DllStructSetData($this.ProxyServer, 'fEnable', False)
			DllStructSetData($this.ProxyServer, 'uAddress', 0)
			DllStructSetData($this.ProxyServer, 'uPort', 0)
		Else
			DllStructSetData($this.ProxyServer, 'fEnable', True)
			DllStructSetData($this.ProxyServer, 'uAddress', inet_addr($oResponse.Item('Proxy').Item('IP')))
			DllStructSetData($this.ProxyServer, 'uPort', htons($oResponse.Item('Proxy').Item('Port')))
		EndIf
	Else
		DllStructSetData($this.ProxyServer, 'fEnable', False)
		DllStructSetData($this.ProxyServer, 'uAddress', 0)
		DllStructSetData($this.ProxyServer, 'uPort', 0)
	EndIf

	$this.GarenaRoomServerCount = UBound($oResponse.Item('RoomServers'))
	$this.GarenaRoomServers = $oResponse.Item('RoomServers')

	$this.GarenaTalkServerCount = UBound($oResponse.Item('TalkServers'))
	$this.GarenaTalkServers = $oResponse.Item('TalkServers')

	Return $this.Result['Success']
	;
	;---------------------------------------------------------------------------
EndFunc

Func Server_Logout($this)
	;---------------------------------------------------------------------------
	;
	Local $sRequest = StringFormat('r=%s|%s|%s', $this.Request['Logout'], $this.Username, $this.MachineId)
	Curl_Easy_Setopt($this.Curl, $CURLOPT_COPYPOSTFIELDS, $sRequest)

	If Curl_Easy_Perform($this.Curl) = $CURLE_OK Then
		; --- Nothing to do
	Else
		Debug('Server.class | Curl_Easy_Perform() failed.', @ScriptLineNumber)
		Return $this.Result['InternetError']
	EndIf

	Curl_Data_Cleanup($this.Curl)

	Return $this.Result['Success']
	;
	;---------------------------------------------------------------------------
EndFunc

Func Server_IsGarenaLanAvailable($this)
	#forceref $this

	Run('ipconfig /flushdns', '', @SW_HIDE)
	Local $sIpAddress = TCPNameToIP('langame.auth.garenanow.com')
	If @error Then
		Return False
	EndIf

	Local $iTcpTimeout = AutoItSetOption('TCPTimeout', 5000)

	Local $iSocket = TCPConnect($sIpAddress, 7456)
	If @error Then
		AutoItSetOption('TCPTimeout', $iTcpTimeout)
		Return False
	EndIf

	TCPSend($iSocket, Binary('0x02010000ad00ab0c2abeb7cf87a7207bcfb012b595573249589ca7af1e05004bcf7342f7566ca824e8dd059eaa0ff9322770395cf8d2c07230e316fa3786d37376b6867ee4d0ebecbe33c549c51125c60b16da20f39cdfb2eee2ec8f0ec70da0cc94d4bcb1946691ea178a07f57151fdf8c53bc3da15d4233802a5d2f5d1e2b7e10adbee85e5443bfd8a45c710ec6b472c69c8569293b47581781e44e8c1cd9da1451357cd85447fe0e5452aa37cd122d9e5d991682211dd9848b060b84e337afeb18b059ef9550b4d7dfc34545441416c99c6b2e9c9c3d392bf55892722cce6f2e8dd9f0768f0c80443e87174af397d8bc187faa1a7cb655e97f1492d1ddb2f4d425acd7708'))
	If @error Then
		TCPCloseSocket($iSocket)
		AutoItSetOption('TCPTimeout', $iTcpTimeout)
		Return False
	EndIf

	Local $dBuffer = Binary(0)

	$dBuffer = TCPRecv($iSocket, 32, $TCP_DATA_BINARY)
	If @error Or BinaryLen($dBuffer) <> 20 Then
		TCPCloseSocket($iSocket)
		AutoItSetOption('TCPTimeout', $iTcpTimeout)
		Return False
	EndIf

	TCPSend($iSocket, Binary('0xd00000013931c67e54ca02e2fefba625f74f1ff43a8d43831bd5ad764f981ff5972d7b526c530f81d6856b1ffab5664f02ccb20cb4cbeb29b6b1c02afff6678b9b621af7934cacb1d9f1c6949a7403105c9b3f77245e3089a96f427295f117d3b61e5d53b9fabab54b97fd4e0ec7027177eb2e63ae0fa09c125cfeaf8610adab74b6bc8db007f5c6185a47cd5236c79d92826980612c3b89aaa0546e2d8f80a4114303cd28f441918ded40f66e737584ab1585fd320d5fda2357e7ab285b48c82f4c67dbd0c36f2317c64071e862de642f43e7eb'))
	If @error Then
		TCPCloseSocket($iSocket)
		AutoItSetOption('TCPTimeout', $iTcpTimeout)
		Return False
	EndIf

	$dBuffer = TCPRecv($iSocket, 128, $TCP_DATA_BINARY)
	If @error Or BinaryLen($dBuffer) <> 116 Then
		TCPCloseSocket($iSocket)
		AutoItSetOption('TCPTimeout', $iTcpTimeout)
		Return False
	EndIf

	TCPCloseSocket($iSocket)
	AutoItSetOption('TCPTimeout', $iTcpTimeout)
	Return True
EndFunc