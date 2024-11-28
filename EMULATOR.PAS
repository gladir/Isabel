(********************************************************)
(*                                                      *)
(*                 Malte Genesis/Emulator               *)
(*   Phoenix Edition for Real Mode & Protected Mode     *)
(*                   II - Version 1.8                   *)
(*                      1994/12/29                      *)
(*                                                      *)
(*      Copyiright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit Emulator;

INTERFACE

Uses Math;

Var FormulaErr : String[31];

Procedure CursorBlock(X,Y:Byte);

Function Formula(S:String;Var Ok:Bool):Long;
Function FormulaReal(S:String):Real;

IMPLEMENTATION

Uses Strs,Video,Keyboard;

Const O:Array[0..8] of Char = '^*/\%+-ï|';

Function Formula;
Var H,I,J:Byte; a,b,L:Long; Err:Word; aS,bS,T:String;
Begin
 Ok := True; Formula := 0;
 If(S = '')Then Exit;
 For H := 0 to 8 do While (Pos(O[H],S) > 0) do
 Begin
  J := 1;
  For I := 1 to Length(S) do
  Begin
   If(S[I] = O[H])Then
   Begin
    aS := Copy(S,J,I-J);
    If(StrI(1,aS) = '_')Then as[1] := '-';
    Val(aS,a,Err); Inc(I); bS := '';
    If(StrI(I,S) in ['-','_'])Then
    Begin
     Inc(I); IncStr(bs,'-');
    End;
    While (S[I] in ['0'..'9']) do
    Begin
     IncStr(bS,S[I]);
     Inc(I);
     If(I > Length(S))Then Break;
    End;
    Val(bS,b,Err);
    If(a = 0)and(aS <> '0')Then Ok := False Else
    If(b = 0)and(bS <> '0')Then Ok := False
     Else
    Case H of
     0 : L := Trunc(a*Exp(b));
     1 : Begin
	  L := Long(a) * Long(b);
	  If((a or b) <> 0)and(L = 0)Then Ok := False;
	 End;
     2 : Begin
	  L := Long(a) div Long(b);
	  If((Long(a) Mod Long(b)) <> 0)Then Ok := False;
	 End;
     3 : L := Long(a) div Long(b);
     4 : L := Long(a) Mod Long(b);
     5 : Begin
	  L := Long(a) + Long(b);
	  If(L = 0)and((Long(a) or Long(b)) <> 0)Then Ok := False;
	 End;
     6 : L := Long(a) - Long(b);
     7 : L := Long(a) and Long(b);
     8 : L := Long(a) or Long(b);
    End;
    If Not(Ok)Then Exit;
    System.Str(L,T);
    If(StrI(1,T) = '-')Then T[1] := '_';
    S := Copy(S,1,J-1) + T + Copy(S,I,255);
    Break;
   End
    Else
   If Not(S[I] in ['_','0'..'9'])Then J := I + 1;
  End;
 End;
 ChgChr(S,'_','-'); Val(S,a,Err);
 Ok := Not((a = 0)and(Length(S) > 4));
 Formula := a;
End;

Function FormulaReal(S:String):Real;
Var H,I,J,L:Byte; a,b,R:Real; Err:Word; aS,bS,T:String;
Begin
 FormulaReal := 0.0; FormulaErr := '';
 If(S = '')Then Exit;
 For H := 0 to 6 do While (Pos(O[H],S) > 0) do
 Begin
  J := 1;
  For I := 1 to Length(S) do
  Begin
   If(S[I] = O[H])Then
   Begin
    If(StrI(1,aS) = '_')Then as[1] := '-';
    aS := Copy(S,J,I-J); Inc(I); bS := '';
    If((StrI(I,S) in ['-','_']))Then
    Begin
     Inc(I); IncStr(bs,'-');
    End;
    While (StrI(I,S) in ['0'..'9','.']) do
    Begin
     IncStr(bS,S[I]); Inc(I);
    End;
    If(StrI(I,S) = 'E')and(StrI(I+1,S) in ['-','+'])Then
    Begin
     IncStr(bs,S[I]); Inc(I); IncStr(bs,S[I]); Inc(I);
     While (StrI(I,S) in ['0'..'9']) do
     Begin
      IncStr(bs,S[I]); Inc(I);
     End;
    End;
    Val(aS,a,Err); Val(bS,b,Err);
    Case H of
     0 : R := a * Exp(b);
     1 : R := a * b;
     2 : If(a = 0)Then
	 Begin
	  FormulaErr := '/0';
	  Exit;
	 End
	  Else
	 R := a / b;
     3 : R := Trunc(a / b);
     4 : R := Trunc(a) Mod Trunc(b);
     5 : R := a + b;
     6 : R := a - b;
     7 : L := Trunc(a) and Trunc(b);
     8 : L := Trunc(a) or Trunc(b);
    End;
    System.Str(R,T);
    Val(Copy(T,Length(T)-4,4),L,Err);
    Inc(L,Length(T)-Pos('.',T));
    If(Frac(R) = 0.0)Then System.Str(R:0:0,T)
		     Else System.Str(R:0:L-2,T);
    If(StrI(1,T) = '-')Then T[1] := '_';
    S := Copy(S,1,J-1) + T + Copy(S,I,255);
    Break;
   End
    Else
   If Not(S[I] in ['_','0'..'9','.','E'])Then
   Begin
    If(StrI(I-1,S) = 'E')and(S[I] in ['-','+'])Then
    Begin
     While (StrI(I,S) in ['0'..'9']) do Inc(I);
    End;
    J := I + 1;
   End;
  End;
 End;
 ChgChr(S,'_','-');
 Val(S,a,Err);
 FormulaReal := a;
End;

Procedure CursorBlock(X,Y:Byte);
Var Cube:Word;
Begin
 Cube := GetCube(X,Y);
 Repeat
  Case Mem[_0040:$6C] and $F of
   0 : If(Char(Cube) in [#0,' ',#255])Then SetChar(X,Y,'Û')
				      Else SetChar(X,Y,' ');
   8 : SetChar(X,Y,Char(Cube));
  End;
 Until Keypressed;
 SetChar(X,Y,Char(Cube));
End;

BEGIN
END.