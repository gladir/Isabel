{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³           Malte Genesis/Module de M‚moire Central          ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Mems;

INTERFACE

Uses Math;

Type

     PCharByteRec = Record
      PChr:PChar;
      Nm:Byte;
     End;

     StrByteRec = Record
      PChr:PChar;
      Nm:Byte;
      Len:Word;
     End;

     StrWordRec = Record
      PChr:PChar;
      Nm,Len:Word;
     End;

     PCharWordRec = Record
      PChr:PChar;
      Nm:Word;
     End;

     RBufPtr = ^RBufRec;

     RBufRec = Record
      Buf:Pointer;
      Size:Word;
      Previous,Next:RBufPtr;
     End;

     RBuf = Object
      Constructor Init;
      Procedure SetPtr(P:Long);
      Procedure Next;
      Procedure Previous;
      Function AddBuf(Size:Word;Var Addr:Pointer):Bool;
      Function InsBuf(P:Long;Size:Word;Var Addr:Pointer):Bool;
      Function InsStr(P:Long;Str:String):Bool;
      Function InsStrWord(P:Long;Str:String;Num:Word):Bool;
      Function DelBuf(P:Long):Bool;
      Function SetBuf(P:Long;Size:Word;Var Addr:Pointer):Bool;
      Function AddLn:Bool;
      Function AddPChr(PChr:PChar):Bool;
      Function AddPChrByte(PChr:PChar;Num:Byte):Bool;
      Function AddPChrWord(PChr:PChar;Num:Word):Bool;
      Function AddStr(Str:String):Bool;
      Function AddStrByte(Str:String;Num:Byte):Bool;
      Function AddStrWord(Str:String;Num:Word):Bool;
      Function AddModeTextWord(X,Y:Byte;_Type:Char;Value:Word):Bool;
      Function AddModeGrafWord(X,Y:Word;BitsPerPixel:Byte;Value:Word):Bool;
      Function AddStrPasType(Str:String):Bool;
      Function AddSpcUStrPasType(S:Byte;Str:String):Bool;
      Function AddSpcUStr(S:Byte;Str:String):Bool;
      Function GetBuf(P:Long;Var Size:Word):Pointer;
      Function GetCurrBuf(Var Size:Word):Pointer;
      Function NmBuf:Long;
      Function MaxBuf:Long;
      Function IsEmpty:Bool;
      Function _AddBuf(Size:Word):Pointer;
      Function _GetBuf(P:Long):Pointer;
      Function _GetCurrBuf:Pointer;
      Function _GetStr(P:Long):String;
      Function _SetBuf(P:Long;Size:Word):Pointer;
      Destructor Done;
      PRIVATE
      PCurrPtr,NB:Long;
      CurrPtr,List,EndListPtr:RBufPtr;
     End;

     IBufPtr = ^IBufRec;

     IBufRec = Record
      Buf:Pointer;
      Size:Word;
      Jmp:Long;
      Previous,Next:IBufPtr;
     End;

     IBuf = Object
      Constructor Init;
      Function AddBufAt(P:Long;Size:Word):Pointer;
      Function GetBuf(P:Long;Var Size:Word):Pointer;
      Function SetBuf(P:Long;Size:Word):Pointer;
      Function NmBuf:Long;
      Destructor Done;
      PRIVATE
      List,EndListPtr:IBufPtr;
      NB,NV:Long;
     End;

Procedure FreeMem(Buffer:Pointer;Size:Word);
Function MemAlloc(Size:Word):Pointer;

IMPLEMENTATION

Uses Strings,Strs;

Constructor IBuf.Init;
Begin
 List := NIL; EndListPtr := NIL; NB := 0; NV := 0;
End;

Function IBuf.NmBuf;
Begin
 NmBuf := NV;
End;

Function IBuf.AddBufAt;
Var J,L:Long; BufP,InsBufP:IBufPtr; BufAlloc:IBufRec;
Begin
 AddBufAt := NIL; BufAlloc.Previous := NIL; BufAlloc.Next := NIL;
 BufAlloc.Jmp := 0; BufAlloc.Size := Size;
 If(Size = 0)Then BufAlloc.Buf := NIL
  Else
 Begin
  BufAlloc.Buf := MemAlloc(Size);
  If(BufAlloc.Buf = NIL)Then Exit;
 End;
 If(P = 0)Then
 Begin
  If(NB = 0)Then
  Begin
   If(Size = 0)Then Exit;
   List := MemAlloc(SizeOf(BufAlloc));
   If(List = NIL)Then Exit;
   Move(BufAlloc,List^,SizeOf(BufAlloc));
   Inc(NB); Inc(NV);
  End
   Else
  Begin
   InsBufP := MemAlloc(SizeOf(BufAlloc));
   If(InsBufP = NIL)Then Exit;
   Move(BufAlloc,InsBufP^,SizeOf(BufAlloc));
   InsBufP^.Next := List; InsBufP^.Jmp := 1; List := InsBufP; Inc(NB); Inc(NV);
  End;
  EndListPtr := List^.Next;
 End
  Else
 If(NB = 0)Then
 Begin
  List := MemAlloc(SizeOf(BufAlloc));
  If(List = NIL)Then Exit;
  FillChar(List^,SizeOf(BufAlloc),0);
  List^.Jmp := P;
  InsBufP := MemAlloc(SizeOf(BufAlloc));
  If(InsBufP = NIL)Then Exit;
  Move(BufAlloc,InsBufP^,SizeOf(BufAlloc));
  InsBufP^.Previous := List; InsBufP^.Jmp := 1;
  List^.Next := InsBufP; EndListPtr := List^.Next;
  NB := 2; NV := P;
 End
  Else
 Begin
  J := 0; BufP := List;
  While True do
  Begin
   If(J > P)Then
   Begin
    InsBufP := MemAlloc(SizeOf(BufAlloc));
    If(InsBufP = NIL)Then Exit;
    Move(BufAlloc,InsBufP^,SizeOf(BufAlloc));
    InsBufP^.Previous := BufP^.Previous; InsBufP^.Next := BufP;
    InsBufP^.Jmp := J - P + 1; BufP^.Previous^.Jmp  := P - 1;
    BufP^.Previous^.Next := InsBufP; BufP^.Previous := InsBufP;
    Inc(NB); Inc(NV);
    Break;
   End
    Else
   If(J = P)Then
   Begin
    InsBufP := MemAlloc(SizeOf(BufAlloc));
    If(InsBufP = NIL)Then Exit;
    Move(BufAlloc,InsBufP^,SizeOf(BufAlloc));
    InsBufP^.Next := BufP; InsBufP^.Previous := BufP^.Previous;
    InsBufP^.Jmp := 1; BufP^.Previous^.Next := InsBufP;
    BufP^.Previous := InsBufP; Inc(NB); Inc(NV);
    Break;
   End
    Else
   Begin
    If(BufP^.Next = NIL)Then
    Begin
     InsBufP := MemAlloc(SizeOf(BufAlloc));
     If(InsBufP = NIL)Then Exit;
     Move(BufAlloc,InsBufP^,SizeOf(BufAlloc));
     InsBufP^.Previous := BufP;
     If(J + BufP^.Jmp > P)Then
     Begin
      InsBufP^.Jmp := J + BufP^.Jmp - P; Inc(NV);
     End
      Else
     Begin
      InsBufP^.Jmp := 0; NV := P + 1;
     End;
     BufP^.Next := InsBufP; BufP^.Jmp := P - J;
     EndListPtr := InsBufP^.Next; Inc(NB);
     Break;
    End
     Else
    Begin
     Inc(J,BufP^.Jmp); BufP := BufP^.Next;
    End;
   End;
  End;
 End;
 AddBufAt := BufAlloc.Buf;
End;

Function IBuf.SetBuf;
Var J,L:Long; BufP,InsBufP:IBufPtr; BufAlloc:IBufRec;
Begin
 If(NB = 0)or(P >= NV)Then SetBuf := AddBufAt(P,Size)
  Else
 Begin
  BufAlloc.Previous := NIL; BufAlloc.Next := NIL;
  BufAlloc.Jmp := 0; BufAlloc.Size := Size;
  If(Size = 0)Then BufAlloc.Buf := NIL
   Else
  Begin
   BufAlloc.Buf := MemAlloc(Size);
   If(BufAlloc.Buf = NIL)Then Exit;
  End;
  J := 0; BufP := List;
  While True do
  Begin
   If(J > P)Then
   Begin
    InsBufP := MemAlloc(SizeOf(BufAlloc));
    If(InsBufP = NIL)Then Exit;
    Move(BufAlloc,InsBufP^,SizeOf(BufAlloc));
    InsBufP^.Previous := BufP^.Previous; InsBufP^.Next := BufP;
    InsBufP^.Jmp := J - P; Dec(BufP^.Previous^.Jmp,J - P);
    BufP^.Previous^.Next := InsBufP; BufP^.Previous := InsBufP; Inc(NB);
    Break;
   End
    Else
   If(J = P)Then
   Begin
    FreeMem(BufP^.Buf,BufP^.Size);
    BufP^.Buf := BufAlloc.Buf; BufP^.Size := BufAlloc.Size;
    Break;
   End
    Else
   Begin
    If(BufP^.Next = NIL)Then
    Begin
     InsBufP := MemAlloc(SizeOf(BufAlloc));
     If(InsBufP = NIL)Then Exit;
     Move(BufAlloc,InsBufP^,SizeOf(BufAlloc));
     InsBufP^.Previous := BufP;
     If(J + BufP^.Jmp > P)Then InsBufP^.Jmp := J + BufP^.Jmp - P
      Else
     Begin
      InsBufP^.Jmp := 0; NV := P + 1;
     End;
     BufP^.Next := InsBufP; BufP^.Next^.Jmp := P - J; EndListPtr := InsBufP^.Next; Inc(NB);
     Break;
    End
     Else
    Begin
     Inc(J,BufP^.Jmp); BufP := BufP^.Next;
    End;
   End;
  End;
  SetBuf := BufAlloc.Buf;
 End;
End;

Function IBuf.GetBuf;
Var J:Long; BufP:IBufPtr;
Begin
 GetBuf := NIL; Size := 0;
 If(NB = 0)or(P > NV)Then Exit;
 If(P = 0)Then
 Begin
  GetBuf := List^.Buf; Size := List^.Size;
 End
  Else
 Begin
  J := 0; BufP := List;
  While True do
  Begin
   If(J > P)Then Break Else
   If(J = P)Then
   Begin
    GetBuf := BufP^.Buf; Size := BufP^.Size;
    Break;
   End
    Else
   Begin
    Inc(J,BufP^.Jmp); BufP := BufP^.Next;
    If(BufP = NIL)Then Exit;
   End;
  End;
 End;
End;

Destructor IBuf.Done;
Begin
End;

Constructor RBuf.Init;
Begin
 PCurrPtr := $F0000000; CurrPtr := NIL; List := NIL; EndListPtr := NIL; NB := 0;
End;

Function RBuf.IsEmpty;
Begin
 IsEmpty := (List = NIL);
End;

Function RBuf.AddBuf;
Var W:RBufRec; WPtr:RBufPtr;
Begin
 AddBuf := False;
 If(Size = 0)Then
 Begin
  W.Buf := NIL; W.Size := 0;
 End
  Else
 Begin
  Addr := MemAlloc(Size);
  If(Addr = NIL)Then Exit;
  W.Buf := Addr; W.Size := Size;
 End;
 W.Previous := NIL; W.Next := NIL;
 If(List = NIL)Then
 Begin
  List := MemAlloc(SizeOf(List^));
  If(List = NIL)Then Exit;
  Move(W,List^,SizeOf(List^)); EndListPtr := List;
 End
  Else
 Begin
  WPtr := EndListPtr; W.Previous := WPtr; WPtr^.Next := MemAlloc(SizeOf(List^));
  Move(W,WPtr^.Next^,SizeOf(List^)); EndListPtr := WPtr^.Next;
 End;
 Inc(NB); AddBuf := True;
End;

Function RBuf._AddBuf;
Var Ptr:Pointer;
Begin
 _AddBuf := NIL;
 If Not(AddBuf(Size,Ptr))Then Exit;
 _AddBuf := Ptr;
End;

Function RBuf._SetBuf;
Var Ptr:Pointer;
Begin
 _SetBuf := NIL;
 If Not(SetBuf(P,Size,Ptr))Then Exit;
 _SetBuf := Ptr;
End;

Function RBuf.InsBuf;
Var WP,NewP:RBufPtr; I:Long;
Begin
 InsBuf := False;
 If(P > NB)Then Exit;
 If(P = NB)Then InsBuf := AddBuf(Size,Addr)
  else
 Begin
  InsBuf := False;
  If(P = 0)Then
  Begin
   WP := MemAlloc(SizeOf(List^));
   If(WP = NIL)Then Exit;
   List^.Previous := WP; WP^.Previous := NIL; WP^.Next := List;
   If(Size = 0)Then
   Begin
    WP^.Buf := NIL; WP^.Size := 0; Addr := NIL;
   End
    Else
   Begin
    Addr := MemAlloc(Size);
    If(Addr = NIL)Then Exit;
    WP^.Buf := Addr; WP^.Size := Size;
   End;
   List := WP;
  End
   else
  Begin
   NewP := MemAlloc(SizeOf(List^));
   If(NewP = NIL)Then Exit;
   WP := List;
   For I := 1 to P do
   Begin
    If(WP = NIL)Then Exit;
    WP := WP^.Next;
   End;
   NewP^.Next := WP; NewP^.Previous := WP^.Previous;
   If(Size = 0)Then
   Begin
    NewP^.Buf := NIL; NewP^.Size := 0; Addr := NIL;
   End
    Else
   Begin
    Addr := MemAlloc(Size);
    If(Addr = NIL)Then Exit;
    NewP^.Buf := Addr; NewP^.Size := Size;
   End;
   WP^.Previous^.Next := NewP; WP^.Previous := NewP;
  End;
  Inc(NB); InsBuf := True;
 End;
End;

Function RBuf.AddPChr;
Var Ptr:Pointer; PBuf:PChar Absolute Ptr; L:Word;
Begin
 AddPChr := False; L := StrLen(PChr) + 1;
 If Not(AddBuf(L,Ptr))Then Exit;
 If(Ptr = NIL)Then Exit;
 Move(PChr[0],PBuf[0],L);
 AddPChr := True;
End;

Function RBuf.AddPChrByte;
Var PCharByte:^PCharByteRec; Ptr:Pointer;
Begin
 AddPChrByte := False;
 If Not(AddBuf(SizeOf(PCharByteRec),Ptr))Then Exit;
 PCharByte := Ptr; PCharByte^.PChr := PChr; PCHarByte^.Nm := Num;
 AddPChrByte := True;
End;

Function RBuf.AddStrByte;
Var StrByte:^StrByteRec; Ptr:Pointer; PChr:Array[0..255] of Char;
Begin
 AddStrByte := False;
 If Not(AddBuf(SizeOf(StrByteRec),Ptr))Then Exit;
 StrByte := Ptr; StrPCopy(PChr,Str); StrByte^.PChr := StrNew(PChr);
 StrByte^.Len := Length(Str); StrByte^.Nm := Num; AddStrByte := True;
End;

Function RBuf.AddStrWord;
Var StrWord:^StrWordRec; Ptr:Pointer; PChr:Array[0..255] of Char;
Begin
 AddStrWord := False;
 If Not(AddBuf(SizeOf(StrWordRec),Ptr))Then Exit;
 StrWord := Ptr; StrPCopy(PChr,Str); StrWord^.PChr := StrNew(PChr);
 StrWord^.Len := Length(Str); StrWord^.Nm := Num; AddStrWord := True;
End;

Function RBuf.AddStr;
Var Ptr:Pointer; PChr:PChar; Size:Word;
Begin
 AddStr := False; Size := Length(Str)+1;
 If(Size < 32)Then Size := 32;
 If Not(AddBuf(Size,Ptr))Then Exit;
 If(Ptr = NIL)Then Exit;
 PChr := Ptr; StrPCopy(PChr,Str); AddStr := True;
End;

Function RBuf.AddModeTextWord;
Var S:String;
Begin
 S := 'Texte '+Str(X) + 'x' + Str(Y)+', ';
 Case _Type of
  'C' : Strs.AddStr(S,'16 couleurs');
  'M' : Strs.AddStr(S,'Monochrome');
   Else Strs.AddStr(S,'noir & blanc');
 End;
 AddModeTextWord := AddStrWord(S,Value);
End;

Function RBuf.AddModeGrafWord;
Begin
 AddModeGrafWord := AddStrWord('Graphiques '+Str(X) + 'x' + Str(Y)+', ' +
		    Str(1 shl BitsPerPixel)+ ' couleurs',Value);
End;

Function RBuf.AddStrPasType;
Var Target:String; I:Byte;
Begin
 Target := '';
 For I := 1 to Length(Str) do
 Begin
  Case Str[I] of
   ' ' : Strs.AddStr(Target,'After');
   'ï' : Strs.AddStr(Target,'And');
   '' : Strs.AddStr(Target,'Array[0..255] of Char');
   'Ž' : Strs.AddStr(Target,'Array');
   '®' : Strs.AddStr(Target,'Begin');
   '‡' : Strs.AddStr(Target,'Chr');
   '€' : Strs.AddStr(Target,'Char');
   'ö' : Strs.AddStr(Target,'div');
   '÷' : Strs.AddStr(Target,'Else');
   'ð' : Strs.AddStr(Target,'Equal');
   '¯' : Strs.AddStr(Target,'End;');
   '' : Strs.AddStr(Target,'Extract');
   'ô' : Strs.AddStr(Target,'False');
   'Ÿ' : Strs.AddStr(Target,'Function');
   'î' : Strs.AddStr(Target,'In');
   '?' : Strs.AddStr(Target,'If');
   '¨' : Strs.AddStr(Target,'Then');
   '!' : Strs.AddStr(Target,'Not');
   '¢' : Strs.AddStr(Target,'Open');
   '|' : Strs.AddStr(Target,'or');
   '•' : Strs.AddStr(Target,'Close');
   'ž' : Strs.AddStr(Target,'Procedure');
   '›' : Strs.AddStr(Target,'Str');
   '$' : Strs.AddStr(Target,'String');
   '' : Strs.AddStr(Target,'True');
   'š' : Strs.AddStr(Target,'Up');
   'ý' : Strs.AddStr(Target,'Word');
    Else IncStr(Target,Str[I]);
  End;
 End;
 AddStrPasType := AddStr(Target);
End;

Function RBuf.AddSpcUStrPasType;
Begin
 AddSpcUStrPasType := AddStrPasType(Spc(S)+Str);
End;

Function RBuf.AddSpcUStr;
Begin
 AddSpcUStr := AddStr(Spc(S)+Str);
End;

Function RBuf.AddLn;
Begin
 AddLn := AddPChr('');
End;

Function RBuf.InsStr;
Var Ptr:Pointer; PChr:PChar; Size:Word;
Begin
 InsStr := False; Size := Length(Str)+1;
 If(Size < 32)Then Size := 32;
 If Not(InsBuf(P,Size,Ptr))Then Exit;
 If(Ptr = NIL)Then Exit;
 PChr := Ptr; StrPCopy(PChr,Str); InsStr := True;
End;

Function RBuf.InsStrWord;
Var StrWord:^StrWordRec; Ptr:Pointer; PChr:Array[0..255] of Char;
Begin
 InsStrWord := False;
 If Not(InsBuf(P,SizeOf(StrWordRec),Ptr))Then Exit;
 StrWord := Ptr; StrPCopy(PChr,Str);
 StrWord^.PChr := StrNew(PChr); StrWord^.Len := Length(Str);
 StrWord^.Nm := Num; InsStrWord := True;
End;

Function RBuf.AddPChrWord;
Var PCharWord:^PCharWordRec; Ptr:Pointer;
Begin
 AddPChrWord := False;
 If Not(AddBuf(SizeOf(PCharWordRec),Ptr))Then Exit;
 PCharWord := Ptr; PCharWord^.PChr := PChr;
 PCHarWord^.Nm := Num; AddPChrWord := True;
End;

Function RBuf.GetBuf;
Var WP:RBufPtr; I:Long;
Begin
 Size := 0; GetBuf := Nil;
 If(P < 0)or(P >= NB)Then Exit;
 If(P = 0)Then
 Begin
  GetBuf := List^.Buf; Size := List^.Size;
 End
  Else
 Begin
  WP := List;
  For I := 1 to P do
  Begin
   If(WP = NIL)Then Exit;
   WP := WP^.Next;
  End;
  If(WP = NIL)Then Exit;
  GetBuf := WP^.Buf; Size := WP^.Size;
 End;
End;

Function RBuf._GetStr;
Begin
 _GetStr := StrPas(_GetBuf(P));
End;

Procedure RBuf.SetPtr;
Var WP:RBufPtr; I:Long;
Begin
 If(P = 0)Then
 Begin
  PCurrPtr := 0; CurrPtr := List;
 End
  else
 If Not(PCurrPtr = P)Then
 Begin
  If(PCurrPtr - 1 = P)Then Previous else
  If(PCurrPtr + 1 = P)Then Next
   else
  Begin
   WP := List;
   If(P > 0)Then For I := 1 to P do
   Begin
    If(WP = NIL)Then Exit;
    WP := WP^.Next;
   End;
   If(WP = NIL)Then Exit;
   PCurrPtr := P;
   CurrPtr  := WP;
  End;
 End;
End;

Procedure RBuf.Previous;
Begin
 If Not(CurrPtr = NIL)Then
 Begin
  CurrPtr := CurrPtr^.Previous;
  Dec(PCurrPtr);
 End;
End;

Procedure RBuf.Next;
Begin
 If Not(CurrPtr = NIL)Then
 Begin
  CurrPtr := CurrPtr^.Next;
  Inc(PCurrPtr);
 End;
End;

Function RBuf._GetCurrBuf;
Begin
 If(CurrPtr = NIL)Then _GetCurrBuf := NIL Else _GetCurrBuf := CurrPtr^.Buf;
End;

Function RBuf.GetCurrBuf;
Begin
 If(CurrPtr = NIL)Then
 Begin
  GetCurrBuf := NIL; Size := 0;
 End
  Else
 Begin
  GetCurrBuf := CurrPtr^.Buf; Size := CurrPtr^.Size;
 End;
End;

Function RBuf._GetBuf;
Var Size:Word;
Begin
 _GetBuf := GetBuf(P,Size);
End;

Function RBuf.DelBuf;
Var WP:RBufPtr; I:Long;
Begin
 DelBuf := False;
 If(NB = 0)or(P < 0)or(P >= NB)Then Exit;
 If(P = 0)Then
 Begin
  If(List = NIL)Then Exit;
  WP := List;
  Mems.FreeMem(WP^.Buf,WP^.Size);
  Mems.FreeMem(WP,SizeOf(WP^));
  If(NB > 1)Then
  Begin
   If(List^.Next = NIL)Then Exit;
   WP^.Next^.Previous := NIL; List := List^.Next; CurrPtr := NIL;
   PCurrPtr := $F0000000; Dec(NB); DelBuf := True;
   Exit;
  End
   else
  Begin
   PCurrPtr := $F0000000; CurrPtr := NIL; List := NIL; EndListPtr := NIL;
   NB := 0; DelBuf := True;
   Exit;
  End;
 End
  else
 Begin
  WP := List;
  For I := 1 to P do
  Begin
   If(WP = NIL)Then Exit;
   WP := WP^.Next;
  End;
  If(WP = NIL)Then Exit;
  If(NB - 1 = P)Then
  Begin
   EndListPtr := WP^.Previous; WP^.Previous^.Next := NIL;
  End
   Else
  Begin
   WP^.Next^.Previous := WP^.Previous; WP^.Previous^.Next := WP^.Next;
  End;
  Mems.FreeMem(WP^.Buf,WP^.Size);
  Mems.FreeMem(WP,SizeOf(List^));
  Dec(NB);
  DelBuf := True;
 End;
End;

Function RBuf.SetBuf;
Var WP:RBufPtr; I:Long;
Begin
 SetBuf := False;
 If(P < 0)or(P > NB)Then Exit;
 If(P = NB)Then
 Begin
  SetBuf := AddBuf(Size,Addr);
  Exit;
 End;
 If(P = 0)Then
 Begin
  Mems.FreeMem(List^.Buf,List^.Size);
  If(Size = 0)Then
  Begin
   List^.Buf := NIL; List^.Size := 0;
  End
   Else
  Begin
   Addr := MemAlloc(Size);
   If(Addr = NIL)Then Exit;
   List^.Buf := Addr; List^.Size := Size;
  End;
  SetBuf := True;
  Exit;
 End;
 WP := List;
 For I := 1 to P do
 Begin
  If(WP = NIL)Then Exit;
  WP := WP^.Next;
 End;
 Mems.FreeMem(WP^.Buf,WP^.Size);
 If(Size = 0)Then
 Begin
  WP^.Buf := NIL; WP^.Size := 0;
 End
  Else
 Begin
  Addr := MemAlloc(Size);
  If(Addr = NIL)Then Exit;
  WP^.Buf := Addr; WP^.Size := Size;
 End;
 SetBuf := True;
End;

Function RBuf.NmBuf;
Begin
 NmBuf := NB;
End;

Function RBuf.MaxBuf;
Begin
 MaxBuf := NB - 1;
End;

Destructor RBuf.Done;
Var WP:RBufPtr; Ptr:^StrByteRec;
Begin
 WP := List;
 While Not(WP = NIL) do
 Begin
  If(WP^.Size = SizeOf(StrByteRec))Then
  Begin
   Ptr := WP^.Buf;
   StrDispose(Ptr^.PChr);
  End;
  Mems.FreeMem(WP^.Buf,WP^.Size);
  Mems.FreeMem(WP,SizeOf(RBufRec));
  WP := WP^.Next;
 End;
End;

Procedure FreeMem(Buffer:Pointer;Size:Word);
Begin
 If(Size = 0)Then Exit;
 If(Buffer = NIL)Then Exit;
 System.FreeMem(Buffer,Size);
End;

Function MemAlloc(Size:Word):Pointer;
Var Ptr:Pointer;
Begin
 MemAlloc := NIL;
 If(Size = 0)Then Exit;
 If(MaxAvail < Size)Then Exit;
 GetMem(Ptr,Size);
 MemAlloc := Ptr;
End;

BEGIN
END.
