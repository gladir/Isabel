(********************************************************)
(*                                                      *)
(*                   Malte Genesis/AC                   *)
(*   Phoenix Edition for Real Mode & Protected Mode     *)
(*                   II - Version 1.8                   *)
(*                      1994/12/29                      *)
(*                                                      *)
(*      Copyiright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit AC;

INTERFACE

Uses Dos,Math;

Var I:Byte; L:Word;

Function ConvFileAC2Pas(Source,Target:PathStr):Int;

IMPLEMENTATION

Uses Strings,Systems,Language,Strs,Mems;

Const O : Array[0..10] of Char = '^*/\%+-я|оп';

Function Formula(S:String;Var Ok:Bool):String;
Var H,I,J:Byte; a,b,L:Long; Err:Word; aS,bS,T:String; Hex:Bool;
Begin
 Hex := False; Ok := True; Formula := '';
 If(S = '')Then Exit;
 For H := 0 to 10 do While (Pos(O[H],S) > 0) do
 Begin
  J := 1;
  For I := 1 to Length(S) do
  Begin
   If(S[I] = O[H])Then
   Begin
    aS := Copy(S,J,I-J);
    If(StrI(1,aS) = '_')Then as[1] := '-';
    If(StrI(1,aS) = '$')Then
    Begin
     a := HexStr2Num(CopyStr(aS,2,255)); Hex := True;
    End
     Else
    Begin
     If(aS = '')Then  Begin Formula := S; Exit; End;
     Val(aS,a,Err);
    End;
    Inc(I); bS := '';
    If(StrI(I,S) = '$')Then
    Begin
     Inc(I);
     Hex := True;
     While (StrI(I,S) in ['0'..'9','A'..'F','a'..'f']) do
     Begin
      IncStr(bS,S[I]);
      Inc(I);
      If(I > Length(S))Then Break;
     End;
     b := HexStr2Num(CopyStr(bS,2,255))
    End
     Else
    Begin
     If(StrI(I,S) in ['-','_'])Then
     Begin
      Inc(I); IncStr(bs,'-');
     End;
     While (S[I] in ['0'..'9']) do
     Begin
      IncStr(bS,S[I]); Inc(I);
      If(I > Length(S))Then Break;
     End;
     If(bS = '')Then
     Begin
      Formula := S;
      Exit;
     End;
     Val(bS,b,Err);
    End;
    If(a = 0)and(aS <> '0')Then Ok := False Else
    If(b = 0)and(bS <> '0')Then Ok := False
     Else
    Case H of
     0 : L := Trunc(a*Exp(b));
     1 : Begin
	  L := Long(a) * Long(b);
	  If((a or b) <> 0)and(L = 0)Then Ok := False;
	 End;
     2 : Begin
	  L := Long(a) div Long(b);
	  If((Long(a) Mod Long(b)) <> 0)Then Ok := False;
	 End;
     3 : L := Long(a) div Long(b);
     4 : L := Long(a) Mod Long(b);
     5 : Begin
	  L := Long(a) + Long(b);
	  If(L = 0)and((Long(a) or Long(b)) <> 0)Then Ok := False;
	 End;
     6 : L := Long(a) - Long(b);
     7 : L := Long(a) and Long(b);
     8 : L := Long(a) or Long(b);
     9 : L := Long(a) shl Long(b);
    10 : L := Long(a) shr Long(b);
    End;
    If Not(Ok)Then Exit;
    System.Str(L,T);
    If(StrI(1,T) = '-')Then T[1] := '_';
    S := Copy(S,1,J-1) + T + Copy(S,I,255);
    Break;
   End
    Else
   If Not(S[I] in ['$','_','0'..'9','A'..'F','a'..'f'])Then J := I + 1;
  End;
 End;
 ChgChr(S,'_','-');
 If(Hex)Then
 Begin
  Val(S,L,Err);
  If(L > $FFFF)Then S := HexLong2Str(L) Else
  If(L > $FF)Then S := HexWord2Str(L)
	     Else S := HexByte2Str(L);
  S := '$' + S;
 End;
 Formula := S;
End;

Function ConvFileAC2Pas;
Var HandleS,HandleT:Word; P,FS:Long; I2,_Begin:Byte; Err:Int; _Ptr,Rep:Bool;
    S,s1,s1U,s2,s2U,FuncS:String; LstConst,LstType:RBuf;
    ModePas:(_None,_Unit,_Interface,_Implementation);
    ModeInter:(_Off,_Const,_Type,_FuncHeader,_FuncVar,_InFunc,_AsmFunc);

 Procedure Return(V:Int);
 Begin
  Close(HandleT);
  Close(HandleS);
  LstConst.Done;
  LstType.Done;
  ConvFileAC2Pas := V;
 End;

 Function ExtractValConst:String;
 Var sE,sEU,sP,SR:String; J:Long; PChr:PChar; Ok:Bool; I3:Byte;
 Begin
  ExtractValConst := ''; SR := ''; Ok := True;
  SkipSpcInLine(I,S);
  Repeat
   Case StrI(I,S) of
    '(' :
    Begin
     Inc(I);
     AddStr(SR,ExtractValConst);
     SkipSpcInLine(I,S);
     If Not(StrI(I,S) = ')')Then Begin Err := SyntaxError; Exit; End
			    Else Inc(I);
    End;
    '-','0'..'9','.' :
    Begin
     If(S[I] = '-')Then  Begin IncStr(SR,'_'); Inc(I); End;
     sE := ExtractCNum2Pascal(I,S);
     If(StrI(I,S) = '.')Then
     Begin
      IncStr(sE,'.');
      Inc(I);
      AddStr(sE,ExtractCNum2Pascal(I,S));
     End;
     AddStr(SR,sE);
    End;
    'A'..'Z','a'..'z','_' :
    Begin
     sE := ExtractWord(I,S);
     sEU := StrUp(sE);
     If(sEU = 'FALSE')or(sEU = 'TRUE')Then AddStr(SR,sE) Else
     If(sEU = 'SIZEOF')Then
     Begin
      If(StrI(I,S) = '(')Then Inc(I)
       Else
      Begin
       Err := SyntaxError;
       Exit;
      End;
      sP := '';
      While Not(StrI(I,S) in [#0,')']) do
      Begin
       IncStr(sP,S[I]);
       Inc(I);
      End;
      If(StrI(I,S) = ')')Then Inc(I)
       Else
      Begin
       Err := SyntaxError;
       Exit;
      End;
      AddStr(SR,'SizeOf('+sP+')');
     End
      Else
     For J := 0 to LstConst.MaxBuf do
     Begin
      PChr := LstConst._GetBuf(J); sP := StrPas(PChr);
      If(CmpLeft(sP,sE))and(Pos('=',sP) = Length(sE) + 1)Then
      Begin
       AddStr(SR,CopyStr(sP,Length(sE)+2,255));
       Break;
      End;
     End;
    End;
    ' ',#9 : Begin Inc(I); Continue; End;
   End;
   SkipSpcInLine(I,S);
   Ok := (StrI(I,S) in ['^','*','/','\','+','-','%','|','&']);
   If(Ok)Then
   Begin
    If(S[I] = '&')Then IncStr(SR,'я') Else IncStr(SR,StrI(I,S));
    Inc(I);
   End
    Else
   Case StrI(I,S) of
    '<' : Case StrI(I,S) of
	   '<' : Begin IncStr(SR,'о'); Inc(I,2); Ok := True; End;
	  End;
    '>' : Case StrI(I,S) of
	   '>' : Begin IncStr(SR,'п'); Inc(I,2); Ok := True; End;
	  End;
   End;
  Until Not(Ok);
  SR := Formula(SR,Ok); I3 := Pos('\',SR);
  While (I3 > 0) do
  Begin
   DelChrAt(SR,I3); InsStr(SR,I3,' div '); I3 := Pos('\',SR);
  End;
  ExtractValConst := SR;
 End;

 Function ExtractType:String;
 Var oS,eS,eSU,sP:String; oL,eL,J:Long; PChr:PChar; _Rep:Bool;
 Begin
  ExtractType := '';
  SkipSpcInLine(I,S);
  Case StrI(I,S) of
   '#' :
   Begin
    Inc(I); oS := ExtractCNum2Pascal(I,S); oL := ValL(oS);
    If(oL > 255)Then
    Begin
     Err := TooBigNumber;
     Exit;
    End;
    If(StrI(I,S) = '#')Then Inc(I)
     Else
    Begin
     Err := TooBigNumber;
     Exit;
    End;
    If(StrI(I,S) = '.')and(StrI(I+1,S) = '.')Then
    Begin
     Inc(I,2);
     eS := ExtractCNum2Pascal(I,S); eL := ValL(eS);
     If(eL > 255)or(eL < oL)Then
     Begin
      Err := TooBigNumber;
      Exit;
     End;
     ExtractType := '#' + oS + '..#' + eS;
    End
     Else
    Begin
     Err := SyntaxError;
     Exit;
    End;
   End;
   '{' :
   Begin
    Inc(I);
    SkipSpcInLine(I,S);
    eS := ExtractType;
    SkipSpcInLine(I,S);
    sP := '';
    Repeat
     AddStr(sP,ExtractWord(I,S));
     SkipSpcInLine(I,S);
     If(StrI(I,S) = ',')Then
     Begin
      _Rep := True;
      Inc(I);
      SkipSpcInLine(I,S);
      IncStr(sP,',');
     End
      Else
     _Rep := False;
    Until Not(_Rep);
    If(StrI(I,S) = '}')Then Inc(I);
    ExtractType := 'Record ' + sP + ':' + eS + '; End';
    Exit;
   End;
   'A'..'Z','a'..'z','_' :
   Begin
    eS := ExtractWord(I,S); eSU := StrUp(eS);
    If(eSU = 'SET')Then
    Begin
     SkipSpcInLine(I,S);
     If Not(StrUp(ExtractWord(I,S)) = 'OF')Then
     Begin
      Err := OfExpected;
      Exit;
     End;
     SkipSpcInLine(I,S);
     ExtractType := 'Set of ' + ExtractWord(I,S);
    End
     Else
    If(eSU = 'VOID')Then  Begin ExtractType := 'Procedure'; Exit; End  Else
    If(eS = 'int')Then  Begin ExtractType := 'Integer'; Exit; End  Else
    Begin
     For J := 0 to LstType.MaxBuf do
     Begin
      PChr := LstType._GetBuf(J); sP := StrUp(StrPas(PChr));
      If(CmpLeft(sP,eSU))and(Pos('=',sP) = Length(eS) + 1)Then
      Begin
       ExtractType := eS;
       Exit;
      End;
     End;
     Err := UnknownIdentifier;
     Exit;
    End;
   End;
   Else
   Begin
    Err := SyntaxError;
    Exit;
   End;
  End;
 End;

 Function ExtractLabel:String;
 Var Sx:String;
 Begin
  Sx := '';
  While StrI(I,S) in ['@','A'..'Z','a'..'z','_','0'..'9']  do
  Begin
   IncStr(Sx,S[I]); Inc(I);
  End;
  ExtractLabel := Sx;
 End;

Begin
 ConvFileAC2Pas := 0; _Begin := 0; HandleS := Open(Source,ReadOnly);
 If(IsHandleErr(HandleS))Then
 Begin
  ConvFileAC2Pas := FileNotFound;
  Exit;
 End;
 If(FileExist(Target))Then Del(Target);
 HandleT := New(Target);
 If(IsHandleErr(HandleT))Then
 Begin
  ConvFileAC2Pas := CannotCreateFile;
  Exit;
 End;
 FS := FileSize(HandleS);
 LstConst.Init;
 LstConst.AddStr('MAXINT=32768');
 LstConst.AddStr('MAXLONGINT=2147483647');
 LstType.Init;
 LstType.AddStr('BOOLEAN=1:FALSE..TRUE');
 LstType.AddStr('BYTE=1:0..255');
 LstType.AddStr('BYTEBOOL=1:FALSE..TRUE');
 LstType.AddStr('CHAR=1:#0..#255');
 LstType.AddStr('COMP=8:');
 LstType.AddStr('DOUBLE=8:FLOAT');
 LstType.AddStr('EXTENDED=10:FLOAT');
 LstType.AddStr('FILE=128:');
 LstType.AddStr('INTEGER=2:-32768..32768');
 LstType.AddStr('LONGBOOL=4:FALSE..TRUE');
 LstType.AddStr('LONGINT=4:-2147483648..2147483647');
 LstType.AddStr('PCHAR=4:^CHAR');
 LstType.AddStr('POINTER=4:^UNTYPED');
 LstType.AddStr('REAL=6:FLOAT');
 LstType.AddStr('SHORTINT=1:-128..127');
 LstType.AddStr('SINGLE=4:FLOAT');
 LstType.AddStr('STRING=0..255:CHAR');
 LstType.AddStr('TEXT=128:FILE OF CHAR');
 LstType.AddStr('WORD=2:0..65535');
 LstType.AddStr('WORDBOOL=2:FALSE..TRUE');
 Err := 0; P := 0; L := 0; ModePas := _None; ModeInter := _Off;
 Repeat
  SetFilePos(HandleS,P);
  S := GetFileTextLn(HandleS);
  Inc(L);
  Inc(P,LongInt(Length(S)+2));
  If(FileError <> 0)Then
  Begin
   ConvFileAC2Pas := FileReadError;
   Exit;
  End;
  I := 1;
  If Not(S = '')Then While Not(StrI(I,S) = #0) do
  Begin
   Case StrI(I,S) of
    '/' :
    If(StrI(I+1,S) = '/')Then Break
     Else
    Begin
     Return(SyntaxError);
     Exit;
    End;
    '?' :
    Case ModePas of
     _Implementation :
     Begin
      If(StrI(I+1,S) = '(')and(StrI(I+2,S) = '>')and(StrI(I+3,S) = '=')and
        (StrI(I+4,S) = ')')Then
      Begin
       Inc(I,5);
       PutFileText(HandleT,'  JGE ');
       SkipSpcInLine(I,S);
       s := ExtractLabel;
       If(s = '')Then
       Begin
        Return(LabelExpected);
        Exit;
       End;
       PutFileTextLn(HandleT,s+';');
      End;
     End;
     Else
     Begin
      Return(SyntaxError);
      Exit;
     End;
    End;
    '#' :
    Case ModePas of
     _Interface :
     Begin
      Inc(I);
      s1 := ExtractWord(I,S);
      If(s1 = '')Then
      Begin
       Return(SyntaxError);
       Exit;
      End;
      s1U := StrUp(s1);
      If(s1U = 'DEFINE')Then
      Begin
       SkipSpcInLine(I,S);
       s1 := ExtractWord(I,S);
       SkipSpcInLine(I,S);
       s2 := ExtractWord(I,S);
       If(StrUp(s2) = '__INLINE')Then
       Begin
	If(StrI(I,S) = '(')Then Inc(I)
	 Else
	Begin
	 Return(OpenParExpected);
	 Exit;
	End;
	PutFileText(HandleT,'Procedure '+s1+'; InLine(');
	While Not(StrI(I,S) in [#0,')']) do
	Begin
	 PutFileText(HandleT,S[I]);
	 Inc(I);
	End;
	If(StrI(I,S) = ')')Then
	Begin
	 Inc(I);
	 PutFileTextLn(HandleT,');');
	End
	 Else
	Begin Return(CloseParExpected); Exit; End;
       End;
      End
       Else
      Begin Return(SyntaxError); Exit; End;
     End;
     Else
     Begin Return(SyntaxError); Exit; End;
    End;
    '}' :
    Case ModePas of
     _Interface :
     Case ModeInter of
      _Type,_Const :
      Begin
       PutFileLn(HandleT);
       Inc(I); ModeInter := _Off;
      End
      Else
      Begin
       Return(SyntaxError);
       Exit;
      End;
     End;
     Else
     Begin Return(SyntaxError); Exit; End;
    End;
    '{','_','A'..'Z','a'..'z' :
    Begin
     I2 := I; s1 := ExtractWord(I,S); s1U := StrUp(s1);
     Case ModePas of
      _None:
      If(s1U = 'UNIT')Then
      Begin
       SkipSpcInLine(I,S);
       s1 := ExtractWord(I,S);
       If(s1 = '')Then  Begin Return(NameExpected); Exit; End;
       PutFileTextLn(HandleT,'Unit '+s1+';');
       PutFileLn(HandleT);
       ModePas := _Unit;
      End
       Else
      Begin Return(SyntaxError); Exit; End;
      _Unit:
      If(s1U = 'PUBLIC')Then
      Begin
       PutFileTextLn(HandleT,'INTERFACE');
       PutFileLn(HandleT);
       ModePas := _Interface;
      End
       Else
      Begin Return(SyntaxError); Exit; End;
      _Implementation,
      _Interface:
      If(ModeInter in [_InFunc,_AsmFunc])Then
      Begin
       Case S[I] of
	'{':
	Begin
	 Inc(I); Inc(_Begin);
	 PutFileTextLn(HandleT,'Begin');
	End;
	Else
	Begin
	 If(s1U = '_AX')or(s1U = '_BX')or(s1U = '_CX')or(s1U = '_DX')Then
	 Begin
	  DelChrAt(s1,1); DelChrAt(s1U,1);
	  If(ModeInter <> _AsmFunc)Then PutFileTextLn(HandleT,' ASM');
	  SkipSpcInLine(I,S);
	  Case StrI(I,S) of
	   '=' :
	   Begin
	    Inc(I);
	    SkipSpcInLine(I,S);
	    s2 := ExtractWord(I,S); s2U := StrUp(s2);
	    If(s2U = '_AX')or(s2U = '_BX')or(s2U = '_CX')or(s2U = '_DX')Then
	     DelChrAt(s2,1);
	    PutFileTextLn(HandleT,'  MOV '+s1+','+s2+';');
	    SkipSpcInLine(I,S);
	   End;
	   '|' :
	   Begin
	    Inc(I);
	    If(StrI(I,S) = '=')Then Inc(I)
			       Else Begin Return(SyntaxError); Exit; End;
	    SkipSpcInLine(I,S);
	    s2 := ExtractWord(I,S); s2U := StrUp(s2);
	    If(s2U = '_AX')or(s2U = '_BX')or(s2U = '_CX')or(s2U = '_DX')Then
	     DelChrAt(s2,1);
	    PutFileTextLn(HandleT,'  OR  '+s1+','+s2+';');
	    SkipSpcInLine(I,S);
	   End;
	  End;
	  If(StrI(I,S) = ',')Then Inc(I);
	  ModeInter := _AsmFunc;
	 End
	  Else
	 Begin
	  Return(SyntaxError);
	  Exit;
	 End;
	End;
       End;
      End
       Else
      If(ModeInter = _Type)Then
      Begin
       I := I2; s2 := ExtractType;
       If(Err <> 0)Then
       Begin
	Return(Err);
	Exit;
       End;
       If(s2 = '')Then
       Begin
	Return(TypeExpected);
	Exit;
       End;
       Repeat
        SkipSpcInLine(I,S);
        If(StrI(I,S) = '*')Then
        Begin
         Inc(I);
	 If(s2 = 'Procedure')Then _Ptr := False Else _Ptr := True;
	End
	 Else
	_Ptr := False;
	s1 := ExtractWord(I,S);
	If(s1 = '')Then
	Begin
	 Return(NameExpected);
	 Exit;
	End;
	If(StrI(I,S) = '[')Then
	Begin
	 Inc(I); s1U := s1 + '=';
	 PutFileText(HandleT,Spc(5));
	 If(_Ptr)Then IncStr(s1U,'^');
	 AddStr(s1U,'Array[0..'); s1 := ExtractValConst;
	 If(s1 = '')Then
	 Begin
	  Return(ValueExpected);
	  Exit;
	 End;
	 AddStr(s1U,s1+'] of '+s2);
	 PutFileTextLn(HandleT,s1U+';');
	 LstType.AddStr(s1U);
	 If(StrI(I,S) = ']')Then Inc(I)
	  Else
	 Begin
	  Return(OpenArrayExpected);
	  Exit;
	 End;
	End
	 Else
	Begin
	 If(_Ptr)Then
	 Begin
	  PutFileTextLn(HandleT,Spc(5)+s1+'=^'+s2+';');
	  LstType.AddStr(s1+'=^'+s2);
	 End
	  Else
	 Begin
	  PutFileTextLn(HandleT,Spc(5)+s1+'='+s2+';');
	  LstType.AddStr(s1+'='+s2);
	 End;
	End;
	SkipSpcInLine(I,S);
	If(StrI(I,S) = ',')Then
	Begin
	 Inc(I); Rep := True;
	End
	 Else
	Rep := False;
       Until Not(Rep);
      End
       Else
      If(ModeInter = _Const)Then
      Begin
       s2 := ExtractValConst;
       If(Err <> 0)Then
       Begin
	Return(Err);
	Exit;
       End;
       If(s2 = '')Then
       Begin
	Return(ValueExpected);
	Exit;
       End;
       If Not(LstConst.AddStr(s1+'='+s2))Then
       Begin
	Return(OutofMemory);
	Exit;
       End;
       PutFileTextLn(HandleT,Spc(6)+s1+'='+s2+';');
      End
       Else
      If(s1U = 'PRIVATE')Then
      Begin
       If(ModePas = _Implementation)Then
       Begin
	Return(SyntaxError);
	Exit;
       End;
       PutFileLn(HandleT);
       PutFileTextLn(HandleT,'IMPLEMENTATION');
       PutFileLn(HandleT);
       ModePas := _Implementation;
      End
       Else
      If(s1U = 'TYPE')Then
      Begin
       SkipSpcInLine(I,S);
       If(StrI(I,S) = '{')Then
       Begin
	Inc(I); ModeInter := _Type;
	PutFileTextLn(HandleT,'Type');
	PutFileLn(HandleT);
       End
	Else
       Begin
	Return(OpenEnsExpected);
	Exit;
       End;
      End
       Else
      If(s1U = 'CONST')Then
      Begin
       SkipSpcInLine(I,S);
       If(StrI(I,S) = '{')Then
       Begin
	Inc(I); ModeInter := _Const;
	PutFileTextLn(HandleT,'Const');
	PutFileLn(HandleT);
       End
	Else
       Begin
	Return(OpenEnsExpected);
	Exit;
       End;
      End
       Else
      Begin
       SkipSpcInLine(I,S);
       If(StrI(I,S) = ';')Then
       Begin
	PutFileText(HandleT,'Procedure '+s1+';');
	If(ModePas = _Implementation)Then PutFileText(HandleT,' Forward;');
	PutFileLn(HandleT);
	Inc(I);
       End
	Else
       Begin
	If(StrI(I,S) = '(')Then
	Begin
	 Inc(I);
	 PutFileText(HandleT,'Procedure '+s1+'(');
	 FuncS := ''; Rep := True;
	End
	 Else
	Begin
	 Rep := True; I := I2; FuncS := ExtractType;
	 If(FuncS = '')Then
	 Begin
	  Return(SyntaxError);
	  Exit;
	 End;
	 SkipSpcInLine(I,S);
	 s1 := ExtractWord(I,S);
	 PutFileText(HandleT,'Function '+s1);
	 If(StrI(I,S) = '(')Then
	 Begin
	  Inc(I);
	  PutFileText(HandleT,'(');
	 End
	  Else
	 Rep := False;
	End;
	If(Rep)Then
	Begin
	 Repeat
	  SkipSpcInLine(I,S);
	  s1 := ''; s2 := '';
	  If(StrI(I,S) = '*')Then
	  Begin
	   Inc(I);
	   PutFileText(HandleT,'Var ');
	   SkipSpcInLine(I,S);
	   s2 := ExtractWord(I,S);
	   If(s2 = '')Then
	   Begin
	    Return(SyntaxError);
	    Exit;
	   End;
	   PutFileText(HandleT,s2);
	   SkipSpcInLine(I,S);
	  End
	   Else
	  Begin
	   s2 := ExtractType;
	   If(s2 = '')Then
	   Begin
	    Return(SyntaxError);
	    Exit;
	   End;
	   SkipSpcInLine(I,S);
	   If(StrI(I,S) = '*')Then
	   Begin
	    Inc(I); _Ptr := True;
	   End
	    Else
	   _Ptr := False;
	   s1 := ExtractWord(I,S);
	   If(s1 = '')Then
	   Begin
	    Return(SyntaxError);
	    Exit;
	   End;
	   SkipSpcInLine(I,S);
	   If(_Ptr)Then PutFileText(HandleT,'Var ');
	   If(StrI(I,S) = ':')Then
	   Begin
	    PutFileText(HandleT,s1);
	    Repeat
	     Inc(I);
	     SkipSpcInLine(I,S);
	     s1 := ExtractWord(I,S);
	     If(s1 = '')Then Break;
	     PutFileText(HandleT,','+s1);
	     SkipSpcInLine(I,S);
	    Until Not(StrI(I,S) = ':');
	    PutFileText(HandleT,':'+s2);
	   End
	    Else
	   PutFileText(HandleT,s1+':'+s2);
	  End;
	  If(StrI(I,S) = ',')Then
	  Begin
	   Rep := True; Inc(I);
	   PutFileText(HandleT,';');
	  End
	   Else
	  Rep := False;
	 Until Not(Rep);
	 SkipSpcInLine(I,S);
	 If(StrI(I,S) = ')')Then Inc(I)
	  Else
	 Begin
	  Return(SyntaxError);
	  Exit;
	 End;
	 PutFileText(HandleT,')');
	End;
	SkipSpcInLine(I,S);
	If(StrI(I,S) = ';')Then Inc(I)
	 Else
	Begin
	 If(ModePas = _Interface)Then
	 Begin
	  Return(SyntaxError);
	  Exit;
	 End
	  Else
	 ModeInter := _InFunc;
	End;
	If(FuncS = '')Then PutFileTextLn(HandleT,';')
		      Else PutFileTextLn(HandleT,':' + FuncS + ';');
       End;
      End;
      Else
      Begin
       Return(SyntaxError);
       Exit;
      End;
     End;
    End;
    ' ',#9 : Inc(I);
    Else
    Begin
     Return(SyntaxError);
     Exit;
    End;
   End;
   If(I > Length(S))Then Break;
  End;
 Until (P >= FS);
 Close(HandleT); Close(HandleS);
 LstConst.Done;
 LstType.Done;
End;

BEGIN
END.