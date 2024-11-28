Unit MalLibrary;

INTERFACE

Var

    YEditor : Byte;

Procedure GetNextWnPos(Var X1,Y1,X2,Y2:Byte);
Procedure GetNextWnMin(L,H:Byte;Var X,Y:Byte);

Function XEditor:Byte;

IMPLEMENTATION

Uses Video;

Function XEditor:Byte;
Begin
 If(ModeInfVid.Graf)Then XEditor := 8 + YEditor
                    Else XEditor := YEditor - 2;
End;

Procedure GetNextWnPos(Var X1,Y1,X2,Y2:Byte);
Begin
 If(MaxYTxts - YEditor > 10)Then Inc(YEditor) Else YEditor := 2;
 X1 := XEditor; Y1 := YEditor; X2 := MaxXTxts; Y2 := MaxYTxts - 2;
End;

Procedure GetNextWnMin(L,H:Byte;Var X,Y:Byte);
Var X1,Y1,X2,Y2 : Byte;
Begin
 GetNextWnPos(X1,Y1,X2,Y2);
 If(X2-X1 < L)Then X := MaxXTxts - L Else X := X1;
 If(Y2-Y1 < H)Then Y := (MaxYTxts - 2) - H Else Y := Y1;
End;

BEGIN
END.