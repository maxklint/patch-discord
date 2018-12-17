opcode GenShuffling, k[], i
iLen xin
kIn[] init iLen
kOut[] init iLen

kCnt = 0

loop1:
    kIn[kCnt] = kCnt
    loop_lt kCnt, 1, iLen, loop1

kCnt = 0
kRange = iLen

loop2:
    ;copy a random element to kOut
    kRnd rnd31 kRange-.0001, 0
    kRnd = int(abs(kRnd))
    kOut[kCnt] = kIn[kRnd]
    ;replace it with the last unused element in kIn
    kIn[kRnd] = kIn[kRange - 1]
    ;adapt range (new length)
    kRange -= 1
    loop_lt kCnt, 1, iLen, loop2
    
xout kOut
endop

opcode Shuffle, k[], k[]k[]
kIn[], kShuf[] xin
iLen init lenarray(kIn)
kOut[] init iLen

kCnt = 0

loop:
    kDestination = kShuf[kCnt]
    kOut[kDestination] = kIn[kCnt]
    loop_lt kCnt, 1, iLen, loop
xout kOut
endop
