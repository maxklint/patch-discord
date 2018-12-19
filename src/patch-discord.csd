<Cabbage>
form caption("patch discord") size(600, 600), colour(234, 234, 234), pluginid("def1")

#define KNOB_IN  range(0, 127, 0, 1, 1) colour(0, 0, 0)    trackercolour(255, 64, 34) trackerinsideradius(0.33)
#define KNOB_OUT range(0, 127, 0, 1, 1) colour(0, 0, 0, 0) trackercolour(34, 64, 255) trackerinsideradius(0.8) active(0)
#define COMBO_CC items("CC16", "CC17", "CC18", "CC19", "CC20", "CC21", "CC22", "CC23", "CC24", "CC25", "CC26", "CC27", "CC28", "CC29", "CC30", "CC31", "CC70", "CC71", "CC72", "CC73", "CC74", "CC75", "CC76", "CC77", "CC78", "CC79")

rslider bounds( 15, 140, 120, 120) channel("knob_out1") $KNOB_OUT
rslider bounds( 25, 150, 100, 100) channel("knob_in1") $KNOB_IN
combobox bounds(50, 250, 50, 20) channel("combo_cc1") value(1) $COMBO_CC

rslider bounds(165, 140, 120, 120) channel("knob_out2") $KNOB_OUT
rslider bounds(175, 150, 100, 100) channel("knob_in2") $KNOB_IN
combobox bounds(200, 250, 50, 20) channel("combo_cc2") value(2) $COMBO_CC

rslider bounds(315, 140, 120, 120) channel("knob_out3") $KNOB_OUT
rslider bounds(325, 150, 100, 100) channel("knob_in3") $KNOB_IN
combobox bounds(350, 250, 50, 20) channel("combo_cc3") value(3) $COMBO_CC

rslider bounds(465, 140, 120, 120) channel("knob_out4") $KNOB_OUT
rslider bounds(475, 150, 100, 100) channel("knob_in4") $KNOB_IN
combobox bounds(500, 250, 50, 20) channel("combo_cc4") value(4) $COMBO_CC

rslider bounds( 15, 340, 120, 120) channel("knob_out5") $KNOB_OUT
rslider bounds( 25, 350, 100, 100) channel("knob_in5") $KNOB_IN
combobox bounds(50, 450, 50, 20) channel("combo_cc5") value(5) $COMBO_CC

rslider bounds(165, 340, 120, 120) channel("knob_out6") $KNOB_OUT
rslider bounds(175, 350, 100, 100) channel("knob_in6") $KNOB_IN
combobox bounds(200, 450, 50, 20) channel("combo_cc6") value(6) $COMBO_CC

rslider bounds(315, 340, 120, 120) channel("knob_out7") $KNOB_OUT
rslider bounds(325, 350, 100, 100) channel("knob_in7") $KNOB_IN
combobox bounds(350, 450, 50, 20) channel("combo_cc7") value(7) $COMBO_CC

rslider bounds(465, 340, 120, 120) channel("knob_out8") $KNOB_OUT
rslider bounds(475, 350, 100, 100) channel("knob_in8") $KNOB_IN
combobox bounds(500, 450, 50, 20) channel("combo_cc8") value(8) $COMBO_CC

checkbox bounds(555, 560, 15, 15) value(1) channel("is_aleatoric") colour:0(0, 0, 0, 220) colour:1(255, 64, 34)
label bounds(480, 560, 80, 15) text("aleatoric")
</Cabbage>
<CsoundSynthesizer>
<CsOptions>
-n -d -m0d -+rtmidi=null -Q0 -M0 --midi-key=4 --midi-velocity=5
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

#include "printarr.i"
#include "shuffling.i"
#include "permutation.i"
#include "algebra.i"

instr 1
iNumIns = 8
iNumOuts = 8

kAleatoric chnget "is_aleatoric"

; The combination {1, 0.05} results in approximately 10 minute cycle
iUpdateTempo = 1 ; once per second
iPhaseIncr = 0.01 ; in radians

iMidiChan = 1
iCCs[] fillarray 0, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79

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
    Schn sprintfk "knob_in%d", kIndx+1
    kVal chnget Schn
    kKnobs[kIndx] = kVal
    kIndx += 1
od

kResult[] init iNumOuts
if kAleatoric > 0 then
    kTranslated[] = kKnobs + kTranslation
    
    kPermuted[] init iNumOuts
    kPermuted MatrixVectMult iNumOuts, iNumIns, kPermutation, kTranslated
    
    kIndx = 0
    until kIndx == iNumOuts do
        kResult[kIndx] mirror kPermuted[kIndx], 0, 127
        kIndx += 1
    od
else
    kIndx = 0
    until kIndx == iNumOuts do
        kResult[kIndx] = kKnobs[kIndx]
        kIndx += 1
    od
endif

kPrevResult[] init iNumOuts
kIndx = 0
until kIndx == iNumOuts do
    if kPrevResult[kIndx] != kResult[kIndx] then
        Scc sprintfk "combo_cc%d", kIndx+1
        kCCindx chnget Scc
        printks "CC: %d; VAL: %d\\n", 0, iCCs[kCCindx], kResult[kIndx]
        outkc iMidiChan, iCCs[kCCindx], kResult[kIndx], 0, 127
        Schn sprintfk "knob_out%d", kIndx+1
        chnset kResult[kIndx], Schn
    endif
    kPrevResult[kIndx] = kResult[kIndx]
    kIndx += 1
od

midion iMidiChan, p4, p5
endin

</CsInstruments>
<CsScore>
i 1 0 z
</CsScore>
</CsoundSynthesizer>
