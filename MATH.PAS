{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³        Malte Genesis/Module de base des Math‚matiques      ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Math;

INTERFACE

{$IFNDEF Debug}
 {$D-,L-,Y-}
{$ENDIF}
{$F+,I-,Q-,R-,S-,X+}

Uses InlineIntel;

Const

       M_E = 2.71828182845904523536;
       M_LOG2E = 1.44269504088896340736;
       M_LOG10E = 0.434294481903251827651;
       M_LN2 = 0.693147180559945309417;
       M_LN10 = 2.30258509299404568402;
       M_PI = 3.14159265358979323846;
       M_PI_2 = 1.57079632679489661923;
       M_PI_4 = 0.785398163397448309616;
       M_1_PI = 0.318309886183790671538;
       M_2_PI = 0.636619772367581343076;
       M_1_SQRTPI = 0.564189583547756286948;
       M_2_SQRTPI = 1.12837916709551257390;
       M_SQRT2 = 1.41421356237309504880;
       M_SQRT_2 = 0.707106781186547524401;

       { Video }

      VBiosSeg = $C000;

       { CPU }

      _i486  = 8;
      _80486 = _i486;
      _i386  = 7;
      _80386 = _i386;
      _80286 = 6;
      _80186 = 5;
      _80188 = 4;
      _v30   = 3;
      _v20   = 2;
      _8086  = 1;
      _8088  = 0;

       { Flags - CPU }

      CarryFlag = 1;
      ParityFlag = 4;
      AuxCarryFlag = 16;
      ZeroFlag = 64;
      SignFlag = 128;

       { Limit }

      ByteMin = 0;
      ByteMax = $FF;

      ShortIntMin = -128;
      ShortIntMax = 127;

      WordMin = 0;
      WordMax = $FFFF;

      IntegerMin = -32768;
      IntegerMax = 32767;

      LongIntMax = 2147483647;

      MaxArray = 65520;

      SizeOfByte = SizeOf(Byte);
      SizeOfWord = SizeOf(Word);

      NULL = 0;

       { Boolean }

      Yes = True;
      No = False;

       { Memory Size }

      _1Kb = 1024;
      _2Kb = 2048;
      _4Kb = 4096;
      _8Kb = 8192;
      _16Kb = 16384;
      _32Kb = 32768;
      _64Kb = 65536;
      _96Kb = 98304;
      _128Kb = 131072;
      _256Kb = 262144;
      _512Kb = 524288;
      _1Mb = 1048576;
      _2Mb = 2097152;
      _4Mb = 4194304;

Type

     RPtr = Record
      Base:Word;
      LoSeg:Byte;
     End;

     Bool = Boolean;
     Int = Integer;
     Long = LongInt;
     LInt = LongInt;

     TBoolean = Array[0..MaxArray] of Boolean;
     TByte = Array[0..MaxArray] of Byte;
     TChar = Array[0..MaxArray] of Char;
     TWord = Array[0..MaxArray div SizeOf(Word)] of Word;
     TLongInt = Array[0..MaxArray div SizeOf(LongInt)] of LongInt;
     TReal = Array[0..MaxArray div SizeOf(Real)] of Real;
     TPChar = Array[0..MaxArray div SizeOf(PChar)] of PChar;
     BString = Array[0..255] of Byte;
     PString = ^String;
     PWord = ^Word;
     PProc = Procedure;
     PChar2 = Array[0..2] of Char;
     PChar3 = Array[0..3] of Char;
     PChar7 = Array[0..7] of Char;
     CharSet = Set of Char;

     Bits32 = LongInt;
     Bits16 = Word;
     Bits8 = Byte;

     XYRec = Record
      X,Y:Byte;
     End;

     WordRec = Record
      Lo,Hi:Byte;
     End;

     IntegerRec = Record
      Lo,Hi:ShortInt;
     End;

     LongRec = Record
      Lo,Hi:Word;
     End;

     PtrRec = Record
      Ofs,Seg:Word;
     End;

     LongIntRec = LongRec;
     LongWordRec = LongRec;

Var
    Up32Bits:Bool;
    CPU:Byte;
    Processor:Byte Absolute CPU;

     { Environnement Sp‚cial d'Isabel }

    Move:Procedure(Var Source,Dest;Count:Word) Absolute $0040:$00D0;
    FillChar:Procedure(Var X;Len:Word;Value:Byte) Absolute $0040:$00D4;

Const

     _0040 = $0040;
     _A000 = $A000;
     _B000 = $B000;
     _B800 = $B800;

Procedure CLI; InLine(__CLI);
Procedure FillBool(Var X;Len:Word;Value:Boolean);
Procedure FillBoolAt(Var X;At,Len:Word;Value:Boolean);
Procedure FillWord(Var X;Len,Value:Word);
Procedure MoveBack(Var Source,Dest;Count:Word);
Procedure Ret;
Procedure RetB(A:Byte);
Procedure RetBBB(A,B,C:Byte);
Procedure RetBBBBB(A,B,C,D,E:Byte);
Procedure RetBBCB(A,B:Byte;C:Char;D:Byte);
Procedure RetBBS(A,B:Byte;C:String);
Procedure RetIIW(A,B:Integer;C:Word);
Procedure RetIIIIW(A,B,C,D:Integer;E:Word);
Procedure RetWWBB(A,B:Word;C,D:Byte);
Procedure RetWWBBB(A,B:Word;C,D,E:Byte);
Procedure RetWWCB(A,B:Word;C:Char;D:Byte);
Procedure STI; InLine(__STI);
Procedure SwapByte(Var a,b:Byte);
Procedure SwapInt(Var a,b:Integer);
Procedure SwapWord(Var a,b:Word);

Function AbsInt(I:Int):Int;
Function AddrExt2Conv(Addr:Pointer):Long;
Function AddrRPtr2Ext(X:RPtr):Pointer;
Function Compare(Var Source,Dest;Len:Word):Bool;
Function DivL(a,b:Long):Long;
Function GetProcessor:Byte;
Function MinByte(N,Max:Byte):Byte;
Function MaxByte(N,Max:Byte):Byte;
Function Mem2Str(Var Addr;Len:Byte):String;
Function MemJmp2Str(Var Addr;Jmp,Num:Byte):String;
Function ModW(a,b:Word):Word;
Function ReadRom(Seg,Ofs:Word;Len:Byte):String;
Function RetBB_B(a,b:Byte):Byte;
Function RetBB_W(a,b:Byte):Word;
Function RetII_W(a,b:Integer):Word;
Function VBiosAreaColor:Bool;
Function VReadRom(Ofs:Word;Len:Byte):String;
Function WhoMax(a,b:Long):Long;
Function WhoMin(a,b:Long):Long;

IMPLEMENTATION

{ Pr‚d‚finition : FillChar }
Procedure FillChar86(Var X;Len:Word;Value:Byte); Forward;
Procedure FillChar88(Var X;Len:Word;Value:Byte);Forward;
Procedure FillChar386(Var X;Len:Word;Value:Byte); Forward;
{ Pr‚d‚finition : Move }
Procedure Move86(Var Source,Dest;Count:Word); Forward;
Procedure Move88(Var Source,Dest;Count:Word); Forward;
Procedure Move386(Var Source,Dest;Count:Word); Forward;

Type

     BankFuncRec = Record
      Move:Procedure(Var Source,Dest;Count:Word);
      FillChar:Procedure(Var X;Len:Word;Value:Byte);
     End;

Var

    BankFunc : BankFuncRec Absolute Move;

Const

      Func : Array[0..8] of BankFuncRec = (
       (Move:Move386;FillChar:FillChar386),{ 80486 }
       (Move:Move386;FillChar:FillChar386),{ 80386 }
       (Move:Move86; FillChar:FillChar86), { 80286 }
       (Move:Move86; FillChar:FillChar86), { 80186 }
       (Move:Move88; FillChar:FillChar88), { 80188 }
       (Move:Move86; FillChar:FillChar86), { v30   }
       (Move:Move88; FillChar:FillChar88), { v20   }
       (Move:Move86; FillChar:FillChar86), { 8086  }
       (Move:Move88; FillChar:FillChar86));{ 8088  }

Function AbsInt;
Assembler;
ASM
 MOV AX,I;
 OR  AX,AX;
 JGE @@End;
 NEG AX;
@@End:
END;

Function AddrExt2Conv;
Begin
 AddrExt2Conv := Long(PtrRec(Addr).Seg) shl 4 + PtrRec(Addr).Ofs;
End;

Function AddrRPtr2Ext;
Begin
 AddrRPtr2Ext := Ptr((X.LoSeg shl 12),X.Base);
End;

Function Compare;
Assembler;
ASM
 MOV CX,Len;
 JCXZ @@0;
 LDS SI,Source;
 LES DI,Dest;
 CLD;
 REPZ CMPSB;
 JZ  @@0;
 MOV CL,1;
@@0:
 MOV AL,CL;
 XOR AL,1;
END;

Function DivL(a,b:Long):Long;
Begin
 If(a = 0)or(b = 0)Then DivL := 0 Else DivL := Long(Long(a) div Long(b));
End;

Procedure FillBoolAt;
Var VX,EB:Byte; W:Word; XB:TByte Absolute X; AtHi:Word;
Begin
 If(At = 0)Then FillBool(X,Len,Value)
  Else
 Begin
  AtHi := At div 8; At := At and 7; W := (Len shr 3) + 1;
  If(Value)Then XB[0] := XB[0] or ($FF shl At)
	   Else XB[0] := XB[0] and Not($FF shr At);
  FillBool(XB[1+AtHi],Len-At,Value);
 End;
End;

Procedure FillBool;
Var VX,EB:Byte; W:Word; XB:TByte Absolute X;
Begin
 VX := Byte(Value) * $FF;
 FillChar(X,Len shr 3,VX);
 EB := Len and 7;
 If(EB > 0)Then
 Begin
  W := (Len shr 3) + 1;
  If(Value)Then XB[W] := XB[W] or ($FF shr (8-EB))
	   Else XB[W] := XB[W] and Not($FF shr (8-EB));
 End;
End;

Procedure FillChar88(Var X;Len:Word;Value:Byte);
Assembler;
ASM
 CLD;
 LES DI,X;
 MOV CX,Len;
 MOV AL,Value;
 REP STOSB;
END;

Procedure FillChar86(Var X;Len:Word;Value:Byte);
Assembler;
ASM
 CLD;
 LES DI,X;
 MOV CX,Len;
 MOV AL,Value;
 MOV AH,AL;
 SHR CX,1;
 REP STOSW;
 ADC CX,CX;
 REP STOSB;
END;

Procedure FillChar386(Var X;Len:Word;Value:Byte);
Assembler;
ASM
 CLD;
 LES DI,X;
 MOV CX,Len;
 MOV AL,Value;
 MOV AH,AL;
 DB  __PUSH_AX, __PUSH_AX;
 DW  __POP__EAX;
 MOV BX,CX;
 AND BX,3;
 {$IFOPT G+}
  SHR CX,2;
 {$ELSE}
  DB $C1,$E9,$02;
 {$ENDIF}
 DB  __REP; DW __STOSD;
 MOV CX,BX;
 REP STOSB;
END;

Procedure FillWord(Var X;Len,Value:Word);
Assembler;
ASM
 CLD;
 LES DI,X;
 MOV CX,Len;
 MOV AX,Value;
 REP STOSW;
END;

Function GetProcessor;
Assembler;
ASM
 PUSHF;
 XOR AX,AX;
 PUSH AX;
 POPF;
 PUSHF;
 POP AX;
 AND AX,$F000;
 CMP AX,$F000;
 JE  @@inferieur286;
 MOV  DL,_80286;
 MOV  AX,$7000;
 PUSH AX;
 POPF;
 PUSHF;
 POP AX;
 AND AX,$7000;
 JE  @@pfin
 INC DL;
 CLI;
 DB $66,$8B,0DCh         { MOV    EBX,ESP;     }
 DB $66,$83,0E4h,0FCh    { AND    ESP,$FFFC;   }
 DB $66,$9C              { PUSHFD;             }
 DB $66,$58              { POP    EAX;         }
 DB $66,$8B,0C8h         { MOV    ECX,EAX;     }
 DB $66,$35,000h,0h,4h,0h{ XOR    EAX,1 shl 18 }
 DB $66,$50              { PUSH   EAX;         }
 DB $66,$9D              { POPFD;              }
 DB $66,$9C              { PUSHFD;             }
 DB $66,$58              { POP    EAX;         }
 DB $66,$51              { PUSH   ECX;         }
 DB $66,$9D              { POPFD;              }
 DB $66,$33,0C1h         { XOR    EAX,ECX;     }
 DB $66,$C1,0E8h,012h    { SHR    EAX,18;      }
 DB $66,$83,0E0h,001h    { AND    EAX,1h       }
 DB $66,$8B,0E3h         { MOV    ESP,EBX      }
 STI;
 ADD dl,al;
 JMP @@pfin;
@@inferieur286:
 MOV DL,_80188;
 MOV AL,$FF;
 MOV CL,$21;
 SHR AL,CL;
 JNE @@t88_86;
 MOV DL,_v20;
 STI;
 MOV SI,0;
 MOV CX,$FFFF;
 DB  $F3,$26,$AC;
 OR  CX,CX;
 JE  @@t88_86;
 MOV DL,_8088;
@@t88_86:
 PUSH CX;
 POP  ES;
 STD;
 MOV DI,Offset @@q2_end;
 MOV AL,$FB;
 MOV CX,3;
 CLI;
 REP STOSB;
 CLD;
 NOP;
 NOP;
 NOP;
 INC DX;
 NOP;
@@q2_end:
 STI;
@@pfin:
 POPF;
 XOR DH,DH;
 MOV AX,DX;
@@End:
END;

Function MaxByte;
Begin
 If(N < Max)Then MaxByte := N + 1 Else MaxByte := 0;
End;

Function Mem2Str;
Var S:String; SLen:Byte Absolute S;
Begin
 SLen := Len;
 Move(Addr,S[1],Len);
 Mem2Str := S;
End;

Function MemJmp2Str;
Var X:Array[0..255] of Char Absolute Addr; S:String;
    SLen:Byte Absolute S; I:Byte;
Begin
 SLen := Num;
 For I := 1 to Num do S[I] := X[(I-1)*Jmp];
 MemJmp2Str := S;
End;

Function MinByte;
Begin
 If(N > 0)Then MinByte := N-1 Else MinByte := Max;
End;

Function ModW(a,b:Word):Word;
Begin
 If(a = 0)or(b = 0)Then ModW := 0
		   Else ModW := a mod b;
End;

Procedure Move88(Var Source,Dest;Count:Word);
Assembler;
ASM
 CLD;
 PUSH DS;
  LDS SI,Source;
  LES DI,Dest;
  MOV CX,Count;
  REP MOVSB;
 POP DS;
END;

Procedure Move86(Var Source,Dest;Count:Word);
Assembler;
ASM
 CLD;
 PUSH DS;
  LDS SI,Source;
  LES DI,Dest;
  MOV CX,Count;
  SHR CX,1;
  REP MOVSW;
  ADC CX,CX;
  REP MOVSB;
 POP DS;
END;

Procedure Move386(Var Source,Dest;Count:Word);
Assembler;
ASM
 CLD;
 PUSH DS;
  LDS SI,Source;
  LES DI,Dest;
  MOV CX,Count;
  MOV BX,CX;
  AND BX,3;
  {$IFOPT G+}
   SHR CX,2;
  {$ELSE}
   DB $C1,$E9,$02;
  {$ENDIF}
  DB  __REP; DW __MOVSD;
  MOV CX,BX;
  REP MOVSB;
 POP  DS;
END;

Procedure MoveBack;
Assembler;
ASM
 STD;
 PUSH DS;
  LDS SI,Source;
  LES DI,Dest;
  MOV CX,Count;
  ADD SI,CX;
  SUB SI,2;
  ADD DI,CX;
  SUB DI,2;
  SHR CX,1;
  REP MOVSW;
  ADC CX,CX;
  REP MOVSB;
@@End:
 POP  DS;
END;

Function ReadROM;
Var S:String; SLen:Byte Absolute S;
Begin
 SLen := Len;
 Move(Mem[Seg:Ofs],S[1],Len);
 ReadROM := S;
End;

Procedure Ret;
Begin
End;

Procedure RetB;
Begin
End;

Procedure RetBBB;
Begin
End;

Procedure RetBBBBB;
Begin
End;

Procedure RetBBS;
Begin
End;

Procedure RetBBCB;
Begin
End;

Function RetBB_B;
Begin
End;

Function RetBB_W;
Begin
End;

Procedure RetIIW;
Begin
End;

Procedure RetIIIIW;
Begin
End;

Function RetII_W;
Begin
End;

Procedure RetWWBB;
Begin
End;

Procedure RetWWBBB;
Begin
End;

Procedure RetWWCB;
Begin
End;

Procedure SwapByte;
Var c:Byte;
Begin
 c := a; a := b; b := c;
End;

Procedure SwapInt;
Var c:Int;
Begin
 c := b; b := a; a := c;
End;

Procedure SwapWord;
Assembler;
ASM
 PUSH DS;
  LES  DI,A;
  LDS  SI,B;
  MOV  AX,ES:[DI];
  XCHG AX,DS:[SI];
  MOV  ES:[DI],AX;
 POP DS;
END;

Function VBiosAreaColor;
Begin
 VBiosAreaColor := (MemW[_0040:$63] = $3D4);
End;

Function VReadRom;
Begin
 VReadRom := ReadRom(VBiosSeg,Ofs,Len);
End;

Function WhoMax;
Begin
 If(a >= b)Then WhoMax := a Else WhoMax := b;
End;

Function WhoMin;
Begin
 If(a <= b)Then WhoMin := a Else WhoMin := b;
End;

BEGIN { Main Unit }
 Processor := GetProcessor;
 Up32Bits  := (Processor > _80286);
 BankFunc  := Func[Processor];
END.