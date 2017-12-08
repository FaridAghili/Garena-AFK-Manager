#include "stdafx.h"

DWORD dwGetRoomIdAddress, dwJoinRoomAddress, dwRoomEAX, dwRoomECX;

VOID AutoRoomJoiner(DWORD dwGetRoomId, DWORD dwJoinRoom)
{
	dwGetRoomIdAddress = dwGetRoomId + 5;

	if (*(LPBYTE)dwGetRoomId == 0xE8)
		dwJoinRoomAddress = dwGetRoomId + 5 + *(LPDWORD)(dwGetRoomId + 1);

	DWORD dwOldProtection = 0;

	VirtualProtect((LPVOID)dwGetRoomId, 5, PAGE_READWRITE, &dwOldProtection);
	*(LPBYTE)dwGetRoomId = 0xE9;
	*(LPDWORD)(dwGetRoomId + 1) = (DWORD)GetRoomID - dwGetRoomId - 5;
	VirtualProtect((LPVOID)dwGetRoomId, 5, dwOldProtection, &dwOldProtection);

	VirtualProtect((LPVOID)dwJoinRoom, 6, PAGE_READWRITE, &dwOldProtection);
	*(LPBYTE)dwJoinRoom = 0xE8;
	*(LPDWORD)(dwJoinRoom + 1) = (DWORD)JoinRoom - dwJoinRoom - 5;
	*(LPBYTE)(dwJoinRoom + 5) = 0x90;
	VirtualProtect((LPVOID)dwJoinRoom, 6, dwOldProtection, &dwOldProtection);
}

__declspec(naked) VOID GetRoomID()
{
	__asm
	{
		MOV  [dwRoomEAX], EAX
		MOV  [dwRoomECX], ECX
		CALL [dwJoinRoomAddress]
		JMP  dwGetRoomIdAddress
	}
}

__declspec(naked) VOID JoinRoom()
{
	__asm
	{
		PUSH EBP
		MOV  EBP, ESP
		MOV  EAX, [dwRoomEAX]
		PUSH EAX
		MOV  ECX, [dwRoomECX]
		CALL [dwJoinRoomAddress]
		MOV  ESP, EBP
		POP  EBP
		RET  14h
	}
}