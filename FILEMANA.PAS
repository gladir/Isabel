(*********************************************************)
(*                                                       *)
(*                Malte Genesis/File Manager             *)
(*     Phoenix Edition for Real Mode & Protected Mode    *)
(*                    II - Verison 1.8                   *)
(*                       1994/12/29                      *)
(*                                                       *)
(*        Copyright (C) par les Chevaliers de Malte      *)
(*                                                       *)
(*********************************************************)

Unit FileManagers;

INTERFACE

Uses Dos,MLibrary,Video,Windows,Dials,Math,Terminal,Mems;

Const

      BoardInfo = 0;
      BoardFile = 1;
      BoardTree = 2;

Type

     FileInfoType = Record
      Size,SizeArchive,SizeHidden,SizeReadOnly,SizeSys,NmFile,NmSector,
      ArchiveFile,HiddenFile,ReadOnlyFile,SysFile,Directory:Long;
     End;

     FileManager = Object
      Select:Array[0..1] of ^TBoolean;
      Plane:Byte;
      Constructor InitWin(X1,Y1,X2,_Y2:Byte);
      Procedure ReadFiles(Pln:Byte);
      Procedure ReadTree(Pln:Byte);
      Procedure SetPath(Pln:Byte;_Path:PathStr);
      Function GetCurrName:PathStr;
      Function NumSel:Word;
      Procedure GetCurrFile(Var Info:SearchRec);
      Procedure GetFile(_P:Word;Var Info:SearchRec);
      Procedure ChgBoard;
      Procedure Refresh;
      Function GetPath:PathStr;
      Procedure CopyFiles;
      Procedure DeleteFiles;
      Procedure ChDsk;
      Procedure PrincipalPath;
      Function Run:Word;
      Destructor Done;
      PRIVATE
      Name:PathStr;
      P,SizeFileSel:Array[0..1] of Long;
      Y,Board:Array[0..1] of Byte;
      LF:Array[0..1] of Wins;
      W:Ansi;
      BF:Array[0..1] of BankFiles;
      Path:Array[0..1] of PathStr;
      SizeSelect,SelFiles:Array[0..1] of Word;
      BufTree:Array[0..1] of RBuf;
      More:Bool;
      Procedure PutDisk(Pln:Byte);
      Procedure PutBar(_Plane,_Y:Byte;_P:Long;Info:SearchRec);
      Procedure PutBarTree(Pln,_Y:Byte;_P:Long);
      Procedure SelectBar(_Plane:Byte);
      Procedure UnSelectBar;
      Procedure kUp;
      Procedure kDn;
      Procedure kHome;
      Procedure kEnd;
      Procedure PutSelect(Pln:Byte);
      Function GetCurrPathTree(Pln:Byte):PathStr;
     End;

Procedure GetFileInfo(Drive:Char;Var Info:FileInfoType;Var Buf:RBuf);

Function SelectDisk(OldChoice:Byte):Byte;

IMPLEMENTATION

Uses Strings,Strs,Country,Keyboard,Systems,Mouse;

Constructor FileManager.InitWin;
Begin
 BufTree[0].Init; BufTree[1].Init;
 Name := ''; SizeSelect[0] := 0; Select[0] := NIL; SelFiles[0] := 0;
 SizeFileSel[0] := 0; SizeSelect[1] := 0; Select[1] := NIL;
 SelFiles[1] := 0; SizeFileSel[1] := 0; Board[1] := BoardInfo;
 Board[0] := BoardFile;
 W.Init(X1,Y1,X2,_Y2);
 More := (W.MaxXTxts < 76);
 W.PushWn;
 Path[0] := Systems.GetPath;
 If(Path[0][Length(Path[0])] <> '\')Then IncStr(Path[0],'\');
 AddStr(Path[0],'*.*'); Path[1] := Path[0];
 P[0] := 0; Y[0] := 0; P[1] := 0; Y[1] := 0; Plane := 0;
 BF[0].Init; BF[1].Init;
 Refresh;
End;

Procedure FileManager.ChDsk;
Var Disk,Out:Byte;
Begin
 Disk := Path2Disk(GetPath) + 1; Out := SelectDisk(Disk);
 If(Out = $FF)Then Exit;
 If(Out <> Disk)Then
 Begin
  SetPath(Plane,Char(Out+Byte('@'))+':*.*');
  If(Board[(Plane+1) and 1] = BoardTree)Then
  Begin
   Path[(Plane+1) and 1] := Path[Plane];
   ReadTree((Plane+1)and 1);
  End;
 End;
End;

Procedure FileManager.PrincipalPath;
Begin
 SetPath(Plane,Path2Drive(Path[0])+':\*.*');
End;

Var

    WCopy : Wins;

Procedure InitCopy(Source,Target:PathStr);
Begin
 WCopy.InitO(40,9);
 WCopy.PushWn;
 WCopy.PutWn('Copie',CurrColors.Dialog.Wins);
 WCopy.PutTxtXY(0,1,'De: '+FileExpand(Source));
 WCopy.PutTxtXY(0,2,'…: '+FileExpand(Target));
 WCopy.SetKr($1F);
 WCopy.BarSpcHorShade(0,6,WCopy.MaxXTxts-1);
 WCopy.SetKrBorder;
End;

Procedure BackCopy(Pour:Byte;Curr,Total:Long);
Begin
 WCopy.PutTxtXY(0,4,Str(Curr)+'/'+Str(Total));
 WCopy.SetPos(0,6);
 WCopy.PutOTxtU(Str(Pour)+'%');
 WCopy.SetKr($F0);
 WCopy.BarSelHor(0,6,Trunc(Pour * ((WCopy.MaxXTxts-1)/100)));
 WCopy.SetKrBorder;
End;

Procedure DoneCopy;
Begin
 WCopy.Done;
End;

Procedure FileManager.CopyFiles;
Var N,N1,N2:String; J:Word; Info:SearchRec;
Begin
 If(NumSel = 0)Then
 Begin
  N := '';
  If(WinInp(40,'Copier Fichier','Entrez le nom destinataire',
           CurrColors.Dialog.Wins,N) = kbYes)Then
  Begin
   If(Pos('.',N) = 0)Then
   Begin
    If(N[Length(N)] <> '\')Then IncStr(N,'\');
    AddStr(N,Path2NoDir(GetCurrName));
   End;
   InitCopy(GetCurrName,N);
   _CopyFile(GetCurrName,N,BackCopy);
   DoneCopy;
   ReadFiles(Plane);
  End;
 End
  Else
 Begin
  N := '';
  If(WinInp(40,'Copier des Fichiers','Entrez le nom du r‚pertoire destinataire',
            CurrColors.Dialog.Wins,N) = kbYes)Then
  For J := 0 to BF[0].MaxFiles do
  Begin
   If(Select[Plane]^[J])Then
   Begin
    N2 := N;
    If(N2[Length(N2)] <> '\')Then IncStr(N2,'\');
    GetFile(J,Info);
    AddStr(N2,Info.Name); N1 := Path2Dir(GetPath) + Info.Name;
    InitCopy(N1,N2);
    _CopyFile(N1,N2,BackCopy);
    DoneCopy;
   End;
  End;
 End;
End;

Procedure FileManager.DeleteFiles;
Var H:SearchRec; J:Word;
Begin
 If(NumSel = 0)Then
 Begin
  GetCurrFile(H);
  ClrKbd;
  If(WarningMsgYesNo('Etes-vous certain de vouloir effacer "'+H.Name+'" ?') = kbYes)Then
  Begin
   If(H.Attr and Dir = Dir)Then RmDir(Path2Dir(GetPath) + H.Name)
			   Else Systems.Del(Path2Dir(GetPath) + H.Name);
  End;
  ReadFiles(Plane);
 End
  Else
 Begin
  ClrKbd;
  If(WarningMsgYesNo('Etes-vous certain de vouloir effacer '+Str(NumSel)+' fichiers ?') = kbNo)Then Exit;
  ClrKbd;
  If(ErrorMsg('Etes-vous vraiment certain de vouloir effacer '+Str(NumSel)+' fichiers ?',
     Video.__Yes__+Video.__No__) = kbYes)Then
  Begin
   For J := 0 to BF[Plane].MaxFiles do
   Begin
    If(Select[Plane]^[J])Then
    Begin
     GetFile(J,H);
     If((H.Attr and ReadOnly) = ReadOnly)Then
     Begin
      ClrKbd;
      If(ErrorMsg('Fichier Prot‚g‚! Etes-vous vraiment certain de '+
  'vouloir effacer "' + H.Name + '" ?',
  Video.__Yes__+Video.__No__) = kbNo)Then Break;
     End;
     Systems.Del(Path2Dir(GetPath) + H.Name);
    End;
   End;
  End;
  ReadFiles(Plane);
 End;
End;

Procedure FileManager.ChgBoard;
Var L:LstMnu; E:Word;
Begin
 L.Init(LF[Plane].GetRX1,LF[Plane].GetRY1,LF[Plane].GetRX1+LF[Plane].MaxXTxts,LF[Plane].GetRY1+LF[Plane].MaxYTxts,
	'Liste des Tableaux',CurrColors.Dialog.Wins);
 L.AddPChrWord('Information',BoardInfo);
 L.AddPChrWord('Fichier',BoardFile);
 L.AddPChrWord('Arbre R‚pertoire',BoardTree);
 E := L.Run;
 L.Done;
 If(E = kbEsc)Then Exit;
 Board[Plane] := E;
 Refresh;
End;

Procedure FileManager.ReadTree;
Var J:Byte; Info:FileInfoType; L:Wins;
Begin
 L.PushEndBar;
 PutLastBar(2,'Lecture des r‚pertoires en cours...');
 BufTree[Pln].Done;
 BufTree[Pln].Init;
 BufTree[Pln].AddStrByte('\',0);
 GetFileInfo(Path2Drive(Path[(Pln+1)and 1]),Info,BufTree[Pln]);
 L.Done;
 Path[Pln] := Path2Drive(Path[(Pln+1) and 1]) + ':\';
 LF[Pln].SetPos(0,0);
 LF[Pln].SetKrBorderF($B);
 For J := 0 to LF[Pln].MaxYTxts do PutBarTree(Pln,J,J);
 LF[Pln].SetEndBarCTitle;
 LF[Pln].SetEndBarTxtX(2,Str(BufTree[Pln].NmBuf)+' R‚pertoires',LF[Pln].XColrs.Title);
 PutSelect(Pln);
 SelectBar(Pln);
End;

Procedure FileManager.Refresh;
Var fX1,fY1,fX2,fY2,I:Byte; MoreB:Byte Absolute More;
Begin
 W.PutWn('Gestionnaire Fichiers',CurrColors.Dialog.Wins);
 SetShade(False);
 fX1 := W.GetRX1; fY1 := W.GetRY1 + 1; fX2 := fX1 + ((W.RX2-W.RX1) shr 1) - 1;
 fY2 := W.MaxYTxts - (3 + (MoreB * 2));
 LF[0].Init(fX1,fY1,fX2+1,fY2);
 LF[1].Init(fX2+2,fY1,W.GetRX1+W.MaxXTxts-1,fY2);
 If(More)Then
 Begin
  W.PutkHorO(W.MaxYTxts-5,'Regarde|Edite|Copie');
  W.PutkHorO(W.MaxYTxts-3,'Renomme|Recherche|Imprime');
 End
  Else
 W.PutkHorO(W.MaxYTxts-3,'Regarde|Edite|Copie|Renomme|Recherche|Imprime');
 W.PutkHorDn('Compile|Convertie|Compresse');
 For I := 0 to 1 do
 Begin
  LF[I].XColrs := W.XColrs;
  Case Board[I] of
   BoardInfo :
   Begin
    LF[I]._PutWn('Informations');
    PutDisk(I);
    LF[I].SetKrBorder;
    LF[I].PutTxtLn('Espace r‚pertoire utilis‚ :');
    LF[I].PutTxtXY(0,LF[I].MaxYTxts-1,'S‚lection :');
   End;
   BoardFile :
   Begin
    LF[I]._PutWn(Path[I]);
    LF[I].SetEndBarCTitle;
   End;
   BoardTree :
   Begin
    LF[I]._PutWn('Arbre R‚pertoire');
    ReadTree(I);
   End;
  End;
  LF[I].PutSmallBorder;
 End;
 For I := 0 to 1 do Case Board[I] of
  BoardFile : ReadFiles(I);
  BoardTree : SetPath((I+1) and 1,GetCurrPathTree(I));
 End;
 SetShade(True);
End;

Procedure FileManager.PutDisk;
Var Disk:Byte;
Begin
 Disk := Path2Disk(Path[(Pln+1) and 1]) + 1;
 LF[Pln].SetKrBorder;
 LF[Pln].SetPos(0,0);
 LF[Pln].PutTxtLn('Espace disque total :');
 LF[Pln].SetKrBorderF($B);
 LF[Pln].PutTxtLn(' '+Str(DiskSize(Disk))+' octet(s)');
 LF[Pln].SetKrBorder;
 LF[Pln].PutTxtLn('Espace disque utilis‚ :');
 LF[Pln].SetKrBorderF($B);
 LF[Pln].PutTxtLn(' '+Str(DiskUsed(Disk))+' octet(s)');
 LF[Pln].SetKrBorder;
 LF[Pln].PutTxtLn('Espace disque libre :');
 LF[Pln].SetKrBorderF($B);
 LF[Pln].PutTxtLn(' '+Str(DiskFree(Disk))+' octet(s)');
End;

Procedure FileManager.SetPath;
Var ChgDsk:Bool;
Begin
 If(Board[Pln] = BoardFile)Then
 Begin
  ChgDsk := (Path2Disk(Path[Pln]) <> Path2Disk(_Path)); Path[Pln] := _Path;
  If(ChgDsk)Then PutDisk(Pln);
  ReadFiles(Pln);
 End;
End;

Function FileManager.GetPath;
Begin
 GetPath := Path[Plane];
End;

Function FileManager.NumSel;
Begin
 NumSel := SelFiles[Plane];
End;

Procedure FileManager.GetCurrFile;
Begin
 BF[Plane].GetFile(P[Plane],Info);
End;

Function FileManager.GetCurrName;
Var H:SearchRec;
Begin
 BF[Plane].GetFile(P[Plane],H);
 If((H.Attr and Dir) = 0)Then GetCurrName := Path2Dir(GetPath) + H.Name
			 Else GetCurrName := '';
End;

Procedure FileManager.GetFile;
Begin
 BF[Plane].GetFile(_P,Info);
End;

Procedure FileManager.PutSelect;
Var PlnNext:Byte;
Begin
 PlnNext := (Pln + 1) and 1;
 If(Board[PlnNext] = BoardInfo)Then
 Begin
  LF[PlnNext].SetKrBorderF($B);
  If(SelFiles[Pln] = 0)Then LF[PlnNext].PutTxtXY(1,LF[PlnNext].MaxYTxts,StrUSpc('Aucun',13))
		       Else LF[PlnNext].PutTxtXY(1,LF[PlnNext].MaxYTxts,StrUSpc(Str(SelFiles[Pln]),13));
  If(SizeFileSel[Pln] > 0)Then LF[PlnNext].PutTxtXY(14,LF[(Pln+1)and 1].MaxYTxts,Str(SizeFileSel[Pln])+' octet(s)');
  LF[PlnNext].ClrEol;
 End;
End;

Procedure FileManager.PutBar;
Begin
 If(Select[_Plane]^[_P])Then LF[_Plane].SetKrBorderF($E)
			Else LF[_Plane].SetKrBorderF($B);
 LF[_Plane].SetPos(0,_Y);
 LF[_Plane].PutTxt(SetFullName(Info.Name));
 If(Info.Attr = Dir)Then LF[_Plane].PutTxt(StrUSpc('<R‚p>',8))
		    Else LF[_Plane].PutTxt(Str2(Info.Size,8));
 LF[_Plane].PutTxt(' '+CStrDate(Info.Time)+' ');
 LF[_Plane].PutTxt(CStrTime(Info.Time));
End;

Procedure FileManager.PutBarTree;
Var Ptr,PtrNext:^PCharByteRec;
Begin
 Ptr := BufTree[Pln]._GetBuf(_P);
 If(Ptr^.Nm > 0)Then With LF[Pln] do
 Begin
  PtrNext := BufTree[Pln]._GetBuf(_P+1);
  If(PtrNext = NIL)Then PutTxtXY(0,_Y,Spc(Ptr^.Nm-1)+'À'+StrPas(Ptr^.PChr)) Else
  If(PtrNext^.Nm = Ptr^.Nm)Then PutTxtXY(0,_Y,Spc(Ptr^.Nm-1)+'Ã'+StrPas(Ptr^.PChr))
			   Else PutTxtXY(0,_Y,Spc(Ptr^.Nm-1)+'À'+StrPas(Ptr^.PChr));
 End
  Else
 LF[Pln].PutTxtXY(0,_Y,StrPas(Ptr^.PChr));
 LF[Pln].ClrEol;
End;

Function FileManager.GetCurrPathTree;
Var Ptr,PtrPrev:^PCharByteRec; _Path:PathStr; J,Nm:Int;
Begin
 GetCurrPathTree := ''; Ptr := BufTree[Pln]._GetBuf(P[Pln]);
 If(Ptr^.Nm = 0)Then
 Begin
  If(Ptr^.PChr[0] = '\')Then GetCurrPathTree := Path2Drive(Path[Pln])+':\*.*'
   Else
  GetCurrPathTree := Path2Drive(Path[Pln])+':\'+StrPas(Ptr^.PChr)+'\*.*';
 End
  Else
 Begin
  Nm := Ptr^.Nm; _Path := StrPas(Ptr^.PChr);
  For J := P[Pln] downto 0 do
  Begin
   PtrPrev := BufTree[Pln]._GetBuf(J);
   If(PtrPrev^.Nm < Nm)Then
   Begin
    Dec(Nm); _Path := StrPas(PtrPrev^.PChr) + '\' + _Path;
   End;
  End;
  GetCurrPathTree := Path2Drive(Path[Pln]) + ':\' + _Path + '\*.*';
 End;
End;

Procedure FileManager.SelectBar;
Begin
 If Not(Board[_Plane] in [BoardFile,BoardTree])Then Exit;
 If(Board[Plane] = BoardTree)Then LF[_Plane].SetKrSel Else
 If(Select[_Plane]^[P[_Plane]])Then LF[_Plane].SetKrSelF($E)
                               Else LF[_Plane].SetKrSel;
 LF[_Plane].BarSelHor(0,Y[_Plane],wnMax);
End;

Procedure FileManager.UnSelectBar;
Begin
 If(Board[Plane] = BoardTree)Then LF[Plane].SetKrBorderF($B) Else
 If(Select[Plane]^[P[Plane]])Then LF[Plane].SetKrBorderF($E)
                             Else LF[Plane].SetKrBorderF($B);
 LF[Plane].BarSelHor(0,Y[Plane],wnMax);
End;

Procedure FileManager.ReadFiles;
Var I,M,PlnNext:Byte; H:SearchRec; J:Word;
Begin
 Y[Pln] := 0; P[Pln] := 0; SelFiles[Pln] := 0; SizeFileSel[Pln] := 0;
 FreeMem(Select[Pln],SizeSelect[Pln]);
 Path[Pln] := FileExpand(Path[Pln]);
 LF[Pln]._SetTitle(Path[Pln]);
 LF[Pln].PutBarMsRight;
 BF[Pln].SelectPath(Path[Pln],$FFFF-VolumeID);
 SizeSelect[Pln] := BF[Pln].MaxFiles + 1;
 LF[Pln].SetEndBarCTitle;
 LF[Pln].SetEndBarTxtX(2,Str(SizeSelect[Pln])+' Fichiers',LF[Pln].XColrs.Title);
 Select[Pln] := MemAlloc(SizeSelect[Pln]);
 If(Select[Pln] = NIL)Then Exit;
 FillChar(Select[Pln]^[0],SizeSelect[Pln],Byte(False));
 If(Name <> '')Then
 Begin
  For J := 0 to BF[Pln].MaxFiles do
  Begin
   BF[Pln].GetFile(J,H);
   If((H.Attr and Dir) = Dir)and(H.Name = Name)Then
   Begin
    P[Pln] := J;
    Break;
   End;
  End;
 End;
 If(BF[Pln].MaxFiles > LF[Pln].MaxYTxts)Then M := LF[Pln].MaxYTxts
  Else
 Begin
  Y[Pln] := P[Pln]; M := BF[Pln].MaxFiles;
  LF[Pln].ClrWnBorder(0,M+1,wnMax,wnMax);
 End;
 For I := 0 to M do
 Begin
  BF[Pln].GetFile(P[Pln]-Y[Pln]+I,H);
  PutBar(Pln,I,P[Pln]-Y[Pln]+I,H);
 End;
 PlnNext := (Pln + 1) and 1;
 If(Board[PlnNext] = BoardInfo)Then
 Begin
  LF[PlnNext].SetKrBorderF($B);
  LF[PlnNext].PutTxtXY(1,7,Str(BF[Pln].SizeFiles)+' octet(s)');
  LF[PlnNext].ClrEol;
 End;
 SelectBar(Pln);
 PutSelect(Pln);
End;

Procedure FileManager.kHome;
Var I,M:Byte; H:SearchRec;
Begin
 LF[Plane].SetKrBorderF($B);
 Y[Plane] := 0; P[Plane] := 0;
 If(Board[Plane] = BoardTree)and(BufTree[Plane].MaxBuf > LF[Plane].MaxYTxts)Then M := LF[Plane].MaxYTxts else
 If(BF[Plane].MaxFiles > LF[Plane].MaxYTxts)Then M := LF[Plane].MaxYTxts
  Else
 Begin
  Y[Plane] := P[Plane]; M := BF[Plane].MaxFiles;
  LF[Plane].ClrWnBorder(0,M+1,wnMax,wnMax);
 End;
 If(Board[Plane] = BoardTree)Then
 Begin
  For I := 0 to M do PutBarTree(Plane,I,I);
  SetPath((Plane+1) and 1,GetCurrPathTree(Plane));
 End
  Else
 For I := 0 to M do
 Begin
  BF[Plane].GetFile(P[Plane]-Y[Plane]+I,H);
  PutBar(Plane,I,P[Plane]-Y[Plane]+I,H);
 End;
 SelectBar(Plane);
 PutSelect(Plane);
End;

Procedure FileManager.kEnd;
Var J:Word; H:SearchRec;
Begin
 LF[Plane].SetKrBorderF($B);
 If(Board[Plane] = BoardTree)Then
 Begin
  If(BufTree[Plane].MaxBuf <= LF[Plane].MaxYTxts)Then
  Begin
   UnSelectBar;
   Y[Plane] := BufTree[Plane].MaxBuf; P[Plane] := Y[Plane];
   SelectBar(Plane);
  End
   Else
  Begin
   P[Plane] := BufTree[Plane].MaxBuf; Y[Plane] := LF[Plane].MaxYTxts;
   For J := 0 to LF[Plane].MaxYTxts do PutBarTree(Plane,J,P[Plane]-LF[Plane].MaxYTxts+J);
   SelectBar(Plane);
  End;
  SetPath((Plane+1) and 1,GetCurrPathTree(Plane));
 End
  Else
 Begin
  If(BF[Plane].MaxFiles <= LF[Plane].MaxYTxts)Then
  Begin
   UnSelectBar;
   Y[Plane] := BF[Plane].MaxFiles; P[Plane] := Y[Plane];
   SelectBar(Plane);
   PutSelect(Plane);
  End
   Else
  Begin
   P[Plane] := BF[Plane].MaxFiles; Y[Plane] := LF[Plane].MaxYTxts;
   For J := 0 to LF[Plane].MaxYTxts do
   Begin
    BF[Plane].GetFile(P[Plane]-LF[Plane].MaxYTxts+J,H);
    PutBar(Plane,J,P[Plane]-LF[Plane].MaxYTxts+J,H);
   End;
   SelectBar(Plane);
   PutSelect(Plane);
  End;
 End;
End;

Procedure FileManager.kUp;
Var H:SearchRec;
Begin
 If(Board[Plane] = BoardTree)Then
 Begin
  If(P[Plane] > 0)Then
  Begin
   If(Y[Plane] > 0)Then
   Begin
    UnSelectBar;
    Dec(P[Plane]); Dec(Y[Plane]);
    SelectBar(Plane);
   End
    else
   Begin
    UnSelectBar;
    Dec(P[Plane]);
    LF[Plane].ScrollUp(0,0,wnMax,wnMax);
    PutBarTree(Plane,0,P[Plane]);
    SelectBar(Plane);
   End;
  End;
  SetPath((Plane+1)and 1,GetCurrPathTree(Plane));
 End
  Else
 If(P[Plane] > 0)Then
 Begin
  If(Y[Plane] > 0)Then
  Begin
   UnSelectBar;
   Dec(P[Plane]); Dec(Y[Plane]);
   SelectBar(Plane);
  End
   else
  Begin
   UnSelectBar;
   Dec(P[Plane]);
   LF[Plane].ScrollUp(0,0,wnMax,wnMax);
   BF[Plane].GetFile(P[Plane],H);
   PutBar(Plane,0,P[Plane],H);
   SelectBar(Plane);
  End;
 End;
End;

Procedure FileManager.kDn;
Var H:SearchRec;
Begin
 If(Board[Plane] = BoardTree)Then
 Begin
  If(P[Plane] < BufTree[Plane].MaxBuf)Then
  Begin
   If(Y[Plane] < LF[Plane].MaxYTxts)Then
   Begin
    UnSelectBar;
    Inc(P[Plane]); Inc(Y[Plane]);
    SelectBar(Plane);
   End
    Else
   Begin
    UnSelectBar;
    Inc(P[Plane]);
    LF[Plane].ScrollDn(0,0,wnMax,wnMax);
    PutBarTree(Plane,Y[Plane],P[Plane]);
    SelectBar(Plane);
   End;
  End;
  SetPath((Plane+1)and 1,GetCurrPathTree(Plane));
 End
  Else
 If(P[Plane] < BF[Plane].MaxFiles)Then
 Begin
  If(Y[Plane] < LF[Plane].MaxYTxts)Then
  Begin
   UnSelectBar;
   Inc(P[Plane]); Inc(Y[Plane]);
   SelectBar(Plane);
  End
   Else
  Begin
   UnSelectBar;
   Inc(P[Plane]);
   LF[Plane].ScrollDn(0,0,wnMax,wnMax);
   BF[Plane].GetFile(P[Plane],H);
   PutBar(Plane,Y[Plane],P[Plane],H);
   SelectBar(Plane);
  End;
 End;
End;

Function FileManager.Run;
Var Ok:Bool; K:Word; H:SearchRec; T:PathStr;

 Procedure SelectTitle(Plane:Byte);
 Begin
  If(Plane > 1)Then Exit;
  Case Board[Plane] of
   BoardInfo: LF[Plane]._SetTitleF('Informations',$C);
   BoardFile: LF[Plane]._SetTitleF(Path[Plane],$C);
   BoardTree: LF[Plane]._SetTitleF('Arbre R‚pertoire',$C);
  End;
 End;

 Procedure UnSelTitle(Plane:Byte);
 Begin
  If(Plane > 1)Then Exit;
  Case Board[Plane] of
   BoardInfo: LF[Plane]._SetTitle('Informations');
   BoardFile: LF[Plane]._SetTitle(Path[Plane]);
   BoardTree: LF[Plane]._SetTitle('Arbre R‚pertoire');
  End;
 End;

Begin
 Name := '';
 SelectTitle(Plane);
 Repeat
  Ok := False;
  Case Plane of
  0,1:
  Begin
  K := W.Readk;
  Case K of
   kbInWn : Case LF[Plane].InRightBarMs(LastMsX,LastMsY) of
             kbRightBarMsUp : Begin
              DelayMsPress(100);
              kUp;
             End;
             kbRightBarMsDn : Begin
              DelayMsPress(100);
              kDn;
             End;
             Else
             If(LF[Plane].InTitle(LastMsX,LastMsY))Then
             Begin
              Repeat Until (__GetMouseButton = 0);
              UnSelTitle(Plane);
              Plane := (Plane + 1) and 1;
              ChgBoard;
              SelectTitle(Plane);
             End
              Else
             If(LF[(Plane+1) and 1].InTitle(LastMsX,LastMsY))Then
             Begin
              Repeat Until (__GetMouseButton = 0);
              UnSelTitle(Plane);
              Plane := (Plane + 1) and 1;
              ChgBoard;
              SelectTitle(Plane);
             End
              Else
             If(LF[(Plane+1) and 1].InWn(LastMsX,LastMsY))Then
             Begin
              UnSelTitle(Plane);
              Plane := (Plane + 1) and 1;
              SelectTitle(Plane);
             End
              Else
             If((LastMsY - W.GetRY1) = W.MaxYTxts - 3)Then
             Begin
              UnSelTitle(Plane);
              Plane := 2;
             End
              Else
             If((LastMsY - W.GetRY1) = W.MaxYTxts - 1)Then
             Begin
              UnSelTitle(Plane);
              Plane := 3;
             End;
            End;
    kbTab : Begin
             UnSelTitle(Plane);
             Inc(Plane);
             SelectTitle(Plane);
            End;
kbCtrlLeft: If(Plane = 1)Then
            Begin
             UnSelTitle(1);
             Plane := 0;
             SelectTitle(0);
            End;
kbCtrlRight:If(Plane = 0)Then
            Begin
             UnSelTitle(0);
             Plane := 1;
             SelectTitle(1);
            End;
 kbDelete : If(Board[Plane] = BoardFile)Then DeleteFiles;
kbShiftIns,
kbCtrlIns : If(Board[Plane] = BoardFile)Then CopyFiles;
    kbIns : If(Board[Plane] = BoardFile)Then If(BF[Plane].MaxFiles >= 0)Then
            Begin
             BF[Plane].GetFile(P[Plane],H);
             If((H.Attr and Dir) = 0)Then
             Begin
              Select[Plane]^[P[Plane]] := Not(Select[Plane]^[P[Plane]]);
              If(Select[Plane]^[P[Plane]])Then
              Begin
               Inc(SelFiles[Plane]); Inc(SizeFileSel[Plane],H.Size);
              End
               Else
              Begin
               Dec(SelFiles[Plane]); Dec(SizeFileSel[Plane],H.Size);
              End;
              PutSelect(Plane);
              kDn;
             End;
            End;
   kbHome : If(Board[Plane] in [BoardFile,BoardTree])Then kHome;
    kbEnd : If(Board[Plane] in [BoardFile,BoardTree])Then kEnd;
     kbUp : If(Board[Plane] in [BoardFile,BoardTree])Then kUp;
   kbDown : If(Board[Plane] in [BoardFile,BoardTree])Then kDn;
  kbEnter : If(Board[Plane] = BoardFile)Then
            Begin
             BF[Plane].GetFile(P[Plane],H);
             If((H.Attr and Dir) = Dir)Then
             Begin
              If(Copy(H.Name,1,2) = '..')Then
              Begin
               Name := Path2Dir(Path[Plane]); Dec(Byte(Name[Plane]));
               Name := Path2Name(Name) + Path2Ext(Name);
              End
               Else
              Name := ''; T := Path2NoDir(Path[Plane]);
              Path[Plane] := Path2Dir(Path[Plane]) + H.Name;
              If Not(Path[Plane][Length(Path[Plane])] = '\')Then IncStr(Path[Plane],'\');
              AddStr(Path[Plane],T);
              ReadFiles(Plane);
              SelectTitle(Plane);
             End
              Else
             Begin
              Name := Path2Dir(Path[Plane]) + H.Name; Run := K;
              Exit;
             End;
            End;
       Else Case Char(Lo(K)) of
             '^' : Begin
                    ChgBoard;
                    SelectTitle(Plane);
                   End;
             '*' : Begin
                    ChDsk;
                    SelectTitle(Plane);
                   End;
             '\' : Begin
                    PrincipalPath;
                    SelectTitle(Plane);
                   End;
              Else Ok := True;
            End;
  End;
  End;
  2:
  Begin
  K := W.GetkHorO(W.MaxYTxts-3,'Regarde|Edite|Copie|Renomme|Recherche|Imprime');
  Case K of
    0..5 : Case K of
             2 : CopyFiles;
            Else Ok := True;
           End;
   kbTab : Plane := 3;
      Else Ok := True;
  End;
  End;
  3:
  Begin
  K := W.GetkHorDn('Compile|Convertie|Compresse');
  Case K of
    0..2 : Begin
            Ok := True;
            Inc(K,6);
           End;
   kbTab : Begin
            Plane := 0;
            LF[0]._SetTitleF(Path[0],$C);
           End;
      Else Ok := True;
  End;
  End;
  End;
 Until Ok;
 UnSelTitle(Plane);
 Run := K;
End;

Destructor FileManager.Done;
Begin
 If(Board[1] = BoardFile)Then FreeMem(Select[1],SizeSelect[1]);
 FreeMem(Select[0],SizeSelect[0]);
 LF[1].Done;
 LF[0].Done;
 BF[1].Done;
 BF[0].Done;
 W.Done;
End;

Function SelectDisk(OldChoice:Byte):Byte;
Var DiskTab    : Array[0..25] of Bool;
    DiskLet    : Array[0..25] of Char;
    Res,Ok     : Bool;
    P,I,N,FD,M : Byte; { Number of disk, First disk, maximum }
    W,L        : Wins;
Begin
 SelectDisk := $FF;
 If(OldChoice = 0)Then OldChoice := GetDisk Else Dec(OldChoice);
 N := 0; FD := $FF;
 For I := 0 to 25 do
 Begin
  Res := DiskExist(I); DiskTab[I] := Res;
  If(Res)Then
  Begin
   DiskLet[N] := Char(I+Byte('A')); Inc(N);
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
 L.PushEndBar;
 PutLastBar(2,'S.V.P. S‚lectionnez le lecteur appropri‚');
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

Procedure GetFileInfo;
Label Start,10,20;
Var H:SearchRec; OldPath,Path:PathStr; TmpName:String[12]; SizeSec,P:Word;
Begin
 SizeSec := SectorSize(Drive2Disk(Drive));
 FillChar(Info,SizeOf(Info),0);
 OldPath := Systems.GetPath; P := 0; Path := Drive + ':\';
Start:
 FindFirst(Path+'*.*',$FFFF-VolumeID,H);
10:
 While (DosError = 0) do
 Begin
  If((H.Attr and Dir) = Dir)Then
  Begin
   If(H.Name <> '.')and(H.Name <> '..')Then
   Begin
    Inc(Info.Directory); AddStr(Path,H.Name + '\');
    Buf.AddStrByte(H.Name,P); Inc(P);
    Goto Start;
   End;
  End
   else
  Begin
   Inc(Info.Size,Long(H.Size));
   Inc(Info.NmSector,(Long(H.Size) div Long(SizeSec)));
   If((Long(H.Size) mod Long(SizeSec)) <> 0)Then Inc(Info.NmSector);
   Inc(Info.NmFile);
   If((H.Attr and Archive) = Archive)Then
   Begin
    Inc(Info.SizeArchive,Long(H.Size)); Inc(Info.ArchiveFile);
   End;
   If((H.Attr and Hidden) = Hidden)Then
   Begin
    Inc(Info.SizeHidden,Long(H.Size)); Inc(Info.HiddenFile);
   End;
   If((H.Attr and ReadOnly) = ReadOnly)Then
   Begin
    Inc(Info.SizeReadOnly,Long(H.Size)); Inc(Info.ReadOnlyFile);
   End;
   If((H.Attr and SysFile) = SysFile)Then
   Begin
    Inc(Info.SizeSys,Long(H.Size)); Inc(Info.SysFile);
   End;
  End;
  FindNext(H);
 End;
 If(Length(Path) > 3)Then
 Begin
20:
  TmpName := ''; BackStr(Path); Dec(P);
  While (Path[Length(Path)] <> '\') do
  Begin
   TmpName := Path[Length(Path)] + TmpName;
   BackStr(Path);
  End;
  FindFirst(Path+'*.*',$FFFF-VolumeID,H);
  While Not(H.Name = TmpName) do
  Begin
   FindNext(H);
   If(DosError <> 0)Then Goto 20;
  End;
  FindNext(H);
  Goto 10;
 End;
 ChDir(OldPath);
End;

BEGIN
END.