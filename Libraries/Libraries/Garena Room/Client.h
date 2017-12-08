#pragma once

struct ProxyServer {
	BOOL fEnable;
	u_long uAddress;
	u_short uPort;
};

struct SpamBotInfo {
	BOOL fState;
	CHAR szFirstMessage[131];
	CHAR szSecondMessage[131];
	CHAR szThirdMessage[131];
	DWORD dwInterval;
};

BOOL IsLoggedIn();
BOOL IsInRoom();
VOID ChatClear();
BOOL ChatSend(LPCSTR);
BOOL RoomJoin(DWORD);
VOID RoomRejoin();
BOOL CALLBACK GetRoomDialogHandleProc(HWND, LPARAM);