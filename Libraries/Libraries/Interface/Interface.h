#pragma once

extern "C" __declspec(dllexport) BOOL _IsClientConnectedToRoomServer(DWORD);
extern "C" __declspec(dllexport) BOOL _MD5(LPSTR, LPVOID);
extern "C" __declspec(dllexport) DWORD _ProcessGetFileName(DWORD, LPVOID, DWORD);