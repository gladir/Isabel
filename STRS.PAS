{⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
 ≥                                                               ≥
 ≥   Malte Genesis/Module de Traitement de Chaåne de Caractäre   ≥
 ≥                  Edition Isabel pour Mode RÇel                ≥
 ≥                        III - Version 1.0                      ≥
 ≥                         1995/02/02                            ≥
 ≥                                                               ≥
 ≥         Copyright (C) par les Chevaliers de Malte             ≥
 ≥                                                               ≥
 ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ}

Unit Strs;

INTERFACE

Uses Math;

Var XCmp:Byte;

Procedure AddStr(Var Output:String;Add:String);
Procedure BackStr(Var Str:String);
Procedure ChgChr(Var Str:String;Search,Replace:Char);
Procedure DelChrAt(Var S:String;P:Byte);
Procedure IncStr(Var Str:String;Chr:Char);
Procedure InsStr(Var S:String;Pos:Byte;Ins:String);
Procedure StrDel(Str:PChar;Start,Len:Word);

Function CenterStr(S:String;Width:Byte):String;
Function ChrUp(Chr:Char):Char;
Function CmpLeft(Str,Cmp:String):Bool;
Function CmpStr(a,b:String):Bool;
Function CopyStr(S:String;Start,Len:Byte):String;
Function DelChr(Str:String;Chr:Char):String;
Function DeleteStr(Str:String;P,N:Byte):String;
Function DelRightSpc(Msg:PChar):PChar;
Function DelAllSpcLeft(Str:String):String;
Function DelAllSpcRight(Str:String):String;
Function HexByte2Str(X:Byte):String;
Function HexWord2Str(X:Word):String;
Function HexLong2Str(X:Long):String;
Function Left(Str:String;Num:Byte):String;
Function LeftJustifyStr(Str:String;Width:Byte):String;
Function MultChar(Value:Char;Len:Byte):String;
Function PadChar(Source:String;Chr:Char;Len:Byte):String;
Function RealStr(X:Real):String;
Function RealStr2(X:Real;LenH,LenL:Byte):String;
Function RightJustifyStr(Str:String;Width:Byte):String;
Function Spc(Len:Byte):String;
Function SpcTab:String;
Function Str(X:Long):String;
Function Str2(X:Long;As:Byte):String;
Function Str0(X:Long;Len:Byte):String;
Function StrI(I:Byte;S:String):Char;
Function StrLength(PChr:PChar):Word;
Function StrUSpc(Str:String;L:Byte):String;
Function StrUp(Str:String):String;
Function Trim(S:String):String;
Function ValL(S:String):Long;
Function ValW(S:String):Word;
Function XCmpLeft(Source,Cmp:String):Bool;
Function Zero(Len:Byte):String;

IMPLEMENTATION

Uses Strings;

Const HexData:Array[0..15] of Char = '0123456789ABCDEF';

Procedure AddStr;
Begin
 Output := Output + Add;
End;

Procedure BackStr;
Var StrLen : Byte Absolute Str;
Begin
 If(StrLen > 0)Then Dec(StrLen);
End;

Function CenterStr;
Var LenStr:Byte Absolute S;
Begin
 CenterStr := StrUSpc(Spc((Width-LenStr) shr 1) + S,Width);
End;

Procedure ChgChr;
Assembler;
ASM
 LES DI,Str;
 XOR DX,DX;
 MOV AL,Replace;
 MOV AH,Search;
 XOR CX,CX;
 MOV CL,ES:[DI];
 JCXZ @@3;
@@1:
 INC DI;
 CMP ES:[DI],AH;
 JNE @@2;
 MOV ES:[DI],AL;
 INC DX;
@@2:
 LOOP @@1;
 OR  DX,DX;
 JNZ @@End;
@@3:
@@End:
END;

Function ChrUp;
Begin
 Case Chr of
  'a'..'z' : ChrUp := Char(Byte(Chr) - 32);
  'Ä','á' : ChrUp := 'C';
  'Å','ñ','ó','ö','£' : ChrUp := 'U';
  'Ç','à','â','ä','ê' : ChrUp := 'E';
  'É','Ñ','Ö','Ü','é','è','†','¶' : ChrUp := 'A';
  'ã','å','ç','°' : ChrUp := 'I';
  'ì','î','ï','ô','¢','ß' : ChrUp := 'O';
  '§','•' : ChrUp := 'N';
  'ò' : ChrUp := 'Y';
  'ë' : ChrUp := 'í';
  Else ChrUp := Chr;
 End;
End;

Function CmpLeft;
Var I:Byte;
Begin
 CmpLeft := False;
 If(Length(Str) < Length(Cmp))Then Exit;
 If(Str[1] <> Cmp[1])Then Exit;
 For I := 2 to Length(Cmp) do
 Begin
  If(Str[I] <> Cmp[I])Then Exit;
 End;
 CmpLeft := True;
End;

Function CmpStr;
Begin
 CmpStr := (a = b);
End;

Function CopyStr;
Begin
 If(Start > Length(S))Then CopyStr := ''
		      Else CopyStr := Copy(S,Start,Len);
End;

Function DelAllSpcLeft;
Var I:Byte;
Begin
 If Not(Str = '')Then
 Begin
  If Not(Str[1] > ' ')Then
  Begin
   I := 2;
   While ((Length(Str) > I)and(Not(Str[I] > ' '))) do Inc(I);
   If(I = Length(Str))Then DelAllSpcLeft := Str[I]
    Else
   DelAllSpcLeft := Copy(Str,I,Length(Str)-I+1);
  End
   Else
  DelAllSpcLeft := Str;
 End
  else
 DelAllSpcLeft := '';
End;

Function DelAllSpcRight;
Var I:Byte; StrLen:Byte Absolute Str;
Begin
 If Not(Str = '')Then
 Begin
  If Not(Str[Length(Str)] > ' ')Then
  Begin
   I := Length(Str);
   While ((I > 1)and(Str[I] <= ' ')) do Dec(I);
   If(I = 0)Then DelAllSpcRight := ''
    Else
   Begin
    StrLen := I;
    DelAllSpcRight := Str;
   End;
  End
   Else
  DelAllSpcRight := Str;
 End
  Else
 DelAllSpcRight := '';
End;

Function DelChr;
Var I:Byte; T:String;
Begin
 T := '';
 For I := 1 to Length(Str) do If Not(Chr = Str[I])Then IncStr(T,Str[I]);
 DelChr := T;
End;

Procedure DelChrAt;
Begin
 If(P = 1)Then S := Copy(S,2,255)
	  Else S := CopyStr(S,1,P-1) + CopyStr(S,P+1,255);
End;

Function DeleteStr;
Var StrLen:Byte Absolute Str;
Begin
 DeleteStr := '';
 If(Str <> '')and(StrLen > 1)Then
 Begin
  If((P + N) > StrLen)Then
  Begin
   StrLen := P - 1; DeleteStr := Str;
  End
   else
  Begin
   Delete(Str,P,N);
   DeleteStr := Str;
  End;
 End;
End;

Function DelRightSpc;
Var L,I:Word;
Begin
 L := StrLen(Msg);
 For I := L-1 downto 0 do
 Begin
  If Not(Msg[I] = ' ')Then
  Begin
   Msg[I+1] := #0; DelRightSpc := Msg;
   Exit;
  End;
 End;
 Msg[0] := #0; DelRightSpc := Msg;
End;

Function HexByte2Str;
Begin
 HexByte2Str := HexData[X shr 4] + HexData[X and 15];
End;

Function HexWord2Str;
Begin
 HexWord2Str := HexData[X shr 12] + HexData[(X shr 8) and 15] +
		HexData[(X shr 4) and 15] + HexData[X and 15];
End;

Function HexLong2Str;
Begin
 HexLong2Str := HexData[(X shr 28) and 15] + HexData[(X shr 24) and 15] +
		HexData[(X shr 20) and 15] + HexData[(X shr 16) and 15] +
		HexData[(X shr 12) and 15] + HexData[(X shr 8) and 15] +
		HexData[(X shr 4) and 15] + HexData[X and 15];
End;

Procedure IncStr;
Begin
 Inc(Str[0]);
 Str[Byte(Str[0])] := Chr;
End;

Procedure InsStr;
Begin
 S := CopyStr(S,1,Pos-1) + Ins + CopyStr(S,Pos,255);
End;

Function Left;
Var StrLen:Byte Absolute Str;
Begin
 StrLen := Num; Left := Str;
End;

Function LeftJustifyStr;
Begin
 LeftJustifyStr := PadChar(Str,' ',Width);
End;

Function MultChar;
Var Str:String; StrLen:Byte Absolute Str;
Begin
 StrLen := Len;
 FillChar(Str[1],Len,Byte(Value));
 MultChar := Str;
End;

Function PadChar;
Var NL:Byte; StrLen:Byte Absolute Source;
Begin
 NL := WhoMin(StrLen,Len); StrLen := Len;
 FillChar(Source[Succ(NL)],Len-NL,Byte(Chr));
 PadChar := Source;
End;

Function RealStr;
Var S:String;
Begin
 System.Str(X,S);
 RealStr := S;
End;

Function RealStr2;
Var S:String;
Begin
 System.Str(X:LenH:LenL,S);
 RealStr2 := S;
End;

Function RightJustifyStr;
Var StrLen:Byte Absolute Str;
Begin
 If(StrLen > Width)Then StrLen := Width;
 RightJustifyStr := LeftJustifyStr('',Width-StrLen) + Str;
End;

Function Spc;
Var S:String;
Begin
 Spc := '';
 If(Len = 0)Then Exit;
 S[0] := Char(Len);
 FillChar(S[1],Len,Byte(' '));
 Spc := S;
End;

Function SpcTab;
Begin
 SpcTab := Spc(8);
End;

Procedure StrDel;
Var SLen:Word;
Begin
 SLen := StrLen(Str);
 If(SLen = 0)Then Exit;
 If(SLen = 1)Then Str[0] := #0
  Else
 Begin
  If Not(Start = SLen)Then Move(Str[Start+Len],Str[Start],SLen-Start);
  Str[SLen] := #0;
 End;
End;

Function Str;
Var S : String;
Begin
 System.Str(X,S);
 Str := S;
End;

Function Str2;
Var S : String;
Begin
 System.Str(X:As,S);
 Str2 := S;
End;

Function Str0;
Var S:String;
Begin
 S := Str(X);
 Str0 := Zero(Len-Length(S)) + S;
End;

Function StrI;
Begin
 If(I > Length(S))Then StrI := #0 Else StrI := S[I];
End;

Function StrLength;
Begin
 If(PChr = NIL)Then StrLength := 0 Else StrLength := Strings.StrLen(PChr);
End;

Function StrUp;
Var I:Byte; StrLen:Byte Absolute Str;
Begin
 For I := 1 to StrLen do Str[I] := ChrUp(Str[I]);
 StrUp := Str;
End;

Function StrUSpc;
Var StrLen:Byte Absolute Str;
Begin
 If(L <= StrLen)Then StrUSpc := Str Else StrUSpc := Str + Spc(L-StrLen);
End;

Function Trim(S:String):String;
Begin
 InLine(
  $1E/                   {         PUSH    DS                ; Save DS}
			 {;}
  $C5/$76/$06/           {         LDS     SI,[BP+6]         ; Get address of S}
  $FC/                   {         CLD                       ; Forward search}
  $AC/                   {         LODSB                     ; Get length of S}
  $3C/$00/               {         CMP     AL,0              ; See if length 0}
  $74/$21/               {         JE      Trim2             ; If so, no trimming required}
			 {;}
  $30/$ED/               {         XOR     CH,CH}
  $88/$C1/               {         MOV     CL,AL             ; Remember length for search loop}
			 {;}
  $B0/$20/               {         MOV     AL,' '            ; Blank to AL}
			 {;}
  $C4/$7E/$06/           {         LES     DI,[BP+6]         ; Get address of S}
  $01/$CF/               {         ADD     DI,CX             ; Point to end of source string}
			 {;}
  $FD/                   {         STD                       ; Backwards search}
  $F3/$AE/               {         REPE    SCASB             ; Scan over blanks}
  $74/$01/               {         JE      Trim1             ; If CX=0, entire string is blank.}
  $41/                   {         INC     CX}
			 {;}
  $88/$C8/               {Trim1:   MOV     AL,CL             ; Length to copy}
  $C5/$76/$06/           {         LDS     SI,[BP+6]         ; Source string address}
  $46/                   {         INC     SI                ; Skip length}
  $C4/$7E/$0A/           {         LES     DI,[BP+10]        ; Result string address}
  $FC/                   {         CLD                       ; Forward move}
  $AA/                   {         STOSB                     ; Set length in result}
  $F2/$A4/               {         REP     MOVSB             ; Move trimmed result}
  $E9/$04/$00/           {         JMP     Exit}
			 {;}
  $C4/$7E/$0A/           {Trim2:   LES     DI,[BP+10]        ; Result string address}
  $AA/                   {         STOSB                     ; Set length=0 in result}
			 {;}
  $1F);                  {Exit:    POP     DS                ; Restore DS}
End;

Function ValL;
Var a:Long; E:Word; I:Byte;

 Function Exp:Long;
 Var J:Byte; b:Long;
 Begin
  b := 1;
  For J := Length(S)-1 downto I do b := b * 10;
  Exp := b;
 End;

Begin
 a := 0;
 For I := Length(S) downto 1 do
 Begin
  Inc(a,(Byte(S[I]) - Byte('0')) * Exp);
 End;
 ValL := a;
End;

Function ValW;
Var a,Err:Word;
Begin
 Val(S,a,Err);
 ValW := a;
End;

Function XCmpLeft(Source,Cmp:String):Bool;
Var Ok:Bool;
Begin
 Ok := CmpLeft(Source,Cmp);
 If(Ok)Then XCmp := Length(Cmp);
 XCmpLeft := Ok;
End;

Function Zero;
Var Str:String; StrLen:Byte Absolute Str;
Begin
 Zero := '';
 If(Len = 0)Then Exit;
 StrLen := Len;
 FillChar(Str[1],Len,Byte('0'));
 Zero := Str;
End;

BEGIN
END.