{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³       Malte Genesis III/Module des Outils d'Imprimante     ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit ToolPrn;

INTERFACE

{$IFDEF Overlay}
 {$O+,F+}
{$ENDIF}

Uses Video,Dials,Printers,Terminal;

Type

     SelectPrn = Object
      List:LstMnu;
      Constructor Init(Default,X1,Y1,X2,Y2:Byte);
      Procedure PutSmallShade;
      Function Run:Word;
      Function GetPrn:Word;
      Destructor Done;
     End;

     SetupPrn = Object
      Constructor Init(X,Y:Byte);
      Function Run:Word;
      Destructor Done;
      PRIVATE
      Default:PrnSetupType;
      W:Ansi;
      SelPrn:SelectPrn;
      SelPrnOut:SelectPrnOutput;
      PrnMethode:SwitchOption;
      ListPrinting:LstMnu;
      P:Byte;
     End;

IMPLEMENTATION

Uses Math,Strings,Strs,Language,Keyboard,Memorys,Cursor;

Constructor SelectPrn.Init(Default,X1,Y1,X2,Y2:Byte);
Begin
 With List do
 Begin
  _QInit(X1,Y1,X2,Y2,'ModŠle Imprimante',CurrColors.Dialog.Wins);
  AddStrByte('Pas d''imprimante',prnNoPrinter);
  AddStrByte('Brother M-1209',prnBrotherM1209);
  AddStrByte('Brother M-1224',prnBrotherM1224);
  AddStrByte('Brother M-2518',prnBrotherM2518);
  AddStrByte('Brother M-2524L',prnBrotherM2524L);
  AddStrByte('Brother M-3524L',prnBrotherM3524L);
  AddStrByte('Brother M-4018',prnBrotherM4018);
  AddStrByte('C. Itoh C-310',prnCItohC310);
  AddStrByte('C. Itoh C-315',prnCItohC315);
  AddStrByte('C. Itoh C-510',prnCItohC510);
  AddStrByte('C. Itoh C-510+',prnCItohC510Plus);
  AddStrByte('C. Itoh C-545',prnCItohC545);
  AddStrByte('C. Itoh C-715A',prnCItohC715A);
  AddStrByte('C. Itoh C-815',prnCItohC815);
  AddStrByte('C. Itoh CI-2500',prnCItohCI2500);
  AddStrByte('C. Itoh M-1209',prnCItohM1209);
  AddStrByte('C. Itoh M-1224',prnCItohM1224);
  AddStrByte('C. Itoh M-2518',prnCItohM2518);
  AddStrByte('C. Itoh M-2524L',prnCItohM2524L);
  AddStrByte('C. Itoh M-4018',prnCItohM4018);
  AddStrByte('C. Itoh Super Rillman',prnCItohSuperRillman);
  AddStrByte('Citizen 120-D',prnCitizen120D);
  AddStrByte('Citizen 120-D+',prnCitizen120DPlus);
  AddStrByte('Citizen MSP 40',prnCitizenMSP40);
  AddStrByte('Citizen MSP 45',prnCitizenMSP45);
  AddStrByte('Citizen MSP 50',prnCitizenMSP50);
  AddStrByte('Citizen MSP 55',prnCitizenMSP55);
  AddStrByte('Citizen 124D',prnCitizen124D);
  AddStrByte('Citizen HQP-45',prnCitizenHQP45);
  AddStrByte('Citizen Prodot 24',prnCitizenProdot24);
  AddStrByte('Citizen Prodot 9/9X',prnCitizenProdot9_9X);
  AddStrByte('Citizen Swift 9',prnCititzenSwift9);
  AddStrByte('Epson DFX-5000',prnEpsonDFX5000);
  AddStrByte('Epson DFX-8000',prnEpsonDFX8000);
  AddStrByte('Epson DLQ-2000',prnEpsonDLQ2000);
  AddStrByte('Epson FX-85',prnEpsonFX85);
  AddStrByte('Epson FX-800',prnEpsonFX800);
  AddStrByte('Epson FX-850',prnEpsonFX850);
  AddStrByte('Epson FX-1000',prnEpsonFX1000);
  AddStrByte('Epson FX-1050',prnEpsonFX1050);
  AddStrByte('Epson LQ-400',prnEpsonLQ400);
  AddStrByte('Epson LQ-550',prnEpsonLQ550);
  AddStrByte('Epson LQ-850',prnEpsonLQ850);
  AddStrByte('Epson LQ-850+',prnEpsonLQ850Plus);
  AddStrByte('Epson LQ-860',prnEpsonLQ860);
  AddStrByte('Epson LQ-1050',prnEpsonLQ1050);
  AddStrByte('Epson LQ-1060',prnEpsonLQ1060);
  AddStrByte('Epson LQ-2550',prnEpsonLQ2550);
  AddStrByte('Epson LX-400',prnEpsonLX400);
  AddStrByte('Epson LX-850',prnEpsonLX850);
  AddStrByte('Fujitsu DL-1100',prnFujitsuDL1100);
  AddStrByte('Fujitsu DL-3300',prnFujitsuDX3300);
  AddStrByte('Fujitsu DL-3400',prnFujitsuDL3400);
  AddStrByte('Fujitsu DL-4400',prnFujitsuDL4400);
  AddStrByte('Fujitsu DL-4600',prnFujitsuDL4600);
  AddStrByte('Fujitsu DL-5600',prnFujitsuDL5600);
  AddPChrByte('Fujitsu DX-2150',prnFujitsuDX2150);
  AddStrByte('Fujitsu DX-2250',prnFujitsuDX2250);
  AddStrByte('IBM 4201-003',prnIBM4201003);
  AddStrByte('IBM 4202-003',prnIBM4202003);
  AddStrByte('IBM 4207-002',prnIBM4202007);
  AddStrByte('IBM 4208-002',prnIBM4208002);
  AddStrByte('IBM 5204-001',prnIBM5204001);
  AddStrByte('Mannesmann Tally MT-81',prnMannMT81);
  AddStrByte('Mannesmann Tally MT-90',prnMannMT90);
  AddStrByte('Mannesmann Tally MT-91',prnMannMT91);
  AddStrByte('Mannesmann Tally MT-130/9',prnMannMT130_9);
  AddStrByte('Mannesmann Tally MT-130/24',prnMannMT130_24);
  AddStrByte('Mannesmann Tally MT-131/9',prnMannMT131_9);
  AddStrByte('Mannesmann Tally MT-131/24',prnMannMT131_24);
  AddStrByte('Mannesmann Tally MT-230/9',prnMannMT230_9);
  AddStrByte('Mannesmann Tally MT-230/18',prnMannMT230_18);
  AddStrByte('Mannesmann Tally MT-230/24',prnMannMT230_24);
  AddStrByte('Mannesmann Tally MT-290',prnMannMT290);
  AddStrByte('Mannesmann Tally MT-330',prnMannMT330);
  AddStrByte('Mannesmann Tally MT-340',prnMannMT340);
  AddStrByte('Mannesmann Tally MT-460',prnMannMT460);
  AddStrByte('Mannesmann Tally MT-490',prnMannMT490);
  AddStrByte('NEC P2+',prnNECP2Plus);
  AddStrByte('NEC P6',prnNECP6);
  AddStrByte('NEC P6+',prnNECP6Plus);
  AddStrByte('NEC P7',prnNECP7);
  AddStrByte('NEC P7+',prnNECP7Plus);
  AddStrByte('NEC P-20',prnNECP20);
  AddStrByte('NEC P-30',prnNECP30);
  AddStrByte('NEC P-60',prnNECP60);
  AddStrByte('NEC P-70',prnNECP70);
  AddStrByte('NEC P-90',prnNECP90);
  AddStrByte('NEC P-2200',prnNECP2200);
  AddStrByte('Oki Systems ML-182',prnOkiSystemsML182);
  AddStrByte('Oki Systems ML-183',prnOkiSystemsML183);
  AddStrByte('Oki Systems ML-192 Elite',prnOkiSystemsML192Elite);
  AddStrByte('Oki Systems ML-193 Elite',prnOkiSystemsML193Elite);
  AddStrByte('Oki Systems ML-292',prnOkiSystemsML292);
  AddStrByte('Oki Systems ML-293 Elite',prnOkiSystemsML293Elite);
  AddStrByte('Oki Systems ML-294',prnOkiSystemsML294);
  AddStrByte('Oki Systems ML-320',prnOkiSystemsML320);
  AddStrByte('Oki Systems ML-321 Elite',prnOkiSystemML320Elite);
  AddStrByte('Oki Systems ML-380',prnOkiSystemsML380);
  AddStrByte('Oki Systems ML-390',prnOkiSystemsML390);
  AddStrByte('Oki Systems ML-391',prnOkiSystemsML391);
  AddStrByte('Oki Systems ML-393',prnOkiSystemsML393);
  AddStrByte('Oki Systems Okimate 20',prnOkiSystemsOkimate20);
  AddStrByte('Panasonic KX-P1081',prnPanasonicKX1081);
  AddStrByte('Panasonic KX-P1180',prnPanasonicKX1180);
  AddStrByte('Panasonic KX-P1123',prnPanasonicKX1123);
  AddStrByte('Panasonic KX-P1124',prnPanasonicKX1124);
  AddStrByte('Panasonic KX-P1624',prnPanasonicKX1624);
  AddStrByte('Panasonic KX-P1695',prnPanasonicKX1695);
  AddStrByte('Seikosha BP-5420FA',prnSeikoshaBP5420FA);
  AddStrByte('Seikosha BP-5500',prnSeikoshaBP5500);
  AddStrByte('Seikosha MP-1300 AI',prnSeikoshaMP1300AI);
  AddStrByte('Seikosha MP-5300 AI',prnSeikoshaMP5300AI);
  AddStrByte('Seikosha SBP-10 AI',prnSeikoshaSBP10AI);
  AddStrByte('Seikosha SL-80IP',prnSeikoshaSL80IP);
  AddStrByte('Seikosha SL-92',prnSeikoshaSL92);
  AddStrByte('Seikosha SL-130 AI',prnSeikoshaSL130AI);
  AddStrByte('Seikosha SL-230 AI',prnSeikoshaSL230AI);
  AddStrByte('Seikosha SL-532',prnSeikoshaSL532);
  AddStrByte('Seikosha SP-1600 AI',prnSeikoshaSP1600AI);
  AddStrByte('Seikosha SP-1800 AI',prnSeikoshaSP1800AI);
  AddStrByte('Seikosha SP-2000',prnSeikoshaSP2000);
  AddStrByte('Star LC-10',prnStarLC10);
  AddStrByte('Star LC-10LL',prnStarLC10LL);
  AddStrByte('Star LC-10 colour',prnStarLC10colour);
  AddStrByte('Star LC-15',prnStarLC15);
  AddStrByte('Star LC-20',prnStarLC20);
  AddStrByte('Star LC24-10',prnStarLC24_10);
  AddStrByte('Star LC24-15',prnStarLC24_15);
  AddStrByte('Star LC24-200',prnStarLC24_200);
  AddStrByte('Star LC-200',prnStarLC200);
  AddStrByte('Star NB-15',prnStarNB15);
  AddStrByte('Star NB24-10',prnStarNB24_10);
  AddStrByte('Star NB24-15',prnStarNB24_15);
  AddStrByte('Star ND-10',prnStarND10);
  AddStrByte('Star ND-15',prnStarND15);
  AddStrByte('Star NL-10',prnStarNL10);
  AddStrByte('Star NR-10',prnStarNR10);
  AddStrByte('Star NR-15',prnStarNR15);
  AddStrByte('Star XB24-10',prnStarXB24_10);
  AddStrByte('Star XB24-15',prnStarXB24_15);
  P := Default;
  Refresh;
  SelBarInactive;
 End;
End;

Procedure SelectPrn.PutSmallShade;
Begin
 List.PutSmallShade;
End;

Function SelectPrn.Run:Word;
Begin
 Run := List.RunKbd;
 List.SelBarInactive;
End;

Function SelectPrn.GetPrn:Word;
Begin
 GetPrn := List.GetVal;
End;

Destructor SelectPrn.Done;
Begin
 List.Done;
End;

Constructor SetupPrn.Init(X,Y:Byte);
Begin
 W.InitO(70,20);
 W.PushWn;
 W.PutWn('Gestionnaire Imprimante',CurrColors.Dialog.Wins);
 SetShade(False);
 SelPrnOut.Init(PrnOutput,W.RX1+1,W.RY1+2,W.RX1+1+32,W.RY1+1+6);
 SelPrnOut.PutSmallShade;
 SelPrn.Init(PrnSetup[PrnOutput].Code,W.RX1+1,W.RY1+1+8,W.RX1+1+32,W.RY1+1+12);
 SelPrn.PutSmallShade;
 W.PutTxtXY(35,1,'Dimension du papier');
 W.PutTxtXY(51,2,'x');
 W.PutTxtXY(35,4,'M‚moire de l''Imprimante');
 W.PutTxtXY(35,6,'Mode "Machine … ‚crire"        ['+Char(32+56*Byte(PrnSetup[PrnOutput].ModeWM))+']');
 W.PutTxtXY(35,7,'Alimentation feuille … feuille ['+Char(32+56*Byte(PrnSetup[PrnOutput].P2P))+']');
 W.PutTxtXY(35,8,'Impression en marge autoris‚   ['+Char(32+56*Byte(PrnSetup[PrnOutput].PrnMarge))+']');
 W.SetKr($8F);
 W.BarSpcHorShade(35,2,48);
 W.PutTxtXY(35,2,StrCurrPrnPLen+'"');
 W.BarSpcHorShade(53,2,W.MaxXTxts-1);
 W.PutTxtXY(53,2,StrCurrPrnPHeight+'"');
 W.BarSpcHorShade(59,4,W.MaxXTxts-1);
 W.PutTxtXY(59,4,Str(PrnSetup[PrnOutput].Memory)+'K');
 SetAllColor(W.XColrs.Border,(W.XColrs.Border and $F0)+$B);
 PrnMethode.Init(W.RX1+1+35,W.RY1+1+10,'Code Impression','Seulement en Pixel|Mixte',0);
 W.SubList(0,14,W.MaxXTxts-1,W.MaxYTxts-1,'Liste Impression',ListPrinting);
 ListPrinting.PutSmallShade;
 ListPrinting.SelBarInactive;
 SetShade(True);
 P := 0; Default := PrnSetup;
End;

Function SetupPrn.Run:Word;
Var K,Err:Word; KChr:Char Absolute K; PBuffer:Array[0..63] of Char;
    PChr:PChar; R:Real; Str:String[63];
Begin
 PChr := PBuffer;
 SetShade(False);
 Repeat
  Case P of
   0 : Begin
        K := SelPrnOut.Run; PrnOutput := SelPrnOut.GetPrnOut;
        Case K of
           $F000 : Begin
                    SelPrn.List.P := PrnSetup[PrnOutput].Code;
                    SelPrn.List.Refresh;
                    SelPrn.List.SelBarInactive;
                   End;
          kbLeft : P := 2;
           kbTab : P := 1;
         kbRight : P := 9;
prnLPT1..prnFile : Begin
                    PrnOutput := K; K := kbEnter;
                    Break;
                   End;
              Else Break;
        End;
       End;
   1 : Begin
        K := SelPrn.Run; PrnSetup[PrnOutput].Code := SelPrn.GetPrn;
        Case K of
            kbLeft : P := 0;
             kbTab : P := 2;
           kbRight : P := 2;
 0..prnStarXB24_15 : Begin
                      PrnSetup[PrnOutput].Code := K; K := kbEnter;
                      Break;
                     End;
                Else Break;
        End;
       End;
   2 : Begin
        StrPCopy(PBuffer,StrCurrPrnPLen+'"');
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(35,2,48,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(35,2,48);
        Str := StrPas(PChr);
        If Not(Str[Length(Str)] in ['0'..'9'])Then BackStr(Str);
        Val(Str,R,Err);
        PrnSetup[PrnOutput].PLen := Trunc(R * 10);
        Case K of
             kbTab : P := 3;
              kbUp : P := 1;
            kbDown : P := 4;
                Else Break;
        End;
       End;
   3 : Begin
        StrPCopy(PBuffer,StrCurrPrnPHeight+'"');
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(53,2,W.MaxXTxts-1,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(53,2,W.MaxXTxts-1);
        Str := StrPas(PChr);
        If Not(Str[Length(Str)] in ['0'..'9'])Then BackStr(Str);
        Val(Str,R,Err);
        PrnSetup[PrnOutput].PHeight := Trunc(R * 10);
        Case K of
             kbTab : P := 4;
              kbUp : P := 3;
            kbDown : P := 4;
                Else Break;
        End;
       End;
   4 : Begin
        StrPCopy(PBuffer,Strs.Str(PrnSetup[PrnOutput].Memory)+'K');
        W.SetInpColrs($8F,W.XColrs.Sel);
        K := W._Input(59,4,W.MaxXTxts-1,12,PChr);
        W.SetKr($8F);
        W.BarSelHor(59,4,W.MaxXTxts-1);
        Str := StrPas(PChr);
        If Not(Str[Length(Str)] in ['0'..'9'])Then BackStr(Str);
        Val(Str,PrnSetup[PrnOutput].Memory,Err);
        Case K of
             kbTab : P := 5;
              kbUp : P := 3;
            kbDown : P := 6;
                Else Break;
        End;
       End;
   5 : Begin
        SimpleCursor;
        W.SetCurPos(67,6);
        K := ReadKey;
        CloseCursor;
        Case K of
           kbLeft,kbUp : P := 4;
  kbDown,kbRight,kbTab : P := 6;
                    Else Begin
                          If(KChr = ' ')Then
                          Begin
                           PrnSetup[PrnOutput].ModeWM := Not(PrnSetup[PrnOutput].ModeWM);
                           Case PrnSetup[PrnOutput].ModeWM of
                            True : W.SetChr(67,6,'X');
                              Else W.SetChr(67,6,' ');
                           End;
                          End
                           Else
                          Break;
                         End;
        End;
       End;
   6 : Begin
        SimpleCursor;
        W.SetCurPos(67,7);
        K := ReadKey;
        CloseCursor;
        Case K of
           kbLeft,kbUp : P := 5;
  kbDown,kbRight,kbTab : P := 7;
                    Else Begin
                          If(KChr = ' ')Then
                          Begin
                           PrnSetup[PrnOutput].P2P := Not(PrnSetup[PrnOutput].P2P);
                           Case PrnSetup[PrnOutput].P2P of
                            True : W.SetChr(67,7,'X');
                              Else W.SetChr(67,7,' ');
                           End;
                          End
                           Else
                          Break;
                         End;
        End;
       End;
   7 : Begin
        SimpleCursor;
        W.SetCurPos(67,8);
        K := ReadKey;
        CloseCursor;
        Case K of
           kbLeft,kbUp : P := 6;
  kbDown,kbRight,kbTab : P := 8;
                    Else Begin
                          If(KChr = ' ')Then
                          Begin
                           PrnSetup[PrnOutput].PrnMarge := Not(PrnSetup[PrnOutput].PrnMarge);
                           Case PrnSetup[PrnOutput].PrnMarge of
                            True : W.SetChr(67,8,'X');
                              Else W.SetChr(67,8,' ');
                           End;
                          End
                           Else
                          Break;
                         End;
        End;
       End;
   8 : Begin
        SetAllColor(W.XColrs.Border,(W.XColrs.Border and $F0)+$B);
        K := PrnMethode.Select;
        Case K of
                kbLeft : P := 7;
         kbRight,kbTab : P := 9;
                    Else Break;
        End;
       End;
   9 : Begin
        SetAllColor(W.XColrs.Border,(W.XColrs.Border and $F0)+$B);
        K := ListPrinting.RunKbd;
        ListPrinting.SelBarInactive;
        Case K of
                kbLeft : P := 8;
         kbRight,kbTab : P := 0;
                    Else Break;
        End;
       End;
  End;
 Until False;
 SetShade(True);
 If(K = kbEsc)Then PrnSetup := Default;
 Run := K;
End;

Destructor SetupPrn.Done;
Begin
 SelPrnOut.Done;
 SelPrn.Done;
 PrnMethode.Done;
 ListPrinting.Done;
 W.Done;
End;

BEGIN
END.