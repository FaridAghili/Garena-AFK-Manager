#include "stdafx.h"

extern HDESK hDesktop;
extern ClientInfo *pClientInfo;
BOOL bIsRoomPasswordWrong;

HWND GarenaRoom(LPCTSTR lpApplicationName, LPSTR lpCommandLine, LPCSTR szCurrentDirectory, LPCSTR szDllPath, ClientInfo *ci)
{
	STARTUPINFO si;
	ZeroMemory(&si, sizeof(STARTUPINFO));
	si.cb = sizeof(STARTUPINFO);
	si.lpDesktop = "AFK Manager: Desktop";

	PROCESS_INFORMATION pi;
	ZeroMemory(&pi, sizeof(PROCESS_INFORMATION));

	if (!CreateProcess(lpApplicationName,
		lpCommandLine,
		NULL,
		NULL,
		FALSE,
		CREATE_SUSPENDED,
		NULL,
		szCurrentDirectory,
		&si,
		&pi)
		)
	{
		return NULL;
	}

	ZeroMemory(pClientInfo, sizeof(ClientInfo));
	CopyMemory(pClientInfo, ci, sizeof(ClientInfo));
	pClientInfo->hWnd = NULL;

	if (!InjectDll(pi.hProcess, pi.hThread, szDllPath))
	{
		TerminateProcess(pi.hProcess, 0);
		CloseHandle(pi.hThread);
		CloseHandle(pi.hProcess);
		return NULL;
	}

	ResumeThread(pi.hThread);
	CloseHandle(pi.hThread);

	WaitForInputIdle(pi.hProcess, INFINITE);

	EnumDesktopWindows(hDesktop, GarenaRoomMainWindowProc, (LPARAM)pi.dwProcessId);
	if (pClientInfo->hWnd == NULL)
	{
		TerminateProcess(pi.hProcess, 0);
		CloseHandle(pi.hProcess);
		return NULL;
	}

	CloseHandle(pi.hProcess);
	return pClientInfo->hWnd;
}

BOOL CALLBACK GarenaRoomMainWindowProc(HWND hWnd, LPARAM lParam)
{
	DWORD dwProcessId = 0;
	GetWindowThreadProcessId(hWnd, &dwProcessId);

	if (dwProcessId == (DWORD)lParam)
	{
		LPSTR szString = (LPSTR)VirtualAlloc(NULL, 16, MEM_COMMIT, PAGE_READWRITE);
		GetWindowText(hWnd, szString, 16);

		BOOL bResult = strcmp(szString, "Garena LAN Game") == 0;
		VirtualFree(szString, NULL, MEM_RELEASE);

		if (bResult)
		{
			pClientInfo->hWnd = hWnd;
			return FALSE;
		}
	}

	return TRUE;
}

BOOL IsRoomPasswordWrong(DWORD dwProcessId)
{
	bIsRoomPasswordWrong = FALSE;
	EnumDesktopWindows(hDesktop, RoomPasswordWrongDialogProc, (LPARAM)dwProcessId);

	return bIsRoomPasswordWrong;
}

BOOL CALLBACK RoomPasswordWrongDialogProc(HWND hWnd, LPARAM lParam)
{
	DWORD dwProcessId = 0;
	GetWindowThreadProcessId(hWnd, &dwProcessId);

	if (dwProcessId == (DWORD)lParam)
	{
		EnumChildWindows(hWnd, RoomPasswordWrongProc, (LPARAM)hWnd);
		if (bIsRoomPasswordWrong)
			return FALSE;
	}

	return TRUE;
}

BOOL CALLBACK RoomPasswordWrongProc(HWND hWnd, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);

	LPSTR szString = (LPSTR)VirtualAlloc(NULL, 16, MEM_COMMIT, PAGE_READWRITE);
	GetWindowText(hWnd, szString, 16);

	BOOL bResult = strcmp(szString, "Wrong password!") == 0;
	VirtualFree(szString, NULL, MEM_RELEASE);

	if (bResult)
	{
		bIsRoomPasswordWrong = TRUE;
		return FALSE;
	}

	return TRUE;
}