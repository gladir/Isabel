(*********************************************************)
(*                                                       *)
(*             Malte Genesis/Tools Terminal              *)
(*    Phoenix Edition for Real Mode & Protected Mode     *)
(*                   II - Version 1.8                    *)
(*                      1994/12/29                       *)
(*                                                       *)
(*       Copyright (C) par les Chevaliers de Malte       *)
(*                                                       *)
(*********************************************************)

Unit ToolTerm;

INTERFACE

Uses MM,Dos,Math,Windows,Terminal;

Type

      MDos = Object(Ansi)
       Constructor Init(X1,Y1,X2,Y2:Byte);
       Function Run:Word;
       Destructor Done;
       PRIVATE
       Param,Ext:String;
       Echo:Bool;
       Procedure PutComspec;
       Procedure PutCurrentDisk;
       Procedure PutCurrentPath;
       Procedure PutDir;
       Procedure PutEcho;
       Procedure PutFree;
       Function PutLine(Str:String):Bool;
       Procedure PutPath;
       Procedure PutMemory;
       Procedure PutSet;
       Function PutStr(Str:String):Bool;
       Procedure PutVer;
       Procedure PutVol;
       Procedure RunChDir;
       Procedure RunCopy;
       Procedure RunDel;
       Procedure RunMkDir;
       Procedure RunRMDir;
       Procedure RunSetPrn;
       Procedure RunPrnFiles;
       Procedure RunType;
       Function Extract(CmpMsg:String):Bool;
       Function ExtractExt(P:Byte;Var Bar:Bool):String;
       Function MaxExtractExt:Byte;
       Function GetPath:PathStr;
       Function GetVer:String;
      End;

     MUnix = Object(Ansi)
      Constructor Init(X1,Y1,X2,Y2:Byte);
      Function Run:Word;
      Procedure Refresh;
      Destructor Done;
      PRIVATE
      Param,Ext,PS1,PS2,PathVar:String;
      Echo:Bool;
      Procedure RunBanner;
      Procedure RunCP;
      Function Extract(CmpMsg:String):Bool;
      Function ExtractExt(P:Byte;Var Bar:Bool):String;
      Function MaxExtractExt:Byte;
      Function PutStr(Str:String):Bool;
      Function PutLine(Str:String):Bool;
     End;

     TermPrn = Object(Ansi)
      Constructor Init(X1,Y1,X2,Y2:Byte);
      Function Run:Word;
      Procedure Refresh;
      Destructor Done;
      PRIVATE
      Param,Ext:String;
      Echo:Bool;
      Function Extract(CmpMsg:String):Bool;
      Function ExtractExt(P:Byte;Var Bar:Bool):String;
      Function MaxExtractExt:Byte;
      Procedure PutEcho;
      Function PutStr(Str:String):Bool;
      Function PutLine(Str:String):Bool;
      Procedure RunSetPrn;
      Procedure RunPrnFiles;
     End;

IMPLEMENTATION

Uses Strs,Country,MLibrary,Dials,Systems,Language,Memorys,Clock,
     Keyboard,Strings,Printers;

Function ExtractExt(Ext:String;P:Byte;Var Bar:Bool):String;
Var I,N,E : Byte; Str,_Ex : String;
Begin
 ExtractExt := '';
 If(Ext = '')Then
 Begin
  Bar := False;
  Exit;
 End;
 N := 1; I := 2; _Ex := DelAllSpcLeft(Ext);
 If(_Ex = '')Then Exit;
 If((Length(_Ex) = 1)and(P = 1))Then
 Begin
  ExtractExt := _Ex;
  Exit;
 End;
 Bar := False;
 While ((Not(_Ex[I] in ['/','_','-',' ']))and(I < Length(_Ex))) do Inc(I);
 If(P = N)Then
 Begin
  Str := DelAllSpcRight(DelAllSpcLeft(Copy(_Ex,1,I)));
  If(Length(Str) > 0)Then
  Begin
   If(Str[1] in ['/','-','_'])Then
   Begin
    Bar := True;
    If(Length(Str) = 1)Then Str := ''
                       Else Str := Copy(Str,2,Length(Str)-1);
   End;
  End;
  ExtractExt := Str;
  Exit;
 End
  Else
 Inc(N);
 While (I < Byte(_Ex[0])) do
 Begin
  Bar := (_Ex[I] in ['/','-','_']);
  If(_Ex[I] = ' ')or(Bar)Then
  Begin
   If(_Ex[I+1] in ['/','-','_'])Then
   Begin
    Bar := True; _Ex := DeleteStr(_Ex,I+1,1);
   End;
   Inc(I); E := I;
   While (Not(_Ex[E] in [' ','/','-','_'])and(Length(_Ex) > E)) do Inc(E);
   If(N = P)Then
   Begin
    ExtractExt := DelAllSpcRight(Copy(_Ex,I,E-I+1));
    Exit;
   End
    Else
   Inc(N);
   I := E;
  End;
  Inc(I);
 End;
End;

Function MaxExtractExt(Ext:String):Byte;
Var I,N,E : Byte; _Ex:String;
Begin
 _Ex := Ext;
 If(_Ex = '')Then
 Begin
  MaxExtractExt := 0;
  Exit;
 End;
 N := 0; I := 2;
 While ((Not(_Ex[I] in ['/','_','-',' ']))and(I < Length(_Ex))) do Inc(I);
 Inc(N);
 While (I < Byte(_Ex[0])) do
 Begin
  If(_Ex[I] in [' ','/','-','_'])Then
  Begin
   If(_Ex[I+1] in ['/','-','_'])Then _Ex := DeleteStr(_Ex,I+1,1);
   Inc(I); E := I;
   While (Not(_Ex[E] in [' ','/','-','_'])and(Length(_Ex) > E)) do Inc(E);
   I := E; Inc(N);
  End;
  Inc(I);
 End;
 MaxExtractExt := N;
End;

Function RunSetPrn(Param:String):String;
Var I,M:Byte; Output,TStr:String; Bar:Bool;
Begin
 Output := ''; Param := DelAllSpcLeft(Param);
 M := MaxExtractExt(Param);
 If(M > 0)Then
 Begin
  For I := 1 to M do
  Begin
   TStr := StrUp(ExtractExt(Param,I,Bar));
   If(Bar)Then
   Begin
    If(TStr = '88LNS')or(TStr = '88LINES')or(TStr = 'ESC0')Then
    Begin
     If(__SetPrnInterLn1_8)Then
      AddStr(Output,'Imprimante ajust‚ pour des pages standard de 88 lignes.'+#13+#10)
     Else
     Begin
      AddStr(Output,'Erreur : L''imprimante n''est pas prˆte!'+#13+#10);
      Break;
     End;
    End
     Else
    If(TStr = 'BOLD')Then
    Begin
     If(__SetPrnBold)Then
      AddStr(Output,'Activation de l''impression en caractŠre gras.'+#13+#10)
     Else
     Begin
      AddStr(Output,'Erreur : L''imprimante n''est pas prˆte!'+#13+#10);
      Break;
     End;
    End
     Else
    If(TStr = 'DBL')or(TStr = 'DOUBLE')Then
    Begin
     If(__SetPrnDbl)Then
      AddStr(Output,'Activation de l''impression … chassis ‚largie.'+#13+#10)
     Else
     Begin
      AddStr(Output,'Erreur : L''imprimante n''est pas prˆte!'+#13+#10);
      Break;
     End;
    End
     Else
    If(TStr = 'ITALIC')Then
    Begin
     If(__SetPrnItalic)Then
      AddStr(Output,'Activation de l''italique.'+#13+#10)
     Else
     Begin
      AddStr(Output,'Erreur : L''imprimante n''est pas prˆte!'+#13+#10);
      Break;
     End;
    End
     Else
    If(TStr = 'UNBOLD')Then
    Begin
     If(__SetPrnUnBold)Then
      AddStr(Output,'D‚sactivation de l''impression en caractŠre gras.'+#13+#10)
     Else
     Begin
      AddStr(Output,'Erreur : L''imprimante n''est pas prˆte!'+#13+#10);
      Break;
     End;
    End
     Else
    If(TStr = 'UNDBL')or(TStr = 'UNDOUBLE')or(TStr = 'SIMPLE')Then
    Begin
     If(__SetPrnSimple)Then
      AddStr(Output,'D‚sactivation de l''impression … chassis ‚largie.'+#13+#10)
     Else
     Begin
      AddStr(Output,'Erreur : L''imprimante n''est pas prˆte!'+#13+#10);
      Break;
     End;
    End
     Else
    If(TStr = 'UNITALIC')Then
    Begin
     If(__SetPrnUnItalic)Then
      AddStr(Output,'D‚sactivation de l''italique.'+#13+#10)
     Else
     Begin
      AddStr(Output,'Erreur : L''imprimante n''est pas prˆte!'+#13+#10);
      Break;
     End;
    End
     Else
    Begin
     AddStr(Output,'Erreur : ParamŠtre inconnue.'+#13+#10);
     Break;
    End;
   End;
  End;
 End
  Else
 Begin
  AddStr(Output,'Erreur: ParamŠtre requis pour ajuster l''imprimante courante!' + #13+#10+
               #13+#10+
               'SETPRN  [/88LINES][/BOLD][/DOUBLE][/ITALIC]'+#13+#10+
               #9+'[/SIMPLE][/UNDOUBLE][/UNITALIC]'+#13+#10);
 End;
 RunSetPrn := Output;
End;

Constructor MDos.Init;
Begin
 Wins.Init(X1,Y1,X2,Y2);
 Wins.PushWn;
 Wins.PutWn('Malte-DOS',CurrColors.MalteDos.Wins);
 Echo := True;
 PauseLn := False;
End;

Procedure MDos.PutComspec;
Begin
 PutLine('Sp‚cification de commande : ' + GetEnv('COMSPEC'));
End;

Procedure MDos.PutEcho;
Var Str : String;
Begin
 If(MaxExtractExt = 0)Then
 Begin
  PutStr('L''‚cho est ');
  If(Echo)Then PutLine('ouvert')
          Else PutLine('fermer');
 End
  else
 Begin
  Str := StrUp(Ext);
  If(Str = 'ON')Then Echo := True Else
  If(Str = 'OFF')Then Echo := False Else
  If Not(Ext = '.')Then PutLine(Ext);
 End;
End;

Procedure MDos.PutFree;
Begin
 PutLine('');
 PutLine('Le volume de l''unit‚ ' + GetDrive + ' est ' + GetDiskLabel(GetDisk+1));
 PutLine('');
 PutLine(Str2(DiskSize(GetDisk+1),10)+' octet(s) en tous');
 PutLine(Str2(DiskFree(GetDisk+1),10)+' octet(s) de libre');
End;

Procedure MDos.PutMemory;
Begin
 PutLine('Status m‚moire');
 PutLine('');
 If(EmmExist)Then
 Begin
  PutLine(Str2(Long(EmmNumPage)*16384,8) + ' octet(s) en tous dans l''EMS');
  If(VSwpInit)and(VSwp[__EMS].Exist)Then
  Begin
   PutLine(Str2(VSwp[__EMS].GetSize,8) + ' octet(s) d''EMS pour l''Application en tous');
   PutLine(Str2(VSwp[__EMS].GetFree,8) + ' octet(s) d''EMS pour l''Application de libre');
  End;
  PutLine(Str2(Long(EmmFreePage)*16384,8) + ' octet(s) de libre de EMS');
  PutLine('');
 End;
 PutLine(Str2(Long(QueryFreeMemXMS)*1024,8) + ' octet(s) de libre de XMS');
 PutLine(Str2(Long(MemW[_0040:$13])*1024,8) + ' octet(s) en tous dans la m‚moire conventionnel');
 PutLine(Str2(MemAvail,8)+' octet(s) de libre en m‚moire conventionnel');
 PutLine(Str2(MaxAvail,8)+' octet(s) de m‚moire continue pour le Dos');
End;

Procedure MDos.PutCurrentDisk;
Begin
 PutLine('Le disque courant est '+ GetDrive);
End;

Procedure MDos.PutCurrentPath;
Begin
 PutLine(GetPath);
End;

Procedure MDos.PutDir;
Var Descr       : SearchRec;
    TStr,DirCMD : String;
    Pause,Bar   : Bool;
    Line,Max,I  : Byte;
    K           : Word;
    Size,NumFiles:Long;
    Path        : PathStr;
Begin
 NumFiles := 0; Path := FileExpand('*.*'); Max := MaxYTxts;
 DirCMD := GetEnv('DIRCMD'); Pause := (Pos('/P',DirCMD) > 0);
 If(MaxExtractExt > 0)Then
 Begin
  For I := 1 to MaxExtractExt do
  Begin
   TStr := StrUp(ExtractExt(I,Bar));
   If(Bar)Then
   Begin
    If(TStr = 'P')or(TStr = 'PAUSE')Then Pause := True else
    If(TStr = 'NP')Then Pause := False
     Else
    Begin
     PutLine('Je ne connais pas le paramŠtre '+TStr);
     Exit;
    End;
   End
    Else
   Path := FileExpand(SelectAllIfNoExt(TStr));
  End;
 End;
 Line := 5; Size := 0;
 PutLine('');
 If(Pause)Then SetPause(True);
 PutLine('Le volume de l''unit‚ '+Path[1]+' est ' + GetDiskLabel(Byte(Path[1])-64));
 PutLine('R‚pertoire ' + Path);
 PutLine('');
 FindFirst(Path,$FFFF-VolumeID,Descr);
 While (DOSError = 0) do
 Begin
  Inc(NumFiles);
  If((Descr.Attr and Directory) = Directory)Then
   Descr.Name := StrUSpc(Descr.Name,12)
  Else
   Descr.Name := StrUSpc(SetFullName(Descr.Name),12);
  PutStr(Descr.Name);
  If((Descr.Attr and Directory) = Directory)Then
  Begin
   If(Descr.Name[1] = '.')Then PutStr('<R‚p-pare>')
			  Else PutStr('<Sous-R‚p>');
  End
   Else
  Begin
   PutStr(Str2(Descr.Size,10));
   Inc(Size,Descr.Size);
  End;
  If(PutLine(' '+CStrTime(Descr.Time)+' '+CStrDate(Descr.Time)))Then Break;
  FindNext(Descr);
 End;
 PutLine(' Les '+Str(NumFiles)+' fichier(s) utilisent '+Str(Size)+' octet(s)');
 PutLine(Str2(DiskFree(GetDisk+1),10)+' octet(s) de libre');
 SetPause(False);
End;

Function MDos.PutLine;
Begin
 PutLine := PutStr(Str+#13+#10);
End;

Procedure MDos.PutPath;
Begin
 PutLine(MDos.GetPath);
End;

Procedure MDos.PutSet;
Var I : Word;
Begin
 For I := 1 to EnvCount do PutLine(EnvStr(I));
End;

Function MDos.PutStr;
Var PChr : Array[0..255] of Char;
Begin
 StrPCopy(PChr,Str);
 PutStr := Ansi.Put(PChr);
End;

Procedure MDos.PutVer;
Begin
 PutLine(GetVer);
End;

Procedure MDos.PutVol;
Begin
 PutLine(GetDiskLabel(GetDisk));
End;

Function MDos.GetPath;
Var Path : PathStr;
Begin
 Path := GetEnv('PATH');
 If(Path = '')Then
 Path := 'Pas de PATH!';
 GetPath := Path;
End;

Function MDos.GetVer;
Begin
 GetVer := 'MS-DOS Version '+Str(Lo(DOSVersion))+'.'+
            Str(Hi(DOSVersion))+', Malte-DOS Version 3.01';
End;

Function MDos.Extract;
Var RtnValue : Bool;
Begin
 RtnValue := CmpLeft(Param,CmpMsg);
 If(Length(Param) > Length(CmpMsg))and
   ((Param[Length(CmpMsg)+1] in ['A'..'Z','a'..'z']))Then RtnValue := False;
 If(RtnValue)Then
 Begin
  If(Length(CmpMsg) = Length(Param))Then Ext := ''
   Else
  Ext := DelAllSpcLeft(Copy(Param,Length(CmpMsg)+1,255));
 End;
 Extract := RtnValue;
End;

Function MDos.ExtractExt;
Begin
 ExtractExt := ToolTerm.ExtractExt(Ext,P,Bar);
End;

Function MDos.MaxExtractExt;
Begin
 MaxExtractExt := ToolTerm.MaxExtractExt(Ext);
End;

Procedure MDos.RunChDir;
Var M : Byte;
Begin
 M := MaxExtractExt;
 If(M > 0)Then
 Begin
  If(M > 1)Then
  Begin
   PutLine('Erreur : Trop de paramŠtre!');
   PutLine('');
   PutLine('CHDIR|CD [r‚pertoire]');
  End
   Else
  System.ChDir(Ext);
 End
  Else
 PutCurrentPath;
End;

Procedure MDOS.RunMkDir;
Var M : Byte;
Begin
 M := MaxExtractExt;
 If(M > 0)Then
 Begin
  If(M > 1)Then
  Begin
   PutLine('Erreur : Trop de paramŠtre!');
   PutLine('');
   PutLine('MD|MKDIR r‚pertoire');
  End
   Else
  System.MkDir(Ext);
 End
  Else
 Begin
  PutLine('Erreur : ParamŠtre requis pour cr‚er le r‚pertoire.');
  PutLine('');
  PutLine('MD|MKDIR r‚pertoire');
 End;
End;

Procedure MDOS.RunRMDir;
Var M : Byte;
Begin
 M := MaxExtractExt;
 If(M > 0)Then
 Begin
  If(M > 1)Then
  Begin
   PutLine('Erreur : Trop de paramŠtre.');
   PutLine('RD|RMDIR r‚pertoire');
   PutLine('');
  End
   Else
  System.RMDir(Ext);
 End
  Else
 Begin
  PutLine('Erreur : ParamŠtre requis pour d‚truire le r‚pertoire!');
  PutLine('');
  PutLine('RD|RMDIR r‚pertoire');
 End;
End;

Procedure MDOS.RunCopy;
Var Source,Target:PathStr; I,NP:Byte; Bar:Bool; TStr:String; K:Word;

 Procedure CommandCopy(Source,Target:PathStr);
 Var Rec:SearchRec; TSource,TTarget:PathStr;
 Begin
  If(IsWildCard(Source))Then
  Begin
   FindFirst(Source,$FFFF-VolumeID-Directory,Rec);
   While (DOSError = 0) do
   Begin
    TSource := Path2Dir(Source)+Rec.Name;
    TTarget := Src2Target(TSource,Target);
    PutLine(TSource + ' -> ' + TTarget);
    CopyFile(TSource,TTarget);
    FindNext(Rec);
   End;
  End
   Else
  Begin
   If(IsWildCard(Target))Then Target := Src2Target(Rec.Name,Target);
   PutLine(Source + ' -> ' + Target);
   CopyFile(Source,Target);
  End;
 End;

Begin
 If(MaxExtractExt > 0)Then
 Begin
  NP := 0;
  For I := 1 to MaxExtractExt do
  Begin
   TStr := ExtractExt(I,Bar);
   If(Bar)Then
   Begin
    PutLine('Attention : Je ne connais pas le paramŠtre '+TStr+'.');
    PutLine('');
    PutLine('Continue quand mˆme (O/N) ?');
    K := ReadKey;
    If(K = kbEsc)or(ChrUp(Char(Lo(K))) = 'N')Then Exit;
   End
    Else
   Begin
    Case NP of
      0 : Source := TStr;
      1 : Target := TStr;
     Else Begin
           PutLine('Erreur : Trop de r‚pertoire sp‚cifi‚!');
           Exit;
          End;
    End;
    Inc(NP);
   End;
  End;
  CommandCopy(Source,Target);
 End
  Else
 Begin
  PutLine('Erreur : ParamŠtre requis pour commencer le copiage!');
  PutLine('');
  PutLine('COPY Source [Destination]');
 End;
End;

Procedure MDOS.RunDel;
Var I    : Byte;
    Bar  : Bool;
    TStr : String;

 Procedure CommandDel(Path:PathStr);
 Var Rec : SearchRec; TPath : PathStr;
 Begin
  Path := SelectAllIfNoExt(Path);
  If(IsWildCard(Path))Then
  Begin
   FindFirst(Path,$FFFF-VolumeID-Directory,Rec);
   While (DosError = 0) do
   Begin
    TPath := Path2Dir(Path)+Rec.Name;
    PutLine('Efface '+TPath);
    Systems.Del(TPath);
    FindNext(Rec);
   End;
  End
   Else
  Begin
   PutLine('Efface '+Path);
   Systems.Del(Path);
  End;
 End;

Begin
 If(MaxExtractExt > 0)Then For I := 1 to MaxExtractExt do
 Begin
  TStr := ExtractExt(I,Bar);
  If Not(Bar)Then CommandDel(TStr)
             Else PutLine('Erreur : ParamŠtre invalide!');
 End
  Else
 Begin
  PutLine('Erreur : ParamŠtre requis pour effacer les fichiers!');
  PutLine('');
  PutLine('DEL|ERASE fichier(s) [fichier(s)] [...]');
 End;
End;

Procedure MDOS.RunPrnFiles;
Var I    : Byte;
    Bar  : Bool;
    TStr : String;

 Procedure CmdPrnFile(Path:PathStr);
 Var Rec : SearchRec; TPath : PathStr;

  Procedure PrnFile;
  Var Handle,J,K : Word; Buffer : Array[0..511] of Char; I,Size : Long;
  Begin
   TPath := FileExpand(TPath);
   PutLine('Imprime le fichier ASCII: '+TPath);
   Handle := Systems.Open(TPath,Systems.ReadOnly);
   If(Systems.IsHandleErr(Handle))Then PutLine('Erreur : Fichier introuvable!')
    Else
   Begin
    Size := Systems.FileSize(Handle);
    If(Size > 0)Then
    Begin
     For I := 0 to (Size div SizeOf(Buffer))-1 do
     Begin
      Wins.PutTxtXY(0,RY,Str(I*SizeOf(Buffer))+'/'+Str(Size)+' octets');
      Systems.GetRec(Handle,I,SizeOf(Buffer),Buffer);
      If(FileError > 0)Then PutLine(StrPas(GetDosErrMsg(FileError)));
      For J := 0 to SizeOf(Buffer)-1 do Printers.PrintChr(Buffer[J],PrnOutput);
      If(Keypressed)Then
      Begin
       ClrKbd;
       PutLine('');
       Wins.PutTxtXY(0,RY,'Dois-je annuler l''op‚ration (O/N) ?');
       K := ReadKey;
       If(Char(K) in ['o','O'])Then
       Begin
        Systems.Close(Handle);
        Exit;
       End;
      End;
     End;
     If((Size mod SizeOf(Buffer)) > 0)Then
     Begin
      Systems.SetFilePos(Handle,(Size div SizeOf(Buffer)) * SizeOf(Buffer));
      Systems._GetRec(Handle,Size mod SizeOf(Buffer),Buffer);
      For J := 0 to (Size mod SizeOf(Buffer))-1 do PrintChr(Buffer[J],PrnOutput);
     End;
     RX := 0;
     PutLine('Impression termin‚.');
    End;
    Systems.Close(Handle);
   End;
  End;

 Begin
  Path := SelectAllIfNoExt(Path);
  If(IsWildCard(Path))Then
  Begin
   FindFirst(Path,$FFFF-VolumeID-Directory,Rec);
   While (DosError = 0) do
   Begin
    TPath := Path2Dir(Path)+Rec.Name;
    PrnFile;
    FindNext(Rec);
   End;
  End
   Else
  Begin
   TPath := Path;
   PrnFile;
  End;
 End;

Begin
 If(MaxExtractExt > 0)Then
 Begin
  For I := 1 to MaxExtractExt do
  Begin
   TStr := ExtractExt(I,Bar);
   If Not(Bar)Then CmdPrnFile(TStr)
    Else
   PutLine('Erreur : ParamŠtre invalide!');
  End;
 End
  Else
 Begin
  PutLine('Erreur : ParamŠtre requis pour imprimer des fichiers!');
  PutLine('');
  PutLine('PRNFILE fichier(s) [fichier(s)] [...]');
 End;
End;

Procedure MDos.RunSetPrn;
Begin
 PutStr(ToolTerm.RunSetPrn(Ext));
End;

Procedure MDos.RunType;
Var Bar,Pause : Bool; I : Byte; TStr : String;

 Procedure CmdTypeFile(Path:PathStr);
 Var Rec : SearchRec;
 Begin
  Path := SelectAllIfNoExt(Path);
  If(IsWildCard(Path))Then
  Begin
   FindFirst(Path,$FFFF-VolumeID-Directory,Rec);
   While (DosError = 0) do
   Begin
    Ansi.TypeFile(Path2Dir(Path)+Rec.Name);
    RX := 0;
    FindNext(Rec);
   End;
  End
   Else
  Begin
   Ansi.TypeFile(Path);
   RX := 0;
  End;
 End;

Begin
 Pause := False;
 For I := 1 to MaxExtractExt do
 Begin
  TStr := StrUp(ExtractExt(I,Bar));
  If(Bar)Then
  Begin
   If(TStr = 'P')or(TStr = 'PAUSE')Then Pause := True;
  End;
 End;
 If(Pause)Then SetPause(True);
 For I := 1 to MaxExtractExt do
 Begin
  TStr := ExtractExt(I,Bar);
  If Not(Bar)Then CmdTypeFile(TStr);
 End;
 SetPause(False);
End;

Function MDos.Run;
Var K,Err   : Word;
    Comspec : String;
    Buffer  : Array[0..255] of Char;
    PBuffer : PChar;

 Procedure EndLn;
 Begin
  If((RX + 16) > Wins.MaxXTxts)Then PutLine('');
 End;

Begin
 Repeat
  If(Echo)Then
  Begin
   Wins._HL;
   Wins.SetKr(CurrColors.MalteDos.Env.Prompt);
   PutStr(GetPrompt);
   Wins.SetKr(CurrColors.MalteDos.Env.Default);
  End;
  Repeat
   Buffer[0] := #0; PBuffer := @Buffer;
   K := Wins.Inp(PBuffer,SizeOf(Buffer)-1); Param := StrPas(Buffer);
   If Not(K = kbEnter)Then
   Begin
    Run := K;
    Exit;
   End;
  Until (K = kbEnter);
  RX := 0;
  If(Echo)Then
  Begin
   Wins.SetKr(CurrColors.MalteDos.Env.Prompt);
   PutStr(GetPrompt);
  End;
  Wins.SetKr(XColrs.Sel);
  PutLine(Param);
  Wins.SetKr(CurrColors.MalteDos.Env.Default);
  Param := StrUp(Param);
  If(Param = '?')Then
  Begin
   PutStr(StrUSpc('?',16)); EndLn;
   PutStr(StrUSpc(':',16)); EndLn;
   PutStr(StrUSpc('CD',16)); EndLn;
   PutStr(StrUSpc('CHDIR',16)); EndLn;
   PutStr(StrUSpc('CLS',16)); EndLn;
   PutStr(StrUSpc('COMSPEC',16)); EndLn;
   PutStr(StrUSpc('COPY',16)); EndLn;
   PutStr(StrUSpc('DEL',16)); EndLn;
   PutStr(StrUSpc('DIR',16)); EndLn;
   PutStr(StrUSpc('ECHO',16)); EndLn;
   PutStr(StrUSpc('ERASE',16)); EndLn;
   PutStr(StrUSpc('EXIT',16)); EndLn;
   PutStr(StrUSpc('FREE',16)); EndLn;
   PutStr(StrUSpc('MD',16)); EndLn;
   PutStr(StrUSpc('MEMORY',16)); EndLn;
   PutStr(StrUSpc('PATH',16)); EndLn;
   PutStr(StrUSpc('PRNFILE',16)); EndLn;
   PutStr(StrUSpc('RD',16)); EndLn;
   PutStr(StrUSpc('SET',16)); EndLn;
   PutStr(StrUSpc('SETPRN',16)); EndLn;
   PutStr(StrUSpc('TYPE',16)); EndLn;
   PutStr(StrUSpc('VER',16)); EndLn;
   PutStr(StrUSpc('VOL',16)); EndLn;
  End
   Else
  If(Length(Param) = 2)and(Param[2] = ':')Then System.ChDir(Param) else
  If(Param = ':')Then PutCurrentDisk Else
  If(Extract('CD'))or(Extract('CHDIR'))Then RunChDir Else
  If(Param = 'CLS')Then Wins.ClrScr Else
  If(Param = 'COMSPEC')Then PutComspec Else
  If(Extract('DIR'))Then PutDir Else
  If(Extract('COPY'))Then RunCopy Else
  If(Extract('DEL'))or(Extract('ERASE'))Then RunDel Else
  If(Extract('ECHO'))Then PutEcho Else
  If(Extract('EXIT'))Then
  Begin
   Run := kbEsc;
   Exit;
  End
   Else
  If(Extract('FREE'))Then PutFree Else
  If(Extract('MD'))or(Extract('MKDIR'))Then RunMkDir Else
  If(Extract('MEMORY'))Then PutMemory Else
  If(Param = 'PATH')Then PutPath Else
  If(Extract('PRNFILE'))Then RunPrnFiles Else
  If(Extract('RD'))or(Extract('RMDIR'))Then RunRMDir Else
  If(Extract('SETPRN'))Then RunSetPrn Else
  If(Param = 'SET')Then PutSet Else
  If(Extract('TYPE'))Then RunType Else
  If(Param = 'VER')Then PutVer Else
  If(Extract('VOL'))Then PutVol
   Else
  Begin
   Comspec := GetEnv('COMSPEC');
   PutLine('Attenton : Je ne connais pas cette commande, je teste avec '+Comspec+'.');
   {$IFNDEF DPMI}FreeMaxHeap;{$ENDIF}
   Exec(GetEnv('COMSPEC'),'/C'+Param);
   {$IFNDEF DPMI}MaxExpandHeap;{$ENDIF}
   Err := DosError;
   Case Err of
     2 : PutLine('Erreur : Commande inconnue!');
     8 : PutLine('Erreur : Manque de m‚moire!');
    Else PutLine('Erreur critique : Erreur Dos #'+ Str(Err));
   End;
  End;
  PutLine('');
 Until (True = False);
End;

Destructor MDos.Done;
Begin
 Wins.Done;
End;

Constructor MUnix.Init;
Begin
 Wins.Init(X1,Y1,X2,Y2);
 Wins.PushWn;
 Wins.PutWn('Malte Unix',CurrColors.MalteDos.Wins);
 Echo := True; PauseLn := False;
 PS1 := '$'; PS2 := '>'; PathVar := ':/bin:/usr/bin';
End;

Function MUnix.Extract;
Var RtnValue : Bool;
Begin
 RtnValue := CmpLeft(Param,CmpMsg);
 If(Length(Param) > Length(CmpMsg))and
   ((Param[Length(CmpMsg)+1] in ['A'..'Z','a'..'z']))Then RtnValue := False;
 If(RtnValue)Then
 Begin
  If(Length(CmpMsg) = Length(Param))Then Ext := ''
   Else
  Ext := DelAllSpcLeft(Copy(Param,Length(CmpMsg)+1,255));
 End;
 Extract := RtnValue;
End;

Function MUnix.ExtractExt;
Begin
 ExtractExt := ToolTerm.ExtractExt(Ext,P,Bar);
End;

Function MUnix.MaxExtractExt;
Begin
 MaxExtractExt := ToolTerm.MaxExtractExt(Ext);
End;

Function MUnix.PutStr;
Var PChr : Array[0..255] of Char;
Begin
 StrPCopy(PChr,Str);
 PutStr := Ansi.Put(PChr);
End;

Function MUnix.PutLine;
Begin
 PutLine := PutStr(Str+#13+#10);
End;

Procedure MUnix.RunCP;
Var Source,Target:PathStr; I,NP:Byte; Bar:Bool; TStr:String; K:Word;

 Procedure CommandCopy(Source,Target:PathStr);
 Var Rec:SearchRec; TSource,TTarget:PathStr;
 Begin
  If(IsWildCard(Source))Then
  Begin
   FindFirst(Source,$FFFF-VolumeID-Directory,Rec);
   While (DOSError = 0) do
   Begin
    TSource := Path2Dir(Source)+Rec.Name;
    TTarget := Src2Target(TSource,Target);
    PutLine(TSource + ' -> ' + TTarget);
    CopyFile(TSource,TTarget);
    FindNext(Rec);
   End;
  End
   Else
  Begin
   If(IsWildCard(Target))Then Target := Src2Target(Rec.Name,Target);
   PutLine(Source + ' -> ' + Target);
   CopyFile(Source,Target);
  End;
 End;

Begin
 If(MaxExtractExt > 0)Then
 Begin
  NP := 0;
  For I := 1 to MaxExtractExt do
  Begin
   TStr := ExtractExt(I,Bar);
   If(Bar)Then
   Begin
    PutLine('Attention : Je ne connais pas le paramŠtre '+TStr+'.');
    PutLine('');
    PutLine('Continue quand mˆme (O/N) ?');
    K := ReadKey;
    If(K = kbEsc)or(ChrUp(Char(Lo(K))) = 'N')Then Exit;
   End
    Else
   Begin
    Case NP of
      0 : Source := TStr;
      1 : Target := TStr;
     Else Begin
           PutLine('Erreur : Trop de r‚pertoire sp‚cifi‚!');
           Exit;
          End;
    End;
    Inc(NP);
   End;
  End;
  CommandCopy(Source,Target);
 End
  Else
 Begin
  PutLine('Erreur : ParamŠtre requis pour commencer le copiage!');
  PutLine('');
  PutLine('cp Source [Destination]');
 End;
End;

Procedure MUnix.RunBanner;
Var TB : Array[0..7,0..79] of Char;
    I,J : Byte;
    S : String Absolute Ext;

 Procedure PutTTextXY;
 Var Mtx : ^TByte; _BH,I,J,K,Masque : Byte; _ES,_BP:Word;
 Begin
  ASM
   MOV AX,$1130;
   MOV BH,$03;
   PUSH BP;
    INT $10;
    MOV BX,BP;
   POP BP;
   MOV _BP,BX;
   MOV _ES,ES;
  END;
  Mtx := Ptr(_ES,_BP);
  For J := 0 to Length(S)-1 do For I := 0 to 7 do
  Begin
   Masque := Mtx^[(8*Byte(S[J+1]))+I];
   For K := 0 to 7 do
   Begin
    If(Masque and 128 <> 0)Then TB[I,(J*8)+K] := '#';
    Masque := Masque shl 1;
   End;
  End;
 End;

Begin
 If(S = '')Then Exit;
 If(S[1] = '"')Then S := Copy(S,2,255)
  Else
 Begin
  PutLine('Erreur de chaŒne de caractŠre');
  Exit;
 End;
 If(S[Length(S)] = '"')Then BackStr(S);
 FillChar(TB,SizeOf(TB),32);
 If(Length(S) > 10)Then S[0] := #10;
 PutTTextXY;
 For J := 0 to 7 do
 Begin
  For I := 0 to (Length(S) * 8)-1 do PutStr(TB[J,I]);
  If(Length(S) < 10)Then PutLine('');
 End;
End;

Function MUnix.Run;
Var K,Err   : Word;
    Comspec : String;
    Buffer  : Array[0..255] of Char;
    PBuffer : PChar;

 Procedure EndLn;
 Begin
  If((RX + 16) > Wins.MaxXTxts)Then PutLine('');
 End;

Begin
 Repeat
  If(Echo)Then
  Begin
   Wins._HL;
   Wins.SetKr(CurrColors.MalteDos.Env.Prompt);
   PutStr(PS1);
   Wins.SetKr(CurrColors.MalteDos.Env.Default);
  End;
  Repeat
   Buffer[0] := #0; PBuffer := @Buffer;
   K := Wins.Inp(PBuffer,SizeOf(Buffer)-1); Param := StrPas(Buffer);
   If Not(K = kbEnter)Then
   Begin
    Run := K;
    Exit;
   End;
  Until (K = kbEnter);
  RX := 0;
  If(Echo)Then
  Begin
   Wins.SetKr(CurrColors.MalteDos.Env.Prompt);
   PutStr(PS1);
  End;
  Wins.SetKr(XColrs.Sel);
  PutLine(Param);
  Wins.SetKr(CurrColors.MalteDos.Env.Default);
  Param := DelAllSpcRight(Param);
  If(Extract('banner'))Then RunBanner Else
  If(Extract('cp'))Then RunCP Else
  If(Param <> '')Then PutLine('Erreur de syntaxe');
  If(Param <> '')Then PutLine('');
 Until (True = False);
End;

Procedure MUnix.Refresh;
Begin
End;

Destructor MUnix.Done;
Begin
 Wins.Done;
End;

Constructor TermPrn.Init;
Begin
 Wins.Init(X1,Y1,X2,Y2);
 Wins.PushWn;
 Wins.PutWn('Terminal d''Imprimante',CurrColors.MalteDos.Wins);
 Echo := True;
 PauseLn := False;
End;

Function TermPrn.Extract;
Var RtnValue : Bool;
Begin
 RtnValue := CmpLeft(Param,CmpMsg);
 If(Length(Param) > Length(CmpMsg))and
   ((Param[Length(CmpMsg)+1] in ['A'..'Z','a'..'z']))Then RtnValue := False;
 If(RtnValue)Then
 Begin
  If(Length(CmpMsg) = Length(Param))Then Ext := ''
   Else
  Ext := DelAllSpcLeft(Copy(Param,Length(CmpMsg)+1,255));
 End;
 Extract := RtnValue;
End;

Function TermPrn.ExtractExt;
Begin
 ExtractExt := ToolTerm.ExtractExt(Ext,P,Bar);
End;

Function TermPrn.MaxExtractExt;
Begin
 MaxExtractExt := ToolTerm.MaxExtractExt(Ext);
End;

Procedure TermPrn.RunPrnFiles;
Var I    : Byte;
    Bar  : Bool;
    TStr : String;

 Procedure CmdPrnFile(Path:PathStr);
 Var Rec : SearchRec; TPath : PathStr;

  Procedure PrnFile;
  Var Handle,J,K : Word; Buffer : Array[0..511] of Char; I,Size : Long;
  Begin
   TPath := FileExpand(TPath);
   PutLine('Imprime le fichier ASCII: '+TPath);
   Handle := Systems.Open(TPath,Systems.ReadOnly);
   If(Systems.IsHandleErr(Handle))Then PutLine('Erreur : Fichier introuvable!')
    Else
   Begin
    Size := Systems.FileSize(Handle);
    If(Size > 0)Then
    Begin
     For I := 0 to (Size div SizeOf(Buffer))-1 do
     Begin
      Wins.PutTxtXY(0,RY,Str(I*SizeOf(Buffer))+'/'+Str(Size)+' octets');
      Systems.GetRec(Handle,I,SizeOf(Buffer),Buffer);
      If(FileError > 0)Then PutLine(StrPas(GetDosErrMsg(FileError)));
      For J := 0 to SizeOf(Buffer)-1 do Printers.PrintChr(Buffer[J],PrnOutput);
      If(Keypressed)Then
      Begin
       ClrKbd;
       PutLine('');
       Wins.PutTxtXY(0,RY,'Dois-je annuler l''op‚ration (O/N) ?');
       K := ReadKey;
       If(Char(K) in ['o','O'])Then
       Begin
        Systems.Close(Handle);
        Exit;
       End;
      End;
     End;
     If((Size mod SizeOf(Buffer)) > 0)Then
     Begin
      Systems.SetFilePos(Handle,(Size div SizeOf(Buffer)) * SizeOf(Buffer));
      Systems._GetRec(Handle,Size mod SizeOf(Buffer),Buffer);
      For J := 0 to (Size mod SizeOf(Buffer))-1 do PrintChr(Buffer[J],PrnOutput);
     End;
     RX := 0;
     PutLine('Impression termin‚.');
    End;
    Systems.Close(Handle);
   End;
  End;

 Begin
  Path := SelectAllIfNoExt(Path);
  If(IsWildCard(Path))Then
  Begin
   FindFirst(Path,$FFFF-VolumeID-Directory,Rec);
   While (DosError = 0) do
   Begin
    TPath := Path2Dir(Path)+Rec.Name;
    PrnFile;
    FindNext(Rec);
   End;
  End
   Else
  Begin
   TPath := Path;
   PrnFile;
  End;
 End;

Begin
 If(MaxExtractExt > 0)Then
 Begin
  For I := 1 to MaxExtractExt do
  Begin
   TStr := ExtractExt(I,Bar);
   If Not(Bar)Then CmdPrnFile(TStr)
    Else
   PutLine('Erreur : ParamŠtre invalide!');
  End;
 End
  Else
 Begin
  PutLine('Erreur : ParamŠtre requis pour imprimer des fichiers!');
  PutLine('');
  PutLine('PRNFILE fichier(s) [fichier(s)] [...]');
 End;
End;

Procedure TermPrn.RunSetPrn;
Begin
 PutStr(ToolTerm.RunSetPrn(Ext));
End;

Function TermPrn.PutStr;
Var PChr : Array[0..255] of Char;
Begin
 StrPCopy(PChr,Str);
 PutStr := Ansi.Put(PChr);
End;

Procedure TermPrn.PutEcho;
Var Str : String;
Begin
 If(MaxExtractExt = 0)Then
 Begin
  PutStr('L''‚cho est ');
  If(Echo)Then PutLine('ouvert')
          Else PutLine('fermer');
 End
  else
 Begin
  Str := StrUp(Ext);
  If(Str = 'ON')Then Echo := True Else
  If(Str = 'OFF')Then Echo := False Else
  If Not(Ext = '.')Then PutLine(Ext);
 End;
End;

Function TermPrn.PutLine;
Begin
 PutLine := PutStr(Str+#13+#10);
End;

Function TermPrn.Run;
Var K,Err   : Word;
    Comspec : String;
    Buffer  : Array[0..255] of Char;
    PBuffer : PChar;

 Procedure EndLn;
 Begin
  If((RX + 16) > Wins.MaxXTxts)Then PutLine('');
 End;

Begin
 Repeat
  If(Echo)Then
  Begin
   Wins._HL;
   Wins.SetKr(CurrColors.MalteDos.Env.Prompt);
   PutStr(GetPromptPrn);
   Wins.SetKr(CurrColors.MalteDos.Env.Default);
  End;
  Repeat
   Buffer[0] := #0; PBuffer := @Buffer;
   K := Wins.Inp(PBuffer,SizeOf(Buffer)-1); Param := StrPas(Buffer);
   If Not(K = kbEnter)Then
   Begin
    Run := K;
    Exit;
   End;
  Until (K = kbEnter);
  RX := 0;
  If(Echo)Then
  Begin
   Wins.SetKr(CurrColors.MalteDos.Env.Prompt);
   PutStr(GetPromptPrn);
  End;
  Wins.SetKr(XColrs.Sel);
  PutLine(Param);
  Wins.SetKr(CurrColors.MalteDos.Env.Default);
  Param := StrUp(DelAllSpcRight(Param));
  If(Param = '?')Then
  Begin
   PutStr(StrUSpc('?',16)); EndLn;
   PutStr(StrUSpc(':',16)); EndLn;
   PutStr(StrUSpc('COM1:',16)); EndLn;
   PutStr(StrUSpc('COM2:',16)); EndLn;
   PutStr(StrUSpc('COM3:',16)); EndLn;
   PutStr(StrUSpc('COM4:',16)); EndLn;
   PutStr(StrUSpc('COM5:',16)); EndLn;
   PutStr(StrUSpc('COM6:',16)); EndLn;
   PutStr(StrUSpc('COM7:',16)); EndLn;
   PutStr(StrUSpc('COM8:',16)); EndLn;
   PutStr(StrUSpc('ECHO',16)); EndLn;
   PutStr(StrUSpc('EXIT',16)); EndLn;
   PutStr(StrUSpc('LPT1:',16)); EndLn;
   PutStr(StrUSpc('LPT2:',16)); EndLn;
   PutStr(StrUSpc('LPT3:',16)); EndLn;
   PutStr(StrUSpc('LPT4:',16)); EndLn;
   PutStr(StrUSpc('NUL',16)); EndLn;
   PutStr(StrUSpc('PRN',16)); EndLn;
   PutStr(StrUSpc('PRNFILE',16)); EndLn;
   PutStr(StrUSpc('SET',16)); EndLn;
   PutStr(StrUSpc('SETPRN',16)); EndLn;
  End
   Else
  If(Param = ':')Then PutLine(GetPromptPrn) Else
  If(Param = 'LPT1:')Then PrnOutput := prnLPT1 Else
  If(Param = 'LPT2:')Then PrnOutput := prnLPT2 Else
  If(Param = 'LPT3:')Then PrnOutput := prnLPT3 Else
  If(Param = 'LPT4:')Then PrnOutput := prnLPT4 Else
  If(Param = 'COM1:')Then PrnOutput := prnCOM1 Else
  If(Param = 'COM2:')Then PrnOutput := prnCOM2 Else
  If(Param = 'COM3:')Then PrnOutput := prnCOM3 Else
  If(Param = 'COM4:')Then PrnOutput := prnCOM4 Else
  If(Param = 'COM5:')Then PrnOutput := prnCOM5 Else
  If(Param = 'COM6:')Then PrnOutput := prnCOM6 Else
  If(Param = 'COM7:')Then PrnOutput := prnCOM7 Else
  If(Param = 'COM8:')Then PrnOutput := prnCOM8 Else
  If(Param = 'NUL')Then PrnOutput := prnNUL Else
  If(Extract('ECHO'))Then PutEcho Else
  If(Extract('EXIT'))Then
  Begin
   Run := kbEsc;
   Exit;
  End
   Else
  If(Extract('PRNFILE'))Then RunPrnFiles Else
  If(Extract('SETPRN'))Then RunSetPrn Else
  If(Extract('SET'))Then RunSetPrn Else
  If(Param <> '')Then PutLine('Erreur de syntaxe');
  If(Param <> '')Then PutLine('');
 Until (True = False);
End;

Procedure TermPrn.Refresh;
Begin
End;

Destructor TermPrn.Done;
Begin
 Wins.Done;
End;

BEGIN
END.