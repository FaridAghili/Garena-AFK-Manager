#pragma once

extern "C" __declspec(dllexport) HWND GarenaRoom(LPCTSTR, LPSTR, LPCSTR, LPCSTR, ClientInfo *);
BOOL CALLBACK GarenaRoomMainWindowProc(HWND, LPARAM);

extern "C" __declspec(dllexport) BOOL IsRoomPasswordWrong(DWORD);
BOOL CALLBACK RoomPasswordWrongDialogProc(HWND, LPARAM);
BOOL CALLBACK RoomPasswordWrongProc(HWND, LPARAM);