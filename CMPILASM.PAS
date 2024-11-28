(********************************************************)
(*                                                      *)
(*            Malte Genesis/Compiler Assembler          *)
(*   Phoenix Edition for Real Mode & Protected Mode     *)
(*                   II - Version 1.8                   *)
(*                      1994/12/29                      *)
(*                                                      *)
(*      Copyiright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit CmpilAsm;

INTERFACE

Uses Math,InlineIntel;

Const SAddr : Array[0..7] of PChar = ('[BX+SI]','[BX+DI]','[BP+SI]','[BP+DI]','[SI]','[DI]','[BP]','[BX]');

      RegWord : Array[0..7] of String[2] = ('AX','CX','DX','BX','SP','BP','SI','DI');

      RegByte : Array[0..7] of String[2] = ('AL','CL','DL','BL','AH','CH','DH','BH');

      adrBX_SI   = $00;
      adrBX_DI   = $01;
      adrBP_SI   = $02;
      adrBP_DI   = $03;
      adrSI      = $04;
      adrDI      = $05;
      adrBP      = $06;
      adrBX      = $07;
      regAX      = $10;
      regCX      = $11;
      regDX      = $12;
      regBX      = $13;
      regSP      = $14;
      regBP      = $15;
      regSI      = $16;
      regDI      = $17;
      regES      = $18;
      regCS      = $19;
      regSS      = $1A;
      regDS      = $1B;
      regAL      = $20;
      regCL      = $21;
      regDL      = $22;
      rerBL      = $23;
      regAH      = $24;
      regCH      = $25;
      regDH      = $26;
      regBH      = $27;
      adrBX_SI_  = $40;
      adrBX_DI_  = $41;
      adrBP_SI_  = $42;
      adrBP_DI_  = $43;
      adrSI_     = $44;
      adrDI_     = $45;
      adrBP_     = $46;
      adrBX_     = $47;
      CallDirect = $FC;
      DataWord   = $FD;
      DataByte   = $FE;
      Unknown    = $FF;

      InvalidA1  = $1000;
      InvalidA2  = $1001;
      ParamFound = $1002;
      A1Expected = $1003;
      A2Expected = $1004;

Var

    _C80286 : Bool;

Procedure AAA(Var Output:String);
Function Adc(A1,A2,Ofs:Byte;Data:Word;Var Output:String):Word;
Function Add(A1,A2,Ofs:Byte;Data:Word;Var Output:String):Word;
Function And_(A1,A2,Ofs:Byte;Data:Word;Var Output:String):Word;
Function __Asm2Inline(Input:String;Var Output:String):Word;
Function Call(A:Byte;Far_:Bool;Ptr:Pointer;adr:Word;Var Output:String):Word;
Function CallFar(A:Byte;Ptr:Pointer;Var Output:String):Word;
Function CallNear(A:Byte;ofs,adr:Word;Var Output:String):Word;
Procedure CBW(Var Output:String);
Procedure CLC(Var Output:String);
Procedure CLD(Var Output:String);
Procedure CLI(Var Output:String);
Function CMP(A1,A2,Ofs:Byte;Data:Word;Var Output:String):Word;
Procedure CMPSB(Var Output:String);
Procedure CMPSW(Var Output:String);
Procedure CWD(Var Output:String);
Function Dec(A,Ofs:Byte;Word:Bool;Var Output:String):Word;
Function Div_(A,Ofs:Byte;Word:Bool;Var Output:String):Word;
Function IDiv(A,Ofs:Byte;Word:Bool;Var Output:String):Word;
Function IMul(A,Ofs:Byte;Word:Bool;Var Output:String):Word;
Function Inc(A,Ofs:Byte;Word:Bool;Var Output:String):Word;
Procedure Int(Num:Byte;Var Output:String);
Procedure IRet(Var Output:String);
Procedure LAHF(Var Output:String);
Function Mov(A1,A2,Ofs:Byte;Data:Word;Var Output:String):Word;
Procedure MovSB(Var Output:String);
Procedure MovSW(Var Output:String);
Function Mul(A,Ofs:Byte;Word:Bool;Var Output:String):Word;
Function Neg(A,Ofs:Byte;Word:Bool;Var Output:String):Word;
Procedure Nop(Var Output:String);
Function Not_(A,Ofs:Byte;Word:Bool;Var Output:String):Word;
Function Pop(A:Byte;Var Output:String):Word;
Procedure PopF(Var Output:String);
Function Push(A:Byte;Var Output:String):Word;
Procedure PushF(Var OutPut:String);
Procedure RetF(Var Output:String);
Procedure RetN(Var Output:String);
Procedure SCASB(Var Output:String);
Procedure SCASW(Var Output:String);
Procedure STC(Var Output:String);
Procedure STD(Var Output:String);
Procedure STI(Var Output:String);
Procedure STOSB(Var Output:String);
Procedure STOSW(Var Output:String);

IMPLEMENTATION

Uses Strings,Strs,MLibrary,Language;

Const regSegB : Array[0..3] of Byte = ($06,$0E,$16,$1E);

Procedure SetStrChr(Var Str:String;Chr:Char);
Begin
 Str[0] := #1; Str[1] := Chr;
End;

Procedure SetStrChr2(Var Str:String;Chr1,Chr2:Char);
Begin
 Str[0] := #2; Str[1] := Chr1; Str[2] := Chr2;
End;

Procedure SetStrChr3(Var Str:String;Chr1,Chr2,Chr3:Char);
Begin
 Str[0] := #3; Str[1] := Chr1; Str[2] := Chr2; Str[3] := Chr3;
End;

Procedure SetStrChr4(Var Str:String;Chr1,Chr2,Chr3,Chr4:Char);
Begin
 Str[0] := #4; Str[1] := Chr1; Str[2] := Chr2; Str[3] := Chr3; Str[4] := Chr4;
End;

Procedure SetStrOfs(Var Str:String;A,Ofs:Byte);
Begin
 If((A and $40) = $40)Then IncStr(Str,Char(Ofs));
End;

Procedure SetStrChr2Ofs(Var Str:String;Chr1,Chr2:Char;A,Ofs:Byte);
Begin
 SetStrChr2(Str,Chr1,Chr2);
 SetStrOfs(Str,A,Ofs);
End;

Function AD_(Carry:Bool;A1,A2,Ofs:Byte;Data:Word;Var Output:String):Word;
Var I,C10:Byte; C:Byte Absolute Carry;
Begin
 AD_ := 0; Output := ''; C10 := C * $10;
 Case A1 of
  regAL..regBH : { 1 - AL,BL,CL,DL,AH,BH,CH,DH ? }
  Case A2 of
   regAL..regBH : { 1A - AL,BL,CL,DL,AH,BH,CH,DH ? }
    SetStrChr2(Output,Char(2+C10),Char($C0+((A1-regAL)*8)+(A2-regAL)));
   adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 1B - Address ? }
    SetStrChr2Ofs(Output,Char(2+C10),Char(A2+(A1-regAL)),A2,Ofs);
   DataByte : { 1C - Data : Byte ? }
    SetStrChr3(Output,#$80,Char($C0+C10+A1-regAL),Char(Data));
   Else AD_ := InvalidA2; { 1D - Error ? }
  End;
  regAX..regDI : { 2 - AX,BX,CX,DX,BP,SP,SI,DI ? }
  Case A2 of
   regAX..regDI: { 2A - AX,BX,CX,DX,BP,SP,SI,DI ? }
    SetStrChr2(Output,Char(3+C10),Char($C0+((A2-regAX)*8)+(A1-regAX)));
   adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 2B - Address ? }
    SetStrChr2Ofs(Output,Char(3+C10),Char(A2),A2,Ofs);
   DataWord : { 2C - Data : Word ? }
    SetStrChr2(Output,#$81,Char($C0+C10+A1-regAX));
   Else AD_ := InvalidA2; { 2D - Error ? }
  End;
  adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 3 - Address ? }
  Case A2 of
   regAX..regDI: { 3A - AX,BX,CX,DX,BP,SP,SI,DI ? }
    SetStrChr2Ofs(Output,Char(1+C10),Char(A1-regAX+((A2-regAX)*8)),A1,Ofs);
   regAL..regBH: { 3B - AL,BL,CL,DL,AH,BH,CH,DH ? }
    SetStrChr2Ofs(Output,Char(C10),Char(A1-regAL+((A2-regAX)*8)),A1,Ofs);
   DataByte: { 3C - Data : Byte ? }
    SetStrChr3(Output,#$80,Char(C),Char(Data));
   DataWord: { 3D - Data : Word ? }
   Begin
    If(Data > $FF)Then SetStrChr4(Output,#$80,Char(C10),Char(Data),Char(Hi(Data)))
		  else SetStrChr3(Output,#$83,Char(C),Char(Data));
   End;
   Else AD_ := InvalidA2; { 3E - Error ? }
  End;
  Else AD_ := InvalidA1; { 4 - Error ? }
 End;
End;

Function AND_;
Var I:Byte;
Begin
 AND_ := 0; Output := '';
 Case A1 of
  regAL..regBH: { 1 - AL,BL,CL,DL,AH,BH,CH,DH ? }
  Case A2 of
   regAL..regBH: { 1A - AL,BL,CL,DL,AH,BH,CH,DH ? }
    SetStrChr2(Output,#$22,Char($C0+((A1-regAL)*8)+A2-regAL));
   adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 1B - Address ? }
    SetStrChr2Ofs(Output,#$22,Char(A2+(A1-regAL)),A2,Ofs);
   DataByte : { 1C - Data : Byte ? }
    SetStrChr3(Output,#$80,Char($E0+A2-regAL),Char(Data));
   Else AND_ := InvalidA2; { 1D - Error ? }
  End;
  regAX..regDI : { 2 - BX,CX,DX,BP,SP,SI,DI ? }
  Case A2 of
   regAX..regDI : { 2A - AX,BX,CX,DX,BP,SP,SI,DI ? }
    SetStrChr2(Output,#$23,Char($C0+((A1-regAX)*8)+A2-regAX));
   adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 2B - Address ? }
    SetStrChr2Ofs(Output,#$23,Char(((A1-regAX)*8)+A2),A2,Ofs);
   DataWord : { 2C - Data : Word ? }
   Begin
    SetStrChr3(Output,#$83,Char($E0+A1-regAX),Char(Data));
    If(_C80286)and(Data < $100)Then
    Begin
     SetStrChr4(Output,#$81,Char($E0+A1-regAX),Char(Data),Char(Hi(Data)));
    End;
   End;
   Else AND_ := InvalidA2; { 2D - Error ? }
  End;
  regAX : { 20 }
  If(_C80286)Then Case A2 of
   regAX..regDI : { 20A - AX,BX,CX,DX,BP,SP,SI,DI ? }
    SetStrChr2(Output,#$23,Char($C0+A2-regAX));
   adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 20B - Address }
    SetStrChr2Ofs(Output,#$23,Char(A2),A2,Ofs);
   DataWord : { 20C - Data : Word }
    SetStrChr3(Output,#$25,Char(Data),Char(Hi(Data)));
   Else AND_ := InvalidA2; { 20D - Error }
  End;
  regAL : { 21 }
  If(_C80286)Then Case A2 of
   regAL..regBH: { 21A - AL,BL,CL,DL,AH,BH,CH,DH ? }
    SetStrChr2(Output,#$22,Char($C0+(A2-regAL)));
   adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 21B - Address }
    SetStrChr2Ofs(Output,#$22,Char(A2),A2,Ofs);
   DataByte : { 21C - Data : Byte }
    SetStrChr2(Output,#$24,Char(Data));
   Else AND_ := InvalidA2; { 21D - Error }
  End;
  Else AND_ := InvalidA1; { 99 - Error }
 End;
End;

Function ADC;
Begin
 ADC := AD_(True,A1,A2,Ofs,Data,Output);
End;

Function ADD;
Begin
 ADD := AD_(False,A1,A2,Ofs,Data,Output);
End;

Function CALL;
Var NearAdr:Word; PB:Array[0..3] of Char Absolute Ptr; NB:Array[0..1] of Char Absolute NearAdr;
Begin
 CALL := 0; Output := '';
 Case A of
  adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { Address }
  If(Far_)Then SetStrChr2Ofs(Output,#$FF,Char($18+A),A,Ofs(Ptr))
	  Else SetStrChr2Ofs(Output,#$FF,Char($10+A),A,Ofs(Ptr));
  CallDirect :
  If(Far_)Then
  Begin
   SetStrChr4(Output,#$9A,PB[0],PB[1],PB[2]);
   IncStr(Output,PB[3]);
  End
   Else
  Begin
   NearAdr := ($FFFD - adr) + Ofs(Ptr);
   SetStrChr3(Output,#$E8,NB[0],NB[1]);
  End;
  Else CALL := InvalidA1;
 End;
End;

Function CallFar;
Begin
 CallFar := Call(A,True,Ptr,0,Output);
End;

Function CallNear;
Begin
 CallNear := Call(A,False,Ptr(0,ofs),adr,Output);
End;

Procedure AAA;
Begin
 SetStrChr(Output,Char(__AAA));
End;

Procedure CBW;
Begin
 SetStrChr(Output,Char(__CBW));
End;

Procedure CLC;
Begin
 SetStrChr(Output,Char(__CLC));
End;

Procedure CLD;
Begin
 SetStrChr(Output,Char(__CLD));
End;

Procedure CLI;
Begin
 SetStrChr(Output,Char(__CLI));
End;

Function CMP;
Begin
 CMP := 0; Output := '';
 Case A1 of
  regAX..regDI : { 1 - AX,BX,CX,DX,BP,SP,SI,DI ? }
  Case A2 of
   regAX..regDI: { 1A - AX,BX,CX,DX,BP,SP,SI,DI ? }
    SetStrChr2(Output,#$3B,Char($C0+(A1-regAX)*8+(A2-regAX)));
   adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 1B - Address ? }
    SetStrChr2Ofs(Output,#$3B,Char(A2+(A1-regAX)*8),A2,Ofs);
   DataWord: { 1C - Data : Word ? }
    SetStrChr4(Output,#$81,Char($F8+A1-regAX),Char(Data),Char(Hi(Data)));
   Else CMP := InvalidA2; { 1D - Error }
  End;
  Else CMP := InvalidA1; { 99 - Error }
 End;
End;

Procedure CMPSB;
Begin
 SetStrChr(Output,Char(__CMPSB));
End;

Procedure CMPSW;
Begin
 SetStrChr(Output,Char(__CMPSW));
End;

Procedure CWD;
Begin
 SetStrChr(Output,Char(__CWD));
End;

Function Dec;
Begin
 Dec := 0; Output := '';
 Case A of
  adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 1 - Address ? }
   SetStrChr2Ofs(Output,Char($FE + Byte(Word)),Char($08+A),A,Ofs);
  regAL..regBH : { 2 - AL,BL,CL,DL,AH,BH,CH,DH ? }
   SetStrChr2(Output,#$FE,Char($C0+A-regAL));
  regAX..regDI : { 3 - AX,BX,CX,DX,SP,BP,SI,DI ? }
   SetStrChr(Output,Char($48+A-regAX));
  Else Dec := InvalidA1; { 4 - Error }
 End;
End;

Function Div_;
Begin
 Div_ := 0; Output := '';
 Case A of
  adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 1 - Address }
   SetStrChr2Ofs(Output,Char($F6 + Byte(Word)),Char($30+A),A,Ofs);
  regAL..regBH : { 2 - AL,BL,CL,DL,AH,BH,CH,DH ? }
   SetStrChr2(Output,#$F6,Char($F0+A-regAL));
  regAX..regDI : { 3 - AX,BX,CX,DX,SP,BP,SI,DI ? }
   SetStrChr2(Output,#$F7,Char($F0+A-regAL));
  Else Div_ := InvalidA1; { 4 - Error ? }
 End;
End;

Function IDiv;
Begin
 IDiv := 0; Output := '';
 Case A of
  adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 1 - Address ? }
   SetStrChr2Ofs(Output,Char($F6+Byte(Word)),Char($38+A),A,Ofs);
  regAL..regBH : { 2 - AL,BL,CL,DL,AH,BH,CH,DH ? }
   SetStrChr2(Output,#$F6,Char($F8+A-regAL));
  regAX..regDI : { 3 - AX,BX,CX,DX,SP,BP,SI,DI ? }
   SetStrChr2(Output,#$F7,Char($F8+A-regAL));
  Else IDiv := InvalidA1; { 4 - Error ? }
 End;
End;

Function IMul;
Begin
 IMul := 0; Output := '';
 Case A of
  adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 1 - Address ? }
   SetStrChr2Ofs(Output,Char($F6+Byte(Word)),Char($28+A),A,Ofs);
  regAL..regBH : { 2 - AL,BL,CL,DL,AH,BH,CH,DH ? }
   SetStrChr2(Output,#$F6,Char($E8+A-regAL));
  regAX..regDI : { 3 - AX,BX,CX,DX,SP,BP,SI,DI ? }
   SetStrChr2(Output,#$F7,Char($E8+A-regAL));
  Else IMul := InvalidA1; { 4 - Error ? }
 End;
End;

Function Inc;
Begin
 Inc := 0; Output := '';
 Case A of
  adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 1 - Address ? }
   SetStrChr2Ofs(Output,Char($FE+Byte(Word)),Char(A),A,Ofs);
  regAL..regBH : { 2 - AL,BL,CL,DL,AH,BH,CH,DH ? }
   SetStrChr2(Output,#$FE,Char($C0+A-regAL));
  regAX..regDI : { 3 - AX,BX,CX,DX,SP,BP,SI,DI ? }
   SetStrChr(Output,Char($40+A-regAX));
  Else Inc := InvalidA1; { 4 - Error ? }
 End;
End;

Procedure Int;
Begin
 SetStrChr2(Output,#$CD,Char(Num));
End;

Procedure IRet;
Begin
 SetStrChr(Output,Char(__IRET));
End;

Procedure LAHF;
Begin
 SetStrChr(Output,Char(__LAHF));
End;

Function Mov;
Var BA1,BA2,SA1,SA2,WA1,WA1_8,WA2:Byte;
Begin
 Mov := 0; Output := ''; BA1 := A1 - regAL; BA2 := A2 - regAL;
 SA1 := A1 - regES; SA2 := A2 - regES; WA1 := A1 - regAX;
 WA2 := A2 - regAX; WA1_8 := WA1 * 8;
 Case A1 of
  regES..regDS :
  Case A2 of
   regAX..regDI : { AX,BX,CX,DX,BP,SP,SI,DI ? }
    SetStrChr2(Output,#$8E,Char($C0+SA1*8+WA2));
   adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { Address ? }
    SetStrChr2Ofs(Output,#$8E,Char(SA1*8+WA2),A2,Ofs);
   Else Mov := InvalidA2; { Error ? }
  End;
  regAX..regDI :
  Case A2 of
   regES..regDS : { CS,DS,ES,SS ? }
    SetStrChr2(Output,#$8C,Char($C0+SA2*8+WA1));
   regAX..regDI : { AX,BX,CX,DX,BP,SP,SI,DI ? }
    SetStrChr2(Output,#$8B,Char($C0+WA1_8+WA2));
   adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_:
    SetStrChr2Ofs(Output,#$8B,Char(WA1_8+WA2),A2,Ofs);
   Else Mov := InvalidA2;
  End;
  regAL..regBH :
  Case A2 of
   regAL..regBH :
   SetStrChr2(Output,#$88,Char($C0+BA2*8+BA1));
   adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_:
    SetStrChr2Ofs(Output,#$8A,Char(A2+BA1),A2,Ofs);
   DataByte :
    SetStrChr2(Output,Char($B8+BA1),Char(Data));
   Else Mov := InvalidA2;
  End;
  adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_:
  Case A2 of
   regAX..regDI :
    SetStrChr2Ofs(Output,#$89,Char(A1+WA2),A1,Ofs);
   regAL..regBH :
    SetStrChr2Ofs(Output,#$88,Char(A1+WA2),A1,Ofs);
   Else Mov := InvalidA2;
  End;
  Else Mov := InvalidA1;
 End;
End;

Procedure MovSB;
Begin
 SetStrChr(Output,Char(__MOVSB));
End;

Procedure MovSW;
Begin
 SetStrChr(Output,Char(__MOVSW));
End;

Function Mul;
Begin
 Mul := 0; Output := '';
 Case A of
  adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 1 - Address ? }
   SetStrChr2(Output,Char($F6+Byte(Word)),Char($20+A));
  regAL..regBH : { 2 - AL,BL,CL,DL,AH,BH,CH,DH ? }
   SetStrChr2(Output,#$F6,Char($E0+A-regAL));
  regAX..regDI : { 3 - AX,BX,CX,DX,SP,BP,SI,DI ? }
   SetStrChr2(Output,#$F7,Char($E0+A-regAL));
  Else Mul := InvalidA1; { 4 - Error ? }
 End;
End;

Function Neg;
Begin
 Neg := 0; Output := '';
 Case A of
  adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 1 - Address ? }
   SetStrChr2(Output,Char($F6+Byte(Word)),Char($18+A));
  regAL..regBH : { 2 - AL,BL,CL,DL,AH,BH,CH,DH ? }
   SetStrChr2(Output,#$F6,Char($D8+A-regAL));
  regAX..regDI : { 3 - AX,BX,CX,DX,SP,BP,SI,DI ? }
   SetStrChr2(Output,#$F7,Char($D8+A-regAL));
  Else Neg := InvalidA1; { 4 - Error ? }
 End;
End;

Procedure Nop;
Begin
 SetStrChr(Output,Char(__NOP));
End;

Function Not_;
Begin
 Not_ := 0; Output := '';
 Case A of
  adrBX_SI..adrBP_DI,adrBX_SI_..adrBP_DI_: { 1 - Address ? }
   SetStrChr2(Output,Char($F6+Byte(Word)),Char($10+A));
  regAL..regBH : { 2 - AL,BL,CL,DL,AH,BH,CH,DH ? }
   SetStrChr2(Output,#$F6,Char($D0+A-regAL));
  regAX..regDI : { 3 - AX,BX,CX,DX,SP,BP,SI,DI ? }
   SetStrChr2(Output,#$F7,Char($D0+A-regAL));
  Else Not_ := InvalidA1; { 4 - Error ? }
 End;
End;

Function Pop;
Begin
 Pop := 0; Output := '';
 Case A of
  regAX..regDI : { 1 - AX,BX,CX,DX,SP,BP,SI,DI ? }
   SetStrChr(Output,Char($58+A-regAX));
  regES..regDS : { 2 - ES,CS,SS,DS ? }
   SetStrChr(Output,Char(regSegB[A-regES]+1));
  Else Pop := InvalidA1; { 3 - Error }
 End;
End;

Procedure PopF;
Begin
 SetStrChr(Output,Char(__POPF));
End;

Function Push;
Begin
 Push := 0; Output := '';
 Case A of
  regAX..regDI : { 1 - AX,BX,CX,DX,SP,BP,SI,DI ? }
   SetStrChr(Output,Char($50+A-regAX));
  regES..regDS : { 2 - ES,CS,SS,DS ? }
   SetStrChr(Output,Char(regSegB[A-regES]));
  Else Push := InvalidA1; { 3 - Error }
 End;
End;

Procedure PushF;
Begin
 SetStrChr(Output,Char(__PUSHF));
End;

Procedure RetF;
Begin
 SetStrChr(Output,Char(__RETF));
End;

Procedure RetN;
Begin
 SetStrChr(Output,Char(__RETN));
End;

Procedure SCASB;
Begin
 SetStrChr(Output,Char(__SCASB));
End;

Procedure SCASW;
Begin
 SetStrChr(Output,Char(__SCASW));
End;

Procedure STC;
Begin
 SetStrChr(Output,Char(__STC));
End;

Procedure STD;
Begin
 SetStrChr(Output,Char(__STD));
End;

Procedure STI;
Begin
 SetStrChr(Output,Char(__STI));
End;

Procedure STOSB;
Begin
 SetStrChr(Output,Char(__STOSB));
End;

Procedure STOSW;
Begin
 SetStrChr(Output,Char(__STOSW));
End;

Function __Asm2Inline;
Var I:Byte;

 Function CmpName(S:String):Bool;
 Var X:Bool;
 Begin
  X := CmpLeft(Input,S);
  If(X)Then I := Length(S) + 1;
  CmpName := X;
 End;

 Function ExtractA1:String;
 Var S : String;
 Begin
  S := '';
  SkipSpcInLine(I,Input);
  While (I <= Length(Input)) do
  Begin
   If(Input[I] = ',')Then Break;
   If Not(Input[I] in [' ',#9])Then IncStr(S,Input[I]);
   System.Inc(I);
  End;
  If(Input[I] = ',')Then System.Inc(I);
  ExtractA1 := S;
 End;

 Function ExtractA2:String;
 Begin
  SkipSpcInLine(I,Input);
  If(I <= Length(Input))Then ExtractA2 := Copy(Input,I,255)
			Else ExtractA2 := '';
 End;

 Function ClassA(A:String):Byte;
 Var I:Byte;
 Begin
  ClassA := Unknown;
  If(A = '')Then Exit;
  If(A[1] = '[')Then { Address ? }
  For I := 0 to 7 do
  Begin
   If(StrPas(SAddr[I]) = A)Then
   Begin
    ClassA := I;
    Exit;
   End;
  End
   else
  Begin
   For I := 0 to 7 do
   Begin
    If(RegWord[I] = A)Then
    Begin
     ClassA := I + regAX;
     Exit;
    End;
   End;
   For I := 0 to 7 do
   Begin
    If(RegByte[I] = A)Then
    Begin
     ClassA := I + regAL;
     Exit;
    End;
   End;
  End;
 End;

 Procedure __AAA;
 Begin
  If Not(Length(Input) = Length('AAA'))Then __Asm2InLine := ParamFound
				       Else AAA(Output);
 End;

 Procedure __ADC;
 Var A1,A2 : String;
 Begin
  A1 := ExtractA1;
  If(A1 = '')Then
  Begin
   __Asm2InLine := A1Expected;
   Exit;
  End;
  A2 := ExtractA2;
  If(A2 = '')Then
  Begin
   __Asm2InLine := A2Expected;
   Exit;
  End;
  __Asm2InLine := ADC(ClassA(A1),ClassA(A2),0,0,Output);
 End;

 Procedure __ADD;
 Var A1,A2 : String;
 Begin
  A1 := ExtractA1;
  If(A1 = '')Then
  Begin
   __Asm2InLine := A1Expected;
   Exit;
  End;
  A2 := ExtractA2;
  If(A2 = '')Then
  Begin
   __Asm2InLine := A2Expected;
   Exit;
  End;
  __Asm2InLine := ADD(ClassA(A1),ClassA(A2),0,0,Output);
 End;

 Procedure __AND;
 Var A1,A2 : String;
 Begin
  A1 := ExtractA1;
  If(A1 = '')Then
  Begin
   __Asm2InLine := A1Expected;
   Exit;
  End;
  A2 := ExtractA2;
  If(A2 = '')Then
  Begin
   __Asm2InLine := A2Expected;
   Exit;
  End;
  __Asm2InLine := AND_(ClassA(A1),ClassA(A2),0,0,Output);
 End;

 Procedure __CALL;
 Begin
 End;

 Procedure __CBW;
 Begin
  If Not(Length(Input) = Length('CBW'))Then __Asm2InLine := ParamFound
				       Else CBW(Output);
 End;

 Procedure __CLC;
 Begin
  If Not(Length(Input) = Length('CLC'))Then __Asm2InLine := ParamFound
				       Else CLC(Output);
 End;

 Procedure __CLD;
 Begin
  If Not(Length(Input) = Length('CLD'))Then __Asm2InLine := ParamFound
				       Else CLD(Output);
 End;

 Procedure __CLI;
 Begin
  If Not(Length(Input) = Length('CLI'))Then __Asm2InLine := ParamFound
				       Else CLI(Output);
 End;

 Procedure __CMPSB;
 Begin
  If Not(Length(Input) = Length('CMPSB'))Then __Asm2InLine := ParamFound
					 Else CMPSB(Output);
 End;

 Procedure __CMPSW;
 Begin
  If Not(Length(Input) = Length('CMPSW'))Then __Asm2InLine := ParamFound
					 Else CMPSW(Output);
 End;

 Procedure __CWD;
 Begin
  If Not(Length(Input) = Length('CWD'))Then __Asm2InLine := ParamFound
				       Else CWD(Output);
 End;

 Procedure __IRET;
 Begin
  If Not(Length(Input) = Length('IRET'))Then __Asm2InLine := ParamFound
					Else IRet(Output);
 End;

 Procedure __LAHF;
 Begin
  If Not(Length(Input) = Length('LAHF'))Then __Asm2InLine := ParamFound
					Else LAHF(Output);
 End;

 Procedure __MOVSB;
 Begin
  If Not(Length(Input) = Length('MOVSB'))Then __Asm2InLine := ParamFound
					 Else MOVSB(Output);
 End;

 Procedure __MOVSW;
 Begin
  If Not(Length(Input) = Length('MOVSW'))Then __Asm2InLine := ParamFound
					 Else MOVSW(Output);
 End;

 Procedure __NOP;
 Begin
  If Not(Length(Input) = Length('NOP'))Then __Asm2InLine := ParamFound
				       Else NOP(Output);
 End;

 Procedure __POPF;
 Begin
  If Not(Length(Input) = Length('POPF'))Then __Asm2InLine := ParamFound
					Else POPF(Output);
 End;

 Procedure __PUSHF;
 Begin
  If Not(Length(Input) = Length('PUSHF'))Then __Asm2InLine := ParamFound
					 Else PUSHF(Output);
 End;

 Procedure __RETF;
 Begin
  If Not(Length(Input) = Length('RETF'))Then __Asm2InLine := ParamFound
					Else RETF(Output);
 End;

 Procedure __RETN;
 Begin
  If Not(Length(Input) = Length('RETN'))Then __Asm2InLine := ParamFound
					Else RETN(Output);
 End;

 Procedure __SCASB;
 Begin
  If Not(Length(Input) = Length('SCASB'))Then __Asm2InLine := ParamFound
					 Else SCASB(Output);
 End;

 Procedure __SCASW;
 Begin
  If Not(Length(Input) = Length('SCASW'))Then __Asm2InLine := ParamFound
					 Else SCASW(Output);
 End;

 Procedure __STC;
 Begin
  If Not(Length(Input) = Length('STC'))Then __Asm2InLine := ParamFound
				       Else STC(Output);
 End;

 Procedure __STD;
 Begin
  If Not(Length(Input) = Length('STD'))Then __Asm2InLine := ParamFound
				       Else STD(Output);
 End;

 Procedure __STI;
 Begin
  If Not(Length(Input) = Length('STI'))Then __Asm2InLine := ParamFound
				       Else STI(Output);
 End;

 Procedure __STOSB;
 Begin
  If Not(Length(Input) = Length('STOSB'))Then __Asm2InLine := ParamFound
					 Else STOSB(Output);
 End;

 Procedure __STOSW;
 Begin
  If Not(Length(Input) = Length('STOSW'))Then __Asm2InLine := ParamFound
					 Else STOSW(Output);
 End;

Begin
 __Asm2Inline := 0;
 Output       := '';
 If(CmpName('AAA'))Then __AAA;
 If(CmpName('ADC'))Then __ADC;
 If(CmpName('ADD'))Then __ADD;
 If(CmpName('AND'))Then __AND;
 If(CmpName('CALL'))Then __CALL;
 If(CmpName('CBW'))Then __CBW;
 If(CmpName('CLC'))Then __CLC;
 If(CmpName('CLD'))Then __CLD;
 If(CmpName('CLI'))Then __CLI;
 If(CmpName('CMP'))Then ;
 If(CmpName('CMPSB'))Then __CMPSB;
 If(CmpName('CMPSW'))Then __CMPSW;
 If(CmpName('CWD'))Then __CWD;
 If(CmpName('DEC'))Then;
 If(CmpName('DIV'))Then;
 If(CmpName('IDIV'))Then;
 If(CmpName('IMUL'))Then;
 If(CmpName('INC'))Then;
 If(CmpName('INT'))Then;
 If(CmpName('IRET'))Then __IRET;
 If(CmpName('LAHF'))Then __LAHF;
 If(CmpName('MOVSB'))Then __MOVSB;
 If(CmpName('MOVSW'))Then __MOVSW;
 If(CmpName('MUL'))Then;
 If(CmpName('NEG'))Then;
 If(CmpName('NOP'))Then __NOP;
 If(CmpName('NOT'))Then;
 If(CmpName('POP'))Then;
 If(CmpName('POPF'))Then __POPF;
 If(CmpName('PUSH'))Then;
 If(CmpName('PUSHF'))Then __PUSHF;
 If(CmpName('RETF'))Then __RETF;
 If(CmpName('RETN'))Then __RETN;
 If(CmpName('SCASB'))Then __SCASB;
 If(CmpName('SCASW'))Then __SCASW;
 If(CmpName('STC'))Then __STC;
 If(CmpName('STD'))Then __STD;
 If(CmpName('STI'))Then __STI;
 If(CmpName('STOSB'))Then __STOSB;
 If(CmpName('STOSW'))Then __STOSW;
End;

BEGIN
 _C80286 := False;
END.