(********************************************************)
(*                                                      *)
(*                Malte Genesis/AntiVirus               *)
(*   Phoenix Edition for Real Mode & Protected Mode     *)
(*                   II - Version 1.8                   *)
(*                      1994/12/29                      *)
(*                                                      *)
(*      Copyiright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit AntiVirus;

INTERFACE

Uses Math;

Function AgiplanVirus:Bool;
Function AnarkiaVirus:Bool;
Function ArmagedonVirus:Bool;
Function BlackMondayVirus:Bool;
Function CariocaVirus:Bool;
Function CascadeVirus:Bool;
Function DatalockVirus:Bool;
Function dBASEVirus:Bool;
Function DiamondAVirus:Bool;
Function DiamondBVirus:Bool;
Function DirVirus:Bool;
Function DurbanVirus:Bool;
Function Dutch555Virus:Bool;
Function Eddie2Virus:Bool;
Function FellowShipVirus:Bool;
Function FlipVirus:Bool;
Function FrereJacquesVirus:Bool;
Function FuManchuVirus:Bool;
Function GPIVirus:Bool;
Function GVirus:Bool;
Function InvaderVirus:Bool;
Function JerusalemVirus:Bool;
Function JerusalemGVirus:Bool;
Function JusticeVirus:Bool;
Function KlaerenVirus:Bool;
Function LozinskyVirus:Bool;
Function MagnitogorskVirus:Bool;
Function MendozaVirus:Bool;
Function MGVirus:Bool;
Function MltiVirus:Bool;
Function Murphy1Virus:Bool;
Function Murphy2Virus:Bool;
Function NomenklaturaVirus:Bool;
Function OntarioVirus:Bool;
Function OropaxVirus:Bool;
Function Plastique2576Virus:Bool;
Function PlastiqueVirus:Bool;
Function PSQR1720Virus:Bool;
Function ShakeVirus:Bool;
Function SlowVirus:Bool;
Function SolanoVirus:Bool;
Function SpyerVirus:Bool;
Function SundayVirus:Bool;
Function SVCVirus:Bool;
Function SverdlovVirus:Bool;
Function TerrorVirus:Bool;
Function VoronezhVirus:Bool;
Function VriestVirus:Bool;
Function WestwoodVirus:Bool;
Function YankeeVirus:Bool;
Function _516Virus:Bool;
Function _600Virus:Bool;
Function _699Virus:Bool;
Function _707Virus:Bool;
Function _789Virus:Bool;
Function _8tunesVirus:Bool;
Function _905Virus:Bool;
Function _948Virus:Bool;
Function _1049Virus:Bool;
Function _1067Virus:Bool;
Function _2468Virus:Bool;

Const

      _AgiplanVirus = 0;
      _AnarkiaVirus = 1;
      _ArmagedonVirus = 2;
      _BlackMondayVirus = 3;
      _CariocaVirus = 4;
      _CascadeVirus = 5;
      _DatalockVirus = 6;
      _dBASEVirus = 7;
      _DiamondAVirus = 8;
      _DiamondBVirus = 9;
      _DirVirus = 10;
      _DurbanVirus = 11;
      _Dutch555Virus = 12;
      _Eddie2Virus = 13;
      _FellowShipVirus = 14;
      _FlipVirus = 15;
      _FrereJacquesVirus = 16;
      _FuManchuVirus = 17;
      _GPIVirus = 18;
      _GVirus = 19;
      _InvaderVirus = 20;
      _JerusalemVirus = 21;
      _JerusalemGVirus = 22;
      _JusticeVirus = 23;
      _KlaerenVirus = 24;
      _LozinskyVirus = 25;
      _MagnitogorskVirus = 26;
      _MendozaVirus = 27;
      _MGVirus = 28;
      _MltiVirus = 29;
      _Murphy1Virus = 30;
      _Murphy2Virus = 31;
      _NomenklaturaVirus = 32;
      _OntarioVirus = 33;
      _OropaxVirus = 34;
      _Plastique2576Virus = 35;
      _PlastiqueVirus = 36;
      _PSQR1720Virus = 37;
      _ShakeVirus = 38;
      _SlowVirus = 39;
      _SolanoVirus = 40;
      _SpyerVirus = 41;
      _SundayVirus = 42;
      _SVCVirus = 43;
      _SverdlovVirus = 44;
      _TerrorVirus = 45;
      _VoronezhVirus = 46;
      _VriestVirus = 47;
      _WestwoodVirus = 48;
      _YankeeVirus = 49;
      __516Virus = 50;
      __600Virus = 51;
      __699Virus = 52;
      __707Virus = 53;
      __789Virus = 54;
      __8tunesVirus = 55;
      __905Virus = 56;
      __948Virus = 57;
      __1049Virus = 58;
      __1067Virus = 59;
      __2468Virus = 60;

      MaxVirusBank = 60;

      AntiVirusBank : Array[0..MaxVirusBank] of
      Record
       Func:Function:Bool; PChr:PChar;
      End = (
       (Func:_516Virus;PChr:'516'),
       (Func:_600Virus;PChr:'600'),
       (Func:_699Virus;PChr:'699'),
       (Func:_707Virus;PChr:'707'),
       (Func:_789Virus;PChr:'789'),
       (Func:_8tunesVirus;PChr:'8-tunes'),
       (Func:_905Virus;PChr:'905'),
       (Func:_948Virus;PChr:'948'),
       (Func:_1049Virus;PChr:'1049'),
       (Func:_1067Virus;PChr:'1067'),
       (Func:_2468Virus;PChr:'2468'),
       (Func:AgiplanVirus;PChr:'Agiplan'),
       (Func:AnarkiaVirus;PChr:'Anarkia'),
       (Func:ArmagedonVirus;PChr:'Armagedon'),
       (Func:BlackMondayVirus;PChr:'Black-Monday'),
       (Func:CariocaVirus;PChr:'Carioca'),
       (Func:CascadeVirus;PChr:'Cascade'),
       (Func:DatalockVirus;PChr:'DataLock'),
       (Func:dBASEVirus;PChr:'dBASE'),
       (Func:DiamondAVirus;PChr:'Diamond-A'),
       (Func:DiamondBVirus;PChr:'Diamond-B'),
       (Func:DirVirus;PChr:'Dir'),
       (Func:DurbanVirus;PChr:'Durban'),
       (Func:Dutch555Virus;PChr:'Dutch-555'),
       (Func:Eddie2Virus;PChr:'Eddie 2'),
       (Func:FellowShipVirus;PChr:'FellowShip'),
       (Func:FlipVirus;PChr:'Flip'),
       (Func:FrereJacquesVirus;PChr:'Fräre-Jacques'),
       (Func:FuManchuVirus;PChr:'Fu Manchu'),
       (Func:GPIVirus;PChr:'GPI'),
       (Func:GVirus;PChr:'G'),
       (Func:InvaderVirus;PChr:'Invader'),
       (Func:JerusalemVirus;PChr:'Jerusalem'),
       (Func:JerusalemGVirus;PChr:'Jerusalem-G'),
       (Func:JusticeVirus;PChr:'Justice'),
       (Func:KlaerenVirus;PChr:'Klaeren'),
       (Func:LozinskyVirus;PChr:'Lozinsky'),
       (Func:MagnitogorskVirus;PChr:'Magnitogorsk'),
       (Func:MendozaVirus;PChr:'Mendoza'),
       (Func:MGVirus;PChr:'MG'),
       (Func:MltiVirus;PChr:'Mlti'),
       (Func:Murphy1Virus;PChr:'Murphy-1'),
       (Func:Murphy2Virus;PChr:'Murphy-2'),
       (Func:NomenklaturaVirus;PChr:'Nomenklatura'),
       (Func:OntarioVirus;PChr:'Ontario'),
       (Func:OropaxVirus;PChr:'Oropax'),
       (Func:Plastique2576Virus;PChr:'Plastique 2576'),
       (Func:PlastiqueVirus;PChr:'Plastique'),
       (Func:PSQR1720Virus;PChr:'PSQR/1720'),
       (Func:ShakeVirus;PChr:'Shake'),
       (Func:SlowVirus;PChr:'Slow'),
       (Func:SolanoVirus;PChr:'Solano'),
       (Func:SpyerVirus;PChr:'Spyer'),
       (Func:SundayVirus;PChr:'Sunday'),
       (Func:SVCVirus;PChr:'SVC'),
       (Func:SverdlovVirus;PChr:'Sverdlov'),
       (Func:TerrorVirus;PChr:'Terror'),
       (Func:VoronezhVirus;PChr:'Voronezh'),
       (Func:VriestVirus;PChr:'Vriest'),
       (Func:WestwoodVirus;PChr:'Westwood'),
       (Func:YankeeVirus;PChr:'Yankee'));

IMPLEMENTATION

Function GVirus;
Assembler;
ASM
 MOV AX,$0B56;
 INT $21;
 CMP AX,$4952;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function Dutch555Virus;
Assembler;
ASM
 MOV AX,$30F1;
 INT $21;
 CMP AL,0;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function OropaxVirus;
Assembler;
ASM
 MOV AX,$33E0;
 INT $21;
 CMP AL,$FF;
 MOV AL,Byte(False);
 JNE @@End;
 CMP AH,$33;
 JE  @@End;
 MOV AL,Byte(True);
@@End:
END;

Function AgiplanVirus;
Assembler;
ASM
 MOV AX,$357F;
 XOR DX,DX;
 INT $21;
 CMP DX,$FFFF;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function ShakeVirus;
Assembler;
ASM
 MOV AX,$4203;
 INT $21;
 CMP AX,$1234;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function InvaderVirus;
Assembler;
ASM
 MOV AX,$4243;
 INT $21;
 CMP AX,$5678;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function MGVirus;
Assembler;
ASM
 MOV AX,$4B04;
 XOR BX,BX;
 XOR DX,DX;
 STC;
 PUSH DS;
  MOV ES,BX;
  MOV DS,BX;
  INT $21;
 POP DS;
 MOV AL,Byte(False);
 JC  @@End;
 MOV AL,Byte(True);
@@End:
END;

Function _699Virus;
Assembler;
ASM
 MOV AX,$4B04;
 XOR BX,BX;
 XOR DX,DX;
 STC;
 PUSH DS;
  MOV ES,BX;
  MOV DS,BX;
  INT $21;
 POP DS;
 CMP AX,$044B;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function PlastiqueVirus;
Assembler;
ASM
 MOV AX,$4B40;
 INT $21;
 CMP AX,$5678;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function Murphy2Virus;
Assembler;
ASM
 MOV AX,$4B4D;
 STC;
 INT $21;
 MOV AL,Byte(False);
 JC  @@End;
 MOV AL,Byte(True);
@@End:
END;

Function Plastique2576Virus;
Assembler;
ASM
 MOV AX,$4B50;
 INT $21;
 CMP AX,$1234;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function Murphy1Virus;
Assembler;
ASM
 MOV AX,$4B59;
 STC;
 INT $21;
 MOV AL,Byte(False);
 JC  @@End;
 MOV AL,Byte(True);
@@End:
END;

Function NomenklaturaVirus;
Assembler;
ASM
 MOV AX,$4BAA;
 STC;
 INT $21;
 MOV AL,Byte(False);
 JC  @@End;
 MOV AL,Byte(True);
@@End:
END;

Function _948Virus;
Assembler;
ASM
 MOV AX,$4BAF;
 INT $21;
 CMP AL,$FA;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function MagnitogorskVirus;
Assembler;
ASM
 MOV AX,$4BAF;
 INT $21;
 CMP AL,$AF;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function LozinskyVirus;
Assembler;
ASM
 MOV AX,$4BDD;
 INT $21;
 CMP AX,$4BDD;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function _707Virus;
Assembler;
ASM
 MOV AX,$4BFF;
 MOV BL,0;
 INT $21;
 CMP BL,$FF;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function JusticeVirus;
Assembler;
ASM
 MOV AX,$4BFF;
 XOR DI,DI;
 INT $21;
 CMP DI,$55AA;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function CascadeVirus;
Assembler;
ASM
 MOV AX,$4BFF;
 XOR SI,SI;
 XOR DI,DI;
 INT $21;
 CMP DI,$55AA;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function _516Virus;
Assembler;
ASM
 MOV AX,$5252;
 XOR BX,BX;
 INT $21;
 CMP BX,$FFEE;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function _1067Virus;
Assembler;
ASM
 MOV AX,$58CC;
 STC;
 INT $21;
 MOV AL,Byte(False);
 JC  @@End;
 MOV AL,Byte(True);
@@End:
END;

Function KlaerenVirus;
Assembler;
ASM
 MOV AX,$7600;
 INT $21;
 CMP AL,$48;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function SVCVirus;
Assembler;
ASM
 MOV AH,$83;
 XOR DX,DX;
 INT $21;
 CMP DX,$1990;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function VriestVirus;
Assembler;
ASM
 MOV AH,$89;
 INT $21;
 CMP AX,$0123;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function CariocaVirus;
Assembler;
ASM
 MOV AH,$90;
 INT $21;
 CMP AH,$01;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function _789Virus;
Assembler;
ASM
 MOV AX,$A1D5;
 INT $21;
 CMP AX,$900D;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function Eddie2Virus;
Assembler;
ASM
 MOV AX,$A55A;
 INT $21;
 CMP AX,$5AA5;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function _600Virus;
Assembler;
ASM
 MOV AH,$AB;
 INT $21;
 CMP AX,$5555;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function VoronezhVirus;
Begin
 VoronezhVirus := _600Virus;
End;

Function DatalockVirus;
Assembler;
ASM
 MOV AH,$BE;
 INT $21;
 CMP AX,$1234;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function _1049Virus;
Assembler;
ASM
 MOV AX,$BE00;
 STC;
 INT $21;
 MOV AL,Byte(False);
 JNC @@End;
 MOV AL,Byte(True);
@@End:
END;

Function SlowVirus;
Assembler;
ASM
 MOV AH,$C0;
 XOR BX,BX;
 XOR CX,CX;
 XOR DX,DX;
 PUSH DS;
  MOV DS,BX;
  INT $21;
 POP DS;
 CMP AX,$0300;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function SolanoVirus;
Assembler;
ASM
 MOV AH,$C0;
 XOR BX,BX;
 XOR CX,CX;
 XOR DX,DX;
 PUSH DS;
  MOV DS,BX;
  INT $21;
 POP DS;
 CMP AX,$1234;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function _905Virus;
Assembler;
ASM
 MOV AX,$C301;
 MOV DX,$F1F1;
 INT $21;
 CMP DX,$0E0E;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function SverdlovVirus;
Assembler;
ASM
 MOV AX,$C500;
 INT $21;
 CMP AX,$6731;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function YankeeVirus;
Assembler;
ASM
 MOV AX,$C603;
 STC;
 INT $21;
 MOV AL,Byte(False);
 JNC @@End;
 MOV AL,Byte(True);
@@End:
END;

Function MltiVirus;
Begin
 MltiVirus := YankeeVirus;
End;

Function WestwoodVirus;
Assembler;
ASM
 MOV AH,$CC;
 XOR DX,DX;
 PUSH DS;
  MOV DS,DX;
  INT $21;
 POP DS;
 CMP AX,$0700;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function FellowShipVirus;
Assembler;
ASM
 MOV AX,$D000;
 XOR BX,BX;
 XOR DX,DX;
 PUSH DS;
  MOV DS,DX;
  INT $21;
 POP DS;
 CMP BX,$1234;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function DiamondAVirus;
Assembler;
ASM
 MOV AX,$D5AA;
 INT $21;
 CMP AX,$2A55;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function DiamondBVirus;
Assembler;
ASM
 MOV AX,$D5AA;
 INT $21;
 CMP AX,$2A03;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function DirVirus;
Assembler;
ASM
 MOV AX,$D5AA;
 XOR SI,SI;
 PUSH BP;
  MOV BP,$DEAA;
  INT $21;
 POP BP;
 CMP SI,$4321;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function DurbanVirus;
Assembler;
ASM
 MOV AX,$DEFF;
 INT $21;
 CMP AH,$DF;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function JerusalemVirus;
Assembler;
ASM
 MOV AX,$E000;
 XOR SI,SI;
 XOR DI,DI;
 MOV ES,SI;
 PUSH DS;
  MOV DS,SI;
  INT $21;
 POP DS;
 CMP AX,$0300;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function ArmagedonVirus;
Assembler;
ASM
 MOV AX,$E000;
 XOR SI,SI;
 XOR DI,DI;
 MOV ES,SI;
 PUSH DS;
  MOV DS,SI;
  INT $21;
 POP DS;
 CMP AX,$DADA;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function _8tunesVirus;
Assembler;
ASM
 MOV AX,$E00F;
 INT $21;
 CMP AX,$4C31;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function MendozaVirus;
Assembler;
ASM
 MOV AH,$E1;
 XOR SI,SI;
 XOR DI,DI;
 MOV ES,SI;
 PUSH DS;
  MOV DS,SI;
  INT $21;
 POP DS;
 CMP AX,$0300;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function FuManchuVirus;
Assembler;
ASM
 MOV AH,$E1;
 XOR SI,SI;
 XOR DI,DI;
 MOV ES,SI;
 PUSH DS;
  MOV DS,SI;
  INT $21;
 POP DS;
 CMP AX,$0400;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function AnarkiaVirus;
Assembler;
ASM
 MOV AH,$E4;
 XOR DX,DX;
 PUSH DS;
  MOV DS,DX;
  INT $21;
 POP DS;
 CMP AH,$04;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function SpyerVirus;
Assembler;
ASM
 MOV AH,$E7;
 INT $21;
 CMP AH,$78;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function TerrorVirus;
Assembler;
ASM
 MOV AX,$EC59;
 PUSH BP;
  INT $21;
  CMP BP,$EC59;
 POP BP;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function JerusalemGVirus;
Assembler;
ASM
 MOV AH,$EE;
 INT $21;
 CMP AX,$0300;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function FrereJacquesVirus;
Assembler;
ASM
 MOV AX,$F0FF;
 INT $21;
 CMP AX,$0300;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function GPIVirus;
Assembler;
ASM
 MOV AH,$F7;
 INT $21;
 CMP AX,$0300;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function dBASEVirus;
Assembler;
ASM
 MOV AX,$FB0A;
 INT $21;
 CMP AX,$0AFB;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function FlipVirus;
Assembler;
ASM
 MOV AX,$FE01;
 INT $21;
 CMP AX,$01FE;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function _2468Virus;
Assembler;
ASM
 MOV AX,$FE02;
 INT $21;
 CMP AX,$01FD;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function BlackMondayVirus;
Assembler;
ASM
 MOV AX,$FEDC;
 INT $21;
 CMP AL,$DC;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function SundayVirus;
Assembler;
ASM
 MOV AX,$FF00;
 INT $21;
 CMP AX,$0400;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function PSQR1720Virus;
Assembler;
ASM
 MOV AX,$FF0F;
 INT $21;
 CMP AX,$0101;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

Function OntarioVirus;
Assembler;
ASM
 MOV AX,$FFFF;
 INT $21;
 CMP AX,0;
 MOV AL,Byte(False);
 JNE @@End;
 MOV AL,Byte(True);
@@End:
END;

BEGIN
END.