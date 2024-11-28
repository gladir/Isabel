{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                               ³
 ³  Malte Genesis/Module de Dialogue T‚l‚matique ³
 ³         Edition Isabel pour Mode R‚el         ³
 ³               III - Version 1.0               ³
 ³                  1995/02/02                   ³
 ³                                               ³
 ³   Copyright (C) par les Chevaliers de Malte   ³
 ³                                               ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit TMDials;

INTERFACE

Uses Dos,Math,Video,Windows,Dials,TeleMate,Terminal,Mems;

Const

 TerminalColors:MtxColors = (
  Title: (LightGray shl 4) + Black;
  Border: (Black shl 4) + LightGray;
  Icon: (Black shl 4) + White;
  Sel: (Blue shl 4) + White;
  High: (Black shl 4) + LightCyan;
  Key: (White shl 4) + Black;
  kShade: (Black shl 4) + Black;
  kSel: (White shl 4) + LightRed
 );

Type

 DialWn=Object
  P:Long;
  Y:Byte;
  Lst:RBuf;
  Constructor Init;
  Constructor InitWin(X1,Y1,X2,Y2:Byte;FileName:PathStr);
  Function Open(FileName:PathStr):Bool;
  Procedure PutWindow(X1,Y1,X2,Y2:Byte);
  Procedure PutLine(_Y:Byte;_P:Long);
  Function CallNumber(Number:String):Bool;
  Procedure UpKey;
  Procedure DownKey;
  Procedure HangUp;
  Function Run(Var RtnDial:DialRecord):Word;
  Function _Run:Word;
  Destructor Done;
  PRIVATE
  PathDial:PathStr;
  W:Wins;
  Select:^TBoolean;
  SizeSelect:Word;
  Procedure SelectBar;
  Procedure UnSelectBar;
  Procedure UpDateInfo;
 End;

 Term=Object
  CurrCom:Byte;
  AttendedMode,LoggingOn,CurrCarrierStatus:Bool;
  W:Ansi;
  Constructor Init(X1,Y1,X2,Y2,Com:Byte);
  Procedure Refresh;
  Procedure PutTxt(S:String);
  Procedure PutTxtLn(S:String);
  Procedure Ln;
  Procedure ClrScr;
  Procedure PutMode(M:String);
  Procedure PutStatus(S:String);
  Procedure PutFlags;
  Procedure BackService(S:String);
  Function ExecCmd(S:String):Bool;
  Function Input(Var S:String):Word;
  Function Run:Word;
  Destructor Done;
  PRIVATE
  SW:Wins;
  NewCarrierStatus,PrnOn,FileOn:Bool;
  Procedure InitModem;
 End;

Function SelectTermEmul(X1,Y1,X2,Y2:Byte):Byte;

IMPLEMENTATION

Uses Clock,Strings,Strs,Keyboard,Systems,Language,Mouse;

Constructor DialWn.Init;
Begin
 Lst.Init;
 P := 0; Y := 0; SizeSelect := 0; Select := NIL;
End;

Constructor DialWn.InitWin;
Begin
 Init;
 Open(FileName);
 PathDial := FileName;
 PutWindow(X1,Y1,X2,Y2);
End;

Function DialWn.Open;
Var J,M:Long; Handle:Word; Ptr:Pointer;
Begin
 Open := False; PathDial := FileName; Handle := Systems.Open(FileName,ReadOnly);
 If(Systems.IsHandleErr(Handle))Then Exit;
 M := (Systems.FileSize(Handle) div SizeOf(DialRecord))-1;
 For J := 0 to M do
 Begin
  Ptr := Lst._AddBuf(SizeOf(DialRecord));
  If(Ptr = NIL)Then Break;
  Systems.GetRec(Handle,J,SizeOf(DialRecord),Ptr^);
 End;
 Systems.Close(Handle);
 SizeSelect := M + 1;
 Select := MemAlloc(SizeSelect);
 If(Select = NIL)Then Exit;
 FillChar(Select^,SizeSelect,Byte(False));
 Open := True;
End;

Procedure DialWn.PutWindow;
Var J    : Byte;
    Dial : ^DialRecord;
Begin
 W.Init(X1,Y1,X2,Y2);
 W.PushWn;
 W.PutWn('Dial - ('+PathDial+')',CurrColors.Dial.Wins);
 W.PutTxtXY(0,0,'Nom    :');
 W.PutTxtXY(0,1,'Num‚ro :');
 W.PutTxtXY(35,1,'Attente #');
 W.PutTxtXY(0,2,MultChar('Ä',W.MaxXTxts+1));
 W.PutTxtXY(0,3,'Ligne');
 W.PutTxtXY(7,3,'Nom BBS');
 W.PutTxtXY(38,3,'Num‚ro T‚l‚phone');
 W.PutTxtXY(59,3,'Der. Date');
 W.PutTxtXY(69,3,'Terminal');
 W.PutTxtXY(78,3,'Protocol');
 W.PutTxtXY(0,4,MultChar('Ä',6));
 W.PutTxtXY(7,4,MultChar('Ä',SizeOf(Dial^.Name)));
 W.PutTxtXY(38,4,MultChar('Ä',SizeOf(Dial^.Phone)));
 W.PutTxtXY(59,4,MultChar('Ä',SizeOf(Dial^.Last)));
 W.PutTxtXY(69,4,MultChar('Ä',8));
 W.PutTxtXY(78,4,MultChar('Ä',14));
 For J := 0 to W.MaxYTxts-5 do PutLine(J,J);
 SelectBar;
End;

Procedure DialWn.PutLine;
Var Dial : ^DialRecord;
    PChr : Array[0..255] of Char;
Begin
 If(Select^[_P])Then W.SetKrBorderF($E)
		Else W.SetKrBorderF($B);
 W.PutTxtXY(0,5+_Y,Str2(_P+1,6));
 Dial := Lst._GetBuf(_P);
 If(Dial = NIL)Then Exit;
 PChr[SizeOf(Dial^.Name)] := #0;
 Move(Dial^.Name,PChr,SizeOf(Dial^.Name));
 W.PutPTxtXY(7,5+_Y,PChr);
 PChr[SizeOf(Dial^.Phone)] := #0;
 Move(Dial^.Phone,PChr,SizeOf(Dial^.Phone));
 W.PutPTxtXY(38,5+_Y,PChr);
 PChr[SizeOf(Dial^.Last)] := #0;
 Move(Dial^.Last,PChr,SizeOf(Dial^.Last));
 W.PutPTxtXY(59,5+_Y,PChr);
 Case Dial^.Term of
  '1' : W.PutTxtXY(69,5+_Y,'VT102');
  '5' : W.PutTxtXY(69,5+_Y,'VT52');
  'A' : W.PutTxtXY(69,5+_Y,'Ansi');
  'T' : W.PutTxtXY(69,5+_Y,'TTY');
   Else W.PutTxtXY(69,5+_Y,'Unknown');
 End;
 Case Dial^.Protocol of
  'A' : W.PutTxtXY(78,5+_Y,'ASCII');
  'B' : W.PutTxtXY(78,5+_Y,'Batch Ymodem');
  'C' : W.PutTxtXY(78,5+_Y,'CIS Quick B');
  'G' : W.PutTxtXY(78,5+_Y,'Ymodem-G');
  'M' : W.PutTxtXY(78,5+_Y,'Modem7');
  'R' : W.PutTxtXY(78,5+_Y,'XModem Relaxed');
  'S' : W.PutTxtXY(78,5+_Y,'SeaLink');
  'T' : W.PutTxtXY(78,5+_Y,'Telink');
  'X' : W.PutTxtXY(78,5+_Y,'Xmodem');
  'Y' : W.PutTxtXY(78,5+_Y,'Ymodem');
  'Z' : W.PutTxtXY(78,5+_Y,'Zmodem');
 End;
End;

Procedure DialWn.SelectBar;
Begin
 If(Select^[P])Then W.SetKrSelF($E) Else W.SetKrSel;
 W.BarSelHor(0,5+Y,wnMax);
End;

Procedure DialWn.UnSelectBar;
Begin
 With W do
 Begin
  If(Select^[P])Then SetKrBorderF($E) Else SetKrBorderF($B);
  BarSelHor(0,5+Y,wnMax);
 End;
End;

Procedure DialWn.UpDateInfo;
Var Dial:^DialRecord;
    PChr:Array[0..255] of Char;
Begin
 Dial := Lst._GetBuf(P);
 If(Dial = NIL)Then Exit;
 If(Select^[P])Then W.SetKrBorderF($E) Else W.SetKrBorderF($B);
 PChr[SizeOf(Dial^.Name)] := #0;
 Move(Dial^.Name,PChr,SizeOf(Dial^.Name));
 W.PutPTxtXY(9,0,PChr);
 PChr[SizeOf(Dial^.Phone)] := #0;
 Move(Dial^.Phone,PChr,SizeOf(Dial^.Phone));
 W.PutPTxtXY(9,1,PChr);
End;

Procedure DialWn.UpKey;
Begin
 With W do With Lst do
 Begin
  If(P > 0)Then
  Begin
   Dec(P);
   UpDateInfo;
   Inc(P);
   If(Y > 0)Then
   Begin
    UnSelectBar;
    Dec(P); Dec(Y);
    SelectBar;
   End
    else
   Begin
    UnSelectBar;
    Dec(P);
    ScrollUp(0,5,wnMax,wnMax);
    PutLine(0,P);
    SelectBar;
   End;
  End;
 End;
End;

Procedure DialWn.DownKey;
Begin
 If(P < Lst.MaxBuf)Then
 Begin
  Inc(P);
  UpDateInfo;
  Dec(P);
  If(Y < W.MaxYTxts-5)Then
  Begin
   UnSelectBar;
   Inc(P); Inc(Y);
   SelectBar;
  End
   Else
  Begin
   UnSelectBar;
   Inc(P);
   W.ScrollDn(0,5,wnMax,wnMax);
   PutLine(Y,P);
   SelectBar;
  End;
 End;
End;

Function DialWn.Run;
Var Ok:Bool; Dial:^DialRecord; K:Word;
Begin
 UpDateInfo;
 Run := kbNoKey; Ok := False;
 Repeat
  K := W.Readk;
  Case K of
       kbUp : If Not(Lst.IsEmpty)Then DialWn.UpKey;
     kbDown : If Not(Lst.IsEmpty)Then DialWn.DownKey;
      kbIns : Begin
	       If Not(Lst.IsEmpty)Then
	       Begin
		Select^[P] := Not(Select^[P]);
		DialWn.DownKey;
	       End;
	      End;
    kbEnter : If Not(Lst.IsEmpty)Then With Lst do
	      Begin
	       Ok   := True;
	       Dial := _GetBuf(P);
	       Move(Dial^.Phone,RtnDial,SizeOf(RtnDial));
	      End;
	 Else Ok := True;
  End;
 Until Ok;
 Run := K;
End;

Function DialWn._Run;
Var Dial : DialRecord;
Begin
 _Run := Run(Dial);
End;

Function DialWn.CallNumber;
Begin
 If(Number = '')Then Exit;
 W.SetKr($9B);
 W.PutTxtXY(9,1,Number);
 ClearXoffReceived;
 SendModemCmd(StrPas(ModemDial)+StrPas(PrefixStr)+Number+
	      StrPas(PostfixStr)+StrPas(ModemDialEnd));
End;

Procedure DialWn.HangUp;
Var OpenFlag,SaveXonXoff,SaveXonOV:Bool;
Begin
 SaveXonXoff := AsyncDoXonXoff; AsyncDoXonXoff := False;
 SaveXonOV := AsyncOVXonXoff; AsyncOVXonXoff := False;
 If(AsyncXoffReceived)Then ClearXoffReceived;
 AsyncClose(True);
 Delay(1000);
 OpenFlag := AsyncOpen(CommPort,BaudRate,Parity,DataBits,StopBits);
 If(AsyncCarrierDetect)Then
 Begin
  _Delay(ModemEscapeTime);
  SendModemCmd(StrPas(ModemEscape));
  _Delay(ModemEscapeTime);
  SendModemCmd(StrPas(ModemHangUp));
  _Delay(ModemEscapeTime);
 End;
 AsyncPurgeBuf;
 AsyncDoXonXoff := SaveXonXoff; AsyncOVXonXoff := SaveXonOV;
End;

Destructor DialWn.Done;
Begin
 FreeMem(Select,SizeSelect);
 W.Done;
 Lst.Done;
End;

Constructor Term.Init;
Begin
 CurrCom := Com; AttendedMode := True; PrnOn := False; FileOn := False;
 W.Init(0,Y1,Video.MaxXTxts,Y2);
 W.SetPause(False);
 SW.Init(W.RX1,W.RY1,W.RX1,W.RY2);
 W.PushWn;
 Refresh;
 W.PutTxt('Installation des circuits de communication...');
 AsyncInit(0,0,0,0,0);
 AsyncOpen(Com,BaudRate,Parity,DataBits,StopBits);
 W.Ln;
 InitModem;
End;

Procedure Term.PutTxt;
Var PChr:Array[0..255] of Char;
Begin
 StrPCopy(PChr,S);
 W.Put(PChr);
End;

Procedure Term.PutTxtLn;
Var PChr:Array[0..255] of Char;
Begin
 AddStr(S,#13+#10);
 StrPCopy(PChr,S);
 W.Put(PChr);
End;

Procedure Term.Ln;
Begin
 W._Ln;
End;

Procedure Term.ClrScr;
Begin
 W.ClrScr;
End;

Function Term.Input;
Var PChr:Array[0..255] of Char; PChrP:PChar;
Begin
 StrPCopy(PChr,S);
 PChrP := PChr;
 ComInInput := True;
 Input := W.Inp(PChrP,255);
 ComInInput := False;
 S := StrPas(PChr);
End;

Procedure Term.InitModem;
Var DoneFlag,DoInit:Bool;

 Function ModemConnected:Bool;
 Var StartTime:Long; TimedOut:Bool;
 Begin
  ASM
   MOV DX,AsyncBase;
   ADD DX,UartMCR;
   MOV AL,$0B;
   OUT DX,AL;
  END;
  AsyncClearErrors;
  StartTime := TimeOfDay; TimedOut := False;
  If(AsyncDoDSR)Then
  Begin
   While (Not(TimedOut))and((Port[UartMSR + AsyncBase] and $20) = 0) do
    TimedOut := (TimeDiff(StartTime,TimeOfDay) > 2);
   If(TimedOut)Then If(AttendedMode)Then
   Begin
    AsyncDoDSR := (WarningMsgYesNo('Donn‚e ajust‚ correctement sans travail, ferme le tout ?') = kbYes);
    TimedOut := AsyncDoDSR;
   End
    Else
   PutTxtLn('*** Donn‚ ajust‚ correctement fermer.');
  End;
  StartTime := TimeOfDay;
  If(AsyncDoCTS)Then
  Begin
   While(Not(TimedOut))and((Port[UartMSR+AsyncBase] and $10) = 0) do
    TimedOut := (TimeDiff(StartTime,TimeOfDay) > 2);
   If(TimedOut)Then If(AttendedMode)Then
   Begin
    AsyncDoCTS := (WarningMsgYesNo('Dois-je effacer l''envoie ?') = kbYes);
    TimedOut := AsyncDoCTS;
   End
    Else
   PutTxtLn('Envoie effacer.');
  End;
  StartTime := TimeOfDay;
  While (Not(TimedOut))and((Port[UartLSR+AsyncBase] and $20) = 0) do
   TimedOut := (TimeDiff(StartTime,TimeOfDay) > 2);
  ModemConnected := Not(TimedOut);
 End;

Const HardWired = False;

Begin
 CurrCarrierStatus := AsyncCarrierDetect; NewCarrierStatus := CurrCarrierStatus;
 If(Not(ModemConnected))Then
 Begin
  If(Not(HardWired))Then
  Begin
   PutTxtLn('*** Modem apparament fermer.');
   PutTxtLn('*** S.V.P ouvrir le modem et presse une touche pour continuer.');
  End
   Else
  Begin
   PutTxtLn('*** Mauvais connection "Hard-wired".');
   PutTxtLn('*** Vous devriez v‚rifier CTS & DSR.');
   PutTxtLn('*** Presse une touche pour continuer...');
  End;
  If(AttendedMode)Then ReadKey
   Else
  PutTxtLn('*** Continuer de toute fa‡on parcequ''il n''est pas en mode attende.');
 End;
 If(Not(IsPChrEmpty(ModemInit)))and(Not(HardWired))Then
 Begin
  If(AsyncCarrierDetect)Then
  Begin
   PutTxt('*** Session apparament d‚j… en progression.');
   If(AttendedMode)Then
    DoInit := (WarningMsgYesNo('Initialise le modem quand mˆme ?') = kbYes)
    Else
   Begin
    PutTxtLn('*** Initialisation du modem non effectu‚.');
    DoInit := False;
   End;
  End
   Else
  DoInit := True;
  If(DoInit)Then
  Begin
   W._Ln;
   SendModemCmd(StrPas(ModemInit));
  End;
 End;
End;

Procedure Term.BackService;
Begin
End;

Procedure Term.PutMode;
Begin
 W.SetEndBarTxtX(22,StrUSpc(M,10),$7C);
End;

Procedure Term.PutFlags;
Var D:String[8];
Begin
 D[0] := #8;
 FillChar(D[1],8,Byte(' '));
 If(FileOn)Then D[1] := 'F';
 If(PrnOn)Then D[2] := 'P';
 If(LoggingOn)Then D[3] := 'L';
 If(AsyncHardWiredOn)Then D[4] := 'W';
 If(AsyncDoDSR)Then D[5] := 'D';
 If(AsyncDoXonXoff)Then D[6] := 'X';
 If(AsyncDoCTS)Then D[7] := 'T';
 If(CurrCarrierStatus)Then D[8] := 'H';
 W.SetEndBarTxtX(72,D,$74);
End;

Procedure Term.PutStatus;
Begin
 W.SetEndBarTxtX(34,Copy(StrUSpc(S,35),1,35),$74);
 PutFlags;
End;

Procedure Term.Refresh;
Var S : String;
Begin
 W.PutWn('Terminal',TerminalColors);
 W.CloseIcon;
 SW.PopWn;
 W.SetEndBar($70);
 S := 'COM' + Str(CurrCom) + ':' + Str(BaudRate) + ','+Parity+
      ','+Str(DataBits)+','+Str(StopBits);
 W.SetEndBarTxtX(19-Length(S),S,$7C);
 W.SetEndBarTxtX(20,'³',$70);
 W.SetEndBarTxtX(32,'³',$70);
 W.SetEndBarTxtX(70,'³',$70);
End;

Function Term.ExecCmd;
Begin
 PutTxtLn(S);
 SendModemCmd(S);
End;

Function Term.Run;
Var K:Word; Chr:Char;
Begin
 PutFlags;
 Repeat
  W.PushCur;
  __ShowMousePtr;
  _InitKbd;
  Repeat
   _BackKbd;
   K := W.BackReadk;
   If(K > 0)Then
   Case K of
    kbInWn :;
	Else Begin
	      W.PopCur;
	      __HideMousePtr;
	      Run := K;
	      Exit;
	     End;
   End;
   W.AniCur;
   If(AsyncReceive(Chr))Then
   Begin
    W.PopCur;
    PutTxt(Chr);
    W.PushCur;
   End;
   PutFlags;
  Until Keypressed;
  __HideMousePtr;
  W.PopCur;
  K := W.Readk;
  Case K of
   kbHome: W.SetPos(0,W.RY);
     kbUp: W._Up;
   kbDown: W._Dn;
   kbLeft: W._Left;
  kbRight: W._Right;
  kbEnter: Begin
	    SendModemCmd(W.GetStr(0,W.RY1)+'|');
	    W._Ln;
	   End;
      Else Begin
	    If(Char(K) > #31)Then PutTxt(Char(K)) Else Break;
	   End;
  End;
 Until False;
 SW.PushWn;
 Run := K;
End;

Destructor Term.Done;
Begin
 AsyncClose(True);
 W.Done;
End;

Function SelectTermEmul(X1,Y1,X2,Y2:Byte):Byte;
Var List:LstMnu;
Begin
 With List do
 Begin
  Init(X1,Y1,X2,Y2,'Select Terminal Emulation',CurrColors.Dialog.Wins);
  AddPChrByte('ADM3a',teADM3a);
  AddPChrByte('ADM5',teADM5);
  AddPChrByte('Ansi',teANSI);
  AddPChrByte('Dumb',teDumb);
  AddPChrByte('Gossip Mode',teGossipMode);
  AddPChrByte('Host Mode',teHostMode);
  AddPChrByte('Tektronix 401',teTektronix401);
  AddPChrByte('TV925',teTV925);
  AddPChrByte('VT52',teVT52);
  AddPChrByte('VT100',teVT100);
  SelectTermEmul := Run;
  Done;
 End;
End;

BEGIN
END.