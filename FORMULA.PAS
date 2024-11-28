Var a,b : Word;

Const O : Array[0..3] of Char = '*/+-';

Function Formula(S:String):LongInt;
Var H,I,J   : Byte;
    a,b     : LongInt;
    Err     : Word;
    aS,bS,T : String;
Begin
 Formula := 0;
 If(S = '')Then Exit;
 For H := 0 to 3 do While (Pos(O[H],S) > 0) do
 Begin
  J := 1;
  For I := 1 to Length(S) do
  Begin
   If(S[I] = O[H])Then
   Begin
    aS := Copy(S,J,I-J);
    Inc(I);
    bS := '';
    While (S[I] in ['0'..'9']) do
    Begin
     bS := bS + S[I];
     Inc(I);
     If(I > Length(S))Then Break;
    End;
    Val(aS,a,Err);
    Val(bS,b,Err);
    Case H of
     0 : Str(LongInt(a)*LongInt(b),T);
     1 : Str(LongInt(a) div LongInt(b),T);
     2 : Str(LongInt(a) + LongInt(b),T);
     3 : Str(LongInt(a) - LongInt(b),T);
    End;
    S := Copy(S,1,J-1) + T + Copy(S,I,255);
    Break;
   End
    Else
   If Not(S[I] in ['0'..'9'])Then J := I + 1;
  End;
 End;
 Val(S,a,Err);
 Formula := a;
End;

Function FormulaReal(S:String):Real;
Var H,I,J   : Byte;
    a,b     : Real;
    Err     : Word;
    aS,bS,T : String;
Begin
 FormulaReal := 0.0;
 If(S = '')Then Exit;
 For H := 0 to 3 do While (Pos(O[H],S) > 0) do
 Begin
  J := 1;
  For I := 1 to Length(S) do
  Begin
   If(S[I] = O[H])Then
   Begin
    aS := Copy(S,J,I-J);
    Inc(I);
    bS := '';
    While (S[I] in ['0'..'9','.','E']) do
    Begin
     bS := bS + S[I];
     Inc(I);
     If(I > Length(S))Then Break;
    End;
    Val(aS,a,Err);
    Val(bS,b,Err);
    Case H of
     0 : Str(a * b:1:38,T);
     1 : Str(a / b:1:38,T);
     2 : Str(a + b:1:38,T);
     3 : Str(a - b:1:38,T);
    End;
    S := Copy(S,1,J-1) + T + Copy(S,I,255);
    Break;
   End
    Else
   If Not(S[I] in ['0'..'9','.','E'])Then J := I + 1;
  End;
 End;
 Val(S,a,Err);
 FormulaReal := a;
End;

BEGIN
 WriteLn(FormulaReal('9.3*9.1+9.0625*9.67/3.34*3+7.8'));
END.