#include <string.h>
const char shellcode[] = "\x48\x31\xc0\x48\x31\xf6\x48\x31\xd2\xb0\x01\x40\xb6\x01\x6a\x0a\x6a\x48\x48\x89\xe6\xb2\x0e\x0f\x05\x48\x31\xc0\xb0\x3c\x31\xff\x0f\x05";
int main() {
char code[34];
memcpy(code, shellcode, 34);
((void(*)())code)();
return 0;
}
