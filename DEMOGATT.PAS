Uses Strs;

Const PChr:PChar = 'ABCDEFGHIJKLMN'+#6+'OPQRSTUVWXYZ';
Var PChrT:Array[0..1024] of Char;

Procedure SetGattAttr(PChr:PChar;Var PChrT:Array of Char;P,L:Word;Attr:Byte);
Var I,J,K,Len:Word;
Begin
 Len := StrLength(PChr);
 If(Len = 0)Then Exit;
 J := 0;
 For I := 0 to (P - 1) do
 Case PChr[J] of
       #0: Begin
	    Move(PChr^,PChrT,Len+1);
	    Exit;
	   End;
  #1..#31: Inc(J,2)
      Else Inc(J);
 End;
 K := J;
 Move(PChr^,PChrT,J);
 For I := P to (P + L - 1) do
 Case PChr[J] of
  #0:
  Begin
   PChrT[K] := #0;
   Exit;
  End;
  ' ':
  Begin
   PChrT[K] := '_'; Inc(J); Inc(K);
  End;
  #1..#31:
  Begin
   PChrT[K] := Char(Attr); PChrT[K+1] := PChr[J+1];
   Inc(J,2); Inc(K,2);
  End;
  Else
  Begin
   PChrT[K] := Char(Attr); PChrT[K+1] := PChr[J];
   Inc(J); Inc(K,2);
  End;
 End;
 Move(PChr[J],PChrT[K],Len-J+1);
End;

BEGIN
 FillChar(PChrT,SizeOf(PChrT),$FF);
 WriteLn(PChr);
 SetGattAttr(PChr,PChrT,25,256,20);
 WriteLn(PChrT);
END.