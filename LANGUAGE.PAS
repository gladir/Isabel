{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³             Malte Genesis III/Module du Langage            ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Language;

INTERFACE

{$I-,Q-,R-,S-,X+}

Uses Dos,Math,Mems;

Const

       IncludeFile = 100;

	{ Message Error Constant }

       PointCommaExpected          = -1;
       OpenEnsExpected             = -2;
       CloseEnsExpected            = -3;
       OpenArrayExpected           = -4;
       CloseArrayExpected          = -5;
       OpenParExpected             = -6;
       CloseParExpected            = -7;
       AsterixExpected             = -8;
       NumExpected                 = -9;
       GrExpected                  = -10;
       GuillExpected               = -11;
       CommaExpected               = -12;
       EnumExpected                = -13;
       NumberOfArrayExpected       = -14;
       EndOfFunctionExpected       = -15;
       EndOfSourceExpected         = -16;
       EndOfStringExpected         = -17;
       EndOfCommentExpected        = -18;
       EndOfCommandExpected        = -19;
       EndOfArgumentExpected       = -20;
       TypeVarExpected             = -21;
       VarNameExpected             = -22;
       DirectiveCommandExpected    = -23;
       TypedefNameExpected         = -24;
       IncludeFileNameExpected     = -25;
       IfDirectNameExpected        = -26;
       IfDefDirectNameExpected     = -27;
       IfNDefDirectNameExpected    = -28;
       WhileExpected               = -29;
       BeginExpected               = -30;
       NameExpected                = -31;
       ValueExpected               = -32;
       TypeExpected                = -33;
       OfExpected                  = -34;
       LabelExpected               = -35;
       EnumDupl                    = -50;
       VarStructDupl               = -51;
       UsePascalReservedWordForVar = -70;
       EnumEmpty                   = -80;
       StructEmpty                 = -81;
       TooManyPathInHeader         = -96;
       TooManyWarning              = -97;
       UnknownIdentifier           = -98;
       UnknownType                 = -99;
       SyntaxError                 = -100;
       SyntaxNumber                = -101;
       MisplacedBeginSymbol        = -127;
       MisplacedCondDirective      = -128;
       MisplacedEndSymbol          = -129;
       MisplacedPointComma         = -130;
       TooBigNumber                = -140;
       FileNotFound                = -200;
       CannotCreateFile            = -201;
       FileReadError               = -202;
       OutOfMemory                 = -254;
       InternalError               = -255;


	{ Message Warning Constant }

       SkipDefineFar               = -1;  (* Skip define "far".               *)
       SkipDefineSizeOf            = -2;  (* Skip define "sizeof".            *)
       DuplicateDefineSymbol       = -3;  (* Duplicate define symbol.         *)
       WrongValueInDefineDirective = -4;  (* Wrong value in define directive. *)

Type

     ModeType = (_Label_,_Const_,_Type_,_Var_,_None_);

     BooleanDirectivePtr = ^BooleanDirectiveRecord;

     BooleanDirectiveRecord = Record Name:PChar; Value:Bool; End;

     BooleanDirective = Object(RBuf)
      Constructor Init;
      Function Add(Name:String;Value:Bool):Bool;
      Function SearchValue(Name:String):Bool;
      Destructor Done;
     End;

     BankWord = Object(RBuf)
      Constructor Init;
      Function Add(Name:String):Bool;
      Function WordExist(Name:String):Bool;
      Function GetMaxWord:Int;
      Function GetWord(N:Word):String;
      Destructor Done;
     End;

     BankVarPtr = ^BankVarRec;

     BankVarRec = Record Name,TypeVar:PChar; Previous,Next:BankVarPtr; End;

     BankVar = Object
      Constructor Init;
      Function Add(Name,TypeVar:String):Bool;
      Function WordExist(Name:String):Bool;
      Function GetMaxWord:Integer;
      Procedure GetWord(N:Word;Var Name,TypeVar:String);
      Destructor Done;
      PRIVATE
      List,EndList:BankVarPtr;
     End;

Var

    NoUpper:Bool;

Procedure SkipSpcInLine(Var I:Byte;Line:String);

Function AutoUpper(Str:String):String;
Function BinByte2Str(X:Byte):String;
Function BinStr2Num(Str:String):Long;
Function ExtractCNum2Pascal(Var I:Byte;Line:String):String;
Function ExtractCStr(Var I:Byte;Line:String;Var EndMissing:Bool):String;
Function ExtractBinNum(Var I:Byte;Line:String):String;
Function ExtractDecNum(Var I:Byte;Line:String):String;
Function ExtractHexNum(Var I:Byte;Line:String):String;
Function ExtractOctNum(Var I:Byte;Line:String):String;
Function ExtractPascalStr(Var I:Byte;Line:String;Var EndMissing:Bool):String;
Function ExtractWord(Var I:Byte;Line:String):String;
Function GetNextLetter(I:Word;S:PChar):Char;
Function HexStr2Num(Str:String):Long;
Function IinStr(I:Byte;Str:String):Bool;
Function IsLangChrWord(Chr:Char):Bool;
Function IsPChrEmpty(PChr:PChar):Bool;
Function OctStr2Num(Str:String):Long;
Function PExtractCNum(Var I:Word;Line:PChar):String;
Function PExtractWord(Var I:Word;Line:PChar):String;

IMPLEMENTATION

Uses Strings,Strs;

Constructor BankVar.Init;
Begin
 List := NIL; EndList := NIL;
End;

Function BankVar.Add;
Var PBV:BankVarPtr; BV:BankVarRec; PName,PTypeVar:PChar;
Begin
 Add := False; PName := MemAlloc(Length(Name)+1);
 If(PName = NIL)Then Exit;
 StrPCopy(PName,Name);
 BV.Name := PName; PTypeVar := MemAlloc(Length(TypeVar)+1);
 If(PTypeVar = NIL)Then Exit;
 StrPCopy(PTypeVar,TypeVar);
 BV.TypeVar  := PTypeVar;
 BV.Previous := NIL;
 BV.Next     := NIL;
 PBV         := List;
 If Not(PBV = NIL)Then
 Begin
  While Not(PBV^.Next = NIL) do PBV := PBV^.Next;
  BV.Previous  := PBV;
  PBV^.Next    := MemAlloc(SizeOf(List^));
  EndList      := PBV^.Next;
  If(PBV^.Next = NIL)Then Exit;
  Move(BV,PBV^.Next^,SizeOf(List^));
 End
  Else
 Begin
  PBV     := MemAlloc(SizeOf(List^));
  If(PBV = NIL)Then Exit;
  List    := PBV;
  EndList := List;
  Move(BV,PBV^,SizeOf(List^));
 End;
 Add := True;
End;

Function BankVar.WordExist;
Var BV:BankVarPtr;
Begin
 WordExist := False; BV := EndList;
 If(StrPas(EndList^.Name) = Name)Then WordExist := True
  Else
 Begin
  While Not(BV^.Previous = NIL) do
  Begin
   BV := BV^.Previous;
   If(StrPas(BV^.Name) = Name)Then
   Begin
    WordExist := True;
    Exit;
   End;
  End;
 End;
End;

Function BankVar.GetMaxWord;
Var I:Int; BV:BankVarPtr;
Begin
 I := 0; BV := List;
 While Not(BV = NIL) do
 Begin
  Inc(I); BV := BV^.Next;
 End;
 Dec(I); GetMaxWord := I;
End;

Procedure BankVar.GetWord;
Var I:Word;
    BV:BankVarPtr;
Begin
 Name := ''; TypeVar := '';
 If(List = NIL)Then Exit;
 I := 0; BV := List;
 If(N > 0)Then For I := 1 to N do BV := BV^.Next;
 Name := StrPas(BV^.Name); TypeVar := StrPas(BV^.TypeVar);
End;

Destructor BankVar.Done;
Begin
End;

Constructor BankWord.Init;
Begin
 Inherited Init;
End;

Function BankWord.Add;
Begin
 Add := Inherited AddStr(Name);
End;

Function BankWord.WordExist;
Var I:Long; S:PChar;
Begin
 WordExist := False;
 For I := 0 to RBuf.MaxBuf do
 Begin
  S := Inherited _GetBuf(I);
  If(StrPas(S) = Name)Then
  Begin
   WordExist := True;
   Exit;
  End;
 End;
End;

Function BankWord.GetMaxWord;
Begin
 GetMaxWord := RBuf.MaxBuf;
End;

Function BankWord.GetWord;
Var S:PChar;
Begin
 S := Inherited _GetBuf(N);
 GetWord := StrPas(S);
End;

Destructor BankWord.Done;
Begin
 Inherited Done;
End;

Constructor BooleanDirective.Init;
Begin
 Inherited Init;
End;

Function BooleanDirective.Add;
Var Ptr:Pointer; BMC:BooleanDirectiveRecord; PName:PChar;
Begin
 Add := False; PName := MemAlloc(Length(Name)+1);
 If(PName = NIL)Then Exit;
 StrPCopy(PName,Name); BMC.Name := PName; BMC.Value := Value;
 Inherited AddBuf(SizeOf(BMC),Ptr);
 If(Ptr = NIL)Then Exit;
 Move(BMC,Ptr^,SizeOf(BMC));
 Add := True;
End;

Function BooleanDirective.SearchValue;
Var TMC:BooleanDirectivePtr; I:Long;
Begin
 SearchValue := False;
 For I := 0 to RBuf.MaxBuf do
 Begin
  TMC := Inherited _GetBuf(I);
  If(StrPas(TMC^.Name) = Name)Then
  Begin
   SearchValue := TMC^.Value;
   Exit;
  End;
 End;
End;

Destructor BooleanDirective.Done;
Begin
 Inherited Done;
End;

Function AutoUpper;
Begin
 If(NoUpper)Then AutoUpper := Str Else AutoUpper := StrUp(Str);
End;

Function BinStr2Num;
Var I:Byte; X:Long; StrLen:Byte Absolute Str;
Begin
 X := 0;
 For I := StrLen downto 1 do X := X or ((Byte(Str[I])-Byte('0')) shl (StrLen-I));
 BinStr2Num := X;
End;

Function BinByte2Str;
Begin
 BinByte2Str := Char(48+((X shr 7) and 1))+Char(48+((X shr 6) and 1))+
		Char(48+((X shr 5) and 1))+Char(48+((X shr 4) and 1))+
		Char(48+((X shr 3) and 1))+Char(48+((X shr 2) and 1))+
		Char(48+((X shr 1) and 1))+Char(48+(X and 1));
End;

Function ExtractBinNum(Var I:Byte;Line:String):String;
Var Word:String; Ok:Boolean;
Begin
 ExtractBinNum := '';
 If(I > Length(Line))Then Exit;
 Ok := True; Word := Line[I]; Inc(I);
 While ((I <= Length(Line))and(Ok)) do
 Begin
  Ok := (Line[I] in ['0'..'1']);
  If(Ok)Then
  Begin
   IncStr(Word,Line[I]); Inc(I);
  End;
 End;
 ExtractBinNum := Word;
End;

Function PExtractCNum(Var I:Word;Line:PChar):String;
Var Str:String;
Begin
 PExtractCNum := '';
 If(Line[I] = #0)Then Exit;
 Case Line[I] of
      '0' : Begin
	     Case Line[I+1] of
		 #0 : Begin
		       Inc(I); PExtractCNum := '0';
		      End;
	   '0'..'7' : Begin
		       Str := '';
		       While (Line[I] in ['0'..'7']) do
		       Begin
			IncStr(Str,Line[I]); Inc(I);
		       End;
		       PExtractCNum := Str;
		      End;
	    'B','b' : Begin
		       Str := '0' + Line[I+1];
		       Inc(I,Length('0b'));
		       While (Line[I] in ['0'..'1']) do
		       Begin
			IncStr(Str,Line[I]);
			Inc(I);
		       End;
		       PExtractCNum := Str;
		      End;
	    'X','x' : Begin
		       Str := '0' + Line[I+1];
		       Inc(I,Length('0x'));
		       While (Line[I] in ['0'..'9','A'..'F','a'..'f']) do
		       Begin
			IncStr(Str,Line[I]);
			Inc(I);
		       End;
		       PExtractCNum := Str;
		      End;
	    'L','l' : Begin
		       PExtractCNum := '0' + Line[I+1];
		       Inc(I,Length('0L'));
		      End;
		 Else Begin
		       PExtractCNum := '0';
		       Inc(I);
		      End;
	      End;
	     End;
  '1'..'9' : Begin
	      Str := '';
	      While (Line[I] in ['0'..'9']) do
	      Begin
	       IncStr(Str,Line[I]);
	       Inc(I);
	      End;
	      If(Line[I] in ['l','L'])Then
	      Begin
	       IncStr(Str,Line[I]);
	       Inc(I);
	      End;
	      PExtractCNum := Str;
	     End;
	Else PExtractCNum := '';
 End;
End;

Function ExtractCNum2Pascal;
Begin
 ExtractCNum2Pascal := '';
 If(I > Length(Line))Then Exit;
 Case Line[I] of
      '0' : Begin
	     If((I + 1) > Length(Line))Then
	     Begin
	      Inc(I);
	      ExtractCNum2Pascal := '0';
	     End
	      Else
	     Case Line[I+1] of
	   '0'..'7' : Begin
		       Inc(I,Length('0'));
		       ExtractCNum2Pascal := Str(OctStr2Num(ExtractOctNum(I,Line)));
		      End;
	    'B','b' : Begin
		       Inc(I,Length('Ob'));
		       ExtractCNum2Pascal := Str(BinStr2Num(ExtractBinNum(I,Line)));
		      End;
	    'X','x' : Begin
		       Inc(I,Length('0x'));
		       ExtractCNum2Pascal := ('$' + ExtractHexNum(I,Line));
		      End;
	    'L','l' : Begin
		       Inc(I,Length('0L'));
		       ExtractCNum2Pascal := 'LongInt(0)';
		      End;
		 Else Begin
		       ExtractCNum2Pascal := '0';
		       Inc(I);
		      End;
	      End;
	     End;
  '1'..'9' : Begin
	      If(I <= Length(Line))and(Line[I] = 'L')Then
	       ExtractCNum2Pascal := 'LongInt(' + ExtractDecNum(I,Line) + ')'
	      Else
	       ExtractCNum2Pascal := ExtractDecNum(I,Line);
	     End;
	Else ExtractCNum2Pascal := '';
 End;
End;

Function ExtractCStr;
Var Msg,NumStr:String; J:Byte; W:Word;

 Function EndStr:Bool;
 Begin
  EndStr := (I > Length(Line));
 End;

Begin
 ExtractCStr := ''; EndMissing := True; Msg := ''; Inc(I);
 While Not(Line[I] = '"') do
 Begin
  If(I > Length(Line))Then Exit;
  If(Line[I] = '\')Then
  Begin
   Inc(I);
   If Not(EndStr)Then
   Begin
    Case Line[I] of
      '?' : IncStr(Msg,'?');
      '\' : IncStr(Msg,'\');
      '"' : IncStr(Msg,'"');
     '''' : IncStr(Msg,'''');
      '0' : Begin
	     J := 0;
	     NumStr := '';
	     While (Line[I] in ['0'..'7']) do
	     Begin
	      IncStr(NumStr,Line[I]);
	      Inc(I);
	      If(EndStr)Then Exit;
	      Inc(J);
	      If(J > 3)Then Break;
	     End;
	     IncStr(Msg,Char(OctStr2Num(NumStr)));
	     Dec(I);
	    End;
      'a' : IncStr(Msg,#7);
      'b' : IncStr(Msg,#8);
      'f' : IncStr(Msg,#$C);
      'n' : IncStr(Msg,#$A);
      'r' : IncStr(Msg,#$D);
      't' : IncStr(Msg,#$B);
      'x' : Begin
	     J := 0;
	     NumStr := '';
	     While (Line[I] in ['0'..'9','A'..'F','a'..'f']) do
	     Begin
	      IncStr(NumStr,Line[I]);
	      Inc(I);
	      If(EndStr)Then Exit;
	      Inc(J);
	      If(J > 3)Then Break;
	     End;
	     W := HexStr2Num(NumStr);
	     If(Hi(W) = 0)Then IncStr(Msg,Char(W))
			  Else AddStr(Msg,Char(Lo(W)) + Char(Hi(W)));
	    End;
       Else IncStr(Msg,Line[I]);
    End;
    Inc(I);
   End
    Else
   Exit;
  End
   Else
  Begin
   IncStr(Msg,Line[I]);
   Inc(I);
  End;
 End;
 ExtractCStr := Msg;
 EndMissing  := False;
End;

Function ExtractDecNum(Var I:Byte;Line:String):String;
Var Word:String; Ok:Bool;
Begin
 ExtractDecNum := '';
 If(I > Length(Line))Then Exit;
 Ok := True; Word := Line[I]; Inc(I);
 While ((I <= Length(Line))and(Ok)) do
 Begin
  Ok := (Line[I] in ['0'..'9']);
  If(Ok)Then
  Begin
   IncStr(Word,Line[I]); Inc(I);
  End;
 End;
 ExtractDecNum := Word;
End;

Function ExtractHexNum;
Var Word:String; Ok:Bool;
Begin
 ExtractHexNum := '';
 If(I > Length(Line))Then Exit;
 Ok := True; Word := Line[I]; Inc(I);
 While ((I <= Length(Line))and(Ok)) do
 Begin
  Ok := (Line[I] in ['0'..'9','A'..'F','a'..'f']);
  If(Ok)Then
  Begin
   IncStr(Word,Line[I]); Inc(I);
  End;
 End;
 ExtractHexNum := Word;
End;

Function ExtractOctNum(Var I:Byte;Line:String):String;
Var Word:String; Ok:Bool;
Begin
 ExtractOctNum := '';
 If(I > Length(Line))Then Exit;
 Ok := True; Word := Line[I]; Inc(I);
 While ((I <= Length(Line))and(Ok)) do
 Begin
  Ok := (Line[I] in ['0'..'7']);
  If(Ok)Then
  Begin
   IncStr(Word,Line[I]); Inc(I);
  End;
 End;
 ExtractOctNum := Word;
End;

Function ExtractPascalStr;
Var Msg:String;

 Function GetNext:Char;
 Begin
  GetNext := #0;
  If(I+1 <= Length(Line))Then GetNext := Line[I+1];
 End;

Begin
 ExtractPascalStr := ''; EndMissing := True; Msg := ''; Inc(I);
 While (Not(Line[I] = ''''))or((Line[I] = '''')and(GetNext = '''')) do
 Begin
  If(I > Length(Line))Then Exit;
  If(Line[I] = '''')and(GetNext = '''')Then
  Begin
   IncStr(Msg,''''); Inc(I,2);
  End
   Else
  Begin
   IncStr(Msg,Line[I]); Inc(I);
  End;
 End;
 ExtractPascalStr := Msg; EndMissing := False;
End;

Function ExtractWord;
Var Word:String; WordLen:Byte Absolute Word; Ok:Bool;
    LineLen:Byte Absolute Line;
Begin
 ExtractWord := '';
 If(I > LineLen)Then Exit;
 If Not(Line[I] in ['A'..'Z','a'..'z','_'])Then Exit;
 Ok := True; WordLen := 1; Word[1] := Line[I]; Inc(I);
 While ((I <= LineLen)and(Ok)) do
 Begin
  Ok := (Line[I] in ['A'..'Z','a'..'z','0'..'9','_']);
  If(Ok)Then
  Begin
   IncStr(Word,Line[I]); Inc(I);
  End;
 End;
 ExtractWord := Word;
End;

Function GetNextLetter;
Begin
 While Not(S[I] = #0) do
 Begin
  If(S[I] in ['A'..'Z','a'..'z'])Then
  Begin
   GetNextLetter := S[I];
   Exit;
  End;
  Inc(I);
 End;
 GetNextLetter := #0;
End;

Function HexStr2Num;
Const HexChar : Array['A'..'F'] of Byte = (10,11,12,13,14,15);
      HexNum  : Array['0'..'9'] of Byte = (0,1,2,3,4,5,6,7,8,9);
Var I:Byte; X:Long; StrLen:Byte Absolute Str;
Begin
 X := 0; Str := StrUp(Str);
 For I := StrLen downto 1 do
 Begin
  If(Str[I] in ['A'..'F'])Then X := X or (HexChar[Str[I]] shl ((StrLen-I) * 4)) Else
  If(Str[I] in ['0'..'9'])Then X := X or (HexNum[Str[I]] shl ((StrLen-I) * 4));
 End;
 HexStr2Num := X;
End;

Function IinStr;
Var StrLen:Byte Absolute Str;
Begin
 IinStr := (I > 0)and(I <= StrLen);
End;

Function IsLangChrWord;
Begin
 IsLangChrWord := (Chr in ['A'..'Z','a'..'z','_']);
End;

Function IsPChrEmpty;
Begin
 IsPChrEmpty := ((PChr = NIL)or(PChr[0] = #0));
End;

Function OctStr2Num;
Var I:Byte; X:Long; StrLen:Byte Absolute Str;
Begin
 X := 0;
 For I := StrLen downto 1 do
  X := X or ((Byte(Str[I])-Byte('0')) shl ((StrLen-I) * 3));
 OctStr2Num := X;
End;

Function PExtractWord;
Var Word:String; Ok:Bool;
Begin
 PExtractWord := '';
 If(Line[I] = #0)Then Exit;
 If Not(Line[I] in ['A'..'Z','a'..'z','_'])Then Exit;
 Ok := True; Word := Line[I]; Inc(I);
 While ((Not(Line[I] = #0))and(Ok)) do
 Begin
  Ok := (Line[I] in ['A'..'Z','a'..'z','0'..'9','_']);
  If(Ok)Then
  Begin
   IncStr(Word,Line[I]); Inc(I);
   If(I = 255)Then Break;
  End;
 End;
 PExtractWord := Word;
End;

Procedure SkipSpcInLine;
Var LineLen:Byte Absolute Line;
Begin
 If(I > LineLen)Then Exit;
 While (Line[I] in [' ',#9]) do
 Begin
  Inc(I);
  If(I > LineLen)Then Exit;
 End;
End;

BEGIN { Main Unit }
 NoUpper := False;
END.