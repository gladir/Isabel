{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                           ³
 ³                Malte Genesis/Module Clavier               ³
 ³                Edition Isabel pour Mode R‚el              ³
 ³                      III - Version 1.0                    ³
 ³                         1995/02/02                        ³
 ³                                                           ³
 ³       Copyright (C) par les Chevaliers de Malte           ³
 ³                                                           ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Keyboard;

INTERFACE

{$IFNDEF Debug}
 {$D-,L-,Y-}
{$ENDIF}
{$I-,Q-,R-,S-,X+}

Uses Math;

Const

      mNone = 0;
      mShiftRight = 1;
      mShiftLeft = 2;
      mShift = mShiftLeft + mShiftRight;
      mCtrl = 4;
      mAlt = 8;

      iokbEsc        = $01;
      iokb1          = $02;
      iokb2          = $03;
      iokb3          = $04;
      iokb4          = $05;
      iokb5          = $06;
      iokb6          = $07;
      iokb7          = $08;
      iokb8          = $09;
      iokb9          = $0A;
      iokb0          = $0B;
      iokbMoin       = $0C;
      iokbEqual      = $0D;
      iokbBackSpace  = $0E;
      iokbTab        = $0F;
      iokbQ          = $10;
      iokbW          = $11;
      iokbE          = $12;
      iokbR          = $13;
      iokbT          = $14;
      iokbY          = $15;
      iokbU          = $16;
      iokbI          = $17;
      iokbO          = $18;
      iokbP          = $19;
      iokbCrochetLeft= $1A;
      iokbCrochetRight=$1B;
      iokbEnter      = $1C;
      iokbCtrl       = $1D;
      iokbA          = $1E;
      iokbS          = $1F;
      iokbD          = $20;
      iokbF          = $21;
      iokbG          = $22;
      iokbH          = $23;
      iokbJ          = $24;
      iokbK          = $25;
      iokbL          = $26;
      iokbCommaFloat = $27;
      iokbApostrof   = $28;
      iokbApoInv     = $29;
      iokbShiftLeft  = $2A;
      iokbZ          = $2C;
      iokbX          = $2D;
      iokbC          = $2E;
      iokbV          = $2F;
      iokbB          = $30;
      iokbN          = $31;
      iokbM          = $32;
      iokbFloat      = $33;
      iokbComma      = $34;
      iokbSlash      = $35;
      iokbShiftRight = $36;
      iokbAsterix    = $37;
      iokbAlt        = $38;
      iokbSpaceBar   = $39;
      iokbCapsLock   = $3A;
      iokbF1         = $3B;
      iokbF2         = $3C;
      iokbF3         = $3D;
      iokbF4         = $3E;
      iokbF5         = $3F;
      iokbF6         = $40;
      iokbF7         = $41;
      iokbF8         = $42;
      iokbF9         = $43;
      iokbF10        = $44;
      iokbNumLock    = $45;
      iokbScrollLock = $46;
      iokbHome       = $47;
      iokbUp         = $48;
      iokbPgUp       = $49;
      iokbLeft       = $4B;
      iokbKeypad5    = $4C;
      iokbRight      = $4D;
      iokbPlus       = $4E;
      iokbEnd        = $4F;
      iokbDown       = $50;
      iokbPgDn       = $51;
      iokbIns        = $52;
      iokbDel        = $53;
      iokbSysRq      = $54;
      iokbBackSlash  = $56; { 101/102 touches }
      iokbF11        = $57; { 101/102 touches }
      iokbF12        = $58; { 101/102 touches }
      iokbPA1        = $5A; { 122 touches }
      iokbF13        = $5B; { 122 touches }
      iokbF14        = $5C; { 122 touches }
      iokbF15        = $5D; { 122 touches }
      iokbF16        = $63; { 122 touches }
      iokbF17        = $64; { 122 touches }
      iokbF18        = $65; { 122 touches }
      iokbF19        = $66; { 122 touches }
      iokbF20        = $67; { 122 touches }
      iokbF21        = $68; { 122 touches }
      iokbF22        = $69; { 122 touches }
      iokbF23        = $6A; { 122 touches }
      iokbF24        = $6B; { 122 touches }
      iokbEraseEOF   = $6D; { 122 touches }
      iokbCopyPlay   = $6F; { 122 touches }
      iokbCrSel      = $72; { 122 touches }
      iokbExSel      = $74; { 122 touches }
      iokbClear      = $76; { 122 touches }

      kbNoKey           = $0000;
      kbEsc        	= $011B;
      kbEscape          = kbEsc;
      kbAltSpace   	= $0200;
      kbAltSpc          = kbAltSpace;
      kbCtrl2           = $0300;
      kbCtrlIns    	= $0400;
      kbCtrlInsert      = kbCtrlIns;
      kbShiftIns   	= $0500;
      kbShiftInsert     = kbShiftIns;
      kbCtrlDel    	= $0600;
      kbCtrlDelete      = kbCtrlDel;
      kbShiftDel   	= $0700;
      kbShiftDelete     = kbShiftDel;
      kbAltBKSP    	= $0E00;
      kbAltBackSpace    = kbAltBKSP;
      kbAltBackSpc      = kbAltBKSP;
      kbBack       	= $0E08;
      kbBackSpace  	= kbBack;
      kbBS         	= kbBack;
      kbCtrlBack   	= $0E7F;
      kbCtrlBackSpace   = kbCtrlBack;
      kbCtrlBS          = kbCtrlBack;
      kbShiftTab   	= $0F00;
      kbTab        	= $0F09;
      kbAltQ       	= $1000;
      kbCtrlQ      	= $1011;
      kbAltW       	= $1100;
      kbCtrlW      	= $1117;
      kbAltE       	= $1200;
      kbCtrlE      	= $1205;
      kbAltR       	= $1300;
      kbCtrlR     	= $1312;
      kbAltT       	= $1400;
      kbCtrlT      	= $1414;
      kbAltY       	= $1500;
      kbCtrlY      	= $1519;
      kbAltU       	= $1600;
      kbCtrlU      	= $1615;
      kbAltI       	= $1700;
      kbCtrlI      	= $1809;
      kbAltO       	= $1800;
      kbCtrlO      	= $180F;
      kbAltP       	= $1900;
      kbCtrlP      	= $1910;
      kbCtrlEnter  	= $1C0A;
      kbEnter      	= $1C0D;
      kbAltA       	= $1E00;
      kbCtrlA      	= $1E01;
      kbAltS       	= $1F00;
      kbCtrlS      	= $1F13;
      kbAltD       	= $2000;
      kbCtrlD      	= $2004;
      kbAltF       	= $2100;
      kbCtrlF      	= $2106;
      kbAltG       	= $2200;
      kbCtrlG      	= $2207;
      kbAltH            = $2300;
      kbCtrlH           = $2308;
      kbAltJ       	= $2400;
      kbCtrlJ      	= $240A;
      kbAltK       	= $2500;
      kbCtrlK      	= $250B;
      kbAltL       	= $2600;
      kbCtrlL     	= $260C;
      kbAltZ       	= $2C00;
      kbCtrlZ           = $2C1A;
      kbAltX            = $2D00;
      kbCtrlX           = $2D18;
      kbAltC            = $2E00;
      kbCtrlC           = $2E03;
      kbAltV            = $2F00;
      kbCtrlV           = $2F16;
      kbAltB            = $3000;
      kbCtrlB           = $3002;
      kbAltN            = $3100;
      kbCtrlN           = $310E;
      kbAltM            = $3200;
      kbCtrlM           = $320D;
      kbF1              = $3B00;
      kbF2              = $3C00;
      kbF3         	= $3D00;
      kbF4         	= $3E00;
      kbF5         	= $3F00;
      kbF6         	= $4000;
      kbF7         	= $4100;
      kbF8         	= $4200;
      kbF9         	= $4300;
      kbF10        	= $4400;
      kbHome       	= $4700;
      kbUp         	= $4800;
      kbPgUp       	= $4900;
      kbGrayMinus  	= $4A2D;
      kbLeft       	= $4B00;
      kbKeypad5         = $4C00;
      kbRight      	= $4D00;
      kbGrayPlus   	= $4E2B;
      kbEnd        	= $4F00;
      kbDown       	= $5000;
      kbDn              = kbDown;
      kbPgDn       	= $5100;
      kbPgDown     	= kbPgDn;
      kbIns        	= $5200;
      kbInsert          = kbIns;
      kbDel        	= $5300;
      kbDelete          = kbDel;
      kbShiftF1    	= $5400;
      kbShiftF2    	= $5500;
      kbShiftF3    	= $5600;
      kbShiftF4    	= $5700;
      kbShiftF5    	= $5800;
      kbShiftF6    	= $5900;
      kbShiftF7    	= $5A00;
      kbShiftF8    	= $5B00;
      kbShiftF9    	= $5C00;
      kbShiftF10   	= $5D00;
      kbCtrlF1     	= $5E00;
      kbCtrlF2     	= $5F00;
      kbCtrlF3     	= $6000;
      kbCtrlF4     	= $6100;
      kbCtrlF5     	= $6200;
      kbCtrlF6     	= $6300;
      kbCtrlF7     	= $6400;
      kbCtrlF8     	= $6500;
      kbCtrlF9     	= $6600;
      kbCtrlF10    	= $6700;
      kbAltF1      	= $6800;
      kbAltF2           = $6900;
      kbAltF3      	= $6A00;
      kbAltF4      	= $6B00;
      kbAltF5      	= $6C00;
      kbAltF6           = $6D00;
      kbAltF7           = $6E00;
      kbAltF8           = $6F00;
      kbAltF9           = $7000;
      kbAltF10          = $7100;
      kbCtrlPrtSc       = $7200;
      kbCtrlPrintScrn   = kbCtrlPrtSc;
      kbCtrlPrintScreen = kbCtrlPrtSc;
      kbCtrlLeft   	= $7300;
      kbCtrlRight  	= $7400;
      kbCtrlEnd         = $7500;
      kbCtrlPgDn   	= $7600;
      kbCtrlPgDown      = kbCtrlPgDn;
      kbCtrlPageDn      = kbCtrlPgDn;
      kbCtrlPageDown    = kbCtrlPgDn;
      kbCtrlHome   	= $7700;
      kbAlt1       	= $7800;
      kbAlt2       	= $7900;
      kbAlt3       	= $7A00;
      kbAlt4       	= $7B00;
      kbAlt5       	= $7C00;
      kbAlt6       	= $7D00;
      kbAlt7       	= $7E00;
      kbAlt8       	= $7F00;
      kbAlt9       	= $8000;
      kbAlt0       	= $8100;
      kbAltMinus   	= $8200;
      kbAltEqual   	= $8300;
      kbCtrlPgUp   	= $8400;
      kbCtrlPageUp 	= kbCtrlPgUp;
      kbF11        	= $8500;
      kbF12        	= $8600;
      kbShiftF11        = $8700;
      kbShiftF12   	= $8800;
      kbCtrlF11    	= $8900;
      kbCtrlF12    	= $8A00;
      kbAltF11     	= $8B00;
      kbAltF12     	= $8C00;
      kbCtrlUp    	= $8D00;
      kbCtrlDown   	= $8E00;
      kbCtrlDn          = kbCtrlDown;

       { Code Non Standard d'Isabel }
      kbAltEsc          = $9100;
      kbCtrlEsc         = $911B;
      kbCtrlAltEsc      = $9200;
      kbShiftEsc        = $921B;
      kbUnknown    	= $FFFF;

Var _InitKbd,_BackKbd:Procedure;

Procedure ClrKbd;
Procedure PushKey(K:Word);
Procedure SetCapsLock(X:Bool);
Procedure SetInsMode(X:Bool);
Procedure SetNumLock(X:Bool);
Procedure SetScrollLock(X:Bool);

Function AltCode2ASCII(Code:Word):Char;
Function AltPressed:Bool;
Function ASCII2AltCode(C:Char):Word;
Function CtrlPressed:Bool;
Function GetModeIns:Bool;
Function GetCapsLock:Bool;
Function GetNumLock:Bool;
Function GetScrollLock:Bool;
Function IsAltCode(Code:Word):Bool;
Function IsExtKbd:Bool;
Function IsUpperKey(K:Word):Bool;
Function KeyPressed:Bool;
Function LeftShiftPressed:Bool;
Function NextKey:Word;
Function ReadKey:Word;
Function RightShiftPressed:Bool;
Function ShiftPressed:Bool;

IMPLEMENTATION

Const

      ShiftCode : Array['A'..'Z'] of Byte = (
 30,48,46,32,18,33,34,35,23,36,37,38,50,49,24,25,16,19,31,20,22,47,17,45,21,44);

Function IsAltCode;
Begin
 Case Code of
  kbAltA,kbAltB,kbAltC,kbAltD,kbAltE,kbAltF,
  kbAltG,kbAltH,kbAltI,kbAltJ,kbAltK,kbAltL,
  kbAltM,kbAltN,kbAltO,kbAltP,kbAltQ,kbAltR,
  kbAltS,kbAltT,kbAltU,kbAltV,kbAltW,kbAltX,
  kbAltY,kbAltZ: IsAltCode := True;
  Else IsAltCode := False;
 End;
End;

Function AltCode2ASCII;
Var I:Char; CW:WordRec Absolute Code;
Begin
 AltCode2ASCII := #0;
 If(CW.Lo = 0)Then
 Begin
  For I := 'A' to 'Z' do
  Begin
   If(ShiftCode[I] = CW.Hi)Then
   Begin
    AltCode2ASCII := I;
    Exit;
   End;
  End;
 End;
End;

Function AltPressed;
Assembler;
ASM
 {$IFOPT G+}
  PUSH $0040;
  POP ES;
  MOV AL,ES:[$17];
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
  MOV AL,ES:[$417];
 {$ENDIF}
 AND AL,8;
 JZ @@End;
 MOV AL,Byte(True);
@@End:
END;

Function ASCII2AltCode;
Var CB:Byte Absolute C;
Begin
 If(C in ['a'..'z'])Then Dec(CB,32);
 If Not(C in ['A'..'Z'])Then
 Begin
  ASCII2AltCode := 0;
  Exit;
 End;
 ASCII2AltCode := (ShiftCode[C] shl 8);
End;

Procedure ClrKbd;
Assembler;
ASM
 XOR AX,AX;
 MOV ES,AX;
 CLI;
 MOV AX,ES:[$41C];
 MOV ES:[$41A],AX;
 STI;
END;

Function CtrlPressed;
Assembler;
ASM
 {$IFOPT G+}
  PUSH $0040;
  POP ES;
  MOV AL,ES:[$17];
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
  MOV AL,ES:[$417];
 {$ENDIF}
 AND AL,4;
 JZ @@End;
 MOV AL,Byte(True);
@@End:
END;

Function GetCapsLock;
Assembler;
ASM
 {$IFOPT G+}
  PUSH $0040;
  POP ES;
  MOV AL,ES:[$17];
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
  MOV AL,ES:[$417];
 {$ENDIF}
 AND AL,$40;
 JZ @@End;
 MOV AL,Byte(True);
@@End:
END;

Function GetModeIns;
Assembler;
ASM
 {$IFOPT G+}
  PUSH $0000;
  POP  ES;
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
 {$ENDIF}
 MOV AL,ES:[$0417];
 {$IFOPT G+}
  SHR AL,7;
 {$ELSE}
  ROL AL,1;
  AND AL,1;
 {$ENDIF}
END;

Function GetNumLock;
Assembler;
ASM
 {$IFOPT G+}
  PUSH $0040;
  POP ES;
  MOV AL,ES:[$17];
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
  MOV AL,ES:[$417];
 {$ENDIF}
 AND AL,$20;
 JZ @@End;
 MOV AL,Byte(True);
@@End:
END;

Function GetScrollLock;
Assembler;
ASM
 {$IFOPT G+}
  PUSH $0040;
  POP ES;
  MOV AL,ES:[$17];
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
  MOV AL,ES:[$417];
 {$ENDIF}
 AND AL,$10;
 JZ @@End;
 MOV AL,Byte(True);
@@End:
END;

Function IsExtKbd;
Assembler;
ASM
 {$IFOPT G+}
  PUSH $0040;
  POP ES;
  MOV AL,ES:[$96];
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
  MOV AL,ES:[$496];
 {$ENDIF}
 AND AL,$10;
 JZ @@End;
 MOV AL,Byte(True);
@@End:
END;

Function IsUpperKey;
Begin
 IsUpperKey := (K > $FF);
End;

Function KeyPressed;
Begin
 KeyPressed := Not(MemW[_0040:$001A] = MemW[_0040:$001C]);
End;

Function LeftShiftPressed;
Assembler;
ASM
 {$IFOPT G+}
  PUSH $0040;
  POP ES;
  MOV AL,ES:[$17];
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
  MOV AL,ES:[$417];
 {$ENDIF}
 AND AL,2;
 JZ @@End;
 MOV AL,Byte(True);
@@End:
END;

Function NextKey;
Var K:Word; KByte:Byte Absolute K;
Begin
 If Not(Keypressed)Then NextKey := 0
  Else
 Begin
  CLI;
  K := MemW[_0040:MemW[_0040:$1A]];
  STI;
  If(KByte in [$D0,$E0])Then KByte := 0;
  NextKey := K;
 End;
End;

Procedure PushKey;
Assembler;
ASM
 {$IFOPT G+}
  PUSH $0040;
  POP  ES;
 {$ELSE}
  MOV AX,$0040;
  MOV ES,AX;
 {$ENDIF}
 CLI;
 MOV BX,ES:[$1C];
 MOV AX,K;
 MOV ES:[BX],AX;
 INC BX;
 INC BX;
 MOV ES:[$1C],BX;
 MOV AX,ES:[$82];
 CMP AX,BX;
 JNE @@End;
 MOV ES:[$1C],AX;
@@End:
 STI;
END;

Function ReadKey;
Begin
 _InitKbd;
 Repeat _BackKbd Until Keypressed;
 ASM
  {$IFOPT G+}
   PUSH $0040;
   POP  ES;
  {$ELSE}
   MOV AX,$0040;
   MOV ES,AX;
  {$ENDIF}
  CLI;
  MOV BX,ES:[$1A];
  MOV AX,ES:[BX];
  CMP AL,$E0;
  JE  @@NotOk;
  CMP AL,$D0;
  JNE @@Ok;
@@NotOk:
  MOV AL,0;
@@Ok:
  MOV @Result,AX;
  INC BX;
  INC BX;
  MOV ES:[$1A],BX;
  MOV AX,ES:[$82];
  CMP AX,BX;
  JNE @@End;
  MOV AX,ES:[$80];
  MOV ES:[$1A],AX;
@@End:
  STI;
 END;
End;

Function RightShiftPressed;
Assembler;
ASM
 {$IFOPT G+}
  PUSH $0040;
  POP ES;
  MOV AL,ES:[$17];
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
  MOV AL,ES:[$417];
 {$ENDIF}
 AND AL,1;
END;

Procedure SetCapsLock;
Assembler;
ASM
 XOR AX,AX;
 MOV ES,AX;
 MOV AX,ES:[$417];
 CMP X,Byte(True);
 JE  @@Equal;
 AND AX,$BF;
 JMP @@End;
@@Equal:
 OR AX,$40;
@@End:
 MOV ES:[$417],AX;
END;

Procedure SetInsMode;
Assembler;
ASM
 XOR AX,AX;
 MOV ES,AX;
 MOV AX,ES:[$417];
 CMP X,Byte(True);
 JE  @@Equal;
 AND AX,$7F;
 JMP @@End;
@@Equal:
 OR AX,$80;
@@End:
 MOV ES:[$417],AX;
END;

Procedure SetNumLock;
Assembler;
ASM
 XOR AX,AX;
 MOV ES,AX;
 MOV AX,ES:[$417];
 CMP X,Byte(True);
 JE  @@Equal;
 AND AX,$DF;
 JMP @@End;
@@Equal:
 OR AX,$20;
@@End:
 MOV ES:[$417],AX;
END;

Procedure SetScrollLock;
Assembler;
ASM
 XOR AX,AX;
 MOV ES,AX;
 MOV AX,ES:[$417];
 CMP X,Byte(True);
 JE  @@Equal;
 AND AX,$EF;
 JMP @@End;
@@Equal:
 OR AX,$10;
@@End:
 MOV ES:[$417],AX;
END;

Function ShiftPressed;
Assembler;
ASM
 {$IFOPT G+}
  PUSH $0040;
  POP ES;
  MOV AL,ES:[$17];
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
  MOV AL,ES:[$417];
 {$ENDIF}
 AND AL,3;
 JZ @@End;
 MOV AL,Byte(True);
@@End:
END;

BEGIN { Main Unit }
 _InitKbd := Ret;
 _BackKbd := Ret;
END.