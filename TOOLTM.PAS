{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                               ³
 ³  Malte Genesis/Module d'Outil de T‚l‚matique  ³
 ³         Edition Isabel pour Mode R‚el         ³
 ³               III - Version 1.0               ³
 ³                  1995/02/02                   ³
 ³                                               ³
 ³   Copyright (C) par les Chevaliers de Malte   ³
 ³                                               ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit ToolTM;

INTERFACE

{$IFDEF Overlay}
 {$O+}
 {$F+}
{$ENDIF}

Uses Dos,Video,Memorys,Mems,Math,TeleMate,TMDials,Protocol;

Const

 MaxUsers = 100; MaxLoginTry = 3;

Type

 UserRecord=Record
  FirstName,LastName:String[20]; Password:String[10]; Privilege:Char;
 End;

 UserListType=Array[1..MaxUsers] of UserRecord;
 UserListPtrType=^UserListType;

 TermAtlas = Object(Term)
  UploadDirPath,DownloadDirPath,HostModeDownload,HostModeUpload:PathStr;
  Constructor Init(Y1,Y2,Com:Byte);
  Procedure HostMode;
  Procedure DoneHostMode;
  Procedure HangUpPhone;
  Function Run:Word;
  Destructor Done;
  PRIVATE
  _Done,ReallyDone,HostModeFlag,ExpertOn,SaveLogging:Bool;
  LocalHost,ReviewOn,LogFileOpen,FirstTime,SaveReview:Bool;
  RecipientName,CurUserName,SaveUpload,SaveDownload:PathStr;
  MsgSubject,MsgLn,CurHostStatus:String;
  Fname,Lname,PassWord:String[30];
  CRLFHost:String[2];
  NUsers,UserFileSize,CurUser,Ierr,NMsg,SaveHDataBits,
  SaveHStopBits,PageSize,HostIoError:Int;
  MsgFile:Text;
  UserList:UserListPtrType;
  OneUser:UserRecord;
  BlankTime:Long;
  HostSection,LastHostSect,SaveHParity,Privilege:Char;
  SaveHBaudRate,NewBaud:Word;
  Protocol:Prots;
  Procedure InitHostMode;
  Procedure CreateXferListFile(Handle:Word);
  Function DoHost:Word;
  Procedure DownloadAFile;
  Procedure EndPrompt(Mess:String);
  Procedure GetTransferTime(Var FileSpec:String;Var NFiles:Int;Var TransferTimeMsg:String);
  Procedure GetUserInfo(Var Found:Bool);
  Function GetXferProtocol:Byte;
  Procedure HostAutoBaudDetect(ModemAns:String);
  Procedure HostBaudDetect;
  Function HostCarrierDetect:Bool;
  Procedure HostSend(C:Char);
  Procedure HostSendStr(S:String);
  Procedure HostSendStrLn(S:String);
  Procedure HostSendStrNEcho(S:String);
  Procedure HostPromptNReadStr(Prompt:String;Var S:String;Echo:Bool);
  Procedure ListFiles4Transfer;
  Procedure ListPrompt(Var ListCount:Integer;Var ListDone:Bool);
  Function Open4Append(Var F:Text;FNm:String;Var Error:Int):Bool;
  Procedure PageSysop(Var SysopFound:Bool);
  Procedure PutHostCmd;
  Procedure PutWelcomeMsg;
  Procedure PutXferCmd;
  Procedure PutXferProtocols;
  Function ProcessFileTransferCmd(Var __Done,Back:Bool):Word;
  Function ProcessHostCmd(Var __Done:Bool):Word;
  Procedure ResetThePort;
  Procedure UploadAFile;
  Procedure WriteLog(S:String;Cont,Scr:Bool);
  Procedure Wait4Ring(Var __Done:Bool);
 End;

Procedure StatDialEntry(Dial:DialRecord);
Function EditDialEntry(Var Dial:DialRecord):Bool;

IMPLEMENTATION

Uses Strs,Cursor,Clock,Strings,Language,Printers,Keyboard,
     Systems,Terminal,MLibrary,Windows,Dials,MalBkRes,Country;

Function WinInpUser(Var User:UserRecord):Bool; Forward;
Function WinNewUser(Var User:UserRecord):Bool; Forward;

Constructor TermAtlas.Init;
Begin
 HostModeFlag := False; HostModeDownload := ''; HostModeUpload := '';
 UploadDirPath := ''; DownloadDirPath := ''; CurHostStatus := '';
 Inherited Init(0,Y1,79,Y2,Com);
 Protocol.Init(0,4);
End;

Function TermAtlas.HostCarrierDetect;
Begin
 HostCarrierDetect := True;
 If Not(LocalHost)Then HostCarrierDetect := AsyncCarrierDetect;
End;

Procedure TermAtlas.WriteLog;
Begin
 If(Scr)Then PutTxtLn(S);
 BackService(S);
End;

Function TermAtlas.Open4Append;
Var OpenOk:Bool; FByte:File of Byte;
Begin
 Assign(FByte,FNm);
 Reset(FByte);
 Error := IOResult; OpenOK := (Error = 0);
 If(OpenOk)Then If(System.FileSize(FByte) = 0)Then OpenOk := False;
 System.Close(FByte);
 Error := IoResult;
 Assign(F,FName);
 If(OpenOk)Then Append(F) Else ReWrite(F);
 Error := IoResult; Open4Append := (Error = 0);
End;

Function GetAStr(S:String;Var IS:Int;Delim:Char):String;
Var T:String;
Begin
 T := '';
 While (IS <= Length(S))and(S[IS] <> Delim) do
 Begin
  IncStr(T,S[IS]); Inc(IS);
 End;
 GetAStr := T;
End;

Procedure TermAtlas.CreateXferListFile;
Var FileEntry:SearchRec; SFileTime,SFileDate:String[8];
    DirSpec:String; DirSkipEntry:Byte;
Begin
 If(FileError <> 0)Then
 Begin
  WriteLog('Impossible de cr‚‚ TERMINAL.XFR.',False,True);
  Ln;
  Exit;
 End
  Else
 If(Length(HostModeDownload) = 0)Then
 Begin
  WriteLog('Cr‚e TERMINAL.XFR vide.',False,True);
  Ln;
  PutFileTextLn(Handle,'Pas fichier disponible pour le "Download".');
  Exit;
 End;
 WriteLog('Cr‚e TERMINAL.XFR pour le r‚pertoire '+HostModeDownload+'.',False,True);
 DirSpec := SetPath4AddFile(HostModeDownload) + '*.*';
 PutFileTextLn(Handle,
  '==================== Fichiers pour "Downloader" ====================');
 DirSkipEntry := (Hidden)or(Directory)or(VolumeID)or(SysFile);
 FindFirst(DirSpec,$FFFF-Directory-VolumeID,FileEntry);
 While (DosError = 0) do With FileEntry do
 Begin
  PutFileTextLn(Handle,StrUSpc(Name,14)+' '+Str2(Size,8)+' '+
		CStrDate(FileEntry.Time)+' '+CStrTime(FileEntry.Time));
  FindNext(FileEntry);
 End;
End;

Procedure TermAtlas.InitHostMode;
Const LogFileName = 'TERMINAL.LOG';
Var QErr,DoneFlag:Bool; UserFile,LogFile:Text; UserLine:String; I:Int;
    XferHandle:Word;
Begin
 HostModeFlag := True; _Done := False; ReallyDone := False; FirstTime := True;
 UserFileSize := 0; SaveUpload := UploadDirPath; SaveDownload := DownloadDirPath;
 DownloadDirPath := HostModeUpload; UploadDirPath := HostModeDownload;
 SaveReview := ReviewOn; ReviewOn := False; SaveLogging := LoggingOn;
 LoggingOn := True; LogFileOpen := Open4Append(LogFile,LogFileName,Ierr);
 ClrScr;
 {StatusLineAttr    := 16 * (ForeGroundColor and 7) + BackGroundColor;}
 {DoStatusLine      := True;
 DoStatusTime      := True;
 CurrentStatusTime := -1;}
 PutLastBar(2,'^ESC^ Quitter  ^F1^ Chat  ^F2^ Logout  ^F3^ Dos  ^F4^ Undim  ^F5^ Appelle  ^Enter^ Local');
 PutMode('HostMode');
{ WriteToStatusLine(StatusLineName,1);}
 WriteLog('D‚bute le mode Host.',False,False);
 Assign(UserFile,SetPath4AddFile(StrPas(PathBBS))+'TERMINAL.USF');
 (*!I-*) Reset(UserFile); (*!I+*)
 If(IoResult <> 0)Then
 Begin
  Ln;
  WriteLog('Pas d''usager pr‚sent dans le fichier, assume l''usager en mode simple.',False,True);
  UserList := @OneUser;
  WinNewUser(UserList^[1]);
  Ln;
  NUsers := 1;
 End
  Else
 Begin
  UserFileSize := 0;
  Repeat
   ReadLn(UserFile,UserLine);
   Inc(UserFileSize);
  Until(Eof(UserFile)or(UserFileSize > MaxUsers));
  UserList := MemAlloc(UserFileSize * SizeOf(UserRecord));
  If(UserList = NIL)Then
  Begin
   ReallyDone := True;
   Ln;
   WriteLog('Pas assez de m‚moire pour sauvegarder l''usager',False,True);
   System.Close(UserFile);
   I := IoResult; UserFileSize := 0;
   Exit;
  End;
  Reset(UserFile);
  NUsers := 0;
  Repeat
   Inc(NUsers);
   ReadLn(UserFile,UserLine);
   With UserList^[NUsers] do
   Begin
    I := 1; FirstName := Trim(StrUp(GetAStr(UserLine,I,';')));
    Inc(I); LastName := Trim(StrUp(GetAStr(UserLine,I,';')));
    Inc(I); PassWord := Trim(GetAStr(UserLine,I,';'));
    Inc(I); UserLine := Trim(StrUp(GetAStr(UserLine,I,';'))); Privilege := UserLine[1];
    If(Privilege <> 'S')Then Privilege := 'N';
   End;
   If(UserList^[NUsers].FirstName = '')Then Dec(NUsers);
  Until (EOF(UserFile)or(NUsers >= MaxUsers));
  If(NUsers = 1)Then WriteLog('Il y a 1 usager enregistr‚ dans le UserFile.',False,True)
		Else WriteLog('Il y a '+Str(NUsers)+' usagers enregistr‚s dans le UserFile.',False,True);
  Ln;
  Ln;
 End;
 System.Close(UserFile);
 I := IoResult; NMsg := 0;
 Assign(MsgFile,'TERMINAL.MSG');
 Reset(MsgFile);
 If(IoResult <> 0)Then
 Begin
  WriteLog('Pas de messages dans la BoŒte aux lettres.',False,True);
  Ln;
 End
  Else
 Repeat
  ReadLn(MsgFile,MsgLn);
  If(Copy(MsgLn,1,6) = '== End')Then Inc(NMsg);
 Until (EOF(MsgFile));
 If(NMsg > 0)Then If(NMsg = 1)Then
 Begin
  WriteLog('Il y a 1 message dans la boŒte aux lettres.',False,True);
  Ln;
 End
  Else
 Begin
  WriteLog('Il y a ' + Str(NMsg)+' messages dans la boŒte aux lettres.',False,True);
  Ln;
 End;
 System.Close(MsgFile);
 I := IoResult;
 If(FileExist('TERMINAL.XFR'))Then Systems.Del('TERMINAL.XFR');
 XFerHandle := New('TERMINAL.XFR');
 If(IsHandle(XFerHandle))Then
 Begin
  CreateXferListFile(XFerHandle);
  Close(XFerHandle);
 End;
End;

Procedure TermAtlas.HostMode;
Begin
 HostModeFlag := True; SaveHParity := Parity; SaveHDataBits := DataBits;
 SaveHStopBits := StopBits; SaveHBaudRate := BaudRate;
 InitHostMode;
End;

Procedure TermAtlas.PutXferCmd;
Begin
 If Not(ExpertOn)Then
 Begin
  HostSendStrLn('');
  HostSendStrLn(MultChar('=',54));
  HostSendStrLn('=       Terminal Host Mode File Transfer Menu        =');
  HostSendStrLn(MultChar('=',54));
  HostSendStrLn(' ');
  HostSendStrLn('     U=Envoie un fichier');
  HostSendStrLn('     D=Recoie un fichier');
  HostSendStrLn('     L=Liste des fichiers pour le transfŠre');
  If(Privilege = 'S')Then HostSendStrLn('     J=Saute au Dos');
  HostSendStrLn('     M=Retourne au menu principal');
  HostSendStrLn('     Q=Quitte et "logoff"');
  HostSendStrLn('     X=Mode Expert');
  HostSendStrLn('');
  HostSendStrLn(MultChar('=',54));
  HostSendStrLn('');
  HostSendStrNEcho('Entrer la commande ? ');
 End
  Else
 Begin
  HostSendStrLn('');
  If(Privilege = 'S')Then HostSendStrNEcho('Xfer (U,D,J,L,M,Q,X) ? ')
		     Else HostSendStrNEcho('Xfer (U,D,L,M,Q,X) ? ');
 End;
 If Not(LocalHost)Then AsyncPurgeBuf;
End;

Procedure TermAtlas.ListFiles4Transfer;
Begin
 PutStatus('Liste des fichiers');
 W.SetPause(True);
 W.TypeFile('TERMINAL.XFR');
 W.SetPause(False);
 WriteLog('Liste des fichiers pour le transfŠre.',False,False);
 PutStatus(CurHostStatus);
End;

Procedure TermAtlas.PutXferProtocols;
Var I:Byte; S:String;
Begin
 HostSendStrLn('');
 HostSendStrLn('Les protocols de transfŠre disponible sont:');
 HostSendStrLn('');
 For I := 0 to MaxTransferTypes do
 Begin
  S := Spc(4)+Copy(TransTypeName[I],1,2)+SpcTab+StrPas(TransNameList[I]);
  HostSendStrLn(S);
 End;
 HostSendStrLn('   Q ou ^X  Quitte le transfŠre');
End;

Function TermAtlas.GetXferProtocol:Byte;
Var TransMode:String[30]; TransferProtocol,T:Byte;
    I:Int; TransModeChar2:String[2];
Begin
 Repeat
  HostSendStrLn('');
  HostPromptNReadStr('Entrer le protocol de transfŠre (? pour la Liste, ^X pour Quitter): ',
		     TransMode,True);
  TransModeChar2[1] := ' '; TransModeChar2[2] := ' ';
  TransMode := StrUp(Trim(TransMode));
  For I := 1 to WhoMin(Length(TransMode),2) do TransModeChar2[I] := TransMode[I];
  TransferProtocol := trsNone;
  If(TransMode = '?')Then PutXferProtocols else
  If((TransMode <> ^X)and(TransMode <> 'Q'))Then
  For I := 1 to MaxTransferTypes do
   If(TransModeChar2 = TransTypeName[I])Then TransferProtocol := T;
 Until (TransferProtocol <> trsNone)or(TransMode = 'Q')or(TransMode = ^X);
 GetXferProtocol := TransferProtocol;
 If(TransferProtocol = trsKermit)Then Protocol.KermitFileTypeVar := KermitBinary;
End;

Procedure TermAtlas.UploadAFile;
Var FileName,TransMode:String; TransferProtocol:Byte;
    OK2Upload,SaveAttended,SDone,SingleFP:Bool;
Begin
 TransferProtocol := GetXferProtocol;
 If(TransferProtocol = trsNone)Then Exit;
 FileName := ''; SingleFP := SingleFileProtocol[TransferProtocol]; OK2Upload := True;
 If Not(HostModeUpload[Length(HostModeUpload)] = '\')Then IncStr(HostModeUpload,'\');
 If(SingleFP)Then
 Begin
  HostSendStrLn('');
  HostPromptNReadStr('Entrer le nom du fichier … recevoir: ',FileName,True);
  If(FileName = '')or(Pos(^X,FileName) > 0)Then Exit;
  If Not(IsWildCard(FileName))Then
   Ok2Upload := Not(FileExist(HostModeUpload+FileName))
   Else
  Begin
   Ok2Upload := False;
   HostSendStrLn('');
   HostSendStr('Les "Wildcards" ne sont pas disponible pour ce protocole.');
   Exit;
  End;
 End;
 If(Privilege = 'S')Then Ok2Upload := True;
 If(Ok2Upload)Then
 Begin
  FileName := FileName;
  HostSendStrLn('');
  HostSendStrLn('Prˆte … recevoir, d‚butez votre proc‚dure d''envoie.');
  AsyncDrainOutputBuf(5000);
  SaveAttended := AttendedMode; AttendedMode := False;
  PutStatus('R‚ception fichier');
  Protocol.UpDownLoad(TransferProtocol,'R');
{   While ScriptFileMode do
  Begin
    GetScriptCommand(PibTerm_Command);
    Execute_Command(PibTerm_Command,SDone,True);
   End;}
  PutStatus(CurHostStatus);
  AttendedMode := SaveAttended;
 End
  Else
 Begin
  HostSendStrLn('');
  HostSendStrLn('Fichier d‚j… existant, "upload" annul‚.');
  Ok2Upload := False;
 End;
End;

Procedure TermAtlas.GetTransferTime(Var FileSpec:String;Var NFiles:Int;Var TransferTimeMsg:String);
Var TotalFileSize,FileSize,TransferTime:Long;
    FileEntry:SearchRec; LastFound,OkFile:Bool;
    SNFiles,SFileSize:String[8]; InfoLine:String;
Begin
 HostSendStrLn('');
 HostSendStrLn('Recherche la liste de fichier...');
 TotalFileSize := 0; NFiles := 0;
 FileSpec := SetPath4AddFile(HostModeDownload) + FileSpec;
 FindFirst(FileSpec,AnyFile,FileEntry);
 LastFound := (DosError <> 0);
 While Not(LastFound) do With FileEntry do
 Begin
  OkFile := True;
{   If(Privilege <> 'S')Then OkFile := (ScanXferList(Name) > 0);}
  If(OkFile)Then
  Begin
   Inc(NFiles);
   If(NFiles = 1)Then
   Begin
    HostSendStrLn(' File name      Size     Trans. time');
    HostSendStrLn('============  ========   ===========');
   End;
   Inc(TotalFileSize,Size);
   SFileSize := Str2(Size,8);
   TransferTime := Round(Round((Size / 128.0) + 0.49) *
		   (TransTimeVal * 1.0) / (BaudRate * 1.0));
   InfoLine := Name + Spc(14 - Length(Name)) + SFileSize + '     ' +
	       TimeString(TransferTime,MilitaryTime);
   HostSendStrLn(InfoLine);
  End;
  FindNext(FileEntry);
  LastFound := (LastFound)or(DosError <> 0);
 End;
 TransferTimeMsg := 'Temps approximatif de transfŠre pour ';
 If(NFiles <= 1)Then AddStr(TransferTimeMsg,'1 fichier est ')
  Else
 AddStr(TransferTimeMsg,Str(NFiles) + ' fichiers est ');
 AddStr(TransferTimeMsg,TimeString(Round((TotalFileSize / 128.0) + 0.49) *
 Round((TransTimeVal * 1.0) / BaudRate),MilitaryTime));
End;

Procedure TermAtlas.DownloadAFile;
Var FileName,TransMode:String; TransferProtocol:Byte;
    NFiles:Int; SaveAttended,SDone:Bool;
Begin
 TransferProtocol := GetXferProtocol;
 If(TransferProtocol = trsNone)Then Exit;
 HostSendStr(CRLFHost);
 HostPromptNReadStr('Entrer le nom du fichier … "download": ',FileName,True);
 If(FileName = '')or(Pos(^X,FileName) > 0)Then Exit;
 If(Privilege <> 'S')Then If(Pos('\',FileName) <> 0)or(Pos(':',FileName) <> 0)Then
 Begin
  HostSendStr(CRLFHost);
  HostSendStr('Cette sp‚cification de fichier est invalide.');
  Exit;
 End;
 If Not(IsWildCard(FileName))Then If(SingleFileProtocol[TransferProtocol])Then
 Begin
  HostSendStr(CRLFHost);
  HostSendStr('Les "Wildcards" ne sont pas disponible avec ce protocole.');
  Exit
 End;
 GetTransferTime(FileName,NFiles,TransMode);
 If(NFiles <= 0)Then
 Begin
  HostSendStrLn('');
  HostSendStrLn('Aucun fichiers trouv‚ … envoyer, transfŠre annul‚.');
  Exit;
 End;
 FileName := FileName;
 HostSendStrLn('');
 HostSendStrLn(TransMode);
 HostSendStrLn('Prˆte … envoyer, pr‚parez votre proc‚dure de r‚ception.');
 AsyncDrainOutputBuf(5000);
 SaveAttended := AttendedMode;
 AttendedMode := False;
 PutStatus('Envoie du fichier en cours');
 Protocol.UpDownLoad(TransferProtocol,'S');
{ WHILE Script_File_Mode DO
 BEGIN
  Get_Script_Command( PibTerm_Command );
  Execute_Command   ( PibTerm_Command , SDone , TRUE );
 END;}
 PutStatus(CurHostStatus);
 AttendedMode := SaveAttended;
End;

Function TermAtlas.ProcessFileTransferCmd;
Var FoundCh,DontEcho,KbdInput:Bool; K:Word; Ch:Char Absolute K;
Label ReadChar;
Begin
 ProcessFileTransferCmd := kbNoKey; CurHostStatus := 'Section fichier';
 PutStatus(CurHostStatus);
 Back := False;
 PutXferCmd;
ReadChar:
 KbdInput := False;
 Repeat
  FoundCh := (AsyncReceive(Ch))or(KeyPressed);
  __Done  := __Done or(Not(HostCarrierDetect));
 Until __Done or FoundCh;
 DontEcho := False;
 If(KeyPressed)Then
 Begin
  K := ReadKey;
  Ch := Char(K);
  KbdInput := True;
  If(K = kbEsc)and(KeyPressed)Then
  Begin
   DontEcho := True;
   K := ReadKey;
   Case K of
    kbF1: Ch := 'G';
    kbF2: Ch := 'Q';
    kbF3: Begin
	    {DosJump('');}
	    Ch := ' ';
	   End;
    kbF5: Begin
	   PutTxtLn('');
	   PutTxtLn('Appeleur courant est '+CurUserName);
	   Ch := ' ';
	   End;
     Else Begin
	   ProcessFileTransferCmd := K;
	   Exit;
	  End;
   End;
  End;
 End;
 If(Ch = ' ')Then Goto ReadChar;
 If Not(__DONE)Then If Not(DontEcho)Then
 Begin
  BackService(Ch+CRLFHost);
  HostSendStr(Ch+CRLFHost);
 End;
 Case UpCase(Ch) of
  'U' : UploadAFile;
  'D' : DownloadAFile;
  'Q' : Begin
	 If(KbdInput)Then
	 Begin
	  HostSendStrLn('Op‚rateur systŠme termine le systŠme.');
	  HostSendStrLn('Merci d''avoir appell‚.');
	  __Done := True;
	 End
	  Else
	 Begin
	  HostSendStrLn('Quitte & "logoff"');
	  __Done := True;
	 End;
	End;
  'L' : ListFiles4Transfer;
  'X' : ExpertOn := Not(ExpertOn);
  'M' : Begin
	 Back := True; HostSection := 'M';
	End;
  'G' : If(KbdInput)Then
	Begin
	 HostSendStrLn('...demande … l''op‚rateur SystŠme de rentrer en dialogue, S.V.P. attendre...');
	 HostSendStrLn('');
	 Back := True; LastHostSect := 'F'; HostSection := 'G';
	End;
  'J' : If(Privilege = 'S')Then
	Begin
	 HostSection := 'D';
	 LastHostSect := 'F';
	 Back := True;
	End
	 Else
	HostSendStr(^G);
  'Z' : {If(KbdInput)Then DosJump('');}
   Else HostSendStr(^G);
 End;
End;

Procedure TermAtlas.HostBaudDetect;
Const WaitChTime = 10; NOfHostBaudRates = 5;
      HostBaudRates:Array[1..NOfHostBaudRates] of Word = (2400,1200,9600,19200,300);
Var FoundSpeed:Bool; IBaud:Int;

 Function TryBaudRate(TestBaudRate:Word):Bool;
 Var StrippedCh,Ch:Int; TimedOut:Bool;
 Begin
  TryBaudRate := False; BaudRate := TestBaudRate;
  AsyncResetPort(CommPort,BaudRate,Parity,DataBits,StopBits);
{  PutMode(ShortTerminalName);
  WriteToStatusLine(StatusLineName,1);}
  AsyncReceiveWithTimeOut(WaitChTime,Ch);
  TimedOut := (Ch = TimeOut);
  AsyncClearErrors;
  StrippedCh := (Ch and $7F);
  If Not(TimedOut)Then If(StrippedCh = CR)or(StrippedCh = Byte(' '))Then
  Begin
   TryBaudRate := True;
   If(StrippedCh <> Ch)Then
   Begin
    If(Parity = 'N')Then
    Begin
     Parity := 'E'; DataBits := 7;
    End
     Else
    Begin
     Parity := 'N'; DataBits := 8;
    End;
    AsyncResetPort(CommPort,BaudRate,Parity,DataBits,StopBits);
{    SetStatusLineName(ShortTerminalName);
    WriteToStatusLine(StatusLineName,1);}
   End;
  End;
 End;

Begin
 FoundSpeed := False;
 Delay(20000);
 AsyncPurgeBuf;
 While (Not(FoundSpeed))and(AsyncCarrierDetect) do
 Begin
  IBaud := 0;
  Repeat
   Inc(IBaud); Parity := 'N'; DataBits := 8;
   FoundSpeed := TryBaudRate(HostBaudRates[IBaud]);
  Until (FoundSpeed)or(IBaud >= NOfHostBaudRates);
  If(FoundSpeed)Then FoundSpeed := TryBaudRate(HostBaudRates[IBaud]);
  If Not(FoundSpeed)Then
  Begin
   Delay(5);
   AsyncPurgeBuf;
  End;
 End;
 Delay(20000);
 AsyncPurgeBuf;
 PutTxtLn('Communications ajust‚ … '+Str(BaudRate)+' baud et Parit‚ = '+Parity);
End;

Procedure TermAtlas.HostAutoBaudDetect;
Var _NewBaud:Word; I,J:Int; MdmConnect:String;
Begin
 MdmConnect := StrPas(ModemConnect); _NewBaud := 0;
 J := Pos(MdmConnect,ModemAns) + Length(MdmConnect);
 For I := J to Length(ModemAns) do
 If(ModemAns[I] IN ['0'..'9'])Then _NewBaud := _NewBaud * 10 + Byte(ModemAns[I]) - Byte('0');
 If(_NewBaud = 0)Then _NewBaud := 300;
 If(_NewBaud > 0)Then
 Begin
  BaudRate := _NewBaud;
  AsyncResetPort(CommPort,BaudRate,Parity,DataBits,StopBits);
{   SetStatusLineName(ShortTerminalName);
  WriteToStatusLine(StatusLineName,1);}
  PutTxtLn('Communications ajust‚ … '+Str(BaudRate)+' baud.');
 End;
End;

Procedure TermAtlas.Wait4Ring;
Const HardWired = False; HostAutoBaud = True;
Var Qerr,MTimeOut,Blanked:Bool; ModemAns:String; Ch:Char; IntCh,I,J:Int; K:Word;
Begin
 Parity := 'N'; DataBits := 8; StopBits := 1; BaudRate := SaveHBaudRate;
 AsyncResetPort(CommPort,BaudRate,Parity,DataBits,StopBits);
 {SetStatusLineName(ShortTerminalName);
 WriteToStatusLine(StatusLineName,1);}
 If Not(HardWired)Then SendModemCmd(StrPas(ModemHostSet));
 AsyncDrainOutputBuf(5000);
 AsyncPurgeBuf;
 PutStatus('Mise en attente d''un appelle t‚l‚phonique...');
 ModemAns := ''; LocalHost := False;
 AsyncTermReady(True);
 __Done := False;
 PutTxtLn('Attend que le t‚l‚phone sonne.');
 PutTxtLn('Presse la touche ESC pour retourner au terminal.');
 PutTxtLn('F1 D‚bute/Arrˆte le ChatMode.');
 PutTxtLn('F2 Fermer immediatement aprŠs que l''usager est appell‚.');
 PutTxtLn('F5 Donne le nom de l''appeleur courant.');
 PutTxtLn('Presse n''importe quel autre touche pour d‚buter un Host Local.');
 AsyncPurgeBuf;
 BlankTime := TimeOfDay; Blanked := False;
 _InitKbd;
 Repeat
  _BackKbd;
  If(KeyPressed)Then
  Begin
   K := ReadKey;
   Case K of
   kbEsc:
   Begin
    __Done := True; ReallyDone := True;
    Exit;
   End;
   Else
   Begin
    LocalHost := True;
    PutTxtLn('D‚bute une session local de Host... ');
    AsyncTermReady(False);
    Exit;
   End;
   End;
  End;
 Until (HostCarrierDetect);
 PutTxtLn('Le t‚l‚phone sonne... ');
 PutStatus('R‚pond au t‚l‚phone');
 Delay(1000);
 MTimeOut := False;
 Repeat
  AsyncReceiveWithTimeOut(1,IntCh);
  If(IntCh <> TimeOut)Then
  Begin
   Ch := Char(IntCh);
   If(Ch in ['A'..'Z',' ','0'..'9'])Then IncStr(ModemAns,Ch);
   PutTxt(Ch);
   BackService(Ch);
  End
   Else
  MTimeOut := True;
 Until ((MTimeOut)or(__Done));
 If(Not(__Done))Then If(Not(HardWired))Then
 Begin
  If(HostAutoBaud)Then HostAutoBaudDetect(ModemAns)
		  Else HostBaudDetect;
 End;
 __Done := __Done or (Not(HostCarrierDetect));
End;

Procedure TermAtlas.ResetThePort;
Begin
 NewBaud := 150;
 If(BaudRate <> 300)Then NewBaud := 300;
 AsyncResetPort(CommPort,NewBaud,Parity,DataBits,StopBits);
{ Set_Status_Line_Name(Short_Terminal_Name);
 Write_To_Status_Line(Status_Line_Name,1);}
 PutStatus(CurHostStatus);
End;

Procedure TermAtlas.HangUpPhone;
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

Procedure TermAtlas.DoneHostMode;
Const HardWired = False;
Var SaveBaud:Word;
Begin
 If Not(HostModeFlag)Then Exit;
 CurHostStatus := 'Fin de la session Host';
 AsyncDrainOutputBuf(1000);
 If(Not(HardWired))Then
 Begin
  ResetThePort;
  SaveBaud := NewBaud; BaudRate := NewBaud;
  HangUpPhone;
  SendModemCmd(StrPas(ModemHostUnSet));
  AsyncDrainOutputBuf(5000);
  BaudRate := SaveBaud;
  AsyncResetPort(CommPort,BaudRate,Parity,DataBits,StopBits);
  AsyncPurgeBuf;
  {SetStatusLineName(ShortTerminalName);
  WriteToStatusLine(StatusLineName,1);}
 End;
 Ln;
 PutTxtLn('Session Host termin‚.');
 If(HardWired)Then
  ReallyDone := ReallyDone or (WarningMsgYesNo('Retourne … l''‚mulateur de terminal ?') = kbYes);
End;

Procedure TermAtlas.HostSendStr;
Begin
 If Not(LocalHost)Then AsyncSendStr(S);
 PutTxt(S);
 BackService(S);
End;

Procedure TermAtlas.HostSendStrLn;
Begin
 If Not(LocalHost)Then AsyncSendStr(S+CRLFHost);
 PutTxtLn(S);
 BackService(S+#13+#10);
End;

Procedure TermAtlas.HostSendStrNEcho;
Begin
 If Not(LocalHost)Then AsyncSendStr(S);
 PutTxt(S);
 BackService(S);
End;

Procedure TermAtlas.HostSend;
Begin
 If Not(LocalHost)Then AsyncSend(C);
 PutTxt(C);
End;

Procedure TermAtlas.ListPrompt;
Const ListPromptStr:String[63] =
	'<Enter> pour continuer, S pour arrˆter, <C>ontinue sans arrˆt: ';
Var ListChar:Char; FoundChar:Bool;
Begin
 Inc(ListCount);
 If(ListCount > PageSize)Then
 Begin
  Repeat
   HostSendStrNEcho(ListPromptStr);
   Repeat
    FoundChar := AsyncReceive(ListChar)or(KeyPressed);
{    If Not(FoundChar)Then GiveAwayTime(2);
    UpdateStatusLine;}
   Until (FoundChar)or(Not(HostCarrierDetect));
   If(KeyPressed)Then ListChar := Char(ReadKey);
   If(ListChar = Char(CR))Then ListChar := ' ';
   HostSendStrLn(ListChar);
   BackService(ListChar+CRLFHost);
   ListChar := ChrUp(ListChar);
  Until (ListChar in ['S','C',' '])or(Not(HostCarrierDetect));
  Case ListChar Of
    'C': ListCount := -MaxInt;
    'S': ListDone  := True;
    ' ': ListCount := 1;
  End;
 End;
End;

Procedure TermAtlas.EndPrompt;
Var ListChar:Char; FoundChar:Bool;
Begin
 HostSendStrLn('');
 HostSendStrNEcho(Mess);
 Repeat
  FoundChar := AsyncReceive(ListChar)or(KeyPressed);
 Until ((FoundChar)or(Not(HostCarrierDetect)));
 If(KeyPressed)Then ListChar := Char(ReadKey);
 If(ListChar = Char(CR))Then ListChar := ' ';
 HostSendStrLn(ListChar);
 BackService(ListChar+CRLFHost);
End;

Procedure TermAtlas.HostPromptNReadStr;
Var Ch,RemCh:Char; GotChar:Bool; K:Word;
Begin
 If(Length(Prompt) > 0)Then HostSendStrNEcho(Prompt);
 Ch := #0;
 S  := '';
 K := Input(S);
{  If(AsyncReceive(RemCh))Then}
 If(K = kbCtrlX)Then
 Begin
  S := ^X;
  HostSendStrNEcho(' *** Annul‚');
  Ln;
 End
  Else
 If(HostCarrierDetect)Then
 Begin
  Ln;
  BackService(S);
 End;
End;

Procedure TermAtlas.GetUserInfo;
Var MyPass,CallLine:String;
Begin
 PutStatus('Demande des informations sur un usager');
 HostSendStrLn('');
 HostPromptNReadStr('Entrez le pr‚nom: ',Fname,True);
 Fname := Trim(StrUp(Fname));
 HostSendStrLn(' ');
 HostPromptNReadStr('Entrez le nom de famille: ',Lname,True);
 Lname := Trim(StrUp(Lname));
 CurUser := 0; Found := False; Privilege := 'N'; CurUserName := '';
 If(Length(Fname) > 0)and(Length(Lname) > 0)Then
 Repeat
  Inc(CurUser);
  With UserList^[CurUser] do Found := (Fname = FirstName)and(Lname = LastName);
 Until((Found)or(CurUser >= NUsers));
 CurUserName := Fname + ' ' + Lname;
 If(Not(Found))Then
 Begin
  HostSendStrLn('');
  HostSendStrLn('Usager invalide.');
 End;
 If(Found)and(HostCarrierDetect)Then
 Begin
  HostSendStrLn('');
  HostPromptNReadStr('Entrez le mots de passe: ',MyPass,False);
  HostSendStrLn('');
  If(MyPass = UserList^[CurUser].PassWord)Then
  Begin
   HostSendStrLn('Mots de passe correcte.');
   Found := True;
   WriteLog(Fname+' '+Lname+' connect‚.',False,False);
   Privilege := UserList^[CurUser].Privilege;
  End
   Else
  Begin
   HostSendStrLn('Mots de passe incorrecte');
   Found := False;
   WriteLog(Fname+' '+Lname +' connect‚ avec un mauvais mots de passe = '+MyPass,False,False);
  End;
 End;
 If(Found)Then
 Begin
  CurHostStatus := CurUserName;
  PutStatus(CurHostStatus);
 End;
End;

Procedure TermAtlas.PutHostCmd;
Begin
 If(Not(ExpertOn))Then
 Begin
  HostSendStrLn('');
  HostSendStrLn(MultChar('=',54));
  HostSendStrLn('=             Menu Principal du Host Mode            =');
  HostSendStrLn(MultChar('=',54));
  HostSendStrLn(' ');
  HostSendStrLn('     E=Entrer un message');
  HostSendStrLn('     R=Lire un message');
  HostSendStrLn('     S=Recherche des messages');
  HostSendStrLn('     P=Recherche des messages personnel');
  HostSendStrLn('     Q=Quitter & "Logoff"');
  HostSendStrLn('     F=TransfŠres fichiers');
  HostSendStrLn('     G=Mode Gossip');
  HostSendStrLn('     X=Mode Expert');
  HostSendStrLn('     C=Envoie des commentaires');
  HostSendStrLn('     W=Lecture des messages de bienvenue');
  If(Privilege = 'S')Then HostSendStrLn('     J=Saute au Dos');
  HostSendStrLn('');
  HostSendStrLn(MultChar('=',54));
  HostSendStrNEcho('Entrer la commande ? ');
 End
  Else
 Begin
  HostSendStrLn('');
  If(Privilege = 'S')Then HostSendStrNEcho('Main (E,R,S,P,Q,F,G,X,C,W,J) ? ')
		     Else HostSendStrNEcho('Main (E,R,S,P,Q,F,G,X,C,W) ? ');
 End;
 If Not(LocalHost)Then AsyncPurgeBuf;
End;

Procedure TermAtlas.PageSysop(Var SysopFound:Bool);
Const SilentMode = False;
Var Timer:Long; I:Int; Ch:Char; K:Word;
Begin
 WriteLog('Page SYSOP.',False,False);
 PutStatus('Page SYSOP');
 HostSendStrLn('');
 SysopFound := False;
 If Not(SilentMode)Then
 Begin
  HostSendStrLn('Summoning Sysop (^X cancels) ...');
  Timer := 30;
  Repeat
   Beep; Beep; Beep; Beep; Beep; Beep;
   If(AsyncReceive(Ch))Then If(Ch = ^X)Then Timer := 0;
   If(KeyPressed)Then
   Begin
    K := ReadKey;
    Case K of
     kbEsc :;
   kbCtrlX : SysopFound := True;
	Else Timer := 0;
    End;
   End;
   Delay(1000);
   Dec(Timer);
  Until (Timer <= 0)or(SysopFound);
 End
  Else
 HostSendStrLn('Sysop non disponible, gossip annul‚.');
 PutStatus(CurHostStatus);
End;

Procedure TermAtlas.PutWelcomeMsg;
Begin
 If(W.TypeFile('TERMINAL.WEL'))Then
  EndPrompt('Fin de bienvenue, presse <ENTER> pour continuer...');
End;

Function TermAtlas.ProcessHostCmd;
Label ReadChar;
Var Back,FoundCh,SysopFound,KbdInput:Bool; Ch:Char; K:Word;

 Procedure GetAMsg(Var F:Text);
 Begin
  With UserList^[CurUser] do
  WriteLn(F,'== De:    ',Fname,' ',Lname);
  WriteLn(F,'== A:     ',RecipientName);
  WriteLn(F,'== Date:  ',StrTime(TimeOfDay));
  WriteLn(F,'== Sujet: ',MsgSubject);
  HostSendStr(CRLFHost);
  HostSendStrLn('Entrer un message.   Ligne vide termines.');
  Repeat
   HostSendStr(CRLFHost);
   HostPromptNReadStr('> ',MsgLn,True);
   If(Length(MsgLn) > 0)Then WriteLn(F,' ',MsgLn);
  Until (Length(MsgLn) = 0);
  WriteLn(F,'== End');
  HostSendStr(CRLFHost);
  HostSendStrLn('Message entrer.');
 End;

 Procedure EnterMsg;
 Var Quit:Bool; Ierr:Int;
 Begin
  PutStatus('Entrer un message');
  Quit := False;
  Assign(MsgFile,'TERMINAL.MSG');
  Reset(MsgFile);
  If(IoResult <> 0)Then
  Begin
   PutTxtLn('Creating message file TERMINAL.MSG');
   ReWrite(MsgFile);
   If(IoResult <> 0)Then
   Begin
    HostSendStrLn('D‚sol‚, pas assez de place pour tes messages');
    Quit := True;
   End;
  End
   Else
  Begin
   System.Close(MsgFile);
   HostIoError := IoResult;
   If(Not(Open4Append(MsgFile,'TERMINAL.MSG',Ierr)))Then
   Begin
    HostSendStr(CRLFHost);
    HostSendStrLn('D‚sol‚, pas assez de place pour tes messages');
    Quit := True;
   END;
  END;
  HostSendStr(CRLFHost);
  HostPromptNReadStr('Entrer le destinataire name ou ALL pour tous: ',
		     RecipientName,True);
  RecipientName := StrUp(Trim(RecipientName));
  If(RecipientName = '')Then RecipientName := 'ALL';
  HostSendStr(CRLFHost);
  HostPromptNReadStr('Enter title for message: ',MsgSubject,True);
  If(Not(Quit))Then GetAMsg(MsgFile);
  System.CLOSE(MsgFile);
  HostIOError := IoResult;
  Inc(NMsg);
  WriteLog('Entrer un message.',False,False);
  PutStatus(CurHostStatus);
 End;

 Procedure Skip2Msg(MsgNo:Int);
 Var MsgCount:Int;
 Begin
  MsgCount := 0;
  Repeat
   ReadLn(MsgFile,MsgLn);
   If(Copy(MsgLn,1,6) = '== End')Then Inc(MsgCount);
  Until (MsgCount = (MsgNo - 1));
 End;

 Procedure ReadMsg;
 Var MsgNo,StartMsg,I,LineCount:Int; ReadDone,OkNumber:Bool;
     StartMStr:String; CMsgNo:String[5];
 Label ReadingDone;
 Begin
  PutStatus('V‚rification du courrier de la boŒte aux lettres...');
  Assign(MsgFile,'TERMINAL.MSG');
  Reset(MsgFile);
  If(IoResult <> 0)Then
  Begin
   HostSendStr(CRLFHost);
   HostSendStrLn('Pas de messages dans la boŒte aux lettres.');
   Exit;
  End;
  Repeat
   OKNumber := True;
   HostSendStrLn('');
   System.Str(NMsg,StartMStr);
   If(NMsg = 1)Then StartMStr := 'Il y a 1 message dans la boŒte aux lettres.'
	       Else StartMStr := 'Il y a ' + StartMStr + ' messages dans la boŒte aux lettres.';
   HostSendStrLn(StartMStr);
   HostPromptNReadStr('Entrez le point d''entr‚e du courrier ou <Enter> pour tous: ',StartMStr,True);
   StartMsg := 0;
   For I := 1 to Length(StartMStr) do If(StartMStr[I] in ['0'..'9'])Then
    StartMsg := StartMsg * 10 + Byte(StartMStr[I]) - Byte('0')
   Else
    OKNumber := False;
   If(StartMsg = 0)Then StartMsg := 1;
   If(StartMsg > NMsg)Then StartMsg := NMsg;
  Until(Not(HostCarrierDetect))or(OKNumber);
  If(Not(HostCarrierDetect))Then Goto ReadingDone;
  Skip2Msg(StartMsg);
  MsgNo := Pred(StartMsg); ReadDone := False; LineCount := 0;
  Repeat
   Inc(MsgNo); CMsgNo := Str0(MsgNo,5);
   HostSendStr(CRLFHost);
   ListPrompt(LineCount,ReadDone);
   If(ReadDone)Then Goto ReadingDone;
   HostSendStrLn('Message #' + CMsgNo);
   ListPrompt(LineCount,ReadDone);
   If(ReadDone)Then Goto ReadingDone;
   For I := 1 to 5 do
   Begin
    ReadLn(MsgFile,MsgLn);
    MsgLn := Copy(MsgLn,4,Length(MsgLn) - 3);
    HostSendStrLn(MsgLn);
    ListPrompt(LineCount,ReadDone);
    If(ReadDone)Then Goto ReadingDone;
   End;
   HostSendStrLn('');
   ListPrompt(LineCount,ReadDone);
   If(ReadDone)Then Goto ReadingDone;
   Repeat
    ReadLn(MsgFile,MsgLn);
    If(Copy(MsgLn,1,6) <> '== End' )Then
    Begin
     HostSendStrLn(Copy(MsgLn,2,Pred(Length(MsgLn))));
     ListPrompt(LineCount,ReadDone);
    End;
   Until (Copy(MsgLn,1,6) = '== End')or(ReadDone);
  Until (MsgNo >= NMsg) or ReadDone;
ReadingDone:
  HostSendStrLn('');
  HostPromptNReadStr('Fin de la lecture de la messagerie, presse <Enter> pour continuer: ',StartMStr,True);
  HostSendStrLn('');
  System.Close(MsgFile);
  HostIOError := IoResult;
  WriteLog('Lecture des messages.',False,False);
  PutStatus(CurHostStatus);
 End;

 Procedure ScanMsg(PersonalOnly:Bool);
 Label ScanningDone;
 Var MsgNo,I,LineCount,StartMsg,MsgCount:Int; ScanDone,OKNumber:Bool;
     StartMStr,MsgL1,MsgL2,MsgTitle:String; CMsgNo:String[5];
 Begin
  PutStatus('Recherche des messages');
  Assign(MsgFile,'TERMINAL.MSG');
  Reset(MsgFile);
  If(IoResult <> 0)Then
  Begin
   HostSendStr(CRLFHost);
   HostSendStrLn('Pas de messages dans la boŒte aux lettres.');
   Goto ScanningDone;
  End;
  StartMsg := 1;
  If(Not(PersonalOnly))Then
  Repeat
   OKNumber := True;
   HostSendStrLn('');
   System.Str(NMsg,StartMStr);
   If(NMsg = 1)Then StartMStr := 'Il y a 1 message dans la boŒte aux lettres.'
	       Else StartMStr := 'Il y a ' + StartMStr + ' messages dans la boŒte aux lettres.';
   HostSendStrLn(StartMStr);
   HostPromptNReadStr('Entrez le point d''entr‚e du courrier ou <Enter> pour tous: ',StartMStr,True);
   StartMsg := 0;
   For I := 1 to Length(StartMStr) do If(StartMStr[I] in ['0'..'9'])Then
     StartMsg := StartMsg * 10 + Byte(StartMStr[I]) - Byte('0')
    Else
     OKNumber := False;
   If(StartMsg = 0)Then StartMsg := 1;
   If(StartMsg > NMsg)Then StartMsg := NMsg;
  Until (Not(HostCarrierDetect))or(OKNumber);
  If (Not(HostCarrierDetect))Then Goto ScanningDone;
  Skip2Msg(StartMsg);
  MsgNo := Pred(StartMsg); LineCount := 0; ScanDone := False; MsgCount := 0;
  Repeat
   Inc(MsgNo);
   ReadLn(MsgFile,MsgL1);
   ReadLn(MsgFile,MsgL2);
   If(Copy(MsgL2,13,Length(MsgL2)-12)=StrUp(CurUserName))or(Not(PersonalOnly))Then
   Begin
    Inc(MsgCount);
    System.Str(MsgNo:5,CMsgNo);
    HostSendStr(CRLFHost);
    ListPrompt(LineCount,ScanDone);
    If(ScanDone)Then Goto ScanningDone;
    HostSendStrLn('Message #' + CMsgNo);
    ListPrompt(LineCount,ScanDone);
    If(ScanDone)Then Goto ScanningDone;
    HostSendStrLn(Copy(MsgL1,4,Length(MsgL1) - 3));
    ListPrompt(LineCount,ScanDone);
    If(ScanDone)Then Goto ScanningDone;
    HostSendStrLn(Copy(MsgL2,4,Length(MsgL2) - 3));
    ListPrompt(LineCount,ScanDone);
    If(ScanDone)Then Goto ScanningDone;
    For I := 3 to 5 do
    Begin
     ReadLn(MsgFile,MsgLn);
     MsgLn := Copy(MsgLn,4,Length(MsgLn) - 3);
     HostSendStrLn(MsgLn);
     ListPrompt(LineCount,ScanDone);
     If(ScanDone)Then Goto ScanningDone;
    End;
    HostSendStrLn('');
    ListPrompt(LineCount,ScanDone);
   End;
   If(Not(ScanDone))Then
   Repeat
    ReadLn(MsgFile,MsgLn);
   Until (Copy(MsgLn,1,6) = '== End');
  Until (MsgNo >= NMsg)or(ScanDone);
ScanningDone:
  System.Close(MsgFile);
  HostIOError := IoResult;
  If(PersonalOnly)Then If(MsgCount = 0)Then
  Begin
   HostSendStrLn('');
   HostSendStrLn('Vous n''avez pas de courrier personnellement.');
  End;
  HostSendStrLn('');
  HostPromptNReadStr('Fin de recherche des messages, presse <Enter> pour continuer: ',
		     StartMStr,True);
  HostSendStrLn('');
  WriteLog('Recherche des messages.',False,False);
  PutStatus(CurHostStatus);
 End;

 Procedure EnterComment;
 Var Quit:Bool; Ierr:Int; CommentsFile:Text;
 Begin
  PutStatus('Entrer commentaire');
  Quit := False;
  Assign(CommentsFile,'TERMINAL.CMT');
  Reset(CommentsFile);
  If(IoResult <> 0)Then
  Begin
   PutTxtLn('Cr‚ation du fichier de commentaires TERMINAL.CMT');
   ReWrite(CommentsFile);
   If(IoResult <> 0)Then
   Begin
    HostSendStrLn('');
    HostSendStrLn('D‚sol‚, impossible d''accepter votre commentaire maintenant.');
    Quit := True;
   End;
  End
   Else
  Begin
   System.Close(CommentsFile);
   HostIOError := IoResult;
   If(Not(Open4Append(CommentsFile,'TERMINAL.CMT',Ierr)))Then
   Begin
    HostSendStrLn('');
    HostSendStrLn('D‚sol‚, impossible d''accepter votre commentaire maintenant.');
    Quit := True;
   End;
  End;
  RecipientName := 'SYSOP';
  MsgSubject := ' ';
  If(Not(Quit))Then GetAMsg(CommentsFile);
  System.Close(CommentsFile);
  HostIOError := IoResult;
  WriteLog('Entrer un commentaire au SYSOP.',False,False);
  PutStatus(CurHostStatus);
 End;

 

Begin
 ProcessHostCmd := kbNoKey;
 If(HostSection = 'I')Then
 Begin
  PutWelcomeMsg;
  HostSendStrLn('');
  HostSendStrLn('');
  HostSendStrLn('Recherche pour des messages personnel...');
  ScanMsg(True);
  HostSection := 'M';
 End;
 CurHostStatus := 'Courrier';
 PutStatus(CurHostStatus);
 PutHostCmd;
ReadChar:
 KbdInput := False;
 _InitKbd;
 Repeat
  _BackKbd;
  __Done := __Done or(Not(HostCarrierDetect));
  FoundCh := AsyncReceive(Ch)or(KeyPressed);
{  If(Not(FoundCh))Then GiveAwayTime( 2 );}
 Until(__Done)or(FoundCh);
 If(KeyPressed)Then
 Begin
  _BackKbd;
  K := ReadKey; Ch := Char(K); KbdInput := True;
  If(K = kbEsc)and(Keypressed)Then
  Begin
   K := ReadKey; Ch := Char(K);
   Case K of
   kbF1 : Ch := 'G';
   kbF2 : Ch := 'Q';
   kbF3 : Begin
{           DosJump('');}
	   Ch := ' ';
	  End;
   kbF5 : Begin
	   PutTxtLn('');
	   PutTxtLn('Appelleur current est '+CurUserName);
	   Ch := ' ';
	  End;
     Else If(Ch = #0)Then
	  Begin
	   ProcessHostCmd := K;
	   Exit;
	  End;
   End;
  End
   Else
  If(Ch = #0)Then
  Begin
   ProcessHostCmd := K;
   Exit;
  End;
 End;
 If(Ch = ' ')Then Goto ReadChar;
 If(Not(__Done))Then HostSendStrLn(Ch);
 Ln;
 BackService(Ch+CRLFHost);
 Case UpCase(Ch) OF
  'E': EnterMsg;
  'R': ReadMsg;
  'Q': Begin
	If(KbdInput)Then
	Begin
	 HostSendStrLn('Op‚rateur SystŠme vous sort du systŠme.');
	 HostSendStrLn('Merci d''avoir appell‚.');
	 __Done := True;
	End
	 Else
	Begin
	 HostSendStrLn('Quitte & Logoff');
	 __Done := True;
	End;
       End;
  'F': HostSection := 'F';
  'G': Begin
	If(KbdInput)Then
	Begin
	 HostSendStrLn(' ... Op‚rateur systŠme entrer en "chat" mode , S.V.P. attendre...');
	 HostSendStrLn('');
	 HostSection := 'G'; LastHostSect := 'M';
	End
	 Else
	Begin
	 PageSysop(SysopFound);
	 If(SysopFound)Then
	 Begin
	  HostSection := 'G'; LastHostSect := 'M';
	 End;
	End;
       End;
  'C': EnterComment;
  'P': ScanMsg(True);
  'X': ExpertOn := Not(ExpertOn);
  'S': ScanMsg(False);
  'J': If(Privilege = 'S')Then
       Begin
	HostSection := 'D'; LastHostSect := 'M';
       End
	Else
       HostSendStr(^G);
  'W': PutWelcomeMsg;
  Else HostSendStr(^G);
 End;
End;

Function TermAtlas.DoHost;
Var Ch,SCh:Char; MyPass:String; Try:Int;
    Back,KeyedIn,__Done,Found:Bool; K:Word;
Begin
 DoHost := kbNoKey;
 AsyncPurgeBuf;
 ExpertOn := False; CRLFHost := Char(CR); __Done := False; CurHostStatus := '';
 HostSendStrLn('D‚bute la communications');
 HostSendStrLn('');
 HostSendStrLn('Teste si le "Line Feeds" est requis...');
 Repeat
  AsyncPurgeBuf;
  HostSendStrLn('');
  HostSendStrNEcho('Cette ligne est elle en S U R I M P R E S S I O N ?');
  KeyedIn := False;
  _InitKbd;
  Repeat
   _BackKbd;
   If(KeyPressed)Then
   Begin
    K := ReadKey;
    If(K = kbEsc)Then
    Begin
     ReallyDone := True;
     Exit;
    End
     Else
    Begin
     Ch := Char(K);
     Break;
    End;
   End;
   If Not(HostCarrierDetect)Then Exit;
  Until (AsyncReceive(Ch));
  SCh := Char(Byte(Ch) and $7F);
  If(SCh <> Ch)Then
  Begin
   If(Parity = 'N')Then
   Begin
    Parity := 'E'; DataBits := 7;
   End
    Else
   Begin
    Parity := 'N'; DataBits := 8;
   End;
   AsyncResetPort(CommPort,BaudRate,Parity,DataBits,StopBits);
   Ln;
   PutTxtLn('Communication r‚ajust‚ … parit‚ = '+Parity+' et donn‚ bits = '+Str(DataBits));
   Ln;
  End;
  SCh := UpCase(SCh);
  HostSend(SCh);
  BackService(SCh);
 Until (SCh in ['O','N']);
 If(SCh = 'O')Then CRLFHost := Char(CR) + Char(LF)
	      Else CRLFHost := Char(CR);
 Try := 0;
 Repeat
  Inc(Try);
  GetUserInfo(Found);
 Until((Try > MaxLoginTry)or(Found));
 __Done := __Done or(Not(Found))or(Not(HostCarrierDetect));
 If Not(__Done)Then
 Begin
  HostSection := 'I';
  Repeat
   Case HostSection Of
    'G':  {GossipMode};
    'F':  Repeat
	   ProcessFileTransferCmd(__Done,Back);
	  Until(__Done)or(Back);
    'D':  If(Privilege = 'S')Then
	  Begin
	   If(Not(LocalHost))Then {Jump2Dos}
	    Else
	   Begin
{            DosJump('');}
	    HostSection := LastHostSect;
	   End;
	  End;
     Else Begin
	   K := ProcessHostCmd(__Done);
	   If Not(K = kbNoKey)Then
	   Begin
	    DoHost := K;
	    Exit;
	   End;
	  End;
   End;
   __Done := __Done or(Not(HostCarrierDetect));
  Until(__Done);
 End;
 PutStatus('Attend un appelle');
 WriteLog('Logged off.',False,False);
 PutStatus('Logged off');
 WriteLog('Attend un appelle.',False,False);
END;

Function TermAtlas.Run;
Var K:Word;
Begin
 If(ReallyDone)Then
 Begin
  HostModeFlag := False;
  PutMode('');
 End;
 If(HostModeFlag)Then
 Repeat
  Wait4Ring(_Done);
  If Not(_Done)Then
  Begin
   K := DoHost;
   If Not(K = kbNoKey)Then
   Begin
    Run := K;
    Exit;
   End;
  End;
  DoneHostMode;
 Until ReallyDone
  Else
 Run := Inherited Run;
End;

Destructor TermAtlas.Done;
Begin
 DoneHostMode;
 Inherited Done;
End;

Function EditDialEntry;
Const kbOk = 0; kbCancel = 1;
Var W:Wins; BC:Array[0..3] of Array[0..31] of Char; PChr:PChar;
    P:Byte; K:Word; Ok:Bool; Term:SwitchOption; Key,Str:String;
Begin
 EditDialEntry := False;
 With W do
 Begin
  FillChar(BC,SizeOf(BC),Byte(#0));
  Move(Dial.Name,BC[0],SizeOf(Dial.Name));
  Move(Dial.Phone,BC[1],SizeOf(Dial.Phone));
  Move(Dial.Password,BC[2],SizeOf(Dial.Password));
  Move(Dial.Script,BC[3],SizeOf(Dial.Script));
  For P := 3 downto 0 do DelRightSpc(BC[P]);
  Key2Str(KeyOk + KeyCancel,Key);
  SetBorderSimpleLuxe;
  InitO(50,16);
  PushWn;
  PutWn('Edite Entr‚e Dial',CurrColors.Dialog.Wins);
  Ln;
  PutTxtLn('Nom');
  Ln;
  PutTxtLn('T‚l‚phone');
  Ln;
  PutTxtLn('Mots de passe');
  Ln;
  PutTxtLn('Script');
  SetKr($1F);
  BarSpcHorShade(14,1,MaxXTxts-1); PutTxtXY(14,1,BC[0]);
  BarSpcHorShade(14,3,MaxXTxts-1); PutTxtXY(14,3,BC[1]);
  BarSpcHorShade(14,5,MaxXTxts-1); PutTxtXY(14,5,BC[2]);
  BarSpcHorShade(14,7,MaxXTxts-1); PutTxtXY(14,7,BC[3]);
  SetInpColrs($9F,$9B);
  Case Dial.Term of
   'A' : P := 0;
   'T' : P := 1;
   '5' : P := 2;
   '1' : P := 3;
  End;
  Term.Init(GetRX1+0,GetRY1+9,'Terminal','Ansi|TTY|VT52|VT102',P);
  PutkHorDn(Key);
  SetNorColor($B0);
  P := 0; Ok := False;
  Repeat
   Case P of
    0..3 : Begin
	    PChr := BC[P];
	    K := _Input(14,1+P shl 1,MaxXTxts-1,32,PChr);
	    BarSelHor(9,1+(P shl 1),MaxXTxts-1);
	    Case K of
		kbUp: If(P > 0)Then Dec(P);
       kbTab, kbDown: Inc(P);
	       kbEsc: Ok := True;
	     kbEnter: Begin
		       P := 5;
		       PushKey(kbEnter);
		      End;
	    End;
	   End;
       4 : Begin
	    K := Term.Select;
	    Case K of
	      kbLeft: P := 3;
	       kbTab: P := 5;
	       kbEsc: Ok := True;
	     kbEnter: Begin
		       P := 5;
		       PushKey(kbEnter);
		      End;
	    End;
	   End;
       5 : Begin
	    K := GetkHorDn(Key);
	    Case K of
		 kbOk : Begin
			 FillChar(Dial.Name,SizeOf(Dial.Name),Byte(' '));
			 Move(BC[0],Dial.Name,StrLen(BC[0]));
			 FillChar(Dial.Phone,SizeOf(Dial.Phone),Byte(' '));
			 Move(BC[1],Dial.Phone,StrLen(BC[1]));
			 FillChar(Dial.Password,SizeOf(Dial.Password),Byte(' '));
			 Move(BC[2],Dial.Password,StrLen(BC[2]));
			 FillChar(Dial.Script,SizeOf(Dial.Script),Byte(' '));
			 Move(BC[3],Dial.Script,StrLen(BC[3]));
			 Case Term.GetPos of
			  0: Dial.Term := 'A';
			  1: Dial.Term := 'T';
			  2: Dial.Term := '5';
			  3: Dial.Term := '1';
			 End;
			 Ok := True; EditDialEntry := True;
			End;
	     kbCancel : Ok := True;
		kbTab : P := 0;
	    End;
	   End;
      Else P := 0;
   End;
  Until Ok;
  Done;
 End;
 Term.Done;
End;

Procedure StatDialEntry;
Var W:Wins; Str:String;
Begin
 With W do
 Begin
  InitO(50,7);
  PushWn;
  SetBorderSimpleLuxe;
  PutWn('Statistique Entr‚e Dial',CurrColors.Dialog.Wins);
  Ln;
  Str[0] := Char(SizeOf(Dial.Total));
  Move(Dial.Total,Str[1],SizeOf(Dial.Total));
  PutTxtLn('Total appelle:'+Str);
  Str[0] := Char(SizeOf(Dial.Last));
  Move(Dial.Last,Str[1],SizeOf(Dial.Last));
  PutTxtLn('DerniŠre communication:'+Str);
  GetkHorDn('Correct');
  Done;
 End;
End;

Function WinInpUser(Var User:UserRecord):Bool;
Var W:Wins; P:Byte; K:Word; KChr:Char Absolute K;
    PBuffer:Array[0..63] of Char; PChr:PChar;
{ Description

   Cette fonction permet au Sysop de cr‚e ou modifier les informations
  d'un membre. Si le sysop abandonne l'op‚ration, la fonction retourne
  "False".
}
Begin
 WinInpUser := False;
 W.InitO(70,8);
 W.PushWn;
 If(User.FirstName = '')and(User.LastName = '')Then
  W.PutWn('Entrer le nouveau membre',CurrColors.Dialog.Wins)
 Else
  W.PutWn('Editer un membre',CurrColors.Dialog.Wins);
 W.PutTxtXY(0,1,'Pr‚nom');
 W.PutTxtXY(35,1,'Nom de famille');
 W.PutTxtXY(0,3,'Mot de passe');
 W.PutTxtXY(35,3,'Pr‚vilŠge de super membre ['+Char(32+56*Byte(User.Privilege = 'S'))+']');
 W.SetKr($8F);
 W.BarSpcHorShade(7,1,32);
 W.PutTxtXY(7,1,User.FirstName);
 W.BarSpcHorShade(50,1,W.MaxXTxts-1);
 W.PutTxtXY(50,1,User.LastName);
 W.BarSpcHorShade(13,3,32);
 W.PutTxtXY(13,3,User.PassWord);
 P := 0;
 W.PutkHorDn('Correct|Annule');
 PChr := PBuffer;
 Repeat
  Case P of
   0 : Begin
	StrPCopy(PBuffer,User.FirstName);
	W.SetInpColrs($8F,W.XColrs.Sel);
	K := W._Input(7,1,32,20,PChr);
	W.SetKr($8F);
	W.BarSelHor(7,1,32);
	User.FirstName := StrUp(StrPas(PChr));
	Case K of
	   kbEsc: Break;
	    kbUp: P := 4;
	  kbDown: P := 2;
	   kbTab: P := 1;
	 kbEnter: P := 4;
	End;
       End;
   1 : Begin
	StrPCopy(PBuffer,User.LastName);
	W.SetInpColrs($8F,W.XColrs.Sel);
	K := W._Input(50,1,W.MaxXTxts-1,20,PChr);
	W.SetKr($8F);
	W.BarSelHor(50,1,W.MaxXTxts-1);
	User.LastName := StrUp(StrPas(PChr));
	Case K of
	   kbEsc: Break;
	    kbUp: P := 4;
	  kbDown: P := 3;
	   kbTab: P := 2;
	 kbEnter: P := 4;
	End;
       End;
   2 : Begin
	StrPCopy(PBuffer,User.PassWord);
	W.SetInpColrs($8F,W.XColrs.Sel);
	K := W._Input(13,3,32,10,PChr);
	W.SetKr($8F);
	W.BarSelHor(13,3,32);
	User.PassWord := StrPas(PChr);
	Case K of
	   kbEsc: Break;
	    kbUp: P := 0;
	  kbDown: P := 4;
	   kbTab: P := 3;
	 kbEnter: P := 4;
	End;
       End;
   3 : Begin
	SimpleCursor;
	SetCursorPos(W.GetRX1+62,W.GetRY1+3);
	K := ReadKey;
	CloseCursor;
	Case K of
		 kbEsc: Break;
		kbLeft: P := 2;
		  kbUp: P := 1;
  kbDown,kbRight,kbTab: P := 4;
	       kbEnter: P := 4;
		   Else If(KChr = ' ')Then
			Begin
			 If(User.Privilege = 'S')Then User.Privilege := 'N'
						 Else User.Privilege := 'S';
			 W.SetChr(62,3,Char(32+56*Byte(User.Privilege = 'S')));
			End;
	End;
       End;
   4 : Begin
	K := W.GetkHorDn('Correct|Annule');
	Case K of
    kbEsc,1: Break;
      kbTab: P := 0;
	  0: Begin
	      WinInpUser := True;
	      Break;
	     End;
	End;
       End;
  End;
 Until False;
 W.Done;
End;

Function WinNewUser(Var User:UserRecord):Bool;
Begin
 FillChar(User,SizeOf(User),0);
 WinNewUser := WinInpUser(User);
End;

BEGIN
END.