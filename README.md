# x86_64 Shellcode Basics

- [www.evildojo.com](https://www.evildojo.com)
- [x.com](https://x.com/evildojo666)
- [youtube](https://youtube.com/@evildojo666)

-----

# Building/Running

### Requirements

- Linux (tested on Xubuntu)
- `nasm`
- `ld`
- `objdump`
- `make`
- `gcc`
- `sysctl`
- `git`

### Building

To build the example and generate a C file containing your shellcode, clone the repo and run `make` from within the project folder.

```
git clone httpsa://www.github.com/mikedesu/x86_64_shellcode_basics
cd x86_64_shellcode_basics
make
```

### Running

To run, you're going to need to disable ASLR temporarily.

```
sudo sysctl -w kernel.randomize_va_space=0
```

To re-enable ASLR:

```
sudo sysctl -w kernel.randomize_va_space=2
```

-----

The motivation for this repo was to simplify getting started working with shellcoding in x86_64 assembly language.

In digging through resources and working to get my first proof-of-concept working, I discovered an important detail about working with x64 vs x86 that failed to be emphasized in much of the literature I came across (stack overflow posts, university lecture notes, etc):

### You need to zero-out 64-bit registers before moving values into their lower-bit counterparts

As an example of this, see the contents of `hello.asm`:

```
xor     rax, rax
xor     rsi, rsi
xor     rdx, rdx
mov     al,  1
mov     sil, 1
```

See that I've used `xor` to zero-out the `rax` register, among others, before I move 1 into `al`, which is the lower-half 8-bit register part of that greater 64-bit register.

I was very confused as to why my shellcode wasn't working, but this key detail is what finally clicked my example project into actually executing the shellcode now.

I've provided a `Makefile` and a shell script to make generating the example easier, so you can focus on writing assembly and can immediately test out your payload.

-----

# About writing shellcode

Another important detail I've learned is that you want to make an effort to eliminate instructions that generate zero-bytes, which correspond to NULL bytes. Any functions we attempt to inject into may use `strcpy` instead of `memcpy`, which would result in our payload failing, so to avoid this, the assembly written must generate machine code bytes that contain no zero-bytes. We can check this using `objdump -d` on our intermediary binary.

The `gen_shellcode.sh` script assumes the assembly written already conforms to this requirement, but future work may be done to automate the generation of "zero-byte-free" assembly from human-written assembly.

As an example, let's take `mov al, 1`. 

We prefer this to `mov rax, 1`, which generates a sequence of 5 bytes containing 3 trailing zero-bytes.

Recognizing this instruction sequence is trivial, as `rax` maps directly to `eax`, `ax`, and `ah` and `al`. These same techniques used in 32-bit shellcoding directly apply to 64-bit as well. 

Further work can be done to enumerate the x86_64 instruction set "sandsifter"-style to catalog instructions that are appropriate for use in shellcoding in order to build better tooling for this kind of work (though I suspect this mapping has been done already).

