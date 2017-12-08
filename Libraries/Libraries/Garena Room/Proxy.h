#pragma once

int PASCAL FAR _connect(SOCKET, const struct sockaddr FAR *, int);
int SOCKSv5(SOCKET, sockaddr_in *, sockaddr_in *);