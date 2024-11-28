(********************************************************)
(*                                                      *)
(*         Malte Genesis/Commodore 64 Emulator          *)
(*   Phoenix Edition for Real Mode & Protected Mode     *)
(*                  II - Version 1.8                    *)
(*                     1994/12/29                       *)
(*                                                      *)
(*      Copyiright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit CK64;

INTERFACE

Uses Video,Windows,Terminal,Memorys,Mems;

Type

     CK64Emul = Object
      Constructor Init(X,Y:Byte);
      Procedure Refresh;
      Function Run:Word;
      Destructor Done;
      PRIVATE
      W:Ansi;
      Scr:Wins;
      List:RBuf;
     End;

IMPLEMENTATION

Uses Strs,Keyboard,Cursor,Dials,Emulator;

Constructor CK64Emul.Init;
Var Colrs : MtxColors;
Begin
 List.Init;
 W.Init(X,Y,X+41,Y+25);
 W.PushWn;
 Colrs := CurrColors.Dialog.Wins; Colrs.Border := $91;
 W.PutWn('Emulateur Commodore 64',Colrs);
 W.SetKr($19);
 W.ClrScr;
 W.PutTxtLn('    **** COMMODORE 64 BASIC V2 ****');
 W.Ln;
 W.PutTxtLn('64K RAM SYSTEM 38911 BASIC BYTES FREE');
 W.Ln;
 W.PutTxtLn('READY');
 If(GetShade)Then Scr.Init(W.RX1,W.RY1,W.RX2-2,W.RY2-1)
	     Else Scr.Init(W.RX1,W.RY1,W.RX2,W.RY2);
 Scr.PushWn;
End;

Procedure CK64Emul.Refresh;
Begin
 Scr.PopWn;
End;

Function CK64Emul.Run;
Var K : Word;
Begin
 PushCursor;
 CursorBlock(W.GetRealX,W.GetRealY);
 PopCursor;
 K := ReadKey;
 Scr.PushWn; Run := K;
End;

Destructor CK64Emul.Done;
Begin
 Scr.Done; List.Done; W.Done;
End;

BEGIN
END.