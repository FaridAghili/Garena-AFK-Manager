#include "Functions.h"

/* ---------------------------------------------------------------------------------------------------- */

BOOL IsSignedFile()
{
	CHAR szFilePath[MAX_PATH];
	GetModuleFileName(NULL, szFilePath, MAX_PATH);

	FILE *hFile;
    if (fopen_s(&hFile, szFilePath, "rb") != NO_ERROR)
        return FALSE;

    if (fseek(hFile, -8192, SEEK_END) != NO_ERROR)
    {
        fclose(hFile);
        return FALSE;
    }

	LPSTR szBuffer = (LPSTR)VirtualAlloc(NULL, 128, MEM_COMMIT, PAGE_READWRITE);
	if (fread(szBuffer, 1, 128, hFile) != 128)
    {
		VirtualFree(szBuffer, NULL, MEM_RELEASE);
        fclose(hFile);
        return FALSE;
    }

    fclose(hFile);

	CHAR szSignature[] =
		"\x31\x33\x37\x30\x31\x31\x31\x32\x7F\x86\x1D\x2C\x42\xE9\xFD\xD9"
		"\xC5\x83\x69\xE6\xEA\xD0\x48\xC3\x5E\x26\x35\x43\x98\x6F\x79\x04"
		"\xDC\x2A\xEE\xBF\x71\x19\x72\x9A\xC9\x89\xC6\xDF\x7A\x3D\xF3\x14"
		"\x1B\x2F\x7A\x41\x2F\x7C\xDC\x09\xC7\xA8\x9C\x0B\x53\xDD\xAC\x03"
		"\xDF\x58\xBB\xE9\x62\x26\xCB\xD3\xFD\x8B\x9D\x69\x83\xAC\xEF\x3A"
		"\xC0\x24\x88\xD8\xF8\x36\xFF\xA1\xC6\x84\xF8\xA1\xA9\x94\x1C\xFB"
		"\xE1\x08\x8D\x11\x24\x97\xAE\x7A\xBB\xC4\xDB\x84\x54\x19\xCB\x67"
		"\xC3\x81\x2D\x00\xD9\xC9\xFA\xDD\x31\x33\x37\x30\x31\x31\x31\x32";

	for (int i = 0; i < 128; i++)
	{
		if (szSignature[i] != szBuffer[i])
		{
			VirtualFree(szBuffer, NULL, MEM_RELEASE);
			return FALSE;
		}
	}

	VirtualFree(szBuffer, NULL, MEM_RELEASE);
    return TRUE;
}

VOID HideModule(HMODULE hModule)
{
	DWORD PEB_LDR_DATA;

	__asm
	{
		pushad;
		pushfd;
		mov eax, fs:[30h]
		mov eax, [eax+0Ch]
		mov PEB_LDR_DATA, eax

		// InLoadOrderModuleList
			mov esi, [eax+0Ch]
			mov edx, [eax+10h]

		LoopInLoadOrderModuleList:
			lodsd
			mov esi, eax
			mov ecx, [eax+18h]
			cmp ecx, hModule
			jne SkipA
			mov ebx, [eax]
			mov ecx, [eax+4]
			mov [ecx], ebx
			mov [ebx+4], ecx
			jmp InMemoryOrderModuleList

		SkipA:
			cmp edx, esi
			jne LoopInLoadOrderModuleList

		InMemoryOrderModuleList:
			mov eax, PEB_LDR_DATA
			mov esi, [eax+14h]
			mov edx, [eax+18h]

		LoopInMemoryOrderModuleList:
			lodsd
			mov esi, eax
			mov ecx, [eax+10h]
			cmp ecx, hModule
			jne SkipB
			mov ebx, [eax]
			mov ecx, [eax+4]
			mov [ecx], ebx
			mov [ebx+4], ecx
			jmp InInitializationOrderModuleList

		SkipB:
			cmp edx, esi
			jne LoopInMemoryOrderModuleList

		InInitializationOrderModuleList:
			mov eax, PEB_LDR_DATA
			mov esi, [eax+1Ch]
			mov edx, [eax+20h]

		LoopInInitializationOrderModuleList:
			lodsd
			mov esi, eax
			mov ecx, [eax+08h]
			cmp ecx, hModule
			jne SkipC
			mov ebx, [eax]
			mov ecx, [eax+4]
			mov [ecx], ebx
			mov [ebx+4], ecx
			jmp Finished

		SkipC:
			cmp edx, esi
			jne LoopInInitializationOrderModuleList

		Finished:
			popfd;
			popad;
	}
}

/* ---------------------------------------------------------------------------------------------------- */

BOOL IsClientConnectedToRoomServer(DWORD dwProcessId)
{
	DWORD dwSize = 0;
	if (GetExtendedTcpTable(NULL, &dwSize, TRUE, AF_INET, TCP_TABLE_OWNER_PID_CONNECTIONS, 0) != ERROR_INSUFFICIENT_BUFFER)
		return FALSE;

	HANDLE hHeap = GetProcessHeap();

	LPVOID pTcpTable = HeapAlloc(hHeap, 0, dwSize);
	if (pTcpTable == NULL)
		return FALSE;

	if (GetExtendedTcpTable(pTcpTable, &dwSize, TRUE, AF_INET, TCP_TABLE_OWNER_PID_CONNECTIONS, 0) != NO_ERROR)
	{
		HeapFree(hHeap, NULL, pTcpTable);
		return FALSE;
	}

	if (dwProcessId == NULL)
		dwProcessId = GetCurrentProcessId();

	for (DWORD i = 0; i < ((PMIB_TCPTABLE_OWNER_PID)pTcpTable)->dwNumEntries; i++)
	{
		if (
			((PMIB_TCPTABLE_OWNER_PID)pTcpTable)->table[i].dwOwningPid == dwProcessId
			&&
			((PMIB_TCPTABLE_OWNER_PID)pTcpTable)->table[i].dwRemotePort == 0xEF21 // 8687
		   )
		{
			HeapFree(hHeap, NULL, pTcpTable);
			return TRUE;
		}
	}

	HeapFree(hHeap, NULL, pTcpTable);
	return FALSE;
}

BOOL MD5(LPSTR szInput, LPVOID lpBuffer)
{
	HCRYPTPROV hProv;
	if (!CryptAcquireContext(&hProv, NULL, NULL, PROV_RSA_FULL, CRYPT_VERIFYCONTEXT))
		 return FALSE;

	HCRYPTHASH hHash;
	if (!CryptCreateHash(hProv, CALG_MD5, NULL, 0, &hHash))
	{
		CryptReleaseContext(hProv, 0);
		return FALSE;
	}

	if (!CryptHashData(hHash, (LPBYTE)szInput, strlen(szInput), 0))
	{
		CryptDestroyHash(hHash);
		CryptReleaseContext(hProv, 0);
		return FALSE;
	}

	DWORD dwLength = 16;
	if (!CryptGetHashParam(hHash, HP_HASHVAL, (LPBYTE)lpBuffer, &dwLength, 0))
	{
		CryptDestroyHash(hHash);
		CryptReleaseContext(hProv, 0);
		return FALSE;
	}

	CryptDestroyHash(hHash);
	CryptReleaseContext(hProv, 0);

	return TRUE;
}

DWORD ProcessGetFileName(DWORD dwProcessId, LPVOID lpBuffer, DWORD nSize)
{
	HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, dwProcessId);
	if (hProcess == NULL)
		return 0;

	DWORD dwLength = GetModuleBaseName(hProcess, NULL, (LPSTR)lpBuffer, nSize);
	CloseHandle(hProcess);

	return dwLength;
}

/* ---------------------------------------------------------------------------------------------------- */

BOOL InjectDll(HANDLE hProcess, HANDLE hThread, LPCSTR szDllPath)
{
	DWORD dwAttributes = GetFileAttributes(szDllPath);
	if (dwAttributes == INVALID_FILE_ATTRIBUTES || dwAttributes & FILE_ATTRIBUTE_DIRECTORY)
		return FALSE;

	CONTEXT ctx;
	ZeroMemory(&ctx, sizeof(CONTEXT));
	ctx.ContextFlags = CONTEXT_CONTROL;

	GetThreadContext(hThread, &ctx);

	DWORD dwLength = (DWORD)AfterLoadLibraryAndJumpBack - (DWORD)LoadLibraryAndJumpBack;
	LPBYTE pLocalFunction = (LPBYTE)VirtualAlloc(NULL, dwLength, MEM_COMMIT, PAGE_EXECUTE_READWRITE);
	CopyMemory(pLocalFunction, LoadLibraryAndJumpBack, dwLength);

	LPBYTE pRemoteFunction = (LPBYTE)VirtualAllocEx(
		hProcess,
		NULL,
		dwLength + strlen(szDllPath) + 1,
		MEM_COMMIT,
		PAGE_EXECUTE_READWRITE);

	*(LPDWORD)&pLocalFunction[2] = (DWORD)GetProcAddress(GetModuleHandle("kernel32.dll"), "LoadLibraryA");
	*(LPDWORD)&pLocalFunction[7] = (DWORD)pRemoteFunction + dwLength;
	*(LPDWORD)&pLocalFunction[15] = ctx.Eip - (DWORD)&pRemoteFunction[19];

	WriteProcessMemory(hProcess, pRemoteFunction, pLocalFunction, dwLength, NULL);
	WriteProcessMemory(hProcess, pRemoteFunction + dwLength, szDllPath, strlen(szDllPath), NULL);

	ctx.Eip = (DWORD)pRemoteFunction;
	SetThreadContext(hThread, &ctx);

	VirtualFree(pLocalFunction, NULL, MEM_RELEASE);

	return TRUE;
}

__declspec(naked) VOID LoadLibraryAndJumpBack()
{
	__asm
	{
		PUSHAD

		MOV EAX, 0xDEADBEEF

		PUSH 0xDEADBEEF
		CALL EAX

		POPAD

		__emit 0xE9
		__emit 0xDE
		__emit 0xAD
		__emit 0xBE
		__emit 0xEF
	}
}

__declspec(naked) VOID AfterLoadLibraryAndJumpBack()
{
}

/* ---------------------------------------------------------------------------------------------------- */

VOID GetCurrentProcessMainModuleInfo(LPDWORD dwBaseAddress, LPDWORD dwSize)
{
	MODULEINFO mi;
	ZeroMemory(&mi, sizeof(MODULEINFO));

	GetModuleInformation(GetCurrentProcess(), GetModuleHandle(NULL), &mi, sizeof(MODULEINFO));

	*dwBaseAddress = (DWORD)mi.lpBaseOfDll;
	*dwSize = mi.SizeOfImage;
}

DWORD FindPattern(LPBYTE bMask, LPCSTR szMask, DWORD dwStartAddress, DWORD dwSize, INT nOffset)
{
	for (DWORD i = 0; i < dwSize; i++)
	{
		if (Compare((LPBYTE)dwStartAddress + i, bMask, szMask))
			return dwStartAddress + i + nOffset;
	}

	return NULL;
}

BOOL Compare(LPBYTE bData, LPBYTE bMask, LPCSTR szMask)
{
	while (*szMask)
	{
		bData++;
		bMask++;
		szMask++;

		if (*szMask == 'x' && *bData != *bMask)
			return FALSE;
	}

	return *szMask == NULL;
}

VOID CopyMemoryEx(DWORD dwBaseAddress, LPSTR szData, size_t dwSize)
{
	DWORD dwOldProtection;
	VirtualProtect((LPVOID)dwBaseAddress, dwSize, PAGE_READWRITE, &dwOldProtection);
	CopyMemory((LPVOID)dwBaseAddress, szData, dwSize);
	VirtualProtect((LPVOID)dwBaseAddress, dwSize, dwOldProtection, &dwOldProtection);
}

DWORD GetModuleBaseAddress(DWORD dwProcessId, LPSTR szModuleName)
{
	HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPMODULE, dwProcessId);
	if (hSnapshot == INVALID_HANDLE_VALUE)
		return NULL;

	MODULEENTRY32 ModuleEntry32;
	ModuleEntry32.dwSize = sizeof(MODULEENTRY32);

	if (Module32First(hSnapshot, &ModuleEntry32))
	{
		do
		{
			if (strcmp(ModuleEntry32.szModule, szModuleName) == 0)
			{
				CloseHandle(hSnapshot);
				return (DWORD)ModuleEntry32.modBaseAddr;
			}
		}
		while (Module32Next(hSnapshot, &ModuleEntry32));
	}

	CloseHandle(hSnapshot);
	return NULL;
}