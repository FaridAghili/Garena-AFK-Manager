#include "stdafx.h"

HDESK hDesktop = NULL;
HANDLE hFileMapping = NULL;
ClientInfo *pClientInfo = NULL;

BOOL APIENTRY DllMain(HMODULE hModule, DWORD dwReason, LPVOID lpReserved)
{
	UNREFERENCED_PARAMETER(lpReserved);

	if (dwReason == DLL_PROCESS_ATTACH)
	{
		HANDLE hMutex = OpenMutex(SYNCHRONIZE, FALSE, "AFK Manager: Running");
		if (hMutex == NULL)
			return FALSE;

		CloseHandle(hMutex);

		if (!IsSignedFile())
			return FALSE;

		hDesktop = CreateDesktop("AFK Manager: Desktop", NULL, NULL, 0, GENERIC_ALL, NULL);
		if (hDesktop == NULL)
			return FALSE;

		hFileMapping = CreateFileMapping(INVALID_HANDLE_VALUE, NULL, PAGE_READWRITE, 0, sizeof(ClientInfo), "AFK Manager: Client");
		if (hFileMapping == NULL)
		{
			CloseDesktop(hDesktop);
			return FALSE;
		}

		pClientInfo = (ClientInfo *)MapViewOfFile(hFileMapping, FILE_MAP_ALL_ACCESS, 0, 0, sizeof(ClientInfo));
		if (pClientInfo == NULL)
		{
			CloseHandle(hFileMapping);
			CloseDesktop(hDesktop);
			return FALSE;
		}

		DisableThreadLibraryCalls(hModule);
	}
	else if (dwReason == DLL_PROCESS_DETACH)
	{
		UnmapViewOfFile(pClientInfo);
		CloseHandle(hFileMapping);
		CloseDesktop(hDesktop);
	}

	return TRUE;
}