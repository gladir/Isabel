Unit MalInfo;

INTERFACE

Procedure SomaryInfo;

IMPLEMENTATION

Uses RLL,Strings,Strs,Systems,CardVideo,LibVideo,Math,Keyboard,
     Mems,Memorys,MLibrary,Video,Dials,ToolMs,Terminal,Mouse;

Function BiosScan(a,b,c:Word;Var d:Word):Boolean;
Const Max = 3;
      Notice : Array[1..Max] of String[9] = ('(C)','CORP.','COPYRIGHT');
Var i                 : 1..Max;
    Len               : Byte;
    Target            : String;
    XBool             : Boolean;
    XLong             : LongInt;
    XWord             : Word;

 Function Scan(a:String;b,c,d:Word;Var e:Word):Boolean;
 Var I      : LongInt;
     j,len  : Byte;
     XBool1 : Boolean;
     XBool2 : Boolean;
 Begin
  i      := c;
  Len    := Length(a);
  xbool1 := false;
  Repeat
   If(i <= (LongInt(d) - Len + 1))Then
   Begin
    j      := 0;
    XBool2 := False;
    Repeat
     If(J < Len)Then
     Begin
      If(UpCase(Char(Mem[B:i+j])) = a[j+1])Then Inc(J)
       Else
      Begin
       XBool2 := True;
       Inc(i);
      End;
     End
      Else
     Begin
      XBool2 := True;
      XBool1 := True;
      e      := i;
      scan   := True;
     End;
    Until XBool2;
   End
    Else
   Begin
    XBool1 := True;
    Scan   := False;
   End;
  Until XBool1;
 End;

Begin
 XLong := C;
 XBool := False;
 For i := 1 to Max do
 Begin
  Target := Notice[i];
  Len    := Length(Target);
  If(XBool)Then XLong := LongInt(XWord) - 2 + Len;
  If(XLong > b)and(XLong <= c)and(Scan(Target,a,b,xlong,xword))Then XBool := True
 End;
 If(XBool)Then
 Begin
  While((XWord > b)and(Char(Mem[a:xword-1]) in ['A'..'Z','a'..'z'])) do Dec(XWord);
  d := XWord;
 End;
 BiosScan := XBool;
End;

Function GetConstructorBios(Var SX:Boolean):String;
Const Dells : Array[2..$11] of String[5] = (
	       '200','300','?','220','310','325','?','310A','316','220E',
	       '210','316SX','316LT','320LX','?','425E'
	      );
Var i2,i1,_ES,_BX : Word;
    S,Out,RomDate : String;
    XByte         : Byte;
    XBool,Ok      : Boolean;
    i             : Byte;
Begin
 GetConstructorBios := '';
 Out                := '';
 Ok                 := True;
 SX                 := False;
 If(ChrUp(Char(Mem[$F000:$E076])) = 'D')Then
 Begin
  S := '';
  For i1 := $E077 to $E079 do IncStr(s,Char(Mem[$F000:i1]));
  If(S = 'ELL')Then
  Begin
   AddStr(Out,'Dell ');
   XBool := True;
   XByte := Mem[$F000:$E845];
   If(XByte in [2,3,5..7,9..$0F,$11])Then Out := Out + DellS[XByte]
    Else
   Begin
    Out   := Out + '(Inconnue - ID est '+ HexByte2Str(Xbyte) + 'h)';
    XBool := False;
   End;
   If(XBool)Then
   Begin
    Out := Out + ': Revision Bios ';
    For i1 := $E845 to $E847 do IncStr(Out,Char(Mem[$F000:i1]));
   End;
  End;
 End;
 RomDate := '';
 For i1 := $FFF5 to $FFFC do IncStr(RomDate,Char(Mem[$F000:i1]));
 ASM
  MOV AH,$C0;
  XOR BX,BX;
  MOV ES,BX;
  INT $15;
  MOV _BX,BX;
  MOV _ES,ES;
 END;
 If((_ES or _BX) > 0)and(Mem[$FFFF:$E] < $FD)Then
 Begin
  XByte := Mem[_ES:_BX + 4];
  Case MemW[_ES:_BX + 2] of
   $00FC : If(XByte = 1)Then Out := Out + 'PC-AT 2x9, 6Mhz'
                        Else Out := Out + 'Industrial AT 7531/2';
   $01FC : Case XByte of
            $00 : Begin
                   If(RomDate = '11/15/85')Then Out := Out + 'PC-AT 319 ou 339, 8Mhz' else
                   If(RomDate = '01/15&88')Then Out := Out + 'Toshiba T5200/100' else
                   If(RomDate = '12/26*89')Then Out := Out + 'Toshiba T1200/XE' else
                   If(RomDate = '07/24&90')Then Out := Out + 'Toshiba T5200/200' else
                   If(RomDate = '09/17/87')Then Out := Out + 'Tandy 3000'
                    Else
                   Begin
                    If(ReadRom($FFFC,$2,Length('WANG')) = 'WANG')Then Out := Out + 'Wang' Else
                    If(ReadRom($FB00,$0,Length('Zenith')) = 'Zenith')Then Out := Out + 'Zenith' Else
                    If(ReadRom($FC2F,$F,Length('Zenith')) = 'Zenith')Then Out := Out + 'Zenith' Else
                    If(ReadRom($FE00,$4,Length('Tandon')) = 'Tandon')Then Out := Out + 'Tandon' Else
                    If(ReadRom($FC02,$B,Length('Tandy')) = 'Tandy')Then Out := Out + 'Tandy' Else
                    If(ReadRom($FC05,$0,Length('OLIVETTI')) = 'OLIVETTI')Then Out := Out + 'Olivetti' Else
                    If(ReadRom($FFFE,$A,Length('COMPAQ')) = 'COMPAQ')Then Out := Out + 'Compaq'
                     Else
                    Begin
                     i2 := $F000;
                     For I := 0 to 94 do
                     Begin
                      If(BiosScan(i2,0,$1FFF,i1))Then
                      Begin
                       If(Char(Mem[i2:i1]) = '(')and
			 (ChrUp(Char(Mem[i2:i1+1])) = 'C')and
                         (Char(Mem[i2:i1+2]) = ')')Then
                       Begin
                        Inc(i1,3);
                        If(Char(Mem[i2:i1]) = '1')and
                          (Char(Mem[i2:i1+1]) = '9')and
                          (Char(Mem[i2:i1+2]) in ['0'..'9'])and
                          (Char(Mem[i2:i1+3]) in ['0'..'9'])Then
                        Begin
                         Inc(i1,4);
                         While (Char(Mem[i2:i1]) = ' ') do Inc(i1);
                        End;
                       End;
                       i := 80;
                       For i := 1 to 80 do
                       Begin
                        If(Char(Mem[i2:i1+i]) in [#0..#31,','])Then Break;
                       End;
                       Out := Out + ReadRom(i2,i1,i);
                       Break;
                      End;
                      Inc(i2,$80);
                     End;
                    End;
                    If(Out = '')Then Out := '(Clone AT)';
                   End;
                  End;
            $30 : Out := Out + 'Tandy 3000NL';
             Else Begin
                   If(Processor >= _80386)Then
                    Out := Out + 'Compaq 386 ou clone'
                   Else
                    Out := Out + 'Compaq 286 ou clone';
                  End;
           End;
   $02FC : Out := Out + 'PC-XT/286';
   $04FC : If(XByte = 3)Then Out := Out + 'PS/2 Model 50Z 10Mhz 286'
                        Else Out := Out + 'PS/2 Model 50 10Mhz 286';
   $05FC : Out := Out + 'PS/2 Model 60 10Mhz 286';
   $06FC : Out := Out + '7552 Gearbox';
   $09FC : If(XByte = 2)Then Out := Out + 'PS/2 Model 30-286'
                        Else Out := Out + 'PS/2 Model 25-286';
   $0BFC : Out := Out + 'PS/1 Model 2011 10Mhz 286';
   $42FC : Out := Out + 'Olivetti M280';
   $45FC : Out := Out + 'Olivetti M380 (XP1, 3 ou 5)';
   $48FC : Out := Out + 'Olivetti M290';
   $4FFC : Out := Out + 'Olivetti M250';
   $50FC : Out := Out + 'Olivetti M380 (XP7)';
   $51FC : Out := Out + 'Olivetti PCS286';
   $52FC : Out := Out + 'Olivetti M300';
   $00FB : If(XByte = 1)Then Out := Out + 'PC-XT w/ Clavier êtendue, Supporte 3.5"'
                        Else Out := Out + 'PC-XT';
   $01FB : Out := Out + 'PC-XT/2';
   $4CFB : Out := Out + 'Olivetti M200';
   $00FA : Out := Out + 'PS/2 Model 30';
   $01FA : Out := Out + 'PS/2 Model 25/25L';
   $4EFA : Out := Out + 'Olivetti M111';
   $00F9 : Out := Out + 'PC-Convertible';
   $00F8 : Out := Out + 'PS/2 Model 80 16Mhz 386';
   $01F8 : Out := Out + 'PS/2 Model 80 20Mhz 386';
   $04F8 : Out := Out + 'PS/2 Model 70 20Mhz 386';
   $09F8 : Out := Out + 'PS/2 Model 70 16Mhz 386';
   $0BF8 : Out := Out + 'PS/2 Model P70';
   $0CF8 : Begin
            Out := Out + 'PS/2 Model 55SZ 16Mhz 386SX';
            SX  := True;
           End;
   $0DF8 : Out := Out + 'PS/2 Model 70 25Mhz 386';
   $11F8 : Out := Out + 'PS/2 Model 90 25Mhz 386';
   $13F8 : Out := Out + 'PS/2 Model 90 33Mhz 386';
   $14F8 : Out := Out + 'PS/2 Model 90-AK9 25Mhz 486';
   $16F8 : Out := Out + 'PS/2 Model 90-AKD 33Mhz 486';
   $19F8 : Begin
            Out := Out + 'PS/2 Model 35/35LS/40 20Mhz 386SX';
            SX  := True;
           End;
   $1BF8 : Out := Out + 'PS/2 Model 70 25Mhz 486';
   $1CF8 : Begin
            Out := Out + 'PS/2 Model 65-121 16Mhz 386SX';
            SX  := True;
           End;
   $1EF8 : Out := Out + 'PS/2 Model 55LS 16Mhz';
   $23F8 : Begin
            Out := Out + 'PS/2 Model L40 20Mhz 386SX';
            SX  := True;
           End;
   $25F8 : Out := Out + 'PS/2 Model M57 20Mhz 386SLC';
   $26F8 : Begin
            Out := Out + 'PS/2 Model 57 20Mhz 386SX';
            SX  := True;
           End;
   $2AF8 : Out := Out + 'PS/2 Model 95 50Mhz 486';
   $2BF8 : Out := Out + 'PS/2 Model 90 50Mhz 486';
   $2CF8 : Begin
            Out := Out + 'PS/2 Model 95 20Mhz 486SX';
            SX  := True;
           End;
   $2DF8 : Begin
            Out := Out + 'PS/2 Model 90 20Mhz 486SX';
            SX  := True;
           End;
   $2EF8 : Out := Out + 'PS/2 Model 95 20Mhz 486SX+487SX';
   $2FF8 : Out := Out + 'PS/2 Model 90 20Mhz 486SX+487SX';
   $30F8 : Begin
            Out := Out + 'PS/1 Model 2121 16Mhz 386SX';
            SX  := True;
           End;
   $50F8 : Out := Out + 'PS/2 Model P70 16Mhz 386';
   $52F8 : Out := Out + 'PS/2 Model P75 33Mhz 386';
   $61F8 : Out := Out + 'Olivetti P500';
   $62F8 : Out := Out + 'Olivetti P800';
   $80F8 : Out := Out + 'PS/2 Model 80 25Mhz 386';
      Else Out := Out + 'Machine de modäle '+HexWord2Str(MemW[_ES:_BX + 2]) + 'h';
  End;
 End
  Else
 Ok := False;
 If(ReadRom($FFFE,$A,Length('WANG')) = 'WANG')Then Out := Out + 'Wang, ' Else
 If(ReadRom($FB00,$0,Length('Zenith')) = 'Zenith')Then Out := Out + 'Zenith, ' Else
 If(ReadRom($FC2F,$F,Length('Zenith')) = 'Zenith')Then Out := Out + 'Zenith, ' Else
 If(ReadRom($FE00,$4,Length('Tandon')) = 'Tandon')Then Out := Out + 'Tandon, ';
 If Not(Ok)Then
 If(Mem[$F000:$C000] = $21)Then Out := Out + 'Tandy 1000' Else
 Case Mem[$FFFF:$E] of
  $FF : Begin
         If(Mem[$FFFF:$D] = $46)Then Out := Out + 'Olivetti M15'
          Else
         Begin
          Out := Out + 'PC ';
          If(RomDate = '04/24/81')Then Out := Out + ' (Original)' else
          If(RomDate = '10/19/81')Then Out := Out + ' (Bios revisÇ)' else
          If(RomDate = '10/27/82')Then Out := Out + '(HD, 640K, Supporte EGA)'
                                  Else Out := Out + 'clone';
         End;
        End;
  $FE : Begin
         If(Mem[$FFFF:$D] = $43)Then Out := Out + 'Olivetti M240'
          else
         Begin
          Out := Out + 'PC-XT ';
          If(RomDate = '11/08/82')Then Out := Out + 'ou Portable' else
          If(RomDate <> '08/16/82')Then Out := Out + 'clone';
         End;
        End;
  $FD : Out := Out + 'PC Junior';
  $FC : Out := Out + 'PC-AT';
  $9A : Out := Out + 'Compaq XT ou Compaq Plus';
  $56 : Out := Out + 'Conterm Max';
  $30 : Out := Out + 'Sperry PC';
  $2D : Out := Out + 'Compaq PC ou Compaq Deskpro';
   Else Out := Out + 'Machine de modäle '+HexByte2Str(Mem[$FFFF:$E]) + 'h';
 End;
 GetConstructorBios := Out + '; ' +RomDate;
End;

Function OperatingSystem:String;
Var _AX,_DX : Word;
    _CX     : Word;
    _SI,_DI : Word;
    Ok      : Boolean;
    DosV    : Word;
    I       : Byte;
    Rtn,Ver : String;
Begin
 DosV := Swap(DosVer);
 Rtn  := '';
 ASM
  MOV AX,$4452;
  INT $21;
  MOV _AX,AX;
  MOV Ok,Byte(True);
  JNC @@Ok;
  MOV Ok,Byte(False);
@@Ok:
 END;
 If(Ok)Then
 Begin
  Case _AX of
   $1063 : Rtn := 'DR-DOS 3.41';
   $1065 : Rtn := 'DR-DOS 5.00';
   $1067 : Rtn := 'DR-DOS 6.00';
      Else Rtn := 'DR-DOS ? (' + HexWord2Str(_AX) + 'h)';
  End;
 End
  Else
 If(Hi(DosV) >= 10)Then Rtn := 'OS/2 ' + Str(Hi(DosV) div 10) + '.' + Str0(Lo(DosV),2)
  Else
 Rtn := 'Dos ' + Str(Hi(DosV)) + '.' + Str0(Lo(DosV),2);
 ASM
  MOV AX,$BF02;
  XOR DX,DX;
  INT $15;
  MOV _DX,DX;
 END;
 If(_DX <> 0)Then
 Begin
  For I := 1 to 4 do
  Begin
   ASM
    MOV AX,$ED00;
    MOV BL,I;
    INT $2F;
    MOV _AX,AX;
    MOV _CX,CX;
    MOV _SI,SI;
    MOV _DI,DI;
   END;
   If((Lo(_AX) = $FF)and(_SI = $5048)and(_DI = $4152))Then
   Begin
    Ver := Str(Hi(_CX)) + '.' + Str(Lo(_CX));
    Case I of
      1 : AddStr(Rtn,'; Phar Lap 286 Dos-Extender 1.3+ SDK ' + Ver);
      2 : AddStr(Rtn,'; Phar Lap 286 Dos-Extender 1.3+ RTK ' + Ver);
      3 : AddStr(Rtn,'; Phar Lap 386 Dos-Extender 4.0+ SDK ' + Ver);
      4 : AddStr(Rtn,'; Phar Lap 386 Dos-Extender 4.0+ RTK ' + Ver);
     Else AddStr(Rtn,'; DOS/16M');
    End;
   End;
  End;
 End;
 OperatingSystem := Rtn;
End;

Procedure SomaryInfo;
Var W,WC        : Ansi;
    LD,LDrv     : LstMnu;
    SX,Ok       : Boolean;
    I           : Byte;
    _CX,_DX     : Word;
    _BX         : Word;
    _DI,_ES     : Word;
    S           : String;
    Buffer      : Array[0..511] of Byte;
    Size        : LongInt;
    NumMem      : Byte;
    MemXms      : LongInt;
    MemEms      : Word;
    MemConv     : Word;
    MemVram     : Word;
    FreeXms     : Long;
    FreeEms     : Word;
    FreeConv    : Word;
    FreeVram    : Word;
    TotalMem    : Long;
    LenFreeConv : Byte;
    LenUsedConv : Byte;
    LenFreeXms  : Byte;
    LenUsedXms  : Byte;
    LenFreeEms  : Byte;
    LenUsedEms  : Byte;
    LenFreeVram : Byte;
    LenUsedVram : Byte;
    XPos        : Byte;
    SizeOf_:Word;PChr:PChar;
Begin
 W.InitO(70,20);
 W.PushWn;
 W.PutWn('Information Systäme Somaire',CurrColors.Dialog.Wins);
 SetShade(False);
 W.SubWins(0,0,W.MaxXTxts-1,7,WC);
 W.SetSubWn('Ordinateur',WC);
 WC.PutSmallBorder;
 WC.PutTxt('Nom de l''ordinateur       : ');
 WC.SetKrHigh;
 Case Mem[$FFFF:$E] of
  $FF : WC.PutTxtLn('PC ou Compatible');
  $FE : WC.PutTxtLn('PC/XT ou Compatible');
  $FD : WC.PutTxtLn('PC Junior ou Compatible');
  $FC : WC.PutTxtLn('PC/AT ou Compatible');
   Else WC.PutTxtLn('PS/2 ou Compatible');
 End;
 WC.SetKrBorder;
 WC.PutTxt('Constructeur du Bios      : ');
 WC.SetKrHigh;
 WC.PutTxtLn(GetConstructorBios(SX));
 WC.SetKrBorder;
 WC.PutTxt('Processeur principal      : ');
 WC.SetKrHigh;
 Case Processor of
   _i486 : If(SX)Then WC.PutTxtLn('80486SX (32 bits)')
	    Else
	   Begin
	    If(Test8087 = 0)Then WC.PutTxtLn('80486SX (32 bits)')
			    Else WC.PutTxtLn('80486 (32 bits)');
	   End;
   _i386 : If(SX)Then WC.PutTxtLn('80386SX (16 bits)')
		 Else WC.PutTxtLn('80386');
  _80286 : WC.PutTxtLn('80286 (16 bits)');
  _80186 : WC.PutTxtLn('80186 (16 bits)');
  _80188 : WC.PutTxtLn('80188 (8 bits)');
    _v30 : WC.PutTxtLn('v30 (16 bits)');
    _v20 : WC.PutTxtLn('v20 (8 bits)');
   _8086 : WC.PutTxtLn('8086 (16 bits)');
   _8088 : WC.PutTxtLn('8088 (8 bits)');
 End;
 WC.SetKrBorder;
 WC.PutTxt('Coprocesseur mathÇmatique : ');
 WC.SetKrHigh;
 If(Test8087 <> 0)Then Case Processor of
		    _i486 : WC.PutTxtLn('80487');
		    _i386 : If(SX)Then WC.PutTxtLn('80387SX')
				  Else WC.PutTxtLn('80387');
		   _80286 : WC.PutTxtLn('80287');
	    _80186,_80188 : WC.PutTxtLn('80187');
    _v30,_v20,_8086,_8088 : WC.PutTxtLn('8087');
 End
  Else
 WC.PutTxtLn('Aucun');
 WC.SetKrBorder;
 WC.PutTxt('Adapteur vidÇo            : ');
 WC.SetKrHigh;
 PChr := AllocFunc(PVid1^.Card,SetPath4AddFile(StrPas(PathSystems))+'FRANCAIS.*',SizeOf_);
 WC.PutPTxtLn(PChr);
 FreeMem(PChr,SizeOf_);
 WC.SetKrBorder;
 WC.PutTxt('Type souris               : ');
 WC.SetKrHigh;
 WC.PutTxtLn(GetStrMouse);
 __InitMouse;
 WC.Done;
 W.SubList(0,9,33,12,'Disques',LD);
 W.SubList(35,9,W.MaxXTxts-1,12,'Divers',LDrv);
 LD.PutSmallShade;
 LDrv.PutSmallShade;
 S := '';
 For I := $80 to $7F + Mem[_0040:$75] do
 Begin
  ASM
   MOV AH,$08;
   MOV DL,I;
   INT $13;
   MOV _CX,CX;
   MOV _DX,DX;
   MOV Ok,Byte(True);
   JNC @@Ok;
   MOV Ok,Byte(False);
@@Ok:
  END;
  If(Ok)Then
  Begin
   _ES := Seg(Buffer);
   _BX := Ofs(Buffer);
   ASM
    MOV AX,$0201;
    MOV CX,1;
    MOV DH,0;
    MOV DL,I;
    MOV ES,_ES;
    MOV BX,_BX;
    INT $13;
   END;
   If Not(S = '')Then AddStr(S,'; ');
   Size := Long(Swap((Hi(_CX) shl 8) + Lo(_CX) shr 6)) *
	   Long(_CX and 63) * Long(Hi(_DX)+1) *
	   Long(512); {MemW[Seg(Buffer)+1:Ofs(Buffer)-5]}
   If(Size > (1024 * 1024 * 1024))Then
   Begin
    Size := Size div (1024 * 1024 * 1024);
    AddStr(S,Str(Size) + 'Go');
   End
    Else
   If(Size > (1024 * 1024))Then
   Begin
    Size := Size div (1024 * 1024);
    AddStr(S,Str(Size) + 'Mo');
   End
    Else
   If(Size > 1024)Then
   Begin
    Size := Size div 1024;
    AddStr(S,Str(Size) + 'Ko');
   End
    Else
   AddStr(S,Str(Size) + 'o');
  End;
 End;
 If(S <> '')Then LD.AddStrByte('Dur : '+S,0);
 S := '';
 For I := 0 to $7F do
 Begin
  ASM
   MOV AH,$08;
   MOV DL,I;
   INT $13;
   MOV _BX,BX;
   MOV Ok,Byte(True);
   JNC @@Ok;
   MOV Ok,Byte(False);
@@Ok:
  END;
  If(Ok)Then
  Begin
   If(Not(S = ''))and(Lo(_BX) in [1..5])Then AddStr(S,'; ');
   Case Lo(_BX) of
    1 : AddStr(S,'360Ko, 5¨');
    2 : AddStr(S,'1.2Mo, 5¨');
    3 : AddStr(S,'720Ko, 3´');
    4 : AddStr(S,'1.44Mo, 3´');
    5 : AddStr(S,'2.88Mo, 3´');
   End;
  End;
 End;
 If(S <> '')Then LD.AddStrByte('Amovible : '+S,1);
 LD.Refresh;
 If((Mem[_0040:$96] and $10) = $10)Then S := '101' Else S := '84';
 LDrv.AddStrByte('Type de clavier : '+S+'-touches',5);
 LDrv.AddStrByte('Systäme OpÇrateur : '+OperatingSystem,6);
 LDrv.Refresh;
 LD.SelBarInactive;
 LDrv.SelBarInactive;
 MemConv  := MemW[_0040:$13];
 FreeConv := MemAvail div 1024;
 MemEms  := EmmNumPage * 16;
 FreeEms := (EmmFreePage * 16);
 If(VSwpInit)Then Inc(FreeEms,(VSwp[__EMS].GetFree div 1024));
  Case Lo(DosVer) of
  0..3 : MemXms := 0;
     4 : MemXms := MainDataR.DosBlock^.Ver.Dos4.XmsSizeK;
    Else MemXms := MainDataR.DosBlock^.Ver.Dos5.XmsSizeK;
 End;
 FreeXms := QueryFreeMemXms; MemVram := PVid1^.Memory div 1024;
 If(VSwpInit)Then FreeVram := VSwp[__VRAM].GetFree div 1024 Else FreeVram := 0;
 TotalMem := MemXms + MemConv + MemEms + MemVram;
 NumMem := Byte(MemXms>0)+Byte(MemEms>0)+Byte(MemConv>0)+Byte(MemVram>0);
 LenUsedConv := Trunc(((MemConv-FreeConv)/TotalMem)*(W.MaxXTxts-(NumMem*2)));
 LenFreeConv := Trunc((FreeConv/TotalMem)*(W.MaxXTxts-(NumMem*2)));
 LenUsedVram := Trunc(((MemVram-FreeVram)/TotalMem)*(W.MaxXTxts-(NumMem*2)));
 LenFreeVram := Trunc((FreeVram/TotalMem)*(W.MaxXTxts-(NumMem*2)));
 LenUsedXms := Trunc(((MemXms-FreeXms)/TotalMem)*(W.MaxXTxts-(NumMem*2)));
 LenFreeXms := Trunc((FreeXms/TotalMem)*(W.MaxXTxts-(NumMem*2)));
 LenUsedEms := Trunc(((MemEms-FreeEms)/TotalMem)*(W.MaxXTxts-(NumMem*2)));
 LenFreeEms := Trunc((FreeEms/TotalMem)*(W.MaxXTxts-(NumMem*2)));
 XPos := 0; S := Str(MemConv) + 'Ko';
 W.PutTxtXY(XPos,14,Copy('Conventionnel',1,LenUsedConv+LenFreeConv-Length(S))+'.: '+S);
 W.SetKr($1F);
 W.BarSpcHorShade(XPos,15,LenUsedConv);
 W.PutTxtXY(XPos,15,Copy(Str(MemConv-FreeConv)+'Ko',1,LenUsedConv+1));
 Inc(XPos,LenUsedConv+1);
 W.SetKr($8F);
 W.BarSpcHorShade(XPos,15,XPos+LenFreeConv);
 W.PutTxtXY(XPos,15,Copy(Str(FreeConv)+'Ko',1,LenFreeConv+1));
 W.SetKrBorder;
 Inc(XPos,LenFreeConv+3);
 If(LenUsedVram+LenFreeVram > 0)Then W.PutTxtXY(XPos,14,'VidÇo: '+Str(MemVram)+'Ko');
 If(LenUsedVram > 0)Then
 Begin
  W.SetKr($1F);
  W.BarSpcHorShade(XPos,15,XPos+LenUsedVram);
  W.PutTxtXY(XPos,15,Copy(Str(MemVram-FreeVram)+'Ko',1,LenUsedVram+1));
  Inc(XPos,LenUsedVram+1);
 End;
 If(LenFreeVram > 0)Then
 Begin
  W.SetKr($8F);
  W.BarSpcHorShade(XPos,15,XPos+LenFreeVram);
  W.PutTxtXY(XPos,15,Copy(Str(FreeVram)+'Ko',1,LenFreeVram+1));
  Inc(XPos,LenFreeVram);
 End;
 If(LenUsedEms + LenFreeEms > 0)Then
 Begin
  Inc(XPos,3);
  W.SetKrBorder;
  W.PutTxtXY(XPos,14,'EMS: '+Str(MemEms)+'Ko');
 End;
 If(LenUsedEms > 0)Then
 Begin
  W.SetKr($1F);
  W.BarSpcHorShade(XPos,15,XPos+LenUsedEms);
  W.PutTxtXY(XPos,15,Copy(Str(MemEms-FreeEms)+'Ko',1,LenUsedEms+1));
  Inc(XPos,LenUsedEms+1);
 End;
 If(LenFreeEms > 0)Then
 Begin
  W.SetKr($8F);
  W.BarSpcHorShade(XPos,15,XPos+LenFreeEms);
  W.PutTxtXY(XPos,15,Copy(Str(FreeEms)+'Ko',1,LenFreeEms+1));
  Inc(XPos,LenFreeEms+1);
 End;
 If(LenUsedXms + LenFreeXms > 0)Then
 Begin
  Inc(XPos,2);
  W.SetKrBorder;
  W.PutTxtXY(XPos,14,'XMS: '+Str(MemXms)+'Ko');
 End;
 If(LenUsedXms > 0)Then
 Begin
  W.SetKr($1F);
  W.BarSpcHorShade(XPos,15,XPos+LenUsedXms);
  W.PutTxtXY(XPos,15,Copy(Str(MemXms-FreeXms)+'Ko',1,LenUsedXms+1));
  Inc(XPos,LenUsedXms+1);
 End;
 If(LenFreeXms > 0)Then
 Begin
  W.SetKr($8F);
  W.BarSpcHorShade(XPos,15,XPos+LenFreeXms);
  W.PutTxtXY(XPos,15,Copy(Str(FreeXms)+'Ko',1,LenFreeXms+1));
  Inc(XPos,LenUsedXms);
 End;
 LD.Done;
 LDrv.Done;
 W.GetkHorDn('Correcte');
 SetShade(True);
 W.Done;
End;

BEGIN
END.