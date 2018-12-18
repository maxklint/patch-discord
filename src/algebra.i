opcode MatrixVectMult, k[], iik[][]k[]
; kProduct[] MatrixVectMult iRows, iCols, kMatrix[][], kVector[]
iRows, iCols, kMatrix[][], kVector[] xin
kProduct[] init iRows

kRow init 0
kCol init 0
kRow = 0
until kRow == iRows do
    kPermRow[] init iCols
    kPermRow getrow kMatrix, kRow
    kMultiplied[] = kPermRow * kVector
    kSum sumarray kMultiplied
    kProduct[kRow] = kSum
    kRow += 1
od

xout kProduct
endop
