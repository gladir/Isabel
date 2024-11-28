(*********************************************************)
(*                                                       *)
(*               Malte Genesis/QuickHex View             *)
(*     Phoenix Edition for Real Mode & Protected Mode    *)
(*                   II - Version 1.8                    *)
(*                      1994/12/29                       *)
(*                                                       *)
(*       Copyright (C) par les Chevaliers de Malte       *)
(*                                                       *)
(*********************************************************)

Unit QHexView;

INTERFACE

Uses Dos,Math,Windows;

Const

      HexViewNumXTxts = 75;
      HexViewNumYTxts = 19;

Type

     HexView = Object
      Constructor Init(X,Y:Byte;Name:PathStr);
      Function Run:Word;
      Function GetPath:PathStr;
      Procedure Refresh;
      Destructor Done;
      PRIVATE
      ViewName:PathStr;
      W:Wins;
      CurrRec,MaxRec:Long;
      Procedure PutCurrRec;
     End;

IMPLEMENTATION

Uses Keyboard,Systems,Strs,Dials;

Constructor HexView.Init;
Var Handle : Word; FS : Long;
Begin
 CurrRec := 0; ViewName := Name;
 W.Init(X,Y,X+HexViewNumXTxts,Y+HexViewNumYTxts);
 W.PushWn;
 Handle := Open(Name,ReadOnly); FS := FileSize(Handle); MaxRec := (FS div 1024) - 1;
 If((FS mod 1024) > 0)Then Inc(MaxRec);
 Close(Handle);
 Refresh;
End;

Procedure HexView.Refresh;
Var J : Byte;
Begin
 W.PutWn('Edite/Regarde Hexad‚cimal '+ViewName,CurrColors.HexView.Wins);
 W.PutTxtXY(0,0,'Courant :');
 W.PutTxtXY(20,0,'Maximum :');
 W.PutTxtXY(30,0,HexLong2Str(MaxRec));
 For J := 0 to 15 do W.PutTxtXY(0,J+2,HexWord2Str(J*64)+' - ');
 PutCurrRec;
End;

Function HexView.GetPath;
Begin
 GetPath := ViewName;
End;

Procedure HexView.PutCurrRec;
Var Buffer : Array[0..15,0..63] of Char; I,J : Byte;
Begin
 GetFile(ViewName,CurrRec,SizeOf(Buffer),Buffer);
 W.PutTxtXY(10,0,HexLong2Str(CurrRec));
 For J := 0 to 15 do For I := 0 to 63 do W.SetChr(9+I,J+2,Buffer[J,I]);
End;

Function HexView.Run;
Var K : Word; Ok : Bool;
Begin
 Ok := False;
 Repeat
  K := W.Readk;
  Case K of
   kbCtrlHome : If(CurrRec <> 0)Then
                Begin
                 CurrRec := 0;
                 PutCurrRec;
                End;
    kbCtrlEnd : If(CurrRec <> MaxRec)Then
                Begin
                 CurrRec := MaxRec;
                 PutCurrRec;
                End;
       kbPgUp : If(CurrRec > 0)Then
                Begin
                 Dec(CurrRec);
                 PutCurrRec;
                End;
     kbPgDown : If(CurrRec < MaxRec)Then
                Begin
                 Inc(CurrRec);
                 PutCurrRec;
                End;
           Else Ok := True;
  End;
 Until Ok;
 Run := K;
End;

Destructor HexView.Done;
Begin
 W.Done;
End;

BEGIN
END.