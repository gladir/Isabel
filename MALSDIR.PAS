(******************************************)
(*                                        *)
(*          Malte Genesis/Resource        *)
(*   Phoenix Edition for Real Mode Only   *)
(*           II - Version 1.7             *)
(*                                        *)
(*              1994-12-18                *)
(*                                        *)
(******************************************)

Unit MALSDIR;

INTERFACE

Procedure SetupDir;

IMPLEMENTATION

Uses Strings, Strs, Keyboard, Video, Windows, Dials, Systems, Language, MLibrary, Terminal, MalBKRes, Editor;

Procedure SetupDir;
Var P, PP            : Byte;
    W                : Ansi;
    L                : LstMnu;
    K                : Word;
    PathBuf          : Array[0..255] of Char;
    PPathBuf         : PChar;
    TPathGatt        : PChar;
    TPathMac         : PChar;
    TPathCalc        : PChar;
    TPathCatDisk     : PChar;
    TPathDraw        : PChar;
    TPathPCX         : PChar;
    TPathMod         : PChar;
    TPathPhoneList   : PChar;
    TPathUpLoad      : PChar;
    TPathDownLoad    : PChar;
    TPathBBS         : PChar;
    TPathAda         : PChar;
    TPathAsm         : PChar;
    TPathBas         : PChar;
    TPathC           : PChar;
    TPathCobol       : PChar;
    TPathEuphoria    : PChar;
    TPathForth       : PChar;
    TPathFortran     : PChar;
    TPathPas         : PChar;
    TPathObject      : PChar;
    TPathResource    : PChar;
    TPathOutput      : PChar;
    TPathUnit        : PChar;
    TPathAdams       : PChar;
    TPathAppleII     : PChar;
    TPathAppleMac    : PChar;
    TPathAtari2600   : PChar;
    TPathTRS80       : PChar;
    TPathCoco3       : PChar;
    TPathAmiga       : PChar;
    TPathCommodore64 : PChar;
    TPathVic20       : PChar;
    TPathSystems     : PChar;
    TPathOS2         : PChar;
    TPathUnix        : PChar;
    TPathWin         : PChar;
    TPathCountry     : PChar;

 Procedure UpDateDir;
 Begin
  Case L.GetVal of
   1 :
   Begin
    W.SetKrBorder;
    W.PutTxtXY(0,7,'Gatt');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,8,W.MaxXTxts-1);
    W.PutPTxtXY(0,8,PathGatt);
    W.SetKrBorder;
    W.PutTxtXY(0,10,'Macro');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,11,W.MaxXTxts-1);
    W.PutPTxtXY(0,11,PathMac);
    W.ClrWn(0,13,W.MaxXTxts,W.MaxYTXts-2,W.XColrs.Border);
   End;
   2 :
   Begin
    W.SetKrBorder;
    W.PutTxtXY(0,7,'Phoenix Calulator');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,8,W.MaxXTxts-1);
    W.PutPTxtXY(0,8,PathCalc);
    W.ClrWn(0,10,W.MaxXTxts,W.MaxYTXts-2,W.XColrs.Border);
   End;
   3 :
   Begin
    W.SetKrBorder;
    W.PutTxtXY(0,7,'Catalogue disque');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,8,W.MaxXTxts-1);
    W.PutPTxtXY(0,8,PathCatDisk);
    W.ClrWn(0,10,W.MaxXTxts,W.MaxYTXts-2,W.XColrs.Border);
   End;
   4 :
   Begin
    W.SetKrBorder;
    W.PutTxtXY(0,7,'Draw');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,8,W.MaxXTxts-1);
    W.PutPTxtXY(0,8,PathDraw);
    W.SetKrBorder;
    W.PutTxtXY(0,10,'PCX');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,11,W.MaxXTxts-1);
    W.PutPTxtXY(0,11,PathPCX);
    W.ClrWn(0,13,W.MaxXTxts,W.MaxYTXts-2,W.XColrs.Border);
   End;
   5 :
   Begin
    W.SetKrBorder;
    W.PutTxtXY(0,7,'Mod');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,8,W.MaxXTxts-1);
    W.PutPTxtXY(0,8,PathMod);
    W.ClrWn(0,10,W.MaxXTxts,W.MaxYTXts-2,W.XColrs.Border);
   End;
   6 :
   Begin
    W.ClrWn(0,8,W.MaxXTxts,W.MaxYTXts-2,W.XColrs.Border);
    W.SetKrBorder;
    W.PutTxtXY(0,7,'Liste de t‚l‚phone');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,8,31);
    W.PutPTxtXY(0,8,PathPhoneList);
    W.SetKrBorder;
    W.PutTxtXY(34,7,'Envoie de fichier');
    W.SetKr($8F);
    W.BarSpcHorShade(34,8,W.MaxXTxts-1);
    W.PutPTxtXY(34,8,PathUpLoad);
    W.SetKrBorder;
    W.PutTxtXY(0,10,'R‚ception de fichier');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,11,31);
    W.PutPTxtXY(0,11,PathDownLoad);
    W.SetKrBorder;
    W.PutTxtXY(34,10,'B.B.S.');
    W.SetKr($8F);
    W.BarSpcHorShade(34,11,W.MaxXTxts-1);
    W.PutPTxtXY(34,11,PathBBS);
   End;
   7 :
   Begin
    W.ClrWn(0,7,W.MaxXTxts,W.MaxYTXts-2,W.XColrs.Border);
    W.SetKrBorder;
    W.PutTxtXY(0,7,'Ada');
    W.SetKr($8F);
    W.BarSpcHorShade(0,8,20);
    W.PutPTxtXY(0,8,PathAda);
    W.SetKrBorder;
    W.PutTxtXY(23,7,'Assembleur');
    W.SetKr($8F);
    W.BarSpcHorShade(23,8,43);
    W.PutPTxtXY(23,8,PathAsm);
    W.SetKrBorder;
    W.PutTxtXY(46,7,'Basic');
    W.SetKr($8F);
    W.BarSpcHorShade(46,8,W.MaxXTxts-1);
    W.PutPTxtXY(46,8,PathBas);
    W.SetKrBorder;
    W.PutTxtXY(0,10,'C/C++');
    W.SetKr($8F);
    W.BarSpcHorShade(0,11,20);
    W.PutPTxtXY(0,11,PathC);
    W.SetKrBorder;
    W.PutTxtXY(23,10,'Cobol');
    W.SetKr($8F);
    W.BarSpcHorShade(23,11,43);
    W.PutPTxtXY(23,11,PathCobol);
    W.SetKrBorder;
    W.PutTxtXY(46,10,'Euphoria');
    W.SetKr($8F);
    W.BarSpcHorShade(46,11,W.MaxXTxts-1);
    W.PutPTxtXY(46,11,PathEuphoria);
    W.SetKrBorder;
    W.PutTxtXY(0,13,'Forth');
    W.SetKr($8F);
    W.BarSpcHorShade(0,14,20);
    W.PutPTxtXY(0,14,PathForth);
    W.SetKrBorder;
    W.PutTxtXY(23,13,'Fortran');
    W.SetKr($8F);
    W.BarSpcHorShade(23,14,43);
    W.PutPTxtXY(23,14,PathFortran);
    W.SetKrBorder;
    W.PutTxtXY(46,13,'Pascal');
    W.SetKr($8F);
    W.BarSpcHorShade(46,14,W.MaxXTxts-1);
    W.PutPTxtXY(46,14,PathPas);
   End;
   8 :
   Begin
    W.ClrWn(0,8,W.MaxXTxts,W.MaxYTXts-2,W.XColrs.Border);
    W.SetKrBorder;
    W.PutTxtXY(0,7,'Objet');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,8,31);
    W.PutPTxtXY(0,8,PathObject);
    W.SetKrBorder;
    W.PutTxtXY(34,7,'Resource');
    W.SetKr($8F);
    W.BarSpcHorShade(34,8,W.MaxXTxts-1);
    W.PutPTxtXY(34,8,PathResource);
    W.SetKrBorder;
    W.PutTxtXY(0,10,'Sortie');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,11,31);
    W.PutPTxtXY(0,11,PathOutput);
    W.SetKrBorder;
    W.PutTxtXY(34,10,'Unit‚');
    W.SetKr($8F);
    W.BarSpcHorShade(34,11,W.MaxXTxts-1);
    W.PutPTxtXY(34,11,PathUnit);
   End;
   9 :
   Begin
    W.ClrWn(0,7,W.MaxXTxts,W.MaxYTXts-2,W.XColrs.Border);
    W.SetKrBorder;
    W.PutTxtXY(0,7,'Adams');
    W.SetKr($8F);
    W.BarSpcHorShade(0,8,20);
    W.PutPTxtXY(0,8,PathAdams);
    W.SetKrBorder;
    W.PutTxtXY(23,7,'Apple ][');
    W.SetKr($8F);
    W.BarSpcHorShade(23,8,43);
    W.PutPTxtXY(23,8,PathAppleII);
    W.SetKrBorder;
    W.PutTxtXY(46,7,'Apple Macintosh');
    W.SetKr($8F);
    W.BarSpcHorShade(46,8,W.MaxXTxts-1);
    W.PutPTxtXY(46,8,PathAppleMac);
    W.SetKrBorder;
    W.PutTxtXY(0,10,'Atari 2600');
    W.SetKr($8F);
    W.BarSpcHorShade(0,11,20);
    W.PutPTxtXY(0,11,PathAtari2600);
    W.SetKrBorder;
    W.PutTxtXY(23,10,'TRS-80');
    W.SetKr($8F);
    W.BarSpcHorShade(23,11,43);
    W.PutPTxtXY(23,11,PathTRS80);
    W.SetKrBorder;
    W.PutTxtXY(46,10,'Coco 3');
    W.SetKr($8F);
    W.BarSpcHorShade(46,11,W.MaxXTxts-1);
    W.PutPTxtXY(46,11,PathCoco3);
    W.SetKrBorder;
    W.PutTxtXY(0,13,'Commodore Amiga');
    W.SetKr($8F);
    W.BarSpcHorShade(0,14,20);
    W.PutPTxtXY(0,14,PathAmiga);
    W.SetKrBorder;
    W.PutTxtXY(23,13,'Commodore 64K');
    W.SetKr($8F);
    W.BarSpcHorShade(23,14,43);
    W.PutPTxtXY(23,14,PathCommodore64);
    W.SetKrBorder;
    W.PutTxtXY(46,13,'Commodore VIC-20');
    W.SetKr($8F);
    W.BarSpcHorShade(46,14,W.MaxXTxts-1);
    W.PutPTxtXY(46,14,PathVic20);
   End;
   10 :
   Begin
    W.ClrWn(0,8,W.MaxXTxts,W.MaxYTXts-2,W.XColrs.Border);
    W.SetKrBorder;
    W.PutTxtXY(0,7,'Malte');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,8,31);
    W.PutPTxtXY(0,8,PathSystems);
    W.SetKrBorder;
    W.PutTxtXY(34,7,'OS/2');
    W.SetKr($8F);
    W.BarSpcHorShade(34,8,W.MaxXTxts-1);
    W.PutPTxtXY(34,8,PathOS2);
    W.SetKrBorder;
    W.PutTxtXY(0,10,'Unix');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,11,31);
    W.PutPTxtXY(0,11,PathUnix);
    W.SetKrBorder;
    W.PutTxtXY(34,10,'Windows');
    W.SetKr($8F);
    W.BarSpcHorShade(34,11,W.MaxXTxts-1);
    W.PutPTxtXY(34,11,PathWin);
   End;
   11 :
   Begin
    W.SetKrBorder;
    W.PutTxtXY(0,7,'Pays');
    W.ClrEol;
    W.SetKr($8F);
    W.BarSpcHorShade(0,8,W.MaxXTxts-1);
    W.PutPTxtXY(0,8,PathCountry);
    W.ClrWn(0,10,W.MaxXTxts,W.MaxYTXts-2,W.XColrs.Border);
   End;
  End;
 End;

Begin
 W.InitO(70,20);
 W.PushWn;
 W.PutWn('R‚pertoire',CurrColors.Dialog.Wins);
 SetShade(False);
 W.SubList(0,1,W.MaxXTxts-1,5,'Cat‚gorie',L);
 L.PutSmallShade;
 L.AddStrByte('Traitement de texte',1);
 L.AddStrByte('Chiffrier ‚lectronique',2);
 L.AddStrByte('Catalogue',3);
 L.AddStrByte('Imagerie/Dessin',4);
 L.AddStrByte('Musique',5);
 L.AddStrByte('T‚l‚matique',6);
 L.AddStrByte('Programmation',7);
 L.AddStrByte('Outils de programmation',8);
 L.AddStrByte('Emulateur ordinateur',9);
 L.AddStrByte('SystŠme d''exploitation',10);
 L.AddStrByte('Symbole',11);
 L.Refresh;
 L.SelBarInactive;
 W.PutkHorDn('Correcte|Annule');
 P        := 0;
 PP       := 0;
 PPathBuf := PathBuf;
 UpDateDir;
 TPathGatt        := StrNew(PathGatt);
 TPathMac         := StrNew(PathMac);
 TPathCalc        := StrNew(PathCalc);
 TPathCatDisk     := StrNew(PathCatDisk);
 TPathDraw        := StrNew(PathDraw);
 TPathPCX         := StrNew(PathPCX);
 TPathMod         := StrNew(PathMod);
 TPathPhoneList   := StrNew(PathPhoneList);
 TPathUpLoad      := StrNew(PathUpLoad);
 TPathDownLoad    := StrNew(PathDownLoad);
 TPathBBS         := StrNew(PathBBS);
 TPathAda         := StrNew(PathAda);
 TPathAsm         := StrNew(PathAsm);
 TPathBas         := StrNew(PathBas);
 TPathC           := StrNew(PathC);
 TPathCobol       := StrNew(PathCobol);
 TPathEuphoria    := StrNew(PathEuphoria);
 TPathForth       := StrNew(PathForth);
 TPathFortran     := StrNew(PathFortran);
 TPathPas         := StrNew(PathPas);
 TPathObject      := StrNew(PathObject);
 TPathResource    := StrNew(PathResource);
 TPathOutput      := StrNew(PathOutput);
 TPathUnit        := StrNew(PathUnit);
 TPathAdams       := StrNew(PathAdams);
 TPathAppleII     := StrNew(PathAppleII);
 TPathAppleMac    := StrNew(PathAppleMac);
 TPathAtari2600   := StrNew(PathAtari2600);
 TPathTRS80       := StrNew(PathTRS80);
 TPathCoco3       := StrNew(PathCoco3);
 TPathAmiga       := StrNew(PathAmiga);
 TPathCommodore64 := StrNew(PathCommodore64);
 TPathVic20       := StrNew(PathVic20);
 TPathSystems     := StrNew(PathSystems);
 TPathOS2         := StrNew(PathOS2);
 TPathUnix        := StrNew(PathUnix);
 TPathWin         := StrNew(PathWin);
 TPathCountry     := StrNew(PathCountry);
 W.SetInpColrs($8F,W.XColrs.Sel);
 Repeat
  Case P of
   0 : Begin
        PP := 0;
        L.SelBar;
	K := ReadKey;
        L.SelBarInactive;
        Case K of
           kbUp : Begin
                  L.kUp;
                  UpDateDir;
                 End;
         kbDn : Begin
                  L.kDn;
                  UpDateDir;
                 End;
          kbTab : P := 1;
          kbEsc : Break;
        End;
       End;
   1 : Case L.GetVal of
         1 :
         Begin
          Case PP of
           0 : Begin
                If(TPathGatt = NIL)Then StrCopy(PathBuf,'')
                                   Else StrCopy(PathBuf,TPathGatt);
                K := W._Input(0,8,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathGatt);
                TPathGatt := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,8,W.MaxXTxts-1);
                Case K of
                        kbEsc : Break;
                         kbUp : P := 0;
                 kbDown,kbTab : PP := 1;
                      kbEnter : P := 2;
                End;
               End;
           1 : Begin
                If(TPathMac = NIL)Then StrCopy(PathBuf,'')
                                  Else StrCopy(PathBuf,TPathMac);
                K := W._Input(0,11,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathMac);
                TPathMac := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,11,W.MaxXTxts-1);
                Case K of
                        kbEsc : Break;
                         kbUp : PP := 0;
                 kbDown,kbTab : P := 2;
                      kbEnter : P := 2;
                End;
               End;
           End;
         End;
         2 :
         Begin
          If(TPathCalc = NIL)Then StrCopy(PathBuf,'')
                             Else StrCopy(PathBuf,TPathCalc);
          K := W._Input(0,8,W.MaxXTxts-1,80,PPathBuf);
          StrDispose(TPathCalc);
          TPathCalc := StrNew(PPathBuf);
          W.SetKr($8F);
          W.BarSelHor(0,8,W.MaxXTxts-1);
          Case K of
                  kbEsc : Break;
                   kbUp : P := 0;
           kbDown,kbTab : P := 2;
                kbEnter : P := 2;
          End;
         End;
         3 :
         Begin
          If(TPathCatDisk = NIL)Then StrCopy(PathBuf,'')
                                Else StrCopy(PathBuf,TPathCatDisk);
          K := W._Input(0,8,W.MaxXTxts-1,80,PPathBuf);
          StrDispose(TPathCatDisk);
          TPathCatDisk := StrNew(PPathBuf);
          W.SetKr($8F);
          W.BarSelHor(0,8,W.MaxXTxts-1);
          Case K of
                  kbEsc : Break;
                   kbUp : P := 0;
           kbDown,kbTab : P := 2;
                kbEnter : P := 2;
          End;
         End;
         4 :
         Begin
          Case PP of
           0 : Begin
                If(TPathDraw = NIL)Then StrCopy(PathBuf,'')
                                   Else StrCopy(PathBuf,TPathDraw);
                K := W._Input(0,8,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathDraw);
                TPathDraw := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,8,W.MaxXTxts-1);
                Case K of
                        kbEsc : Break;
                         kbUp : P := 0;
                 kbDown,kbTab : PP := 1;
                      kbEnter : P := 2;
                End;
               End;
           1 : Begin
                If(TPathPCX = NIL)Then StrCopy(PathBuf,'')
                                  Else StrCopy(PathBuf,TPathPCX);
                K := W._Input(0,11,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathPCX);
                TPathPCX := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,11,W.MaxXTxts-1);
                Case K of
                        kbEsc : Break;
                         kbUp : PP := 0;
                 kbDown,kbTab : P := 2;
                      kbEnter : P := 2;
                End;
               End;
           End;
         End;
         5 :
         Begin
          If(TPathMod = NIL)Then StrCopy(PathBuf,'')
                            Else StrCopy(PathBuf,TPathMod);
          K := W._Input(0,8,W.MaxXTxts-1,80,PPathBuf);
          StrDispose(TPathMod);
          TPathMod := StrNew(PPathBuf);
          W.SetKr($8F);
          W.BarSelHor(0,8,W.MaxXTxts-1);
          Case K of
                  kbEsc : Break;
                   kbUp : P := 0;
           kbDown,kbTab : P := 2;
                kbEnter : P := 2;
          End;
         End;
         6 :
         Begin
          Case PP of
           0 : Begin
                If(TPathPhoneList = NIL)Then StrCopy(PathBuf,'')
                                        Else StrCopy(PathBuf,TPathPhoneList);
                K := W._Input(0,8,31,80,PPathBuf);
                StrDispose(TPathPhoneList);
                TPathPhoneList := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,8,31);
                Case K of
                   kbEsc : Break;
                    kbUp : P := 0;
                  kbDown : PP := 2;
                   kbTab : PP := 1;
                 kbEnter : P := 2;
                End;
               End;
           1 : Begin
                If(TPathUpLoad = NIL)Then StrCopy(PathBuf,'')
                                     Else StrCopy(PathBuf,TPathUpLoad);
                K := W._Input(34,8,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathUpLoad);
                TPathUpLoad := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(34,8,W.MaxXTxts-1);
                Case K of
                   kbEsc : Break;
                    kbUp : P := 0;
                  kbDown : PP := 3;
                   kbTab : PP := 2;
                 kbEnter : P := 2;
                End;
               End;
           2 : Begin
                If(TPathDownLoad = NIL)Then StrCopy(PathBuf,'')
                                       Else StrCopy(PathBuf,TPathDownLoad);
                K := W._Input(0,11,31,80,PPathBuf);
                StrDispose(TPathDownLoad);
                TPathDownLoad := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,11,31);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 0;
                  kbDown : P := 2;
                   kbTab : PP := 3;
                 kbEnter : P := 2;
                End;
               End;
           3 : Begin
                If(TPathBBS = NIL)Then StrCopy(PathBuf,'')
                                  Else StrCopy(PathBuf,TPathBBS);
                K := W._Input(34,11,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathBBS);
                TPathBBS := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(34,11,W.MaxXTxts-1);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 1;
                  kbDown : P := 2;
                   kbTab : P := 2;
                 kbEnter : P := 2;
                End;
               End;
           End;
         End;
         7 :
         Begin
          Case PP of
           0 : Begin
                If(TPathAda = NIL)Then StrCopy(PathBuf,'')
                                  Else StrCopy(PathBuf,TPathAda);
                K := W._Input(0,8,20,80,PPathBuf);
                StrDispose(TPathAda);
                TPathAda := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,8,20);
                Case K of
                   kbEsc : Break;
                    kbUp : P := 0;
                  kbDown : PP := 3;
                   kbTab : PP := 1;
                 kbEnter : P := 2;
                End;
               End;
           1 : Begin
                If(TPathAsm = NIL)Then StrCopy(PathBuf,'')
                                  Else StrCopy(PathBuf,TPathAsm);
                K := W._Input(23,8,43,80,PPathBuf);
                StrDispose(TPathAsm);
                TPathAsm := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(23,8,43);
                Case K of
                   kbEsc : Break;
                    kbUp : P := 0;
                kbDown : PP := 4;
                 kbTab : PP := 2;
                 kbEnter : P := 2;
                End;
               End;
           2 : Begin
                If(TPathBas = NIL)Then StrCopy(PathBuf,'')
                                  Else StrCopy(PathBuf,TPathBas);
                K := W._Input(46,8,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathBas);
                TPathBas := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(46,8,W.MaxXTxts-1);
                Case K of
                   kbEsc : Break;
                    kbUp : P := 0;
                kbDown : PP := 5;
                 kbTab : PP := 3;
                 kbEnter : P := 2;
                End;
               End;
           3 : Begin
                If(TPathC = NIL)Then StrCopy(PathBuf,'')
                                Else StrCopy(PathBuf,TPathC);
                K := W._Input(0,11,20,80,PPathBuf);
                StrDispose(TPathC);
                TPathC := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,11,20);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 0;
                kbDown : PP := 6;
                 kbTab : PP := 4;
                 kbEnter : P := 2;
                End;
               End;
           4 : Begin
                If(TPathCobol = NIL)Then StrCopy(PathBuf,'')
                                    Else StrCopy(PathBuf,TPathCobol);
                K := W._Input(23,11,43,80,PPathBuf);
                StrDispose(TPathCobol);
                TPathCobol := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(23,11,43);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 1;
                kbDown : PP := 7;
                 kbTab : PP := 5;
                 kbEnter : P := 2;
                End;
               End;
           5 : Begin
                If(TPathEuphoria = NIL)Then StrCopy(PathBuf,'')
                                       Else StrCopy(PathBuf,TPathEuphoria);
                K := W._Input(46,11,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathEuphoria);
                TPathEuphoria := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(46,11,W.MaxXTxts-1);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 2;
                kbDown : PP := 8;
                 kbTab : PP := 6;
                 kbEnter : P := 2;
                End;
               End;
           6 : Begin
                If(TPathForth = NIL)Then StrCopy(PathBuf,'')
                                    Else StrCopy(PathBuf,TPathForth);
                K := W._Input(0,14,20,80,PPathBuf);
                StrDispose(TPathForth);
                TPathForth := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,14,20);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 3;
                kbDown : P := 2;
                 kbTab : PP := 7;
                 kbEnter : P := 2;
                End;
               End;
           7 : Begin
                If(TPathFortran = NIL)Then StrCopy(PathBuf,'')
                                      Else StrCopy(PathBuf,TPathFortran);
                K := W._Input(23,14,43,80,PPathBuf);
                StrDispose(TPathFortran);
                TPathFortran := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(23,14,43);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 4;
                kbDown : P := 2;
                 kbTab : PP := 8;
                 kbEnter : P := 2;
                End;
               End;
           8 : Begin
                If(TPathPas = NIL)Then StrCopy(PathBuf,'')
                                  Else StrCopy(PathBuf,TPathPas);
                K := W._Input(46,14,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathPas);
                TPathPas := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(46,14,W.MaxXTxts-1);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 5;
                kbDown : P := 2;
                 kbTab : P := 2;
                 kbEnter : P := 2;
                End;
               End;
           End;
         End;
         8 :
         Begin
          Case PP of
           0 : Begin
                If(TPathObject = NIL)Then StrCopy(PathBuf,'')
                                     Else StrCopy(PathBuf,TPathObject);
                K := W._Input(0,8,31,80,PPathBuf);
                StrDispose(TPathObject);
                TPathObject := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,8,31);
                Case K of
                   kbEsc : Break;
                    kbUp : P := 0;
                  kbDown : PP := 2;
                   kbTab : PP := 1;
                 kbEnter : P := 2;
                End;
               End;
           1 : Begin
                If(TPathResource = NIL)Then StrCopy(PathBuf,'')
                                       Else StrCopy(PathBuf,TPathResource);
                K := W._Input(34,8,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathResource);
                TPathResource := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(34,8,W.MaxXTxts-1);
                Case K of
                   kbEsc : Break;
                    kbUp : P := 0;
                  kbDown : PP := 3;
                   kbTab : PP := 2;
                 kbEnter : P := 2;
                End;
               End;
           2 : Begin
                If(TPathOutput = NIL)Then StrCopy(PathBuf,'')
                                     Else StrCopy(PathBuf,TPathOutput);
                K := W._Input(0,11,31,80,PPathBuf);
                StrDispose(TPathOutput);
                TPathOutput := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,11,31);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 0;
                  kbDown : P := 2;
                   kbTab : PP := 3;
                 kbEnter : P := 2;
                End;
               End;
           3 : Begin
                If(TPathUnit = NIL)Then StrCopy(PathBuf,'')
                                   Else StrCopy(PathBuf,TPathUnit);
                K := W._Input(34,11,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathUnit);
                TPathUnit := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(34,11,W.MaxXTxts-1);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 1;
                  kbDown : P := 2;
                   kbTab : P := 2;
                 kbEnter : P := 2;
                End;
               End;
           End;
         End;
         9 :
         Begin
          Case PP of
           0 : Begin
                If(TPathAdams = NIL)Then StrCopy(PathBuf,'')
                                    Else StrCopy(PathBuf,TPathAdams);
                K := W._Input(0,8,20,80,PPathBuf);
                StrDispose(TPathAdams);
                TPathAdams := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,8,20);
                Case K of
                   kbEsc : Break;
                    kbUp : P := 0;
                  kbDown : PP := 3;
                   kbTab : PP := 1;
                 kbEnter : P := 2;
                End;
               End;
           1 : Begin
                If(TPathAppleII = NIL)Then StrCopy(PathBuf,'')
                                      Else StrCopy(PathBuf,TPathAppleII);
                K := W._Input(23,8,43,80,PPathBuf);
                StrDispose(TPathAppleII);
                TPathAppleII := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(23,8,43);
                Case K of
                   kbEsc : Break;
                    kbUp : P := 0;
                kbDown : PP := 4;
                 kbTab : PP := 2;
                 kbEnter : P := 2;
                End;
               End;
           2 : Begin
                If(TPathAppleMac = NIL)Then StrCopy(PathBuf,'')
                                       Else StrCopy(PathBuf,TPathAppleMac);
                K := W._Input(46,8,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathAppleMac);
                TPathAppleMac := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(46,8,W.MaxXTxts-1);
                Case K of
                   kbEsc : Break;
                    kbUp : P := 0;
                kbDown : PP := 5;
                 kbTab : PP := 3;
                 kbEnter : P := 2;
                End;
               End;
           3 : Begin
                If(TPathAtari2600 = NIL)Then StrCopy(PathBuf,'')
                                        Else StrCopy(PathBuf,TPathAtari2600);
                K := W._Input(0,11,20,80,PPathBuf);
                StrDispose(TPathAtari2600);
                TPathAtari2600 := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,11,20);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 0;
                kbDown : PP := 6;
                 kbTab : PP := 4;
                 kbEnter : P := 2;
                End;
               End;
           4 : Begin
                If(TPathTRS80 = NIL)Then StrCopy(PathBuf,'')
                                    Else StrCopy(PathBuf,TPathTRS80);
                K := W._Input(23,11,43,80,PPathBuf);
                StrDispose(TPathTRS80);
                TPathTRS80 := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(23,11,43);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 1;
                kbDown : PP := 7;
                 kbTab : PP := 5;
                 kbEnter : P := 2;
                End;
               End;
           5 : Begin
                If(TPathCoco3 = NIL)Then StrCopy(PathBuf,'')
                                    Else StrCopy(PathBuf,TPathCoco3);
                K := W._Input(46,11,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathCoco3);
                TPathCoco3 := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(46,11,W.MaxXTxts-1);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 2;
                kbDown : PP := 8;
                 kbTab : PP := 6;
                 kbEnter : P := 2;
                End;
               End;
           6 : Begin
                If(TPathAmiga = NIL)Then StrCopy(PathBuf,'')
                                    Else StrCopy(PathBuf,TPathAmiga);
                K := W._Input(0,14,20,80,PPathBuf);
                StrDispose(TPathAmiga);
                TPathAmiga := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,14,20);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 3;
                kbDown : P := 2;
                 kbTab : PP := 7;
                 kbEnter : P := 2;
                End;
               End;
           7 : Begin
                If(TPathCommodore64 = NIL)Then StrCopy(PathBuf,'')
                                          Else StrCopy(PathBuf,TPathCommodore64);
                K := W._Input(23,14,43,80,PPathBuf);
                StrDispose(TPathCommodore64);
                TPathCommodore64 := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(23,14,43);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 4;
                kbDown : P := 2;
                 kbTab : PP := 8;
                 kbEnter : P := 2;
                End;
               End;
           8 : Begin
                If(TPathVic20 = NIL)Then StrCopy(PathBuf,'')
                                    Else StrCopy(PathBuf,TPathVic20);
                K := W._Input(46,14,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathVic20);
                TPathVic20 := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(46,14,W.MaxXTxts-1);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 5;
                kbDown : P := 2;
                 kbTab : P := 2;
                 kbEnter : P := 2;
                End;
               End;
           End;
         End;
         10 :
         Begin
          Case PP of
           0 : Begin
                If(TPathSystems = NIL)Then StrCopy(PathBuf,'')
                                      Else StrCopy(PathBuf,TPathSystems);
                K := W._Input(0,8,31,80,PPathBuf);
                StrDispose(TPathSystems);
                TPathSystems := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,8,31);
                Case K of
                   kbEsc : Break;
                    kbUp : P := 0;
                  kbDown : PP := 2;
                   kbTab : PP := 1;
                 kbEnter : P := 2;
                End;
               End;
           1 : Begin
                If(TPathOS2 = NIL)Then StrCopy(PathBuf,'')
                                  Else StrCopy(PathBuf,TPathOS2);
                K := W._Input(34,8,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathOS2);
                TPathOS2 := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(34,8,W.MaxXTxts-1);
                Case K of
                   kbEsc : Break;
                    kbUp : P := 0;
                  kbDown : PP := 3;
                   kbTab : PP := 2;
                 kbEnter : P := 2;
                End;
               End;
           2 : Begin
                If(TPathUnix = NIL)Then StrCopy(PathBuf,'')
                                   Else StrCopy(PathBuf,TPathUnix);
                K := W._Input(0,11,31,80,PPathBuf);
                StrDispose(TPathUnix);
                TPathUnix := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(0,11,31);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 0;
                  kbDown : P := 2;
                   kbTab : PP := 3;
                 kbEnter : P := 2;
                End;
               End;
           3 : Begin
                If(TPathWin = NIL)Then StrCopy(PathBuf,'')
                                  Else StrCopy(PathBuf,TPathWin);
                K := W._Input(34,11,W.MaxXTxts-1,80,PPathBuf);
                StrDispose(TPathWin);
                TPathWin := StrNew(PPathBuf);
                W.SetKr($8F);
                W.BarSelHor(34,11,W.MaxXTxts-1);
                Case K of
                   kbEsc : Break;
                    kbUp : PP := 1;
                  kbDown : P := 2;
                   kbTab : P := 2;
                 kbEnter : P := 2;
                End;
               End;
           End;
         End;
         11 :
         Begin
          If(TPathCountry = NIL)Then StrCopy(PathBuf,'')
                                Else StrCopy(PathBuf,TPathCountry);
          K := W._Input(0,8,W.MaxXTxts-1,80,PPathBuf);
          StrDispose(TPathCountry);
          TPathCountry := StrNew(PPathBuf);
          W.SetKr($8F);
          W.BarSelHor(0,8,W.MaxXTxts-1);
          Case K of
                  kbEsc : Break;
                   kbUp : P := 0;
           kbDown,kbTab : P := 2;
                kbEnter : P := 2;
          End;
         End;
        End;
   2 : Begin
        PP := 0;
	K := W.GetkHorDn('Correcte|Annule');
        Case K of
           kbEsc : Break;
         kbEnter : Begin
                    StrDispose(PathGatt);
                    StrDispose(PathMac);
                    StrDispose(PathCalc);
                    StrDispose(PathCatDisk);
                    StrDispose(PathDraw);
                    StrDispose(PathPCX);
                    StrDispose(PathMod);
                    StrDispose(PathPhoneList);
                    StrDispose(PathUpLoad);
                    StrDispose(PathDownLoad);
                    StrDispose(PathBBS);
                    StrDispose(PathAda);
                    StrDispose(PathAsm);
                    StrDispose(PathBas);
                    StrDispose(PathC);
                    StrDispose(PathCobol);
                    StrDispose(PathEuphoria);
                    StrDispose(PathForth);
                    StrDispose(PathFortran);
                    StrDispose(PathPas);
                    StrDispose(PathObject);
                    StrDispose(PathResource);
                    StrDispose(PathOutput);
                    StrDispose(PathUnit);
                    StrDispose(PathAdams);
                    StrDispose(PathAppleII);
                    StrDispose(PathAppleMac);
                    StrDispose(PathAtari2600);
                    StrDispose(PathTRS80);
                    StrDispose(PathCoco3);
                    StrDispose(PathAmiga);
                    StrDispose(PathCommodore64);
                    StrDispose(PathVic20);
                    StrDispose(PathSystems);
                    StrDispose(PathOS2);
                    StrDispose(PathUnix);
                    StrDispose(PathWin);
                    StrDispose(PathCountry);
                    PathGatt             := StrNew(TPathGatt);
                    PathMac              := StrNew(TPathMac);
                    PathCalc             := StrNew(TPathCalc);
                    PathCatDisk          := StrNew(TPathCatDisk);
                    PathDraw             := StrNew(TPathDraw);
                    PathPCX              := StrNew(TPathPCX);
                    PathMod              := StrNew(TPathMod);
                    PathPhoneList        := StrNew(TPathPhoneList);
                    PathUpLoad           := StrNew(TPathUpLoad);
                    PathDownLoad         := StrNew(TPathDownLoad);
                    PathBBS              := StrNew(TPathBBS);
                    PathAda              := StrNew(TPathAda);
                    PathAsm              := StrNew(TPathAsm);
                    PathBas              := StrNew(TPathBas);
                    PathC                := StrNew(TPathC);
                    PathCobol            := StrNew(TPathCobol);
                    PathEuphoria         := StrNew(TPathEuphoria);
                    PathForth            := StrNew(TPathForth);
                    PathFortran          := StrNew(TPathFortran);
                    PathPas              := StrNew(TPathPas);
                    PathObject           := StrNew(TPathObject);
                    PathResource         := StrNew(TPathResource);
                    PathOutput           := StrNew(TPathOutput);
                    PathUnit             := StrNew(TPathUnit);
                    PathAdams            := StrNew(TPathAdams);
                    PathAppleII          := StrNew(TPathAppleII);
                    PathAppleMac         := StrNew(TPathAppleMac);
                    PathAtari2600        := StrNew(TPathAtari2600);
                    PathTRS80            := StrNew(TPathTRS80);
                    PathCoco3            := StrNew(TPathCoco3);
                    PathAmiga            := StrNew(TPathAmiga);
                    PathCommodore64      := StrNew(TPathCommodore64);
                    PathVic20            := StrNew(TPathVic20);
                    PathSystems          := StrNew(TPathSystems);
                    PathOS2              := StrNew(TPathOS2);
                    PathUnix             := StrNew(TPathUnix);
                    PathWin              := StrNew(TPathWin);
                    PathCountry          := StrNew(TPathCountry);
                    Break;
                   End;
           kbTab : P := 0;
         End;
        End;
  End;
 Until False;
 StrDispose(TPathGatt);
 StrDispose(TPathMac);
 StrDispose(TPathCalc);
 StrDispose(TPathCatDisk);
 StrDispose(TPathDraw);
 StrDispose(TPathPCX);
 StrDispose(TPathMod);
 StrDispose(TPathPhoneList);
 StrDispose(TPathUpLoad);
 StrDispose(TPathDownLoad);
 StrDispose(TPathBBS);
 StrDispose(TPathAda);
 StrDispose(TPathAsm);
 StrDispose(TPathBas);
 StrDispose(TPathC);
 StrDispose(TPathCobol);
 StrDispose(TPathEuphoria);
 StrDispose(TPathForth);
 StrDispose(TPathFortran);
 StrDispose(TPathPas);
 StrDispose(TPathObject);
 StrDispose(TPathResource);
 StrDispose(TPathOutput);
 StrDispose(TPathUnit);
 StrDispose(TPathAdams);
 StrDispose(TPathAppleII);
 StrDispose(TPathAppleMac);
 StrDispose(TPathAtari2600);
 StrDispose(TPathTRS80);
 StrDispose(TPathCoco3);
 StrDispose(TPathAmiga);
 StrDispose(TPathCommodore64);
 StrDispose(TPathVic20);
 StrDispose(TPathSystems);
 StrDispose(TPathOS2);
 StrDispose(TPathUnix);
 StrDispose(TPathWin);
 StrDispose(TPathCountry);
 SetShade(True);
 W.Done;
End;

BEGIN
END.