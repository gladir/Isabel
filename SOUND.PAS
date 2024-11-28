{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³              Malte Genesis III/Module des Sons             ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Sound;

INTERFACE

{$D-,L-,Y-,I-,Q-,R-,S-,X+}

Uses Dos,Math;

Const

      sdLPT1              = 1;
      sdLPT2              = 2;
      sdSoundBlaster      = 3;
      sdPCSpeaker         = 4;
      sdStereoLPT1_2      = 5;
      sdSoundBlasterPro   = 6;
      sdStereoLPT1        = 7;
      sdStereoLPT2        = 8;
      sdLPT3              = 9;
      sdMonoLPT1_2        = 10;
      sdMonoUserDefined   = 11;
      sdStereoUserDefined = 12;
      sdDisneySoundLPT1   = 13;
      sdDisneySoundLPT2   = 14;
      sdDisneySoundLPT3   = 15;
      sdQuadOn1LPT        = 16;
      sdAdLib             = 17;
      sdGravisUltraSound  = 18;
      sdRolandMPU_401     = 19;
      sdTandyDigital      = 20;
      sdNul               = 255;

      AdLibGTMin          = 0;
      AdLibGTMax          = 10;

      Note_Octave   : Int = 4;
      Note_Fraction : Real = 0.875;
      Note_Duration : Int = 0;
      Note_Length   : Real = 0.25;
      Note_Quarter  : Real = 500.0;

Type
     AdLibInstrument = array[1..26] of Int;

Var
    AdLibGActVoice : Word;
    AdLibGT        : Array[AdLibGTMin..AdLibGTMax] of AdLibInstrument;

Procedure AdLibDirectNoteOn(Voice:Word;Pitch:Int);
Procedure AdLibDirectNoteOff(Voice:Word);
Procedure AdLibDirectTimbre;
Procedure AdLibInitDriver;
Procedure AdLibLoadInstrument(FileSpec:PathStr);
Procedure AdLibRelTimeStart(TimeNum,TimeDen:Int);
Procedure AdLibSetActVoice(Var Voice:Word);
Procedure AdLibSetMode(Var PercussionMode:Int);
Procedure AdLibSetState(Var State:Int);
Procedure AdLibSetTickBeat(Var TickBeat:Int);
Procedure AskInit;
Procedure DeAlloc;
Procedure Initialise;
Procedure InitSound;
Procedure LoadOvl;
Procedure LoadModule(Name:PathStr);
Procedure Play(S:String);
Procedure PCSpeakerNoSound;
Procedure PCSpeakerSound(Frequency:Word);
Procedure RemoveOvl;
Procedure StartPlaying;
Procedure StopPlaying;
Procedure SetSys(SoundDevice:Byte;TimerSpeed:Word;SBDMA,SBIRQ:Byte;SBPort:Word);

Function AdLibGetState:Bool;
Function AdLibLoadSong(FileSpec:PathStr):Bool;
Function AdLibPlayNote(Pitch:Int;LengthNum,LengthDen:Word):Bool;
Function AdLibSetTempo(Tempo,TimeNum,TimeDen:Int):Bool;
Function AdLibSetTimbre(TimeNum,TimeDen:Word):Bool;
Function AdLibSetVolume(VolNum,VolDen,TimeNum,TimeDen:Int):Bool;
Function Error:Byte;
Function GetModOutput:Byte;
Function IsAdLib:Bool;
Function IsGravisUltraSound:Bool;
Function IsPlayMod:Bool;
Function IsRoland:Bool;
Function IsSoundBlaster:Bool;
Function IsTandyDigital:Bool;
Function LoadDriver:Bool;
Function SelectOutput:Byte;
Function Unload:Bool;

IMPLEMENTATION

Uses Clock,Strings,Strs,Printers,Video,Keyboard,MLibrary,Systems,Dials,RLL;

Var
    _AdLib,_Gravis,_Midi,_SoundBlaster,_TandyDigital:Bool;
    _Memory:Word; OutputSound:Byte; Playing:Bool;

Function LoadDriver;
Var Ptr8Ch:Pointer;
Begin
 Exec('DRVMOD.EXE','/MALTE');
 CLI;
 LoadDriver := (DosError = 0)and(TableInt[$8C] <> NIL);
 STI;
End;

Procedure LoadOvl;
Assembler;
ASM
 MOV AH,$01;
 INT $8C;
END;

Procedure SetSys(SoundDevice:Byte;TimerSpeed:Word;SBDMA,SBIRQ:Byte;SBPort:Word);
Assembler;
ASM
 MOV AH,$02;
 MOV AL,SoundDevice;
 MOV BX,TimerSpeed;
 MOV CL,SBDMA;
 MOV CH,SBIRQ;
 MOV DX,SBPort;
 INT $8C;
END;

Procedure AskInit;
Assembler;
ASM
 MOV AH,$03;
 INT $8C;
END;

Procedure Initialise;
Assembler;
ASM
 MOV AH,$04;
 INT $8C;
END;

Procedure LoadModule(Name:PathStr);
Var _Seg,_Ofs : Word;
Begin
 _Seg := Seg(Name);
 _Ofs := Ofs(Name);
 ASM
  MOV DI,_Ofs;
  MOV ES,_Seg;
  MOV AH,$05;
  INT $8C;
 END;
End;

Procedure StartPlaying;
Assembler;
ASM
 MOV AH,$06;
 INT $8C;
 MOV Playing,True;
END;

Procedure StopPlaying;
Assembler;
ASM
 MOV AH,$08;
 INT $8C;
 MOV Playing,False;
END;

Procedure DeAlloc;
Assembler;
ASM
 MOV AH,$09;
 INT $8C;
END;

Procedure RemoveOvl;
Assembler;
ASM
 MOV AH,$0A;
 INT $8C;
END;

Function Error:Byte;
Assembler;
ASM
 MOV AX,$FEFF;
 INT $8C;
END;

Function Unload:Bool;
Assembler;
ASM
 MOV AH,$FF;
 INT $8C;
END;

Procedure AdLibInitDriver;
Assembler;
ASM
 XOR SI,SI;
 INT 101;
END;

Procedure AdLibRelTimeStart(TimeNum,TimeDen:Int);
Assembler;
Var Time:Record Num,Den:Int; End;
ASM
 MOV AX,TimeNum;
 MOV Time.Num,AX;
 MOV AX,TimeDen;
 MOV Time.Den,AX;
 LES BX,Time;
 MOV SI,2;
 INT 101;
END;

Procedure AdLibSetState(Var State:Int);
Assembler;
ASM
 MOV SI,3;
 LES BX,State;
 INT 101;
END;

Function AdLibGetState:Bool;
Var Regs:Registers; Rtn:Bool;
Begin
 With Regs do
 Begin
  SI := 4;
  ES := Seg(Rtn);
  BX := Ofs(Rtn);
  Intr(101,Regs);
  AdLibGetState := (BP = 1);
 End;
End;

 {Percussion or Melodic Mode}

Procedure AdLibSetMode(Var PercussionMode:Int);
Assembler;
ASM
 MOV SI,6;
 LES BX,PercussionMode;
 INT 101;
END;

Function AdLibSetVolume(VolNum,VolDen,TimeNum,TimeDen:Int):Bool;
Var TD,TN,VD,VN:Word; { Attention! Ne pas changer l'ordre des variables!}
    r:Registers;
Begin
 TD:=TimeDen;
 TN:=TimeNum;
 VD:=VolDen;
 VN:=VolNum;
 r.SI:=8;
 r.ES:=Seg(VN);
 r.BX:=Ofs(VN);
 Intr(101,r);
 AdLibSetVolume := (r.BP=1);
End;

Function AdLibSetTempo(Tempo,TimeNum,TimeDen:Int):Bool;
Var TD,TN,TP:Int; { Attention! Ne pas changer l'ordre des variables!}
    r:registers;
Begin
 TD := TimeDen;
 TN := TimeNum;
 TP := Tempo;
 r.SI:=9;
 r.ES:=Seg(TP);
 r.BX:=Ofs(TP);
 Intr(101,r);
 AdLibSetTempo:=(r.BP=1);
END;

Procedure AdLibSetActVoice(Var Voice:Word);
Assembler;
ASM
 LES BX,Voice;
 MOV AX,ES:[BX];
 MOV AdLibGActVoice,AX;
 MOV SI,12;
 INT 101;
END;

Function AdLibPlayNoteDel(Pitch:Int;LengthNum,LengthDen,DelayNum,DelayDen:word):Bool;
Var DD,DN,LD,LN:Word; P:Int; r:Registers;
Begin
 P  := Pitch;
 LD := LengthDen;
 LN := LengthNum;
 DN := DelayNum;
 DD := DelayDen;
 r.SI := 14;
 r.ES := Seg(P);
 r.BX := Ofs(P);
 Intr(101,r);
 AdLibPlayNoteDel:=(r.BP=1);
End;

Function AdLibPlayNote(Pitch:Int;LengthNum,LengthDen:Word):Bool;
Var LD,LN:Word; P:Int; r:registers;
Begin
 P  := Pitch;
 LD := LengthDen;
 LN := LengthNum;
 r.SI:=15;
 r.ES:=Seg(P);
 r.BX:=Ofs(P);
 Intr(101,r);
 AdLibPlayNote:=(r.BP=1);
End;

Function AdLibSetTimbre(TimeNum,TimeDen:Word):Bool;
Var TD,TN:Word; T:^Int; c1,c2 :Byte; R:Registers;
Begin
 T    := @AdLibGT[AdLibGActVoice];
 TN   := TimeNum;
 TD   := TimeDen;
 r.SI := 16;
 r.ES := Seg(T);
 r.BX := Ofs(T);
 Intr(101,r);
 AdLibSetTimbre := (r.BP=1);
End;

Function AdLibSetPitch(DeltaOctave,DeltaNum,DeltaDen:Int;TimeNum,TimeDen:Word):Bool;
Var TD,TN:Word; DD,DN,D:Int; c1,c2:Byte; r:Registers;
Begin
 D  := DeltaOctave;
 DN := DeltaNum;
 DD := DeltaDen;
 TN := TimeNum;
 TD := TimeDen;
 r.SI := 16;
 r.ES := Seg(D);
 r.BX := Ofs(D);
 Intr(101,r);
 AdLibSetPitch:=(r.BP=1);
End;

Procedure AdLibSetTickBeat(Var TickBeat:Int);
Assembler;
ASM
 MOV SI,18;
 LES BX,TickBeat;
 INT 101;
END;

Procedure AdLibDirectNoteOn(Voice:Word;Pitch:Int);
Assembler;
Var T:Record Pitch:Int; Voice:Word; End;
ASM
 MOV AX,Voice;
 MOV T.Voice,AX;
 MOV AX,Pitch;
 MOV T.Pitch,AX;
 MOV SI,19;
 LES BX,T;
 INC BX;
 INC BX;
 INT 101;
END;

Procedure AdLibDirectNoteOff(Voice:Word);
Var R:Registers;
Begin
 r.SI := 20;
 r.ES := Seg(Voice);
 r.BX := Ofs(Voice);
 Intr(101,r);
End;

Procedure AdLibDirectTimbre;
Var T:^Int; V:Word; r:Registers;
Begin
 V := AdLibGActVoice; T := @AdLibGT[V];
 r.SI:=21;
 r.ES:=Seg(V);
 r.BX:=Ofs(V);
 Intr(101,r);
End;

Procedure AdLibLoadInstrument(FileSpec:PathStr);
Var Handle:Word; { .INS }
Begin
 If(Not(FileExist(FileSpec)))Then Exit;
 Handle := Open(FileSpec,ReadOnly);
 If(IsHandleErr(Handle))Then Exit;
 GetRec(Handle,2,SizeOf(AdLibGT),AdLibGT);
 Close(Handle);
End;

 {Read a .ROL file and place song in Buffer}

Function AdLibLoadSong(FileSpec:PathStr):Bool;
Var nb:Byte; ns:String; ni,ni2,ni3,ni4,BPM,Mode:Int;
    I,J:Word; nr,nr2:Real; fl:Bool; f:File;

 Procedure StringRead(Len:Byte);
 Var I : Byte;
 begin
  ns[0] := Char(Len);
  For I := 1 to len do BlockRead(f,ns[I],1);
 end;

 procedure TempoRead;
 var b1,b2,b3,b4 :byte;
 begin
  BlockRead(f,b1,1);
  BlockRead(f,b2,1);
  BlockRead(f,b3,1);
  BlockRead(f,b4,1);
  nb := b3;
 end;

 Procedure VolumeRead;
 Var b1,b2,b3,b4 :byte;
 Begin
  BlockRead(f,b1,1);
  BlockRead(f,b2,1);
  BlockRead(f,b3,1);
  BlockRead(f,b4,1);
  nb := 51 + Round(b3/2.5);
 End;

Begin
 AdLibLoadSong := False;
 If Not(FileExist(FileSpec))Then Exit;
 AdLibInitDriver;
 AdLibRelTimeStart(0,1);
 Assign(f,FileSpec);
 Reset(f,1);
 StringRead(44);
 BlockRead(f,ni,2);
 AdLibSetTickBeat(ni); {Ticks per Beat}
 BlockRead(f,ni,2);
 BPM := ni; {Beats per Measure}
 StringRead(5);
 BlockRead(f,nb,1);
 Mode := 1;
 AdLibSetMode(Mode); {Mode}
 StringRead(143);
 TempoRead;
 fl := AdLibSetTempo(nb,0,1); {Tempo}
 BlockRead(f,ni,2);
 For I := 1 to ni do
 Begin
  BlockRead(f,ni2,2);
  TempoRead;
  fl := AdLibSetTempo(nb,ni2,1); {Tempo}
 End;
 For I := 0 to 10 do {11 Voices}
 Begin
  AdLibSetActVoice(I);
  StringRead(15);
  BlockRead(f,ni2,2); {Time in ticks of last Note}
  J := 0;
  While (J < ni2) do
  Begin
   BlockRead(f,ni3,2); {Note Pitch}
   BlockRead(f,ni4,2); {Note Duration}
   fl := AdLibPlayNote(ni3-60,ni4,BPM); {Note}
   Inc(J,ni4); {Summation of Durations}
  End;
  StringRead(15);
  BlockRead(f,ni2,2);
  For J := 1 to ni2 do {Instuments}
  Begin
   BlockRead(f,ni3,2);
   StringRead(9);
   nb := Pos(#0,ns);
   Delete(ns,nb,Length(ns));
   AdLibLoadInstrument('C:\MUSIC\' + ns + '.INS');
   fl := AdLibSetTimbre(ni3,1);
   StringRead(1);
   BlockRead(f,ni4,2);
  End;
  StringRead(15);
  BlockRead(f,ni2,2);
  nb := 1;
  For J := 1 to ni2 do {Volume}
  Begin
   BlockRead(f,ni3,2);
   fl := AdLibSetVolume(100,nb,ni3,1); {Use inverse to disable Relative}
   VolumeRead;
   fl := AdLibSetVolume(nb,100,ni3,1);
  End;
  StringRead(15);
  BlockRead(f,ni2,2);
  For J := 1 to ni2 do {Pitch -disabled}
  Begin
   BlockRead(f,ni3,2);
   BlockRead(f,nr,4);
   If(nr = 0)then nr2 := 1 else nr2 := nr;
  End;
 End;
 System.Close(f);
 AdLibLoadSong:=true;
End;

Function GetModOutput:Byte;
Begin
 GetModOutput := OutputSound;
End;

Procedure InitSound;
Type SoundRec = Record
 IsAdLib,IsGravis,IsMidi,IsSoundBlaster,IsTandyDigital:Bool;
 Memory:Word; OutputSound:Byte;
End;
Var CheckSoundCard:Procedure(Info:SoundRec);
    CheckSoundCardPtr:Pointer Absolute CheckSoundCard;
    _SizeOf:Word; Info:SoundRec;
Begin
 CheckSoundCardPtr := AllocFunc(0,SetPath4AddFile(StrPas(PathSystems))+'SOUND.*',_SizeOf);
 CheckSoundCard(Info);
 FreeMem(CheckSoundCardPtr,_SizeOf);
 Move(Info,_AdLib,SizeOf(SoundRec));
End;

Function IsPlayMod:Bool;
Begin
 IsPlayMod := Playing;
End;

Function IsAdLib:Bool;
Begin
 IsAdLib := _AdLib;
End;

Function IsGravisUltraSound:Bool;
Begin
 IsGravisUltraSound := _Gravis;
End;

Function IsRoland:Bool;
Begin
 IsRoland := _Midi;
End;

Function IsSoundBlaster:Bool;
Begin
 IsSoundBlaster := _SoundBlaster;
End;

Function IsTandyDigital:Bool;
Begin
 IsTandyDigital := _TandyDigital;
End;

Procedure PCSpeakerNoSound;
Assembler;
ASM
 IN  AL,$61;
 AND AL,$FC;
 OUT $61,AL;
END;

Procedure Play(S:String);
Const Note_Offset:Array['A'..'G'] of Int = (9,11,0,2,4,5,7);
      Note_Freqs:Array[0..84] of Int =
(*
      C    C#     D    D#     E     F    F#     G    G#     A    A#     B
*)
(     0,
     65,   69,   73,   78,   82,   87,   92,   98,  104,  110,  116,  123,
    131,  139,  147,  156,  165,  175,  185,  196,  208,  220,  233,  247,
    262,  278,  294,  312,  330,  350,  370,  392,  416,  440,  466,  494,
    524,  556,  588,  624,  660,  700,  740,  784,  832,  880,  932,  988,
   1048, 1112, 1176, 1248, 1320, 1400, 1480, 1568, 1664, 1760, 1864, 1976,
   2096, 2224, 2352, 2496, 2640, 2800, 2960, 3136, 3328, 3520, 3728, 3952,
   4192, 4448, 4704, 4992, 5280, 5600, 5920, 6272, 6656, 7040, 7456, 7904  );

   Quarter_Note = 0.25;
   Digits : Set of '0'..'9' = ['0'..'9'];
Var Play_Freq,Play_Duration,Rest_Duration,I,N,K:Int; C:Char;
    Freq:Array[0..6,0..11] of Integer Absolute Note_Freqs; XN:Real;

 Function GetInt:Int;
 Var N : Integer;
 Begin
  N := 0;
  While (S[I] in Digits) do
  Begin
   N := N * 10 + Byte(S[I]) - Byte('0');
   Inc(I);
  End;
  Dec(I);
  GetInt := N;
 End;

Begin
 IncStr(S,' ');
 I := 1;
 While(I < Length(S)) do
 Begin
  C := UpCase(S[I]);
  Case C of
   'A'..'G' : Begin
               N         := Note_Offset[C];
               Play_Freq := Freq[Note_Octave,N];
               XN        := Note_Quarter * (Note_Length/Quarter_Note);
               Play_Duration := Trunc(XN * Note_Fraction);
               Rest_Duration := Trunc(XN * ( 1.0 - Note_Fraction));
               If(S[I+1] in ['#','+','-' ])Then
               Begin
                Inc(I);
                Case S[I] of
                 '#',
                 '+' : Play_Freq := Freq[Note_Octave,SUCC(N)];
                 '-' : Play_Freq := Freq[Note_Octave,PRED(N)];
                  Else;
                End;
               End;
               If(S[I+1] in Digits)Then
               Begin
                Inc(I);
                N  := GetInt;
                XN := (1.0 / N) / Quarter_Note;
                Play_Duration := Trunc(Note_Fraction * Note_Quarter * XN);
                Rest_Duration := Trunc((1.0 - Note_Fraction) * Xn * Note_Quarter);
               End;
               If(S[I+1] = '.')Then
               Begin
                XN := 1.0;
                While (S[I+1] = '.') do
                Begin
                 XN := XN * 1.5;
                 INC(I);
                End;
                Play_Duration := Trunc(Play_Duration * XN);
               End;
               PCSpeakerSound(Play_Freq);
               Delay(Play_Duration);
               PCSpeakerNoSound;
               Delay(Rest_Duration);
              End;
        'M' : Begin
               Inc(I);
               C := S[I];
               Case C Of
                'F' : ;
                'B' : ;
                'N' : Note_Fraction := 0.875;
                'L' : Note_Fraction := 1.000;
                'S' : Note_Fraction := 0.750;
                Else;
               End;
              End;
        'O' : Begin
               Inc(I);
               N := ORD(S[I]) - ORD('0');
               If(N < 0)or(N > 6)Then N := 4;
               Note_Octave := N;
              End;
        '<' : Begin
               If(Note_Octave > 0)Then Dec(Note_Octave);
              End;
        '>' : Begin
               If(Note_Octave < 6)Then Inc(Note_Octave);
              End;
        'N' : Begin
               Inc(I);
               N := GetInt;
               If(N > 0)and(N <= 84)Then
               Begin
                Play_Freq     := Note_Freqs[N];
                XN            := Note_Quarter * (Note_Length / Quarter_Note);
                Play_Duration := Trunc(XN * Note_Fraction);
                Rest_Duration := TRUNC(XN * ( 1.0 - Note_Fraction));
               End
                Else
               If(N = 0)Then
               Begin
                Play_Freq     := 0;
                Play_Duration := 0;
                Rest_Duration := Trunc(Note_Fraction * Note_Quarter *
                                      (Note_Length / Quarter_Note));
               End;
               PCSpeakerSound(Play_Freq);
               Delay(Play_Duration);
               PCSpeakerNoSound;
               Delay(Rest_Duration);
              End;
        'L' : Begin
               Inc(I);
               N := GetInt;
               If(N > 0)Then Note_Length := 1.0 / N;
              End;
        'T' : Begin
               Inc(I);
               N := GetInt;
               Note_Quarter := ( 1092.0 / 18.2 / N ) * 1000.0;
              End;
        'P' : Begin
               Inc(I);
               N := GetInt;
               If(N <  1)Then N := 1 Else
               If(N > 64)Then N := 64;
               Play_Freq     := 0;
               Play_Duration := 0;
               Rest_Duration := Trunc(((1.0 / N) / Quarter_Note) * Note_Quarter);
               PCSpeakerSound(Play_Freq);
               Delay(Play_Duration);
               PCSpeakerNoSound;
               Delay(Rest_Duration);
              End;
         Else;
  End;
  Inc(I);
 End;
 PCSpeakerNoSound;
End;

Procedure PCSpeakerSound(Frequency:Word);
Assembler;
ASM
 MOV  BX,frequency;
 MOV  AX,34DDh;
 MOV  DX,0012h;
 CMP  DX,BX;
 JNB  @@2;
 DIV  BX;
 MOV  BX,AX;
 IN   AL,$61;
 TEST AL,3;
 JNE  @@1;
 OR   al,3;
 OUT  $61,AL;
 MOV  AL,$B6;
 OUT  $43,AL;
@@1:
 MOV  AL,BL;
 OUT  $42,AL;
 MOV  AL,BH;
 OUT  $42,AL;
@@2:
END;

Procedure SetPlay;
Begin
 Note_Octave   := 4;
 Note_Fraction := 0.875;
 Note_Length   := 0.25;
 Note_Quarter  := 500.0;
End;

Function MnuNoSound:Byte;
Var Mnu : LstMnu;
    K   : Word;
Begin
 With Mnu do
 Begin
  Init(8,8,Video.MaxXTxts-8,Video.MaxYTxts-8,'Sortie Son',CurrColors.Dialog.Wins);
  AddPChrWord('Pas de Son',sdNul);
  AddPChrWord('PC Speaker',sdPCSpeaker);
  If(LPT1Exist)Then AddPChrWord('D/A converter dans LPT1',sdLPT1);
  If(LPT2Exist)Then AddPChrWord('D/A converter dans LPT2',sdLPT2);
  If((LPT1Exist)and(LPT2Exist))Then AddPChrWord('Stereo dans LPT1 et LPT2',sdStereoLPT1_2);
  If(LPT1Exist)Then AddPChrWord('Stereo dans LPT1',sdStereoLPT1);
  If(LPT2Exist)Then AddPChrWord('Stereo dans LPT2',sdStereoLPT2);
  If(RunKbd = kbEnter)Then MnuNoSound := GetVal
                      Else MnuNoSound := sdNul;
  Done;
 End;
End;

Function SelectOutput:Byte;
Begin
 If(_SoundBlaster)Then OutPutSound := sdSoundBlaster
                  Else OutPutSound := MnuNoSound;
End;

BEGIN
 OutputSound := sdPCSpeaker; _AdLib := False; _Midi := False;
 _SoundBlaster := False; _Memory := 0; Playing := False;
END.