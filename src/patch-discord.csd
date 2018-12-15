<Cabbage>
form caption("patch discord") size(600, 600), colour(234, 234, 234), pluginid("def1")

rslider bounds(-1000, -1000, 100, 100) range(0, 1, 0, 1, 0.001) colour(0, 0, 0, 10) trackercolour(232, 217, 9) trackerinsideradius(0.4) widgetarray("knob", 8)
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -m0d
</CsOptions>
<CsInstruments>
ksmps = 32
nchnls = 2
0dbfs = 1

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
i 99 0 0
f0 z
</CsScore>
</CsoundSynthesizer>
