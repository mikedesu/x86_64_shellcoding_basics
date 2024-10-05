BIN=$1

echo "#include <string.h>"
echo -n "const char shellcode[] = \""

for i in $(objdump -d $BIN -M intel | grep "^ " | cut -f2); do
	echo "x$i"
done | sed 's/^/\\/' | tr -d '\n' >shellcode.txt

cat shellcode.txt

# get the length of the shellcode

LENGTH=$(wc -c shellcode.txt | cut -d ' ' -f1)
# divide by 4 to get the number of instructions
LENGTH=$((LENGTH / 4))

echo "\";"

echo "int main() {"
echo "char code[$LENGTH];"
echo "memcpy(code, shellcode, $LENGTH);"
echo "((void(*)())code)();"
echo "return 0;"
echo "}"
