Unit MalEnv;

INTERFACE

Uses MM,Math,Images,MLibrary,Memorys,Editor,
     EditButt,TeleMate,Terminal,FileManagers,ToolTerm,QHexView,MalCalc,
     MalWatch,MalViewAscii,AppleII,Coco3,CK64,ToolTM,Mems,Windows,
     TMDials,Dials,Spooler;

Const

      wnMin = 1;
      wnMax = 24;

      wnEdit            = 1;
      wnView            = 2;
      wnButtonEdit      = 3;
      wnDraw            = 4;
      wnLotus           = 5;
      wnFileManager     = 6;
      wnMDos            = 7;
      wnOutput          = 8;
      wnMusicMod        = 9;
      wnDial            = 10;
      wnTerminal        = 11;
      wnTerm            = wnTerminal;
      wnMacro           = 12;
      wnWatch           = 13;
      wnHelp            = 14;
      wnHlp             = wnHelp;
      wnPersonalJournal = 15;
      wnPJ              = wnPersonalJournal;
      wnCalculator      = 16;
      wnCalendriar      = 17;
      wnAgenda          = 18;
      wnCatDisk         = 19;
      wnHexView         = 20;
      wnCoco3           = 21;
      wnCommodore64     = 22;
      wnAppleII         = 23;
      wnTermPrn         = 24;
      wnUnix            = 25;

Type

     WinRec = Record
	       Model : Byte;
	       P     : Record Case Byte of
			 1:(Edit:Edt);
			 2:(ViewAscii:ViewAsciiWin);
			 3:(ButtonEdit:ButtonEditor);
			 4:(DrawEdit:DrawWins);
			 5:(Lotus:Calc);
			 6:(FM:FileManager);
			 7:(Shell:MDos);
			10:(Dial:DialWn);
			11:(Terminal:TermAtlas);
			13:(Watch:WatchWin);
			14:(Hlp:Edt);
			16:(Calculator:Calc);
			20:(HexVw:HexView);
			21:(Coco3:Coco3Emul);
			22:(CK64:CK64Emul);
			23:(AppleII:AppleII2Emul);
			24:(TPrn:TermPrn);
			25:(Unix:MUnix);
		       End;
	      End;

Const

       SizeOfWin = SizeOf(WinRec);

Var

    DrawMode       : Byte;
    _Windows       : RBuf;
    CurrEdit       : Long;
    Ptr            : Pointer;
    WinPtr         : ^WinRec Absolute Ptr;
    But,ButDraw    : ButtonMnu;
    BackgroundPlay : Bool;

Procedure InitScreen;
Procedure PutFreeMemory;
Procedure Run;
Procedure SetMnuSwitch;

IMPLEMENTATION

Uses Strings,Strs,Sound,Printers,Mouse,Language,Systems,Clock,Dos,
     Keyboard,Video,MalMnu,MalSDir,MalInfo,MalBKRes,Cursor,
     MalCompiler,MalComRC,MalCMPas,MalEnvOverlay,
     ToolEdit,ToolPrn,ToolVid,MalLibrary,ToolLang;

Procedure PutFreeMemory;
Begin
 PutTextXYUnCol(57,MaxYTxts-1,StrUSpc(Str(MemAvail),14));
End;

Procedure SetMnuSwitch;
Var X : Byte;
Begin
 DoneMnu;
 If(_Windows.NmBuf = 0)Then
 Begin
  IsLine   := False;
  IsBox    := False;
  IsCircle := False;
  IsPaint  := False;
  IsTrace  := False;
  IsText   := False;
  MalMnu.DrawMode := False;
  InitMnu(0,0);
 End
  Else
 Begin
  X := 0;
  If(WinPtr^.Model = wnEdit)Then X := WinPtr^.P.Edit.GetViewMode;
  InitMnu(WinPtr^.Model,X);
  Case WinPtr^.Model of
	  wnEdit : Begin
		    IsLine   := False;
		    IsBox    := False;
		    IsCircle := False;
		    IsPaint  := False;
		    IsTrace  := False;
		    IsText   := True;
		    MalMnu.DrawMode := WinPtr^.P.Edit.DrawMode;
		   End;
	  wnDraw,
    wnButtonEdit : Begin
		    IsLine   := (DrawMode = drwLine);
		    IsBox    := (DrawMode = drwBox);
		    IsCircle := (DrawMode = drwCircle);
		    IsPaint  := (DrawMode = drwPaint);
		    IsTrace  := (DrawMode = drwTrace);
		    IsText   := (DrawMode = drwText);
		    MalMnu.DrawMode := False;
		   End;
  End;
 End;
 M.SetWinBar(0,1,MaxXTxts);
 M.PutMnuBar;
 DefaultEndBar;
End;

Procedure WindowMDos;
Var X1,Y1,X2,Y2 : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnMDos;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.Shell.Init(X1,Y1,X2,Y2);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure WindowMUnix;
Var X1,Y1,X2,Y2 : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnUnix;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.Unix.Init(X1,Y1,X2,Y2);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure WindowFileManager;
Var X1,Y1,X2,Y2 : Byte;
Begin
 Ptr := _Windows._AddBuf(SizeOfWin);
 If(Ptr = NIL)Then Exit;
 WinPtr^.Model := wnFileManager;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.FM.InitWin(X1,Y1,X2,Y2);
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Procedure WindowDial;
Var Path        : PathStr;
    X1,Y1,X2,Y2 : Byte;
Begin
 Path := OpenWin('*.FON','Ouvre Dial');
 If Not(Path = '')Then
 Begin
  Ptr := _Windows._AddBuf(SizeOfWin);
  If(Ptr = NIL)Then Exit;
  WinPtr^.Model := wnDial;
  GetNextWnPos(X1,Y1,X2,Y2);
  WinPtr^.P.Dial.InitWin(X1,Y1,X2,Y2,Path);
  CurrEdit := _Windows.MaxBuf;
  SetMnuSwitch;
 End;
End;

Procedure OpenDraw;
Var Path : PathStr;
    SR   : ImgStruct;
Begin
 Path := OpenWin('*.*','Ouvre Dessin');
 If Not(Path = '')Then
 Begin
  _Windows.AddBuf(SizeOfWin,Ptr);
  WinPtr^.Model := wnDraw;
  GetNextWnPos(SR.X1,SR.Y1,SR.X2,SR.Y2);
  SR.BitsPerPix := 8; SR.NmXPixs := 640; SR.NmYPixs := 480; SR.BaseColor := 1;
  WinPtr^.P.DrawEdit.Init(Path,SR);
  CurrEdit := _Windows.MaxBuf;
 End;
 SetMnuSwitch;
End;

Procedure OpenButtonEdit;
Var Path:PathStr; X1,Y1,X2,Y2:Byte;
Begin
 Path := OpenWin('*.MGB','Ouvre Bouton');
 If Not(Path = '')Then
 Begin
  _Windows.AddBuf(SizeOfWin,Ptr);
  WinPtr^.Model := wnButtonEdit;
  GetNextWnPos(X1,Y1,X2,Y2);
  WinPtr^.P.ButtonEdit.InitWin(X1,Y1,X2,Y2,Path);
  CurrEdit := _Windows.MaxBuf;
 End;
 SetMnuSwitch;
End;

Procedure ListEdit;
Var List    : LstMnu;
    K       : Word;
    I       : Long;
    EditorP : ^Edt;
Begin
 List.Init(10,4,MaxXTxts-10,MaxYTxts-4,'Liste Fenˆtre',CurrColors.Dialog.Wins);
 For I := 0 to _Windows.MaxBuf do
 Begin
  WinPtr := _Windows._GetBuf(I);
  Case WinPtr^.Model of
	 wnEdit : List.AddStrByte('Editeur Texte '+WinPtr^.P.Edit.GetName,I+1);
   wnButtonEdit : List.AddStrByte('Editeur Bouton '+WinPtr^.P.ButtonEdit.GetName,I+1);
	 wnDraw : List.AddStrByte('Editeur dessin ',I+1);
	 wnMDos : List.AddStrByte('Malte-Dos (Shell)',I+1);
      wnTermPrn : List.AddStrByte('Terminal d''Imprimante',I+1);
	 wnTerm : List.AddStrByte('Terminal',I+1);
	 wnDial : List.AddStrByte('Dial',I+1);
  wnFileManager : List.AddStrByte('Gestionnaire Fichier '+WinPtr^.P.FM.GetPath,I+1);
      wnHexView : List.AddStrByte('Edite/Regarde Hexad‚cimal '+WinPtr^.P.HexVw.GetPath,I+1);
  End;
 End;
 K := List.Run;
 List.Done;
 If(_Windows.NmBuf > 0)and(K > 0)Then
 Begin
  CurrEdit := K - 1;
  WinPtr := _Windows._GetBuf(CurrEdit);
  Case WinPtr^.Model of
	 wnEdit : WinPtr^.P.Edit.Refresh;
   wnButtonEdit : WinPtr^.P.ButtonEdit.Refresh;
	 wnDraw : WinPtr^.P.DrawEdit.Refresh;
	 wnTerm : WinPtr^.P.Terminal.Refresh;
      wnTermPrn : WinPtr^.P.TPrn.Refresh;
  wnFileManager : WinPtr^.P.FM.Refresh;
      wnHexView : WinPtr^.P.HexVw.Refresh;
	  wnHlp : WinPtr^.P.Hlp.Refresh;
      wnAppleII : WinPtr^.P.AppleII.Refresh;
	wnCoco3 : WinPtr^.P.Coco3.Refresh;
  wnCommodore64 : WinPtr^.P.CK64.Refresh;
  End;
 End
  Else
 WinPtr := _Windows._GetBuf(CurrEdit);
 SetMnuSwitch;
End;

Procedure EditCharType;
Var List : LstMnu;
    K    : Byte;
Begin
 With List do
 Begin
  Init(20,4,MaxXTxts-20,MaxYTxts-4,'Type CaractŠre',CurrColors.Dialog.Wins);
  AddPChrByte('Normal',CharNormal);
  AddPChrByte('Gras',CharBold);
  AddPChrByte('Souligne',CharUnderline);
  AddPChrByte('Italique',CharItalic);
  AddPChrByte('Inverse',CharInverse);
  AddPChrByte('Double',CharDouble);
  AddPChrByte('Double & Soulign‚',CharDouble+CharUnderline);
  K := Run;
  Done;
  Case WinPtr^.Model of
   wnEdit : WinPtr^.P.Edit.SetChrType(K);
  End;
 End;
End;

Procedure EditCurrModeType;
Var List : LstMnu;
    K    : Byte;
Begin
 With List do
 Begin
  Init(20,4,MaxXTxts-20,MaxYTxts-4,'Mode affichage',CurrColors.Dialog.Wins);
  AddPChrByte('Normal',ViewDefault);
  AddPChrByte('Langage Ada',ViewAda);
  AddPChrByte('Langage Assembler',ViewAsm);
  AddPChrByte('Langage Basic',ViewBas);
  AddPChrByte('Langage C/C++',ViewC);
  AddPChrByte('Langage Cobol',ViewCobol);
  AddPChrByte('Langage Euphoria',ViewEuphoria);
  AddPChrByte('Langage Forth',ViewForth);
  AddPChrByte('Langage Fortran',ViewFortran);
  AddPChrByte('Ini (Configuration)',ViewIni);
  AddPChrByte('Mouse Menu',ViewMsMnu);
  AddPChrByte('Langage Pascal',ViewPas);
  AddPChrByte('Professionnel Write',ViewPW);
  AddPChrByte('Resource',ViewRC);
  AddPChrByte('Genesis Ascii Traitement Texte',ViewGAT);
  K := Run;
  Done;
  Case WinPtr^.Model of
   wnEdit : WinPtr^.P.Edit.SetViewMode(K);
  End;
 End;
End;

Procedure InitScreen;
Var Name:PathStr;
Begin
 PutTapis(0,MaxYTxts,$19);
 BarSpaceHori(0,0,MaxXTxts,$1F);
 PutCloseIcon(0,0,$F);
 PutTextCenter(0,__Justified__,'MalteBook (L''Oeuvre Inhumaine)',$1F);
 M.SetWinBar(0,1,MaxXTxts);
 M.PutMnuBar;
 If(GetBitsPerPixel < 4)Then Name := 'MALBOO2.MGB'
			Else Name := 'MALBOOK.MGB';
 But.LoadAll(SetPath4AddFile(StrPas(PathSystems))+Name,0,2);
 ButDraw.LoadAllVert(SetPath4AddFile(StrPas(PathSystems))+'MBDRAW.MGB',0,2+But.UseYTexts,3);
 BarSpaceHori(0,MaxYTxts-1,MaxXTxts,$F0);
 BarSpaceHori(0,MaxYTxts,MaxXTxts,$1F);
 YEditor := 1 + But.UseYTexts;
 SetPosTime(2,MaxYTxts-1);
 SetChar(11,MaxYTxts-1,'³');
 SetPosTimeAfterEndOfDay(13,MaxYTxts-1);
 SetChar(22,MaxYTxts-1,'³');
 SetPosTimeInPrg(24,MaxYTxts-1);
 SetChar(33,MaxYTxts-1,'³');
 SetPosTimeMod(35,MaxYTxts-1);
 SetChar(44,MaxYTxts-1,'³');
 SetPosTimeOnLine(46,MaxYTxts-1);
 SetChar(55,MaxYTxts-1,'³');
 PutFreeMemory;
 DefaultEndBar;
 __InitMouse;
End;

Procedure SetDrawMode(M:Byte);
Begin
 DrawMode := M;
 Case WinPtr^.Model of
  wnButtonEdit : WinPtr^.P.ButtonEdit.SetMode(DrawMode);
	wnDraw : WinPtr^.P.DrawEdit.SetMode(DrawMode);
 End;
 SetMnuSwitch;
End;

Procedure PrintersSetup;
Var Prn : SetupPrn;
Begin
 Prn.Init(XEditor,YEditor);
 Prn.Run;
 Prn.Done;
End;

Procedure SetFormat;
Var X1,X2:Word; Y1,Y2:Long;
Begin
 Case WinPtr^.Model of
  wnEdit : If(WinPtr^.P.Edit.GetViewMode = ViewGAT)Then
	   Begin
	    X1 := WinPtr^.P.Edit.XW1;
	    X2 := WinPtr^.P.Edit.XW2;
	    Y1 := WinPtr^.P.Edit.YW1;
	    Y2 := WinPtr^.P.Edit.YW2;
	    If(SetFormatPage(X1,Y1,X2,Y2))Then
	    Begin
	     WinPtr^.P.Edit.XW1 := X1;
	     WinPtr^.P.Edit.XW2 := X2;
	     WinPtr^.P.Edit.YW1 := Y1;
	     WinPtr^.P.Edit.YW2 := Y2;
	     If(X1 > 0)Then WinPtr^.P.Edit.InsSpcIfHome(X1);
	    End;
	   End;
 End;
End;

Procedure Compile;
Begin
 Case WinPtr^.Model of
  wnEdit : Begin
	    If Not(CompileRC)Then
	    Begin
	     WinPtr^.P.Edit.GotoXY(ErrI,ErrJ);
	     SimpleCursor;
	     WinPtr^.P.Edit.SetCur;
	     SetAllColor($CE,$CF);
	     PutLastBar(2,'Erreur '+Str(Abs(ErrCode))+' : ^'+ErrStr(ErrCode)+'^');
	     Repeat Until Keypressed;
	     CloseCursor;
	    End;
	    DefaultEndBar;
	   End;
 End;
End;

Procedure Compress;
Begin
 Case WinPtr^.Model of
  wnEdit : Begin
	    If Not(CompressPas)Then
	    Begin
	     WinPtr^.P.Edit.GotoXY(ErrI,ErrJ);
	     SimpleCursor;
	     WinPtr^.P.Edit.SetCur;
	     SetAllColor($CE,$CF);
	     PutLastBar(2,'Erreur '+Str(Abs(ErrCode))+' : ^'+ErrStr(ErrCode)+'^');
	     Repeat Until Keypressed;
	     CloseCursor;
	    End;
	    DefaultEndBar;
	   End;
 End;
End;

Procedure ViewOption;
Var X,Y  : Byte;
    Path : PathStr;
Begin
 If(WinPtr^.Model = wnFileManager)Then
 Begin
  Path := WinPtr^.P.FM.GetCurrName;
  _Windows.AddBuf(SizeOfWin,Ptr);
  WinPtr^.Model := wnHexView;
  GetNextWnMin(HexViewNumXTxts,HexViewNumYTxts,X,Y);
  WinPtr^.P.HexVw.Init(X,Y,Path);
  CurrEdit := _Windows.MaxBuf;
  SetMnuSwitch;
 End;
End;

Procedure MoveFiles;
Var Name : String;
Begin
 If(WinPtr^.Model = WnFileManager)Then
 Begin
  Name := '';
  If(WinInp(40,'Mouve Fichier','Entrez le nom du r‚pertoire destination',
	    CurrColors.Dialog.Wins,Name) = kbYes)Then
  Begin
   If(Pos('.',Name) = 0)Then
   Begin
    If(Name[Length(Name)] <> '\')Then IncStr(Name,'\');
    AddStr(Name,Path2NoDir(WinPtr^.P.FM.GetCurrName));
   End;
   MoveFile(WinPtr^.P.FM.GetCurrName,Name);
   WinPtr^.P.FM.ReadFiles(WinPtr^.P.FM.Plane);
  End;
 End;
End;

Procedure XAltF1Key;
Var Disk,Out : Byte;
Begin
 Case WinPtr^.Model of
  wnFileManager :
  Begin
   Disk := Path2Disk(WinPtr^.P.FM.GetPath) + 1;
   Out  := SelectDisk(Disk);
   If(Out = $FF)Then Exit;
   If(Out <> Disk)Then
   Begin
    WinPtr^.P.FM.SetPath(WinPtr^.P.FM.Plane,Char(Out+Byte('@'))+':*.*');
   End;
  End;
 End;
End;

Procedure EditDrawMode;
Begin
 If(WinPtr^.Model = wnEdit)Then
 Begin
  WinPtr^.P.Edit.SetDrawMode(Not(WinPtr^.P.Edit.DrawMode));
  SetMnuSwitch;
 End;
End;

Const

      cmdNone              = 0;
      cmdEmulAppleII       = 1;
      cmdEmulCK64          = 2;
      cmdEmulCoco3         = 3;
      cmdEmulVIC20         = 4;
      cmdNewBasCoco3       = 5;
      cmdNewButt           = 6;
      cmdNewDial           = 7;
      cmdNewDrw            = 8;
      cmdNewEdt            = 9;
      cmdNewFileManagers   = 10;
      cmdNewGatt           = 11;
      cmdNewMDos           = 12;
      cmdNewPJ             = 13;
      cmdNewSuperCalc      = 14;
      cmdNewTerm           = 15;
      cmdNewUnix           = 16;
      cmdHostMode          = 17;
      cmdOpenAC            = 18;
      cmdOpenAsm           = 19;
      cmdOpenBas           = 20;
      cmdOpenBasAppleII    = 21;
      cmdOpenBasCK64       = 22;
      cmdOpenBasCoco3      = 23;
      cmdOpenButtEdt       = 24;
      cmdOpenC             = 25;
      cmdOpenCobol         = 26;
      cmdOpenDrw           = 27;
      cmdOpenEdt           = 28;
      cmdOpenEuphoria      = 29;
      cmdOpenFortran       = 30;
      cmdOpenGatt          = 31;
      cmdOpenMod           = 32;
      cmdOpenPas           = 33;
      cmdOpenRC            = 34;
      cmdOpenSuperCalc     = 35;
      cmdOpenCountry       = 36;
      cmdOpenView          = 37;
      cmdOpenPckAC         = 38;
      cmdOpenPckAsm        = 39;
      cmdOpenPckBas        = 40;
      cmdOpenPckBasAppleII = 41;
      cmdOpenPckBasCK64    = 42;
      cmdOpenPckBasCoco3   = 43;
      cmdOpenPckC          = 44;
      cmdOpenPckCobol      = 45;
      cmdOpenPckDrw        = 46;
      cmdOpenPckEdt        = 47;
      cmdOpenPckEuphoria   = 48;
      cmdOpenPckFortran    = 49;
      cmdOpenPckGatt       = 50;
      cmdOpenPckPas        = 51;
      cmdOpenPckRC         = 52;
      cmdHelp              = 53;
      cmdSave              = 54;
      cmdPrint             = 55;
      cmdMoveFiles         = 56;
      cmdAssign            = 57;
      cmdAwk               = 58;
      cmdGrep              = 59;
      cmdExec              = 60;
      cmdJoinDsk           = 61;
      cmdJoinPath          = 62;
      cmdShell             = 63;
      cmdChDsk             = 64;
      cmdMkDir             = 65;
      cmdDskDoctor         = 66;
      cmdHardDiskPark      = 67;
      cmdViewEdtDsk        = 68;
      cmdHexViewEdtDsk     = 69;
      cmdHexEdt            = 70;
      cmdFormatDsk         = 71;
      cmdDskOption         = 72;
      cmdDelFile           = 73;
      cmdDoctorVirus       = 74;
      cmdCompile           = 75;
      cmdCompress          = 76;
      cmdConv2AC           = 77;
      cmdConv2Bas          = 78;
      cmdConv2C            = 79;
      cmdConv2Cobol        = 80;
      cmdConv2Fortran      = 81;
      cmdConv2Pas          = 82;
      cmdConv2RC           = 83;
      cmdTxtBoldWord       = 84;
      cmdTxtUnderlnWord    = 85;
      cmdTxtItalicWord     = 86;
      cmdTxtDblWord        = 87;
      cmdTxtInverseWord    = 88;
      cmdTxtDelSpc         = 89;
      cmdTxtDelWord        = 90;
      cmdTxtMarge          = 91;
      cmdTxtPgUp           = 92;
      cmdDelCurrCol        = 93;
      cmdDelCurrLn         = 94;
      cmdDelCurrMatrix     = 95;
      cmdInsCurrCol        = 96;
      cmdInsCurrLn         = 97;
      cmdInsCurrMatrix     = 98;
      cmdGotoLn            = 99;
      cmdSearch            = 100;
      cmdReplace           = 101;
      cmdEditMode          = 102;
      cmdChrType           = 103;
      cmdCenterTxt         = 104;
      cmdTxtBold           = 105;
      cmdTxtDbl            = 106;
      cmdTxtItalic         = 107;
      cmdTxtInverse        = 108;
      cmdTxtUnderln        = 109;
      cmdLnMode            = 110;
      cmdBoxMode           = 111;
      cmdCircleMode        = 112;
      cmdPaintMode         = 113;
      cmdTraceMode         = 114;
      cmdTextMode          = 115;
      cmdDrawMode          = 116;
      cmdChgColor          = 117;
      cmdDrwNewPgButt      = 118;
      cmdDrwChgPgButt      = 119;
      cmdPlayMod           = 120;
      cmdStopPlayMod       = 121;
      cmdPrnSetup          = 122;
      cmdOptionVid         = 123;
      cmdSetVideoMode      = 124;
      cmdCmosInfo          = 125;
      cmdInternalInfo      = 126;
      cmdSomaryInfo        = 127;
      cmdVidInfo           = 128;
      cmdDskInfo           = 129;
      cmdRun               = 130;
      cmdSetMarge          = 131;
      cmdSetDirSetup       = 132;
      cmdLstWn             = 133;
      cmdPreviousWn        = 134;
      cmdNextWn            = 135;
      cmdCloseWn           = 136;
      cmdCloseAllWn        = 137;
      cmdCloseAllWnSaved   = 138;
      cmdRefreshWn         = 139;
      cmdPgUp              = 140;
      cmdPgDn              = 141;
      cmdLeft              = 142;
      cmdRight             = 143;
      cmdUp                = 144;
      cmd2Up               = 145;
      cmdDn                = 146;
      cmdTermWelcome       = 147;
      cmdViewDownload      = 148;
      cmdBoard             = 149;
      cmdDoctorSys         = 150;
      cmdCurrListFiles     = 151;
      cmdExecMacro         = 152;
      cmdNewTermPrn        = 153;
      cmdSaveAs            = 154;
      cmdExit              = 155;

      DefaultMaxKey = 90;

      MaxKey : Word = DefaultMaxKey;

Type

      ButtSwitchType = Array[0..DefaultMaxKey] of Record
       KeyA,KeyB:Word;
       Option:Byte;
      End;

Const

      ButtSwitch : ButtSwitchType = (
		    (KeyA:kbF2;   KeyB:kbNoKey;Option:cmdSave),
		    (KeyA:kbF3;   KeyB:kbNoKey;Option:cmdOpenEdt),
		    (KeyA:kbF4;   KeyB:kbNoKey;Option:cmdHexEdt),
		    (KeyA:kbF5;   KeyB:kbNoKey;Option:cmdMoveFiles),
		    (KeyA:kbF6;   KeyB:kbNoKey;Option:cmdNextWn),
		    (KeyA:kbF7;   KeyB:kbNoKey;Option:cmdMkDir),
		    (KeyA:kbF8;   KeyB:kbNoKey;Option:cmdDelFile),
		    (KeyA:kbAlt0; KeyB:kbNoKey;Option:cmdLstWn),
		    (KeyA:kbAltX; KeyB:kbNoKey;Option:cmdExit),
		    (KeyA:kbAltF1;KeyB:kbNoKey;Option:cmdChDsk),
		    (KeyA:kbAltF3;KeyB:kbNoKey;Option:cmdCloseWn),
		    (KeyA:kbAltF9;KeyB:kbNoKey;Option:cmdCompile),
		    (KeyA:kbCtrlA;KeyB:kbNoKey;Option:cmdLeft),
		    (KeyA:kbCtrlB;KeyB:kbNoKey;Option:cmdTxtBoldWord),
		    (KeyA:kbCtrlC;KeyB:kbCtrlA;Option:cmdCloseAllWn),
		    (KeyA:kbCtrlC;KeyB:kbCtrlB;Option:cmdConv2Bas),
		    (KeyA:kbCtrlC;KeyB:kbCtrlC;Option:cmdPgUp),
		    (KeyA:kbCtrlC;KeyB:kbCtrlD;Option:cmdTxtDbl),
		    (KeyA:kbCtrlC;KeyB:kbCtrlF;Option:cmdConv2Fortran),
		    (KeyA:kbCtrlC;KeyB:kbCtrlG;Option:cmdTxtBold),
		    (KeyA:kbCtrlC;KeyB:kbCtrlI;Option:cmdTxtInverse),
		    (KeyA:kbCtrlC;KeyB:kbCtrlK;Option:cmdConv2AC),
		    (KeyA:kbCtrlC;KeyB:kbCtrlL;Option:cmdConv2Cobol),
		    (KeyA:kbCtrlC;KeyB:kbCtrlP;Option:cmdConv2Pas),
		    (KeyA:kbCtrlC;KeyB:kbCtrlR;Option:cmdConv2RC),
		    (KeyA:kbCtrlC;KeyB:kbCtrlS;Option:cmdCloseAllWnSaved),
		    (KeyA:kbCtrlC;KeyB:kbCtrlT;Option:cmdTxtItalic),
		    (KeyA:kbCtrlC;KeyB:kbCtrlU;Option:cmdTxtUnderln),
		    (KeyA:kbCtrlC;KeyB:kbCtrlZ;Option:cmdConv2C),
		    (KeyA:kbCtrlD;KeyB:kbCtrlC;Option:cmdChDsk),
		    (KeyA:kbCtrlD;KeyB:kbCtrlD;Option:cmdDskDoctor),
		    (KeyA:kbCtrlD;KeyB:kbCtrlE;Option:cmdViewEdtDsk),
		    (KeyA:kbCtrlD;KeyB:kbCtrlF;Option:cmdFormatDsk),
		    (KeyA:kbCtrlD;KeyB:kbCtrlH;Option:cmdHexViewEdtDsk),
		    (KeyA:kbCtrlD;KeyB:kbCtrlI;Option:cmdDskInfo),
		    (KeyA:kbCtrlD;KeyB:kbCtrlO;Option:cmdDskOption),
		    (KeyA:kbCtrlD;KeyB:kbCtrlS;Option:cmdDoctorSys),
		    (KeyA:kbCtrlD;KeyB:kbCtrlV;Option:cmdDoctorVirus),
		    (KeyA:kbCtrlD;KeyB:kbCtrlX;Option:cmdDelCurrCol),
		    (KeyA:kbCtrlD;KeyB:kbCtrlY;Option:cmdDelCurrLn),
		    (KeyA:kbCtrlD;KeyB:kbCtrlZ;Option:cmdDelCurrMatrix),
		    (KeyA:kbCtrlE;KeyB:kbCtrlA;Option:cmdEmulAppleII),
		    (KeyA:kbCtrlE;KeyB:kbCtrlC;Option:cmdEmulCoco3),
		    (KeyA:kbCtrlE;KeyB:kbCtrlE;Option:cmd2Up),
		    (KeyA:kbCtrlE;KeyB:kbCtrlH;Option:cmdHexEdt),
		    (KeyA:kbCtrlE;KeyB:kbCtrlK;Option:cmdEmulCK64),
		    (KeyA:kbCtrlE;KeyB:kbCtrlM;Option:cmdExecMacro),
		    (KeyA:kbCtrlE;KeyB:kbCtrlV;Option:cmdEmulVic20),
		    (KeyA:kbCtrlF;KeyB:kbCtrlA;Option:cmdAssign),
		    (KeyA:kbCtrlF;KeyB:kbCtrlB;Option:cmdAwk),
		    (KeyA:kbCtrlF;KeyB:kbCtrlC;Option:cmdExec),
		    (KeyA:kbCtrlF;KeyB:kbCtrlD;Option:cmdNewMDos),
		    (KeyA:kbCtrlF;KeyB:kbCtrlE;Option:cmdDelFile),
		    (KeyA:kbCtrlF;KeyB:kbCtrlF;Option:cmdNewFileManagers),
		    (KeyA:kbCtrlF;KeyB:kbCtrlG;Option:cmdGrep),
		    (KeyA:kbCtrlF;KeyB:kbCtrlL;Option:cmdCurrListFiles),
		    (KeyA:kbCtrlF;KeyB:kbCtrlM;Option:cmdMkDir),
		    (KeyA:kbCtrlF;KeyB:kbCtrlU;Option:cmdNewUnix),
		    (KeyA:kbCtrlH;KeyB:kbCtrlM;Option:cmdHostMode),
		    (KeyA:kbCtrlI;KeyB:kbCtrlC;Option:cmdCmosInfo),
		    (KeyA:kbCtrlI;KeyB:kbCtrlI;Option:cmdInternalInfo),
		    (KeyA:kbCtrlI;KeyB:kbCtrlS;Option:cmdSomaryInfo),
		    (KeyA:kbCtrlK;KeyB:kbCtrlD;Option:cmdExit),
		    (KeyA:kbCtrlK;KeyB:kbCtrlS;Option:cmdSave),
		    (KeyA:kbCtrlM;KeyB:kbCtrlH;Option:cmdHostMode),
		    (KeyA:kbCtrlN;KeyB:kbCtrlG;Option:cmdNewGatt),
		    (KeyA:kbCtrlN;KeyB:kbCtrlY;Option:cmdNewBasCoco3),
		    (KeyA:kbCtrlO;KeyB:kbCtrlA;Option:cmdOpenAsm),
		    (KeyA:kbCtrlO;KeyB:kbCtrlB;Option:cmdOpenButtEdt),
		    (KeyA:kbCtrlO;KeyB:kbCtrlC;Option:cmdOpenSuperCalc),
		    (KeyA:kbCtrlO;KeyB:kbCtrlD;Option:cmdOpenDrw),
		    (KeyA:kbCtrlO;KeyB:kbCtrlE;Option:cmdOpenEuphoria),
		    (KeyA:kbCtrlO;KeyB:kbCtrlF;Option:cmdOpenFortran),
		    (KeyA:kbCtrlO;KeyB:kbCtrlG;Option:cmdOpenGatt),
		    (KeyA:kbCtrlO;KeyB:kbCtrlK;Option:cmdOpenAC),
		    (KeyA:kbCtrlO;KeyB:kbCtrlL;Option:cmdOpenCobol),
		    (KeyA:kbCtrlO;KeyB:kbCtrlM;Option:cmdOpenMod),
		    (KeyA:kbCtrlO;KeyB:kbCtrlP;Option:cmdOpenPas),
		    (KeyA:kbCtrlO;KeyB:kbCtrlQ;Option:cmdOpenBas),
		    (KeyA:kbCtrlO;KeyB:kbCtrlR;Option:cmdOpenRC),
		    (KeyA:kbCtrlO;KeyB:kbCtrlW;Option:cmdOpenBasAppleII),
		    (KeyA:kbCtrlO;KeyB:kbCtrlX;Option:cmdOpenBasCK64),
		    (KeyA:kbCtrlO;KeyB:kbCtrlY;Option:cmdOpenBasCoco3),
		    (KeyA:kbCtrlO;KeyB:kbCtrlZ;Option:cmdOpenC),
		    (KeyA:kbCtrlP;KeyB:kbCtrlM;Option:cmdPlayMod),
		    (KeyA:kbCtrlP;KeyB:kbCtrlS;Option:cmdStopPlayMod),
		    (KeyA:kbCtrlS;KeyB:kbNoKey;Option:cmdTxtDelSpc),
		    (KeyA:kbCtrlU;KeyB:kbNoKey;Option:cmdTxtUnderlnWord),
		    (KeyA:kbCtrlX;KeyB:kbNoKey;Option:cmdCenterTxt),
		    (KeyA:kbCtrlF10;KeyB:kbNoKey;Option:cmdCompress),
		    (KeyA:kbShiftF6;KeyB:kbNoKey;Option:cmdPreviousWn)
		   );

     ButtSwitchPtr : ^ButtSwitchType = @ButtSwitch;

     cmdDefault : Set of Byte = [cmdNone,cmdEmulAppleII,
		   cmdEmulCK64,cmdEmulCoco3,cmdEmulVIC20,cmdNewBasCoco3,
		   cmdNewButt,cmdNewDial,cmdNewDrw,cmdNewEdt,cmdNewFileManagers,
		   cmdNewGatt,cmdNewMDos,cmdNewPJ,cmdNewSuperCalc,cmdNewTerm,cmdNewTermPrn,
		   cmdNewUnix,cmdOpenAC,cmdOpenAsm,cmdOpenBas,cmdOpenBasAppleII,
		   cmdOpenBasCK64,cmdOpenBasCoco3,cmdOpenButtEdt,cmdOpenC,
		   cmdOpenCobol,cmdOpenDrw,cmdOpenEdt,cmdOpenEuphoria,
		   cmdOpenFortran,cmdOpenGatt,cmdOpenMod,cmdOpenPas,cmdOpenRC,
		   cmdOpenSuperCalc,cmdOpenCountry,cmdOpenView,cmdOpenPckAC,
		   cmdOpenPckAsm,cmdOpenPckBas,cmdOpenPckBasAppleII,cmdOpenPckBasCK64,
		   cmdOpenPckBasCoco3,cmdOpenPckC,cmdOpenPckCobol,cmdOpenPckDrw,
		   cmdOpenPckEdt,cmdOpenPckEuphoria,cmdOpenPckFortran,cmdOpenPckGatt,
		   cmdOpenPckPas,cmdOpenPckRC,cmdHelp,cmdShell,cmdChDsk,cmdMkDir,
		   cmdDskDoctor,cmdHardDiskPark,cmdFormatDsk,cmdDskOption,
		   cmdDoctorVirus,cmdPlayMod,cmdStopPlayMod,cmdPrnSetup,cmdOptionVid,
		   cmdSetVideoMode,cmdSomaryInfo,cmdVidInfo,cmdDskInfo,
		   cmdSetDirSetup,cmdHexEdt,cmdExit];

     cmdDefaultOpen : Set of Byte = [cmdLstWn,cmdPreviousWn,cmdNextWn,
		       cmdCloseWn,cmdCloseAllWn,cmdCloseAllWnSaved,cmdRefreshWn];

     cmdWn : Array[wnMin..wnMax] of Set of Byte = (
{Edt}	      [cmdHelp,cmdSave,cmdSaveAs,cmdCompile,cmdCompress,cmdConv2AC,
	       cmdConv2Bas,cmdConv2C,cmdConv2Cobol,cmdConv2Fortran,
	       cmdConv2Pas,cmdConv2RC,cmdTxtBoldWord,cmdTxtUnderlnWord,
	       cmdTxtItalicWord,cmdTxtDblWord,cmdTxtInverseWord,
	       cmdTxtDelSpc,cmdTxtDelWord,cmdTxtMarge,cmdTxtPgUp,
	       cmdDelCurrCol,cmdDelCurrLn,cmdDelCurrMatrix,cmdInsCurrCol,
	       cmdInsCurrLn,cmdInsCurrMatrix,cmdGotoLn,cmdSearch,
	       cmdReplace,cmdEditMode,cmdChrType,cmdCenterTxt,cmdTxtDbl,
	       cmdTxtItalic,cmdTxtUnderln,cmdLnMode,cmdDrawMode,cmdRun,
	       cmdSetMarge,cmdPgUp,cmdPgDn,cmdLeft,cmdRight,cmdUp,cmdDn,
	       cmdExecMacro],
{View}	      [cmdHelp],
{ButtonEdt}   [cmdHelp,cmdSave,cmdSaveAs],
{Drw}         [cmdHelp,cmdSave,cmdSaveAs],
{Lotus}       [cmdHelp],
{FileMangers} [cmdHelp,cmdMoveFiles,cmdAssign,cmdAwk,cmdGrep,cmdExec,cmdJoinDsk,cmdJoinPath,cmdBoard],
{MDos}	      [cmdHelp],
{Output}      [cmdHelp],
{MusicMod}    [cmdHelp],
{Dial}	      [cmdHelp],
{Terminal}    [cmdHelp,cmdHostMode,cmdTermWelcome,cmdViewDownload],
	      [cmdHelp],
	      [cmdHelp],
	      [cmdHelp],
	      [cmdHelp],
	      [cmdHelp],
	      [cmdHelp],
	      [cmdHelp],
	      [cmdHelp],
	      [cmdHelp],
	      [cmdHelp],
	      [cmdHelp],
	      [cmdHelp],
	      [cmdHelp]
	     );

Var

    ExitOk : Bool;

Function IsValidFunc(X:Byte):Bool;
Begin
 IsValidFunc := False;
 If(X in cmdDefault)Then IsValidFunc := True
  Else
 If Not(_Windows.IsEmpty)Then
 Begin
  If(X in cmdDefaultOpen)Then IsValidFunc := True
			 else IsValidFunc := (X in cmdWn[WinPtr^.Model]);
 End;
End;

Procedure RunPlayMod; Forward;

Procedure RunFunc(Code:Byte);
Var L : Long; Path:PathStr;
Begin
 Case Code of
  cmdEmulAppleII:WindowAppleII;
  cmdEmulCK64:WindowCoco3;
  cmdEmulCoco3:WindowCommodore64;
  cmdEmulVIC20:;
  cmdNewBasCoco3:NewCoco3;
  cmdNewButt:NewButtonEdit;
  cmdNewDial:WindowDial;
  cmdNewDrw:NewDraw;
  cmdNewEdt:NewEdit;
  cmdNewFileManagers:WindowFileManager;
  cmdNewGatt:NewGatt;
  cmdNewMDos:WindowMDos;
  cmdNewSuperCalc:NewSuperCalc;
  cmdNewTerm:NewTerm;
  cmdNewUnix:;
  cmdHostMode:If(WinPtr^.Model = wnTerminal)Then WinPtr^.P.Terminal.HostMode;
  cmdOpenAC:OpenX(ViewAC);
  cmdOpenAsm:OpenX(ViewAsm);
  cmdOpenBas:OpenX(ViewBas);
  cmdOpenBasAppleII:OpenX(ViewBasAppleII);
  cmdOpenBasCK64:OpenX(ViewBasCK64);
  cmdOpenBasCoco3:OpenX(ViewBasCoco3);
  cmdOpenButtEdt:OpenButtonEdit;
  cmdOpenC:OpenX(ViewC);
  cmdOpenCobol:OpenX(ViewCobol);
  cmdOpenDrw:OpenDraw;
  cmdOpenEdt:OpenEdit;
  cmdOpenEuphoria:OpenX(ViewEuphoria);
  cmdOpenFortran:OpenX(ViewFortran);
  cmdOpenGatt:OpenText;
  cmdOpenMod:OpenMod;
  cmdOpenPas:OpenX(ViewPas);
  cmdOpenRC:OpenX(ViewRC);
  cmdOpenSuperCalc:OpenSuperCalc;
  cmdOpenCountry:;
  cmdOpenView:;
  cmdOpenPckAC:;
  cmdOpenPckAsm:;
  cmdOpenPckBas:;
  cmdOpenPckBasAppleII:;
  cmdOpenPckBasCK64:;
  cmdOpenPckBasCoco3:;
  cmdOpenPckC:;
  cmdOpenPckCobol:;
  cmdOpenPckDrw:;
  cmdOpenPckEdt:;
  cmdOpenPckEuphoria:;
  cmdOpenPckFortran:;
  cmdOpenPckGatt:;
  cmdOpenPckPas:;
  cmdOpenPckRC:;
  cmdHelp:;
  cmdSave:If Not(_Windows.IsEmpty)Then Case WinPtr^.Model of
	   wnEdit : WinPtr^.P.Edit.Save;
     wnButtonEdit : WinPtr^.P.ButtonEdit.Save;
	  End;
  cmdPrint:If Not(_Windows.IsEmpty)Then Case WinPtr^.Model of
	   wnEdit : WinPtr^.P.Edit.Prn;
	   End;
  cmdMoveFiles:MoveFiles;
  cmdAssign:;
  cmdAwk:;
  cmdGrep:;
  cmdExec:;
  cmdJoinDsk:;
  cmdJoinPath:;
  cmdShell:;
  cmdChDsk:XAltF1Key;
  cmdMkDir:MkDir;
  cmdDskDoctor:;
  cmdHardDiskPark:__HardDiskPark;
  cmdViewEdtDsk:;
  cmdHexViewEdtDsk:;
  cmdHexEdt:ViewOption;
  cmdFormatDsk:;
  cmdDskOption:;
  cmdDelFile:Delete;
  cmdDoctorVirus:;
  cmdCompile:Compile;
  cmdCompress:Compress;
  cmdConv2AC:;
  cmdConv2Bas:;
  cmdConv2C:;
  cmdConv2Cobol:;
  cmdConv2Fortran:;
  cmdConv2Pas:;
  cmdConv2RC:;
  cmdTxtBoldWord:If(WinPtr^.Model = wnEdit)Then WinPtr^.P.Edit.BoldWord;
  cmdTxtUnderlnWord:If(WinPtr^.Model = wnEdit)Then WinPtr^.P.Edit.UnderlineWord;
  cmdTxtItalicWord:If(WinPtr^.Model = wnEdit)Then WinPtr^.P.Edit.ItalicWord;
  cmdTxtDblWord:If(WinPtr^.Model = wnEdit)Then WinPtr^.P.Edit.DoubleWord;
  cmdTxtInverseWord:If(WinPtr^.Model = wnEdit)Then WinPtr^.P.Edit.InverseWord;
  cmdTxtDelSpc:If(WinPtr^.Model = wnEdit)Then WinPtr^.P.Edit.DelSpc;
  cmdTxtDelWord:;
  cmdTxtMarge:;
  cmdTxtPgUp:;
  cmdDelCurrCol:;
  cmdDelCurrLn:;
  cmdDelCurrMatrix:;
  cmdInsCurrCol:;
  cmdInsCurrLn:;
  cmdInsCurrMatrix:;
  cmdGotoLn:If Not(_Windows.IsEmpty)Then Case WinPtr^.Model of
  wnHlp,wnEdit : WinPtr^.P.Edit.GotoLns(WinGotoLine);
       wnCoco3 : Begin
		  L := WinGotoLine;
		  If(L <> 0)Then WinPtr^.P.Coco3.ExecCmd('LIST '+Str(L));
		 End;
	    End;
  cmdSearch:;
  cmdReplace:;
  cmdEditMode:EditCurrModeType;
  cmdChrType:EditCharType;
  cmdCenterTxt:If(WinPtr^.Model = wnEdit)Then WinPtr^.P.Edit.CenterTxt;
  cmdTxtDbl:;
  cmdTxtItalic:;
  cmdTxtUnderln:;
  cmdLnMode:SetDrawMode(drwLine);
  cmdBoxMode:SetDrawMode(drwBox);
  cmdCircleMode:SetDrawMode(drwCircle);
  cmdPaintMode:SetDrawMode(drwPaint);
  cmdTraceMode:SetDrawMode(drwTrace);
  cmdTextMode:SetDrawMode(drwText);
  cmdDrawMode:If(WinPtr^.Model = wnEdit)Then
	      Begin
	       WinPtr^.P.Edit.SetDrawMode(Not(WinPtr^.P.Edit.DrawMode));
	       SetMnuSwitch;
	      End;
  cmdChgColor:;
  cmdDrwNewPgButt:If(WinPtr^.Model = wnButtonEdit)Then WinPtr^.P.ButtonEdit.NewPage;
  cmdDrwChgPgButt:If(WinPtr^.Model = wnButtonEdit)Then WinPtr^.P.ButtonEdit.ChangePage;
  cmdPlayMod:RunPlayMod;
  cmdStopPlayMod:If(IsPlayMod)Then
		 Begin
		  Sound.StopPlaying;
		  Sound.DeAlloc;
		  Sound.RemoveOvl;
		  Sound.Unload;
		  MaxExpandHeap;
		  PutFreeMemory;
		 End;
  cmdPrnSetup:PrintersSetup;
  cmdOptionVid:;
  cmdSetVideoMode:;
  cmdSomaryInfo:SomaryInfo;
  cmdVidInfo:VideoInfo;
  cmdDskInfo:;
  cmdRun:;
  cmdSetMarge:SetFormat;
  cmdSetDirSetup:SetupDir;
  cmdLstWn:ListEdit;
  cmdPreviousWn:If Not(_Windows.IsEmpty)Then
		Begin
		 If(0 < CurrEdit)Then Dec(CurrEdit)
				 Else CurrEdit := _Windows.MaxBuf;
		 If(CurrEdit >= 0)Then
		 Begin
		  WinPtr := _Windows._GetBuf(CurrEdit);
		  RunFunc(cmdRefreshWn);
		  SetMnuSwitch;
		 End;
		End;
  cmdNextWn:If Not(_Windows.IsEmpty)Then
	    Begin
	     If(_Windows.MaxBuf > CurrEdit)Then Inc(CurrEdit)
					  Else CurrEdit := 0;
	     WinPtr := _Windows._GetBuf(CurrEdit);
	     RunFunc(cmdRefreshWn);
	     SetMnuSwitch;
	    End;
  cmdCloseWn:Begin
	      If(CurrEdit >= 0)Then
	      Begin
	       Case WinPtr^.Model of
		 wnEdit : WinPtr^.P.Edit.Done;
	   wnButtonEdit : WinPtr^.P.ButtonEdit.Done;
		 wnDraw : WinPtr^.P.DrawEdit.Done;
		wnLotus : WinPtr^.P.Lotus.Done;
	  wnFileManager : WinPtr^.P.FM.Done;
		 wnMDos : WinPtr^.P.Shell.Done;
		 wnUnix : WinPtr^.P.Unix.Done;
		 wnTerm : WinPtr^.P.Terminal.Done;
	      wnTermPrn : WinPtr^.P.TPrn.Done;
		 wnDial : WinPtr^.P.Dial.Done;
	      wnHexView : WinPtr^.P.HexVw.Done;
		  wnHlp : WinPtr^.P.Hlp.Done;
	      wnAppleII : WinPtr^.P.AppleII.Done;
		wnCoco3 : WinPtr^.P.Coco3.Done;
	  wnCommodore64 : WinPtr^.P.CK64.Done;
	       End;
	       _Windows.DelBuf(CurrEdit);
	       RunFunc(cmdPreviousWn);
	       If(CurrEdit = -1)Then YEditor := 1;
	      End;
	      PutFreeMemory;
	      SetMnuSwitch;
	     End;
  cmdCloseAllWn:Begin
		 While (_Windows.NmBuf > 0) do
		 Begin
		  CurrEdit := 0; WinPtr := _Windows._GetBuf(CurrEdit);
		  Case WinPtr^.Model of
		    wnEdit : WinPtr^.P.Edit.Done;
	      wnButtonEdit : WinPtr^.P.ButtonEdit.Done;
		    wnDraw : WinPtr^.P.DrawEdit.Done;
		   wnLotus : WinPtr^.P.Lotus.Done;
	     wnFileManager : WinPtr^.P.FM.Done;
		    wnMDos : WinPtr^.P.Shell.Done;
		    wnUnix : WinPtr^.P.Unix.Done;
		    wnTerm : WinPtr^.P.Terminal.Done;
		 wnTermPrn : WinPtr^.P.TPrn.Done;
		    wnDial : WinPtr^.P.Dial.Done;
		 wnHexView : WinPtr^.P.HexVw.Done;
		     wnHlp : WinPtr^.P.Hlp.Done;
		 wnAppleII : WinPtr^.P.AppleII.Done;
		   wnCoco3 : WinPtr^.P.Coco3.Done;
	     wnCommodore64 : WinPtr^.P.CK64.Done;
		  End;
		  _Windows.DelBuf(CurrEdit);
		  RunFunc(cmdPreviousWn);
		  If(CurrEdit = -1)Then YEditor := 1;
		 End;
		 PutFreeMemory;
		 SetMnuSwitch;
		End;
  cmdCloseAllWnSaved:;
  cmdRefreshWn:If Not(_Windows.IsEmpty)Then Case WinPtr^.Model of
	 wnEdit : WinPtr^.P.Edit.Refresh;
   wnButtonEdit : WinPtr^.P.ButtonEdit.Refresh;
	 wnDraw : WinPtr^.P.DrawEdit.Refresh;
	wnLotus : WinPtr^.P.Lotus.Refresh;
	 wnTerm : WinPtr^.P.Terminal.Refresh;
      wnTermPrn : WinPtr^.P.TPrn.Refresh;
  wnFileManager : WinPtr^.P.FM.Refresh;
      wnHexView : WinPtr^.P.HexVw.Refresh;
	  wnHlp : WinPtr^.P.Hlp.Refresh;
      wnAppleII : WinPtr^.P.AppleII.Refresh;
	wnCoco3 : WinPtr^.P.Coco3.Refresh;
  wnCommodore64 : WinPtr^.P.CK64.Refresh;
	     End;
  cmdPgUp:If Not(_Windows.IsEmpty)Then Case WinPtr^.Model of
	   wnEdit : WinPtr^.P.Edit.kPgUp;
	  End;
  cmdPgDn:If Not(_Windows.IsEmpty)Then Case WinPtr^.Model of
	   wnEdit : WinPtr^.P.Edit.kPgDn;
	  End;
  cmdLeft:If Not(_Windows.IsEmpty)Then Case WinPtr^.Model of
	   wnEdit : WinPtr^.P.Edit.kLeft;
	  End;
 cmdRight:If Not(_Windows.IsEmpty)Then Case WinPtr^.Model of
	   wnEdit : WinPtr^.P.Edit.kRight;
	  End;
    cmdUp:If Not(_Windows.IsEmpty)Then Case WinPtr^.Model of
	   wnEdit : WinPtr^.P.Edit.kUp;
	  End;
   cmd2Up:Begin
	   RunFunc(cmdUp);
	   RunFunc(cmdUp);
	  End;
    cmdDn:If Not(_Windows.IsEmpty)Then Case WinPtr^.Model of
	   wnEdit : WinPtr^.P.Edit.kDn;
	  End;
  cmdTermWelcome:OpenHelp(SetPath4AddFile(StrPas(PathBBS))+'TERMINAL.WEL','Message de Bienvenue du BBS');
  cmdViewDownload:OpenHelp(SetPath4AddFile(StrPas(PathBBS))+'TERMINAL.XFR','Liste des fichiers Download');
  cmdBoard:If Not(_Windows.IsEmpty)Then Case WinPtr^.Model of
	    wnFileManager : WinPtr^.P.FM.ChgBoard;
	   End;
  cmdExecMacro:
  Begin
   Path := OpenWin(SetPath4AddFile(StrPas(PathMac))+'*.MAC','Execute Macro');
   If Not(Path = '')Then
   Begin
    If(WinPtr^.Model = 1)Then WinPtr^.P.Edit.ExecMacro(Path);
   End;
  End;
  cmdNewTermPrn: NewTermPrn;
  cmdNewUnix: WindowMUnix;
  cmdSaveAs: If Not(_Windows.IsEmpty)Then Case WinPtr^.Model of
	      wnEdit : WinPtr^.P.Edit.SaveAs('');
	     End;
  cmdExit:ExitOk := True;
 End;
End;

Procedure RunPlayMod;
Var Info:SearchRec; OldPath,Path:PathStr;
Begin
 If Not(WinPtr^.Model = wnFileManager)Then
 Begin
  OldPath := Systems.GetPath;
  Path := FileExpand(StrPas(PathMod));
  If(Path[Length(Path)] <> '\')Then IncStr(Path,'\');
  Path := OpenWin(Path+'*.MOD','Ouvre Fichier');
  If Not(Path = '')Then
  Begin
   RunFunc(cmdStopPlayMod);
   FindFirst(Path,Archive,Info);
   If(DosError <> 0)Then
   Begin
    __FileNotFound(Path);
    Exit;
   End;
   If Not(FreeHeap(((80 * 1024) + Info.Size) div 16))Then
   Begin
    ErrorMsgOk('Impossible de lib‚rer suffisament de m‚moire pour charger le .MOD!');
    Exit;
   End;
   ChDir(StrPas(PathSystems));
   If(Sound.LoadDriver)Then
   Begin
    PutLastBar(2,'Chargement du .MOD en cours...');
    Sound.LoadOvl;
    Sound.SetSys(4,1193182 div 15750,1,7,$220);
    Sound.Initialise;
    Sound.LoadModule(Path);
    Sound.StartPlaying;
    PutFreeMemory;
    DefaultEndBar;
   End;
   ChDir(OldPath);
  End;
 End
  Else
 Begin
  OldPath := Systems.GetPath;
  RunFunc(cmdStopPlayMod);
  WinPtr^.P.FM.GetCurrFile(Info);
  If Not(FreeHeap(((80 * 1024) + Info.Size) div 16))Then
  Begin
   ErrorMsgOk('Impossible de lib‚rer suffisament de m‚moire pour charger le .MOD!');
   Exit;
  End;
  ChDir(StrPas(PathSystems));
  If(Sound.LoadDriver)Then
  Begin
   PutLastBar(2,'Chargement du .MOD en cours...');
   Sound.LoadOvl;
   Sound.SetSys(4,1193182 div 15750,1,7,$220);
   Sound.Initialise;
   Sound.LoadModule(WinPtr^.P.FM.GetCurrName);
   Sound.StartPlaying;
   PutFreeMemory;
   DefaultEndBar;
  End;
  ChDir(OldPath);
 End;
End;

Procedure Run;
Var LK,K,I,B:Word; MX,MY:Byte; Path:PathStr; Ok:Bool;
Begin
 PathDiskSwap := FileExpand('MALBOOK.$$$');
 InitMemManagers;
 InitSpooler;
 InitMnu(0,0);
 InitScreen;
 PutMemory := PutFreeMemory;
 SetOnTimer;
 _Windows.Init;
{ InitTeleMate;}
 CurrEdit := 0;
 WinPtr := _Windows._GetBuf(CurrEdit);
 LK := 0;
 Repeat
  If(_Windows.NmBuf = 0)Then
  Begin
   _InitKbd;
   __ShowMousePtr;
   Repeat
    __GetMouseTextSwitch(MX,MY,B);
    If(B > 0)Then
    Begin
     If(LastMsY = 0)and(LastMsX < Length(GetCloseIcon^))Then PushKey(kbAltX);
     Case But.GetBut(LastMsX,LastMsY) of
      0 : Begin
	   __HideMousePtr;
	   OpenEdit;
	   __ShowMousePtr;
	   Continue;
	  End;
      1 : Begin
	   __HideMousePtr;
	   OpenDraw;
	   __ShowMousePtr;
	   Continue;
	  End;
      2 : Begin
	   __HideMousePtr;
	   OpenButtonEdit;
	   __ShowMousePtr;
	   Continue;
	  End;
      3 : Begin
	   __HideMousePtr;
	   OpenSuperCalc;
	   __ShowMousePtr;
	   Continue;
	  End;
      4 :;{ Ouvre drapeau }
      9 : Begin
	   __HideMousePtr;
	   RunFunc(cmdPrint);
	   __ShowMousePtr;
	   Continue;
	  End;
     10 : Begin
	   __HideMousePtr;
	   NewTerm;
	   __ShowMousePtr;
	   Continue;
	  End;
     16 : Begin
	   __HideMousePtr;
	   SomaryInfo;
	   __ShowMousePtr;
	   Continue;
	  End;
     17 : Begin
	   __HideMousePtr;
	   ListEdit;
	   __ShowMousePtr;
	   Continue;
	  End;
     End;
     M.GetMnuBar(LastMsX,LastMsY);
    End;
    _BackKbd;
   Until Keypressed;
   __HideMousePtr;
   K := ReadKey;
  End
   Else
  Case WinPtr^.Model of
	 wnEdit : K := WinPtr^.P.Edit.Run;
   wnButtonEdit : K := WinPtr^.P.ButtonEdit.Run;
	 wnDraw : K := WinPtr^.P.DrawEdit.Run;
	wnLotus : K := WinPtr^.P.Lotus.Run;
  wnFileManager : K := WinPtr^.P.FM.Run;
	 wnMDos : K := WinPtr^.P.Shell.Run;
	 wnUnix : K := WinPtr^.P.Unix.Run;
     wnTerminal : K := WinPtr^.P.Terminal.Run;
	 wnDial : K := WinPtr^.P.Dial._Run;
      wnHexView : K := WinPtr^.P.HexVw.Run;
	  wnHlp : K := WinPtr^.P.Hlp.Run;
{	   wnPJ : K := WinPtr^.P.PJ.Run;}
      wnAppleII : K := WinPtr^.P.AppleII.Run;
	wnCoco3 : K := WinPtr^.P.Coco3.Run;
  wnCommodore64 : K := WinPtr^.P.CK64.Run;
      wnTermPrn : K := WinPtr^.P.TPrn.Run;
	     Else K := ReadKey;
  End;
  Ok := False;
  For I := 0 to MaxKey do
  Begin
   If(ButtSwitchPtr^[I].KeyB = kbNoKey)Then
   Begin
    If(ButtSwitchPtr^[I].KeyA = K)Then
    Begin
     If(IsValidFunc(ButtSwitchPtr^[I].Option))Then
     Begin
      Ok := True; LK := 0;
      RunFunc(ButtSwitchPtr^[I].Option);
      Break;
     End;
    End;
   End
    Else
   Begin
    If(ButtSwitch[I].KeyB = K)and(ButtSwitch[I].KeyA = LK)Then
    Begin
     If(IsValidFunc(ButtSwitch[I].Option))Then
     Begin
      Ok := True; LK := 0;
      RunFunc(ButtSwitch[I].Option);
      Break;
     End;
    End;
   End;
  End;
  If Not(Ok)Then Case K of
kbShiftF1,
     kbF1 : Begin
	     Path := StrPas(PathGatt);
	     If Not(Path[Length(Path)] = '\')Then IncStr(Path,'\');
	     If(_Windows.NmBuf > 0)Then Case WinPtr^.Model of
	     wnEdit : Case WinPtr^.P.Edit.GetViewMode of
			 ViewAsm : OpenHelp(Path+'ASSEMBLE.GAT','Langage Assembleur');
			 ViewBas : OpenHelp(Path+'BASIC.GAT','Langage Basic');
			   ViewC : OpenHelp(Path+'C.GAT','Langage C/C++');
			 ViewPas : OpenHelp(Path+'PASCAL.GAT','Langage Pascal');
		      End;
	      wnHlp :;
	     End;
	     If(K = kbShiftF1)and(WinPtr^.Model = wnHlp)Then WinPtr^.P.Hlp.SetIndexMode;
	    End;
  kbMouse : Case But.GetBut(LastMsX,LastMsY) of
	     0 : OpenEdit;
	     1 : OpenDraw;
	     2 : OpenButtonEdit;
	     3 : OpenSuperCalc;
	     9 : RunFunc(cmdPrint);
	    10 : NewTerm;
	    16 : SomaryInfo;
	    17 : ListEdit;
	    End;
kbPrgMnuBar : M.GetMnuBar(LastMsX,LastMsY);
kbPrgCloseIcon : ExitOk := True;
   Else 
	Begin
	 PushKey(K);
	 Case M.WaitForMnuAction of
		 mbFileNew : NewEdit;
		mbFileOpen : OpenEdit;
	    mbFileNewLotus : NewSuperCalc;
	   mbFileOpenLotus : OpenSuperCalc;
		mbFileSave : RunFunc(cmdSave);
	      mbFileSaveAs : RunFunc(cmdSaveAs);
	       mbFilePrint : RunFunc(cmdPrint);
		mbFileExit : ExitOk := True;
		 mbDrawNew : NewDraw;
		mbDrawOpen : OpenDraw;
	   mbDrawNewButton : NewButtonEdit;
	  mbDrawOpenButton : OpenButtonEdit;
       mbDrawNewPageButton : RunFunc(cmdDrwNewPgButt);
    mbDrawChangePageButton : RunFunc(cmdDrwChgPgButt);
		mbEditMode : EditCurrModeType;
	    mbEditCharType : EditCharType;
		mbEditDraw : EditDrawMode;
		mbEditLine : SetDrawMode(drwLine);
		 mbEditBox : SetDrawMode(drwBox);
	      mbEditCircle : SetDrawMode(drwCircle);
	       mbEditPaint : SetDrawMode(drwPaint);
	       mbEditTrace : SetDrawMode(drwTrace);
		mbEditText : SetDrawMode(drwText);
	  mbSearchGotoLine : RunFunc(cmdGotoLn);
		 mbCompile : Compile;
	 mbCompileCompress : Compress;
	mbOptionMemorySize : SetFormat;
	 mbOptionDirectory : SetupDir;
	  mbOptionPrinters : PrintersSetup;
	     mbOptionVideo : Begin
			      I := SelectVideoMode(8,6,Video.MaxXTxts-8,Video.MaxYTxts-6,__Two__);
			      If Not(I = _NoMode)Then
			      Begin
			       RunFunc(cmdCloseAllWn);
			       But.Done;
			       ButDraw.Done;
			       __DoneMouse;
			       SetVideoModeDeluxe(I);
			       InitScreen;
			       CurrEdit := 0;
			       WinPtr := _Windows._GetBuf(CurrEdit);
			      End;
			     End;
       mbOptionTermWelcome : RunFunc(cmdTermWelcome);
	     mbOptionBoard : RunFunc(cmdBoard);
	      mbWindowMDos : WindowMDos;
	      mbWindowUnix : WindowMUnix;
		 mbTermPrn : NewTermPrn;
	      mbWindowTerm : NewTerm;
       mbWindowFileManager : WindowFileManager;
	      mbWindowDial : WindowDial;
	   mbWindowAppleII : WindowAppleII;
	     mbWindowCoco3 : WindowCoco3;
       mbWindowCommodore64 : WindowCommodore64;
	     mbWindowClose : RunFunc(cmdCloseWn);
	  mbWindowCloseAll : RunFunc(cmdCloseAllWn);
	  mbWindowPrevious : RunFunc(cmdPreviousWn);
	      mbWindowNext : RunFunc(cmdNextWn);
	      mbWindowList : ListEdit;
	      mbInfoSomary : SomaryInfo;
	mbInfoTermDownload : RunFunc(cmdViewDownload);
  mbInfoSomaryVideoPrimary : VideoInfo;
	     mbCmdHostMode : RunFunc(cmdHostMode);
	       mbExecMacro : RunFunc(cmdExecMacro);
	Else If(IsAltCode(K))Then
	Begin
	 If(WinPtr^.Model = wnEdit)Then
	 Begin
	  Path := SetPath4AddFile(StrPas(PathMac))+'ALT'+AltCode2ASCII(K)+'.MAC';
	  WinPtr^.P.Edit.ExecMacro(Path);
	 End;
	End;
	End;
	End;
  End;
  If(ExitOk)Then
  Begin
   If Not(__InputExit('Etes-vous certain de quitter ?'))Then K := 0;
  End;
  LK := K;
 Until ExitOk;
 RunFunc(cmdCloseAllWn);
 RunFunc(cmdStopPlayMod);
 __DoneMouse;
 DoneSpooler;
{ DoneTeleMate;}
 But.Done;
 ButDraw.Done;
 DoneMnu;
 DoneLuxeVideo;
 DoneMemManagers;
End;

BEGIN
 DrawMode:=drwText; IsFill:=False; ExitOk:=False;
END.