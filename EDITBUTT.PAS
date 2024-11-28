(********************************************************)
(*                                                      *)
(*              Malte Genesis/Editor Button             *)
(*   Phoenix Edition for Real Mode & Protected Mode     *)
(*                   II - Version 1.8                   *)
(*                      1994/12/29                      *)
(*                                                      *)
(*      Copyiright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit EditButt;

INTERFACE

Uses Dos,Math,Video,Windows,Dials;

Const

      drwNone = 0;
      drwLine = 1;
      drwBox = 2;
      drwCircle = 3;
      drwPaint = 4;
      drwTrace = 5;
      drwText = 6;

Type

     ButtonEditor = Object
      Constructor InitWin(X1,Y1,X2,Y2:Byte;Path:PathStr);
      Procedure Refresh;
      Procedure Save;
      Procedure SaveAs(Path:PathStr);
      Procedure SetMode(M:Byte);
      Procedure NewPage;
      Procedure ChangePage;
      Function GetName:PathStr;
      Function Run:Word;
      Destructor Done;
      PRIVATE
      W:Wins; Name:PathStr; Block:BlockButton;
      X,Y,XM,YM,CurrColor,CurrPage,Mode:Byte;
      Modified,SM:Bool;
      Procedure PutCube(Pset:Bool);
      Procedure SetPosColor;
      Procedure UnSetPosColor;
      Procedure InputSaveModified;
      Procedure PutFillBox(X1,Y1,X2,Y2,Color:Byte);
      Procedure _PutCube(_X,_Y:Byte;Pset:Bool);
     End;

IMPLEMENTATION

Uses Strs,Systems,Keyboard;

Constructor ButtonEditor.InitWin;
Begin
 SM := False; Modified := False; Mode := drwNone;
 XM := $FF; YM := $FF; CurrPage := 0; CurrColor := 15;
 W.Init(X1,Y1,X1+64+1,Y1+16+2);
 W.PushWn;
 Name := Path;
 If(Path = '')Then FillChar(Block,SizeOf(Block),0)
	      Else GetFile(Path,0,SizeOf(Block),Block);
 Refresh;
 X := 15; Y := 15;
End;

Procedure ButtonEditor.PutFillBox;
Var I,J,L : Byte;
Begin
 If(X1 > X2)Then SwapByte(X1,X2);
 If(Y1 > Y2)Then SwapByte(Y1,Y2);
 L := (X2-X1)+1;
 For J := Y1 to Y2 do
 Begin
  FillChar(Block.Data[J,X1],L,Color);
  For I := X1 to X2 do _PutCube(I,J,True);
 End;
End;

Procedure ButtonEditor.InputSaveModified;
Begin
 If(Modified)Then
 Begin
  If(WarningMsgYesNo('Bouton n''a pas ‚t‚ sauvegard‚! Dois-je le sauver ?') = kbYes)Then Save;
  Modified := False;
 End;
End;

Procedure ButtonEditor.NewPage;
Var Handle:Word;
Begin
 InputSaveModified;
 Handle := Open(Name,ReadOnly); CurrPage := FileSize(Handle) div SizeOf(Block);
 FillChar(Block,SizeOf(Block),0);
 Close(Handle);
 Refresh;
 X := 15; Y := 15;
End;

Procedure ButtonEditor.ChangePage;
Var Lst:LstMnu; Handle,I:Word;
Begin
 InputSaveModified;
 Lst.Init(10,4,MaxXTxts-10,MaxYTxts-4,'Page Bouton',CurrColors.EditButt);
 Handle := Open(Name,ReadOnly);
 For I := 0 to (FileSize(Handle) div SizeOf(Block))-1 do
 Begin
  GetRec(Handle,I,SizeOf(Block),Block);
  If(Block.Name = '')Then Block.Name := 'Pasnom';
  Lst.AddStr(Str(I)+' - '+Block.Name);
 End;
 CurrPage := Lst.Run;
 GetRec(Handle,CurrPage,SizeOf(Block),Block);
 Close(Handle);
 Lst.Done;
 Refresh;
 X := 15; Y := 15;
End;

Procedure ButtonEditor.Save;
Var Path:PathStr;
Begin
 Path := Name;
 If(Name = '')Then
 Begin
  Path := OpenWin('Sauve Sous',Path);
  If(Path = '')Then Exit;
  Name := Path;
 End;
 SaveAs(Path);
End;

Procedure ButtonEditor.SaveAs;
Var Str:String; Handle:Word;
Begin
 If(Path <> Name)Then
 Begin
  If(FileExist(Path))Then
  Begin
   If Not(__InputOverwriteFile)Then Exit;
   Name := Path;
  End;
 End;
 If Not(FileExist(Path))Then
 Begin
  Handle := Systems.New(Path);
  Systems.Close(Handle);
 End;
 If(Block.Name = '')Then
 Begin
  Str := '';
  WinInp(40,'Page','Entrez le nom de cette page:',CurrColors.Dialog.Wins,Str);
  If(Length(Str) > SizeOf(Block.Name)-1)Then
   Str[0] := Char(SizeOf(Block.Name) - 1);
  Block.Name := Str;
 End;
 SetFile(Path,CurrPage,SizeOf(Block),Block);
 Modified := False;
End;

Procedure ButtonEditor.SetMode;
Begin
 Mode := M;
End;

Procedure ButtonEditor.SetPosColor;
Begin
 W.SetChr((CurrColor*4)+2,W.MaxYTxts,'þ');
End;

Procedure ButtonEditor.UnSetPosColor;
Begin
 W.SetChr((CurrColor*4)+2,W.MaxYTxts,' ');
End;

Procedure ButtonEditor.Refresh;
Var XT,YT,I,J : Byte;
Begin
 If(Name = '')Then W.PutWn('Pasnom',CurrColors.EditButt)
	      Else W.PutWn(Name,CurrColors.EditButt);
 XT := X; YT := Y;
 For J := 0 to 15 do For I := 0 to 31 do
 Begin
  X := I; Y := J shl 1;
  PutCube(True);
 End;
 X := XT; Y := YT;
 For I := 0 to 15 do
 Begin
  W.SetKr(I shl 4);
  W.PutTxtXY(I*4,W.MaxYTxts,Spc(4));
 End;
 SetPosColor;
End;

Function ButtonEditor.GetName;
Begin
 GetName := Name;
End;

Procedure ButtonEditor.PutCube;
Begin
 _PutCube(X,Y,Pset);
End;

Procedure ButtonEditor._PutCube;
Var Attr : Byte;
Begin
 Attr := (Block.Data[_Y and $FE,_X] shl 4) + Block.Data[(_Y and $FE)+1,_X];
 If Not(Pset)Then
 Begin
  If((_Y and 1) = 1)Then Attr := Attr xor $F Else Attr := Attr xor $F0;
 End;
 W._SetCube(_X shl 1,_Y shr 1,'Ü',Attr);
 W._SetCube((_X shl 1)+1,_Y shr 1,'Ü',Attr);
End;

Function ButtonEditor.Run;
Var K:Word; Ok:Bool;
Begin
 Ok := False;
 Repeat
  PutCube(False);
  K := W.Readk;
  If(Mode = drwTrace)Then
  Begin
   Block.Data[Y,X] := CurrColor; Modified := True;
  End;
  PutCube(True);
  Case K of
      kbCtrlLeft : Begin
		    UnSetPosColor;
		    CurrColor := (CurrColor - 1) and 15;
		    SetPosColor;
		   End;
     kbCtrlRight : Begin
		    UnSetPosColor;
		    CurrColor := (CurrColor + 1) and 15;
		    SetPosColor;
		   End;
	 kbEnter : Case Mode of
		    drwNone,drwText:
		    Begin
		     Modified := True;
		     Block.Data[Y,X] := CurrColor;
		    End;
		    drwBox:
		    Begin
		     If Not(SM)Then Begin XM := X; YM := Y; End
			       Else PutFillBox(X,Y,XM,YM,CurrColor);
		     SM := Not(SM);
		    End;
		   End;
	    kbUp : Y := (Y - 1) and 31;
	  kbDown : Y := (Y + 1) and 31;
	  kbLeft : X := (X - 1) and 31;
	 kbRight : X := (X + 1) and 31;
	      Else Ok := True;
  End;
 Until Ok;
 Run := K;
End;

Destructor ButtonEditor.Done;
Begin
 InputSaveModified;
 W.Done;
End;

BEGIN { Main Unit }
END.