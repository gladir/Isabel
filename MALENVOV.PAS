Unit MalEnvOverlay;

INTERFACE

Uses Dos,Images,MLibrary,Memorys,Editor,EditButt,TeleMate,Terminal,
     FileManagers,ToolTerm;

Procedure DefaultEndBar;
Procedure Delete;
Procedure MkDir;
Procedure NewButtonEdit;
Procedure NewDraw;
Procedure NewEdit;
Procedure NewCoco3;
Procedure NewGatt;
{Procedure NewPJ;}
Procedure NewSuperCalc;
Procedure NewTerm;
Procedure NewTermPrn;
Procedure OpenX(Mode:Byte);
Procedure OpenCoco3;
Procedure OpenEdit;
Procedure OpenFile(FileName:PathStr);
Procedure OpenHelp(FileName,Title:PathStr);
Procedure OpenMod;
Procedure OpenResource;
Procedure OpenText;
Procedure OpenSuperCalc;
Procedure WindowAppleII;
Procedure WindowCoco3;
Procedure WindowCommodore64;

Function SelectDisk(OldChoice:Byte):Byte;
Function WinGotoLine:LongInt;

IMPLEMENTATION

Uses Strings,Strs,Printers,Mouse,Language,Systems,Clock,
     Keyboard,Video,Windows,Dials,MalMnu,Math,MalLibrary,
     MalCompiler,MalComRC,MalCMPas,MalEnv,MalBKRes,
     ToolEdit,ToolPrn,ToolVid,ToolTM;

Procedure DefaultEndBar;
Begin
 SetAllColor($1B,$1F);
 Case WinPtr^.Model of
  wnLotus:
  PutLastBar(2,'^F2^ Sauve  ^F3^ Ouvre  ^Alt+F3^ Ferme  ^F9^ Calcule');
  wnCoco3:
  PutLastBar(2,'^F1^ & ^F2^ Coco 3  ^F4^ = ^Clear^  ^F10^ = ^Break^');
  wnFileManager:
  PutLastBar(2,'^F3^ Edite  ^F4^ Regarde  ^Ctrl+Ins^ Copie  ^F5^ Renomme/Mouve  ^F7^ Cr‚e R‚pertoire');
  wnPersonalJournal:
  PutLastBar(2,'^PageUp^ Journ‚e pr‚c‚dente  ^PageDown^ Journ‚e suivant  ^Ctrl-L^ Liste des journ‚es');
  Else
  MLibrary.PutLastBar(2,'^F2^ Sauve  ^F3^ Ouvre  ^Alt+F3^ Ferme  ^Alt+F9^ Compile');
 End;
End;

Procedure Delete;
Begin
 If(WinPtr^.Model = wnFileManager)Then WinPtr^.P.FM.DeleteFiles;
End;

Procedure MkDir;
Var Path : PathStr;
    Name : String;
Begin
 If(WinPtr^.Model = WnFileManager)Then
 Begin
  Name := '';
  Path := Path2Dir(WinPtr^.P.FM.GetPath);
  If Not(Path[Length(Path)] = '\')Then IncStr(Path,'\');
  If(WinInp(40,'Cr‚e R‚pertoire','Entrez le nom du r‚pertoire',
	    CurrColors.Dialog.Wins,Name) = kbYes)Then
  Begin
   If((Pos('\',Name) or Pos(':',Name)) = 0)Then Name := Path + Name;
   System.MkDir(Name);
   WinPtr^.P.FM.ReadFiles(WinPtr^.P.FM.Plane);
  End;
 End;
End;

Procedure NewButtonEdit;
Var X1,Y1,X2,Y2 : Byte;
Begin
 _Windows.AddBuf(SizeOfWin,Ptr);
 WinPtr^.Model := wnButtonEdit;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.ButtonEdit.InitWin(X1,Y1,X2,Y2,'');
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure NewDraw;
Var S : ImgStruct;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnDraw;
 GetNextWnPos(S.X1,S.Y1,S.X2,S.Y2);
 S.BitsPerPix := 8; S.NmXPixs := 640; S.NmYPixs := 480; S.BaseColor := 1;
 WinPtr^.P.DrawEdit.Init('',S);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure NewEdit;
Var X1,Y1,X2,Y2 : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnEdit;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.Edit.InitWn(X1,Y1,X2,Y2,'');
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

{Procedure NewPJ;
Var X1,Y1,X2,Y2 : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnPJ;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.PJ.Init(X1,Y1,X2,Y2);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;}

Procedure NewCoco3;
Var X1,Y1,X2,Y2 : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnEdit;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.Edit.InitWn(X1,Y1,X2,Y2,'');
 WinPtr^.P.Edit.SetViewMode(ViewBas);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure NewGatt;
Var X1,Y1,X2,Y2 : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnEdit;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.Edit.InitWn(X1,Y1,X2,Y2,'');
 WinPtr^.P.Edit.SetViewMode(ViewGatt);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure NewSuperCalc;
Var X1,Y1,X2,Y2 : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnLotus;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.Lotus.Init(X1,Y1,X2,Y2,0);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure OpenX(Mode:Byte);
Var Path        : PathStr;
    PPath,PExt  : PChar;
    X1,Y1,X2,Y2 : Byte;
Begin
 Case Mode of
      ViewBasCoco3 : Begin
		      PPath := PathCoco3;
		      PExt  := ExtBas;
		     End;
       ViewBasCK64 : Begin
		      PPath := PathCommodore64;
		      PExt  := ExtBas;
		     End;
    ViewBasAppleII : Begin
		      PPath := PathAppleII;
		      PExt  := ExtBas;
		     End;
	   ViewAda : Begin
		      PPath := PathAda;
		      PExt  := '*.*';
		     End;
	   ViewAsm : Begin
		      PPath := PathAsm;
		      PExt  := ExtAsm;
		     End;
	   ViewBas : Begin
		      PPath := PathBas;
		      PExt  := ExtBas;
		     End;
	     ViewC : Begin
		      PPath := PathC;
		      PExt  := ExtC;
		     End;
	 ViewCobol : Begin
		      PPath := PathCobol;
		      PExt  := '*.*';
		     End;
      ViewEuphoria : Begin
		      PPath := PathEuphoria;
		      PExt  := ExtEuphoria;
		     End;
	 ViewForth : Begin
		      PPath := PathForth;
		      PExt  := '*.*';
		     End;
       ViewFortran : Begin
		      PPath := PathFortran;
		      PExt  := ExtFor;
		     End;
	   ViewIni : Begin
		      PPath := '';
		      PExt  := ExtIni;
		     End;
	 ViewMsMnu : Begin
		      PPath := '';
		      PExt  := ExtMsMnu;
		     End;
	   ViewPas : Begin
		      PPath := PathPas;
		      PExt  := ExtPas;
		     End;
	    ViewPW : Begin
		      PPath := '';
		      PExt  := '*.*';
		     End;
	    ViewRC : Begin
		      PPath := PathResource;
		      PExt  := ExtRC;
		     End;
	   ViewGAT : Begin
		      PPath := PathGATT;
		      PExt  := '*.GAT';
		     End;
	    ViewAC : Begin
		      PPath := '';
		      PExt  := '*.AC';
		     End;
		Else Begin
		      PPath := '';
		      PExt  := '';
		     End;
 End;
 If(PPath = NIL)Then Path := ''
		Else Path := SetPath4AddFile(StrPas(PPath));
 Path := OpenWin(Path+StrPas(PExt),'Ouvre Fichier');
 If Not(Path = '')Then
 Begin
  _Windows.AddBuf(SizeOfWin,Ptr);
  WinPtr^.Model := wnEdit;
  GetNextWnPos(X1,Y1,X2,Y2);
  WinPtr^.P.Edit.InitWn(X1,Y1,X2,Y2,Path);
  CurrEdit := _Windows.MaxBuf;
  If Not(WinPtr^.P.Edit.IsLoadOk)or(WinPtr^.P.Edit.IsLoadOutMem)Then
  Begin
   If(WinPtr^.P.Edit.IsLoadOutMem)Then
   Begin
    ErrorMsgOk('Manque de m‚moire! Impossible de charger le fichier.');
   End;
   If Not(WinPtr^.P.Edit.IsLoadOk)Then
   Begin
    ErrorMsgOk('Erreur de lecture! Impossible de charger le fichier.');
   End;
   WinPtr^.P.Edit.Done;
   _Windows.DelBuf(CurrEdit);
   Dec(CurrEdit);
  End;
 End;
 SetMnuSwitch;
End;

Procedure OpenCoco3;
Begin
 OpenX(ViewBasCoco3);
End;

Procedure OpenEdit;
Var Path        : PathStr;
    X1,Y1,X2,Y2 : Byte;
Begin
 If(WinPtr^.Model = wnCoco3)Then
 Begin
  Path := StrPas(PathCoco3);
  If(Path[Length(Path)] <> '\')Then IncStr(Path,'\');
  Path := OpenWin(Path+'*.BAS','Ouvre Fichier');
  If Not(Path = '')Then WinPtr^.P.Coco3.ExecCmd('LOAD"'+Path+'"');
 End
  Else
 Begin
  If(WinPtr^.Model = wnFileManager)Then Path := WinPtr^.P.FM.GetCurrName
				   Else Path := OpenWin('*.*','Ouvre Fichier');
  If Not(Path = '')Then
  Begin
   _Windows.AddBuf(SizeOfWin,Ptr);
   WinPtr^.Model := wnEdit;
   GetNextWnPos(X1,Y1,X2,Y2);
   WinPtr^.P.Edit.InitWn(X1,Y1,X2,Y2,Path);
   CurrEdit := _Windows.MaxBuf;
   If Not(WinPtr^.P.Edit.IsLoadOk)or(WinPtr^.P.Edit.IsLoadOutMem)Then
   Begin
    If(WinPtr^.P.Edit.IsLoadOutMem)Then
    Begin
     ErrorMsgOk('Manque de m‚moire! Impossible de charger le fichier.');
    End;
    If Not(WinPtr^.P.Edit.IsLoadOk)Then
    Begin
     ErrorMsgOk('Erreur de lecture! Impossible de charger le fichier.');
    End;
    WinPtr^.P.Edit.Done;
    _Windows.DelBuf(CurrEdit);
    Dec(CurrEdit);
   End;
  End;
  SetMnuSwitch;
 End;
End;

Procedure OpenFile(FileName:PathStr);
Var X1,Y1,X2,Y2 : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnEdit;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.Edit.InitWn(X1,Y1,X2,Y2,FileName);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure OpenHelp(FileName,Title:PathStr);
Var X1,Y1,X2,Y2 : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnHlp;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.Hlp.InitHlp(X1,Y1,X2,Y2,FileName,Title);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure OpenMod;
Begin
End;

Procedure OpenResource;
Begin
 OpenX(ViewRC);
End;

Procedure OpenText;
Begin
 OpenX(ViewGATT);
End;

Procedure OpenSuperCalc;
Var Path : PathStr;
    X1,Y1,X2,Y2 : Byte;
Begin
 Path := StrPas(PathCalc);
 If(Path[Length(Path)] <> '\')Then IncStr(Path,'\');
 Path := OpenWin(Path+'*.MGC','Ouvre Fichier');
 If Not(Path = '')Then
 Begin
  _Windows.AddBuf(SizeOfWin,Ptr);
  WinPtr^.Model := wnLotus;
  GetNextWnPos(X1,Y1,X2,Y2);
  WinPtr^.P.Edit.InitWn(X1,Y1,X2,Y2,Path);
  CurrEdit := _Windows.MaxBuf;
  If Not(WinPtr^.P.Edit.IsLoadOk)or(WinPtr^.P.Edit.IsLoadOutMem)Then
  Begin
   If(WinPtr^.P.Edit.IsLoadOutMem)Then
   Begin
    ErrorMsgOk('Manque de m‚moire! Impossible de charger le fichier.');
   End;
   If Not(WinPtr^.P.Edit.IsLoadOk)Then
   Begin
    ErrorMsgOk('Erreur de lecture! Impossible de charger le fichier.');
   End;
   WinPtr^.P.Edit.Done;
   _Windows.DelBuf(CurrEdit);
   Dec(CurrEdit);
  End;
 End;
 SetMnuSwitch;
End;

Procedure NewTerm;
Var Path : PathStr;
    X1,Y1,X2,Y2 : Byte;
Begin
 _Windows.AddBuf(SizeOfWin,Ptr);
 WinPtr^.Model := wnTerminal;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.Terminal.Init(Y1,Y2,CurrModem);
 WinPtr^.P.Terminal.HostModeDownload := StrPas(PathUpload);
 WinPtr^.P.Terminal.HostModeUpload := StrPas(PathDownload);
 WinPtr^.P.Terminal.DownloadDirPath := StrPas(PathDownload);
 WinPtr^.P.Terminal.UpLoadDirPath := StrPas(PathUpload);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure NewTermPrn;
Var X1,Y1,X2,Y2 : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnTermPrn;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.TPrn.Init(X1,Y1,X2,Y2);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Function SelectDisk(OldChoice:Byte):Byte;
Var DiskTab    : Array[0..25] of Bool;
    DiskLet    : Array[0..25] of Char;
    Res,Ok     : Boolean;
    P,I,N,FD,M : Byte; { Number of disk, First disk, maximum }
    W,L        : Wins;
Begin
 SelectDisk := $FF;
 If(OldChoice = 0)Then OldChoice := GetDisk
		  Else Dec(OldChoice);
 N  := 0;
 FD := $FF;
 For I := 0 to 25 do
 Begin
  Res        := DiskExist(I);
  DiskTab[I] := Res;
  If(Res)Then
  Begin
   DiskLet[N] := Char(I+Byte('A'));
   Inc(N);
   If(I < FD)Then FD := I;
  End;
 End;
 If(N = 0)Then Exit;
 If(N = 1)Then
 Begin
  SelectDisk := FD;
  Exit;
 End;
 M := N - 1;
 If Not(DiskTab[OldChoice])Then OldChoice := FD;
 L.Init(0,MaxYTxts,MaxXTxts,MaxYTxts);
 L.PushWn;
 PutLastBar(0,'  S.V.P. S‚lectionnez le lecteur appropri‚');
 W.InitO(1+(N * 3),3);
 W.PushWn;
 W.PutWn('Disque',CurrColors.Dialog.Wins);
 For I := 0 to M do
 Begin
  W.PutTxtXY((I*3)+1,1,DiskLet[I]);
  If(OldChoice = (Byte(DiskLet[I]) - Byte('A')))Then
  Begin
   P := I;
   W.SetKrSel;
   W.BarSelHor(I*3,1,(I*3)+2);
   W.SetKrBorder;
  End;
 End;
 Ok := False;
 Repeat
  Repeat
   Case (Mem[_0040:$6C] and $F) of
     0 : W._SetCubeCSelF((P*3)+1,1,DiskLet[P],LightRed);
     4 : W._SetCubeCSelF((P*3)+1,1,DiskLet[P],Yellow);
     8 : W._SetCubeCSelF((P*3)+1,1,DiskLet[P],LightBlue);
    12 : W._SetCubeCSelF((P*3)+1,1,DiskLet[P],LightGreen);
   End;
  Until Keypressed;
  W._SetCubeCSel((P*3)+1,1,DiskLet[P]);
  Case ReadKey of
    kbLeft : Begin
	      W.SetKrBorder;
	      W.BarSelHor(P*3,1,(P*3)+2);
	      P := MinByte(P,M);
	      W.SetKrSel;
	      W.BarSelHor(P*3,1,(P*3)+2);
	     End;
   kbRight : Begin
	      W.SetKrBorder;
	      W.BarSelHor(P*3,1,(P*3)+2);
	      P := MaxByte(P,M);
	      W.SetKrSel;
	      W.BarSelHor(P*3,1,(P*3)+2);
	     End;
   kbEnter : Begin
	      SelectDisk := Byte(DiskLet[P])-64;
	      Ok := True;
	     End;
     kbEsc : Ok := True;
  End;
 Until Ok;
 L.Done;
 W.Done;
End;

Procedure WindowAppleII;
Var X,Y : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnAppleII;
 GetNextWnMin(34,18,X,Y);
 WinPtr^.P.AppleII.Init(X,Y);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure WindowCoco3;
Var X,Y : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnCoco3;
 GetNextWnMin(34,18,X,Y);
 WinPtr^.P.Coco3.Init(X,Y);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure WindowCommodore64;
Var X,Y : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnCommodore64;
 GetNextWnMin(42,25,X,Y);
 WinPtr^.P.CK64.Init(X,Y);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Function WinGotoLine:Long;
Var K:Word; Str:String; Ok:Bool; Target,Err:Word;
Begin
 WinGotoLine := 0; Ok := False; Str := '';
 Repeat
  K := WinInp(40,'Aller Ligne','Entrer la nouvelle ligne',CurrColors.Dialog.Wins,Str);
  If(K = kbEsc)Then Exit;
  Val(Str,Target,Err);
  Ok := (Err = 0);
  If Not(Ok)Then ErrorMsgOk('Nombre attendue.');
 Until Ok;
 WinGotoLine := Target;
End;

BEGIN
END.