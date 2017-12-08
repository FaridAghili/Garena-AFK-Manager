#include "stdafx.h"
#pragma warning(disable: 4127)

extern HWND btnRoom, btnClearChat,  btnSend, txtChat;

extern HANDLE hProxyServer;
extern ProxyServer *pProxyServer;
extern FARPROC pConnect;
extern BYTE bJumpInstruction[6], bJumpInstructionOriginal[6];

HANDLE hClientInfo;
ClientInfo *pClientInfo, ci;

VOID GarenaRoom()
{
	hClientInfo = OpenFileMapping(FILE_MAP_READ, FALSE, "AFK Manager: Client");
	if (hClientInfo == NULL)
		ExitProcess(0);

	pClientInfo = (ClientInfo *)MapViewOfFile(hClientInfo, FILE_MAP_READ, 0, 0, sizeof(ClientInfo));
	if (pClientInfo == NULL)
	{
		CloseHandle(hClientInfo);
		ExitProcess(0);
	}

	hProxyServer = OpenFileMapping(FILE_MAP_READ, FALSE, "AFK Manager: ProxyServer");
	if (hProxyServer == NULL)
	{
		UnmapViewOfFile(pClientInfo);
		CloseHandle(hClientInfo);
		ExitProcess(0);
	}

	pProxyServer = (ProxyServer *)MapViewOfFile(hProxyServer, FILE_MAP_READ, 0, 0, sizeof(ProxyServer));
	if (pClientInfo == NULL)
	{
		CloseHandle(hProxyServer);
		UnmapViewOfFile(pClientInfo);
		CloseHandle(hClientInfo);
		ExitProcess(0);
	}

	DWORD dwBaseAddress = 0, dwSize = 0;
	GetCurrentProcessMainModuleInfo(&dwBaseAddress, &dwSize);

	DWORD dwAddress = 0;

	// Remove Memory Protection
	dwAddress = FindPattern((LPBYTE)"\x74\x63\x8B\x4D\xCC\x8B\x11\x8B\x4D\xCC\x8B\x02", "xxxxxxxxxxxx", dwBaseAddress, dwSize, 0);
	CopyMemoryEx(dwAddress, "\xEB", 1);

	// Disable Auto Update
	dwAddress = FindPattern((LPBYTE)"\x75\x20\xC6\x45\xFC\x00\x8D\x8D\x8C\xFB\xFF\xFF", "xxxxx?xxxxxx", dwBaseAddress, dwSize, 0);
	CopyMemoryEx(dwAddress, "\x90\x90", 2);

	// Enable MultiClient (Disable CreateMutex)
	dwAddress = FindPattern((LPBYTE)"\x83\xC4\x0C\x6A\x00\xFF\x15", "xxxxxxx", dwBaseAddress, dwSize, -25);
	CopyMemoryEx(dwAddress, "\x90\x90\x90\x90\x90", 5);

	// Enable MultiClient (Disable OpenMutex)
	dwAddress = FindPattern((LPBYTE)"\x0F\xB6\xC0\x85\xC0\x74\x13\xE8", "xxxxxxxx", dwBaseAddress, dwSize, 5);
	CopyMemoryEx(dwAddress, "\xEB", 1);

	// Please log in to Garena Plus to launch LAN Game.
	dwAddress = FindPattern((LPBYTE)"\x0F\xB6\xC0\x85\xC0\x74\x37\xE8", "xxxxxxxx", dwBaseAddress, dwSize, 5);
	CopyMemoryEx(dwAddress, "\x90\x90", 2);

	// Failed to login into server!
	dwAddress = FindPattern((LPBYTE)"\x68\xF8\x13\x00\x00\x8D\x8D", "xxxxxxx", dwBaseAddress, dwSize, 0);
	CopyMemoryEx(dwAddress, "\xEB\x76\x90\x90\x90", 5);

	// Server is offline, please try again later!
	dwAddress = FindPattern((LPBYTE)"\x74\x02\xEB\x6D\x8B\x4D\xB8\x81\xC1\xDC\x00\x00\x00", "xxxxxxxxxxxxx", dwBaseAddress, dwSize, 0);
	CopyMemoryEx(dwAddress, "\x90\x90", 2);

	// Sorry, you can only try to join a room every 5 seconds!
	dwAddress = FindPattern((LPBYTE)"\x0F\x83\x95\x00\x00\x00\x68\x4E\x11\x00\x00", "xxxxxxxxxxx", dwBaseAddress, dwSize, 0);
	CopyMemoryEx(dwAddress, "\xE9\x96\x00\x00\x00\x90", 6);

	// You are still in room, leave room now?
	dwAddress = FindPattern((LPBYTE)"\x68\x2D\x11\x00\x00\x8D\x85\x00\x00\x00\x00\x50", "xxxxxxx????x", dwBaseAddress, dwSize, -5);
	CopyMemoryEx(dwAddress, "\x84", 1);

	// EXP Hack
	dwAddress = FindPattern((LPBYTE)"\x7E\x09\xC7\x45\xEC\xC8\x00\x00\x00", "xxxxxxxxx", dwBaseAddress, dwSize, 0);
	CopyMemoryEx(dwAddress, "\x90\x90", 2);

	// Hide IP Address - MOV DWORD PTR DS:[EAX+1C],ECX
	dwAddress = FindPattern((LPBYTE)"\x8B\x55\x08\x8B\x4A\x1C\x89\x48\x1C\x8B\x4D\xFC\x83\xC1\x04", "xxxxxxxxxxxxxxx", dwBaseAddress, dwSize, 6);
	CopyMemoryEx(dwAddress, "\x90\x90\x90", 3);

	// Hide IP Address - MOV DWORD PTR DS:[EAX+1C],ECX
	dwAddress = FindPattern((LPBYTE)"\x8B\x4D\x08\x89\x48\x1C\x8B\x4D\xFC\x83\xC1\x04", "xxxxxxxxxxxx", dwBaseAddress, dwSize, 4);
	CopyMemoryEx(dwAddress, "\x58", 1);

	// http://ad.garenanow.com/showzone?name=im_room_menu
	dwAddress = FindPattern((LPBYTE)"\x68\xE7\x13\x00\x00\x8D\x55", "xxxxxxx", dwBaseAddress, dwSize, 0);
	CopyMemoryEx(dwAddress, "\x6A\x00\x90\x90\x90", 5);

	// http://ad.garenanow.com/showzone?name=im_room_home
	dwAddress = FindPattern((LPBYTE)"\x68\x8C\x10\x00\x00\x8D\x45\x88", "xxxxxxxx", dwBaseAddress, dwSize, 0);
	CopyMemoryEx(dwAddress, "\x6A\x00\x90\x90\x90", 5);

	// http://ad.garenanow.com/showzone?name=im_room_top
	dwAddress = FindPattern((LPBYTE)"\x68\xE3\x13\x00\x00\x8D\x8D", "xxxxxxx", dwBaseAddress, dwSize, 0);
	CopyMemoryEx(dwAddress, "\x6A\x00\x90\x90\x90", 5);

	// http://ad.garenanow.com/showzone?name=im_room_rbottom
	dwAddress = FindPattern((LPBYTE)"\x68\x00\x00\x00\x56\x68\xE2\x13", "xxxxxxxx", dwBaseAddress, dwSize, 0);
	CopyMemoryEx(dwAddress, "\x74\x14\x90\x90\x90", 5);

	// Auto Room Joiner - Initializing
	dwAddress = FindPattern((LPBYTE)"\x32\xC0\xEB\x0E\x8B\x45\x08\x50\x8B\x4D\xB8", "xxxxxxxxxxx", dwBaseAddress, dwSize, 11);
	DWORD dwGetRoomId = dwAddress;

	// Auto Room Joiner - Setting up
	dwAddress = FindPattern((LPBYTE)"\x8B\x55\x08\x52\x68\x13\x01\x00\x00", "xxxxxxxxx", dwBaseAddress, dwSize, 20);
	AutoRoomJoiner(dwGetRoomId, dwAddress);

	// Setting server
	dwAddress = FindPattern((LPBYTE)"\x6C\x61\x6E\x67\x61\x6D\x65\x2E\x61\x75\x74\x68\x2E\x67\x61\x72\x65\x6E\x61\x6E\x6F\x77\x2E\x63\x6F\x6D", "xxxxxxxxxxxxxxxxxxxxxxxxxx", dwBaseAddress, dwSize, 0);
	CopyMemoryEx(dwAddress, pClientInfo->szServerIp, 26);

	// Setting Proxy Server
	CopyMemory(bJumpInstruction, "\xE9\x90\x90\x90\x90\xC3", 6);

	pConnect = GetProcAddress(GetModuleHandle("ws2_32.dll"), "connect");
	DWORD dwJumpSize = (DWORD)_connect - (DWORD)pConnect - 5;

	DWORD dwOldProtection = NULL;
	VirtualProtect(pConnect, 6, PAGE_EXECUTE_READWRITE, &dwOldProtection);
	CopyMemory(bJumpInstructionOriginal, pConnect, 6);
	CopyMemory(&bJumpInstruction[1], &dwJumpSize, 4);
	CopyMemory(pConnect, bJumpInstruction, 6);
	VirtualProtect(pConnect, 6, dwOldProtection, &dwOldProtection);

	// Initialize thread
	HANDLE hThread = CreateThread(NULL, 0, GarenaRoomInitialize, NULL, 0, NULL);
	CloseHandle(hThread);

	SetTimer(NULL, 0, 30000, GarenaRoomCheckUp);
}

DWORD WINAPI GarenaRoomInitialize(LPVOID lpParam)
{
	UNREFERENCED_PARAMETER(lpParam);

	while (pClientInfo->hWnd == NULL)
		Sleep(500);

	CopyMemory(&ci, pClientInfo, sizeof(ClientInfo));
	UnmapViewOfFile(pClientInfo);
	CloseHandle(hClientInfo);

	HWND hRoomDialog = NULL;
	EnumChildWindows(ci.hWnd, GetRoomDialogHandleProc, (LPARAM)&hRoomDialog);

	btnRoom      = GetDlgItem(ci.hWnd, 1152);
	btnClearChat = GetDlgItem(hRoomDialog, 1155);
	btnSend      = GetDlgItem(hRoomDialog, 1161);
	txtChat      = GetDlgItem(hRoomDialog, 1154);

	while (!IsInRoom())
		Sleep(500);

	if (ci.fIsSpamBot)
	{
		HANDLE hThread = CreateThread(NULL, 0, SpamBotThread, NULL, 0, NULL);
		CloseHandle(hThread);
	}

	return 0;
}

VOID CALLBACK GarenaRoomCheckUp(HWND hWnd, UINT uMsg, UINT_PTR uTimerId, DWORD dwTime)
{
	UNREFERENCED_PARAMETER(hWnd);
	UNREFERENCED_PARAMETER(uMsg);
	UNREFERENCED_PARAMETER(uTimerId);
	UNREFERENCED_PARAMETER(dwTime);

	HANDLE hMutex = OpenMutex(SYNCHRONIZE, FALSE, "AFK Manager: Authenticated");
	if (hMutex != NULL)
		CloseHandle(hMutex);
	else
		ExitProcess(0);

	if (IsLoggedIn() && ci.nExpiryDateTimestamp != 0 && ci.nExpiryDateTimestamp <= time(NULL))
		ExitProcess(0);

	static HANDLE hThread = NULL;

	if (IsInRoom() && hThread == NULL)
		hThread = CreateThread(NULL, 0, ReconnectThread, &hThread, 0, NULL);
}

DWORD WINAPI ReconnectThread(LPVOID lpParam)
{
	if (IsClientConnectedToRoomServer(NULL))
		ChatClear();
	else
	{
		HANDLE hMutex = OpenMutex(SYNCHRONIZE, FALSE, "AFK Manager: Reconnecting");
		if (hMutex != NULL)
			CloseHandle(hMutex);
		else
		{
			hMutex = CreateMutex(NULL, TRUE, "AFK Manager: Reconnecting");
			RoomRejoin();
			CloseHandle(hMutex);
		}
	}

	CloseHandle(*(HANDLE *)lpParam);
	*(HANDLE *)lpParam = NULL;

	return 0;
}

DWORD WINAPI SpamBotThread(LPVOID lpParam)
{
	UNREFERENCED_PARAMETER(lpParam);

	HANDLE hSpamBot = OpenFileMapping(FILE_MAP_READ, FALSE, "AFK Manager: SpamBot");
	if (hSpamBot == NULL)
		return 0;

	SpamBotInfo *pSpamBotInfo = (SpamBotInfo *)MapViewOfFile(hSpamBot, FILE_MAP_READ, 0, 0, sizeof(SpamBotInfo));
	if (pSpamBotInfo == NULL)
	{
		CloseHandle(hSpamBot);
		return 0;
	}

	HANDLE hThread = NULL;
	DWORD dwInterval = pSpamBotInfo->dwInterval;

	while (true)
	{
		if (IsInRoom() && pSpamBotInfo->fState)
		{
			if (hThread == NULL)
			{
				dwInterval = pSpamBotInfo->dwInterval;
				hThread = CreateThread(NULL, 0, SpamBotWorkerThread, pSpamBotInfo, 0, NULL);
			}
			else
			{
				if (pSpamBotInfo->dwInterval != dwInterval)
				{
					TerminateThread(hThread, 0);
					CloseHandle(hThread);

					dwInterval = pSpamBotInfo->dwInterval;
					hThread = CreateThread(NULL, 0, SpamBotWorkerThread, pSpamBotInfo, 0, NULL);
				}
			}
		}
		else
		{
			if (hThread != NULL)
			{
				TerminateThread(hThread, 0);
				CloseHandle(hThread);

				hThread = NULL;
			}
		}

		Sleep(5000);
	}

	return 0;
}

DWORD WINAPI SpamBotWorkerThread(LPVOID lpParam)
{
	DWORD dwDelay = 0;

	while (true)
	{
		if (ChatSend(((SpamBotInfo *)lpParam)->szFirstMessage))
			dwDelay += 5000;

		if (ChatSend(((SpamBotInfo *)lpParam)->szSecondMessage))
			dwDelay += 5000;

		if (ChatSend(((SpamBotInfo *)lpParam)->szThirdMessage))
			dwDelay += 5000;

		Sleep(((SpamBotInfo *)lpParam)->dwInterval * 60000 - dwDelay);
		dwDelay = 0;
	}

	return 0;
}

/*
// Show Rooms From All Regions
dwAddress = FindPattern((LPBYTE)"\x0F\x85\xAA\x01\x00\x00\x8B", "xxxxxxx", dwBaseAddress, dwSize, 0);
CopyMemoryEx(dwAddress, "\xE9\xAB\x01\x00\x00\x90", 6);

// You are sending out messages too fast. Why not visit www.garena.com and take a good rest :) - Public
dwAddress = FindPattern((LPBYTE)"\x0F\x84\xA5\x00\x00\x00\x68\xDA\x10\x00\x00", "xxxxxxxxxxx", dwBaseAddress, dwSize, 0);
CopyMemoryEx(dwAddress, "\xE9\xA6\x00\x00\x00\x90", 6);

// Sorry, for better gaming experience of you and others, please don't flood - Public
dwAddress = FindPattern((LPBYTE)"\x0F\x84\xA5\x00\x00\x00\x68\xDB\x10\x00\x00", "xxxxxxxxxxx", dwBaseAddress, dwSize, 0);
CopyMemoryEx(dwAddress, "\xE9\xA6\x00\x00\x00\x90", 6);

// You are sending out messages too fast. Why not visit www.garena.com and take a good rest :) - Whisper
dwAddress = FindPattern((LPBYTE)"\x74\x71\x68\xDA\x10\x00\x00", "xxxxxxx", dwBaseAddress, dwSize, 0);
CopyMemoryEx(dwAddress, "\xEB", 1);

// Sorry, for better gaming experience of you and others, please don't flood - Whisper
dwAddress = FindPattern((LPBYTE)"\x0F\x84\x80\x00\x00\x00\x68\xDB\x10\x00\x00", "xxxxxxxxxxx", dwBaseAddress, dwSize, 0);
CopyMemoryEx(dwAddress, "\xE9\x81\x00\x00\x00\x90", 6);

// You are in same room!
dwAddress = FindPattern((LPBYTE)"\x75\x63\x68\x32\x11\x00\x00", "xxxxxxx", dwBaseAddress, dwSize, 0);
CopyMemoryEx(dwAddress, "\xEB", 1);

// You can't leave room while playing!
dwAddress = FindPattern((LPBYTE)"\x74\x72\x68\x1C\x11\x00\x00", "xxxxxxx", dwBaseAddress, dwSize, 0);
CopyMemoryEx(dwAddress, "\xEB", 1);
*/