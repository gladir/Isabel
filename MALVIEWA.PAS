Unit MalViewAscii;

INTERFACE

Uses Windows;

Type

     ViewAsciiWin = Object
                     Constructor Init(X1,Y1,X2,Y2:Byte);
                     Function Run:Word;
                     Procedure Refresh;
                     Destructor Done;
                     PRIVATE
                     W:Wins;
                    End;

IMPLEMENTATION

Uses Keyboard;

Constructor ViewAsciiWin.Init(X1,Y1,X2,Y2:Byte);
Begin
End;

Function ViewAsciiWin.Run:Word;
Begin
 Run := W.Readk;
End;

Procedure ViewAsciiWin.Refresh;
Begin
End;

Destructor ViewAsciiWin.Done;
Begin
End;

BEGIN
END.