{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³         Malte Genesis III/Module des BibliothŠque          ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit MLibrary;

INTERFACE

{$D-,L-,Y-,I-,Q-,R-,S-,X+}

Uses Dos, Strings, Video, Mems, Math;

Const

      btNone     = 0;
      btBoolean  = 1;
      btByte     = 2;
      btShortInt = 3;
      btWord     = 4;
      btInteger  = 5;
      btLongWord = 6;
      btLongInt  = 7;
      btReal     = 8;
      btSingle   = 9;
      btDouble   = 10;
      btExtended = 11;
      btComp     = 12;
      btPChar    = 13;
      btDate     = 14;
      btTime     = 15;
      btZipCode  = 16;
      btPhone    = 17;
      btEnum     = 18;
      btPath     = 19;
      btPrice    = 20;
      btColor    = 21;

      __Help__    = 0;
      __Ok__      = 1;
      __Cancel__  = 2;
      __Yes__     = 3;
      __No__      = 4;
      __Retry__   = 5;
      __Abort__   = 6;
      __Ignore__  = 7;
      __Default__ = 8;

      __Center__  = 254;

Type

     BankFiles = Object
      Constructor Init;
      Function SelectPath(Path:PathStr;Attr:Word):Bool;
      Procedure GetFile(P:Word;Var Info:SearchRec);
      Function GetAddr(P:Word):Pointer;
      Function SizeFiles:Long;
      Function MaxFiles:Int;
      Destructor Done;
      PRIVATE
      B:RBuf;
      _Init:Bool;
      _SizeFiles:Long;
     End;

     ProcCmdType = Procedure(K:Word);

Var

    SpcMnu:Byte;

Procedure Beep;
Procedure PutLastBar(X:Byte;Msg:String);

Function GetPrompt:String;
Function IsDigit(Chr:Char):Bool;
Function IsMin(Chr:Char):Bool;
Function IsMaj(Chr:Char):Bool;
Function JoystickPos(Axe:Byte):Word;
Function JoystickPotentioMeter:Word;
Function JoyXPosTexts(Joy:Byte):Byte;
Function JoyYPosTexts(Joy:Byte):Byte;
Function Key2Str(Key:Word;Var Str:String):Byte;
Function KeyCode2Str(Code:Word):String;
Function LengthTyping(Msg:PChar):Word;
Function PLengthTyping(Msg:String):Byte;
Function PSearchHigh(Str:String):String;
Function SearchHigh(Msg:PChar):String;

IMPLEMENTATION

Uses CardVideo,LibVideo,Images, Keyboard, Clock, Sound, TeleMate,
      Printers, Systems, Mouse, Language, Strs, Memorys;

Const

      StrKey : Array[0..8] of PChar =
		('Aide','Correct','Annule','Oui','Non','R‚essayer',
		 'Abandonne','Ignore','Par D‚faut');

Var BiosJoystick:Bool;

Constructor BankFiles.Init;
Begin
 _Init := False;
End;

Function BankFiles.SelectPath;
Var DirInfo:SearchRec; I:Byte; MPath:PathStr; MExt:ExtStr;

 Function AddFile:Bool;
 Var Ptr:Pointer;
 Begin
  AddFile := False; Ptr := B._AddBuf(SizeOf(DirInfo));
  If(Ptr = NIL)Then Exit;
  Move(DirInfo,Ptr^,SizeOf(DirInfo)); AddFile := True;
 End;

Begin
 SelectPath := False;
 If(_Init)Then B.Done Else _Init := True;
 B.Init;
 _SizeFiles := 0;
 If(Pos(';',Path) > 0)Then
 Begin
  For I := 1 to Length(Path) do If(Path[I] = ';')Then Break;
  MPath := Copy(Path,1,I-1);
  FindFirst(Path2Dir(MPath)+'*.*',Directory,DirInfo);
  While (DosError = 0) do
  Begin
   If(DirInfo.Attr = Directory)Then
   Begin
    If Not(DirInfo.Name = '.')Then If Not(AddFile)Then Exit;
   End;
   FindNext(DirInfo);
  End;
  Attr := Attr and Not(Directory);
  FindFirst(MPath,Attr,DirInfo);
  While (DosError = 0) do
  Begin
   If Not(AddFile)Then Exit;
   Inc(_SizeFiles,DirInfo.Size);
   FindNext(DirInfo);
  End;
  Inc(I);
  While (Length(Path) >= I) do
  Begin
   MExt := '';
   While Not(StrI(I,Path) in [#0,';']) do
   Begin
    IncStr(MExt,Path[I]);
    Inc(I);
   End;
   If(MExt = '')Then Exit;
   FindFirst(Path2Dir(MPath)+MExt,Attr,DirInfo);
   While (DosError = 0) do
   Begin
    If Not(AddFile)Then Exit;
    Inc(_SizeFiles,DirInfo.Size);
    FindNext(DirInfo);
   End;
  End;
 End
  Else
 If Not(Path2Ext(Path) = '.*')Then
 Begin
  FindFirst(Path2Dir(Path)+'*.*',Directory,DirInfo);
  While (DosError = 0) do
  Begin
   If(DirInfo.Attr = Directory)Then
   Begin
    If Not(DirInfo.Name = '.')Then AddFile;
   End;
   FindNext(DirInfo);
  End;
  Attr := Attr and Not(Directory);
  FindFirst(Path,Attr,DirInfo);
  While (DosError = 0) do
  Begin
   AddFile;
   Inc(_SizeFiles,DirInfo.Size);
   FindNext(DirInfo);
  End;
 End
  Else
 Begin
  FindFirst(Path,Attr,DirInfo);
  While (DosError = 0) do
  Begin
   If Not((DirInfo.Name = '.')and(DirInfo.Attr = Directory))Then
   Begin
    AddFile;
    Inc(_SizeFiles,DirInfo.Size);
   End;
   FindNext(DirInfo);
  End;
 End;
 SelectPath := True;
End;

Procedure BankFiles.GetFile;
Var Size:Word;
    PInfo:^SearchRec;
Begin
 PInfo := B.GetBuf(P,Size);
 If(PInfo = NIL)Then Exit;
 Move(PInfo^,Info,SizeOf(Info));
End;

Function BankFiles.GetAddr;
Var Size:Word;
Begin
 GetAddr := B.GetBuf(P,Size);
End;

Function BankFiles.MaxFiles;
Begin
 MaxFiles := B.MaxBuf;
End;

Function BankFiles.SizeFiles;
Begin
 SizeFiles := _SizeFiles;
End;

Destructor BankFiles.Done;
Begin
 If(_Init)Then B.Done;
End;

Procedure Beep;
Var X:Long;
Begin
 PCSpeakerSound(1550);
 X := MemL[Seg0040:$6C];
 While ((Long(1) + X) >= MemL[Seg0040:$6C]) do If(MemL[Seg0040:$6C] = 0)Then Break;
 PCSpeakerNoSound;
End;

Function GetPrompt;
Var SP,T:String; I:Byte;

 Function SymbolToStr(Chr:Char):String;
 Const Week : Array[0..6] of String[3] = ('Dim','Lun','Mar','Mer','Jeu','Ven','Sam');
       Mon  : Array[1..12] of String[3] = ('Jan','F‚v','Mar','Avr','Mai','Jui',
					   'Jul','Ao–','Sep','Oct','Nov','D‚c');
 Var T:String; Year,Month,Day,DayOfWeek,Hour,Min,Sec,Sec100:Word;
 Begin
  Case Chr of
       'D' : Begin
	      Dos.GetDate(Year,Month,Day,DayOfWeek);
	      T := Week[DayOfWeek]+'  '+Mon[Month]+' '+Str(Day)+', '+Str(Year);
	     End;
       'T' : Begin
	      Dos.GetTime(Hour,Min,Sec,Sec100);
	      T := Str2(Hour,2) + ':' + Str0(Min,2) + ':' + Str0(Sec,2);
	     End;
       'B' : T := '|';
   'e','E' : T := #27;
   'g','G' : T := '>';
       'N' : T := GetDrive;
   'p','P' : T := GetPath;
   '-','S' : T := ' ';
       'V' : T := Str(Lo(DOSVersion)) + '.' + Str(Hi(DOSVersion));
   '_','Z' : T := #13+#10;
       'z' : T := '?';
	Else T := '';
  End;
  SymbolToStr := T;
 End;

Begin
 SP := GetEnv('PROMPT'); T := '';
 For I := 1 to Length(SP) do
 Begin
  If(SP[I] = '$')Then
  Begin
   Inc(I); AddStr(T,SymbolToStr(SP[I]));
  End
   else
  IncStr(T,SP[I]);
 End;
 GetPrompt := T;
End;

Function IsDigit;
Begin
 IsDigit := (Chr in ['0'..'9']);
End;

Function IsMin;
Begin
 IsMin := (Chr in ['a'..'z']);
End;

Function IsMaj;
Begin
 IsMaj := (Chr in ['A'..'Z']);
End;

Function Key2Str;
Var I,N:Byte;
Begin
 Key2Str := 0; N := 0; Str := '';
 For I := 0 to 8 do
 Begin
  If(((Key shr I) and 1) = 1)Then
  Begin
   Inc(N);
   If(Str = '')Then Str := Strings.StrPas(StrKey[I])
	       else AddStr(Str,'|' + Strings.StrPas(StrKey[I]));
  End;
 End;
 Key2Str := N;
End;

Function KeyCode2Str;
Const StrFunc : Array[0..9] of String[3] =
 ('F1','F2','F3','F4','F5','F6','F7','F8','F9','F10');
Begin
 Case Code of
  kbShiftF1..kbShiftF10 : KeyCode2Str := 'Shift+' + StrFunc[Hi(Code)-Hi(kbShiftF1)];
    kbCtrlF1..kbCtrlF10 : KeyCode2Str := 'Ctrl+' + StrFunc[Hi(Code)-Hi(kbCtrlF1)];
      kbAltF1..kbAltF10 : KeyCode2Str := 'Alt+' + StrFunc[Hi(Code)-Hi(kbAltF1)];
	 kbAlt1..kbAlt9 : KeyCode2Str := 'Alt+' + Char(Byte('1')+(Hi(Code) - Hi(kbAlt1)));
		 kbAlt0 : KeyCode2Str := 'Alt+0';
		  kbEsc : KeyCode2Str := 'Esc';
	 kbAltBackSpace : KeyCode2Str := 'Alt+BackSpace';
	     kbAltSpace : KeyCode2Str := 'Alt+Space';
	      kbCtrlIns : KeyCode2Str := 'Ctrl+Ins';
	     kbShiftIns : KeyCode2Str := 'Shift+Ins';
	      kbCtrlDel : KeyCode2Str := 'Ctrl+Del';
	     kbShiftDel : KeyCode2Str := 'Shift+Del';
		 kbBack : KeyCode2Str := 'BackSpace';
	     kbCtrlBack : KeyCode2Str := 'Ctrl+BackSpace';
	     kbShiftTab : KeyCode2Str := 'Shift+Tab';
		  kbTab : KeyCode2Str := 'Tab';
	    kbCtrlEnter : KeyCode2Str := 'Ctrl+Enter';
		kbEnter : KeyCode2Str := 'Enter';
	    kbF1..kbF10 : KeyCode2Str := StrFunc[Hi(Code)-Hi(kbF1)];
		 kbHome : KeyCode2Str := 'Home';
		   kbUp : KeyCode2Str := 'Up';
		 kbPgUp : KeyCode2Str := 'Page Up';
		 kbLeft : KeyCode2Str := 'Left';
		kbRight : KeyCode2Str := 'Right';
		  kbEnd : KeyCode2Str := 'End';
		 kbDown : KeyCode2Str := 'Down';
		 kbPgDn : KeyCode2Str := 'Page Down';
		  kbIns : KeyCode2Str := 'Insert';
		  kbDel : KeyCode2Str := 'Delete';
	    kbCtrlPrtSc : KeyCode2Str := 'Ctrl+PrintScreen';
	     kbCtrlLeft : KeyCode2Str := 'Ctrl+Left';
	    kbCtrlRight : KeyCode2Str := 'Ctrl+Right';
	      kbCtrlEnd : KeyCode2Str := 'Ctrl+End';
	     kbCtrlPgDn : KeyCode2Str := 'Ctrl+Page Down';
	     kbCtrlHome : KeyCode2Str := 'Ctrl+Home';
	     kbAltEqual : KeyCode2Str := 'Alt+=';
	     kbCtrlPgUp : KeyCode2Str := 'Ctrl+Page Up';
		  kbF11 : KeyCode2Str := 'F11';
		  kbF12 : KeyCode2Str := 'F12';
	     kbShiftF11 : KeyCode2Str := 'Shift+F11';
	     kbShiftF12 : KeyCode2Str := 'Shift+F12';
	      kbCtrlF11 : KeyCode2Str := 'Ctrl+F11';
	      kbCtrlF12 : KeyCode2Str := 'Ctrl+F12';
	       kbAltF11 : KeyCode2Str := 'Alt+F11';
	       kbAltF12 : KeyCode2Str := 'Alt+F12';
	       kbCtrlUp : KeyCode2Str := 'Ctrl+Up';
	     kbCtrlDown : KeyCode2Str := 'Ctrl+Down';
		 kbAltA : KeyCode2Str := 'Alt+A';
		 kbAltB : KeyCode2Str := 'Alt+B';
		 kbAltC : KeyCode2Str := 'Alt+C';
		 kbAltD : KeyCode2Str := 'Alt+D';
		 kbAltE : KeyCode2Str := 'Alt+E';
		 kbAltF : KeyCode2Str := 'Alt+F';
		 kbAltG : KeyCode2Str := 'Alt+G';
		 kbAltH : KeyCode2Str := 'Alt+H';
		 kbAltI : KeyCode2Str := 'Alt+I';
		 kbAltJ : KeyCode2Str := 'Alt+J';
		 kbAltK : KeyCode2Str := 'Alt+K';
		 kbAltL : KeyCode2Str := 'Alt+L';
		 kbAltM : KeyCode2Str := 'Alt+M';
		 kbAltN : KeyCode2Str := 'Alt+N';
		 kbAltO : KeyCode2Str := 'Alt+O';
		 kbAltP : KeyCode2Str := 'Alt+P';
		 kbAltQ : KeyCode2Str := 'Alt+Q';
		 kbAltR : KeyCode2Str := 'Alt+R';
		 kbAltS : KeyCode2Str := 'Alt+S';
		 kbAltT : KeyCode2Str := 'Alt+T';
		 kbAltU : KeyCode2Str := 'Alt+U';
		 kbAltV : KeyCode2Str := 'Alt+V';
		 kbAltW : KeyCode2Str := 'Alt+W';
		 kbAltX : KeyCode2Str := 'Alt+X';
		 kbAltY : KeyCode2Str := 'Alt+Y';
		 kbAltZ : KeyCode2Str := 'Alt+Z';
                kbCtrlA : KeyCode2Str := 'Ctrl+A';
                kbCtrlB : KeyCode2Str := 'Ctrl+B';
                kbCtrlC : KeyCode2Str := 'Ctrl+C';
                kbCtrlD : KeyCode2Str := 'Ctrl+D';
		kbCtrlE : KeyCode2Str := 'Ctrl+E';
		kbCtrlF : KeyCode2Str := 'Ctrl+F';
		kbCtrlG : KeyCode2Str := 'Ctrl+G';
                kbCtrlH : KeyCode2Str := 'Ctrl+H';
		kbCtrlI : KeyCode2Str := 'Ctrl+I';
                kbCtrlJ : KeyCode2Str := 'Ctrl+J';
		kbCtrlK : KeyCode2Str := 'Ctrl+K';
                kbCtrlL : KeyCode2Str := 'Ctrl+L';
                kbCtrlM : KeyCode2Str := 'Ctrl+M';
                kbCtrlN : KeyCode2Str := 'Ctrl+N';
                kbCtrlO : KeyCode2Str := 'Ctrl+O';
		kbCtrlP : KeyCode2Str := 'Ctrl+P';
                kbCtrlQ : KeyCode2Str := 'Ctrl+Q';
                kbCtrlR : KeyCode2Str := 'Ctrl+R';
                kbCtrlS : KeyCode2Str := 'Ctrl+S';
                kbCtrlT : KeyCode2Str := 'Ctrl+T';
                kbCtrlU : KeyCode2Str := 'Ctrl+U';
                kbCtrlV : KeyCode2Str := 'Ctrl+V';
		kbCtrlW : KeyCode2Str := 'Ctrl+W';
		kbCtrlX : KeyCode2Str := 'Ctrl+X';
		kbCtrlY : KeyCode2Str := 'Ctrl+Y';
		kbCtrlZ : KeyCode2Str := 'Ctrl+Z';
		     Else KeyCode2Str := Str(Code);
 End;
End;

Function LengthTyping;
Var I,P:Word;
Begin
 I := 0; P := 0;
 While Not(Msg[I] = #0) do
 Begin
  If Not(Msg[I] in [#1..#31,'|','^','~'])Then Inc(P);
  Inc(I);
  If(I > 4096)Then Break;
 End;
 LengthTyping := P;
End;

Function JoystickPos;
Assembler;
ASM
 CMP BiosJoystick,Byte(True);
 MOV AH,$84;
 MOV DX,$1;
 INT $15;
 CMP Axe,0;
 JE  @@End;
 MOV BX,AX;
 CMP Axe,1;
 MOV CX,AX;
 CMP Axe,2;
 JE  @@End;
 MOV DX,AX;
 CMP Axe,3;
 JE  @@End;
 JMP @@End;
@@BIOSJoystick:
 MOV CL,Axe;
 MOV BX,1;
 SHL BX,CL;
 MOV CX,$FFFF;
 XOR AX,AX;
 XOR SI,SI;
 MOV DX,$0201;
 CLI;
 OUT DX,AL;
@@Next:
 IN   AL,DX;
 TEST AL,BL;
 JE   @@Done;
 INC  SI;
 LOOP @@Next;
@@Done:
 STI;
 MOV AX,SI;
@@End:
END;

Function JoystickPotentioMeter;
Begin
 If(BiosJoystick)Then JoystickPotentioMeter := 416
		 Else JoystickPotentioMeter := 270;
End;

Function JoyXPosTexts;
Begin
 JoyXPosTexts := Trunc((JoystickPos(Joy*2)/JoystickPotentioMeter)*GetNumXTexts);
End;

Function JoyYPosTexts;
Begin
 JoyYPosTexts := Trunc((JoystickPos((Joy*2)+1)/JoystickPotentioMeter)*GetNumYTexts);
End;

Function PLengthTyping;
Var I,P:Byte;
Begin
 P := 0;
 For I := 1 to Length(Msg) do If Not(Msg[I] in [#0..#31,'|','^','~'])Then Inc(P);
 PLengthTyping := P;
End;

Function PSearchHigh;
Var I,L:Byte;
Begin
 PSearchHigh := ''; L := 0;
 For I := 1 to Length(Str) do If(Str[I] = '^')Then Inc(L);
 If(L >= 2)Then
 Begin
  I := 1;
  While(Str[I] <> '^') do Inc(I);
  Inc(I); L := 0;
  While(Str[I+L] <> '^') do Inc(L);
  PSearchHigh := Copy(Str,I,L);
 End;
End;

Procedure PutLastBar;
Begin
 If(X > 0)Then Video.BarSpaceHori(0,MaxYTxts,X-1,GetNorColor);
 Video.PutTypingXY(X,MaxYTxts,Msg);
 Video.BarSpaceHori(VideoBankSwitch.XP,MaxYTxts,MaxXTxts,GetNorColor);
End;

Function SearchHigh;
Var I,L:Byte;
Begin
 SearchHigh := '';
 If(Msg = NIL)or(Msg[0] = #0)Then Exit;
 L := 0; I := 0;
 While Not(Msg[I] = #0) do
 Begin
  If(Msg[I] = '^')Then Inc(L);
  Inc(I);
 End;
 If(L >= 2)Then
 Begin
  I := 0;
  While Not(Msg[I] in [#0,'^']) do Inc(I);
  Inc(I); L := 0;
  While Not(Msg[I+L] in [#0,'^']) do Inc(L);
  SearchHigh := Copy(StrPas(Msg),I+1,L);
 End;
End;

BEGIN
 BiosJoystick := (Mem[$FFFF:$E] = $FC);
 SpcMnu := 2;
END.