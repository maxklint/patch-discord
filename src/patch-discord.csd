<Cabbage>
form caption("patch discord") size(600, 600), colour(234, 234, 234), pluginid("def1")

#define KNOB range(0, 127, 0, 1, 1) colour(0, 0, 0) trackercolour(255, 64, 34) trackerinsideradius(0.33)
rslider bounds(25, 150, 100, 100) channel("knob1") $KNOB
rslider bounds(175, 150, 100, 100) channel("knob2") $KNOB
rslider bounds(325, 150, 100, 100) channel("knob3") $KNOB
rslider bounds(475, 150, 100, 100) channel("knob4") $KNOB
rslider bounds(25, 350, 100, 100) channel("knob5") $KNOB
rslider bounds(175, 350, 100, 100) channel("knob6") $KNOB
rslider bounds(325, 350, 100, 100) channel("knob7") $KNOB
rslider bounds(475, 350, 100, 100) channel("knob8") $KNOB
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
#include "permutation.i"

instr 1
iNumIns = 8
iNumOuts = 8
; The combination {1, 0.05} results in approximately 10 minute cycle
iUpdateTempo = 1 ; once per second
iPhaseIncr = 0.01 ; in radians

iMidiChan = 1
kCCs[] fillarray 22, 23, 24, 25, 26, 27, 28, 29

kPhase init 0
kTranslation[] init iNumIns
kInitPhase[] init iNumOuts
kShuffling[][] init iNumOuts, iNumIns
kPermutation[][] init iNumOuts, iNumIns

; initialization
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
        kTmp[] init iNumIns
        kTmp GenShuffling iNumIns
        kShuffling setrow kTmp, kIndx
        kIndx += 1
    od
    kOnce = 1
endif

; state update cycle
kUpdateTrig metro iUpdateTempo
if kUpdateTrig == 1 then
    kPermutation GenPermutation iNumOuts, iNumIns, kShuffling, kInitPhase, kPhase

    kPhase += iPhaseIncr
endif

; control cycle
kKnobs[] init iNumIns
kIndx = 0
until kIndx == lenarray(kKnobs) do
    Schn sprintfk "knob%d", kIndx+1
    kVal chnget Schn
    kKnobs[kIndx] = kVal
    kIndx += 1
od

kOut[] init iNumOuts
kIndx = 0
until kIndx == lenarray(kOut) do
    if kOut[kIndx] != kKnobs[kIndx] then
        printks "CC: %d; VAL: %d\\n", 0, kCCs[kIndx], kKnobs[kIndx]
        outkc iMidiChan, kCCs[kIndx], kKnobs[kIndx], 0, 127
    endif
    kOut[kIndx] = kKnobs[kIndx]
    kIndx += 1
od
endin

</CsInstruments>
<CsScore>
i 1 0 z
</CsScore>
</CsoundSynthesizer>
