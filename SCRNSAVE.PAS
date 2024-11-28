Unit ScrnSaver;

INTERFACE

Uses Math;

Var ActifScrSave:Bool;

Procedure InitKbd;
Procedure BackKbd;
Procedure ScrnSaverStar;

IMPLEMENTATION

Uses Keyboard,Memorys,Video,Spooler;

Var N,T,Sec:Word; Old:Byte; OldBackKbd:Procedure;

Procedure InitKbd;
Begin
 T := Sec * 18; N := 0; Old := Mem[$0040:$6C];
End;

Procedure BackKbd;
Var Curr:Byte;
Begin
 OldBackKbd;
 Curr := Mem[$0040:$6C];
 If(Old <> Curr)Then
 Begin
  Old := Curr;
  Inc(N);
  If(N >= T)Then
  Begin
   If(IVid.Graf)and(ActifScrSave)Then ScrnSaverStar;
   InitKbd;
  End;
 End;
End;

Procedure ScrnSaverStar;
Var Etoiles:Array[0..500] of Record x,y,Plan:Integer; End;
    I:Word; M:MemSwp;
Begin
 Randomize;
 PushScr(M);
 ClearScreenBlack;
 Repeat
  TaskSpooler;
  For I:=0 to 500 do
  Begin
   With Etoiles[I] do
   Begin
    SetPixel(x,y,0);
    Dec(x,Plan shr 5 + 1);
    If(x <= 0)Then
    Begin
     x:=GetMaxXPixels;
     y:=Random(GetMaxYPixels);
     Plan:=Random(256);
    End;
    SetPixel(x,y,Plan shr 4 + 16);
   End;
  End;
 Until KeyPressed;
 PopScr(M);
End;

BEGIN
 Sec := 60; _InitKbd := InitKbd; OldBackKbd := _BackKbd;
 _BackKbd := BackKbd; ActifScrSave := True;
END.