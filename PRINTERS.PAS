{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³            Malte Genesis/Module des Imprimantes            ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Printers;

INTERFACE

{$I-,Q-,R-,S-,X+}

Uses Math,MLibrary,Video;

Const

      prnLPT1 = 0;
      prnLPT2 = 1;
      prnLPT3 = 2;
      prnLPT4 = 3;
      prnCom1 = 4;
      prnCom2 = 5;
      prnCom3 = 6;
      prnCom4 = 7;
      prnCom5 = 8;
      prnCom6 = 9;
      prnCom7 = 10;
      prnCom8 = 11;
      prnFile = 12;
      prnNUL  = $FF;

Type

     PrnSetupRec = Record
      Code:Word;Mode:(__NONE__,__IBM__,__EPSON__);
      Memory,PLen,PHeight:Word; P2P,ModeWM,PrnMarge,CompMode:Bool;
     End;

     PrnSetupType = Array[0..12] of PrnSetupRec;

Const

      prnNoPrinter = 0;
      prnBrotherM1209 = 1; prnBrotherM1224 = 2; prnBrotherM2518 = 3;
      prnBrotherM2524L = 4; prnBrotherM3524L = 5; prnBrotherM4018 = 6;
      prnCItohC310 = 7; prnCItohC315 = 8; prnCItohC510 = 9;
      prnCItohC510Plus = 10; prnCItohC545 = 11; prnCItohC715A = 12;
      prnCItohC815 = 13; prnCItohCI2500 = 14; prnCItohM1209 = 15;
      prnCItohM1224 = 16; prnCItohM2518 = 17; prnCItohM2524L = 18;
      prnCItohM4018 = 19; prnCItohSuperRillman = 20;
      prnCitizen120D = 21; prnCitizen120DPlus = 22; prnCitizenMSP40 = 23;
      prnCitizenMSP45 = 24; prnCitizenMSP50 = 25; prnCitizenMSP55 = 26;
      prnCitizen124D = 27; prnCitizenHQP45 = 28; prnCitizenProdot24 = 29;
      prnCitizenProdot9_9X = 30; prnCititzenSwift9 = 31;
      prnEpsonDFX5000 = 32; prnEpsonDFX8000 = 33; prnEpsonDLQ2000 = 34;
      prnEpsonFX85 = 35; prnEpsonFX800 = 36; prnEpsonFX850 = 37;
      prnEpsonFX1000 = 38; prnEpsonFX1050 = 39; prnEpsonLQ400 = 40;
      prnEpsonLQ550 = 41; prnEpsonLQ850 = 42; prnEpsonLQ850Plus = 43;
      prnEpsonLQ860 = 44; prnEpsonLQ1050 = 45; prnEpsonLQ1060 = 46;
      prnEpsonLQ2550 = 47; prnEpsonLX400 = 48; prnEpsonLX850 = 49;
      prnFujitsuDL1100 = 50; prnFujitsuDX3300 = 51; prnFujitsuDL3400 = 52;
      prnFujitsuDL4400 = 53; prnFujitsuDL4600 = 54; prnFujitsuDL5600 = 55;
      prnFujitsuDX2150 = 56; prnFujitsuDX2250 = 57;
      prnIBM4201003 = 58; prnIBM4202003 = 59; prnIBM4202007 = 60;
      prnIBM4208002 = 61; prnIBM5204001 = 62;
      prnMannMT81 = 63; prnMannMT90 = 64; prnMannMT91 = 65;
      prnMannMT130_9 = 66; prnMannMT130_24 = 67; prnMannMT131_9 = 68;
      prnMannMT131_24 = 69; prnMannMT230_9 = 70; prnMannMT230_18 = 71;
      prnMannMT230_24 = 72; prnMannMT290 = 73; prnMannMT330 = 74;
      prnMannMT340 = 75; prnMannMT460 = 76; prnMannMT490 = 77;
      prnNECP2Plus = 78; prnNECP6 = 79; prnNECP6Plus = 80;
      prnNECP7 = 81; prnNECP7Plus = 82; prnNECP20 = 83; prnNECP30 = 84;
      prnNECP60 = 85; prnNECP70 = 86; prnNECP90 = 87; prnNECP2200 = 88;
      prnOkiSystemsML182 = 89; prnOkiSystemsML183 = 90;
      prnOkiSystemsML192Elite = 91; prnOkiSystemsML193Elite = 92;
      prnOkiSystemsML292 = 93; prnOkiSystemsML293Elite = 94;
      prnOkiSystemsML294 = 95; prnOkiSystemsML320 = 96;
      prnOkiSystemML320Elite = 97; prnOkiSystemsML380 = 98;
      prnOkiSystemsML390 = 99; prnOkiSystemsML391 = 100;
      prnOkiSystemsML393 = 101; prnOkiSystemsOkimate20 = 102;
      prnPanasonicKX1081 = 103; prnPanasonicKX1180 = 104;
      prnPanasonicKX1123 = 105; prnPanasonicKX1124 = 106;
      prnPanasonicKX1624 = 107; prnPanasonicKX1695 = 108;
      prnSeikoshaBP5420FA = 109; prnSeikoshaBP5500 = 110;
      prnSeikoshaMP1300AI = 111; prnSeikoshaMP5300AI = 112;
      prnSeikoshaSBP10AI = 113; prnSeikoshaSL80IP = 114;
      prnSeikoshaSL92 = 115; prnSeikoshaSL130AI = 116;
      prnSeikoshaSL230AI = 117; prnSeikoshaSL532 = 118;
      prnSeikoshaSP1600AI = 119; prnSeikoshaSP1800AI = 120;
      prnSeikoshaSP2000 = 121;
      prnStarLC10 = 122; prnStarLC10LL = 123; prnStarLC10colour = 124;
      prnStarLC15 = 125; prnStarLC20 = 126; prnStarLC24_10 = 127;
      prnStarLC24_15 = 128; prnStarLC24_200 = 129; prnStarLC200 = 130;
      prnStarNB15 = 131; prnStarNB24_10 = 132; prnStarNB24_15 = 133;
      prnStarND10 = 134; prnStarND15 = 135; prnStarNL10 = 136;
      prnStarNR10 = 137; prnStarNR15 = 138; prnStarXB24_10 = 139;
      prnStarXB24_15 = 140;

      PrnErr:Byte = 0;

      PrnSetup:PrnSetupType = (
      (Code:prnPanasonicKX1180; Mode:__IBM__; Memory:4; PLen:95;
      PHeight:110; P2P:False; ModeWM:False; PrnMarge:False;CompMode:False),
      (Code:prnEpsonFX800; Mode:__EPSON__; Memory:4; PLen:95;
      PHeight:110; P2P:False; ModeWM:False; PrnMarge:False;CompMode:False),
      (Code:prnNoPrinter; Mode:__NONE__; Memory:0; PLen:95;
      PHeight:110; P2P:False; ModeWM:False; PrnMarge:False;CompMode:False),
      (Code:prnNoPrinter; Mode:__NONE__; Memory:0; PLen:95;
      PHeight:110;P2P:False; ModeWM:False; PrnMarge:False;CompMode:False),

      (Code:prnNoPrinter; Mode:__NONE__; Memory:0; PLen:95;
      PHeight:110; P2P:False; ModeWM:False; PrnMarge:False;CompMode:False),
      (Code:prnNoPrinter; Mode:__NONE__; Memory:0; PLen:95;
      PHeight:110; P2P:False; ModeWM:False; PrnMarge:False;CompMode:False),
      (Code:prnNoPrinter; Mode:__NONE__; Memory:0; PLen:95;
      PHeight:110;P2P:False; ModeWM:False; PrnMarge:False;CompMode:False),
      (Code:prnNoPrinter; Mode:__NONE__; Memory:0; PLen:95;
      PHeight:110;P2P:False; ModeWM:False; PrnMarge:False;CompMode:False),
      (Code:prnNoPrinter; Mode:__NONE__; Memory:0; PLen:95;
      PHeight:110;P2P:False; ModeWM:False; PrnMarge:False;CompMode:False),
      (Code:prnNoPrinter; Mode:__NONE__; Memory:0; PLen:95;
      PHeight:110;P2P:False; ModeWM:False; PrnMarge:False;CompMode:False),
      (Code:prnNoPrinter; Mode:__NONE__; Memory:0; PLen:95;
      PHeight:110;P2P:False; ModeWM:False; PrnMarge:False;CompMode:False),
      (Code:prnNoPrinter; Mode:__NONE__; Memory:0; PLen:95;
      PHeight:110;P2P:False; ModeWM:False; PrnMarge:False;CompMode:False),

      (Code:prnNoPrinter; Mode:__NONE__; Memory:0; PLen:95;
      PHeight:110; P2P:False; ModeWM:False; PrnMarge:False;CompMode:False));

Var PrnOutput:Byte;

Function ChkPrint(Num:Byte):Bool;
Function Get1LPT:Byte;
Function GetPromptPrn:String;
Function InitPrint(Num:Byte):Bool;
Function InitPrn:Bool;
Function LPT1Exist:Bool;
Function LPT2Exist:Bool;
Function LPT3Exist:Bool;
Function LPT4Exist:Bool;
Function LPTExist:Bool;
Function NumLPT:Byte;
Function PrintChr(Chr:Char;Num:Byte):Bool;
Function Print(Str:String;Num:Byte):Bool;
Function Prn(Str:String):Bool;
Function PrnLn:Bool;
Function PrnStepBit(Nm:Byte):Bool;
Function StrCurrPrnPHeight:String;
Function StrCurrPrnPLen:String;
Function __SetPrnBold:Bool;
Function __SetPrnCompress:Bool;
Function __SetPrnDbl:Bool;
Function __SetPrnInterLn1_8:Bool;
Function __SetPrnItalic:Bool;
Function __SetPrnSimple:Bool;
Function __SetPrnUnBold:Bool;
Function __SetPrnUnItalic:Bool;

IMPLEMENTATION

Uses Strs,Strings,Language,Keyboard,Memorys,Terminal,TeleMate,Spooler;

Function ChkPrint;
Assembler;
ASM
 MOV AH,$02;
 MOV DL,Num;
 MOV DH,0;
 INT $17;
 CMP AH,$90;
 JE  @@Ok;
 MOV PrnErr,AH;
 MOV AL,Byte(False);
 JMP @@End;
@@Ok:
 MOV AL,Byte(True);
@@End:
END;

Function Get1LPT;
Assembler;
ASM
 XOR AX,AX;
 MOV ES,AX;
 MOV AL,$FF;
 CMP Word Ptr ES:[$40E],0;
 JZ  @@LPT2;
 MOV AL,3;
@@LPT2:
 CMP Word Ptr ES:[$40C],0;
 JZ  @@LPT3;
 MOV AL,2;
@@LPT3:
 CMP Word Ptr ES:[$40A],0;
 JZ  @@LPT4;
 MOV AL,1;
@@LPT4:
 CMP Word Ptr ES:[$408],0;
 JZ  @@End;
 MOV AL,0;
@@End:
END;

Function InitPrint;
Begin
 Case PrnSetup[Num].Mode of
  __IBM__ : InitPrint := Print(Char(ESC) + '@',Num);
       Else InitPrint := False;
 End;
End;

Function InitPrn;
Begin
 InitPrn := False;
 If(PrnOutput <= prnLPT4)Then InitPrn := InitPrint(PrnOutput);
End;

Function LPT1Exist;
Assembler;
ASM
 XOR AX,AX;
 MOV ES,AX;
 CMP Word Ptr ES:[$408],0;
 JZ  @@End;
 INC AX;
@@End:
END;

Function LPT2Exist;
Assembler;
ASM
 XOR AX,AX;
 MOV ES,AX;
 CMP Word Ptr ES:[$40A],0;
 JZ  @@End;
 INC AX;
@@End:
END;

Function LPT3Exist;
Assembler;
ASM
 XOR AX,AX;
 MOV ES,AX;
 CMP Word Ptr ES:[$40C],0;
 JZ  @@End;
 INC AX;
@@End:
END;

Function LPT4Exist;
Assembler;
ASM
 XOR AX,AX;
 MOV ES,AX;
 CMP Word Ptr ES:[$40E],0;
 JZ  @@End;
 INC AX;
@@End:
END;

Function LPTExist;
Begin
 LPTExist := (NumLPT > 0);
End;

Function NumLPT;
Assembler;
ASM
 XOR AX,AX;
 MOV ES,AX;
 CMP Word Ptr ES:[$408],0;
 JZ  @@LPT2;
 INC AX;
@@LPT2:
 CMP Word Ptr ES:[$40A],0;
 JZ  @@LPT3;
 INC AX;
@@LPT3:
 CMP Word Ptr ES:[$40C],0;
 JZ  @@LPT4;
 INC AX;
@@LPT4:
 CMP Word Ptr ES:[$40E],0;
 JZ  @@End;
 INC AX;
@@End:
END;

Function Print;
Var I : Byte;
Begin
 Print := False;
 If(Num > 3)Then Exit;
 For I := 1 to Length(Str) do If Not(PrintChr(Str[I],Num))Then Exit;
 Print := True;
End;

Function PrintChr;
Assembler;
ASM
 MOV AL,PrnOutput;
 AND AL,3;
 SHL AL,1;
 ADD AL,8;
 MOV AH,$04;
 MOV DI,AX;
 XOR AX,AX;
 MOV ES,AX;
 MOV DX,ES:[DI];
 INC DX;
@@1:
 IN  AL,DX;
 AND AL,128;
 JZ  @@1;
 DEC DX;
 MOV AL,Chr;
 OUT DX,AL;
 INC DX;
 INC DX;
 IN  AL,DX;
 OR  AL,1;
 OUT DX,AL;
 IN  AL,DX;
 AND AL,NOT 1;
 OUT DX,AL;
 DEC DX;
@@2:
 IN  AL,DX;
 AND AL,64;
 CMP AL,1;
 JE  @@2;
 MOV AL,Byte(True);
END;

Function Prn;
Begin
 Case PrnOutput of
  prnLPT1..prnLPT4:
   PushStrSpooler(Str);
  prnCom1..prnCom8:
   Begin
    AsyncSendStr2Com(Str,PrnOutput-prnCom1);
    Prn := True;
   End;
 End;
End;

Function PrnLn;
Begin
 PrnLn := Prn(#13#10);
End;

Function PrnStepBit;
Var I:Byte;
Begin
 If(Nm = 0)Then Exit;
 If(PrnSetup[PrnOutput].CompMode)Then Prn(Char(ESC)+'L'+Char(Nm))
				 Else Prn(Char(ESC)+'K'+Char(Nm));
 For I := 0 to Nm do Printers.Prn(#0);
End;

Function StrCurrPrnPHeight;
Var PHeight:Word;
Begin
 PHeight := PrnSetup[PrnOutput].PHeight;
 StrCurrPrnPHeight := Str(PHeight div 10) + '.'+Str(PHeight mod 10);
End;

Function StrCurrPrnPLen;
Var PLen:Word;
Begin
 PLen := PrnSetup[PrnOutput].PLen;
 StrCurrPrnPLen := Str(PLen div 10)+'.'+Str(PLen mod 10);
End;

Function __SetPrnBold;
Begin
 Case PrnSetup[PrnOutput].Mode of
  __IBM__ : __SetPrnBold := Prn(Char(ESC) + 'E');
       Else __SetPrnBold := False;
 End;
End;

Function __SetPrnCompress;
Begin
 If(PrnOutput <= prnLPT4)Then
 Case PrnSetup[PrnOutput].Mode of
   __IBM__ : Begin
    Prn(Char(ESC)+'M'+Char(ESC)+Char(SI));
    PrnSetup[PrnOutput].CompMode := True;
    __SetPrnCompress := True;
   End;
   Else
   __SetPrnCompress := False;
 End
  Else
 __SetPrnCompress := False;
End;

Function __SetPrnDbl;
Begin
 __SetPrnDbl := Prn(Char(ESC) + 'W1');
End;

Function __SetPrnItalic;
Begin
 __SetPrnItalic := Prn(Char(ESC) + #4);
End;

Function __SetPrnSimple;
Begin
 __SetPrnSimple := Prn(Char(ESC) + 'W0');
End;

Function __SetPrnUnBold;
Begin
 __SetPrnUnBold := Prn(Char(ESC) + 'F');
End;

Function __SetPrnUnItalic;
Begin
 __SetPrnUnItalic := Prn(Char(ESC) + #5);
End;

Function __SetPrnInterLn1_8:Bool;
Begin
 __SetPrnInterLn1_8 := Prn(Char(ESC) + '0');
End;

Function GetPromptPrn:String;
Var Output : String;
Begin
 Case PrnOutput of
  prnLPT1 : OutPut := 'LPT1:';
  prnLPT2 : OutPut := 'LPT2:';
  prnLPT3 : OutPut := 'LPT3:';
  prnLPT4 : OutPut := 'LPT4:';
  prnCom1 : OutPut := 'COM1:';
  prnCom2 : OutPut := 'COM2:';
  prnCom3 : OutPut := 'COM3:';
  prnCom4 : OutPut := 'COM4:';
  prnCom5 : OutPut := 'COM5:';
  prnCom6 : OutPut := 'COM6:';
  prnCom7 : OutPut := 'COM7:';
  prnCom8 : OutPut := 'COM8:';
  prnFile : OutPut := 'FILE:';
  prnNUL  : OutPut := 'NUL';
 End;
 GetPromptPrn := Output + '>';
End;

BEGIN
 PrnOutput := Get1LPT;
END.