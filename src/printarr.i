opcode PrintArray, 0, k[]P
;adapted from http://write.flossmanuals.net/csound/e-arrays/ example 03E21
kArr[], ktrig xin
kppr init 0 ; elements per row
kend init 0
kprec init 0
kndx init 0
kprint init 1

if ktrig > 0 then
    kppr = 20
    kend = lenarray(kArr)
    kprec = 3
    kndx = 0

    Sformat sprintfk "%%%d.%df, ", kprec+3, kprec
    Sdump sprintfk "%s", "["
    loop:
        Snew sprintfk Sformat, kArr[kndx]
        Sdump strcatk Sdump, Snew
        kmod = (kndx+1) % kppr
        if kmod == 0 && kndx != kend-1 then
            kprint += 1
            printf "%s\n", kprint, Sdump
            Sdump strcpyk " "
        endif
        loop_lt kndx, 1, kend, loop
    klen strlenk Sdump
    Slast strsubk Sdump, 0, klen-2
    kprint += 1
    printf "%s]\n", kprint, Slast
endif
endop
