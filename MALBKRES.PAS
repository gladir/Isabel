Unit MALBKRES;

INTERFACE

Var
    CurrModem : BYTE;
    SwapEms : BOOLEAN;
    NamePrimMonitor : PCHAR;
    NamePrimCard : PCHAR;
    CheckSvga : BOOLEAN;
    P2P : BOOLEAN;
    PrnMarge : BOOLEAN;
    ModeTypeWriter : BOOLEAN;
    NameLPT4 : PCHAR;
    NameLPT3 : PCHAR;
    NameLPT2 : PCHAR;
    NameLPT1 : PCHAR;
    CurrPrn : PCHAR;
    PathOutput : PCHAR;
    PathUnit : PCHAR;
    PathObject : PCHAR;
    PathMac : PCHAR;
    PathAsmC : PCHAR;
    PathCalc : PCHAR;
    PathPCX : PCHAR;
    PathDraw : PCHAR;
    PathCatDisk : PCHAR;
    PathUpload : PCHAR;
    PathDownload : PCHAR;
    PathPhoneList : PCHAR;
    PathBBS : PCHAR;
    PathMod : PCHAR;
    PathVic20 : PCHAR;
    PathCommodore64 : PCHAR;
    PathCoco3 : PCHAR;
    PathTRS80 : PCHAR;
    PathAtari2600 : PCHAR;
    PathAppleMac : PCHAR;
    PathAppleII : PCHAR;
    PathAmiga : PCHAR;
    PathAdams : PCHAR;
    PathWin : PCHAR;
    PathOS2 : PCHAR;
    PathUnix : PCHAR;
    PathCountry : PCHAR;
    ExtFor : PCHAR;

Procedure ReadIniFile;

IMPLEMENTATION

Uses Math, Strings, Strs, Keyboard, Video, Systems, Language, MLibrary, Windows, Dials, Terminal, TeleMate, Editor;

Procedure ReadIniFile;
Const MsgChoice = 'Presse une touche pour continuer sans le fichier MALBOOK.INI ou <ESC> pour quitter.';
Var Handle:Word; Str,Ext,Header:String; PChr:Array[0..255] of Char;
    FS,S:Long; Category:Byte;

 Function ExtractAfterEqual(Str:String):String;
 Var P:Byte;
 Begin
  P := Pos('=',Str);
  If(P = 0)Then ExtractAfterEqual := ''
            Else ExtractAfterEqual := Copy(Str,P+1,255);
 End;

 Function IsTrue(Str:String):Bool;
 Begin
  IsTrue := (Str = 'YES')or(Str = 'TRUE')or(Str = 'ON');
 End;

 Function IsFalse(Str:String):Bool;
 Begin
  IsFalse := (Str = 'NO')or(Str = 'FALSE')or(Str = 'OFF');
 End;

Begin
 Category := 0;
 FS       := 0;
 Handle := Open('MALBOOK.INI',ReadOnly);
 If(IsHandleErr(Handle))Then Exit;
 S := FileSize(Handle);
 SetFilePos(Handle,0);
 Str := GetFileTextLn(Handle);
 While (FS < S) do
 Begin
  Inc(FS,Length(Str)+2);
  Str := DelChr(StrUp(Str),' ');
  If Not((Str = '')or(Str[1] = '/'))Then
  Begin
   If(Str[1] = '[')Then
   Begin
    If Not(Str[Length(Str)] = ']')Then
    Begin
     WriteLn('Erreur MALBOOK.INI: '']'' attendue.');
     WriteLn(MsgChoice);
     If(ReadKey = kbEsc)Then Halt;
     Exit;
    End;
    Header := Copy(Str,2,Length(Str)-2);
    If(Header = 'DISK')Then Category := 1 Else
    If(Header = 'PRINTERS')Then Category := 2 Else
    If(Header = 'VIDEO')Then Category := 3 Else
    If(Header = 'SYSTEMS')Then Category := 4 Else
    If(Header = 'MODEM')Then Category := 5
     Else
    Break;
   End
    Else
   Case Category of
    1 : Begin
         If(CmpLeft(Str,'ASMFILES'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ExtAsm := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'ASMCFILES'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ExtAC := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'BASFILES'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ExtBas := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'CFILES'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ExtC := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'EUPHFILES'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ExtEuphoria := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'FORFILES'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ExtFor := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'INIFILES'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ExtIni := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'MOUSEMENUFILES'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ExtMsMnu := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'PASFILES'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ExtPas := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'RESOURCEFILES'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ExtRC := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRSYSTEMS'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathSystems := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRCOUNTRY'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathCountry := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRUNIX'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathUnix := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIROS2'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathOS2 := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRWINDOWS'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathWin := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRAPPLEII'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathAppleII := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRAPPLEMAC'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathAppleMac := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRCOCO3'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathCoco3 := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRCOMMODORE64'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathCommodore64 := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRMUSICMOD'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathMod := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRBBS'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathBBS := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRPHONELIST'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathPhoneList := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRPHONEDOWNLOAD'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathDownload := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRPHONEUPLOAD'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathUpload := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRCATALOGDISK'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathCatDisk := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRDRAW'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathDraw := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRPCX'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathPCX := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRSUPERCALC'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathCalc := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRGATT'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathGatt := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRMACRO'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathMac := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRSOURCEADA'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathAda := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRSOURCEASM'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathAsm := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRSOURCEASMC'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathAsmC := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRSOURCEBAS'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathBas := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRSOURCEC'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathC := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRSOURCECOBOL'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathCobol := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRSOURCEEUPHORIA'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathEuphoria := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRSOURCEFORTH'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathForth := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRSOURCEFORTRAN'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathFortran := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRSOURCEPAS'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathPas := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRRESOURCE'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathResource := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIROBJECT'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathObject := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIRUNIT'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathUnit := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'DIROUTPUT'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           PathOutput := StrNew(PChr);
          End;
         End;
        End;
    2 : Begin
         If(CmpLeft(Str,'CURRPRINTER'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           CurrPrn := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'NAMELPT1'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           NameLPT1 := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'NAMELPT2'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           NameLPT2 := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'NAMELPT3'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           NameLPT3 := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'NAMELPT4'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           NameLPT4 := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'MODETYPEWRITER'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If IsTrue(Ext)Then ModeTypeWriter := True Else
          If IsFalse(Ext)Then ModeTypeWriter := False
                         Else Break;
         End;
         If(CmpLeft(Str,'PRNMARGEAUTORISED'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If IsTrue(Ext)Then PrnMarge := True Else
          If IsFalse(Ext)Then PrnMarge := False
                         Else Break;
         End;
         If(CmpLeft(Str,'PAPER2PAPER'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If IsTrue(Ext)Then P2P := True Else
          If IsFalse(Ext)Then P2P := False
                         Else Break;
         End;
        End;
    3 : Begin
         If(CmpLeft(Str,'CHECKSVGA'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If IsTrue(Ext)Then CheckSvga := True Else
          If IsFalse(Ext)Then CheckSvga := False
                         Else Break;
         End;
         If(CmpLeft(Str,'NAMEPRIMCARD'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           NamePrimCard := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'NAMEPRIMONITOR'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           NamePrimMonitor := StrNew(PChr);
          End;
         End;
        End;
    4 : Begin
         If(CmpLeft(Str,'SWAPEMS'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If IsTrue(Ext)Then SwapEms := True Else
          If IsFalse(Ext)Then SwapEms := False
                         Else Break;
         End;
        End;
    5 : Begin
         If(CmpLeft(Str,'CURRMODEM'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          CurrModem:=ValW(Ext);
         End;
         If(CmpLeft(Str,'MODEMCMDDELAY'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          ModemCommandDelay:=ValW(Ext);
         End;
         If(CmpLeft(Str,'BUSY'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ModemBusy := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'CONNECT'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ModemConnect := StrNew(PChr);
          End;
         End;
         If(CmpLeft(Str,'NOCARRIER'))Then
         Begin
          Ext := ExtractAfterEqual(Str);
          If(Ext[1] = '"')And(Ext[Length(Ext)] = '"')Then
          Begin
           StrPCopy(PChr,Copy(Ext,2,Length(Ext)-2));
           ModemNoCarrier := StrNew(PChr);
          End;
         End;
        End;
   End;
  End;
  SetFilePos(Handle,FS);
  Str := GetFileTextLn(Handle);
 End;
 Close(Handle);
End;

BEGIN
END.