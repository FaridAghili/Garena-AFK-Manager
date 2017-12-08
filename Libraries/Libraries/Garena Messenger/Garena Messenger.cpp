#include "stdafx.h"

VOID GarenaMessenger()
{
	DWORD dwBaseAddress, dwSize;
	GetCurrentProcessMainModuleInfo(&dwBaseAddress, &dwSize);

	DWORD dwAddress = 0;

	// Enable MultiClient
	dwAddress = FindPattern((LPBYTE)"\x6A\x0C\x6A\x00\x6A\x04\x6A\x00\x6A\xFF\xFF\x15", "xxxxxxxxxxxx", dwBaseAddress, dwSize, -14);
	CopyMemoryEx(dwAddress, "\x90\x90", 2);

	SetTimer(NULL, 0, 30000, GarenaMessengerCheckUp);
}

VOID CALLBACK GarenaMessengerCheckUp(HWND hWnd, UINT uMsg, UINT_PTR uTimerId, DWORD dwTime)
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
}