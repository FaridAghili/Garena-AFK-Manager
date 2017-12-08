#include "stdafx.h"

BOOL GarenaMessenger(LPCTSTR lpApplicationName, LPSTR lpCommandLine, LPCSTR szCurrentDirectory, LPCSTR szDllPath)
{
	STARTUPINFO si;
	ZeroMemory(&si, sizeof(STARTUPINFO));
	si.cb = sizeof(STARTUPINFO);

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
		return FALSE;
	}

	if (!InjectDll(pi.hProcess, pi.hThread, szDllPath))
	{
		TerminateProcess(pi.hProcess, 0);
		CloseHandle(pi.hThread);
		CloseHandle(pi.hProcess);
		return FALSE;
	}

	ResumeThread(pi.hThread);
	CloseHandle(pi.hThread);
	CloseHandle(pi.hProcess);

	return TRUE;
}