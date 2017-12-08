#include "stdafx.h"

BOOL _IsClientConnectedToRoomServer(DWORD dwProcessId)
{
	return IsClientConnectedToRoomServer(dwProcessId);
}

BOOL _MD5(LPSTR szInput, LPVOID lpBuffer)
{
	return MD5(szInput, lpBuffer);
}

DWORD _ProcessGetFileName(DWORD dwProcessId, LPVOID lpBuffer, DWORD nSize)
{
	return ProcessGetFileName(dwProcessId, lpBuffer, nSize);
}