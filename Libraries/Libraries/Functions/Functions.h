#pragma once

#include <Windows.h>
#include <stdio.h>
#include <TlHelp32.h>

#include <IPHlpApi.h>
#pragma comment(lib, "Iphlpapi.lib")

#include <Psapi.h>
#pragma comment(lib, "psapi.lib")

#include <WinInet.h>
#pragma comment(lib, "wininet.lib")

/* ---------------------------------------------------------------------------------------------------- */

struct ClientInfo {
	BOOL fIsSpamBot;
	CHAR szServerIp[26];
	DWORD dwRoomId;
	time_t nExpiryDateTimestamp;
	HWND hWnd;
};

/* ---------------------------------------------------------------------------------------------------- */

BOOL IsSignedFile();
VOID HideModule(HMODULE);

/* ---------------------------------------------------------------------------------------------------- */

BOOL IsClientConnectedToRoomServer(DWORD);
BOOL MD5(LPSTR, LPVOID);
DWORD ProcessGetFileName(DWORD, LPVOID, DWORD);

/* ---------------------------------------------------------------------------------------------------- */

BOOL InjectDll(HANDLE, HANDLE, LPCSTR);
VOID LoadLibraryAndJumpBack();
VOID AfterLoadLibraryAndJumpBack();

/* ---------------------------------------------------------------------------------------------------- */

VOID GetCurrentProcessMainModuleInfo(LPDWORD, LPDWORD);
DWORD FindPattern(LPBYTE, LPCSTR, DWORD, DWORD, INT);
BOOL Compare(LPBYTE, LPBYTE, LPCSTR);
VOID CopyMemoryEx(DWORD, LPSTR, size_t);
DWORD GetModuleBaseAddress(DWORD, LPSTR);