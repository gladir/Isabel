{⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
 ≥                                                            ≥
 ≥      Malte Genesis III/Module des Outils de l'êditeur      ≥
 ≥                Edition Isabel pour Mode RÇel               ≥
 ≥                      III - Version 1.0                     ≥
 ≥                         1995/02/02                         ≥
 ≥                                                            ≥
 ≥       Copyright (C) par les Chevaliers de Malte            ≥
 ≥                                                            ≥
 ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ}

Unit ToolEdit;

INTERFACE

{$IFDEF Overlay}
 {$O+,F+}
{$ENDIF}

Uses Math;

Type

     InfoPrintRec = Record
       NumCopy,StartPage,EndPage:Word;
       Justify,Compress:Bool;
       Quality:(Standard,NLQ);
       Page:(None,Left,Right,Altern);
       AddPage:Long;
       PrnType:Array[0..12] of Byte;
       PrnOutput:Word;
      End;

Function SetFormatPage(Var X1:Word;Var Y1:LongInt;Var X2:Word;Var Y2:Long):Bool;
Function WinPrint(Var Data:InfoPrintRec):Bool;
Function WinPrnAscii(Var Start,_End:Long;Var Merge:Word;Var Compress:Bool):Bool;

IMPLEMENTATION

Uses Dos,Strs,Memorys,Video,Windows,Printers,Strings,Terminal,
     Systems,Language,Keyboard,ToolPrn,Cursor,Dials;

Function WinPrint;
Var W:Wins; SelPrn:SelectPrn; SelPrnOut:SelectPrnOutput;
    CharQuality,Page:SwitchOption; P:Byte; K,Err:Word;
    KChr:Char Absolute K; PBuffer:Array[0..63] of Char; PChr:PChar;
Begin
 WinPrint := False;
 W.InitO(70,18);
 W.PushWn;
 W.PutWn('Imprime',CurrColors.Dialog.Wins);
 W.PutTxtXY(0,1,'Nombre Copie');
 W.PutTxtXY(30,1,'Page');
 W.PutTxtXY(52,1,'Jusqu''Ö');
 W.SetKr($8F);
 W.BarSpcHorShade(13,1,27);
 W.PutTxtXY(13,1,Str(Data.NumCopy));
 W.BarSpcHorShade(35,1,49);
 W.PutTxtXY(35,1,Str(Data.StartPage));
 W.BarSpcHorShade(60,1,W.MaxXTxts-1);
 W.PutTxtXY(60,1,Str(Data.EndPage));
 W.BarSpcHorShade(21,7,32);
 W.PutTxtXY(21,7,Str(Data.AddPage));
 W.SetKrBorder;
 W.PutTxtXY(0,3,'JustifiÇ  ['+Char(32+56*Byte(Data.Justify))+']');
 W.PutTxtXY(0,4,'CompressÇ ['+Char(32+56*Byte(Data.Compress))+']');
 SetAllColor(W.XColrs.Border,(W.XColrs.Border and $F0)+$B);
 With CharQuality do
  Init(W.RX1+1+18,W.RY1+1+3,'QualitÇ','Standard|NLQ',Byte(Data.Quality));
 W.PutTxtXY(0,7,'Additionne Ö la page');
 With Page do
  Init(W.RX1+1+35,W.RY1+1+3,'NumÇro Page','Aucun|Droite|Gauche|AlternÇe',Byte(Data.Page));
 SetShade(False);
 SelPrnOut.Init(Data.PrnOutput,W.RX1+1,W.RY1+10,W.RX1+1+32,W.RY2-4);
 SelPrnOut.PutSmallShade;
 SelPrn.Init(Data.PrnType[Data.PrnOutput],W.RX1+1+35,W.RY1+10,W.RX2-2,W.RY2-4);
 SelPrn.PutSmallShade;
 W.PutkHorDn('Correct|Annule');
 PChr := PBuffer;
 P := 0;
 Repeat
  Case P of
   0 : Begin
        StrPCopy(PBuffer,Str(Data.NumCopy));
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(13,1,27,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(13,1,27);
        Val(StrPas(PChr),Data.NumCopy,Err);
        Case K of
                 kbEsc : Break;
                kbLeft : P := 10;
                kbDown : P := 3;
         kbRight,kbTab : P := 1;
               kbEnter : P := 10;
        End;
       End;
   1 : Begin
        StrPCopy(PBuffer,Str(Data.StartPage));
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(35,1,49,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(35,1,49);
        Val(StrPas(PChr),Data.StartPage,Err);
        Case K of
                 kbEsc : Break;
                kbLeft : P := 0;
                kbDown : P := 3;
         kbRight,kbTab : P := 2;
               kbEnter : P := 10;
        End;
       End;
   2 : Begin
        StrPCopy(PBuffer,Str(Data.EndPage));
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(60,1,W.MaxXTxts-1,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(60,1,W.MaxXTxts-1);
        Val(StrPas(PChr),Data.EndPage,Err);
        Case K of
                 kbEsc : Break;
                kbLeft : P := 1;
         kbRight,kbTab : P := 3;
                kbDown : P := 7;
               kbEnter : P := 10;
        End;
       End;
   3 : Begin
        SimpleCursor;
        W.SetCurPos(11,3);
        K := ReadKey;
        CloseCursor;
        Case K of
                 kbEsc : Break;
                  kbUp : P := 0;
                kbLeft : P := 2;
               kbRight : P := 5;
          kbDown,kbTab : P := 4;
               kbEnter : P := 10;
                    Else Begin
                          If(KChr = ' ')Then
                          Begin
                           Data.Justify := Not(Data.Justify);
                           Case Data.Justify of
                            True : W.SetChr(11,3,'X');
                              Else W.SetChr(11,3,' ');
                           End;
                          End;
                         End;
        End;
       End;
   4 : Begin
        SimpleCursor;
        W.SetCurPos(11,4);
        K := ReadKey;
        CloseCursor;
        Case K of
                 kbEsc : Break;
           kbLeft,kbUp : P := 3;
  kbDown,kbRight,kbTab : P := 5;
               kbEnter : P := 10;
                    Else Begin
                          If(KChr = ' ')Then
                          Begin
                           Data.Compress := Not(Data.Compress);
                           Case Data.Compress of
                            True : W.SetChr(11,4,'X');
                              Else W.SetChr(11,4,' ');
                           End;
                          End;
                         End;
        End;
       End;
   5 : Begin
        SetAllColor(W.XColrs.Border,(W.XColrs.Border and $F0)+$B);
        K := CharQuality.Select;
        Byte(Data.Quality) := CharQuality.GetPos;
        Case K of
                 kbEsc : Break;
                kbLeft : P := 4;
         kbRight,kbTab : P := 6;
               kbEnter : P := 10;
        End;
       End;
   6 : Begin
        StrPCopy(PBuffer,Str(Data.AddPage));
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(21,7,32,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(21,7,32);
        Val(StrPas(PChr),Data.AddPage,Err);
        Case K of
                 kbEsc : Break;
           kbLeft,kbUp : P := 5;
         kbRight,kbTab : P := 7;
                kbDown : P := 8;
               kbEnter : P := 10;
        End;
       End;
   7 : Begin
        SetAllColor(W.XColrs.Border,(W.XColrs.Border and $F0)+$B);
        K := Page.Select;
        Byte(Data.Page) := Page.GetPos;
        Case K of
                 kbEsc : Break;
                kbLeft : P := 6;
         kbRight,kbTab : P := 8;
               kbEnter : P := 10;
        End;
       End;
   8 : Begin
        K := SelPrnOut.Run; Data.PrnOutput := SelPrnOut.GetPrnOut;
        Case K of
                 $F000 : Begin
                          SelPrn.List.P := PrnSetup[Data.PrnOutput].Code;
                          SelPrn.List.Refresh;
                          SelPrn.List.SelBarInactive;
                         End;
                 kbEsc : Break;
                kbLeft : P := 7;
         kbRight,kbTab : P := 9;
      prnLPT1..prnFile : Begin
                          Data.PrnOutput := K; P := 10;
                         End;
        End;
       End;
   9 : Begin
        K := SelPrn.Run;
        Data.PrnType[Data.PrnOutput] := SelPrn.GetPrn;
        Case K of
                 kbEsc : Break;
                kbLeft : P := 8;
         kbRight,kbTab : P := 10;
     0..prnStarXB24_15 : Begin
                          PrnSetup[PrnOutput].Code := K; P := 10;
                         End;
        End;
       End;
  10 : Begin
        K := W.GetkHorDn('Correct|Annule');
        Case K of
           kbEsc,1 : Break;
             kbTab : P := 0;
                 0 : Begin
                      WinPrint := True;
                      Break;
                     End;
        End;
       End;
  End;
 Until False;
 SetShade(True);
 SelPrn.Done;
 SelPrnOut.Done;
 CharQuality.Done;
 Page.Done;
 W.Done;
End;

Function SetFormatPage;
Var W:Wins; P:Byte; K,Err:Word; KChr:Char Absolute K;
    PBuffer:Array[0..63] of Char; PChr:PChar;
Begin
 SetFormatPage := False;
 W.InitO(30,13);
 W.PushWn;
 W.PutWn('Format Page',CurrColors.Dialog.Wins);
 W.PutTxtXY(0,1,'Marge Gauche');
 W.PutTxtXY(0,3,'Marge Droite');
 W.PutTxtXY(0,5,'Marge Haut');
 W.PutTxtXY(0,7,'Marge Bas');
 W.SetKr($8F);
 W.BarSpcHorShade(13,1,W.MaxXTxts-1);
 W.PutTxtXY(13,1,Str(X1));
 W.BarSpcHorShade(13,3,W.MaxXTxts-1);
 W.PutTxtXY(13,3,Str(X2));
 W.BarSpcHorShade(13,5,W.MaxXTxts-1);
 W.PutTxtXY(13,5,Str(Y1));
 W.BarSpcHorShade(13,7,W.MaxXTxts-1);
 W.PutTxtXY(13,7,Str(Y2));
 P := 0;
 W.PutkHorDn('Correct|Annule');
 PChr := PBuffer;
 Repeat
  Case P of
   0 : Begin
        StrPCopy(PBuffer,Str(X1));
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(13,1,W.MaxXTxts-1,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(13,1,W.MaxXTxts-1);
        Val(StrPas(PChr),X1,Err);
        Case K of
                 kbEsc : Break;
                  kbUp : P := 4;
          kbDown,kbTab : P := 1;
               kbEnter : P := 4;
        End;
       End;
   1 : Begin
        StrPCopy(PBuffer,Str(X2));
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(13,3,W.MaxXTxts-1,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(13,3,W.MaxXTxts-1);
        Val(StrPas(PChr),X2,Err);
        Case K of
                 kbEsc : Break;
                  kbUp : P := 0;
          kbDown,kbTab : P := 2;
               kbEnter : P := 4;
        End;
       End;
   2 : Begin
        StrPCopy(PBuffer,Str(Y1));
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(13,5,W.MaxXTxts-1,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(13,5,W.MaxXTxts-1);
        Val(StrPas(PChr),Y1,Err);
        Case K of
                 kbEsc : Break;
                  kbUp : P := 1;
          kbDown,kbTab : P := 3;
               kbEnter : P := 4;
        End;
       End;
   3 : Begin
        StrPCopy(PBuffer,Str(Y2));
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(13,7,W.MaxXTxts-1,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(13,7,W.MaxXTxts-1);
        Val(StrPas(PChr),Y2,Err);
        Case K of
                 kbEsc : Break;
                  kbUp : P := 2;
          kbDown,kbTab : P := 4;
               kbEnter : P := 4;
        End;
       End;
   4 : Begin
        K := W.GetkHorDn('Correct|Annule');
        Case K of
           kbEsc,1 : Break;
             kbTab : P := 0;
                 0 : Begin
                      SetFormatPage := True;
                      Break;
                     End;
        End;
       End;
  End;
 Until False;
 W.Done;
End;

Function WinPrnAscii;
Var W:Wins; P:Byte; K,Err:Word; KChr:Char Absolute K;
    PBuffer:Array[0..63] of Char; PChr:PChar;
Begin
 WinPrnAscii := False;
 W.InitO(70,8);
 W.PushWn;
 W.PutWn('Impression Ascii',CurrColors.Dialog.Wins);
 W.PutTxtXY(0,1,'De la ligne');
 W.PutTxtXY(35,1,'Jusqu''Ö');
 W.PutTxtXY(0,3,'Marge de gauche');
 W.PutTxtXY(35,3,'CompressÇ ['+Char(32+56*Byte(Compress))+']');
 W.SetKr($8F);
 W.BarSpcHorShade(12,1,32);
 W.PutTxtXY(12,1,Str(Start));
 W.BarSpcHorShade(43,1,W.MaxXTxts-1);
 W.PutTxtXY(43,1,Str(_End));
 W.BarSpcHorShade(16,3,32);
 W.PutTxtXY(16,3,Str(Merge));
 P := 0;
 W.PutkHorDn('Correct|Annule');
 PChr := PBuffer;
 Repeat
  Case P of
   0 : Begin
        StrPCopy(PBuffer,Str(Start));
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(12,1,32,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(12,1,32);
        Val(StrPas(PChr),Start,Err);
        Case K of
                 kbEsc : Break;
                  kbUp : P := 4;
                kbDown : P := 2;
                 kbTab : P := 1;
               kbEnter : P := 4;
        End;
       End;
   1 : Begin
        StrPCopy(PBuffer,Str(_End));
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(43,1,W.MaxXTxts-1,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(43,1,W.MaxXTxts-1);
        Val(StrPas(PChr),_End,Err);
        Case K of
                 kbEsc : Break;
                  kbUp : P := 4;
                kbDown : P := 3;
                 kbTab : P := 2;
               kbEnter : P := 4;
        End;
       End;
   2 : Begin
        StrPCopy(PBuffer,Str(Merge));
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(16,3,32,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(16,3,32);
        Val(StrPas(PChr),Merge,Err);
        Case K of
                 kbEsc : Break;
                  kbUp : P := 0;
                kbDown : P := 4;
                 kbTab : P := 3;
               kbEnter : P := 4;
        End;
       End;
   3 : Begin
        SimpleCursor;
        SetCursorPos(W.GetRX1+46,W.GetRY1+3);
        K := ReadKey;
        CloseCursor;
        Case K of
                 kbEsc : Break;
                kbLeft : P := 2;
                  kbUp : P := 1;
  kbDown,kbRight,kbTab : P := 4;
               kbEnter : P := 4;
                    Else If(KChr = ' ')Then
                         Begin
                          Compress := Not(Compress);
                          Case Compress of
                           True : W.SetChr(46,3,'X');
                             Else W.SetChr(46,3,' ');
                          End;
                         End;
        End;
       End;
   4 : Begin
        K := W.GetkHorDn('Correct|Annule');
        Case K of
           kbEsc,1 : Break;
             kbTab : P := 0;
                 0 : Begin
                      WinPrnAscii := True;
                      Break;
                     End;
        End;
       End;
  End;
 Until False;
 W.Done;
End;

BEGIN
END.