(********************************************************)
(*                                                      *)
(*                Malte Genesis/Protocol                *)
(*   Phoenix Edition for Real Mode & Protected Mode     *)
(*                   II - Version 1.8                   *)
(*                      1994/12/29                      *)
(*                                                      *)
(*      Copyiright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit Protocol;

INTERFACE

Uses Dos,Math,Video,Windows;

Const

      KermitNone   = 0;
      KermitAscii  = 1;
      KermitBinary = 2;

      MaxTransferTypes = 16;

      TransTimeVal = 1800.0;

      SingleFileProtocol : Array[1..16] of Bool = (
       True,  True,  True,  False, False, False, False, True,
       True,  False, False, True,  True,  True,  True,  True);

      TransNameList : Array[0..16] of PChar = (
       'Aucun',
       'Ascii',
       'XModem Checksum',
       'XModem CRC',
       'Kermit',
       'Telink',
       'Modem 7 Checksum',
       'Modem 7 CRC',
       'XModem 1K',
       'XModem 1K G',
       'YModem Batch',
       'YModem G',
       'ZModem',
       'Extern 1',
       'Extern 2',
       'Extern 3',
       'Extern 4'
      );

     TransTypeName : Array[0..16] of String[2] = (
      'EX','AS','XK','XC','KE','TE','MK','M7','X1',
      'XG','YB','YG','ZM','U1','U2','U3','U4');

     trsNone        = 0;
     trsAscii       = 1;
     trsXmodemChk   = 2;
     trsXmodemCRC   = 3;
     trsKermit      = 4;
     trsTelink      = 5;
     trsModem7Chk   = 6;
     trsModem7CRC   = 7;
     trsXmodem1K    = 8;
     trsXmodem1KG   = 9;
     trsYmodemBatch = 10;
     trsYmodemG     = 11;
     trsZModem      = 12;
     trsExtern1     = 13;
     trsExtern2     = 14;
     trsExtern3     = 15;
     trsExtern4     = 16;

     DefaultTransferType:Byte = trsXmodemChk;

     protNone = 0; protReceiveError = 1; protCarrierDrop = 2; protAltRStop = 3; protOk = 255;

Type

     Prots = Object
      ExitMsg,KermitFileTypeVar:Byte;
      ReceiveScriptNames,SendScriptNames:Array[1..16] of PChar;
      DownloadDirPath,UploadDirPath:PathStr;
       { Ascii }
      AutoStripHighBit,AsciiTranslate:Bool;
      AddLF,AsciiUseCtrlZ,AsciiSendAsis,AsciiSendBlank:Bool;
      AsciiCharDelay,AsciiLineDelay,AsciiLineSize:Int;
      AsciiPacingChar:Char;
      AsciiCRLFStr:String[2];
       { XModem }
      AltSPressed,AltRPressed,SendingFiles:Bool;
      CrcUsed,DisplayTime,DoAcks,DoWXModem,DoSeaLink:Bool;
      MenuTitle,XFileName:String;
      Blocks2Send,Time2Send,SavedTime2Send,StartTime:Long;
      EndTime,TimePerBlock:Long;
      TransferProtocol:Byte;
      XmodemCharWait,XmodemBlockWait,XmodemAckWait,XmodemMaxErrors:Int;
      SectorNumber,SectorSize,MenuLength:Int;
      DownSizeYmodem,HonorXoffYmodem,UseYmodemHeader:Bool;
      Constructor Init(X,Y:Byte);
      Procedure UpDownLoad(TransferProt:Byte;TransferDirec:Char);
      Destructor Done;
      PRIVATE
      TX,TY:Byte;
      W:Wins;
      LineCount,ByteCount:Long;
      DefaultTransferType:Byte;
      CloseComm4Dos:Bool;
      TName:PathStr;
      SectorData:Array[0..2047] of Char;
      TrTab:Array[Char] of Char;
       { XModem }
      StopReceive,StopSend:Bool;
      XmodemParitySave:Char;
      SendErrors,SectorCount,XmodemStopSave,XmodemBitsSave:Int;
      XFile:File;
       { Ascii }
      Procedure InitAsciiReceiveScr(AsciiTitle:String);
      Procedure UpdateAsciiReceiveScr;
      Function ReceiveAsciiFile:Bool;
      Procedure InitAsciiSendScr(AsciiTitle:String);
      Procedure UpdateAsciiSendScr;
      Procedure SendAsciiFile;
       { XModem }
      Procedure CancelTransfer;
      Procedure InitReceiveScr;
      Procedure InitSendScr;
      Function GetTransferName(X:Byte):String;
      Procedure PutBatchWn;
      Procedure ChkKbd;
      Procedure GetXmodemTitles;
      Procedure SaveComm4Xmodem;
      Procedure RestoreComm4Xmodem;
      Procedure ExtractUploadPathName(Var FilePattern,_UploadDirPath:String);
      Procedure EndBatchTransfer;
      Procedure UpdateXmodemSendScr;
      Procedure AsyncSendDLEChar(C:Char);
      Procedure SendXmodemFile(UseCRC:Bool);
     End;

Function ExitMsgStr(Code:Byte):String;

IMPLEMENTATION

Uses Strs,Printers,Clock,Strings,Keyboard,Systems,
     Memorys,MLibrary,TeleMate,Terminal,Dials;

Function ExitMsgStr;
Begin
 Case Code of
	  protNone : ExitMsgStr := '';
  protReceiveError : ExitMsgStr := 'Erreur de r‚ception';
   protCarrierDrop : ExitMsgStr := 'Carrier Drop';
      protAltRStop : ExitMsgStr := 'Arrˆt par Alt+R';
	    protOk : ExitMsgStr := 'R‚ception r‚ussit';
		Else ExitMsgStr := 'Erreur inconnue!';
 End;
End;

Constructor Prots.Init;
Var I:Byte;
Begin
 DefaultTransferType := trsXmodemChk;
 For I := 1 to 16 do
 Begin
  ReceiveScriptNames[I] := ''; SendScriptNames[I] := '';
 End;
 TX := X; TY := Y; AutoStripHighBit := False;
 AsciiTranslate := True; AddLF := False; AsciiUseCtrlZ := False;
 ExitMsg := 0; AsciiCharDelay := 0; AsciiLineDelay := 0;
 AsciiSendAsis := False; AsciiLineSize := 255; DoSeaLink := False;
 AsciiPacingChar := #0; AsciiSendBlank := False; DoWXModem := False;
 AsciiCRLFStr := ^M; StopReceive := False; StopSend := False;
 XmodemCharWait := 1; XmodemBlockWait := 10; SectorNumber := 0;
 XmodemAckWait := 10; XmodemMaxErrors := 20; DownSizeYmodem := False;
 HonorXoffYmodem := True; UseYmodemHeader := False;
End;

Procedure Prots.InitAsciiReceiveScr;
Begin
 W.Init(TX,TY,TX+30,TY+5);
 W.PushWn;
 W.PutWn(AsciiTitle,CurrColors.Dialog.Wins);
 W.PutTxtXY(0,0,'Texte re‡ue');
 W.PutTxtXY(0,1,MultChar('Ä',30));
 W.PutTxtXY(0,2,'Lignes re‡ue :');
 W.PutTxtXY(0,3,'Octets re‡ue :');
End;

Procedure Prots.UpdateAsciiReceiveScr;
Begin
 W.PutTxtXY(17,2,Str(LineCount));
 W.PutTxtXY(17,3,Str(ByteCount));
End;

Function Prots.ReceiveAsciiFile;
Var Fin,RError,OkDispSize,UseCh,AltRHit:Bool;
    FullName,AsciiTitle:String; AFile:Text; Ch:Char; K:Word;
Begin
 ReceiveAsciiFile := False; Fin := False; LineCount := 0; ByteCount := 0;
 UseCh := True; RError := False; AltRHit := False;
 AsciiTitle := 'R‚ception Ascii du fichier ' + TName;
 InitAsciiReceiveScr(AsciiTitle);
 BackService(AsciiTitle);
 If Not(DownloadDirPath[Length(DownloadDirPath)] = '\')Then
  IncStr(DownloadDirPath,'\');
 FullName := DownloadDirPath + TName;
 Assign(Afile,FullName);
 SetTextBuf(AFile,SectorData);
 ReWrite(AFile);
 RError := (IoResult <> 0);
 Repeat
  While KeyPressed do
  Begin
   K := ReadKey;
   Case K of
    kbEsc : If(Keypressed)Then
	    Begin
	     K := ReadKey;
	     Case K of
	     kbAltR : Begin
		       Fin := True; AltRHit := True;
		      End;
		 Else AsyncSend(Char(K));
	     End;
	    End;
   End;
  End;
  If(AsyncReceive(Ch))Then
  Begin
   If(AutoStripHighBit)Then Ch := Char(Byte(Ch) and $7F);
   If(AsciiTranslate)Then
   Begin
    Ch := TrTab[Ch]; UseCh := (Byte(Ch) <> NUL);
   End;
   If(UseCh)Then
   Begin
    Write(AFile,Ch);
    RError := RError or (IoResult <> 0);
    Inc(ByteCount);
    If(Ch = Char(CR))Then
    Begin
     Inc(LineCount);
     UpdateAsciiReceiveScr;
     If(AddLF)Then
     Begin
      Write(AFile,Char(LF));
      RError := RError or (IoResult <> 0); Inc(ByteCount);
     End;
    End
     Else
    If(AsciiUseCtrlZ)Then If(Ch = ^Z)Then Fin := True;
   End;
  End;
  Fin := ((Fin)or(AsyncCarrierDrop)or(RError));
 Until (Fin);
 OkDispSize := False;
 If(AsyncCarrierDrop)Then ExitMsg := protCarrierDrop Else
 If(AltRHit)Then ExitMsg := protAltRStop Else
 If(Not(RError))Then
 Begin
  ExitMsg := protOk; OkDispSize := True;
 End
  Else
 ExitMsg := protReceiveError;
 If(OkDispSize)Then
  BackService('Taille du fichier … recevoir est '+
	       Str(ByteCount)+' octets, '+Str(LineCount)+' lignes');
 BackService(ExitMsgStr(ExitMsg));
 System.Close(AFile);
 W.Done;
 ReceiveAsciiFile := (IoResult <> 0);
End;

Procedure Prots.InitAsciiSendScr;
Begin
 W.Init(TX,TY,TX+30,TY+8);
 W.PushWn;
 W.PutWn(AsciiTitle,CurrColors.Dialog.Wins);
 W.PutTxtXY(0,0,'CaractŠre … envoy‚:');
 W.PutTxtXY(0,1,'Lignes envoy‚:           '+Str2(LineCount,8));
 W.PutTxtXY(0,2,'Octets envoy‚:           '+Str2(ByteCount,8));
 W.PutTxtXY(0,3,'Temps appro. transfŠre:  '+TimeString(Time2Send,MilitaryTime));
 W.PutTxtXY(0,5,'Lignes … envoyer:');
 W.PutTxtXY(0,6,'Octet encore … envoyer:');
 W.PutTxtXY(0,7,'Temps restant transfŠre: '+TimeString(Time2Send,MilitaryTime));
End;

Procedure Prots.UpdateAsciiSendScr;
Begin
 W.PutTxtXY(25,1,Str(LineCount));
 W.PutTxtXY(25,3,Str(ByteCount));
End;

Procedure Prots.SendAsciiFile;
Label 1;
Const PacingDelay = 0.10; ModemFudge = 0.85; MaxWaitTime = 60;
Var Ch,ACh:Char; TextLine,AsciiTitle:String;
    EscFound,B,PaceFound,Pacing,Fin,PaceTime,AsciiDisplay,EOFAFile,
    DoSendBlank,LongBuffer,AltSHit:Bool; LineKount,LengthLine,T1:Long;
    RBaudRate,RCharDelay,RLineDelay:Real; I,X,Y,BufferPos,BufferSize,MaxDLine:Int;
    CRLFString:String[30]; SBSize,SLSize:String[20]; AFile:File; K:Word;

 Function AsciiReceive(Var Ch:Char):Bool;
 Var KeyC: Char;
 Begin
  If(AsyncReceive(Ch))Then
  Begin
   AsciiReceive := True;
   Case Byte(Ch) Of
    NUL: AsciiReceive := False;
    DEL: AsciiReceive := False;
   BELL: Beep;
    Else If(AsciiDisplay)Then Write(Ch);
   End;
  End
   Else
  AsciiReceive := False;
 End;

 Procedure AsciiSend(Ch:Char);
 Begin
  If(AsciiDisplay)Then AsyncSendNow(Ch)
		  Else AsyncSend(Ch);
 End;

 Procedure SendAsciiLine;
 Var B:Bool; I:Int;
 Begin
  For I := 1 to Length(TextLine) do
  Begin
   AsciiSend(TextLine[I]);
   If(AsciiCharDelay > 0)Then Delay(AsciiCharDelay);
   B := AsciiReceive(Ch);
  End;
  If Not(Pacing)Then
  Begin
   If(AsciiLineDelay > 0)Then Delay(AsciiLineDelay);
   While AsciiReceive(Ch) do;
  End;
 End;

 Procedure ReadALine(Var S:String);
 Var I,Ierr:Int; Eol:Bool;
 Begin
  I := 0; Eol := False; S := '';
  While(Not(Eol OR EOFAFile))do
  Begin
   Inc(BufferPos);
   If(BufferPos > BufferSize)Then
   Begin
    BlockRead(AFile,SectorData,SizeOf(SectorData),BufferSize);
    Ierr := IoResult; BufferPos := 1;
    If((BufferSize <= 0)or(Ierr <> 0))Then
    Begin
     Eol := True; EOFAFile := True;
    End;
   End;
   If(Not(EOFAFile))Then If(Not(AsciiSendAsis))Then
   Case Byte(SectorData[BufferPos]) Of
    CR: ;
    LF: Eol := TRUE;
   Else Begin
	 Inc(I); S[I] := SectorData[BufferPos];
	 Eol := Eol OR (I > 252);
	End;
   End
    Else
   Begin
    Inc(I); S[I] := SectorData[BufferPos];
    Eol := Eol or (I > AsciiLineSize);
   End;
  End;
  If(I > 0)Then If(S[I] = ^Z)Then Dec(I);
  S[0] := Char(I);
 End;

Begin
 AsciiTitle := 'Send file ' + TName + ' using ASCII';
 BackService(AsciiTitle);
 InitAsciiSendScr(AsciiTitle);
 ByteCount := GetFileSize(TName);
 RBaudRate := (BaudRate * ModemFudge) / 10.0; LineCount := 0; AltSHit := False;
 LongBuffer := False;
 FileMode := 0;
 Assign(AFile,TName);
 Reset(AFile,1);
 FileMode := 2;
 If(IoResult <> 0)Then
 Begin
  BackService('Cannot open file to send, transfer cancelled.');
  Exit;
 End;
 BufferPos := SizeOf(SectorData); BufferSize := 0; EOFAFile := FALSE;
 Repeat
  ReadALine(TextLine);
  Inc(LineCount);
 Until(EOFAFile);
 System.Close(AFile);
 FileMode := 0;
 Reset(AFile,1);
 FileMode := 2; I := IoResult;
 BufferPos := SizeOf(SectorData); BufferSize := 0; EOFAFile := FALSE;
 System.Str(ByteCount,SBSize); System.Str(LineCount,SLSize);
 BackService('Size of file to send is '+SBSize+' bytes, '+SLSize+' lines');
 RCharDelay := AsciiCharDelay / 1000.0; RLineDelay := AsciiLineDelay / 1000.0;
 Time2Send := Round(ByteCount/RBaudRate+RCharDelay*ByteCount+RLineDelay*LineCount);
 PaceTime := (AsciiCharDelay=0)and(AsciiLineDelay=0)and
	     (AsciiPacingChar<>Char(NUL))and(AsciiPacingChar<>' ');
 If(PaceTime)Then Time2Send := Round(Time2Send+LineCount*(PacingDelay+RLineDelay));
 DoSendBlank := AsciiSendBlank; CRLFString := AsciiCRLFStr;
 If(AsciiSendAsis)Then
 Begin
  DoSendBlank := False; CRLFString := '';
 End;
 Fin := False; StartTime := TimeOfDay; PaceFound := TRUE; Pacing := False;
 LineKount := LineCount; LineCount := 0;
 Repeat
  ReadALine(TextLine);
  If(EOFAFile and(Length(TextLine) = 0))Then Goto 1;
  If(DoSendBlank)Then If(Length(TextLine) = 0)Then TextLine := ' ';
  AddStr(TextLine,CRLFString);
  LengthLine := Length(TextLine + CRLFString); EscFound := False;
  If(Pacing and(Not(Fin)))Then
  Repeat
   If(KeyPressed)Then
   Begin
    K := ReadKey;
    Case K of
     kbEsc : EscFound := True;
	Else Begin
	      B := AsciiReceive(ACh);
	      AsciiSend(Char(K));
	     End;
    End;
   End;
   If(AsciiReceive(Ch))Then
   Begin
    PaceFound := (Ch = AsciiPacingChar);
    If(PaceFound)Then Delay(AsciiLineDelay);
   End;
  Until(PaceFound or EscFound)
   Else
  Repeat
   If(KeyPressed)Then
   Begin
    K := ReadKey;
    Case K of
     kbEsc : EscFound := True;
	Else Begin
	      B := AsciiReceive(ACh);
	      AsciiSend(Char(K));
	     End;
    End;
   End;
   B := AsciiReceive(Ch);
  Until (PaceFound or EscFound);
  If(EscFound and KeyPressed)Then
  Case ReadKey of
   kbAltS : Begin
	     Fin := True; AltSHit := True;
	    End;
  End
   Else
  While KeyPressed do
  Begin
   Ch := Char(ReadKey); B := AsciiReceive(ACh);
   AsciiSend(Ch);
  End;
  If(Not(Fin))Then SendAsciiLine;
  Inc(LineCount); Dec(LineKount); Dec(ByteCount,LengthLine);
  If(ByteCount < 0)Then ByteCount := 0;
  Time2Send := Round(ByteCount / RBaudRate + RCharDelay * ByteCount +
	       RLineDelay * LineKount);
  If(PaceTime)Then Time2Send := Round(Time2Send + LineKount *
				(PacingDelay + RLineDelay));
  If(Time2Send <= 0)Then Time2Send := 0;
  UpdateAsciiSendScr;
  Pacing := (AsciiPacingChar <> Char(NUL))and(AsciiPacingChar <> ' ');
  Fin := Fin or AsyncCarrierDrop;
1:
 Until(Fin or EOFAFile);
 If(AsciiUseCtrlZ)Then
 Begin
  B := AsciiReceive(Ch);
  AsciiSend(^Z);
 End;
 T1 := TimeOfDay;
 While((AsyncOBufHead <> AsyncOBufTail)and
      (TimeDiff(T1,TimeOfDay) <= MaxWaitTime)and(Not KeyPressed))do
  AsciiReceive(Ch);
 Delay(2000);
 InitAsciiSendScr(AsciiTitle);
 If(Not(Fin))Then
 Begin
  BackService('Send completed.');
  W.PutTxtXY(0,0,'Actual transfer time was ' +
  TimeString(TimeDiff(StartTime,TimeOfDay ),MilitaryTime));
 End
  Else
 If(AltSHit)Then BackService('Alt-S hit, send stopped.')
     Else BackService('Send cancelled.');
 System.Close(AFile);
 I := IoResult;
 W.Done;
End;

Procedure Prots.CancelTransfer;
Begin
 If(DoAcks)Then AsyncPurgeBuf;
 AsyncSendCAN;
 AsyncSendCAN;
 AsyncSendCAN;
 AsyncSendCAN;
 AsyncSendCAN;
 AsyncSendBS;
 AsyncSendBS;
 AsyncSendBS;
 AsyncSendBS;
 AsyncSendBS;
 BackService('Transfer cancelled.');
End;

Procedure Prots.InitReceiveScr;
Begin
 W.Init(TX,TY,TX+30,TY+11);
 W.PushWn;
 W.PutWn('',CurrColors.Dialog.Wins);
 W.PutTxtXY(0,0,'Blocks received      :');
 W.PutTxtXY(0,1,'Block length errors  :');
 W.PutTxtXY(0,2,'SOH errors           :');
 W.PutTxtXY(0,3,'Block number errors  :');
 W.PutTxtXY(0,4,'Complement errors    :');
 W.PutTxtXY(0,5,'Timeout errors       :');
 W.PutTxtXY(0,6,'Resend block errors  :');
 If(Not(CRCUsed))Then W.PutTxtXY(0,7,'Checksum errors      :')
		 Else W.PutTxtXY(0,7,'CRC errors           :');
 W.PutTxtXY(0,8,'Approx. time left    :');
 W.PutTxtXY(0,9,'Last status message  :');
End;

Procedure Prots.InitSendScr;
Begin
 W.Init(TX,TY,TX+45,TY+11);
 W.PushWn;
 W.PutWn('',CurrColors.Dialog.Wins);
 W.PutTxtXY(0,0,'Blocks to send        : '+Str(Blocks2Send));
 W.PutTxtXY(35,0,Str(Blocks2Send shr 3)+'K' );
 W.PutTxtXY(0,2,'Approx. transfer time : '+TimeString(Time2Send,MilitaryTime));
 W.PutTxtXY(0,4,'Sending block         : ');
 W.PutTxtXY(0,5,'Errors                : ');
 W.PutTxtXY(0,6,'Time remaining        : '+TimeString(Time2Send,MilitaryTime));
 W.PutTxtXY(0,8,'Last status message   : ');
End;

Procedure Prots.UpdateXmodemSendScr;
Begin
 W.PutTxtXY(25,0,Str(SectorCount));
 W.PutTxtXY(35,25,Str(SectorCount shr 3)+'K');
 W.PutTxtXY(25,1,Str(SendErrors));
End;

Function Prots.GetTransferName(X:Byte):String;
Begin
 Case X of
  trsXmodemChk   : GetTransferName := 'Xmodem (Checksum)';
  trsXmodemCrc   : GetTransferName := 'Xmodem (CRC)';
  trsTelink      : GetTransferName := 'Telink';
  trsModem7Chk   : GetTransferName := 'Modem7 (Checksum)';
  trsModem7CRC   : GetTransferName := 'Modem7 (CRC)';
  trsXmodem1K    : GetTransferName := 'Xmodem 1K';
  trsXmodem1KG   : GetTransferName := 'Xmodem 1K G';
  trsYmodemBatch : GetTransferName := 'Ymodem Batch';
  trsYmodemG     : GetTransferName := 'Ymodem G Batch';
 End;
End;

Procedure Prots.PutBatchWn;
Var _TName,BatchTitle,Direction : String;
BEGIN
 _TName := GetTransferName(TransferProtocol);
 If(SendingFiles)Then Direction := 'send'
		 Else Direction := 'receive';
 BatchTitle := 'Batch file ' + Direction + ' using ' + _TName;
 W.SetTitle(BatchTitle,W.XColrs.Title);
 BackService(BatchTitle);
End;

Procedure Prots.ChkKbd;
Begin
 While KeyPressed do
 Begin
  If(ReadKey = kbESC)Then If(KeyPressed)Then
  Begin
   Case ReadKey OF
    kbAltR : AltRPressed := True;
    kbAltS : AltSPressed := True;
   End;
   StopReceive := StopReceive or AltRPressed;
   StopSend    := StopSend    or AltSPressed;
  End
   Else
  If(AsyncXOffReceived)Then ClearXOFFReceived;
 End;
End;

Procedure Prots.GetXmodemTitles;
Var Direction,_TName : String;
Begin
 _TName := GetTransferName(TransferProtocol);
 If(SendingFiles)Then
 Begin
  Direction  := 'Send ';
  MenuLength := 19;
 End
  Else
 Begin
  Direction   := 'Receive ';
  MenuLength := 22;
 End;
 If(TName = '')Then MenuTitle := Direction + 'file using ' + _TName
	       Else MenuTitle := Direction + 'file ' + XFileName + ' using ' + _TName;
 W.SetTitle(MenuTitle,W.XColrs.Title);
 BackService(MenuTitle);
End;

Procedure Prots.SaveComm4Xmodem;
Begin
 XmodemBitsSave := DataBits; XmodemParitySave := Parity;
 If(DataBits <> 8)or(Parity <> 'N')Then
 Begin
  Parity := 'N'; DataBits := 8;
  AsyncResetPort(CommPort,BaudRate,Parity,DataBits,StopBits);
 End;
End;

Procedure Prots.RestoreComm4Xmodem;
Begin
 If(XmodemBitsSave <>  8)or(XmodemParitySave <> 'N')Then
 Begin
  Parity := XmodemParitySave; DataBits := XmodemBitsSave;
  AsyncResetPort(CommPort,BaudRate,Parity,DataBits,StopBits);
 End;
End;

Procedure Prots.ExtractUploadPathName;
Var I : Int; _Done : Bool;
Begin
 I := Length(FilePattern) + 1; _Done := False;
 While (Not(_Done))do
 Begin
  Dec(I); _Done := (FilePattern[I] in [':','\'])or(I = 1);
 End;
 If(I > 1)Then _UploadDirPath := Copy(FilePattern,1,I)
  Else
 Begin
  GetDir(0,_UploadDirPath);
  If(IoResult <> 0)Then _UploadDirPath := '';
 End;
 If(Pos('\',_UploadDirPath) <> 0)Then
  If(_UploadDirPath[Length(_UploadDirPath)] <> '\')Then
   IncStr(_UploadDirPath,'\');
End;

Procedure Prots.EndBatchTransfer;
Begin
 BackService('Batch transfer complete.');
End;

Procedure Prots.AsyncSendDLEChar;
Const DLEChars : Set of Char = [^P,^Q,^S,^V];
Begin
 If(Not(DoWXModem))Then AsyncSend(C)
  Else
 Begin
  If(C in DLEChars)Then
  Begin
   AsyncSendDLE;
   C := Char(Byte(C) XOR 64);
  End;
  AsyncSend(C);
 End;
End;

Procedure Prots.SendXmodemFile;
Label 1;
Const BadThreshhold = 6;
      SOHTries      = 5;
      NAKCh         = ^U;
      WXmodemWindow = 4;
      SeaLinkWindow = 6;
      YmodemFamily : Set of Byte = [trsXmodem1K,trsXmodem1KG,trsYmodemBatch,trsYmodemG];
Var
   I,L,Tries,Checksum,Crc,Ch,NRead,MaxTries,ITime,TransferTime,BadSectors:Int;
   ACKWindow,ACKSector,MaxACKWindow,MaxWindowSize,MaxWindowSize1,GoodSectors:Int;
   KbdCh,HeaderCh,NewHeaderCh:Char;
   EOFXFile,SaveXonXoff:Bool;
   RFileSize,XFileSize:Long;
   SendingTitle,ErrMess:String;
   EffectiveRate:Real;
   SCps:String[20];

 Procedure PutSendError(ErrText:String;DisplayBlock:Bool);
 Begin
  ErrMess := ErrText;
  If(DisplayBlock)Then
   AddStr(ErrMess,' at/before block ' + Str(WhoMax(SectorCount - 1,0)));
  W.PutTxtXY(25,8,ErrMess);
  W.ClrEol;
  BackService(ErrMess);
 End;

 Procedure XmodemWait4Ch(WaitTime:Int;Var Ch:Int);
 Var ITime : Int;
 Begin
  ITime := 0;
  Repeat
   Inc(ITime);
   AsyncReceiveWithTimeout(1000,Ch);
   ChkKbd;
  Until (Ch <> TimeOut)or(ITime >= WaitTime)or(StopSend);
 End;

 Procedure DoInitialHandshake;
 Begin
  W.PutTxtXY(25,8,'Wait for NAK/C/G/W --- ');
  W.ClrEol;
  MaxWindowSize := 0; MaxWindowSize1 := 1;
  Repeat
   XmodemWait4Ch(XmodemBlockWait,Ch);
   If(Ch = CAN)Then XmodemWait4Ch(XmodemACKWait,Ch);
   Inc(Tries);
   StopSend := StopSend or(Not(AsyncCarrierDetect));
  Until(Tries > SOHTries)or(Ch in [NAK,Byte('C'),Byte('G'),Byte('W'),CAN])or(StopSend);
  If(Ch = TimeOut)or(Tries > SOHTries)or(Ch = CAN)Then
  Begin
   W.PutTxtXY(25,8,'Not Received ');
   W.ClrEol;
   StopSend := True;
  End
   Else
  If(Ch = NAK)Then UseCrc := False Else
  If(Ch = Byte('C'))Then UseCrc := True Else
  If(Ch = Byte('G'))Then
  Begin
   UseCrc := True; DoACKs := False; AsyncDoXonXoff := True;
  End
   Else
  If(Ch = Byte('W'))Then
  Begin
   UseCrc := True; DoWXModem := True; AsyncDoXonXoff := True;
   MaxACKWindow := WXmodemWindow; MaxWindowSize := WXmodemWindow;
   MaxWindowSize1 := Succ(MaxWindowSize);
  End;
  If(Not(StopSend))Then
  Begin
   W.PutTxtXY(25,8,'Received ');
   Case Char(Ch) Of
    'C','G','W' : W.PutTxt(Char(Ch));
     NAKCh      : W.PutTxt('NAK');
   End;
   W.ClrEol;
  End;
 End;

Procedure HandleSectorACKNAK(Var Ch:Int);
Var ACKCh : Int; CompCh : Char;
Begin
 Ch := ACK;
 If(DoWXModem or(DoSeaLink))Then If(ACKWindow < MaxACKWindow)Then
  If(AsyncBufHead = AsyncBufTail)Then Exit;
 XmodemWait4Ch(XmodemAckWait,Ch);
 If(Ch = CAN)Then
 Begin
  XmodemWait4Ch(XmodemAckWait,Ch);
  If(Ch = CAN)Then EXIT;
 End;
 ACKSector := SectorNumber;
 If(DoWXModem OR DoSeaLink)Then
 Begin
  If((Ch = ACK)or(Ch = NAK))Then
  Begin
   XModemWait4Ch(XModemAckWait,ACKCh);
   If(DoWXModem)Then If(ACKCh > Pred(MaxWindowSize))Then Ch := ACK
    Else
   Begin
    ACKSector := (ACKCh and 3); ACKWindow := (SectorNumber and 3) - ACKSector;
    If(ACKWindow < 0)Then Inc(ACKWindow,MaxWindowSize);
   End
    Else
   If(DoSeaLink)Then
   Begin
    If(AsyncReceive(CompCh))Then If((Byte(CompCh) + ACKCh) = 255)Then
    Begin
     ACKSector := (ACKCh mod MaxWindowSize1);
     ACKWindow := (SectorNumber mod MaxWindowSize1) - ACKSector;
     If(ACKWindow < 0)Then Inc(ACKWindow,MaxWindowSize);
    End
     Else
    MaxACKWindow := 0
     Else
    MaxACKWindow := 0;
   End;
  End;
 End;
 If(Ch <> ACK)Then
 Begin
  PutSendError('No ACK',True);
  Inc(SendErrors);
 End;
End;

Procedure SendXmodemBlock;
Var I,SendState : Int;
Begin
 Tries := 0;
 If(CRCUsed)Then SendState := 1 Else SendState := 0;
 Repeat
  If(DoWXModem)Then AsyncSendSYN;
  AsyncSendDLEChar(HeaderCh);
  AsyncSendDLEChar(Char(SectorNumber));
  AsyncSendDLEChar(Char(255 - SectorNumber));
  Case SendState of
    0 : Begin
	 CheckSum := 0;
	 For I := 1 to SectorSize do
	 Begin
	  AsyncSendDLEChar(SectorData[I]);
	  CheckSum := (CheckSum + Byte(SectorData[I])) and $FF;
	 End;
	 AsyncSendDLEChar(Char(CheckSum));
	End;
    1 : Begin
	 Crc := 0;
	 For I := 1 to SectorSize do
	 Begin
	  AsyncSendDLEChar(SectorData[I]);
	  Crc := Swap(Crc) xor Byte(SectorData[I]);
	  Crc := Crc xor (Lo(Crc) shr 4);
	  Crc := Crc xor (Swap(Lo(Crc)) shl 4) xor (Lo(Crc) shl 5);
	 End;
	 AsyncSendDLEChar(Char(Hi(CRC)));
	 AsyncSendDLEChar(Char(Lo(CRC)));
	End;
    2 : Begin
	 CheckSum := 0;
	 For I := 1 to SectorSize do
	 Begin
	  AsyncSendDLEChar(SectorData[I]);
	  CheckSum := (CheckSum + Byte(SectorData[I])) and $FF;
	 End;
	 AsyncSendDLEChar(Char(CheckSum));
	End;
    3 : Begin
	 Crc := 0;
	 For I := 1 to SectorSize do
	 Begin
	  AsyncSendDLEChar(SectorData[I]);
	  Crc := Swap(Crc) xor Byte(SectorData[I]);
	  Crc := Crc xor (Lo(Crc) shr 4);
	  Crc := Crc xor (Swap(Lo(Crc))shl 4)xor(Lo(Crc) shl 5);
	 End;
	 AsyncSendDLEChar(Char(Hi(Crc)));
	 AsyncSendDLEChar(Char(Lo(Crc)));
	End;
    4 : Begin
	 For I := 1 to SectorSize do AsyncSendDLEChar(Char(SectorData[I]));
	 AsyncSendDLEChar(Char(CheckSum));
	End;
    5 : Begin
	 For I := 1 to SectorSize do AsyncSendDLEChar(SectorData[I]);
	 AsyncSendDLEChar(Char(Hi(Crc)));
	 AsyncSendDLEChar(Char(Lo(Crc)));
	End;
    6 : Begin
	 For I := 1 to SectorSize do AsyncSendDLEChar(SectorData[I]);
	 AsyncSendDLEChar(Char(CheckSum));
	End;
    7 : Begin
	 For I := 1 to SectorSize do AsyncSendDLEChar(SectorData[I]);
	 AsyncSendDLEChar(Char(Hi(Crc)));
	 AsyncSendDLEChar(Char(Lo(Crc)));
	End;
  End;
  If(Not(DoWXModem or DoSEALink or (Not DoAcks)))Then AsyncPurgeBuf;
  SendState := SendState or 4;
  Inc(Tries);
  If(DoAcks)Then HandleSectorACKNAK(Ch)
	    Else Ch := ACK;
  UpdateXmodemSendScr;
 Until(Ch = ACK)or(Ch = CAN)or(Tries > MaxTries)or(StopSend)or
      (AsyncCarrierDrop)or(DoWXModem)or(DoSEALink);
 Inc(ACKWindow);
 StopSend := StopSend or AsyncCarrierDrop;
End;

Procedure SendTelinkHeader;
Var SaveSize:Int; SaveCRC:Bool;
Begin
 MaxTries := 3; SaveSize := SectorSize; SaveCRC := CRCUsed;
 SectorSize := 128; CRCUsed := False; HeaderCh := Char(SYN);
 SendXmodemBlock;
 SectorSize := SaveSize; CRCUsed := SaveCRC; MaxTries := XmodemMaxErrors;
 If(Ch = ACK)Then PutSendError('Telink header accepted.',False)
	     Else PutSendError('Telink header not accepted.',False);
End;

Procedure SendYmodemHeader;
Var SaveSize : Int;
    SaveACK  : Bool;
Begin
 MaxTries := 3; SaveSize := SectorSize; SectorSize := 128;
 HeaderCh := Char(SOH); SaveACK := DoACKs; DoACKs := True;
 SendXmodemBlock;
 SectorSize := SaveSize; DoACKs := SaveACK; MaxTries := XmodemMaxErrors;
 If(Ch = ACK)Then PutSendError('Ymodem header accepted.',False)
	     Else PutSendError('Ymodem header not accepted.',False);
End;

Begin
 CrcUsed := UseCRC;
 If Not(UploadDirPath[Length(UploadDirPath)] = '\')Then IncStr(UploadDirPath,'\');
 XFileName := UploadDirPath + XFileName;
 GetXmodemTitles;
 FileMode := 0;
 Assign(XFile,XFileName);
 Reset(XFile,1);
 FileMode := 2;
 If(IoResult <> 0)Then
 Begin
  PutLastBar(2,'Cannot open file to send, transfer cancelled.');
  CancelTransfer;
  Exit;
 End;
 XFileSize := System.FileSize(XFile);
 RFileSize := XFileSize;
 MaxTries := XmodemMaxErrors;
 Blocks2Send := Round((XFileSize / 128) + 0.49);
 SavedTime2Send := Round(Blocks2Send * (1800.0 / BaudRate));
 Time2Send := SavedTime2Send;
 InitSendScr;
 System.Str(RFileSize,SCps);
 BackService('Size of file to send is ' + SCps + ' bytes');
 HeaderCh := Char(SOH);
 If(TransferProtocol in [trsXmodem1K,trsXmodem1KG,trsYmodemBatch,trsYmodemG])Then
 Begin
  If((DownSizeYmodem)and(XFileSize < 1024))Then
  Begin
   SectorSize := 128;
   PutSendError('Switching to 128 byte blocks',False);
  End
   Else
  Begin
   SectorSize := 1024;
   HeaderCh := Char(STX);
  End;
 End
  Else
 SectorSize := 128; NewHeaderCh := HeaderCh; SectorNumber := 0;
 SectorCount := 0; SendErrors := 0; StopSend := False;
 StartTime := TimeOfDay; EofXFile := False; AltSPressed := False;
 Tries := 0; DoACKs := True; DoWXModem := False; DoSeaLink := False;
 ACKWindow := 0; MaxACKWindow := 0;
 AsyncPurgeBuf;
 SaveXonXoff := AsyncDoXonXoff;
 AsyncDoXonXoff := HonorXoffYmodem and(TransferProtocol in YmodemFamily);
 DoInitialHandshake;
 If(Not(StopSend))Then
  If((TransferProtocol in [trsYmodemBatch,trsYmodemG,
  trsXmodem1K,trsXmodem1KG])and(UseYmodemHeader))Then
 Begin
  SendYmodemHeader;
  CRCUsed := True;
  DoInitialHandshake;
 End
  Else
 If(TransferProtocol = trsTelink)Then
 Begin
  SendTelinkHeader;
  CrcUsed := True;
 End;
 Repeat
  ChkKbd;
  StopSend := StopSend or (Not(AsyncCarrierDetect));
  If(Not(StopSend))Then
  Begin
   HeaderCh := NewHeaderCh;
   BlockRead(XFile,SectorData,SectorSize,NRead);
   If(IoResult <> 0)Then
   Begin
    PutSendError('Cannot read data from file',True);
    StopSend := True;
   End
    Else
   If(NRead <= 0)Then EOFXFile := True
    Else
   Begin
    If(NRead < SectorSize)Then FillChar(SectorData[NRead+1],SectorSize-NRead+1,0);
    Inc(SectorNumber);
    Inc(SectorCount,(SectorSize shr 7));
    SendXmodemBlock;
    If(DoWXModem)or(DoSeaLink)Then If(Ch = NAK)Then
    Begin
     Dec(SectorNumber,ACKWindow);
     L := (ACKWindow + 1) * SectorSize;
     Seek(XFile,FilePos(XFile) - L);
     EofXFile := False;
     Inc(XFileSize,L);
     Goto 1;
    End;
    If(Ch = ACK)Then
    Begin
     Time2Send := Round(SavedTime2Send * (1.0 - SectorCount / Blocks2Send));
     If(Time2Send < 0)Then Time2Send := 0;
     Inc(GoodSectors);
    End
     Else
    Begin
     Inc(BadSectors);
     If(BadThreshhold * BadSectors > GoodSectors)and
       (DownsizeYmodem)and(SectorSize = 1024)Then
     Begin
      NewHeaderCh := Char(SOH);
      SectorSize := 128;
      PutSendError('Switching to 128 byte blocks',False);
     End;
    End;
    Dec(XFileSize,NRead);
    If((XFileSize < 1024)and(DownSizeYmodem)and(SectorSize = 1024))Then
    Begin
     NewHeaderCh := Char(SOH);
     SectorSize  := 128;
     PutSendError('Switching to 128 byte blocks',False);
    End;
   End;
  End;
1:W.PutTxtXY(25,7,TimeString(Time2Send,MilitaryTime));
 Until (EOFXFile)or(Tries = MaxTries)or(Ch = CAN)or(StopSend);
 If(DoWXModem)or(DoSeaLink)Then
 Begin
  MaxACKWindow := 0;
  While((ACKWindow > 0)and(Ch <> CAN)and(Ch <> TimeOut)) do HandleSectorACKNAK(Ch);
 End;
 If(StopSend)Then If(AsyncCarrierDetect)Then CancelTransfer;
 If(Tries >= MaxTries)Then PutSendError('No ACK ever received.',False) Else
 IF(Ch = CAN)Then PutSendError('Receiver cancelled transmission.',False) Else
 If(AltSPressed)Then PutSendError('Alt-S hit, send cancelled.',False) Else
 If(Not(StopSend))Then
 Begin
  If(Not(DoAcks))Then
  Begin
   W.PutTxtXY(25,8,'Waiting for output buffer to drain');
   W.ClrEol;
   While ((AsyncOBufUsed > 128)and(Not(StopSend))) do
   Begin
    ChkKbd;
    StopSend := StopSend or (Not(AsyncCarrierDetect));
   End;
  End;
  W.PutTxtXY(25,8,'Waiting for ACK of EOT');
  W.ClrEol;
  Tries := 0; DoACKs := True;
  Repeat
   AsyncSendEOT;
   Inc(Tries);
   XmodemWait4Ch(XmodemAckWait,Ch);
   If(Ch = CAN)Then XmodemWait4Ch(XmodemAckWait,Ch);
   If(Tries > 1)Then Inc(SendErrors);
   UpdateXmodemSendScr;
   W.PutTxtXY(25,6,TimeString(Time2Send,MilitaryTime));
   ChkKbd;
  Until (Ch = ACK)or(Tries = MaxTries)or(Ch = CAN)or(StopSend);
  If(Tries = MaxTries)Then PutSendError('No ACK on EOT (end of transmission)',False) Else
  If(Ch = CAN)Then PutSendError('Receiver cancelled transmission.',False) Else
  If(AltSPressed)or(StopSend)Then PutSendError('Alt-S key hit, send cancelled.',False)
   Else
  Begin
   W.PutTxtXY(25,8,'EOT acknowledged, send complete.');
   W.ClrEol;
   EndTime := TimeOfDay;
   If(EndTime < StartTime)Then Inc(EndTime,86400);
   EffectiveRate := EndTime - StartTime;
   If(EffectiveRate = 0.0)Then EffectiveRate := 1.0;
   EffectiveRate := RFileSize / EffectiveRate;
   W.PutTxtXY(25,8,'Transfer rate was '+RealStr2(EffectiveRate,6,1)+' CPS');
   W.ClrEol;
   BackService('Send completed.');
   BackService('Transfer rate was ' + RealStr2(EffectiveRate,6,1) + ' CPS');
  End;
 End;
 If(StopSend)Then If(AsyncCarrierDrop)Then PutSendError('Carrier dropped.',False);
 System.Close(XFile);
 I := IoResult;
 AsyncDoXonXoff := SaveXonXoff;
End;

Procedure Prots.UpDownLoad;
Var SaveClose:Bool; I:Int;
Begin
 If(TransferProt = trsNone)Then Exit;
 DefaultTransferType := TransferProt;
 Case TransferDirec Of
  'R': TName := StrPas(ReceiveScriptNames[TransferProt]);
  'S': TName := StrPas(SendScriptNames[TransferProt]);
 End;
{ If(Length(TName) > 0)Then {If(Pos('.BAT',TName) = 0)Then
 Begin
  SaveClose     := CloseComm4Dos;
  CloseComm4Dos := True;
  ProcessScript(TName,'E');
  CloseComm4Dos := SaveClose;
 End
  Else
 TransferThroughBatchFile(TransferProtocol,TName,TransferDirec)
  Else}
 Begin
  Case TransferProt Of
   trsAscii :
   Case TransferDirec Of
    'R': ReceiveAsciiFile;
    'S': SendAsciiFile;
   End;
{   trsYmodemBatch, trsYmodemG,
   trsXmodem1K, trsXmodem1KG, trsXmodemCrc, trsXmodemChk,
   trsModem7CRC, trsTelink, trsModem7Chk:
   Case TransferDirec Of
    'R': DoXmodemDownload(TransferProt);
    'S': DoXmodemUpload(TransferProt);
   End;
   trsKermit:
   DoKermit(TransferDirec);}
  End;
 End;
End;

Destructor Prots.Done;
Begin
End;

BEGIN
END.