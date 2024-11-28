Unit MalJournal;

INTERFACE

Uses Editor;

Type

     PersJrnl = Object(Edt)
		 Constructor Init(X1,Y1,X2,Y2:Byte);
		 Function Run:Word;
		 Destructor Done;
		End;

IMPLEMENTATION

Uses Dos,Strs,Volume,Keyboard,MLibrary;

Constructor PersJrnl.Init(X1,Y1,X2,Y2:Byte);
Var Year,Month,Day,WeekDay : Word;
Begin
 GetDate(Year,Month,Day,WeekDay);
 Inherited InitPJ(X1,Y1,X2,Y2,Str(Year)+'-'+Str0(Month,2)+'-'+Str0(Day,2));
End;

Function PersJrnl.Run:Word;
Begin
 Run := Inherited Run;
End;

Destructor PersJrnl.Done;
Begin
 Inherited Done;
End;

BEGIN
END.