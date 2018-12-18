<Cabbage>
form caption("patch discord") size(600, 600), colour(234, 234, 234), pluginid("def1")

rslider bounds(-1000, -1000, 100, 100) range(0, 127, 0, 1, 1) colour(0, 0, 0) trackercolour(255, 64, 34) trackerinsideradius(0.33) widgetarray("knob", 8)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -m0d
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "printarr.i"
#include "shuffling.i"

instr 1
iNumIns = 8
iNumOuts = 8

kTranslation[] init iNumIns
kInitPhase[] init iNumOuts
kShuffling[][] init iNumOuts, iNumIns

kOnce init 0
if kOnce == 0 then
    kIndx = 0
    until kIndx == lenarray(kTranslation) do
        kTranslation[kIndx] rnd31 127, 0
        kTranslation[kIndx] = abs(kTranslation[kIndx])
        kIndx += 1
    od
    kIndx = 0
    until kIndx == lenarray(kInitPhase) do
        kInitPhase[kIndx] rnd31 $M_PI * 2, 0
        kInitPhase[kIndx] = abs(kInitPhase[kIndx])
        kIndx += 1
    od
    kIndx = 0
    until kIndx == lenarray(kShuffling) do
        kCol init 0
        kTmp[] init iNumIns
        kTmp GenShuffling iNumIns
        kCol = 0
        until kCol == iNumIns do
            kShuffling[kIndx][kCol] = kTmp[kCol]
            kCol += 1
        od
        kIndx += 1
    od
    kOnce = 1
endif

kKnobs[] init iNumIns
kIndx = 0
until kIndx == lenarray(kKnobs) do
    Schn sprintfk "knob%d", kIndx+1
    kVal chnget Schn
    kKnobs[kIndx] = kVal
    kIndx += 1
od
endin

instr 99
; automatic gui layout
; place the slider widgets in a 2x4 grid
iCnt init 0
iCntRows init 0

while iCnt < 8 do
    S1 sprintfk "pos(%d, %d)", iCnt%4*150+25, iCntRows*200+150
    S2 sprintfk "knob_ident%d", iCnt+1
    chnset S1, S2
    iCnt = iCnt + 1
    iCntRows = (iCnt%4==0 ? iCntRows+1 : iCntRows)
od

endin

</CsInstruments>
<CsScore>
i 1 0 z
i 99 0 0
</CsScore>
</CsoundSynthesizer>
