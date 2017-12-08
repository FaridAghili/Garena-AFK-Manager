#pragma once

VOID GarenaRoom();
DWORD WINAPI GarenaRoomInitialize(LPVOID);
VOID CALLBACK GarenaRoomCheckUp(HWND, UINT, UINT_PTR, DWORD);
DWORD WINAPI ReconnectThread(LPVOID);
DWORD WINAPI SpamBotThread(LPVOID);
DWORD WINAPI SpamBotWorkerThread(LPVOID);