{ ARITH-N }

Unit Compress;

Interface

Implementation

Uses Strings,Mems;

Const

 MaximumScale = 16383;
 Escape = 256;
 Done = -1;
 Flush = -2;
 CompressionName:PChar = 'Adaptive order n model with arithmetic coding';
 Usage:PChar = 'in-file out-file [-o order]'#13#13;
 MaxOrder:Integer = 3;
 EOF = 27; { ? Inconnue }

Type

 Symbol=Record
  LowCount,HighCount,Scale:Word;
 End;

 BitFile=Record
  _File:File;
  Mask:Byte;
  Rack,PacifierCount:Integer;
 End;

 BitFilePtr = ^BitFile;

 StatsRec=Record
  Symbol,Count:Byte;
 End;

 StatsArray=Array[0..65520 div SizeOf(StatsRec)] of StatsRec;

 ContextPtr = ^Context;

 LinksRec=Record
  Next:ContextPtr;
 End;

 LinksArray=Array[0..65520 div SizeOf(LinksRec)] of LinksRec;

 Context=Record
  MaxIndex:Integer;
  Links:^LinksArray;
  Stats:^StatsArray;
  LesserContext:ContextPtr;
 End;

 ContextArray=Array[0..65520 div SizeOf(Context)] of ContextPtr;

Var Contexts:^ContextArray;
    CurrOrder:Integer;
    Totals:Array[0..258] of ShortInt;
    ScoreBoard:Array[0..256] of Byte;
    code,low,high:Word;
    underflowbits:LongInt;
    stream:BitFilePtr;

Function Putc(Chr:Char;Var F:File):Char;
Var _F:Text Absolute F;
Begin
 Write(_F,Chr);
End;

Function getc(Var F:File):Char;
Var _F:Text Absolute F; Output:Char;
Begin
 Read(_F,Output);
 getc := Output;
End;

Function fTell(F:BitFilePtr):LongInt;
Begin
End;

Procedure FatalError(Msg:String);
Begin
 WriteLn(Msg);
 Halt;
End;

Function OpenOutputBitFile(Name:PChar):BitFilePtr;
Var PBitFile:BitFilePtr;
    Ptr:Pointer Absolute PBitFile;
Begin
 OpenOutputBitFile := NIL;
 Ptr := MemAlloc(SizeOf(BitFile));
 If(Ptr = NIL)Then Exit;
 Assign(PBitFile^._File,Name);
 PBitFile^.Rack := 0;
 PBitFile^.Mask := $80;
 PBitFile^.PacifierCount := 0;
 OpenOutputBitFile := PBitFile;
End;

Function OpenInputBitFile(Name:PChar):BitFilePtr;
Var PBitFile:BitFilePtr;
    Ptr:Pointer Absolute PBitFile;
Begin
 OpenInputBitFile := NIL;
 Ptr := MemAlloc(SizeOf(BitFile));
 If(Ptr = NIL)Then Exit;
 Assign(PBitFile^._File,Name);
  PBitFile^.Rack := 0;
 PBitFile^.Mask := $80;
 PBitFile^.PacifierCount := 0;
 OpenInputBitFile := PBitFile;
End;

Procedure CloseOutputFile(PBitFile:BitFilePtr);
Begin
 If(PBitFile^.Mask <> $80)Then
  If(Putc(Char(PBitFile^.Rack),PBitFile^._File) <> Char(PBitFile^.Rack))Then
   FatalError('Erreur fatale dans CloseBitFile!');
 Close(PBitFile^._File);
 FreeMem(PBitFile,SizeOf(BitFile));
End;

Procedure OutputBit(bitFile:BitFilePtr;Bit:Integer);
Var _File:File; _Text:Text Absolute _File;
Begin
 If(bit <> 0)Then BitFile^.Rack := BitFile^.Rack or BitFile^.Mask;
 BitFile^.Mask := BitFile^.Mask shr 1;
 Move(bitFile^._File,_File,SizeOf(File));
 If(BitFile^.Mask = 0)Then
  If(putc(Char(bitfile^.Rack),_File) <> Char(bitFile^.Rack))Then
   FatalError('Erreur fatale dans OutputBit!');
End;

Procedure OutputBits(bitFile:BitFilePtr;Code:LongInt;Count:Integer);
Var Mask:LongInt;
    _File:File;_Text:Text Absolute _File;
    _Output:File Absolute Output;
Begin
 Mask := 1 shl (Count - 1);
 While (Mask <> 0) do If((Mask and Code) <> 0)Then
 Begin
  BitFile^.Rack := BitFile^.Rack or BitFile^.Mask;
  BitFile^.Mask := BitFile^.Mask shr 1;
  If(BitFIle^.Mask = 0)Then
  Begin
   Move(bitFile^._File,_File,SizeOf(File));
   If(putc(Char(bitFile^.Rack),_File) <> Char(bitFile^.Rack))Then
    FatalError('Error fatale dans OutputBits') Else
   If((BitFile^.PacifierCount and 2047) = 0)Then putc('.',_output);
   Inc(BitFile^.PacifierCount);
   BitFile^.Rack := 0;
   BitFile^.Mask := $80;
  End;
  Mask := Mask shr 1;
 End;
End;

Function InputBit(BitFile:BitFilePtr):Boolean;
Var Value:Integer;
    _Output:File Absolute Output;
Begin
 If(BitFile^.Mask = $80)Then
 Begin
  BitFile^.Rack := Integer(getc(BitFile^._File));
  If(BitFile^.Rack = EOF)Then FatalError('Erreur fatale dans InputBit!');
  If(BitFile^.PacifierCount and 2047 = 0)Then putc('.',_Output);
  Inc(BitFile^.PacifierCount);
 End;
 value := BitFile^.Rack and BitFile^.Mask;
 BitFile^.Mask := BitFile^.Mask shr 1;
 If(BitFile^.Mask = 0)Then BitFile^.Mask := $80;
 InputBit := (Value <> 0);
End;

Procedure InitializeOptions(argc:Integer;argv:Array of PChar);
Var I,Err:Integer;
Begin
 For I := 0 to argc - 1 do
 Begin
  If(StrComp(argv[I],'-o') = 0)Then
  Begin
   Inc(I);
   Val(StrPas(argv[I]),MaxOrder,Err);
  End
   Else
  WriteLn('Argument inconnue dans la ligne de commande: ',argv[I]);
 End;
End;

Function AllocateNextOrderTable(Table:ContextPtr;Symbol:Integer;
	 LesserContext:ContextPtr):ContextPtr;
Var NewTable:ContextPtr; I:Integer; NewSize:Word; TPtr:Pointer;
Begin
 For I := 0 to Table^.MaxIndex do
  If(Table^.Stats^[I].Symbol = Symbol)Then Break;
 If(I > Table^.MaxIndex)Then
 Begin
  Inc(Table^.MaxIndex);
  NewSize := SizeOf(LinksRec) * (Table^.MaxIndex + 1);
  If(Table^.Links = NIL)Then Table^.Links := MemAlloc(NewSize)
   Else
  Begin
   TPtr := MemAlloc(NewSize);
   Move(Table^.Links,TPtr^,SizeOf(LinksRec));
   Dispose(Table^.Links);
   Table^.Links := TPtr;
  End;
  NewSize := SizeOf(StatsRec) * (Table^.MaxIndex + 1);
  If(Table^.Stats = NIL)Then Table^.Stats := MemAlloc(NewSize)
   Else
  Begin
   TPtr := MemAlloc(NewSize);
   Move(Table^.Stats,TPtr^,SizeOf(StatsRec));
   Dispose(Table^.Stats);
   Table^.Stats := TPtr;
  End;
  If(Table^.Links = NIL)Then
   FatalError('chec #6: Impossible de r‚server de la m‚moire pour la nouvelle table!');
  If(Table^.Stats = NIL)Then
   FatalError('chec #7: Impossible de r‚server de la m‚moire pour la nouvelle table!');
  Table^.Stats^[I].Symbol := Symbol;
  Table^.Stats^[I].Count := 0;
 End;
 NewTable := MemAlloc(SizeOf(Context));
 If(NewTable = NIL)Then
  FatalError('chec #8: Impossible de r‚server de la m‚moire pour la nouvelle table!');
 NewTable^.MaxIndex := -1;
 Table^.Links^[I].Next := NewTable;
 NewTable^.LesserContext := LesserContext;
 AllocateNextOrderTable := NewTable;
End;

Procedure InitializeModel;
Var I:Integer;
    NullTable,ControlTable:^Context;
Begin
 CurrOrder := MaxOrder;
 Contexts := MemAlloc(SizeOf(Context)*10);
 If(Contexts = NIL)Then
  FatalError('chec #1: Impossible de r‚server de la m‚moire pour la table de contexte!');
 NullTable := MemAlloc(SizeOf(Context));
 If(NullTable = NIL)Then
  FatalError('chec #2: Impossible de r‚server de la m‚moire pour la table nulle!');
 NullTable^.MaxIndex := -1;
 Move(NullTable,Contexts^[2],SizeOf(NullTable));
 For I := 0 to MaxOrder do
  Contexts^[2+I] := AllocateNextOrderTable(Contexts^[I+1],0,Contexts^[I+1]);
 Dispose(NullTable^.Stats);
 NullTable^.Stats := MemAlloc(SizeOf(StatsRec)*256);
 If(NullTable^.Stats = NIL)Then
  FatalError('chec #3: Impossible de r‚server de la m‚moire pour la table nulle!');
 NullTable^.MaxIndex := 255;
 For I := 0 to 255 do
 Begin
  NullTable^.Stats^[I].Symbol := I;
  NullTable^.Stats^[I].Count  := 1;
 End;
 ControlTable := MemAlloc(SizeOf(Context));
 If(ControlTable = NIL)Then
  FatalError('chec #4: Impossible de r‚server de la m‚moire pour la table nulle!');
 ControlTable^.Stats := MemAlloc(SizeOf(StatsRec)*2);
 If(ControlTable^.Stats = NIL)Then
  FatalError('chec #5: Impossible de r‚server de la m‚moire pour la table nulle!');
 Contexts^[2]^ := ControlTable^;
 ControlTable^.MaxIndex := 1;
 ControlTable^.Stats^[0].Symbol := -Flush;
 ControlTable^.Stats^[0].Count := 1;
 ControlTable^.Stats^[1].Symbol := -Done;
 ControlTable^.Stats^[1].Count := 1;
 For I := 0 to 255 do ScoreBoard[I] := 0;
End;

Procedure InitializeArithmeticEncoder;
Begin
 Low := 0; High := $FFFF; underflowbits := 0;
End;

Procedure InitializeArithmeticDecoder(Stream:BitFilePtr);
Var I:Integer;
Begin
 Code := 0;
 For I := 0 to 15 do Code := (Code shl 1) + Byte(InputBit(Stream));
 low := 0; High := $FFFF;
End;

Function ChkCompress(Input,Output:BitFilePtr):Boolean;
Const LocalInputMarker:LongInt = 0;
      LocalOutputMarker:LongInt = 0;
Var TotalInputBytes,TotalOutputBytes:LongInt;
    LocalRatio:Integer;
Begin
 TotalInputBytes := fTell(Input) - localInputMarker;
 TotalOutputBytes := fTell(Output);
 Dec(TotalOutputBytes,localOutputMarker);
 If(TotalOutputBytes = 0)Then TotalOutputBytes := 1;
 LocalRatio := Integer((TotalOutputBytes * 100) div TotalInputBytes);
 LocalInputMarker := fTell(Input);
 LocalOutputMarker := fTell(Output);
 ChkCompress := LocalRatio > 90;
End;

Procedure RescaleTable(Table:ContextPtr);
Var I:Integer; TPtr:Pointer;
Begin
 If(Table^.MaxIndex = -1)Then Exit;
 For I := 0 to Table^.MaxIndex do
  Table^.Stats^[I].Count := Table^.Stats^[I].Count shr 1;
 If(Table^.Stats^[Table^.MaxIndex].Count = 0)and(Table^.Links = NIL)Then
 Begin
  While (Table^.Stats^[Table^.MaxIndex].Count = 0)and(Table^.MaxIndex >= 0) do
   Dec(Table^.MaxIndex);
  If(Table^.MaxIndex = -1)Then
  Begin
   Dispose(Table^.Stats);
   Table^.Stats := NIL;
  End
   Else
  Begin
   TPtr := MemAlloc(SizeOf(StatsRec)*(Table^.MaxIndex+1));
   Move(Table^.Stats,TPtr^,SizeOf(StatsRec));
   Dispose(Table^.Stats);
   Table^.Stats := TPtr;
   If(Table^.Stats = NIL)Then
    FatalError('chec #11: Impossible de r‚server de la m‚moire pour rediriger de la table d''espace!');
  End;
 End;
End;

Procedure TotalizeTable(Table:ContextPtr);
Var I:Integer; Max:Byte;
Begin
 Repeat
  Max := 0;
  I := Table^.MaxIndex + 2;
  Totals[I] := 0;
  While (I > 1) do
  Begin
   Totals[i-1] := Totals[i];
   If(Table^.Stats^[i-2].Count <> 0)Then
    If((CurrOrder = -2)or(ScoreBoard[Table^.Stats^[i-2].Symbol] = 0))Then
     Inc(Totals[i-2],Table^.Stats^[i-2].Count);
   If(Table^.Stats^[i-2].Count > Max)Then Max := Table^.Stats^[i-2].Count;
   Dec(I);
  End;
  If(Max = 0)Then Totals[0] := 1
	     Else Totals[0] := ((((256 - Table^.MaxIndex) *
			       Table^.MaxIndex) shr 8) div Max)+1+Totals[1];
  If(Totals[0] < MaximumScale)Then Break;
  RescaleTable(Table);
 Until False;
 For I := 0 to Table^.MaxIndex do
  If(Table^.Stats^[i].Count <> 0)Then
   ScoreBoard[Table^.Stats^[I].Symbol] := 1;
End;

Function ConvertInt2Symbol(C:Integer;S:Symbol):Integer;
Var I:Integer; Table:ContextPtr;
Begin
 Table := Contexts^[2+CurrOrder];
 TotalizeTable(Table);
 S.Scale := Totals[0];
 If(CurrOrder = -2)Then c := -c;
 For I := 0 to Table^.MaxIndex do
 Begin
  If(C = Table^.Stats^[I].Symbol)Then
  Begin
   If(Table^.Stats^[I].Count = 0)Then Break;
   S.LowCount := Totals[1];
   S.HighCount := Totals[0];
   ConvertInt2Symbol := 0;
   Exit;
  End;
 End;
 S.LowCount := Totals[1];
 S.HighCount := Totals[0];
 Dec(CurrOrder);
 ConvertInt2Symbol := 1;
End;

Function ConvertSymbol2Int(Count:Integer;S:Symbol):Integer;
Var c:Integer; Table:ContextPtr;
Begin
 Table := Contexts^[2+CurrOrder];
 c := 0;
 While (Count < Totals[c]) do Inc(c);
 S.HighCount := Totals[c-1];
 S.LowCount := Totals[c];
 If(c = 1)Then
 Begin
  Dec(CurrOrder);
  ConvertSymbol2Int := Escape;
  Exit;
 End;
 If(CurrOrder < -1)Then ConvertSymbol2Int := -Table^.Stats^[c-2].Symbol
		   Else ConvertSymbol2Int := Table^.Stats^[c-2].Symbol;
End;

Procedure EncodeSymbol(Stream:BitFilePtr;S:Symbol);
Var Range:LongInt;
Begin
 Range := (High-Low)+1;
 High := Low + ((range * S.HighCount) div (S.Scale-1));
 Inc(Low,(Range*s.LowCount) div S.Scale);
 Repeat
  If((High and $8000) = (low and $8000))Then
  Begin
   OutputBit(Stream,high and $8000);
   While (Underflowbits > 0) do OutputBit(Stream,(Not(High)) and $8000);
   Dec(UnderflowBits);
  End
   else
  If((Low and $4000)and(Not(High and $4000)) <> 0)Then
  Begin
   Inc(UnderflowBits);
   Low := Low and $3FFF;
   High := High or $4000;
  End
   Else
  Exit;
  Low := Low shl 1;
  High := (High shl 1) or 1;
 Until False;
End;

Procedure RecursiveFlush(Table:ContextPtr);
Var I:Integer;
Begin
 If(Table^.Links <> NIL)Then
  For I := 0 to Table^.MaxIndex do
   If(Table^.Links^[I].Next <> NIL)Then
    RecursiveFlush(Table^.Links^[I].Next);
 RescaleTable(Table);
End;

Procedure FlushModel;
Var _Output:File Absolute Output;
Begin
 putc('F',_Output);
 RecursiveFlush(Contexts^[2]);
End;

Procedure UpdateTable(Table:ContextPtr;Symbol:Integer);
Var I,index:Integer; Temp:Byte; TempPtr:ContextPtr; NewSize:Word; TPtr:Pointer;
Begin
 Index := 0;
 While((Index <= Table^.MaxIndex)and(Table^.Stats^[Index].Symbol <> Symbol)) do
  Inc(Index);
 If(Index > Table^.MaxIndex)Then Inc(Table^.MaxIndex);
 NewSize := SizeOf(LinksRec) * (Table^.MaxIndex + 1);
 If(CurrOrder < MaxOrder)Then
 Begin
  If(Table^.MaxIndex = 0)Then Table^.Links := MemAlloc(NewSize)
   Else
  Begin
   TPtr := MemAlloc(NewSize);
   Move(Table^.Links,TPtr^,SizeOf(LinksRec));
   Dispose(Table^.Links);
   Table^.Links := TPtr;
  End;
  If(Table^.Links = NIL)Then
   FatalError('chec #9: Impossible de r‚server de la m‚moire pour rediriger la table d''espace!');
  Table^.Links^[Index].Next := NIL;
 End;
 NewSize := SizeOf(StatsRec) * (Table^.MaxIndex + 1);
 If(Table^.MaxIndex = 0)Then Table^.Stats := MemAlloc(NewSize)
  Else
 Begin
  TPtr := MemAlloc(NewSize);
  Move(Table^.Stats,TPtr^,SizeOf(StatsRec));
  Dispose(Table^.Stats);
  Table^.Stats := TPtr;
 End;
 If(Table^.Stats = NIL)Then
  FatalError('chec #10: Impossible de r‚server de la m‚moire pour la rediriger la table d''espace!');
 Table^.Stats^[Index].Symbol := Symbol;
 Table^.Stats^[Index].Count := 0;
  { Maintenant je d‚place le "front" de cette liste. }
 I := Index;
 While ((I > 0)and(Table^.Stats^[Index].Count = Table^.Stats^[I-1].Count)) do
  Dec(I);
 If Not(I = Index)Then
 Begin
  Temp := Table^.Stats^[Index].Symbol;
  Table^.Stats^[Index].Symbol := Table^.Stats^[I].Symbol;
  Table^.Stats^[I].Symbol := Temp;
  If(Table^.Links = NIL)Then
  Begin
   TempPtr := Table^.Links^[Index].Next;
   Table^.Links^[Index].Next := Table^.Links^[I].Next;
   Table^.Links^[I].Next := TempPtr;
  End;
  Index := I;
 End;
 Inc(Table^.Stats^[Index].Count);
 If(Table^.Stats^[Index].Count = 255)Then RescaleTable(Table);
End;

Procedure UpdateModel(Symbol:Integer);
Var I,LocalOrder:Integer;
Begin
 If(CurrOrder < 0)Then LocalOrder := 0
		  Else LocalOrder := CurrOrder;
 If(Symbol >= 0)Then
 Begin
  While(LocalOrder <= MaxOrder) do
  Begin
   If(Symbol >= 0)Then UpdateTable(Contexts^[2+LocalOrder],Symbol);
   Inc(LocalOrder);
  End;
 End;
 CurrOrder := MaxOrder;
 For I := 0 to 255 do ScoreBoard[I] := 0;
End;

Function Shift2NextContext(Table:ContextPtr;c,order:Integer):ContextPtr;
Var I:Integer; NewLesser:ContextPtr;
Begin
 Table := Table^.LesserContext;
 If(Order = 0)Then
 Begin
  Shift2NextContext := Table^.Links^[0].Next;
  Exit;
 End;
 For I := 0 to Table^.MaxIndex do
  If(Table^.Stats^[I].Symbol = c)Then
   If(Table^.Links^[I].Next <> NIL)Then
   Begin
    Shift2NextContext := Table^.Links^[I].Next;
    Exit;
   End
    Else
   Break;
 NewLesser := Shift2NextContext(Table,c,Order-1);
 Table := AllocateNextOrderTable(Table,C,NewLesser);
 Shift2NextContext := Table;
End;

Procedure AddChr2Model(C:Integer);
Var I:Integer;
Begin
 If(MaxOrder < 0)or(C < 0)Then Exit;
 Contexts^[2+MaxOrder] := Shift2NextContext(Contexts^[2+MaxOrder],c,MaxOrder);
 For I := MaxOrder-1 downto 0 do
  Contexts^[2+i] := Contexts^[I+3]^.LesserContext;
End;

Procedure FlushArithmeticEncoder(Output:BitFilePtr);
Begin
 OutputBit(stream,low and $4000);
 Inc(UnderflowBits);
 While (underflowbits-1 > 0) do OutputBit(stream,-low and $4000);
 OutputBits(stream,LongInt(0),16);
End;

Procedure GetSymbolScale(Var S:Symbol);
Var Table:ContextPtr;
Begin
 Table := Contexts^[2+CurrOrder];
 TotalizeTable(Table);
 S.Scale := Totals[0];
End;

Function GetCurrCount(Var S:Symbol):Integer;
Var Range:LongInt; Count:Integer;
Begin
 Range := High - Low + 1;
 Count := ((Code - low + 1) * S.Scale-1) div Range;
 GetCurrCount := Count;
End;

Procedure RemoveSymbolFromStream(Input:BitFilePtr;Var S:Symbol);
Var Range:LongInt;
Begin
 Range := High - Low + 1;
 High := Low + (Range * S.HighCount) div S.Scale - 1;
 Low := Low + (Range * S.LowCount) div S.Scale;
 Repeat
  If Not((High and $8000) = (Low and $8000))Then
  Begin
   If((Low and $4000) = $4000)and((High and $4000) = 0)Then
   Begin
    Code := Code xor $4000;
    Low := Low and $3FFF;
    High := High or $4000;
   End
    Else
   Exit;
  End
   Else
  Exit;
  Low := Low shl 1;
  High := (High shl 1) or 1;
  Code := (Code shl 1) + Byte(InputBit(Stream));
 Until False;
End;

Procedure CompressFile(Input,Output:BitFilePtr;argc:Integer;argv:PChar);
Const Flush:Integer = 0; TextCount:LongInt=0;
Var S:Symbol; C,Escaped:Integer;
Begin
 InitializeOptions(argc,argv);
 InitializeModel;
 InitializeArithmeticEncoder;
 Repeat
  If((TextCount and $FF) = 0)Then Flush := Integer(ChkCompress(Input,Output));
  If(Flush <> 0)Then c := Integer(getc(input^._File))
		else c := Flush;
  If(c = EOF)Then c := Done;
  Repeat
   Escaped := ConvertInt2Symbol(c,S);
   EncodeSymbol(Input,S);
  Until (Escaped <> 0);
  If(c = Done)Then Break;
  If(c = FLUSH)Then
  Begin
   FlushModel;
   Flush := 0;
  End;
  UpdateModel(C);
  AddChr2Model(C);
 Until False;
 FlushArithmeticEncoder(Output);
End;

Procedure ExpandFile(Input:BitFilePtr;Var Output:File;argc:Integer;argv:PChar);
Var S:Symbol; C,Count:Integer;
Begin
 InitializeOptions(argc,argv);
 InitializeModel;
 InitializeArithmeticDecoder(Input);
 Repeat
  Repeat
   GetSymbolScale(S);
   Count := GetCurrCount(S);
   C := ConvertSymbol2Int(Count,S);
   RemoveSymbolFromStream(Input,S);
  Until (C <> 0);
  If(c = Done)Then Break;
  If(c <> Flush)Then putc(Char(c),output)
		Else FlushModel;
  UpdateModel(c);
  AddChr2Model(C);
 Until False;
End;

BEGIN
END.