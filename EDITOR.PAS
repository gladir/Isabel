{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                  ³
 ³   Malte Genesis/Module de Traitement de Texte    ³
 ³            Edition Isabel pour Mode R‚el         ³
 ³                  III - Version 1.0               ³
 ³                     1995/02/02                   ³
 ³                                                  ³
 ³    Copyright (C) par les Chevaliers de Malte     ³
 ³                                                  ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Editor;

INTERFACE

{$IFNDEF Debug}
 {$D-,L-,Y-}
{$ENDIF}
{$B-,I-,Q-,R-,S-,X+}

Uses Math,Dos,Memorys,Video,Windows,Dials,Mems;

Const

      ViewDefault = 0;
      ViewAda = 1;
      ViewAsm = 2;
      ViewBas = 3;
      ViewC = 4;
      ViewCobol = 5;
      ViewEuphoria = 6;
      ViewForth = 7;
      ViewFortran = 8;
      ViewIni = 9;
      ViewMsMnu = 10;
      ViewPas = 11;
      ViewPW = 12;
      ViewRC = 13;
      ViewGAT = 14;
      ViewGATT = ViewGAT;
      ViewPJ = 15;
      ViewPersonalJournal = ViewPJ;
      ViewAC = 16;
      ViewBasCoco3 = 17;
      ViewBasCK64 = 18;
      ViewBasAppleII = 19;
      ViewBasVic20 = 20;
      ViewHlp = 21;

      CharNormal = 0;
      CharBold = 1;
      CharUnderLine = 2;
      CharItalic = 4;
      CharInverse = 8;
      CharDouble = 16;

Type

     Edt = Object
      Lst:RBuf;
      XW1,XW2,StrMX:Word;
      YW1,YW2,FS:Long;
      Mode:Byte;
      ReadOnly,Modified,DrawMode,MakeSpc,IndexMode:Bool;
      EditName,_Title:PathStr;
      W:Wins;
      Constructor Init(Name:PathStr);
      Constructor InitHlp(X1,Y1,X2,Y2:Byte;Name,Title:PathStr);
      Constructor InitWn(X1,Y1,X2,Y2:Byte;Name:PathStr);
      Constructor NewGatt(X1,Y1,X2,Y2:Byte);
      Function IsLoadOk:Bool;
      Function IsLoadOutMem:Bool;
      Procedure SetDrawMode(M:Bool);
      Procedure ExecMacro(Path:PathStr);
      Procedure InsSpcIfHome(Num:Word);
      Procedure PutWn(X1,Y1,X2,Y2:Byte);
      Procedure ChkMaxLen(L:Word);
      Procedure PutBar;
      Procedure UpDateScr;
      Procedure SetWn(X1,Y1,X2,Y2:Byte);
      Procedure ViewMode(M:Byte);
      Procedure SetViewMode(M:Byte);
      Procedure SetChrType(M:Byte);
      Procedure BoldWord;
      Procedure DoubleWord;
      Procedure InverseWord;
      Procedure ItalicWord;
      Procedure UnderlineWord;
      Function GetViewMode:Byte;
      Function GetName:PathStr;
      Procedure Refresh;
      Procedure kCtrlLeft;
      Procedure kCtrlRight;
      Procedure kLeft;
      Procedure kRight;
      Procedure kUp;
      Procedure kDn;
      Procedure kHome;
      Procedure kEnd;
      Procedure kDel;
      Procedure kBS;
      Procedure kPgUp;
      Procedure kPgDn;
      Procedure kEnter;
      Procedure DelSpc;
      Procedure CenterTxt;
      Procedure SetIndexMode;
      Procedure SetThisChr(Chr:Char);
      Procedure PushStr(S:String);
      Function GotoLns(Lns:LongInt):Bool;
      Function GotoXY(_X:Word;_Y:Long):Bool;
      Function Run:Word;
      Function MaxLns:Long;
      Procedure SetCur;
      Procedure SetFormat;
      Function SaveAs(Path:PathStr):Bool;
      Function Save:Bool;
      Procedure Prn;
      Destructor Done;
      PRIVATE
      X,Y,ChrAttr:Byte;
      P,PgNmStart:Long;
      PX,PXG:Word;
      ScrollLck,LoadOk,LoadOutMem,InsMode:Bool;
      Index:LstMnu;
      PgNmIn:(pNone,pLeft,pRight,pAlternate);
      Procedure CenterHomeParagraph;
      Procedure GattCenterTxt;
      Procedure DefCenterTxt;
      Procedure InitCoord;
      Procedure InitDef;
      Procedure kEnterIns;
      Function kRightNShow(Show:Bool):Bool;
      Procedure Left4Word;
      Procedure Load(Name:PathStr);
      Procedure PutBarXYM(_X:Word;_Y,Mem:Long);
      Procedure PutCurrLn;
      Procedure PutIns;
      Procedure PutLn(I1:Word;Line:Long);
      Procedure PutPos;
      Procedure PutScrollLck;
      Procedure PutViewMode;
      Procedure SetChr(PChr:PChar;Chr:Char);
      Procedure SetModified;
      Procedure SetWord(ChrMode:Byte);
      Procedure UpDateInfo;
      Procedure UpDatePXGWithX(_X:Byte);
      Procedure _PutLn(Size,I1:Word;PChr:PChar);
      Function AddEndChr(L:Word;PChr:PChar;Chr:Char):Bool;
      Function AddChr(L:Word;PChr:PChar;Chr:Char):Bool;
      Function AddFirstChr(PChr:PChar;Chr:Char):Bool;
      Function GetCurrChr:Char;
      Function GetLastChr:Char;
      Function GetNextChr:Char;
      Function GetUpChr:Char;
      Function GetDnChr:Char;
      Function InsChr(L:Word;PChr:PChar;Chr:Char):Bool;
      Function InsSpcHome(L,N:Word;Var PChr:PChar):Bool;
      Function IsAttrDbl:Bool;
      Function IsAttrUnder:Bool;
      Function IsDbl(Chr:Char):Bool;
     End;

Var

    PathResource,PathPas,PathFortran,PathForth,PathEuphoria:PChar;
    PathCobol,PathC,PathBas,PathAsm,PathAda,PathGatt:PChar;
    ExtAC,ExtAsm,ExtBas,ExtC,ExtEuphoria:PChar;
    ExtFortran,ExtIni,ExtMsMnu,ExtPas,ExtRC:PChar;
    PutMemory:Procedure;

IMPLEMENTATION

Uses Printers,Strings,Strs,Terminal,Systems,Language,MLibrary,
     Keyboard,ToolEdit,ToolLang,Mouse,Clock,Cursor,
     ScrnSaver;

Procedure SetTab(Var S:String); Forward;
Procedure SetGattAttr(Len:Word;PChr:PChar;Var PChrT:Array of Char;P,L:Word;Attr:Byte); Forward;

Function DelChrInGatt(Var PChr:PChar;L,P:Word):Byte; Forward;
Function GetGATTLen(PChr:PChar):Word; Forward;
Function PosGatt2X(PChr:PChar;P:Word):Word; Forward;
Function PosX2Gatt(PChr:PChar;P:Word):Word; Forward;

Function DelChrInGatt(Var PChr:PChar;L,P:Word):Byte;
Begin
 DelChrInGatt := 0;
 If(PChr[P] in [#1..#31])Then
 Begin
  If(PChr[P+1] in [' '..#254])Then
  Begin
   Move(PChr[P+2],PChr[P],L-P-1); PChr[L-2] := #0;
   DelChrInGatt := 2;
  End;
 End
  Else
 If((P > 0)and(PChr[P-1] in [#1..#31]))Then
 Begin
  Move(PChr[P+1],PChr[P-1],L-P-1); PChr[L-2] := #0;
  DelChrInGatt := 2;
 End
  Else
 Begin
  Move(PChr[P+1],PChr[P],L-P); PChr[L] := #0;
  DelChrInGatt := 1;
 End;
End;

Procedure SetGattAttr(Len:Word;PChr:PChar;Var PChrT:Array of Char;P,L:Word;Attr:Byte);
Var I,J,K:Word;
Begin
 If(Len = 0)Then Exit;
 J := 0;
 For I := 0 to (P - 1) do Case PChr[J] of
  #0: Begin Move(PChr^,PChrT,Len+1); Exit; End;
  #1..#31: Inc(J,2)
  Else Inc(J);
 End;
 K := J;
 Move(PChr^,PChrT,J);
 If(Attr = 0)Then
 For I := P to (P + L - 1) do Case PChr[J] of
  #0:  Begin PChrT[K] := #0; Exit; End;
  #1..#31:  Begin PChrT[K] := PChr[J+1]; Inc(J,2); Inc(K); End;
  Else  Begin PChrT[K] := PChr[J]; Inc(J); Inc(K); End;
 End
  Else
 For I := P to (P + L - 1) do Case PChr[J] of
  #0:  Begin PChrT[K] := #0; Exit; End;
  ' ':  Begin PChrT[K] := '_'; Inc(J); Inc(K); End;
  #1..#31:
  Begin
   PChrT[K] := Char(Attr); PChrT[K+1] := PChr[J+1];
   Inc(J,2); Inc(K,2);
  End;
  Else
  Begin
   PChrT[K] := Char(Attr); PChrT[K+1] := PChr[J];
   Inc(J); Inc(K,2);
  End;
 End;
 Move(PChr[J],PChrT[K],Len-J+1);
End;

Procedure Edt.kDel;
Var PBuf,PBuf2,TBuf:PChar; Ptr:Pointer Absolute PBuf; L,L2,TSize,_X:Word;
Begin
 If(ReadOnly)Then Exit;
 PBuf := Lst._GetBuf(P); L := StrLength(PBuf);
 If(Mode = ViewGAT)Then _X := PXG Else _X := PX;
 If(_X < L)Then
 Begin
  If(Mode = ViewGAT)Then
  Begin
   Dec(FS,DelChrInGatt(PBuf,L,PXG));
   W.SetPos(0,Y);
   PutLn(PX-X,P);
   SetModified;
   UpDateInfo;
  End
   Else
  Begin
   Dec(FS); Move(PBuf[PX+1],PBuf[PX],L-PX); PBuf[L] := #0;
   W.SetPos(0,Y);
   PutLn(PX-X,P);
   SetModified;
   UpDateInfo;
  End;
 End
  Else
 If(L = 0)Then
 Begin
  Lst.DelBuf(P);
  Dec(FS,Long(2));
  UpDateScr;
  UpDateInfo;
 End
  else
 Begin
  PBuf2 := Lst._GetBuf(P+1);
  If(PBuf2 = NIL)Then
  Begin
   Lst.DelBuf(P+1);
   UpDateScr;
   UpDateInfo;
  End
   else
  Begin
   L2 := StrLength(PBuf2);
   If(Mode = ViewGAT)Then
   Begin
    TSize := PXG + L2; TBuf := MemAlloc(TSize);
    If(TBuf = NIL)Then Exit;
    FillChar(TBuf[L],PXG-L,32);
   End
    Else
   Begin
    TSize := PX + L2; TBuf := MemAlloc(TSize);
    If(TBuf = NIL)Then Exit;
    FillChar(TBuf[L],PX-L,32);
   End;
   Move(PBuf[0],TBuf[0],L);
   Move(PBuf2[0],TBuf[L],L2);
   If Not(Lst.SetBuf(P,TSize + 1,Ptr))Then Exit;
   If(Ptr = NIL)Then Exit;
   Move(TBuf[0],PBuf[0],TSize);
   PBuf[TSize] := #0;
   Lst.DelBuf(P+1);
   FreeMem(TBuf,TSize);
   Dec(FS,LongInt(2));
   SetModified;
   UpDateScr;
   UpDateInfo;
  End;
 End;
End;

Procedure Edt.kBS;
Begin
 If(PX > 0)Then
 Begin
  kLeft;
  kDel;
 End
  else
 Begin
  If(P > 0)Then
  Begin
   kUp;
   kEnd;
   kDel;
  End;
 End;
End;

Procedure Edt.SetThisChr;
Var PChr:PChar; L,_X:Word;
Begin
 If(ReadOnly)Then Exit;
 If(Chr in [#0..#31,#255])Then Chr := ' ';
 If(Mode = ViewGAT)Then
 Begin
  If(Chr = ' ')and((ChrAttr and CharDouble) = CharDouble)and
    ((ChrAttr and CharUnderline) = CharUnderline)Then
  Begin
   Chr := '_'; ChrAttr := CharNormal;
  End;
  _X := PXG;
 End
  Else
 _X := PX;
 PChr := Lst._GetBuf(P); L := StrLength(PChr);
 If(L >= 65520)Then
 Begin
  WarningMsgOk('Impossible de d‚passer la limite de 65520 octets par ligne!');
  Exit;
 End;
 If(L = 0)Then
 Case _X of
   0 : If Not(AddFirstChr(PChr,Chr))Then __OutOfMemory;
  Else If Not(AddEndChr(L,PChr,Chr))Then __OutOfMemory;
 End
  else
 If(L > _X)Then
 Begin
  If(InsMode)Then
  Begin
   If Not(InsChr(L,PChr,Chr))Then __OutOfMemory;
  End
   Else
  SetChr(PChr,Chr);
 End
  else
 If Not(AddChr(L,PChr,Chr))Then __OutOfMemory;
 SetModified;
End;

Function Edt.kRightNShow;
Var PChr:PChar;
Begin
 kRightNShow := False;
 If(Mode = ViewGAT)Then
 Begin
  If(GetScrollLock)Then
  Begin
   If(PX < XW2)Then
   Begin
    PChr := Lst._GetBuf(P); Inc(PX);
    If(PChr[PXG] < ' ')and(IsDbl(PChr[PXG]))Then
    Begin
     Inc(PX);
     If(X < W.MaxXTxts)Then Inc(X);
    End;
    If(PChr[PXG] in [#1..#31])Then Inc(PXG);
    Inc(PXG);
    If(Show)Then PutPos;
    If(X < W.MaxXTxts)Then Inc(X) Else
    Begin
     If(Show)Then UpDateScr Else kRightNShow := True;
    End;
    If(Show)Then SetCur;
   End;
  End
   else
  Begin
   If(PXG < 65520)Then
   Begin
    PChr := Lst._GetBuf(P); Inc(PX);
    If(PChr[PXG] < ' ')and(IsDbl(PChr[PXG]))Then
    Begin
     Inc(PX);
     If(X < W.MaxXTxts)Then Inc(X);
    End;
    If(PChr[PXG] in [#1..#31])Then Inc(PXG);
    Inc(PXG);
    If(Show)Then PutPos;
    If(X < W.MaxXTxts)Then Inc(X) Else
    Begin
     If(Show)Then UpDateScr Else kRightNShow := True;
    End;
    If(Show)Then SetCur;
   End;
  End;
 End
  Else
 Begin
  If(GetScrollLock)Then
  Begin
   If(PX < XW2)Then
   Begin
    Inc(PX);
    If(Show)Then PutPos;
    If(X < W.MaxXTxts)Then Inc(X) Else
    Begin
     If(Show)Then UpDateScr Else kRightNShow := True;
    End;
    If(Show)Then SetCur;
   End;
  End
   else
  Begin
   If(PX < 65520)Then
   Begin
    Inc(PX);
    If(Show)Then PutPos;
    If(X < W.MaxXTxts)Then Inc(X) Else
    Begin
     If(Show)Then UpDateScr Else kRightNShow := True;
    End;
    If(Show)Then SetCur;
   End;
  End;
 End;
End;

Procedure Edt.kRight;
Begin
 kRightNShow(True);
End;

Procedure Edt.SetWord;
Var PChr,NewPChr:PChar; L,I,N:Word;
Begin
 If(ReadOnly)Then Exit;
 If(Mode = ViewGATT)Then
 Begin
  PChr := Lst._GetBuf(P); L := StrLength(PChr);
  If(L = 0)or(PXG > L)Then Exit;
  I := PXG; N := 0;
  While Not(PChr[I] in [#0,' ']) do
  Begin
   If(PChr[I] in [#33..#254])Then Inc(N);
   Inc(I);
  End;
  NewPChr := MemAlloc(L+N+1);
  If(NewPChr = NIL)Then Exit;
  SetGattAttr(L,PChr,NewPChr[0],PX,N,ChrMode);
  PChr := Lst._SetBuf(P,L+N+1);
  If(PChr = NIL)Then Exit;
  Move(NewPChr^,PChr^,L+N+1);
  FreeMem(NewPChr,L+N+1);
  kCtrlRight;
  UpDateScr;
 End;
End;

Procedure Edt.DelSpc;
Var PChr:PChar; I:Word;
Begin
 If(ReadOnly)Then Exit;
 PChr := Lst._GetBuf(P); I := PXG;
 While (PChr[I] = ' ') do Inc(I);
 StrDel(PChr,PXG,I-PXG);
 PutCurrLn;
 SetModified;
End;

Procedure Edt.InitCoord;
Begin
 X := 0; Y := 0; P := 0; PX := 0; PXG := 0;
 XW1 := 0; XW2 := 65520; YW1 := 0; YW2 := 214783647;
End;

Procedure Edt.InitDef;
Begin
 LoadOk := True; LoadOutMem := False; ScrollLck := False; FS := 0; StrMX := 0;
 Modified := False; DrawMode := False; ReadOnly := False; InsMode := True;
 IndexMode := False; MakeSpc := True; ChrAttr := CharNormal; Mode := ViewDefault;
 EditName := ''; PgNmIn := pNone; PgNmStart := 0;
End;

Constructor Edt.Init;
Begin
 InitDef;
 InitCoord;
 Lst.Init;
End;

Constructor Edt.NewGatt;
Begin
 InitWn(X1,Y1,X2,Y2,'');
 XW1 := 10; XW2 := 70;
 SetViewMode(ViewGatt);
End;

Procedure Edt.PushStr;
Var I : Byte;
Begin
 For I := 1 to Length(S) do
 Begin
  SetThisChr(S[I]);
  kRight;
 End;
End;

Procedure Edt.ExecMacro;
Var L:RBuf; Handle,J,Err,a,b:Word; I,xJ:Byte; FP,MS:Long; V,S,E:String;

 Procedure PageNm;
 Begin
  SkipSpcInLine(I,S); Val(ExtractDecNum(I,S),PgNmStart,Err);
 End;

 Procedure PageFormat;
 Begin
  SkipSpcInLine(I,S); Val(ExtractDecNum(I,S),XW1,Err); SkipSpcInLine(I,S);
  If(S[I] = ',')Then
  Begin
   Inc(I); SkipSpcInLine(I,S); Val(ExtractDecNum(I,S),YW1,Err);
   SkipSpcInLine(I,S);
   If(S[I] = ',')Then
   Begin
    Inc(I); SkipSpcInLine(I,S); Val(ExtractDecNum(I,S),XW2,Err);
    SkipSpcInLine(I,S);
    If(S[I] = ',')Then
    Begin
     Inc(I); SkipSpcInLine(I,S); Val(ExtractDecNum(I,S),YW2,Err);
    End;
   End;
  End;
 End;

 Procedure cPutLn;
 Var Ok:Bool; J,x3,x4:Word; E,E2:String;
 Begin
  Repeat
   SkipSpcInLine(I,S);
   Case StrI(I,S) of
    '#' : Begin
	   Inc(I);
	   If(StrI(I,S) = 'B')Then
	   Begin
	    Inc(I);
	    If(StrI(I,S) = '(')Then
	    Begin
	     Inc(I);
	     E2 := ExtractDecNum(I,S);
	     If(StrI(I,S) = ':')Then
	     Begin
	      Inc(I);
	      E := ExtractWord(I,S);
	      If(E = V)Then
	      Begin
	       If(StrI(I,S) = ')')Then Inc(I);
	       PushStr(BinByte2Str(a));
	       kRight;
	      End;
	     End;
	    End;
	   End
	    Else
	   If(StrI(I,S) = 'H')Then
	   Begin
	    Inc(I);
	    If(StrI(I,S) = '(')Then
	    Begin
	     Inc(I);
	     E2 := ExtractDecNum(I,S);
	     If(StrI(I,S) = ':')Then
	     Begin
	      Inc(I);
	      E := ExtractWord(I,S);
	      If(E = V)Then
	      Begin
	       If(StrI(I,S) = ')')Then Inc(I);
	       PushStr(HexByte2Str(a));
	       kRight;
	      End;
	     End;
	    End;
	   End
	    Else
	   If(StrI(I,S) = '(')Then
	   Begin
	    Inc(I);
	    E := ExtractWord(I,S);
	    If(E = V)Then
	    Begin
	     If(StrI(I,S) = ')')Then Inc(I);
	     SetThisChr(Char(a));
	     kRight;
	    End;
	   End;
	  End;
    '>' : If(StrI(I+1,S) = '>')Then
	  Begin
	   Inc(I,Length('>>'));
	   Val(ExtractDecNum(I,S),Handle,Err);
	   PushStr(Spc(Handle));
	  End;
    '(' : Begin
	   E := ''; Inc(I);
	   If(StrI(I,S) = '"')Then
	   Begin
	    Inc(I);
	    While Not(StrI(I,S) = #0) do
	    Begin
	     If(S[I] = '"')Then
	     Begin
	      Inc(I);
	      Break;
	     End;
	     IncStr(E,S[I]); Inc(I);
	    End;
	    SkipSpcInLine(I,S);
	    If(StrI(I,S) = '*')Then
	    Begin
	     Inc(I); SkipSpcInLine(I,S); E2 := StrUp(ExtractWord(I,S));
	     If(E2 = 'NMXTXTS')Then
	      For J := 1 to (XW2-XW1) div Length(E) do PushStr(E);
	    End;
	    If(StrI(I,S) = ')')Then Inc(I);
	   End;
	  End;
    '"' : Begin
	   Inc(I);
	   While Not(StrI(I,S) = #0) do
	   Begin
	    If(S[I] = '"')Then
	    Begin
	     Inc(I);
	     Break;
	    End;
	    SetThisChr(S[I]);
	    kRight;
	    Inc(I);
	   End;
	  End;
    'A'..'Z','a'..'z','_':
    Begin
     E := ExtractWord(I,S);
     If(StrI(I,S) = ':')Then Inc(I);
     Val(ExtractDecNum(I,S),x3,Err);
     PushStr(Str2(a,x3));
    End;
   End;
   SkipSpcInLine(I,S);
   If(StrI(I,S) = ',')Then
   Begin
    Ok := False; Inc(I);
   End
    Else
   Ok := True;
  Until Ok;
  kEnterIns;
 End;

Begin
 Handle := Open(Path,Systems.ReadOnly); V := '';
 If(IsHandle(Handle))Then
 Begin
  MS := FileSize(Handle); FP := 0;
  L.Init;
  Repeat
   SetFilePos(Handle,FP);
   S := GetFileTextLn(Handle);
   Inc(FP,Length(S)+2);
   If(FileError <> 0)Then Break;
   L.AddStr(S);
  Until (FP >= MS);
  Close(Handle);
  For J := 0 to L.MaxBuf do
  Begin
   S := L._GetStr(J);
   For I := 1 to Length(S) do
   Begin
    If(S[I] in ['A'..'Z','a'..'z'])Then
    Begin
     E := StrUp(ExtractWord(I,S));
     If(E = 'PAGEFORMAT')Then PageFormat Else
     If(E = 'PAGENM')Then PageNm Else
     If(E = 'LN')Then kEnterIns Else
     If(E = 'FOR')Then
     Begin
      SkipSpcInLine(I,S);
      If(StrI(I,S) = '(')Then Inc(I);
      V := ExtractWord(I,S);
      If(StrI(I,S) = '=')Then Inc(I);
      Val(ExtractDecNum(I,S),a,Err);
      If(StrI(I,S) = ';')Then Inc(I);
      Val(ExtractDecNum(I,S),b,Err);
      If(StrI(I,S) = ')')Then Inc(I);
      SkipSpcInLine(I,S);
      Err := a; xJ := I;
      For a := Err to b do
      Begin
       I := xJ; E := StrUp(ExtractWord(I,S));
       If(E = 'PUTLN')Then cPutLn;
      End;
     End
      Else
     If(E = 'PUTLN')Then cPutLn Else
     Break;
    End
     Else
    Break;
    If(I > Length(S))Then Break;
   End;
  End;
  L.Done;
 End;
End;

Procedure Edt.SetIndexMode;
Var J:Long; S:String;

 Procedure CrashWord;
 Var s2:String; I:Byte;
 Begin
  s2 := '';
  For I := 1 to Length(S) do If(S[I] >= ' ')Then IncStr(s2,S[I]);
  S := s2;
 End;

Begin
 IndexMode := True;
 Index.Init(W.RX1+3,W.RY1+2,W.RX2-3,W.RY2-2,'Index',W.XColrs);
 Lst.SetPtr(0);
 If Not(Lst.IsEmpty)Then For J := 0 to Lst.MaxBuf do
 Begin
  S := DelAllSpcLeft(StrPas(Lst._GetCurrBuf));
  CrashWord;
  If(CmpLeft(S,_Title))Then Index.AddStrWord(Copy(S,Length(_Title)+4,255),J);
  Lst.Next;
 End;
End;

Procedure Edt.SetDrawMode;
Begin
 If(Mode = ViewHlp)Then Exit;
 DrawMode := M;
 SetInsMode(False);
 PutIns;
End;

Constructor Edt.InitHlp;
Begin
 Init(Name);
 Mode := ViewHlp;
 EditName := Name; _Title := Title; ReadOnly := True;
 PutWn(X1,Y1,X2,Y2);
 PutBar;
 Load(Name);
 UpDateScr;
 SetCur;
 PutBar;
End;

Procedure Edt.Load;
Var Handle,Err:Word; I,FP:Long; Str:String; T,J:Byte; PChr:PChar; Chr:Char; AddSpc:Bool;

 Procedure PutTimer;
 Begin
  If((Mem[_0040:$6C] and 1) = 0)Then
  Begin
   If(T <> Mem[_0040:$6C])Then
   Begin
    PutMemory;
    PutBarXYM(StrMX,Lst.NmBuf,FS);
    T := Mem[_0040:$6C];
   End;
  End;
 End;

Begin
 AddSpc := False; Handle := Open(Name,Systems.ReadOnly);
 If(IsHandleErr(Handle))Then
 Begin
  LoadOk := False;
  Exit;
 End;
 FS := FileSize(Handle); FP := 0;
 If(FileError <> 0)Then LoadOk := False;
 SetFilePos(Handle,FP);
 Str := GetFileTextLn(Handle);
 If(FileError <> 0)Then LoadOk := False;
 Inc(FP,Length(Str)+2);
 If(Str[1] = ':')Then
 Begin
  J := 2;
  SkipSpcInLine(J,Str); Val(ExtractDecNum(J,Str),XW1,Err);
  SkipSpcInLine(J,Str); Val(ExtractDecNum(J,Str),YW1,Err);
  SkipSpcInLine(J,Str); Val(ExtractDecNum(J,Str),XW2,Err);
  SkipSpcInLine(J,Str); Val(ExtractDecNum(J,Str),YW2,Err);
  AddSpc := False;
 End
  Else
 Begin
  AddSpc := True; XW1 := 10; XW2 := 70; FP := 0;
 End;
 Repeat
  SetFilePos(Handle,FP);
  Str := GetFileTextLn(Handle);
  If(FileError <> 0)Then
  Begin
   LoadOk := False;
   Break;
  End;
  Inc(FP,Length(Str)+2);
  SetTab(Str);
  If(AddSpc)and(Str <> '')Then Str := Spc(10) + Str;
  ChkMaxLen(Word(Length(Str)));
  If Not(Lst.AddStr(Str))Then
  Begin
   LoadOutMem := True;
   Break;
  End;
  PutTimer;
 Until (FP >= FS);
 Systems.Close(Handle);
End;

Constructor Edt.InitWn;
Type PWHeader=Record
      NumYTexts,Y1,EndPageMargeY:Word; Res1:Array[6..9] of Byte;
      X1,X2:Word; Res3:Array[14..640] of Byte; Sign:Array[0..5] of Char;
     End;
Var E:ExtStr; S3:String[15]; Handle,Err:Word; I,FP:Long; S2,Str:String;
    T,J:Byte; PChr:PChar; Chr:Char; PW:PWHeader; AddSpc:Bool;

 Procedure PutTimer;
 Begin
  _BackKbd;
  If((Mem[_0040:$6C] and 1) = 0)Then
  Begin
   If(T <> Mem[_0040:$6C])Then
   Begin
    PutMemory;
    PutBarXYM(StrMX,Lst.NmBuf,FS);
    T := Mem[_0040:$6C];
   End;
  End;
 End;

Begin
 InitDef;
 InitCoord;
 AddSpc := False; FP := 0;
 If Not(Name = '')Then
 Begin
  Name := StrUp(FileExpand(Name));
  T := $FF; E := Path2Ext(Name);
  If(Pos(E,StrPas(ExtRC)) > 0)Then Mode := ViewRC;
  If(Pos(E,StrPas(ExtPas)) > 0)Then Mode := ViewPas;
  If(Pos(E,StrPas(ExtFortran)) > 0)Then Mode := ViewFortran;
  If(Pos(E,StrPas(ExtEuphoria)) > 0)Then Mode := ViewEuphoria;
  If(Pos(E,StrPas(ExtC)) > 0)Then Mode := ViewC;
  If(Pos(E,StrPas(ExtBas)) > 0)Then Mode := ViewBas;
  If(Pos(E,StrPas(ExtAsm)) > 0)Then Mode := ViewAsm;
  If(Pos(E,StrPas(ExtAC)) > 0)Then Mode := ViewAC;
  If(Pos(E,'.GAT') > 0)Then Mode := ViewGat;
 End;
 EditName := Name;
 Lst.Init;
 PutWn(X1,Y1,X2,Y2);
 PutBar;
 PutMemory;
 ActifScrSave := False;
 _InitKbd;
 If(Name <> '')Then
 Begin
  Handle := Open(Name,Systems.ReadOnly);
  If(IsHandleErr(Handle))Then
  Begin
   LoadOk := False;
   Exit;
  End;
  GetRec(Handle,0,SizeOf(PW),PW);
  If(PW.Sign[0] = 'T')and(PW.Sign[1] = 'Y')and(PW.Sign[2] = 'P')and(PW.Sign[3] = 'E')and(PW.Sign[5] = '3')Then
  Begin
   Mode := ViewPW; XW1 := PW.X1; XW2 := PW.X2; FS := FileSize(Handle); Str := Spc(XW1);
   SetFilePos(Handle,861);
   For I := 821 to FS do
   Begin
    Chr := ReadChar(Handle);
    If(FileError <> 0)Then
    Begin
     LoadOk := False;
     Break;
    End;
    Case Chr of
     #0 : ;
     #1 :
     Begin
      If(Length(Str) > StrMX)Then StrMX := Length(Str);
      If Not(Lst.AddStr(Str))Then
      Begin
       LoadOutMem := True;
       Break;
      End;
      PutTimer;
      Str := Spc(XW1);
     End;
     #128..#255 :
     Case ReadChar(Handle) of
      #192 : IncStr(Str,Chr);
       Else;
     End;
     Else IncStr(Str,Chr);
    End;
   End;
   If Not(Lst.AddStr(Str))Then  Begin LoadOutMem := True; Exit; End;
  End
   else
  Begin
   FS := FileSize(Handle);
   If(FileError <> 0)Then LoadOk := False;
   If(Mode = ViewGATT)Then
   Begin
    SetFilePos(Handle,FP);
    Str := GetFileTextLn(Handle);
    If(FileError <> 0)Then LoadOk := False;
    Inc(FP,Length(Str)+2);
    If(Str[1] = ':')Then
    Begin
     J := 2;
     SkipSpcInLine(J,Str); Val(ExtractDecNum(J,Str),XW1,Err);
     SkipSpcInLine(J,Str); Val(ExtractDecNum(J,Str),YW1,Err);
     SkipSpcInLine(J,Str); Val(ExtractDecNum(J,Str),XW2,Err);
     SkipSpcInLine(J,Str); Val(ExtractDecNum(J,Str),YW2,Err);
     SkipSpcInLine(J,Str);
     S2 := ExtractWord(J,Str);
     If(S2 = 'L')or(S2 = 'LEFT')Then PgNmIn := pLeft Else
     If(S2 = 'R')or(S2 = 'RIGHT')Then PgNmIn := pRight Else
     If(S2 = 'A')or(S2 = 'ALTERNATE')Then PgNmIn := pAlternate
				     Else PgNmIn := pNone;
     SkipSpcInLine(J,Str);
     S3 := ExtractDecNum(J,Str);
     If Not(S3 = '')Then PgNmStart := ValL(S3);
     AddSpc := False;
    End
     Else
    Begin
     AddSpc := True; XW1 := 10; XW2 := 70; FP := 0;
    End;
   End;
   Repeat
    SetFilePos(Handle,FP);
    Str := GetFileTextLn(Handle);
    If(FileError <> 0)Then
    Begin
     LoadOk := False;
     Break;
    End;
    Inc(FP,Length(Str)+2);
    SetTab(Str);
    If(AddSpc)and(Str <> '')Then Str := Spc(10) + Str;
    ChkMaxLen(Word(Length(Str)));
    If Not(Lst.AddStr(Str))Then
    Begin
     LoadOutMem := True;
     Break;
    End;
    PutTimer;
   Until (FP >= FS);
  End;
  Systems.Close(Handle);
 End
  Else
 Lst.AddStr('');
 PutBarXYM(StrMX,MaxLns+1,FS);
 If(Mode = ViewDefault)Then
 Begin
  PChr := Lst._GetBuf(0);
  If Not(PChr = NIL)Then
  Begin
   Str := StrUp(DelAllSpcLeft(StrPas(PChr)));
   If(PChr[0] = '{')Then Mode := ViewPas else
   If(PChr[0] = '(')and(PChr[1] = '*')Then Mode := ViewPas else
   If(CmpLeft(Str,'PROGRAM'))or(CmpLeft(Str,'UNIT'))or
     (CmpLeft(Str,'FUNCTION'))or(CmpLeft(Str,'PROCEDURE'))Then Mode := ViewPas;
  End;
 End;
{ If(StrMX > W.MaxXTxts)Then W.SetMatrix(_6x6);}
 UpDateScr;
 SetCur;
 PutBar;
 ActifScrSave := True;
End;

Function Edt.IsLoadOk;
Begin
 IsLoadOk := LoadOk;
End;

Function Edt.IsLoadOutMem;
Begin
 IsLoadOutMem := LoadOutMem;
End;

Procedure Edt.PutWn;
Begin
 W.Init(X1,Y1,X2,Y2);
 W.PushWn;
 Case Mode of
 ViewHlp: W.PutWn(_Title,CurrColors.Help.Wins);
     Else If(EditName = '')Then W.PutWn('Pasnom',CurrColors.Editor.Wins)
			   Else W.PutWn(EditName,CurrColors.Editor.Wins);
 End;
 W.CloseIcon;
 W.PutBarMsRight;
End;

Procedure Edt.PutBarXYM;
Var Colr:Byte;
Begin
 If(Mode = ViewHlp)Then
  W.SetEndBarTxtX(35,Str((_Y div (YW2-YW1))+1)+' Pages',W.XColrs.Title)
  Else
 Begin
  If(Mode = ViewPJ)Then Colr := $D5 Else Colr := CurrColors.Editor.Env.Pos;
  W.SetEndBarTxtX(35,Str(_X)+'x'+Str(_Y)+' : '+Str(Mem)+ ' octet(s)',Colr);
 End;
End;

Procedure Edt.PutBar;
Var Colr:Byte;
Begin
 Case Mode of
   ViewHlp: Colr := W.XColrs.Title;
       Else Colr := CurrColors.Editor.Env.BarInfo;
 End;
 W.SetEndBar(Colr);
 PutPos; W.SetEndBarTxtX(16,'³',Colr);
 PutIns; W.SetEndBarTxtX(23,'³',Colr);
 PutViewMode; W.SetEndBarTxtX(33,'³',Colr);
 PutBarXYM(StrMX,MaxLns+1,FS);
 Case Mode of
   ViewHlp: W.SetKrBorder;
       Else W.SetKr(CurrColors.Editor.Env.Default);
 End;
End;

Procedure Edt.PutViewMode;
Var S : String[15];
Begin
 If(Mode in [ViewHlp,ViewPJ])Then Exit;
 Case Mode of
  ViewAda : S := 'Ada';
  ViewAsm : S := 'Assembler';
  ViewBas : S := 'Basic';
  ViewC : S := 'C/C++';
  ViewCobol : S := 'Cobol';
  ViewEuphoria : S := 'Euphoria';
  ViewForth : S := 'Forth';
  ViewFortran : S := 'Fortran';
  ViewIni : S := 'Ini';
  ViewMsMnu : S := 'Mouse Mnu';
  ViewPas : S := 'Pascal';
  ViewPW : S := 'PW';
  ViewRC : S := 'Resource';
  ViewGAT : S := 'GATT';
  Else S := 'Normal';
 End;
 W.SetEndBarTxtX(24,StrUSpc(S,9),CurrColors.Editor.Env.Insert);
End;

Procedure Edt.Refresh;
Begin
 Case Mode of
 ViewHlp :
 W.PutWn(_Title,CurrColors.Help.Wins);
 Else
 If(EditName = '')Then W.PutWn('Pasnom',CurrColors.Editor.Wins)
		  Else W.PutWn(EditName,CurrColors.Editor.Wins);
 End;
 W.CloseIcon;
 W.PutBarMsRight;
 PutBar;
 UpDateScr;
End;

Procedure Edt.SetFormat;
Begin
 If(Mode = ViewGAT)Then If(SetFormatPage(XW1,YW1,XW2,YW2))Then
 Begin
  If(XW1 > 0)Then InsSpcIfHome(XW1);
 End;
End;

Procedure Edt.SetModified;
Var Colr:Byte;
Begin
 If(Mode = ViewHlp)Then Exit;
 Modified := True;
 If(Mode = ViewPJ)Then Colr := CurrColors.PersonalJournal.Env.Insert
		  Else Colr := CurrColors.Editor.Env.Modified;
 W.SetEndBarTxtX(15,'*',Colr);
End;

Procedure Edt.SetWn;
Begin
 PutWn(X1,Y1,X2,Y2);
 InitCoord;
 UpDateScr;
 PutBar;
End;

Procedure Edt.GattCenterTxt;
Var PChr:PChar; L:Word;
Begin
 If(XW2 < 65520)Then
 Begin
  PChr := Lst._GetBuf(P);
  While (PChr[0] = ' ') do StrDel(PChr,0,1);
  L := GetGATTLen(PChr);
  If(L > 0)Then
  Begin
   If((XW2-XW1) < L)Then Exit;
   InsSpcHome(StrLength(PChr),XW1 + ((XW2-XW1+1-L) shr 1),PChr);
  End;
 End;
End;

Procedure Edt.ViewMode;
Begin
 If Not(Mode = M)Then Mode := M;
End;

Procedure Edt.SetViewMode;
Begin
 If Not(Mode = M)Then
 Begin
  Mode := M;
  PutViewMode;
  UpDateScr;
  PutPos;
 End;
End;

Procedure Edt.SetChrType;
Begin
 ChrAttr := M;
End;

Function Edt.GetViewMode;
Begin
 GetViewMode := Mode;
End;

Function Edt.GetName;
Begin
 GetName := EditName;
End;

Procedure Edt.PutLn;
Var Size:Word; PChr:PChar;
Begin
 PChr := Lst.GetBuf(Line,Size);
 _PutLn(Size,I1,PChr);
End;

Procedure Edt._PutLn;
Var Str,UStr:String; I,J,K,XCmp:Word; Ok:Bool;

 Procedure PutChar(Chr:Char);
 Begin
  If(I >= I1)Then
  Begin
   If(ScrollLck)Then
   Begin
    If(I < XW1)or(I > XW2)Then W._SetCube(I-I1,W.RY,Chr,Not(W.RColr))
			  Else W.SetCube(I-I1,W.RY,Chr);
   End
    else
   W.SetCube(I-I1,W.RY,Chr);
  End;
 End;

 Procedure PutCharGAttr(Chr:Char;GAttr:Byte);
 Var Old : Byte;
 Begin
  If(I >= I1)Then
  Begin
   If(ScrollLck)Then
   Begin
    If(I < XW1)or(I > XW2)Then
    Begin
     Old := W.RColr;
     W.SetKr(Not(W.RColr));
     W.SetPos(I-I1,W.RY);
     W.PutChrGAttr(Chr,GAttr);
     W.RColr := Old;
    End
     Else
    Begin
     W.SetPos(I-I1,W.RY);
     W.PutChrGAttr(Chr,GAttr);
    End;
   End
    else
   Begin
    W.SetPos(I-I1,W.RY);
    W.PutChrGAttr(Chr,GAttr);
   End;
  End;
 End;

 Procedure PutText(Str:String);
 Var I2,I3 : Word;
 Begin
  If(I < I1)Then Exit;
  I2 := I - Word(Length(Str));
  If(I2 >= I1)Then
  Begin
   For I3 := I2 to I - 1 do
   Begin
    If(ScrollLck)Then
    Begin
     If(I3 < XW1)or(I3 > XW2)Then W._SetCube(I3-I1,W.RY,PChr[I3],Not(W.RColr))
			     Else W.SetCube(I3-I1,W.RY,PChr[I3]);
    End
     Else
    W.SetCube(I3-I1,W.RY,PChr[I3]);
   End;
  End
   Else
  Begin
   For I3 := I1 to I - 1 do
   Begin
    If(ScrollLck)Then
    Begin
     If(I3 < XW1)or(I3 > XW2)Then W._SetCube(I3-I1,W.RY,PChr[I3],Not(W.RColr))
			     Else W.SetCube(I3-I1,W.RY,PChr[I3]);
    End
     Else
    W.SetCube(I3-I1,W.RY,PChr[I3]);
   End;
  End;
 End;

 Procedure __Put;
 Begin
  PutChar(PChr[I]);
  Inc(I);
 End;

 Procedure SetColorDefault;
 Begin
  W.SetKr(CurrColors.Editor.Env.Default);
 End;

 Procedure SetColorRem;
 Begin
  W.SetKr(CurrColors.Editor.Env.Rem);
 End;

 Procedure SetColorResWord;
 Begin
  W.SetKr(CurrColors.Editor.Env.ResWord);
 End;

 Procedure PutCString;
 Begin
  J := I;
  W.SetKr(CurrColors.Editor.Env.Chars);
  __Put;
  While Not(PChr[I] = '"') do
  Begin
   If(PChr[I] = '\')Then
   Begin
    PutChar('\');
    Inc(I);
    If(PChr[I] = #0)Then Break;
    __Put;
   End
    Else
   Begin
    If(PChr[I] = #0)Then Break;
    __Put;
   End;
  End;
  If Not(PChr[I] = #0)Then __Put;
  SetColorDefault;
 End;

 Procedure PutAsmCString;
 Begin
  J := I;
  W.SetKr(CurrColors.Editor.Env.Chars);
  __Put;
  While Not(PChr[I] = '"') do
  Begin
   If(PChr[I] = #0)Then Break;
   __Put;
  End;
  If Not(PChr[I] = #0)Then __Put;
  SetColorDefault;
 End;

 Procedure PutPascalString;
 Begin
  J := I;
  W.SetKr(CurrColors.Editor.Env.Chars);
  __Put;
  While Not(PChr[I] = '''') do
  Begin
   If(PChr[I] = '''')Then
   Begin
    PutChar('''');
    Inc(I);
    If(PChr[I] = #0)Then Break;
    __Put;
   End
    Else
   Begin
    If(PChr[I] = #0)Then Break;
    __Put;
   End;
  End;
  If Not(PChr[I] = #0)Then __Put;
  SetColorDefault;
 End;

 Procedure PutCChar;
 Begin
  J := I;
  W.SetKr(CurrColors.Editor.Env.Chars);
  __Put;
  While Not(PChr[I] = '''') do
  Begin
   If(PChr[I] = #0)Then Break;
   __Put;
  End;
  If Not(PChr[I] = #0)Then __Put;
  SetColorDefault;
 End;

 Procedure PutSymbol;
 Begin
  W.SetKr(CurrColors.Editor.Env.Symbol);
  __Put;
  SetColorDefault;
 End;

 Procedure PutZ;
 Begin
  W.SetKr(CurrColors.Editor.Env.Z);
  PutChar('E');
  Inc(I);
  SetColorDefault;
 End;

Begin
 If Not(PChr = NIL)Then If(Size > I1)Then Case Mode of
  ViewAsm:
  Begin
   I := 0;
   While Not(PChr[I] = #0) do
   Begin
    Case PChr[I] of
     ';' :
     Begin
      SetColorRem;
      While Not(PChr[I] = #0) do __Put;
      SetColorDefault;
     End;
     '@',':',',','.','(',')','[',']','=','$',
     '+','-','#','!','&','*','%','/' :
     PutSymbol;
     '"' :
     PutAsmCString;
     '0'..'9' :
     Begin
      W.SetKr(CurrColors.Editor.Env.Number);
      __Put;
      While (PChr[I] in ['0'..'9','A'..'F','a'..'f']) do __Put;
      If(PChr[I] in ['B','b','O','o','H','h'])Then __Put;
      SetColorDefault;
     End;
     '''' :
     PutCChar;
     'A'..'Z','a'..'z','_' :
     Begin
      Str := PExtractWord(I,PChr);
      If IsReservedWordAsm(StrUp(Str))Then SetColorResWord
				      Else SetColorDefault;
      PutText(Str);
      SetColorDefault;
     End;
     ^Z :
     PutZ;
     Else
     __Put;
    End;
   End;
  End;
  ViewBasCoco3,ViewBasCK64,ViewBasAppleII,ViewBasVic20,ViewBas :
  Begin
   I := 0;
   While Not(PChr[I] = #0) do
   Begin
    Case PChr[I] of
     '0'..'9' :
     Begin
      W.SetKr(CurrColors.Editor.Env.Number);
      __Put;
      While (PChr[I] in ['0'..'9']) do __Put;
      SetColorDefault;
     End;
     '&' :
     Begin
      W.SetKr(CurrColors.Editor.Env.Number);
      __Put;
      Case PChr[I] of
       'H' : Begin
	      __Put;
	      While (PChr[I] in ['0'..'9','A'..'F','a'..'f']) do __Put;
	     End;
       'O' : Begin
	      __Put;
	      While (PChr[I] in ['0'..'7']) do __Put;
	     End;
       'B' : Begin
	      __Put;
	      While (PChr[I] in ['0'..'1']) do __Put;
	     End;
      End;
      SetColorDefault;
     End;
     '''' :
     Begin
      SetColorRem;
      While Not(PChr[I] = #0) do __Put;
      SetColorDefault;
     End;
     'A'..'Z','a'..'z','_' :
     Begin
      J := I; Str := ''; XCmp := 0;
      While (PChr[I] in ['A'..'Z','a'..'z']) do
      Begin
       IncStr(Str,PChr[I]);
       Inc(I);
       If(PChr[I] = '$')Then
       Begin
	IncStr(Str,PChr[I]);
	Inc(I);
	Break;
       End;
      End;
      UStr := StrUp(Str);
      Ok := False;
      If(XCmpLeft(UStr,'REM'))Then
      Begin
       I := J;
       SetColorRem;
       While Not(PChr[I] = #0) do __Put;
       SetColorDefault;
      End
       Else
      Begin
       Case UStr[1] of
	'A' : Ok := ((XCmpLeft(UStr,'ABS'))or(XCmpLeft(UStr,'ASC'))or
		     (XCmpLeft(UStr,'ATN')));
	'B' : Ok := ((XCmpLeft(UStr,'BRK'))or
		     (XCmpLeft(UStr,'BUTTON')));
	'C' : Ok := ((XCmpLeft(UStr,'CDBL'))or(XCmpLeft(UStr,'CHR$'))or
		     (XCmpLeft(UStr,'CINT'))or(XCmpLeft(UStr,'COM'))or
		     (XCmpLeft(UStr,'COS'))or(XCmpLeft(UStr,'CSNG'))or
		     (XCmpLeft(UStr,'CSRLIN'))or(XCmpLeft(UStr,'CVD'))or
		     (XCmpLeft(UStr,'CVI'))or(XCmpLeft(UStr,'CVS')));
	'D' : Ok := ((XCmpLeft(UStr,'DATE$'))or(XCmpLeft(UStr,'DBL')));
	'E' : Ok := ((XCmpLeft(UStr,'EOF'))or(XCmpLeft(UStr,'ERLIN'))or
		     (XCmpLeft(UStr,'ERNO'))or(XCmpLeft(UStr,'ERR'))or
		     (XCmpLeft(UStr,'EXP')));
	'F' : Ok := ((XCmpLeft(UStr,'FIX'))or(XCmpLeft(UStr,'FRE')));
	'H' : Ok := ((XCmpLeft(UStr,'HEX$'))or(XCmpLeft(UStr,'HPOINT')));
	'I' : Ok := ((XCmpLeft(UStr,'INKEY$'))or(XCmpLeft(UStr,'INP'))or
		     (XCmpLeft(UStr,'INSTR'))or(XCmpLeft(UStr,'INT')));
	'J' : Ok := ((XCmpLeft(UStr,'JOYSTK')));
	'L' : Ok := ((XCmpLeft(UStr,'LEFT$'))or(XCmpLeft(UStr,'LEN'))or
		     (XCmpLeft(UStr,'LOC'))or(XCmpLeft(UStr,'LOF'))or
		     (XCmpLeft(UStr,'LOG'))or(XCmpLeft(UStr,'LPEEK'))or
		     (XCmpLeft(UStr,'LPOS')));
	'M' : Ok := ((XCmpLeft(UStr,'MEM'))or(XCmpLeft(UStr,'MID$'))or
		     (XCmpLeft(UStr,'MKD$'))or(XCmpLeft(UStr,'MKI$'))or
		     (XCmpLeft(UStr,'MKS$')));
	'O' : Ok := ((XCmpLeft(UStr,'OCT$')));
	'P' : Ok := ((XCmpLeft(UStr,'PEEK'))or(XCmpLeft(UStr,'PMAP'))or
		     (XCmpLeft(UStr,'POINT'))or(XCmpLeft(UStr,'POS'))or
		     (XCmpLeft(UStr,'PPOINT')));
	'R' : Ok := ((XCmpLeft(UStr,'RIGHT$'))or(XCmpLeft(UStr,'RND')));
	'S' : Ok := ((XCmpLeft(UStr,'SGN'))or(XCmpLeft(UStr,'SIN'))or
		     (XCmpLeft(UStr,'SPC'))or(XCmpLeft(UStr,'SQR'))or
		     (XCmpLeft(UStr,'STR$'))or(XCmpLeft(UStr,'STRIG'))or
		     (XCmpLeft(UStr,'STRING$')));
	'T' : Ok := ((XCmpLeft(UStr,'TAB'))or(XCmpLeft(UStr,'TAN'))or
		     (XCmpLeft(UStr,'TIME$'))or(XCmpLeft(UStr,'TIMER')));
	'U' : Ok := ((XCmpLeft(UStr,'USR')));
	'V' : Ok := ((XCmpLeft(UStr,'VAL'))or(XCmpLeft(UStr,'VARPTR$'))or
		     (XCmpLeft(UStr,'VARPTR')));
       End;
       If(Ok)Then
       Begin
	W.SetKr((CurrColors.Editor.Env.Normal and $F0)+$7);
	I := J + XCmp;
	PutText(CopyStr(Str,1,XCmp));
	SetColorDefault;
       End
	Else
       Begin
	If(XCmpLeft(UStr,'ATTR'))Then
	Begin
	 SetColorDefault;
	 I := J + XCmp;
	 PutText(CopyStr(Str,1,XCmp));
	End
	 Else
	Begin
	 Case UStr[1] of
	  'A' : Ok := ((XCmpLeft(UStr,'AND'))or(XCmpLeft(UStr,'AT')));
	  'B' : Ok := ((XCmpLeft(UStr,'BASE')));
	  'C' : Ok := ((XCmpLeft(UStr,'CALL'))or(XCmpLeft(UStr,'CASE'))or
		       (XCmpLeft(UStr,'CHAIN'))or(XCmpLeft(UStr,'COMMON')));
	  'D' : Ok := ((XCmpLeft(UStr,'DATA'))or(XCmpLeft(UStr,'DIM'))or
		       (XCmpLeft(UStr,'DO'))or(XCmpLeft(UStr,'DYNAMIC')));
	  'E' : Ok := ((XCmpLeft(UStr,'ELSE'))or(XCmpLeft(UStr,'END'))or
		       (XCmpLeft(UStr,'ERASE')));
	  'F' : Ok := ((XCmpLeft(UStr,'FOR')));
	  'G' : Ok := ((XCmpLeft(UStr,'GOSUB'))or(XCmpLeft(UStr,'GOTO')));
	  'I' : Ok := ((XCmpLeft(UStr,'IF'))or(XCmpLeft(UStr,'INTERRUPT')));
	  'L' : Ok := ((XCmpLeft(UStr,'LOOP')));
	  'O' : Ok := ((XCmpLeft(UStr,'ON'))or(XCmpLeft(UStr,'OPTION'))or
		       (XCmpLeft(UStr,'OR')));
	  'N' : Ok := ((XCmpLeft(UStr,'NEXT'))or(XCmpLeft(UStr,'NOT')));
	  'R' : Ok := ((XCmpLeft(UStr,'RUN')));
	  'S' : Ok := ((XCmpLeft(UStr,'SELECT'))or(XCmpLeft(UStr,'STEP'))or
		       (XCmpLeft(UStr,'STOP'))or(XCmpLeft(UStr,'SUB')));
	  'T' : Ok := ((XCmpLeft(UStr,'THEN'))or(XCmpLeft(UStr,'TO'))or
		       (XCmpLeft(UStr,'TROFF'))or(XCmpLeft(UStr,'TRON')));
	  'W' : Ok := ((XCmpLeft(UStr,'WEND'))or(XCmpLeft(UStr,'WHILE')));
	  'X' : Ok := ((XCmpLeft(UStr,'XOR')));
	 End;
	 If(Ok)Then
	 Begin
	  SetColorResWord;
	  I := J + XCmp;
	  PutText(CopyStr(Str,1,XCmp));
	  SetColorDefault;
	 End
	  Else
	 Begin
	  Case UStr[1] of
	   'A' : Ok := ((XCmpLeft(UStr,'APPEN'))or(XCmpLeft(UStr,'AUDIO'))or
			(XCmpLeft(UStr,'AUTO')));
	   'B' : Ok := ((XCmpLeft(UStr,'BEEP'))or(XCmpLeft(UStr,'BLOAD'))or
			(XCmpLeft(UStr,'BRU'))or(XCmpLeft(UStr,'BSAVE')));
	   'C' : Ok := ((XCmpLeft(UStr,'CATALOG'))or(XCmpLeft(UStr,'CHDIR'))or
			(XCmpLeft(UStr,'CIRCLE'))or(XCmpLeft(UStr,'CLEAR'))or
			(XCmpLeft(UStr,'CLOADM'))or(XCmpLeft(UStr,'CLOAD'))or
			(XCmpLeft(UStr,'CLOSE'))or(XCmpLeft(UStr,'CLS'))or
			(XCmpLeft(UStr,'COLOR'))or(XCmpLeft(UStr,'CONT'))or
			(XCmpLeft(UStr,'CSAVEM'))or(XCmpLeft(UStr,'CSAVE')));
	   'D' : Ok := ((XCmpLeft(UStr,'DEF'))or(XCmpLeft(UStr,'DELETE'))or
			(XCmpLeft(UStr,'DEL'))or(XCmpLeft(UStr,'DRAW')));
	   'E' : Ok := ((XCmpLeft(UStr,'EDIT'))or(XCmpLeft(UStr,'ERROR'))or
			(XCmpLeft(UStr,'EXEC')));
	   'F' : Ok := ((XCmpLeft(UStr,'FIELD'))or(XCmpLeft(UStr,'FILES'))or
			(XCmpLeft(UStr,'FLASH')));
	   'G' : Ok := ((XCmpLeft(UStr,'GET'))or(XCmpLeft(UStr,'GR')));
	   'H' : Ok := ((XCmpLeft(UStr,'HBUFF'))or(XCmpLeft(UStr,'HCIRCLE'))or
			(XCmpLeft(UStr,'HCLS'))or(XCmpLeft(UStr,'HCOLOR'))or
			(XCmpLeft(UStr,'HDRAW'))or(XCmpLeft(UStr,'HGET'))or
			(XCmpLeft(UStr,'HGR'))or(XCmpLeft(UStr,'HLINE'))or
			(XCmpLeft(UStr,'HLIN'))or(XCmpLeft(UStr,'HOME'))or
			(XCmpLeft(UStr,'HPAINT'))or(XCmpLeft(UStr,'HPLOT'))or
			(XCmpLeft(UStr,'HPRINT'))or(XCmpLeft(UStr,'HPUT'))or
			(XCmpLeft(UStr,'HRESET'))or(XCmpLeft(UStr,'HSCREEN'))or
			(XCmpLeft(UStr,'HSET'))or(XCmpLeft(UStr,'HSTAT'))or
			(XCmpLeft(UStr,'HTAB')));
	   'I' : Ok := ((XCmpLeft(UStr,'INPUT'))or(XCmpLeft(UStr,'INTERRUPT'))or
			(XCmpLeft(UStr,'INVERSE')));
	   'K' : Ok := ((XCmpLeft(UStr,'KEY'))or(XCmpLeft(UStr,'KILL')));
	   'L' : Ok := ((XCmpLeft(UStr,'LET'))or(XCmpLeft(UStr,'LINE'))or
			(XCmpLeft(UStr,'LIST'))or(XCmpLeft(UStr,'LLIST'))or
			(XCmpLeft(UStr,'LOAD'))or(XCmpLeft(UStr,'LOCATE'))or
			(XCmpLeft(UStr,'LOCK'))or(XCmpLeft(UStr,'LOOP'))or
			(XCmpLeft(UStr,'LPOKE'))or(XCmpLeft(UStr,'LPRINT'))or
			(XCmpLeft(UStr,'LSET')));
	   'M' : Ok := ((XCmpLeft(UStr,'MAXFILE'))or(XCmpLeft(UStr,'MERGE'))or
			(XCmpLeft(UStr,'MKDIR'))or(XCmpLeft(UStr,'MOTOR'))or
			(XCmpLeft(UStr,'MO')));
	   'N' : Ok := ((XCmpLeft(UStr,'NAME'))or(XCmpLeft(UStr,'NEW'))or
			(XCmpLeft(UStr,'NOMO'))or(XCmpLeft(UStr,'NORMAL'))or
			(XCmpLeft(UStr,'NOTRACE')));
	   'O' : Ok := ((XCmpLeft(UStr,'OPEN'))or(XCmpLeft(UStr,'OUT')));
	   'P' : Ok := ((XCmpLeft(UStr,'PAINT'))or(XCmpLeft(UStr,'PALETTE'))or
			(XCmpLeft(UStr,'PCLEAR'))or(XCmpLeft(UStr,'PCLS'))or
			(XCmpLeft(UStr,'PCOPY'))or(XCmpLeft(UStr,'PLAY'))or
			(XCmpLeft(UStr,'PLOT'))or(XCmpLeft(UStr,'PMODE'))or
			(XCmpLeft(UStr,'POKE'))or(XCmpLeft(UStr,'POP'))or
			(XCmpLeft(UStr,'POSITION'))or(XCmpLeft(UStr,'PRESET'))or
			(XCmpLeft(UStr,'PRINT'))or(XCmpLeft(UStr,'PSET'))or
			(XCmpLeft(UStr,'PUT')));
	   'R' : Ok := ((XCmpLeft(UStr,'RANDOMIZE'))or(XCmpLeft(UStr,'READ'))or
			(XCmpLeft(UStr,'RECALL'))or(XCmpLeft(UStr,'RENAME'))or
			(XCmpLeft(UStr,'RENUM'))or(XCmpLeft(UStr,'RESET'))or
			(XCmpLeft(UStr,'RESTORE'))or(XCmpLeft(UStr,'RESUME'))or
			(XCmpLeft(UStr,'RETURN'))or(XCmpLeft(UStr,'RMDIR'))or
			(XCmpLeft(UStr,'RSET')));
	   'S' : Ok := ((XCmpLeft(UStr,'SAVE'))or(XCmpLeft(UStr,'SCREEN'))or
			(XCmpLeft(UStr,'SET'))or(XCmpLeft(UStr,'SHELL'))or
			(XCmpLeft(UStr,'SHLOAD'))or(XCmpLeft(UStr,'SKIPF'))or
			(XCmpLeft(UStr,'SOUND'))or(XCmpLeft(UStr,'STOP'))or
			(XCmpLeft(UStr,'STORE'))or(XCmpLeft(UStr,'SWAP'))or
			(XCmpLeft(UStr,'SYSTEM'))or(XCmpLeft(UStr,'SYS')));
	   'T' : Ok := ((XCmpLeft(UStr,'TRACE')));
	   'U' : Ok := ((XCmpLeft(UStr,'UNLOCK'))or(XCmpLeft(UStr,'USING')));
	   'V' : Ok := ((XCmpLeft(UStr,'VERIFY'))or(XCmpLeft(UStr,'VIEW'))or
			(XCmpLeft(UStr,'VLIN'))or(XCmpLeft(UStr,'VTAB')));
	   'W' : Ok := ((XCmpLeft(UStr,'WAIT'))or(XCmpLeft(UStr,'WIDTH'))or
			(XCmpLeft(UStr,'WINDOW'))or(XCmpLeft(UStr,'WRITE')));
	   'X' : Ok := ((XCmpLeft(UStr,'XDRAW')));
	  End;
	  If(Ok)Then
	  Begin
	   SetColorDefault;
	   I := J + XCmp;
	   PutText(CopyStr(Str,1,XCmp));
	  End
	   Else
	  Begin
	   W.SetKr(CurrColors.Editor.Env.AsmInst);
	   PutText(Str);
	   SetColorDefault;
	  End;
	 End;
	End;
       End;
      End;
      Continue;
     End;
     '%','$' :
     Begin
      W.SetKr(CurrColors.Editor.Env.AsmInst);
      __Put;
      SetColorDefault;
     End;
     '[',']','(',')',',',';','^','-','+','=',':','*','/','<','>','\' :
     PutSymbol;
     '"' :
     PutAsmCString;
     ^Z :
     PutZ;
     Else
     __Put;
    End;
   End;
  End;
  ViewRC,ViewC :
  Begin
   I := 0;
   While Not(PChr[I] = #0) do
   Begin
    Case PChr[I] of
     '/' :
     Begin
      Case PChr[I+1] of
       '/' : Begin
	      SetColorRem;
	      While Not(PChr[I] = #0) do __Put;
	     End;
       '*' : Begin
	      SetColorRem;
	      Inc(I,Length('/*'));
	      PutText('/*');
	      While Not(PChr[I] = #0) do
	      Begin
	       If(PChr[I] = '*')and(PChr[I+1] = '/')Then
	       Begin
		Inc(I,Length('*/'));
		PutText('*/');
		Break;
	       End;
	       __Put;
	      End;
	     End;
	Else Begin
	      W.SetKr(CurrColors.Editor.Env.Symbol);
	      __Put;
	     End;
      End;
      SetColorDefault;
     End;
     'A'..'Z','a'..'z','_' :
     Begin
      Str := PExtractWord(I,PChr);
      If(Mode = ViewC)Then
      Begin
       If(Str = 'asm')Then
       Begin
	SetColorResWord;
	PutText(Str);
	W.SetKr(CurrColors.Editor.Env.AsmInst);
	While Not(PChr[I] = #0) do __Put;
	SetColorDefault;
       End
	Else
       Begin
	If(IsReservedWordC(Str))Then SetColorResWord Else SetColorDefault;
	PutText(Str);
	SetColorDefault;
       End;
      End
       else
      Begin
       If(Str = 'BEGIN')or(Str = 'END')or(Str = 'MENU')or(Str = 'MENUITEM')or
	 (Str = 'POPUP')or(Str = 'SEPARATOR')Then SetColorResWord
					     Else SetColorDefault;
       PutText(Str);
       SetColorDefault;
      End;
     End;
     '0'..'9' :
     Begin
      If(I > 0)and(PChr[I-1] in ['A'..'Z','a'..'z','_'])Then
       W.PutTxt(PExtractCNum(I,PChr))
       Else
      Begin
       W.SetKr(CurrColors.Editor.Env.Number);
       PutText(PExtractCNum(I,PChr));
       SetColorDefault;
      End;
     End;
     '{','}' :
     Begin
      SetColorResWord;
      __Put;
      SetColorDefault;
     End;
     '[',']','(',')',',','.',';','|','^','$','?','-','+','=',
     ':','*','%','!','~','&','<','>','\' :
     PutSymbol;
     '#' :
     Begin
      SetColorRem;
      J := I;
      While Not(PChr[I] in [#0..' ']) do __Put;
      SetColorDefault;
     End;
     '"' :
     PutCString;
     '''' :
     PutCChar;
     ^Z :
     PutZ;
     Else
     __Put;
    End;
   End;
  End;
  ViewEuphoria :
  Begin
   I := 0;
   While Not(PChr[I] = #0) do
   Begin
    Case PChr[I] of
     '-' :
     Begin
      If(PChr[I+1] = '-')Then
      Begin
       SetColorRem;
       While Not(PChr[I] = #0) do __Put;
       SetColorDefault;
      End
       Else
      Begin
       W.SetKr(CurrColors.Editor.Env.Symbol);
       __Put;
       SetColorDefault;
      End;
     End;
     '"' :
     PutCString;
     '''' :
     PutCChar;
     '@',':',',','.','(',')','[',']','<','>','=',
     '+','#','!','&','*','%','/','{','}' :
     PutSymbol;
     '0'..'9' :
     Begin
      W.SetKr(CurrColors.Editor.Env.Number);
      __Put;
      While (PChr[I] in ['0'..'9','A'..'F','a'..'f']) do __Put;
      SetColorDefault;
     End;
     'A'..'Z','a'..'z','_' :
     Begin
      Str := Language.PExtractWord(I,PChr);
      UStr := StrUp(Str);
      If(UStr = 'INCLUDE')Then
      Begin
       SetColorResWord;
       PutText(Str);
       W.SetKr(CurrColors.Editor.Env.Chars);
       While Not(PChr[I] = #0) do __Put;
       SetColorDefault;
      End
       Else
      If IsReservedWordEuphoria(UStr)Then
      Begin
       SetColorResWord;
       PutText(Str);
       SetColorDefault;
      End
       Else
      Begin
       SetColorDefault;
       PutText(Str);
       SetColorDefault;
      End;
     End;
     ^Z :
     PutZ;
     Else
     __Put;
    End;
   End;
  End;
  ViewFortran :
  Begin
   I := 0;
   While Not(PChr[I] = #0) do
   Begin
    Case PChr[I] of
     '*' :
     Begin
      If(I = 0)Then
      Begin
       SetColorRem;
       While Not(PChr[I] = #0) do __Put;
       SetColorDefault;
      End
       Else
      PutSymbol;
     End;
     '0'..'9' :
     Begin
      W.SetKr(CurrColors.Editor.Env.Number);
      __Put;
      SetColorDefault;
     End;
     ^Z :
     PutZ;
     Else
     __Put;
    End;
   End;
  End;
  ViewPas :
  Begin
   I := 0;
   While Not(PChr[I] = #0) do
   Begin
    Case PChr[I] of
     '{' :
     Begin
      SetColorRem;
      While Not(PChr[I] in [#0,'}']) do __Put;
      If(PChr[I] = '}')Then __Put;
      SetColorDefault;
     End;
     '(' :
     Begin
      If(PChr[I+1] = '*')Then
      Begin
       SetColorRem;
       Inc(I,Length('(*'));
       PutText('(*');
       While Not(PChr[I] = #0) do
       Begin
	If(PChr[I] = '*')and(PChr[I+1] = ')')Then
	Begin
	 Inc(I,Length('*)'));
	 PutText('*)');
	 Break;
	End;
	__Put;
       End;
      End
       Else
      PutSymbol;
     End;
     '[',']','\','/','-','<','>','*','+','-','^',
     '&',')','.',',','?','=','%','@',':',';' :
     PutSymbol;
     '#' :
     Begin
      W.SetKr(CurrColors.Editor.Env.Chars);
      __Put;
      Case PChr[I] of
       '$' : Begin
	      __Put;
	      While (PChr[I] in ['0'..'9','A'..'F','a'..'f']) do __Put;
	     End;
	Else While (PChr[I] in ['0'..'9']) do __Put;
      End;
      SetColorDefault;
     End;
     '$' :
     Begin
      W.SetKr(CurrColors.Editor.Env.Number);
      __Put;
      While (PChr[I] in ['0'..'9','A'..'F','a'..'f']) do __Put;
      SetColorDefault;
     End;
     '0'..'9' :
     Begin
      W.SetKr(CurrColors.Editor.Env.Number);
      __Put;
      SetColorDefault;
     End;
     '''' :
     PutPascalString;
     'A'..'Z','a'..'z','_' :
     Begin
      Str := PExtractWord(I,PChr);
      If(IsReservedWordPascal(StrUp(Str)))Then SetColorResWord
					  Else SetColorDefault;
      PutText(Str);
      SetColorDefault;
     End;
     ^Z :
     PutZ;
     Else
     __Put;
    End;
   End;
  End;
  ViewHlp,
  ViewGAT :
  Begin
   Case Mode of
    ViewHlp : W.SetKrBorderF($7);
	 Else W.SetKr((CurrColors.Editor.Env.Normal and $F0)+$7);
   End;
   I := 0; K := 0;
   While Not(PChr[K] = #0) do
   Begin
    Case PChr[K] of
     #1..#31 : { Attr ? }
     Begin
      Inc(K);
      If Not(PChr[K] = #0)Then
      Begin
       W.PutChrGAttr(PChr[K],Byte(PChr[K-1]));
       If IsDbl(PChr[K-1])Then Inc(I);
       Inc(K);
       Inc(I);
      End;
     End;
     Else Begin
      PutChar(PChr[K]);
      Inc(I); Inc(K);
     End;
    End;
   End;
  End;
  Else Begin
   W.SetKr(CurrColors.Editor.Env.Normal);
   If(ScrollLck)Then
   Begin
    I := 0; Str := '';
    While Not(PChr[I] = #0) do
    Begin
     If(Length(Str) < 250)Then IncStr(Str,PChr[I])
      Else
     Begin
      PutText(Str);
      Str := '';
     End;
     Inc(I);
    End;
    If(I > 0)Then PutText(Str);
   End
    Else
   W.PutPTxtXY2(0,W.RY,I1,PChr);
  End;
 End;
 W.ClrEol;
 W.Ln;
End;

Function Edt.MaxLns;
Begin
 MaxLns := Lst.MaxBuf;
End;

Procedure Edt.PutPos;
Var S:String; Colr:Byte;
Begin
 Case Mode of
 ViewHlp: Colr := W.XColrs.Title;
     Else Colr := CurrColors.Editor.Env.Pos;
 End;
 If(Mode in [ViewHlp,ViewGatt])Then
  S := Str((P div (YW2-YW1))+1) + ':(' +Str(PX+1) + ',' + Str((P mod (YW2-YW1))+1) + ')'
 Else
  S := '(' + Str(PX+1) + ',' + Str(P+1) + ')';
 W.SetEndBarTxtX(0,Spc(15-Length(S))+S,Colr);
End;

Procedure Edt.PutIns;
Var Colr:Byte;
Begin
 Case Mode of
 ViewHlp: Colr := W.XColrs.Title;
     Else Colr := CurrColors.Editor.Env.Insert;
 End;
 If(InsMode)Then W.SetEndBarTxtX(17,'I',Colr)
	    Else W.SetEndBarTxtX(17,' ',Colr);
 If(ScrollLck)Then W.SetEndBarTxtX(18,'S',Colr)
	      Else W.SetEndBarTxtX(18,' ',Colr);
 If(DrawMode)Then W.SetEndBarTxtX(19,'D',Colr)
	     Else W.SetEndBarTxtX(19,' ',Colr);
 If(ReadOnly)Then W.SetEndBarTxtX(20,'L',Colr)
	     Else W.SetEndBarTxtX(20,' ',Colr);
End;

Procedure Edt.PutScrollLck;
Var Colr:Byte;
Begin
 Case Mode of
  ViewHlp: Colr := W.XColrs.Title;
      Else Colr := CurrColors.Editor.Env.Insert;
 End;
 ScrollLck := GetScrollLock;
 If(ScrollLck)Then W.SetEndBarTxtX(18,'S',Colr)
	      Else W.SetEndBarTxtX(18,' ',Colr);
End;

Procedure Edt.kPgUp;
Begin
 If(P > W.MaxYTxts)Then
 Begin
  Dec(P,W.MaxYTxts);
  PutPos;
  UpDateScr;
 End
  else
 Begin
  If(P = Y)Then
  Begin
   P := 0; Y := 0;
   SetCur;
  End
   Else
  P := Y;
  PutPos;
  UpDateScr;
 End;
End;

Procedure Edt.kPgDn;
Begin
 If(P+W.MaxYTxts <= Lst.NmBuf)Then
 Begin
  Inc(P,W.MaxYTxts);
  PutPos;
  UpDateScr;
 End;
End;

Procedure Edt.UpDatePXGWithX;
Begin
 If(Mode = ViewGAT)Then PXG := PosX2Gatt(Lst._GetBuf(P),_X) Else PXG := _X;
End;

Procedure Edt.kHome;
Begin
 If(ScrollLck)Then
 Begin
  If(XW1 > W.MaxXTxts)Then X := W.MaxXTxts Else X := XW1;
  PX := XW1;
  If(Mode = ViewGAT)Then PXG := PosX2Gatt(Lst._GetBuf(P),XW1);
 End
  else
 Begin
  X := 0; PX := 0; PXG := 0;
 End;
 PutPos;
 UpDateScr;
 SetCur;
End;

Procedure Edt.kEnd;
Var L:Word; PChr:PChar;
Begin
 PChr := Lst._GetBuf(P);
 If(Mode = ViewGAT)Then L := GetGATTLen(PChr)
		   Else L := StrLength(PChr);
 If(ScrollLck)Then
 Begin
  If(L < XW1)Then L := XW1;
  If(L > XW2)Then L := XW2;
 End;
 If(L < W.MaxXTxts)Then X := L else X := W.MaxXTxts;
 PX := L;
 If(Mode = ViewGAT)Then
 Begin
  If(ScrollLck)Then PXG := PosX2Gatt(PChr,PX)
	       Else PXG := StrLength(PChr);
 End;
 PutPos;
 UpDateScr;
 SetCur;
End;

Procedure Edt.kUp;
Begin
 If(P > 0)Then
 Begin
  Dec(P);
  PutPos;
  If(Y > 0)Then Dec(Y)
   else
  Begin
   W._ScrollUp;
   PutLn(PX-X,P);
  End;
  If(Mode = ViewGatt)Then PXG := PosX2Gatt(Lst._GetBuf(P),PX);
  SetCur;
 End;
End;

Procedure Edt.kDn;
Begin
 If(P < MaxLns)Then
 Begin
  Inc(P);
  PutPos;
  If(Y < W.MaxYTxts)Then Inc(Y)
   Else
  Begin
   W._ScrollDn;
   PutLn(PX-X,P);
  End;
  If(Mode = ViewGatt)Then PXG := PosX2Gatt(Lst._GetBuf(P),PX);
  SetCur;
 End;
End;

Procedure Edt.kLeft;
Var PChr:PChar; BiChar,Double:Bool;
Begin
 If(Mode = ViewGAT)Then
 Begin
  If(GetScrollLock)Then
  Begin
   If(PX > XW1)Then
   Begin
    PChr := Lst._GetBuf(P); Dec(PXG);
    BiChar := (PXG > 0)and(PChr[PXG] < ' '); Double := IsDbl(PChr[PXG]);
    If(BiChar)Then Dec(PXG);
    If(BiChar)and(Double)Then
    Begin
     Dec(PX,2);
     If(X > 1)Then Dec(X,2)
      Else
     Begin
      X := 0;
      UpDateScr;
     End;
    End
     Else
    Begin
     Dec(PX);
     If(X > 0)Then Dec(X) Else UpDateScr;
    End;
    PutPos;
    SetCur;
   End;
  End
   else
  Begin
   If(PX > 0)Then
   Begin
    PChr := Lst._GetBuf(P); Dec(PXG); BiChar := (PChr[PXG] < ' ');
    Double := IsDbl(PChr[PXG]);
    If(BiChar)Then Dec(PXG);
    If(BiChar)and(Double)Then
    Begin
     If(PX > 1)Then Dec(PX,2) Else PX := 0;
     If(X > 1)Then Dec(X,2)
      Else
     Begin
      X := 0;
      UpDateScr;
     End;
    End
     Else
    Begin
     Dec(PX);
     If(X > 0)Then Dec(X) Else UpDateScr;
    End;
    PutPos;
    SetCur;
   End;
  End;
 End
  Else
 Begin
  If(GetScrollLock)Then
  Begin
   If(PX > XW1)Then
   Begin
    Dec(PX);
    PutPos;
    If(X > 0)Then Dec(X) Else UpDateScr;
    SetCur;
   End;
  End
   else
  Begin
   If(PX > 0)Then
   Begin
    Dec(PX);
    PutPos;
    If(X > 0)Then Dec(X) Else UpDateScr;
    SetCur;
   End;
  End;
 End;
End;

Function Edt.SaveAs;
Var Handle,L:Word; I,M:Long; PChr:PChar;
Begin
 If(Path = '')Then
 Begin
  Case Mode of
ViewRC: Path := SetPath4AddFile(StrPas(PathResource)) + StrPas(ExtRC);
ViewPas: Path := SetPath4AddFile(StrPas(PathPas)) + StrPas(ExtPas);
ViewFortran: Path := SetPath4AddFile(StrPas(PathFortran)) + StrPas(ExtFortran);
ViewForth: Path := SetPath4AddFile(StrPas(PathForth)) + '*.*';
ViewEuphoria: Path := SetPath4AddFile(StrPas(PathEuphoria)) + StrPas(ExtEuphoria);
ViewCobol: Path := SetPath4AddFile(StrPas(PathCobol)) + '*.*';
ViewC: Path := SetPath4AddFile(StrPas(PathC)) + StrPas(ExtC);
ViewBas: Path := SetPath4AddFile(StrPas(PathBas)) + StrPas(ExtBas);
ViewAsm: Path := SetPath4AddFile(StrPas(PathAsm)) + StrPas(ExtAsm);
ViewAda: Path := SetPath4AddFile(StrPas(PathAda)) + '*.*';
ViewGatt: Path := SetPath4AddFile(StrPas(PathGatt)) + '*.GAT';
Else Path := '';
  End;
  Path := OpenWin(Path,'Sauvegarde sous');
 End;
 If(EditName <> Path)Then { Existe toujours ? }
 Begin
  If(FileExist(Path))Then
  Begin
   If Not(__InputOverwriteFile)Then Exit;
   EditName := StrUp(Path);
  End;
 End;
 If(FileExist(Path))Then
 Begin
  Del(Path2NoExt(Path)+'.BAK');
  Rename(Path,Path2NoExt(Path)+'.BAK');
 End;
 Handle := New(Path);
 If(IsHandleErr(Handle))Then Exit;
 Lst.SetPtr(0);
 If(Mode = ViewGAT)Then
 Begin
  PutFileText(Handle,': '+Str(XW1)+' '+Str(YW1)+' '+Str(XW2)+' '+Str(YW2)+' ');
  Case PgNmIn of
	pLeft: PutFileText(Handle,'L');
       pRight: PutFileText(Handle,'R');
   pAlternate: PutFileText(Handle,'A');
	  Else PutFileText(Handle,'N');
  End;
  PutFileTextLn(Handle,' ' + Str(Long(PgNmStart)));
 End;
 M := MaxLns;
 For I := 0 to M do
 Begin
  PChr := Lst._GetCurrBuf; L := StrLength(PChr);
  If(L > 0)Then _SetRec(Handle,L,PChr[0]);
  If(I < M)Then PutFileLn(Handle);
  Lst.Next;
 End;
 Close(Handle);
 Modified := False;
 PutBar;
 If(EditName = '')Then
 Begin
  EditName := StrUp(Path);
  W.SetTitle(EditName,W.XColrs.Title);
 End;
End;

Procedure Edt.Prn;
Var J,EndJ,BeginJ,NC:Long; H,I,K,L,PL,JN,NumSpc,IS,HP,YWM:Word;
    BitsPerSpc,BitsPerSpcR,BitsPerChar,PageLen:Byte;
    Gras,Underline,Inverse,_Italic,Justify,OnlySpc:Bool;
    Info:InfoPrintRec; PChr:PChar; OldPg,Pg:Long; LL:Wins;

 Procedure PrnPageNm;
 Var _P:Word;
 Begin
  _P := 1 + Info.AddPage + (J div YWM);
  If(Info.Page = Left)or((Info.Page = Altern)and((_P and 1) = 1))Then
  Begin
   Printers.Prn(Spc(XW2+3));
   __SetPrnDbl;
   Printers.Prn(Str(_P))
  End
   Else
  Begin
   Printers.Prn(Spc(3));
   __SetPrnDbl;
   Printers.Prn(Str(_P));
  End;
  __SetPrnSimple;
 End;

Begin
 If(InitPrn)Then
 Begin
  If(Mode in [ViewHlp,ViewGAT])Then
  Begin
   PageLen := 66; YWM := (YW2-YW1); Info.NumCopy := 1; Info.StartPage := 1;
   Info.EndPage := (MaxLns div YWM)+1; Info.Compress := (XW2 > 80);
   Info.Justify := True; Info.Quality := NLQ; Info.AddPage := PgNmStart;
   Case PgNmIn of
      pLeft: Info.Page := Left;
     pRight: Info.Page := Right;
 pAlternate: Info.Page := Altern;
	Else Info.Page := None;
   End;
   For I := 0 to 12 do Info.PrnType[I] := PrnSetup[I].Code;
   Info.PrnOutput := PrnOutput;
   If Not(WinPrint(Info))Then Exit;
   PgNmStart := Info.AddPage;
   Case Info.Page of
    Left: PgNmIn := pLeft;
   Right: PgNmIn := pRight;
  Altern: PgNmIn := pAlternate;
     Else PgNmIn := pNone;
   End;
   Dec(Info.StartPage); Dec(Info.EndPage);
   If(Info.Compress)Then
   Begin
   __SetPrnCompress;
    BitsPerChar := 7;
   End
    Else
   BitsPerChar := 6;
   If(YW2 > PageLen)Then
   Begin
    __SetPrnInterLn1_8;
    PageLen := 88;
   End;
   BeginJ := Info.StartPage * YWM; EndJ := ((Info.EndPage + 1) * YWM) - 1;
   If(EndJ > MaxLns)Then EndJ := MaxLns;
   LL.PushEndBar;
   For NC := 1 to Info.NumCopy do
   Begin
    Lst.SetPtr(BeginJ);
    OldPg := $FFFFFFFF;
    For K := 1 to YW1 do PrnLn;
    For J := BeginJ to EndJ do
    Begin
     Pg := J div YWM;
     If(Pg <> OldPg)Then
     Begin
      OldPg := Pg;
      If(Info.NumCopy > 1)Then
       PutLastBar(2,'Impression de la copie #'+Str(NC)+' de la page '+Str(Pg+1)+' en cours...')
      Else
       PutLastBar(2,'Impression de la page '+Str(Pg+1)+' en cours...');
     End;
     OnlySpc := True; HP := 0; PChr := Lst._GetCurrBuf;
     If(PChr = NIL)Then Continue;
     While Not(PChr[HP] = #0) do
     Begin
      If Not(PChr[HP] = ' ')Then
      Begin
       OnlySpc := False;
       Break;
      End;
      Inc(HP);
     End;
     If Not(OnlySpc)Then
     Begin
      Printers.Prn(Spc(HP));
      K := HP; L := StrLength(PChr); PL := GetGATTLen(PChr);
      Justify := (PChr[L-1] = ' ');
      If(Justify)Then
      Begin
       Dec(PL); Dec(L);
       If(XW2 <= PL)Then Justify := False
	Else
       Begin
	NumSpc := 0;
	For I := HP to (L - 1) do If(PChr[I] = ' ')Then Inc(NumSpc);
	JN := XW2 - XW1 - (PL - XW1);
	If(NumSpc <> 0)Then
	Begin
	 BitsPerSpc := (JN * BitsPerChar) div NumSpc; BitsPerSpcR := (JN * BitsPerChar) mod NumSpc;
	End
	 Else
	Begin
	 BitsPerSpc := 0; BitsPerSpcR := 0;
	End;
       End;
      End;
      IS := 0;
      While Not(PChr[K] = #0) do
      Begin
       Case PChr[K] of
       #1..#31 : { Attr ? }
       Begin
	Inc(K);
	If(PChr[K] = #0)Then Continue;
	Gras := (Byte(PChr[K-1]) and CharBold) = CharBold;
	Underline := (Byte(PChr[K-1]) and CharUnderline) = CharUnderline;
	_Italic := (Byte(PChr[K-1]) and CharItalic) = CharItalic;
	Inverse := (Byte(PChr[K-1]) and CharInverse) = CharInverse;
	If(Not(Info.Compress))and(Gras)Then __SetPrnBold;
	If(_Italic)Then __SetPrnItalic;
	If IsDbl(PChr[K-1])Then
	Begin
	 __SetPrnDbl;
	 Printers.Prn(PChr[K]);
	 If(Info.Compress)and(Gras)Then Printers.Prn(Char(BS)+PChr[K]);
	 If(Underline)Then Printers.Prn(Char(BS)+'_');
	 __SetPrnSimple;
	End
	 Else
	Begin
	 Printers.Prn(PChr[K]);
	 If(Info.Compress)and(Gras)Then Printers.Prn(Char(BS)+PChr[K]);
	 If(Underline)Then Printers.Prn(Char(BS)+'_');
	End;
	If(_Italic)Then __SetPrnUnItalic;
	If(Not(Info.Compress))and(Gras)Then __SetPrnUnBold;
	Inc(K);
       End;
       ' ' :
       If(Justify)Then
       Begin
	Inc(IS);
	PrnStepBit(BitsPerSpc);
	If(BitsPerSpcR > 0)Then
	Begin
	 PrnStepBit(1);
	 Dec(BitsPerSpcR);
	End;
	If(IS = NumSpc)Then PrnStepBit(BitsPerSpcR);
	Printers.Prn(' ');
	Inc(K);
       End
	Else
       Begin
	Printers.Prn(PChr[K]);
	Inc(K);
       End;
       #255 : Inc(K);
       Else
       Begin
	Printers.Prn(PChr[K]);
	Inc(K);
       End;
       End;
      End;
     End;
     PrnLn;
     If((J mod YWM) = (YWM-1))Then
     Begin
      H := (PageLen-YW2) + YW1;
      If(Info.Page <> None)Then
      Begin
       PrnLn;
       PrnPageNm;
       If(J = EndJ)Then H := H shr 1;
       For K := 2 to H do PrnLn;
      End
       Else
      For K := 1 to H do PrnLn;
     End;
     Lst.Next;
    End;
    If((J mod YWM) < YWM-1)Then
    Begin
     For I := (J mod YWM) to YWM-1 do PrnLn;
     If(Info.Page <> None)Then
     Begin
      PrnPageNm;
      PrnLn;
     End;
     For I := YW2 + 2 to PageLen - 1 do PrnLn;
    End;
   End;
   LL.Done;
  End
   Else
  Begin
   BeginJ := 0; EndJ := MaxLns; NumSpc := 0; Info.Compress := (StrMX > 80);
   If(WinPrnAscii(BeginJ,EndJ,NumSpc,Info.Compress))Then
   Begin
    If(Info.Compress)Then __SetPrnCompress;
    Lst.SetPtr(BeginJ);
    For J := BeginJ to EndJ do
    Begin
     PChr := Lst._GetCurrBuf;
     If Not(IsPChrEmpty(PChr))Then
     Begin
      Printers.Prn(Spc(NumSpc));
      Printers.Prn(StrPas(PChr));
     End;
     PrnLn;
     Lst.Next;
    End;
   End;
  End;
 End;
End;

Function Edt.Save;
Begin
 Save := SaveAs(EditName);
End;

Function Edt.GotoLns;
Var J:Byte; Size:Word; PChr:PChar;
Begin
 GotoLns := False;
 If(Lns = 0)Then Exit;
 Dec(Lns);
 If(Lns > MaxLns)Then
  ErrorMsgOk('Valeur en dehors des limites permisses. Les limites sont entre 1 et ' + Str(MaxLns+1) + '.')
  Else
 Begin
  Y := 0; P := Lns; PX := 0; PXG := 0; X := 0;
  UpDateScr;
  UpDateInfo;
  GotoLns := True;
 End;
End;

Function Edt.GotoXY;
Begin
 GotoXY := False;
 If(MaxLns < W.MaxYTxts)Then Y := 0;
 If(_X < W.MaxXTxts)Then X := _X Else X := 0;
 P := _Y; PX  := _X; PXG := 0;
 UpDateScr;
 UpDateInfo;
 GotoXY := True;
End;

Procedure Edt.UpDateScr;
Var PChr:PChar; J,M:Byte; Size,_X:Word; PY:Long;
Begin
 W.SetPos(0,0);
 PY := P-Long(Y);
 Lst.SetPtr(PY);
 M := W.MaxYTxts; _X := PX - X;
 For J := 0 to M do
 Begin
  PChr := Lst.GetCurrBuf(Size);
  _PutLn(Size,_X,PChr);
  Lst.Next;
 End;
End;

Procedure Edt.UpDateInfo;
Begin
 PutBarXYM(StrMX,MaxLns+1,FS);
 PutMemory;
 PutPos;
End;

Procedure Edt.PutCurrLn;
Begin
 W.SetPos(0,Y);
 PutLn(PX-X,P);
End;

Function Edt.InsSpcHome;
Var NewPBuf:PChar;
Begin
 InsSpcHome := False;
 If(ReadOnly)Then Exit;
 If(L > 0)Then
 Begin
  NewPBuf := MemAlloc(L);
  If(NewPBuf = NIL)Then Exit;
  Move(PChr[0],NewPBuf[0],L);
 End;
 PChr := Lst._SetBuf(P,L+N+2);
 If(PChr = NIL)Then Exit;
 FillChar(PChr[0],N,Byte(' '));
 If(L > 0)Then Move(NewPBuf[0],PChr[N],L);
 PChr[L+N] := #0;
 If(L > 0)Then FreeMem(NewPBuf,L);
 SetModified;
 PutCurrLn;
 Inc(FS,N);
 InsSpcHome := True;
End;

Procedure Edt.InsSpcIfHome;
Var I,M:Long; PBuffer,NewPBuf:PChar; L:Word;
Begin
 If(ReadOnly)Then Exit;
 If(Lst.NmBuf = 0)Then Exit;
 M := Lst.MaxBuf;
 Lst.SetPtr(0);
 PBuffer := Lst._GetCurrBuf;
 L := StrLength(PBuffer);
 If(L > 0)Then
 Begin
  If(PBuffer[0] = ' ')Then Exit;
 End;
 Lst.SetPtr(0);
 For I := 0 to M do
 Begin
  PBuffer := Lst._GetCurrBuf; L := StrLength(PBuffer);
  If(L > 0)Then
  Begin
   NewPBuf := MemAlloc(L);
   If(NewPBuf = NIL)Then Exit;
   Move(PBuffer[0],NewPBuf[0],L);
   PBuffer := Lst._SetBuf(I,L+Num+2);
   If(PBuffer = NIL)Then Exit;
   FillChar(PBuffer[0],Num,Byte(' '));
   Move(NewPBuf[0],PBuffer[Num],L);
   PBuffer[L+Num] := #0;
   FreeMem(NewPBuf,L);
   SetModified;
   Inc(FS,Num);
  End;
  Lst.Next;
 End;
 UpDateScr;
End;

Function Edt.InsChr;
Var NewPBuf:PChar;
Begin
 InsChr := False;
 If(ReadOnly)Then Exit;
 NewPBuf := MemAlloc(L);
 If(NewPBuf = NIL)Then Exit;
 Move(PChr[0],NewPBuf[0],L);
 If(Mode = ViewGAT)Then
 Begin
  If(ChrAttr > 0)and(Not(Chr = ' '))Then
  Begin
   PChr := Lst._SetBuf(P,L+3);
   If(PChr = NIL)Then Exit;
   Move(NewPBuf[0],PChr[0],PXG);
   PChr[PXG] := Char(ChrAttr); PChr[PXG+1] := Chr;
   Move(NewPBuf[PXG],PChr[PXG+2],L-PXG);
   PChr[L+2] := #0;
   FreeMem(NewPBuf,L);
   PutCurrLn;
   Inc(FS,Long(2));
  End
   Else
  Begin
   PChr := Lst._SetBuf(P,L+2);
   If(PChr = NIL)Then Exit;
   Move(NewPBuf[0],PChr[0],PXG);
   PChr[PXG] := Chr;
   Move(NewPBuf[PXG],PChr[PXG+1],L-PXG);
   PChr[L+1] := #0;
   FreeMem(NewPBuf,L);
   PutCurrLn;
   Inc(FS,Long(1));
  End;
 End
  Else
 Begin
  PChr := Lst._SetBuf(P,L+2);
  If(PChr = NIL)Then Exit;
  Move(NewPBuf[0],PChr[0],PX);
  PChr[PX] := Chr;
  Move(NewPBuf[PX],PChr[PX+1],L-PX);
  PChr[L+1] := #0;
  FreeMem(NewPBuf,L);
  PutCurrLn;
  Inc(FS,Long(1));
 End;
 ChkMaxLen(L);
 SetModified;
 UpDateInfo;
 InsChr := True;
End;

Procedure Edt.ChkMaxLen;
Begin
 If(L = 255)Then Exit;
 If(StrMX < L)Then StrMX := L;
End;

Function Edt.AddChr;
Var NewPBuf:PChar;
Begin
 AddChr := False;
 If(ReadOnly)Then Exit;
 NewPBuf := MemAlloc(L);
 If(NewPBuf = NIL)Then Exit;
 Move(PChr[0],NewPBuf[0],L);
 If(Mode = ViewGAT)Then
 Begin
  If(ChrAttr > 0)and(Not(Chr = ' '))Then
  Begin
   PChr := Lst._SetBuf(P,PXG+3);
   If(PChr = NIL)Then Exit;
   FillChar(PChr[0],PXG,32);
   Move(NewPBuf[0],PChr[0],L);
   PChr[PXG] := Char(ChrAttr); PChr[PXG+1] := Chr; PChr[PXG+2] := #0;
   FreeMem(NewPBuf,L);
   PutCurrLn;
   Inc(FS,Long(PXG-L+2));
  End
   Else
  Begin
   PChr := Lst._SetBuf(P,PXG+2);
   If(PChr = NIL)Then Exit;
   FillChar(PChr[0],PXG,32);
   Move(NewPBuf[0],PChr[0],L);
   PChr[PXG] := Chr; PChr[PXG+1] := #0;
   FreeMem(NewPBuf,L);
   PutCurrLn;
   Inc(FS,Long(PXG-L+1));
  End;
 End
  Else
 Begin
  PChr := Lst._SetBuf(P,PX+2);
  If(PChr = NIL)Then Exit;
  FillChar(PChr[0],PX,32);
  Move(NewPBuf[0],PChr[0],L);
  PChr[PX] := Chr; PChr[PX+1] := #0;
  FreeMem(NewPBuf,L);
  PutCurrLn;
  Inc(FS,Long(PX-L+1));
 End;
 ChkMaxLen(L);
 SetModified;
 UpDateInfo;
 AddChr := True;
End;

Function Edt.AddEndChr;
Var Ptr:Pointer Absolute PChr;
Begin
 AddEndChr := False;
 If(ReadOnly)Then Exit;
 If(Mode = ViewGAT)Then
 Begin
  If(ChrAttr > 0)and(Not(Chr = ' '))Then
  Begin
   PChr := Lst._SetBuf(P,PXG+3);
   If(PChr = NIL)Then Exit;
   FillChar(PChr[0],PXG,32);
   PChr[PXG] := Char(ChrAttr); PChr[PXG+1] := Chr; PChr[PXG+2] := #0;
   Inc(FS,Long(PXG+1));
  End
   Else
  Begin
   PChr := Lst._SetBuf(P,PXG+2);
   If(PChr = NIL)Then Exit;
   FillChar(PChr[0],PXG,32);
   PChr[PXG] := Chr; PChr[PXG+1] := #0;
   Inc(FS,Long(PXG));
  End;
 End
  Else
 Begin
  PChr := Lst._SetBuf(P,PX+2);
  If(PChr = NIL)Then Exit;
  FillChar(PChr[0],PX,32);
  PChr[PX] := Chr; PChr[PX+1] := #0;
  Inc(FS,Long(PX));
 End;
 PutCurrLn;
 ChkMaxLen(L);
 SetModified;
 UpDateInfo;
 AddEndChr := True;
End;

Function Edt.AddFirstChr;
Begin
 AddFirstChr := False;
 If(ReadOnly)Then Exit;
 If(Mode = ViewGAT)and(ChrAttr > 0)and(Not(Chr = ' '))Then
 Begin
  PChr := Lst._SetBuf(P,3);
  If(PChr = NIL)Then Exit;
  PChr[0] := Char(ChrAttr); PChr[1] := Chr; PChr[2] := #0; Inc(FS,LongInt(2));
 End
  Else
 Begin
  PChr := Lst._SetBuf(P,2);
  If(PChr = NIL)Then Exit;
  PChr[0] := Chr; PChr[1] := #0; Inc(FS);
 End;
 PutCurrLn;
 AddFirstChr := True;
End;

Procedure Edt.SetChr;
Var L:Word;
Begin
 If(ReadOnly)Then Exit;
 If(Mode = ViewGAT)Then
 Begin
  If(ChrAttr > 0)and(Not(Chr = ' '))Then
  Begin
   If(PChr[PXG] in [#1..#31])Then
   Begin
    PChr[PXG] := Char(ChrAttr); PChr[PXG+1] := Chr;
   End
    Else
   Begin
    StrDel(PChr,PXG,1);
    L := StrLength(PChr);
    If Not(InsChr(L,PChr,Chr))Then __OutOfMemory;
   End;
  End
   Else
  Begin
   If(PChr[PXG] in [#1..#31])Then
   Begin
    StrDel(PChr,PXG,1);
    PChr[PXG] := Chr;
   End
    Else
   PChr[PXG] := Chr;
  End;
 End
  Else
 PChr[PX] := Chr;
 PutCurrLn;
End;

Procedure Edt.kEnterIns;
Var PBuffer,PChr:PChar; Ptr:Pointer Absolute PBuffer; L,SB:Word;
Begin
 If(ReadOnly)Then Exit;
 PChr := Lst._GetBuf(P); L := StrLength(PChr);
 If(Mode = ViewGAT)Then
 Begin
  If(PXG > L)Then SB := 0 Else SB := L - PXG + 1;
  If Not(Lst.InsBuf(P+1,SB,Ptr))Then __OutOfMemory
   else
  Begin
   If Not(SB = 0)Then
   Begin
    If Not(Ptr = NIL)Then
    Begin
     Move(PChr[PXG],PBuffer[0],L-PXG);
     PBuffer[L-PXG] := #0; PChr[PXG] := #0;
    End;
   End;
  End;
 End
  Else
 Begin
  If(PX > L)Then SB := 0 Else SB := L - PX + 1;
  If Not(Lst.InsBuf(P+1,SB,Ptr))Then __OutOfMemory
   else
  Begin
   If Not(SB = 0)Then
   Begin
    If Not(Ptr = NIL)Then
    Begin
     Move(PChr[PX],PBuffer[0],L-PX);
     PBuffer[L-PX] := #0; PChr[PX] := #0;
    End;
   End;
  End;
 End;
 If(ScrollLck)Then
 Begin
  If(XW1 = PX)Then DelRightSpc(Lst._GetBuf(P));
 End;
 kDn;
 If(ScrollLck)Then
 Begin
  PChr := Lst._GetBuf(P); L := StrLength(PChr);
  If(L > 0)Then
  Begin
   InsSpcHome(L,XW1,PChr);
   Inc(FS,Long(XW1));
  End;
 End;
 UpDateScr;
 Inc(FS,Long(2));
 SetModified;
 UpDateInfo;
 kHome;
End;

Procedure Edt.Left4Word;
Var I:Word; PChr:PChar; PX9:Word; X9:Byte;
Begin
 PChr := Lst._GetBuf(P); PX9 := PX; X9 := X;
 If Not(Mode = ViewGAT)Then PXG := PX;
 If Not(IsPChrEmpty(PChr))Then
 Begin
  For I := PXG downto 0 do
  Begin
   Case PChr[I] of
	' ' : Begin
	       Inc(I);
	       Break;
	      End;
  #33..#254 : Begin
	       If(PX > 0)Then Dec(PX);
	       If(X > 0)Then Dec(X);
	       If(I <= XW1)or(I = 0)Then
	       Begin
		PX := PX9; X := X9; Exit;
	       End;
	      End;
   End;
  End;
 End;
 PXG := I;
 SetCur;
End;

Procedure Edt.kCtrlLeft;
Begin
 Case GetCurrChr of
  #0:
  Begin
   While (GetCurrChr = #0) do
   Begin
    kLeft;
    If(ScrollLck)and(PX <= XW1)Then Break;
   End;
   While Not(GetLastChr in [' ',#9]) do
   Begin
    kLeft;
    If(ScrollLck)and(PX <= XW1)Then Break;
   End;
  End;
  ' ',#9:
  Begin
   While (GetLastChr in [' ',#9]) do
   Begin
    kLeft;
    If(ScrollLck)and(PX <= XW1)Then Break;
   End;
   While Not(GetLastChr in [' ',#9]) do
   Begin
    kLeft;
    If(ScrollLck)and(PX <= XW1)Then Break;
   End;
  End;
  Else
  Begin
   If(GetLastChr in [' ',#9])Then
   Begin
    While (GetLastChr in [' ',#9]) do
    Begin
     kLeft;
     If(ScrollLck)and(PX <= XW1)Then Break;
    End;
    While Not(GetLastChr in [' ',#9]) do
    Begin
     kLeft;
     If(ScrollLck)and(PX <= XW1)Then Break;
    End;
   End
    Else
   While Not(GetLastChr in [' ',#9]) do
   Begin
    kLeft;
    If(ScrollLck)and(PX <= XW1)Then Break;
   End;
  End;
 End;
End;

Procedure Edt.kCtrlRight;
Var Ok:Bool; L:Word;
Begin
 Ok := False; L := StrLength(Lst._GetBuf(P));
 Case GetCurrChr of
  #0:
  Begin
   kDn;
   kHome;
  End;
  ' ',#9 :
  While (GetCurrChr in [' ',#9]) do
  Begin
   Ok := kRightNShow(False);
   If(ScrollLck)and(PX >= XW2)Then Break;
   If(PX >= L)Then Break;
  End;
  Else
  Begin
   While Not(GetCurrChr in [' ',#9,#0]) do
   Begin
    Ok := kRightNShow(False);
    If(ScrollLck)and(PX >= XW2)Then Break;
    If(PX >= L)Then Break;
   End;
   While (GetCurrChr in [' ',#9]) do
   Begin
    Ok := kRightNShow(False);
    If(ScrollLck)and(PX >= XW2)Then Break;
    If(PX >= L)Then Break;
   End;
  End;
 End;
 PutPos;
 If(Ok)Then UpDateScr;
End;

Procedure Edt.kEnter;
Begin
 If(InsMode)Then kEnterIns
  else
 Begin
  kDn;
  kHome;
 End;
End;

Procedure Edt.DefCenterTxt;
Var PChr:PChar; L,LS:Word;
Begin
 If(XW2 < 65520)Then
 Begin
  PChr := Lst._GetBuf(P);
  While (PChr[0] = ' ') do StrDel(PChr,0,1);
  L := StrLength(PChr);
  If(L > 0)Then InsSpcHome(L,XW1 + ((XW2-XW1+1-L) shr 1),PChr);
 End;
End;

Procedure Edt.CenterTxt;
Begin
 If(ReadOnly)Then Exit;
 Case Mode of
  ViewGatt : GattCenterTxt;
	Else DefCenterTxt;
 End;
End;

Procedure Edt.CenterHomeParagraph;
Var PChr:PChar; L,I,NL:Word;
Begin
 If(ReadOnly)Then Exit;
 If(P > 0)Then
 Begin
  If(XW2 >= 65520)Then Exit;
  PChr := Lst._GetBuf(P); NL := 0;
  If Not(IsPChrEmpty(PChr))Then
  Begin
   L := StrLength(PChr);
   If(L > 0)and(PChr[0] = ' ')Then
   Begin
    NL := 0;
    While (PChr[NL] = ' ') do Inc(NL);
   End;
  End;
  PChr := Lst._GetBuf(P-1);
  If Not(IsPChrEmpty(PChr))Then
  Begin
   L := StrLength(PChr);
   If(L > 0)and(PChr[0] = ' ')Then
   Begin
    I := 0;
    While (PChr[I] = ' ') do Inc(I);
    If(I > XW1)Then Dec(I);
    PChr := Lst._GetBuf(P); L := StrLength(PChr);
    If(I > NL)Then InsSpcHome(L,I-NL,PChr);
   End;
  End;
 End;
End;

Procedure Edt.SetCur;
Begin
 W.SetPos(X,Y);
 W.SetCurPos(X,Y);
End;

Procedure Edt.UnderlineWord;
Begin
 SetWord(CharUnderline);
End;

Procedure Edt.BoldWord;
Begin
 SetWord(CharBold);
End;

Procedure Edt.DoubleWord;
Begin
 SetWord(CharDouble);
End;

Procedure Edt.ItalicWord;
Begin
 SetWord(CharItalic);
End;

Procedure Edt.InverseWord;
Begin
 SetWord(CharInverse);
End;

Function Edt.GetLastChr;
Var PChr:PChar; L:Word;
Begin
 GetLastChr := #0; PChr := Lst._GetBuf(P); L := StrLength(PChr);
 If(L >= PX)Then
 Begin
  If(L > 0)Then GetLastChr := PChr[PX-1];
 End;
End;

Function Edt.GetCurrChr;
Var PChr:PChar; L:Word;
Begin
 GetCurrChr := #0; PChr := Lst._GetBuf(P); L := StrLength(PChr);
 If(L >= PX)Then
 Begin
  If(Mode in [ViewGatt,ViewHlp])Then GetCurrChr := PChr[PXG]
				Else GetCurrChr := PChr[PX];
 End;
End;

Function Edt.GetNextChr;
Var PChr:PChar; L:Word;
Begin
 GetNextChr := #0; PChr := Lst._GetBuf(P); L := StrLength(PChr);
 If(L >= PX+1)Then GetNextChr := PChr[PX+1];
End;

Function Edt.GetUpChr;
Var PChr:PChar; L:Word;
Begin
 GetUpChr := #0;
 If(P > 0)Then
 Begin
  PChr := Lst._GetBuf(P-1); L := StrLength(PChr);
  If(L >= PX)Then GetUpChr := PChr[PX];
 End;
End;

Function Edt.GetDnChr;
Var PChr:PChar; L:Word;
Begin
 GetDnChr := #0;
 If(P < Lst.MaxBuf)Then
 Begin
  PChr := Lst._GetBuf(P+1); L := StrLength(PChr);
  If(L >= PX)Then GetDnChr := PChr[PX];
 End;
End;

Function Edt.IsDbl;
Begin
 IsDbl := ((Byte(Chr) and CharDouble) = CharDouble);
End;

Function Edt.IsAttrDbl;
Begin
 IsAttrDbl := ((ChrAttr and CharDouble) = CharDouble);
End;

Function Edt.IsAttrUnder;
Begin
 IsAttrUnder := ((ChrAttr and CharUnderline) = CharUnderline);
End;

Function Edt.Run;
Var L,_X,K:Word; Chr:Char Absolute K; Ok,Ok2,Shift:Bool;
    PBuffer:PChar; Ptr:Pointer Absolute PBuffer; OldAttr:Byte;
    LastChr,NextChr,UpChr,DnChr:Char;
Begin
 Ok := False;
 If(IndexMode)Then
 Begin
  K := Index.RunKbd; _X := Index.GetVal;
  If(K = _X)Then
  Begin
   Inc(_X);
   Index.Done;
   IndexMode := False;
   GotoLns(_X);
  End
   Else
  Begin
   Run := K;
   Exit;
  End;
 End;
 SetCur;
 SimpleCursor;
 Repeat
  SetCur;
  If(IVid.Graf)Then W.PushCur;
  __ShowMousePtr;
  _InitKbd;
  Repeat
   _BackKbd;
   K := W.BackReadk;
   If(K > 0)Then Case K of
    kbRightBarMsUp:
    Begin
     __HideMousePtr;
     kUp;
     DelayMsPress(100);
     __ShowMousePtr;
    End;
    kbRightBarMsDn:
    Begin
     __HideMousePtr;
     kDn;
     DelayMsPress(100);
     __ShowMousePtr;
    End;
  kbRightBarMsPgUp:
    Begin
     __HideMousePtr;
     kPgUp;
     DelayMsPress(100);
     __ShowMousePtr;
    End;
  kbRightBarMsPgDn:
    Begin
     __HideMousePtr;
     kPgDn;
     DelayMsPress(100);
     __ShowMousePtr;
    End;
    Else
    Begin
     Run := K;
     CloseCursor;
     __HideMousePtr;
     Exit;
    End;
   End;
   If(ScrollLck <> GetScrollLock)Then
   Begin
    PutScrollLck;
    kHome;
   End;
   If(IVid.Graf)Then W.AniCur;
  Until Keypressed;
  __HideMousePtr;
  K := W.Readk; Shift := ShiftPressed;
  If(IVid.Graf)Then W.PopCur;
  Case K of
kbCtrlLeft : kCtrlLeft;
kbCtrlRight: kCtrlRight;
    kbLeft : Begin
	      If(DrawMode)Then
	      Begin
	       LastChr := GetLastChr; NextChr := GetNextChr;
	       UpChr := GetUpChr; DnChr := GetDnChr;
	       Case UpChr of
'¿','´','µ','¸','Â','Ã','Å','Æ','Ñ','Õ','Ú','³':Case NextChr of
'À','Á','Â','Ã','Å','Ç','Ð','Ò','Ó','Ö','×','Ú','Ä' : Case DnChr of
'´','µ','¾','À','Á','Ã','Å','Æ','Ï','Ô','Ù','³' : SetThisChr('Å');
			       Else SetThisChr('Á');
			     End;
			Else Case DnChr of
'´','µ','¾','À','Á','Ã','Å','Æ','Ï','Ô','Ù','³' : SetThisChr('´');
			       Else SetThisChr('Ù');
			     End;
		      End;
		 Else Case NextChr of
'À','Á','Â','Ã','Å','Ç','Ð','Ò','Ó','Ö','×','Ú','Ä' : Case DnChr of
'´','µ','¾','À','Á','Ã','Å','Æ','Ï','Ô','Ù','³' : SetThisChr('Â');
			       Else SetThisChr('Ä');
			     End;
			Else Case DnChr of
'´','µ','¾','À','Á','Ã','Å','Æ','Ï','Ô','Ù','³' : SetThisChr('¿');
			       Else SetThisChr('Ä');
			     End;
		      End;
	       End;
	      End;
	      kLeft;
	     End;
   kbRight : Begin
	      If(DrawMode)Then
	      Begin
	       LastChr := GetLastChr; NextChr := GetNextChr;
	       UpChr := GetUpChr; DnChr := GetDnChr;
	       Case UpChr of
'¿','´','µ','¸','Â','Ã','Å','Æ','Ñ','Õ','Ú','³':Case LastChr of
'´','¶','·','½','¿','Á','Â','Å','Ð','Ò','×','Ù','Ä' : Case DnChr of
'´','µ','¾','À','Á','Ã','Å','Æ','Ï','Ô','Ù','³' : SetThisChr('Å');
			       Else SetThisChr('Á');
			     End;
			Else Case DnChr of
'´','µ','¾','À','Á','Ã','Å','Æ','Ï','Ô','Ù','³' : SetThisChr('Ã');
			       Else SetThisChr('À');
			     End;
		      End;
		 Else Case LastChr of
'´','¶','·','½','¿','Á','Â','Å','Ð','Ò','×','Ù','Ä' : Case DnChr of
'´','µ','¾','À','Á','Ã','Å','Æ','Ï','Ô','Ù','³' : SetThisChr('Â');
			       Else SetThisChr('Ä');
			     End;
			Else Case DnChr of
'´','µ','¾','À','Á','Ã','Å','Æ','Ï','Ô','Ù','³' : SetThisChr('Ú');
			       Else SetThisChr('Ä');
			     End;
		      End;
	       End;
	      End;
	      kRight;
	     End;
    kbDown : Begin
	      If(DrawMode)Then
	      Begin
	       LastChr := GetLastChr; NextChr := GetNextChr;
	       UpChr := GetUpChr; DnChr := GetDnChr;
	       Case UpChr of
'¿','´','µ','¸','Â','Ã','Å','Æ','Ñ','Õ','Ú','³':Case LastChr of
'´','¶','·','½','¿','Á','Â','Å','Ð','Ò','×','Ù','Ä' : Case NextChr of
'À','Á','Â','Ã','Å','Ç','Ð','Ò','Ó','Ö','×','Ú','Ä' : SetThisChr('Å');
			       Else SetThisChr('´');
			     End;
			Else Case NextChr of
'À','Á','Â','Ã','Å','Ç','Ð','Ò','Ó','Ö','×','Ú','Ä' : SetThisChr('Ã');
			       Else SetThisChr('³');
			     End;
		      End;
		 Else Case LastChr of
'´','¶','·','½','¿','Á','Â','Å','Ð','Ò','×','Ù','Ä':Case NextChr of
'À','Á','Â','Ã','Å','Ç','Ð','Ò','Ó','Ö','×','Ú','Ä' : SetThisChr('Â');
			       Else SetThisChr('¿');
			     End;
			Else Case NextChr of
'À','Á','Â','Ã','Å','Ç','Ð','Ò','Ó','Ö','×','Ú','Ä' : SetThisChr('Ú');
			       Else SetThisChr('³');
			     End;
		      End;
	       End;
	      End;
	      If(DrawMode)Then
	      Begin
	       If(P >= Lst.MaxBuf)Then Lst._AddBuf(0);
	      End;
	      kDn;
	     End;
      kbUp : Begin
	      If(DrawMode)Then
	      Begin
	       LastChr := GetLastChr; NextChr := GetNextChr;
	       UpChr := GetUpChr; DnChr := GetDnChr;
	       Case DnChr of
'´','µ','¾','À','Á','Ã','Å','Æ','Ï','Ô','Ù','³' : Case LastChr of
'´','¶','·','½','¿','Á','Â','Å','Ð','Ò','×','Ù','Ä' : Case NextChr of
'À','Á','Â','Ã','Å','Ç','Ð','Ò','Ó','Ö','×','Ú','Ä' : SetThisChr('Å');
			       Else SetThisChr('´');
			     End;
			Else Case NextChr of
'À','Á','Â','Ã','Å','Ç','Ð','Ò','Ó','Ö','×','Ú','Ä' : SetThisChr('Ã');
			       Else SetThisChr('³');
			     End;
		      End;
		 Else Case LastChr of
'´','¶','·','½','¿','Á','Â','Å','Ð','Ò','×','Ù','Ä' : Case NextChr of
'À','Á','Â','Ã','Å','Ç','Ð','Ò','Ó','Ö','×','Ú','Ä' : SetThisChr('Á');
			       Else SetThisChr('Ù');
			     End;
			Else Case NextChr of
'À','Á','Â','Ã','Å','Ç','Ð','Ò','Ó','Ö','×','Ú','Ä' : SetThisChr('À');
			       Else SetThisChr('³');
			     End;
		      End;
	       End;
	      End;
	      kUp;
	     End;
     kbIns : If(DrawMode)Then SetInsMode(False)
	      Else
	     Begin
	      InsMode := Not(InsMode);
	      PutIns;
	     End;
     kbDel : kDel;
      kbBS : kBS;
    kbHome : If Not(GetScrollLock)Then
	     Begin
	      If(Shift)Then XW1 := PX Else kHome;
	     End
	      Else
	     kHome;
     kbEnd : If Not(GetScrollLock)Then
	     Begin
	      If(Shift)Then XW2 := PX Else kEnd;
	     End
	      else
	     kEnd;
    kbPgUp : kPgUp;
    kbPgDn : kPgDn;
   kbEnter : kEnter;
	Else If(Chr > #31)Then
	     Begin
	      If Not(DrawMode)Then
	      Begin
	       OldAttr := ChrAttr;
	       If(Mode = ViewGAT)Then
	       Begin
		If(Chr = ' ')and(IsAttrDbl)and(IsAttrUnder)Then
		Begin
		 Chr := '_'; ChrAttr := CharNormal;
		End;
		_X := PXG;
	       End
		Else
	       _X := PX;
	       Ok2 := ScrollLck;
	       If(Ok2)Then
	       Begin
		If(XW2 > PX)Then Ok2 := False
		 Else
		Begin
		 If(Chr in ['A'..'Z','a'..'z','_','€'..#167])Then
		 Begin
		  Left4Word;
		  kEnterIns;
		  CenterHomeParagraph;
		  kEnd;
		 End
		  Else
		 Begin
		  kEnterIns;
		  CenterHomeParagraph;
		  kEnd;
		 End;
		 If(Chr <> ' ')Then
		 Begin
		  SetThisChr(Char(K));
		  kRight;
		 End;
		End;
	       End;
	       If Not(Ok2)Then
	       Begin
		SetThisChr(Chr);
		kRight;
	       End;
	       ChrAttr := OldAttr;
	      End
	       Else
	      Ok := True;
	     End
	      Else
	     Ok := True;
  End;
 Until Ok;
 CloseCursor;
 Run := K;
End;

Destructor Edt.Done;
Var Path : PathStr;
Begin
 If(IndexMode)Then Index.Done;
 If(Modified)Then
 Begin
  Path := EditName;
  If(Path = '')Then Path := 'Pasnom';
  If(WarningMsgYesNo('Le fichier '+Path+' n''a pas ‚t‚ sauvegard‚! '+
		     'Dois-je le sauver ?') = kbYes)Then Save;
 End;
 W.Done;
 Lst.Done;
 PutMemory;
End;

Function GetGATTLen(PChr:PChar):Word;
Var I,L:Word;
Begin
 I := 0; L := 0;
 While Not(PChr[I] = #0) do
 Begin
  If(PChr[I] in [' '..#254])Then Inc(L) else
  If(PChr[I] < ' ')and((Byte(PChr[I]) and CharDouble) = CharDouble)Then Inc(L);
  Inc(I);
 End;
 GetGATTLen := L;
End;

Function PosGatt2X(PChr:PChar;P:Word):Word;
Var I,L:Word;
Begin
 I := 0; L := 0;
 If(IsPChrEmpty(PChr))Then PosGatt2X := P
  Else
 Begin
  While Not(PChr[I] = #0) do
  Begin
   Case PChr[I] of
      #1..#31 : Begin
		 If((Byte(PChr[I]) and CharDouble) = CharDouble)Then
		 Begin
		  Inc(L);
		  If(L >= P)Then Break;
		 End;
		End;
    ' '..#254 : Begin
		 Inc(L);
		 If(L >= P)Then Break;
		End;
   End;
   Inc(I);
  End;
  PosGatt2X := I;
 End;
End;

Function PosX2Gatt(PChr:PChar;P:Word):Word;
Var I,L:Word;
Begin
 I := 0; L := 0;
 If(IsPChrEmpty(PChr))Then PosX2Gatt := P
  Else
 Begin
  While Not(PChr[I] = #0) do
  Begin
   Case PChr[I] of
      #1..#31 : Begin
		 If((Byte(PChr[I]) and CharDouble) = CharDouble)Then
		 Begin
		  Inc(L);
		  If(L >= P)Then Break;
		 End;
		End;
    ' '..#254 : Begin
		 Inc(L);
		 If(L >= P)Then Break;
		End;
   End;
   Inc(I);
  End;
  PosX2Gatt := L;
 End;
End;

Procedure SetTab(Var S:String);
Var T:String; I:Byte;
Begin
 T := '';
 For I := 1 to Length(S) do
 Begin
  Case S[I] of
   #9 : AddStr(T,SpcTab);
   Else IncStr(T,S[I]);
  End;
 End;
 S := T;
End;

BEGIN { Main Unit }
 ExtAC := '*.AC'; ExtAsm := '*.ASM;*.INC;*.MAC'; ExtBas := '*.BAS';
 ExtC := '*.C;*.CAS;*.CPP;*.H'; ExtEuphoria := '*.E;*.EX'; ExtFortran := '*.FOR';
 ExtIni := '*.INI'; ExtMsMnu := '*.MNU;*.DEF'; ExtPas := '*.PAS;*.INC';
 ExtRC := '*.RC'; PathResource := ''; PathPas := ''; PathFortran := '';
 PathForth := ''; PathEuphoria := ''; PathCobol := ''; PathC := '';
 PathBas := ''; PathAsm :=''; PathAda := ''; PathGatt := '';
 PutMemory := Ret;
END.