(********************************************************)
(*                                                      *)
(*            Malte Genesis/Apple II Emulator           *)
(*   Phoenix Edition for Real Mode & Protected Mode     *)
(*                   II - Version 1.8                   *)
(*                      1994/12/29                      *)
(*                                                      *)
(*      Copyiright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit AppleII;

INTERFACE

Uses Math,Images,Video,Windows,Terminal,Memorys,Mems;

Type

     AppleII2Emul = Object
      Constructor Init(X,Y:Byte);
      Function Run:Word;
      Procedure Refresh;
      Destructor Done;
      PRIVATE
      W,Scr:Wins;
      Underline,Blink,Brk,RunErr,OnBrk:Bool;
      LnErr,LnBrk,OnBrkLn,_Goto:Word;
      List,Variable,HBuff:RBuf;
      Graf:WnImg;
      Err,TxtMode,PMode,HighMode:Byte;
      Procedure Ln;
      Procedure PutTxt(S:String);
      Procedure PutTxtLn(S:String);
      Procedure ClrScr;
      Procedure SetPlace(Num:Word;S:String);
     End;

IMPLEMENTATION

Uses Strs,Clock,Strings,Language,Keyboard,Cursor,MLibrary,Dials,Systems,Emulator;

Constructor AppleII2Emul.Init;
Begin
 Brk := False;
 List.Init;
 Variable.Init;
 W.Init(X,Y,X+42,Y+26);
 W.PushWn;
 W.PutWn('Emulateur Apple II',CurrColors.Dialog.Wins);
 W.SetKr($F);
 W.ClrScr;
 W.PutOTxt('APPLE ][');
 Beep;
 Delay(2000);
 W.ClrScr;
 W.SetY(22);
 W.PutTxtLn(']');
 W.Ln;
 W.PutTxt(']');
End;

Procedure AppleII2Emul.Ln;
Begin
 W._Ln;
End;

Procedure AppleII2Emul.PutTxt;
Var I:Int;
Begin
 If(Length(S)+W.RX > W.MaxXTxts+1)Then
 Begin
  I := 1;
  While (I <= Length(S)) do
  Begin
   W.PutTxt(Copy(S,I,W.MaxXTxts+1));
   Inc(I,W.MaxXTxts+1);
   If(I <= Length(S))Then Ln;
  End;
 End
  Else
 W.PutTxt(S);
End;

Procedure AppleII2Emul.PutTxtLn;
Begin
 PutTxt(S);
 Ln;
End;

Procedure AppleII2Emul.ClrScr;
Begin
 W.ClrScr;
End;

Procedure AppleII2Emul.SetPlace;
Var I,NB:Word; Ptr:^PCharWordRec;
Begin
 NB := List.NmBuf;
 If(NB = 1)Then
 Begin
  Ptr := List._GetBuf(0);
  If(Ptr^.Nm > Num)Then List.InsStrWord(0,S,Num) Else
  If(Ptr^.Nm = Num)Then
  Begin
   List.DelBuf(0);
   If(S <> '')Then List.AddStrWord(S,Num);
  End
   Else
  List.AddStrWord(S,Num);
 End
  Else
 Begin
  For I := 0 to List.MaxBuf do
  Begin
   Ptr := List._GetBuf(I);
   If(Ptr^.Nm = Num)Then
   Begin
    List.DelBuf(I);
    If(S <> '')Then List.InsStrWord(I,S,Num);
    Exit;
   End;
   If(Ptr^.Nm > Num)Then
   Begin
    List.InsStrWord(I,S,Num);
    Exit;
   End;
  End;
  List.AddStrWord(S,Num);
 End;
End;

Function AppleII2Emul.Run;
Var Input,Num:String; K,L,LErr:Word; I:Byte; Chr:Char Absolute K; C:Char;
Begin
 Input := '';
 Repeat
  W.SetCurPos(W.RX,W.RY);
  PushCursor;
  CursorBlock(W.GetRealX,W.GetRealY);
  PopCursor;
  K := W.Readk;
  Case K of
   kbEnter :
   Begin
    RunErr := False; OnBrk := False; OnBrkLn := $FFFF; _Goto := $FFFF;
    Ln;
    Input := DelAllSpcRight(DelAllSpcLeft(Input));
    If(Input <> '')Then
    Begin
     If(Input[1] in ['0'..'9'])Then
     Begin
      Num := ''; I := 1;
      While(StrI(I,Input) in ['0'..'9'])do
      Begin
       IncStr(Num,Input[I]); Inc(I);
      End;
      Val(Num,L,LErr);
      Input := DelAllSpcLeft(Copy(Input,I,255));
      If(List.NmBuf = 0)Then List.AddStrWord(Input,L)
			Else SetPlace(L,Input);
     End
      Else
     Begin
{      If Not(ExecuteCommand(Input))Then
      Begin
       PutErr;
      End;}
      If(Brk)Then
      Begin
{       If(HighMode > 0)Then Width(TxtMode);}
       PutTxtLn('BREAK IN '+Str(LnBrk));
      End;
      Ln;
      PutTxt(']')
     End;
     Input := '';
    End;
   End;
   kbLeft,
   kbBackSpace :
   Begin
    BackStr(Input);
    W._Left;
   End;
   kbRight :
   Begin
    C := GetChar(W.GetRealX,W.GetRealY);
    If Not(C in [#0,' ',#255])Then
    Begin
     IncStr(Input,C);
     W.PutTxt(C);
    End;
   End;
   Else
   Begin
    If(Chr > #31)Then
    Begin
     Chr := ChrUp(Chr); IncStr(Input,Chr);
     W.PutTxt(Chr);
    End
     Else
    Break;
   End;
  End;
 Until False;
 Run := K;
End;

Procedure AppleII2Emul.Refresh;
Begin
End;

Destructor AppleII2Emul.Done;
Begin
 List.Done;
 Variable.Done;
 W.Done;
End;

BEGIN
END.