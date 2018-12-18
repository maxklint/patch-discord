opcode GenPermutation, k[][], iik[][]k[]k
; kPermutation[][] GenPermutation iRows, iCols, kShuffling[][], kInitPhase[], kPhase
iRows, iCols, kShuffling[][], kInitPhase[], kPhase xin

kPermutation[][] init iRows, iCols
kRow init 0
kCol init 0

kRow = 0
until kRow == iRows do
    ; sample a sine
    kSine[] init iCols
    kCol = 0
    until kCol == iCols do
        kSine[kCol] = 2 * sin(((kCol * 2 * $M_PI) / (iCols - 1)) + (kInitPhase[kRow] + kPhase))
        kCol += 1
    od

    kShufflingRow[] init iCols
    kShufflingRow getrow kShuffling, kRow

    ; shuffle sine samples
    kRowTmp[] init iCols
    kRowTmp Shuffle kSine, kShufflingRow

    kPermutation setrow kRowTmp, kRow

    kRow += 1
od

xout kPermutation
endop
