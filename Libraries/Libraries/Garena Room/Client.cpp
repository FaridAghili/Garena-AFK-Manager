#include "stdafx.h"

extern ClientInfo ci;
HWND btnRoom, btnClearChat, btnSend, txtChat;

BOOL IsLoggedIn()
{
	return IsWindowVisible(btnRoom);
}

BOOL IsInRoom()
{
	return IsWindowEnabled(btnRoom);
}

VOID ChatClear()
{
	SendMessage(btnClearChat, BM_CLICK, 0, 0);
}

BOOL ChatSend(LPCSTR szMessage)
{
	if (strlen(szMessage) == 0)
		return FALSE;

	static DWORD dwCounter = 0;

	CHAR szBuffer[141] = {0};
	sprintf_s(szBuffer, "[%d] %s", dwCounter++, szMessage);

	if (dwCounter > 9999999)
		dwCounter = 0;

	SendMessage(txtChat, WM_SETTEXT, 0, (LPARAM)szBuffer);
	SendMessage(btnSend, BM_CLICK, 0, 0);
	Sleep(5000);

	return TRUE;
}

BOOL RoomJoin(DWORD dwRoomId)
{
	if (!InternetCheckConnection("http://www.afk-manager.ir/", FLAG_ICC_FORCE_CONNECTION, 0))
		return FALSE;

	SendMessage(ci.hWnd,
		WM_APP + 101,
		1001,
		dwRoomId == NULL ? ci.dwRoomId : dwRoomId);

	while (!IsInRoom())
		Sleep(500);

	return TRUE;
}

VOID RoomRejoin()
{
	while (!RoomJoin(ci.dwRoomId == 983110 ? 983111 : 983110))
		Sleep(5000);

	Sleep(5000);

	while (!RoomJoin(NULL))
		Sleep(5000);
}

BOOL CALLBACK GetRoomDialogHandleProc(HWND hWnd, LPARAM lParam)
{
	LPSTR szClassName = (LPSTR)VirtualAlloc(NULL, 7, MEM_COMMIT, PAGE_READWRITE);
	GetClassName(hWnd, szClassName, 7);

	static int iIndex = 0;
	if (strcmp(szClassName, "#32770") == 0 && ++iIndex == 3)
	{
		*(HWND *)lParam = hWnd;
		VirtualFree(szClassName, NULL, MEM_RELEASE);
		return FALSE;
	}

	VirtualFree(szClassName, NULL, MEM_RELEASE);
	return TRUE;
}