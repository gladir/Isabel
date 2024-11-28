Unit MalMnu;

INTERFACE

Uses Math,Mnus;

Const

      mbFileNew                    = $F001;
      mbFileOpen                   = $F002;
      mbFileNewLotus               = $F003;
      mbFileOpenLotus              = $F004;
      mbFileSave                   = $F005;
      mbFileSaveAs                 = $F006;
      mbFileSaveAll                = $F007;
      mbFileMkDir                  = $F008;
      mbFileChDir                  = $F009;
      mbFilePrint                  = $F00A;
      mbFileDosShell               = $F00B;
      mbFileExit                   = $F00C;
      mbDrawNew                    = $F00D;
      mbDrawOpen                   = $F00E;
      mbDrawNewButton              = $F011;
      mbDrawOpenButton             = $F012;
      mbDrawNewPageButton          = $F015;
      mbDrawChangePageButton       = $F016;
      mbEditUndo                   = $F017;
      mbEditCut                    = $F018;
      mbEditCopy                   = $F019;
      mbEditPaste                  = $F01A;
      mbEditClear                  = $F01B;
      mbEditShowClipboard          = $F01C;
      mbEditMode                   = $F01D;
      mbEditCharType               = $F01E;
      mbEditDraw                   = $F01F;
      mbEditLine                   = $F020;
      mbEditBox                    = $F021;
      mbEditCircle                 = $F022;
      mbEditPaint                  = $F023;
      mbEditTrace                  = $F024;
      mbEditText                   = $F025;
      mbEditFill                   = $F026;
      mbSearchFind                 = $F027;
      mbSearchReplace              = $F028;
      mbSearchAgain                = $F029;
      mbSearchGotoLine             = $F02A;
      mbSearchGotoRow              = $F02B;
      mbTri                        = $F02C;
      mbRun                        = $F02D;
      mbRunParameters              = $F02E;
      mbCompile                    = $F02F;
      mbCompileConv                = $F030;
      mbCompileCompress            = $F031;
      mbCompileMake                = $F032;
      mbCompileBuilt               = $F033;
      mbCompileInfo                = $F034;
      mbOptionApplication          = $F035;
      mbOptionCompiler             = $F036;
      mbOptionMemorySize           = $F037;
      mbOptionLink                 = $F038;
      mbOptionDebug                = $F039;
      mbOptionDirectory            = $F03A;
      mbOptionPrinters             = $F03B;
      mbOptionVideo                = $F03C;
      mbOptionEnvironment          = $F03D;
      mbOptionTermWelcome          = $F03E;
      mbOptionTermUserList         = $F03F;
      mbOptionBoard                = $F040;
      mbWindowDial                 = $F041;
      mbWindowFileManager          = $F042;
      mbWindowMDos                 = $F043;
      mbWindowUnix                 = $F044;
      mbTermPrn                    = $F045;
      mbWindowTerm                 = $F046;
      mbWindowOutput               = $F047;
      mbWindowAppleII              = $F048;
      mbWindowCoco3                = $F049;
      mbWindowCommodore64          = $F04A;
      mbWindowTile                 = $F04B;
      mbWindowCascade              = $F04C;
      mbWindowCloseAll             = $F04D;
      mbWindowRefreshDisplay       = $F04E;
      mbWindowSizeMove             = $F04F;
      mbWindowZoom                 = $F050;
      mbWindowNext                 = $F051;
      mbWindowPrevious             = $F052;
      mbWindowClose                = $F053;
      mbWindowList                 = $F054;
      mbInfoSomary                 = $F055;
      mbInfoSomaryVideoPrimary     = $F056;
      mbInfoDataCmos               = $F057;
      mbInfoTermDownload           = $F058;
      mbCmdHostMode                = $F059;
      mbExecMacro                  = $F05A;
      mbPersonalJournal            = $F05B;

Var

    M:PullMnu;
    Emul,OTerm:PullSubMnu;
    DrawMode:Bool;
    IsLine,IsBox,IsCircle,IsPaint,IsTrace,IsText,IsFill:Bool;

Procedure InitMnu(Mode:Byte;SubMode:Byte);
Procedure DoneMnu;

IMPLEMENTATION

Uses Editor,Keyboard,MalEnv;

Procedure InitMnu(Mode:Byte;SubMode:Byte);
Begin
 M.Init;
 M.AddMnu('^F^ichier');
  M.AddItem('^N^ouveau texte',mbFileNew);
  M.AddItemKey('^O^uvre texte',kbF3,mbFileOpen);
  M.AddBarItem;
  M.AddItem('Nouveau ^t^ableur',mbFileNewLotus);
  M.AddItem('Ou^v^re tableur',mbFileOpenLotus);
  M.AddBarItem;
  If Not(Mode = 0)Then
  Begin
   M.AddItemKey('^S^auve',kbF2,mbFileSave);
   M.AddItem('Sauve so^u^s',mbFileSaveAs);
   M.AddItem('Sauve ^t^ous',mbFileSaveAll);
   M.AddBarItem;
  End;
  M.AddItem('Cr‚e ^r^‚pertoire',mbFileMkDir);
  M.AddItemKey('^C^hange r‚pertoire',kbF7,mbFileChDir);
  If Not(Mode = 0)Then M.AddItem('^I^mprime',mbFilePrint);
  M.AddItem('^D^os Shell',mbFileDosShell);
  M.AddBarItem;
  M.AddItemKey('^Q^uitte',kbAltX,mbFileExit);
 M.AddMnu('^D^essin');
  M.AddItem('Nouveau',mbDrawNew);
  M.AddItem('Ouvre',mbDrawOpen);
  M.AddBarItem;
  M.AddItem('Nouveau Bouton',mbDrawNewButton);
  M.AddItem('Ouvre Bouton',mbDrawOpenButton);
  If(Mode = wnButtonEdit)Then
  Begin
   M.AddItem('Nouvelle page Bouton',mbDrawNewPageButton);
   M.AddItem('Change page Bouton',mbDrawChangePageButton);
  End;
 M.AddMnu('^E^dite');
  If(Mode in [wnEdit,wnDraw,wnButtonEdit])Then
  Begin
   M.AddItemKey('^A^nnule',kbAltBackSpace,mbEditUndo);
   M.AddItemKey('^M^ouve',kbShiftDel,mbEditCut);
  End;
  M.AddItemKey('^C^opie',kbCtrlIns,mbEditCopy);
  If(Mode in [wnEdit,wnDraw,wnButtonEdit])Then
  Begin
   M.AddItemKey('^P^asse',kbShiftIns,mbEditPaste);
   M.AddItemKey('^E^fface',kbCtrlDel,mbEditClear);
  End;
  M.AddBarItem;
  M.AddItem('Clipboa^r^d',mbEditShowClipboard);
  Case Mode of
   wnEdit :
   Begin
    M.AddBarItem;
    M.AddItem('Mode ^A^ffichage',mbEditMode);
    M.AddItem('Type Ca^r^actŠre',mbEditCharType);
    M.AddItemSwitch('^D^essiner',DrawMode,NIL,mbEditDraw);
   End;
   wnDraw,wnButtonEdit :
   Begin
    M.AddBarItem;
    M.AddItemSwitch('^L^igne',IsLine,NIL,mbEditLine);
    M.AddItemSwitch('^B^oite',IsBox,NIL,mbEditBox);
    M.AddItemSwitch('C^i^rcle',IsCircle,NIL,mbEditCircle);
    M.AddItemSwitch('Peint^u^re',IsPaint,NIL,mbEditPaint);
    M.AddItemSwitch('T^r^ace',IsTrace,NIL,mbEditTrace);
    M.AddItemSwitch('^T^exte',IsText,NIL,mbEditText);
    M.AddBarItem;
    M.AddItemSwitch('Plei^n^',IsFill,NIL,mbEditFill);
   End;
  End;
 M.AddMnu('^R^echerche');
  M.AddItem('^T^rouve',mbSearchFind);
  M.AddItem('^R^emplace',mbSearchReplace);
  M.AddItemKey('Essaie ^E^ncore',kbCtrlL,mbSearchAgain);
  M.AddBarItem;
  M.AddItem('^L^igne',mbSearchGotoLine);
  M.AddItem('^C^olonne',mbSearchGotoRow);
  M.AddBarItem;
  M.AddItem('T^r^i',mbTri);
 If(Mode = wnEdit)Then
 Begin
  M.AddMnu('^T^ravail');
   M.AddItemKey('^C^ompilation',kbAltF9,mbCompile);
   M.AddItemKey('C^o^nvertion',kbShiftF9,mbCompileConv);
   M.AddItemKey('Com^p^ression',kbCtrlF10,mbCompileCompress);
   M.AddItemKey('C^r^‚e',kbF9,mbCompileMake);
   M.AddItem('^F^abrique',mbCompileBuilt);
   M.AddBarItem;
   M.AddItem('^I^nformation',mbCompileInfo);
   M.AddBarItem;
   M.AddItemKey('^E^xecute',kbCtrlF9,mbRun);
 End;
 M.AddMnu('^O^ption');
  If(Mode = wnEdit)and(SubMode in [ViewAda,ViewAsm,ViewBas,ViewC,
     ViewCobol,ViewEuphoria,ViewForth,ViewFortran,ViewPas,ViewAC])Then
  Begin
   M.AddItem('^A^pplication',mbOptionApplication);
   M.AddItem('^C^ompilateur',mbOptionCompiler);
   M.AddItem('Di^m^ension m‚moire',mbOptionMemorySize);
   M.AddItem('^L^inkeur',mbOptionLink);
   M.AddItem('^D^ebugueur',mbOptionDebug);
  End
   Else
  If(Mode = wnEdit)and(SubMode = ViewGatt)Then
   M.AddItem('Di^m^ension',mbOptionMemorySize);
  M.AddItem('^R^‚pertoire',mbOptionDirectory);
  If(Mode = wnEdit)and(SubMode in [ViewAda,ViewAsm,ViewBas,ViewC,
     ViewCobol,ViewEuphoria,ViewForth,ViewFortran,ViewPas,ViewAC])Then
   M.AddItem('^P^aramŠtre',mbRunParameters);
  M.AddBarItem;
  M.AddItem('^V^id‚o',mbOptionVideo);
  M.AddItem('^I^mprimantes',mbOptionPrinters);
  M.AddItem('^E^nvironnement',mbOptionEnvironment);
  OTerm.Init;
  OTerm.AddFullItem('Message ^B^ienvenue',kbNoKey,mbOptionTermWelcome,NIL);
  OTerm.AddFullItem('Liste des ^U^sagers',kbNoKey,mbOptionTermUserList,NIL);
   M.AddFullItem('^T^erminal',kbNoKey,kbNoKey,OTerm.Ptr);
  If(Mode = wnFileManager)Then
  Begin
   M.AddBarItem;
   M.AddItem('^T^ableau',mbOptionBoard);
  End;
 M.AddMnu('Fe^n^ˆtre');
  M.AddItem('Dial',mbWindowDial);
  M.AddItem('Malte-^D^os',mbWindowMDos);
  M.AddItem('Malte-^U^nix',mbWindowUnix);
  M.AddItem('Terminal d''^I^mprimante',mbTermPrn);
  M.AddItem('Terminal',mbWindowTerm);
  M.AdDItem('^G^estionnaire Fichiers',mbWindowFileManager);
  M.AddItem('^O^utput',mbWindowOutput);
  M.AddBarItem;
  Emul.Init;
   Emul.AddFullItem('^A^pple ][',kbNoKey,mbWindowAppleII,NIL);
   Emul.AddFullItem('^C^oco 3',kbNoKey,mbWindowCoco3,NIL);
   Emul.AddFullItem('Commodore ^6^4',kbNoKey,mbWindowCommodore64,NIL);
  M.AddFullItem('^E^mulateur',kbNoKey,kbNoKey,Emul.Ptr);
  M.AddBarItem;
  If Not(Mode = 0)Then
  Begin
   M.AddItem('^T^ile',mbWindowTile);
   M.AddItem('^C^ascade',mbWindowCascade);
   M.AddItem('^F^erme tous',mbWindowCloseAll);
  End;
  M.AddItem('^R^estore ‚cran',mbWindowRefreshDisplay);
  If Not(Mode = 0)Then
  Begin
   M.AddBarItem;
   M.AddItemKey('Taille/^M^ouve',kbCtrlF5,mbWindowSizeMove);
   M.AddItemKey('^Z^oom',kbF5,mbWindowZoom);
   M.AddItemKey('^S^uivant',kbF6,mbWindowNext);
   M.AddItemKey('^P^r‚c‚dant',kbShiftF6,mbWindowPrevious);
   M.AddItemKey('F^e^rme',kbAltF3,mbWindowClose);
   M.AddBarItem;
   M.AddItemKey('^L^iste',kbAlt0,mbWindowList);
  End;
 M.AddMnu('^I^nfo');
  M.AddItem('^I^nformation Sommaire',mbInfoSomary);
  M.AddItem('^S^ommaire du Vid‚o Primaire',mbInfoSomaryVideoPrimary);
  M.AddItem('^D^onn‚es CMOS',mbInfoDataCmos);
 If(Mode = wnTerminal)Then
 Begin
  M.AddBarItem;
  M.AddItem('Liste des Downloads',mbInfoTermDownload);
  M.AddMnu('^C^ommande');
   M.AddItem('HostMode',mbCmdHostMode);
 End;
 If(Mode = wnEdit)Then
 Begin
  M.AddMnu('^C^ommande');
   M.AddItem('Execute Macro',mbExecMacro);
 End;
 {M.AddMnu('^P^ersonnel');
  M.AddItem('^J^ournal',mbPersonalJournal);}
End;

Procedure DoneMnu;
Begin
 Emul.Done;
 OTerm.Done;
 M.Done;
End;

BEGIN { Main Unit }
END.