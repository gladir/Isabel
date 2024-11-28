Unit MalWatch;

INTERFACE

Uses Windows;

Type

     WatchWin = Object
		 Constructor Init(X1,Y1,X2,Y2:Byte);
		 Function Run:Word;
		 Procedure Refresh;
		 Destructor Done;
		 PRIVATE
		 W:Wins;
		End;

IMPLEMENTATION

Uses Keyboard;

Constructor WatchWin.Init(X1,Y1,X2,Y2:Byte);
Begin
End;

Function WatchWin.Run:Word;
Begin
 Run := ReadKey;
End;

Procedure WatchWin.Refresh;
Begin
End;

Destructor WatchWin.Done;
Begin
End;

BEGIN
END.