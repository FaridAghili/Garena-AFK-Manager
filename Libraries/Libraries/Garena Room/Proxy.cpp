#include "stdafx.h"

HANDLE hProxyServer;
ProxyServer *pProxyServer;
FARPROC pConnect;
BYTE bJumpInstruction[6], bJumpInstructionOriginal[6];

int PASCAL FAR _connect(SOCKET s, const struct sockaddr FAR *name, int namelen)
{
	int iResult = SOCKET_ERROR;

	DWORD dwOldProtection = NULL;
	VirtualProtect(pConnect, 6, PAGE_EXECUTE_READWRITE, &dwOldProtection);
	CopyMemory(pConnect, bJumpInstructionOriginal, 6);

	if (pProxyServer->fEnable && ((sockaddr_in *)name)->sin_port == 0x201D) // 7456
	{
		sockaddr_in SocketAddress;
		SocketAddress.sin_family           = AF_INET;
		SocketAddress.sin_addr.S_un.S_addr = pProxyServer->uAddress;
		SocketAddress.sin_port             = pProxyServer->uPort;

		iResult = SOCKSv5(s, &SocketAddress, (sockaddr_in *)name);
	}
	else
		iResult = connect(s, name, namelen);

	CopyMemory(pConnect, bJumpInstruction, 6);
	VirtualProtect(pConnect, 6, dwOldProtection, &dwOldProtection);

	return iResult;
}

int SOCKSv5(SOCKET s, sockaddr_in *SocksAddress, sockaddr_in *DestinationAddress)
{
	if (connect(s, (sockaddr *)SocksAddress, sizeof(sockaddr)) == SOCKET_ERROR)
		return SOCKET_ERROR;

	/* -------------------------------------------------- */

	{
		char szSend[3];
		szSend[0] = 0x05; // SOCKS version number
		szSend[1] = 0x01; // Number of authentication methods supported
		szSend[2] = 0x00; // No authentication

		if (send(s, szSend, 3, 0) != 3)
			return SOCKET_ERROR;
	}

	/* -------------------------------------------------- */

	{
		char szReceive[2];

		if (recv(s, szReceive, 2, 0) != 2)
			return SOCKET_ERROR;

		if (szReceive[0] != 0x05 || szReceive[1] != 0x00)
			return SOCKET_ERROR;
	}

	/* -------------------------------------------------- */

	{
		char szSend[10];
		szSend[0] = 0x05; // SOCKS version number
		szSend[1] = 0x01; // Establish a TCP/IP stream connection
		szSend[2] = 0x00; // Reserved
		szSend[3] = 0x01; // IPv4 address
		memcpy(					// Destination address
			szSend + 4,
			(const void *)&DestinationAddress->sin_addr.S_un.S_addr,
			4);
		memcpy(					// Destination port
			szSend + 8,
			(const void *)&DestinationAddress->sin_port,
			2);

		if (send(s, szSend, 10, 0) != 10)
			return SOCKET_ERROR;
	}

	/* -------------------------------------------------- */

	{
		char szReceive[10];
		ZeroMemory(szReceive, 10);

		if (recv(s, szReceive, 10, 0) != 10)
			return SOCKET_ERROR;

		if (szReceive[0] != 0x05 || szReceive[1] != 0x00)
			return SOCKET_ERROR;
	}

	/* -------------------------------------------------- */

	return NO_ERROR;
}