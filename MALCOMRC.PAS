Unit MalComRC;

INTERFACE

{$O+,F+}

Uses Math;

Var ErrI,ErrJ:Word;
    ErrCode:Int;

Function CompileRC:Bool;

IMPLEMENTATION

Uses Dos,Strings,Strs,Editor,Systems,Mems,Language,
     MLibrary,Keyboard,Video,MalEnv,MalConv,MalLibrary;

Procedure PutLastBarMsgErrCompile;
Begin
 SetAllColor($1B,$1F);
 PutLastBar(2,'êchec de compilation: ^Presse une touche pour continuer...^');
End;

Procedure PutLastBarMsgOkCompile;
Begin
 SetAllColor($1B,$1F);
 PutLastBar(2,'Compilation RÇussit: Presse ^Enter^ pour continuer...');
End;

Procedure PutLastBarMsgProcessCompile;
Begin
 SetAllColor($1B,$1F);
 PutLastBar(2,'Compilation en cours: Presse ^Enter^ pour arràter');
End;

Procedure SetWn(X1,Y1,X2,Y2:Byte);
Begin
 WinPtr^.Model := wnEdit;
 GetNextWnPos(X1,Y1,X2,Y2);
 WinPtr^.P.Edit.PutWn(X1,Y1,X2,Y2);
 WinPtr^.P.Edit.Modified := True;
 WinPtr^.P.Edit.UpDateScr;
 WinPtr^.P.Edit.SetCur;
 WinPtr^.P.Edit.PutBar;
 CurrEdit := _Windows.MaxBuf;
 SetMnuSwitch;
End;

Function CompileRC;
Var Name,Func,_Type,NameType,S,a,b:String;
    Year,Month,Day,Week,InsProc,InsUses,_Begin,I,J,NumHeader:Word;
    IPath,MaxPath,MaxHeader,FirstElement,IHeader,MaxBuf:Int;
    CurrFunc:(None,Variable,LoadIni,SetupPath);
    Source,Target,Files:PathStr;
    BankName,BankSetupPath:RBuf;
    BankTarget:^WinRec;
    K,X1,Y1,X2,Y2:Byte;
    W:WinsWorking;
    PChr:PChar;

 Procedure Return(Code:Int);
 Begin
  PutMemory;
  ErrCode := Code;
  PutLastBarMsgErrCompile;
  ReadKey;
  BankTarget^.P.Edit.Lst.Done;
  _Windows.DelBuf(_Windows.MaxBuf);
  BankName.Done;
  BankSetupPath.Done;
  W.Done;
 End;

 Procedure _AddStr(Str:String);
 Begin
  BankTarget^.P.Edit.Lst.AddStr(Str);
  Inc(BankTarget^.P.Edit.FS,Length(Str)+2);
  BankTarget^.P.Edit.ChkMaxLen(Length(Str));
 End;

 Procedure _InsStr(P:Long;Str:String);
 Begin
  BankTarget^.P.Edit.Lst.InsStr(P,Str);
  Inc(BankTarget^.P.Edit.FS,Length(Str)+2);
  BankTarget^.P.Edit.ChkMaxLen(Length(Str));
 End;

 Procedure _AddSpcUStrPas(Str:String);
 Begin
  BankTarget^.P.Edit.Lst.AddSpcUStrPasType(Byte(Str[1]),Copy(Str,2,255));
  Inc(BankTarget^.P.Edit.FS,Length(Str)+2+Byte(Str[1]));
  BankTarget^.P.Edit.ChkMaxLen((Length(Str)-1)+Byte(Str[1]));
 End;

 Procedure _AddSpcUStr(Spc:Byte;Str:String);
 Begin
  BankTarget^.P.Edit.Lst.AddSpcUStr(Spc,Str);
  Inc(BankTarget^.P.Edit.FS,Length(Str)+2+Spc);
  BankTarget^.P.Edit.ChkMaxLen(Length(Str)+Spc);
 End;

 Procedure _AddStrPas(Str:String);
 Begin
  BankTarget^.P.Edit.Lst.AddStrPasType(Str);
  Inc(BankTarget^.P.Edit.FS,Length(Str)+2);
  BankTarget^.P.Edit.ChkMaxLen(Length(Str));
 End;

 Procedure _AddLn;
 Begin
  BankTarget^.P.Edit.Lst.AddLn;
  Inc(BankTarget^.P.Edit.FS,2);
 End;

 Function MaxHeaderPath:Int;
 Var I,N  : Long;
     PChr : PChar;
 Begin
  N := 0;
  BankSetupPath.SetPtr(0);
  For I := 0 to BankSetupPath.MaxBuf do
  Begin
   PChr := BankSetupPath._GetCurrBuf;
   If Not(PChr = NIL)Then
   Begin
    Case PChr[0] of
     #1 : Inc(N);
    End;
   End;
   BankSetupPath.Next;
  End;
  MaxHeaderPath := N - 1;
 End;

 Function GetMaxPathInSetup(P:Long;Var FirstElement:Int):Int;
 Var I,N,NP:Long; PChr:PChar; Ok:Bool;
 Begin
  NP := 0; N := 0; Ok := False; Inc(P);
  BankSetupPath.SetPtr(0);
  For I := 0 to BankSetupPath.MaxBuf do
  Begin
   PChr := BankSetupPath._GetCurrBuf;
   If Not(PChr = NIL)Then
   Begin
    Case PChr[0] of
     #1 : Begin
	   If(Ok)Then Break;
	   Inc(N);
	   If(N = P)Then
	   Begin
	    Ok := True;
	    FirstElement := I + 1;
	   End;
	  End;
     #2 : Begin
	   If(Ok)Then Inc(NP);
	  End;
    End;
   End;
   BankSetupPath.Next;
  End;
  GetMaxPathInSetup := NP - 1;
 End;

 Procedure GetDataPath(I:Int;Var Str,Name:String);
 Var S : String;
     J : Byte;
 Begin
  S := CopyStr(StrPas(BankSetupPath._GetBuf(I)),2,255);
  For J := 1 to Length(S) do If(S[J] = '"')Then
  Begin
   Inc(J);
   Break;
  End;
  Str := Copy(S,1,J-2); Name := Copy(S,J,255);
 End;

 Const

       _kbEsc             = #1;
       _kbUp              = #2;
       _kbDown            = #3;
       _kbTab             = #4;
       _kbEnter           = #5;
       _LN                = #14;
       _W_GetMaxXTxts     = #21;
       _W_GetMaxYTxts     = #22;
       _StrNew_           = #23;
       _StrDispose_       = #24;
       _W_PutPTxtXY_      = #25;
       _W_PutTxtXY_       = #26;
       _W_ClrEol_         = #27;
       _W_SetColr_        = #28;
       _W_SetColrBorder_  = #29;
       _W_BarSpcHorShade_ = #30;
       _Break_            = #31;

 Procedure _AddSpcUStrX(S:Byte;b:String);
 Var S1 : String;
     I  : Byte;
 Begin
  S1 := '';
  For I := 1 to Length(b) do
  Case b[I] of
	       _kbEsc : AddStr(S1,'kbEsc');
		_kbUp : AddStr(S1,'kbUp');
	      _kbDown : AddStr(S1,'kbDown');
	       _kbTab : AddStr(S1,'kbTab');
	     _kbEnter : AddStr(S1,'kbEnter');
       _W_GetMaxXTxts : AddStr(S1,'W.MaxXTxts');
       _W_GetMaxYTxts : AddStr(S1,'W.MaxYTXts');
	     _StrNew_ : AddStr(S1,'StrNew(');
	 _StrDispose_ : AddStr(S1,'StrDispose(');
	_W_PutPTxtXY_ : AddStr(S1,'W.PutPTxtXY(');
	 _W_PutTxtXY_ : AddStr(S1,'W.PutTxtXY(');
	   _W_ClrEol_ : AddStr(S1,'W.ClrEol;');
	  _W_SetColr_ : AddStr(S1,'W.SetKr(');
    _W_SetColrBorder_ : AddStr(S1,'W.SetKrBorder;');
   _W_BarSpcHorShade_ : AddStr(S1,'W.BarSpcHorShade(');
	      _Break_ : AddStr(S1,'Break;');
		  _LN : Begin
			 _AddSpcUStr(S,S1);
			 S1 := '';
			End;
		   Else IncStr(S1,b[I]);
  End;
  _AddSpcUStr(S,S1);
 End;

 Procedure SetupPathCopyPathBuf2(S:Byte;b:String);
 Begin
  _AddSpcUStrPas(Char(S)+'?(T'+b+' = NIL)® õCopy(PathBuf,'''')');
  _AddSpcUStrPas(Char(S)+Spc(Length(b)+Length('If(T = NIL)'))+'Else õCopy(PathBuf,T'+b+');');
 End;

 Procedure SetupPathInput(S,Y:Byte;b:String);
 Begin
  SetupPathCopyPathBuf2(S,b);
  _AddSpcUStrX(S,'K := W._Input(0,'+Str(Y)+','+_W_GetMaxXTxts+'-1,80,PPathBuf);');
  _AddSpcUStrX(S,_StrDispose_+'T'+b+');');
  _AddSpcUStrX(S,'T'+b+' := '+_StrNew_+'PPathBuf);');
  _AddSpcUStrX(S,_W_SetColr_+'$8F);');
  _AddSpcUStrX(S,'W.BarSelHor(0,'+Str(Y)+','+_W_GetMaxXTxts+'-1);');
 End;

 Procedure SetupPathInput_(S,X1,Y:Byte;X2,b:String);
 Begin
  SetupPathCopyPathBuf2(S,b);
  _AddSpcUStr(S,'K := W._Input('+Str(X1)+','+Str(Y)+','+X2+',80,PPathBuf);');
  _AddSpcUStrX(S,_StrDispose_+'T'+b+');');
  _AddSpcUStrX(S,'T'+b+' := '+_StrNew_+'PPathBuf);');
  _AddSpcUStrX(S,_W_SetColr_+'$8F);');
  _AddSpcUStrX(S,'W.BarSelHor('+Str(X1)+','+Str(Y)+','+X2+');');
 End;

 Procedure SetupPathInput3A(S,Y:Byte;b:String);
 Begin
  SetupPathInput_(S,0,Y,'20',b);
 End;

 Procedure SetupPathInput3B(S,Y:Byte;b:String);
 Begin
  SetupPathInput_(S,23,Y,'43',b);
 End;

 Procedure SetupPathInput3C(S,Y:Byte;b:String);
 Begin
  SetupPathInput_(S,46,Y,'W.MaxXTxts-1',b);
 End;

 Function ExtractNot(Chr:Char):String;
 Var Str : String;
 Begin
  Str := '';
  While Not(PChr[ErrI] = Chr) do
  Begin
   IncStr(Str,PChr[ErrI]);
   Inc(ErrI);
  End;
  ExtractNot := Str;
 End;

 Procedure SkipSpc;
 Begin
  While (PChr[ErrI] = ' ') do Inc(ErrI);
 End;

Begin
 CompileRC := False; CurrFunc := None; ErrCode := 0; _Begin := 0;
 InsProc := 4; InsUses := 7;
 PutLastBarMsgProcessCompile;
 W.Init;
 W.SetCompiler;
 Source := WinPtr^.P.Edit.GetName; Target := Path2NoExt(Source) + '.PAS';
 W.MainFile('RC','Pascal',Source,Target);
 W.TargetFormat('Fichier Pascal ASCII');
 W.FormatProcessor('Mode RÇel');
 W.Target('êditeur');
 BankTarget := _Windows._AddBuf(SizeOfWin);
 If(BankTarget = NIL)Then Exit;
 BankTarget^.P.Edit.Init(Target);
 BankTarget^.P.Edit.ViewMode(ViewPas);
 _AddStr('Unit ' + Path2Name(Source)+';');
 _AddLn;
 _AddStr('INTERFACE');
 _AddLn;
 _AddLn;
 _AddStr('IMPLEMENTATION');
 _AddLn;
 _AddStr('Uses Math, Strings, Strs, Keyboard, Video, Systems, Language, MLibrary, Windows, Dials, Terminal;');
 _AddLn;
 BankName.Init;
 BankSetupPath.Init;
 WinPtr^.P.Edit.Lst.SetPtr(0);
 For ErrJ := 0 to WinPtr^.P.Edit.MaxLns do
 Begin
  W.Line(ErrJ+1);
  W.TotalLine(ErrJ+1);
  W.LineCode(BankTarget^.P.Edit.Lst.NmBuf);
  PChr := WinPtr^.P.Edit.Lst._GetCurrBuf;
  If(PChr = NIL)Then
  Begin
   WinPtr^.P.Edit.Lst.Next;
   Continue;
  End;
  ErrI := 0;
  While Not(PChr[ErrI] = #0) do
  Begin
   Case PChr[ErrI] of
    'A'..'Z','a'..'z','_' :
    Case CurrFunc of
     None :
     Begin
      Name := PExtractWord(ErrI,PChr);
      If(StrUp(Name) = 'USES')Then
      Begin
       BankTarget^.P.Edit.Lst.DelBuf(InsUses);
       _InsStr(InsUses,'Uses Math, Strings, Strs, Keyboard, Video, Systems, Language, MLibrary, Windows, Dials, Terminal, ' +
	       CopyStr(StrPas(PChr),ErrI+2,255)+';');
       Break;
      End;
      If(StrUp(Name) = 'VARIABLE')Then CurrFunc := Variable
       Else
      Begin
       SkipSpc;
       Func := StrUp(PExtractWord(ErrI,PChr));
       If(Func = 'SETUPPATH')Then CurrFunc := SetupPath Else
       If(Func = 'LOADINI')Then
       Begin
	NumHeader := 0;
	CurrFunc  := LoadIni;
	SkipSpc;
	If Not(PChr[ErrI] = '"')Then
	Begin
	 Return(GuillExpected);
	 Exit;
	End;
	Inc(ErrI);
	Files := ExtractNot('"');
	If Not(PChr[ErrI] = '"')Then
	Begin
	 Return(GuillExpected);
	 Exit;
	End;
	Inc(ErrI);
       End;
      End;
     End;
     Variable:
     Begin
      If(_Begin = 1)Then
      Begin
       _Type := PExtractWord(ErrI,PChr);
       If(_Type = 'BEGIN')Then
       Begin
	Return(MisplacedBeginSymbol);
	Exit;
       End
	else
       If(_Type = 'END')Then
       Begin
	CurrFunc := None;
	Dec(_Begin);
       End
	Else
       Begin
	SkipSpc;
	Name := PExtractWord(ErrI,PChr);
	If(Name = '')Then
	Begin
	 Return(VarNameExpected);
	 Exit;
	End;
	If(InsProc = 4)Then
	Begin
	 _InsStr(4,'Var');
	 _InsStr(5,'');
	 Inc(InsProc,2);
	 Inc(InsUses,2);
	End;
	_InsStr(5,Spc(4)+Name+' : '+_Type+';');
	Inc(InsProc);
	Inc(InsUses);
       End;
      End
       Else
      Begin
       Func := PExtractWord(ErrI,PChr);
       If(StrUp(Func) = 'BEGIN')Then Inc(_Begin)
	Else
       Begin
	Return(BeginExpected);
	Exit;
       End;
      End;
     End;
     SetupPath:
     Begin
      If(_Begin = 1)Then
      Begin
       Func := StrUp(PExtractWord(ErrI,PChr));
       If(Func = 'BEGIN')Then
       Begin
	Return(MisplacedBeginSymbol);
	Exit;
       End
	else
       If(Func = 'END')Then
       Begin
	MaxHeader := MaxHeaderPath;
	MaxBuf    := BankSetupPath.MaxBuf;
	_InsStr(InsProc,'Procedure '+Name+';');
	_AddStrPas('û '+Name+';');
	_AddStr('Var '+StrUSpc('P, PP',17)+': Byte;');
	_AddSpcUStr(4,StrUSpc('W',17)+': Ansi;');
	_AddSpcUStr(4,StrUSpc('L',17)+': LstMnu;');
	_AddSpcUStr(4,StrUSpc('K',17)+': Word;');
	_AddSpcUStr(4,StrUSpc('PathBuf',17)+': Array[0..255] of Char;');
	_AddSpcUStr(4,StrUSpc('PPathBuf',17)+': PChar;');
	For IPath := 0 to MaxBuf do
	Begin
	 S := StrPas(BankSetupPath._GetBuf(IPath));
	 If(StrI(1,S) = #2)Then
	 Begin
	  GetDataPath(IPath,a,b);
	  _AddSpcUStr(4,'T'+StrUSpc(b,16)+': PChar;');
	 End;
	End;
	_AddLn;
	_AddSpcUStrPas(#1'û UpDateDir;');
	_AddSpcUStrPas(#1'Æ');
	_AddSpcUStr(1,' Case L.GetVal of');
	IHeader := 0;
	For IPath := 0 to BankSetupPath.MaxBuf do
	Begin
	 S := StrPas(BankSetupPath._GetBuf(IPath));
	 If(StrI(1,S) = #1)Then
	 Begin
	  Inc(IHeader);
	  _AddSpcUStr(3,Str(IHeader) + ' :');
	  _AddSpcUStrPas(#3'Æ');
	  MaxPath := GetMaxPathInSetup(IHeader-1,FirstElement);
	  Inc(IPath);
	  Case MaxPath of
	   0 : Begin
GetDataPath(IPath,a,b);
_AddSpcUStrX(4,_W_SetColrBorder_ + _LN + _W_PutTxtXY_+'0,7,'''+a+''');' + _LN +
_W_ClrEol_ + _LN + _W_SetColr_+'$8F);' + _LN + _W_BarSpcHorShade_+'0,8,'+_W_GetMaxXTxts+'-1);' + _LN +
_W_PutPTxtXY_+'0,8,'+b+');' + _LN + 'W.ClrWnBorder(0,10,'+_W_GetMaxXTxts+','+_W_GetMaxYTxts+'-2);');
	       End;
	   1 : Begin
GetDataPath(IPath,a,b);
_AddSpcUStrX(4,_W_SetColrBorder_ + _LN + _W_PutTxtXY_+'0,7,'''+a+''');' + _LN +
_W_ClrEol_ + _LN + _W_SetColr_+'$8F);' + _LN + _W_BarSpcHorShade_+'0,8,'+_W_GetMaxXTxts+'-1);' + _LN +
_W_PutPTxtXY_+'0,8,'+b+');');
Inc(IPath);
GetDataPath(IPath,a,b);
_AddSpcUStrX(4,_W_SetColrBorder_ + _LN + _W_PutTxtXY_+'0,10,'''+a+''');' + _LN +
_W_ClrEol_ + _LN + _W_SetColr_+'$8F);' + _LN + _W_BarSpcHorShade_+'0,11,'+_W_GetMaxXTxts+'-1);' + _LN +
_W_PutPTxtXY_+'0,11,'+b+');' + _LN + 'W.ClrWnBorder(0,13,'+_W_GetMaxXTxts+','+_W_GetMaxYTxts+'-2);');
	       End;
	   2 : Begin
GetDataPath(IPath,a,b);
_AddSpcUStrX(4,_W_SetColrBorder_ + _LN + _W_PutTxtXY_+'0,7,'''+a+''');' + _LN +
_W_ClrEol_ + _LN + _W_SetColr_+'$8F);' + _LN + _W_BarSpcHorShade_+'0,8,'+_W_GetMaxXTxts+'-1);' + _LN +
_W_PutPTxtXY_+'0,8,'+b+');');
Inc(IPath);
GetDataPath(IPath,a,b);
_AddSpcUStrX(4,_W_SetColrBorder_ + _LN + _W_PutTxtXY_+'0,10,'''+a+''');' + _LN +
_W_ClrEol_ + _LN + _W_SetColr_+'$8F);' + _LN + _W_BarSpcHorShade_+'0,11,'+_W_GetMaxXTxts+'-1);' + _LN +
_W_PutPTxtXY_+'0,11,'+b+');');
Inc(IPath);
GetDataPath(IPath,a,b);
_AddSpcUStrX(4,_W_SetColrBorder_ + _LN + _W_PutTxtXY_+'0,13,'''+a+''');' + _LN +
_W_ClrEol_ + _LN + _W_SetColr_+'$8F);' + _LN + _W_BarSpcHorShade_+'0,14,'+_W_GetMaxXTxts+'-1);' + _LN +
_W_PutPTxtXY_+'0,14,'+b+');' + _LN + 'W.ClrWnBorder(0,16,'+_W_GetMaxXTxts+','+_W_GetMaxYTxts+'-2);');
	       End;
	   3 : Begin
GetDataPath(IPath,a,b);
_AddSpcUStrX(4,'W.ClrWnBorder(0,8,'+_W_GetMaxXTxts+','+_W_GetMaxYTxts+'-2);' + _LN +
_W_SetColrBorder_ + _LN + _W_PutTxtXY_+'0,7,'''+a+''');' + _LN + _W_ClrEol_ + _LN + _W_SetColr_+'$8F);' + _LN +
_W_BarSpcHorShade_+'0,8,31);' + _LN + _W_PutPTxtXY_+'0,8,'+b+');');
Inc(IPath);
GetDataPath(IPath,a,b);
_AddSpcUStrX(4,_W_SetColrBorder_ + _LN + _W_PutTxtXY_+'34,7,'''+a+''');' + _LN +
_W_SetColr_+'$8F);' + _LN + _W_BarSpcHorShade_+'34,8,W.MaxXTxts-1);' + _LN +
_W_PutPTxtXY_+'34,8,'+b+');');
Inc(IPath);
GetDataPath(IPath,a,b);
_AddSpcUStrX(4,_W_SetColrBorder_ + _LN + _W_PutTxtXY_+'0,10,'''+a+''');' + _LN + _W_ClrEol_ + _LN +
_W_SetColr_+'$8F);' + _LN + _W_BarSpcHorShade_+'0,11,31);' + _LN + _W_PutPTxtXY_+'0,11,'+b+');');
Inc(IPath);
GetDataPath(IPath,a,b);
_AddSpcUStrX(4,_W_SetColrBorder_ + _LN + _W_PutTxtXY_+'34,10,'''+a+''');' + _LN +
_W_SetColr_+'$8F);' + _LN + _W_BarSpcHorShade_+'34,11,'+_W_GetMaxXTxts+'-1);' + _LN +
_W_PutPTxtXY_+'34,11,'+b+');');
	       End;
	 4,5 : Begin
		  GetDataPath(IPath,a,b);
		  _AddSpcUStrX(4,'W.ClrWnBorder(0,8,'+_W_GetMaxXTxts+','+_W_GetMaxYTxts+'-2);'+_LN+
				 _W_SetColrBorder_+ _LN +
				 _W_PutTxtXY_+'0,7,'''+a+''');' + _LN +
				 _W_SetColr_+'$8F);' + _LN +
				 _W_BarSpcHorShade_+'0,8,31);' + _LN +
				 _W_PutPTxtXY_+'0,8,'+b+');');
		  Inc(IPath);
		  GetDataPath(IPath,a,b);
		  _AddSpcUStrX(4,_W_SetColrBorder_ + _LN +
				 _W_PutTxtXY_+'34,7,'''+a+''');' + _LN +
				 _W_SetColr_+'$8F);' + _LN +
				 _W_BarSpcHorShade_+'34,8,'+_W_GetMaxXTxts+'-1);' + _LN +
				 _W_PutPTxtXY_+'34,8,'+b+');');
		  Inc(IPath);
		  GetDataPath(IPath,a,b);
		  _AddSpcUStrX(4,_W_SetColrBorder_ + _LN +
				 _W_PutTxtXY_+'0,10,'''+a+''');' + _LN +
				 _W_SetColr_+'$8F);' + _LN  +
				 _W_BarSpcHorShade_+'0,11,31);' + _LN +
				 _W_PutPTxtXY_+'0,11,'+b+');');
		  Inc(IPath);
		  GetDataPath(IPath,a,b);
		  _AddSpcUStrX(4,_W_SetColrBorder_ + _LN +
				 _W_PutTxtXY_+'34,10,'''+a+''');' + _LN +
				 _W_SetColr_+'$8F);' + _LN +
				 _W_BarSpcHorShade_+'34,11,'+_W_GetMaxXTxts+'-1);' + _LN +
				 _W_PutPTxtXY_+'34,11,'+b+');');
		  Inc(IPath);
		  GetDataPath(IPath,a,b);
		  _AddSpcUStrX(4,_W_SetColrBorder_ + _LN +
				 _W_PutTxtXY_+'0,13,'''+a+''');' + _LN +
				 _W_SetColr_+'$8F);' + _LN +
				 _W_BarSpcHorShade_+'0,14,31);' + _LN +
				 _W_PutPTxtXY_+'0,14,'+b+');');
		  If(MaxPath = 5)Then
		  Begin
		   Inc(IPath);
		   GetDataPath(IPath,a,b);
		   _AddSpcUStrX(4,_W_SetColrBorder_ + _LN +
				  _W_PutTxtXY_+'34,13,'''+a+''');' + _LN +
				  _W_SetColr_+'$8F);' + _LN +
				  _W_BarSpcHorShade_+'34,14,'+_W_GetMaxXTxts+'-1);' + _LN +
				  _W_PutPTxtXY_+'34,14,'+b+');');
		  End;
		 End;
	 6,7,8 : Begin
		  GetDataPath(IPath,a,b);
		  _AddSpcUStrX(4,'W.ClrWnBorder(0,7,'+_W_GetMaxXTxts+','+_W_GetMaxYTxts+'-2);' + _LN +
				 _W_SetColrBorder_ + _LN +
				 _W_PutTxtXY_+'0,7,'''+a+''');' + _LN +
				 _W_SetColr_+'$8F);' + _LN +
				 _W_BarSpcHorShade_+'0,8,20);' + _LN +
				 _W_PutPTxtXY_+'0,8,'+b+');');
		  Inc(IPath);
		  GetDataPath(IPath,a,b);
		  _AddSpcUStrX(4,_W_SetColrBorder_ + _LN +
				 _W_PutTxtXY_+'23,7,'''+a+''');' + _LN +
				 _W_SetColr_+'$8F);' + _LN +
				 _W_BarSpcHorShade_+'23,8,43);' + _LN +
				 _W_PutPTxtXY_+'23,8,'+b+');');
		  Inc(IPath);
		  GetDataPath(IPath,a,b);
		  _AddSpcUStrX(4,_W_SetColrBorder_ + _LN +
				 _W_PutTxtXY_+'46,7,'''+a+''');' + _LN +
				 _W_SetColr_+'$8F);' + _LN +
				 _W_BarSpcHorShade_+'46,8,W.MaxXTxts-1);' + _LN +
				 _W_PutPTxtXY_+'46,8,'+b+');');
		  Inc(IPath);
		  GetDataPath(IPath,a,b);
		  _AddSpcUStrX(4,_W_SetColrBorder_);
		  _AddSpcUStrX(4,_W_PutTxtXY_+'0,10,'''+a+''');');
		  _AddSpcUStrX(4,_W_SetColr_+'$8F);');
		  _AddSpcUStrX(4,_W_BarSpcHorShade_+'0,11,20);');
		  _AddSpcUStrX(4,_W_PutPTxtXY_+'0,11,'+b+');');
		  Inc(IPath);
		  GetDataPath(IPath,a,b);
		  _AddSpcUStrX(4,_W_SetColrBorder_);
		  _AddSpcUStrX(4,_W_PutTxtXY_+'23,10,'''+a+''');');
		  _AddSpcUStrX(4,_W_SetColr_+'$8F);');
		  _AddSpcUStrX(4,_W_BarSpcHorShade_+'23,11,43);');
		  _AddSpcUStrX(4,_W_PutPTxtXY_+'23,11,'+b+');');
		  Inc(IPath);
		  GetDataPath(IPath,a,b);
		  _AddSpcUStrX(4,_W_SetColrBorder_);
		  _AddSpcUStrX(4,_W_PutTxtXY_+'46,10,'''+a+''');');
		  _AddSpcUStrX(4,_W_SetColr_+'$8F);');
		  _AddSpcUStrX(4,_W_BarSpcHorShade_+'46,11,'+_W_GetMaxXTxts+'-1);');
		  _AddSpcUStrX(4,_W_PutPTxtXY_+'46,11,'+b+');');
		  Inc(IPath);
		  GetDataPath(IPath,a,b);
		  _AddSpcUStrX(4,_W_SetColrBorder_);
		  _AddSpcUStrX(4,_W_PutTxtXY_+'0,13,'''+a+''');');
		  _AddSpcUStrX(4,_W_SetColr_+'$8F);');
		  _AddSpcUStrX(4,_W_BarSpcHorShade_+'0,14,20);');
		  _AddSpcUStrX(4,_W_PutPTxtXY_+'0,14,'+b+');');
		  If(MaxPath > 6)Then
		  Begin
		   Inc(IPath);
		   GetDataPath(IPath,a,b);
		   _AddSpcUStrX(4,_W_SetColrBorder_);
		   _AddSpcUStrX(4,_W_PutTxtXY_+'23,13,'''+a+''');');
		   _AddSpcUStrX(4,_W_SetColr_+'$8F);');
		   _AddSpcUStrX(4,_W_BarSpcHorShade_+'23,14,43);');
		   _AddSpcUStrX(4,_W_PutPTxtXY_+'23,14,'+b+');');
		   If(MaxPath > 7)Then
		   Begin
		    Inc(IPath);
		    GetDataPath(IPath,a,b);
		    _AddSpcUStrX(4,_W_SetColrBorder_);
		    _AddSpcUStrX(4,_W_PutTxtXY_+'46,13,'''+a+''');');
		    _AddSpcUStrX(4,_W_SetColr_+'$8F);');
		    _AddSpcUStrX(4,_W_BarSpcHorShade_+'46,14,'+_W_GetMaxXTxts+'-1);');
		    _AddSpcUStrX(4,_W_PutPTxtXY_+'46,14,'+b+');');
		   End;
		  End;
		 End;
	    Else Begin
		  Return(TooManyPathInHeader);
		  Exit;
		 End;
	  End;
	  _AddSpcUStrPas(#3'Ø');
	 End;
	 If(IPath > MaxBuf)Then Break;
	End;
	_AddSpcUStrPas(#2'Ø');
	_AddSpcUStrPas(#1'Ø');
	_AddLn;
	_AddStrPas('Æ');
	_AddSpcUStr(1,'W.InitO(70,20);');
	_AddSpcUStr(1,'W.PushWn;');
	_AddSpcUStr(1,'W.PutWn(''RÇpertoire'',CurrColors.Dialog.Wins);');
	_AddSpcUStr(1,'SetShade(False);');
	_AddSpcUStr(1,'W.SubList(0,1,W.MaxXTxts-1,5,''CatÇgorie'',L);');
	_AddSpcUStr(1,'L.PutSmallShade;');
	IHeader := 0;
	For IPath := 0 to MaxBuf do
	Begin
	 S := StrPas(BankSetupPath._GetBuf(IPath));
	 If(StrI(1,S) = #1)Then
	 Begin
	  Inc(IHeader);
	  _AddSpcUStrPas(#1'L.AddõByte('''+Copy(S,2,255)+''','+Str(IHeader)+');');
	 End;
	End;
	_AddSpcUStr(1,'L.Refresh;');
	_AddSpcUStr(1,'L.SelBarInactive;');
	_AddSpcUStr(1,'W.PutkHorDn(''Correcte|Annule'');');
	_AddSpcUStr(1,'P        := 0;');
	_AddSpcUStr(1,'PP       := 0;');
	_AddSpcUStr(1,'PPathBuf := PathBuf;');
	_AddSpcUStr(1,'UpDateDir;');
	For IPath := 0 to BankSetupPath.MaxBuf do
	Begin
	 S := StrPas(BankSetupPath._GetBuf(IPath));
	 If(StrI(1,S) = #2)Then
	 Begin
	  GetDataPath(IPath,a,b);
	  _AddSpcUStrPas(#1'T'+StrUSpc(b,16)+':= õNew('+b+');');
	 End;
	End;
	_AddSpcUStr(1,'W.SetInpColrs($8F,W.XColrs.Sel);');
	_AddSpcUStr(1,'Repeat');
	_AddSpcUStr(2,'Case P of');
	_AddSpcUStrPas(#3'0 : Æ');
	_AddSpcUStr(8,'PP := 0;');
	_AddSpcUStr(8,'L.SelBar;');
	_AddSpcUStr(8,'K := ReadKey;');
	_AddSpcUStr(8,'L.SelBarInactive;');
	_AddSpcUStr(8,'Case K of');
	_AddSpcUStrPas(#11'kbUp : Æ');
	_AddSpcUStr(18,'L.kUp;');
	_AddSpcUStr(18,'UpDateDir;');
	_AddSpcUStrPas(#17'Ø');
	_AddSpcUStrPas(#9'kbDn : Æ');
	_AddSpcUStr(18,'L.kDn;');
	_AddSpcUStr(18,'UpDateDir;');
	_AddSpcUStrPas(#17'Ø');
	_AddSpcUStrX(10,_kbTab+' : P := 1;');
	_AddSpcUStrX(10,_kbEsc+' : '+_Break_);
	_AddSpcUStrPas(#8'Ø');
	_AddSpcUStrPas(#7'Ø');
	_AddSpcUStrPas(#3'1 : Case L.GetVal of');
	IHeader := 0;
	For IPath := 0 to BankSetupPath.MaxBuf do
	Begin
	 S := StrPas(BankSetupPath._GetBuf(IPath));
	 If(StrI(1,S) = #1)Then
	 Begin
	  Inc(IHeader);
	  _AddSpcUStr(9,Str(IHeader) + ' :');
	  _AddSpcUStrPas(#9'Æ');
	  MaxPath := GetMaxPathInSetup(IHeader-1,FirstElement);
	  Inc(IPath);
	  Case MaxPath of
	   0 : Begin
		GetDataPath(IPath,a,b);
		SetupPathInput(10,8,b);
		_AddSpcUStr(10,'Case K of');
		_AddSpcUStrX(18,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(19,_kbUp+' : P := 0;');
		_AddSpcUStrX(11,_kbDown+','+_kbTab+' : P := 2;');
		_AddSpcUStrX(16,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#10'Ø');
	       End;
	   1 : Begin
		GetDataPath(IPath,a,b);
		_AddSpcUStr(10,'Case PP of');
		_AddSpcUStrPas(#11'0 : Æ');
		SetupPathInput(16,8,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(24,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(25,_kbUp+' : P := 0;');
		_AddSpcUStrX(17,_kbDown+','+_kbTab+' : PP := 1;');
		_AddSpcUStrX(22,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'1 : Æ');
		SetupPathInput(16,11,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(24,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(25,_kbUp+' : PP := 0;');
		_AddSpcUStrX(17,_kbDown+','+_kbTab+' : P := 2;');
		_AddSpcUStrX(22,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		_AddSpcUStrPas(#11'Ø');
	       End;
	   2 : Begin
		GetDataPath(IPath,a,b);
		_AddSpcUStr(10,'Case PP of');
		_AddSpcUStrPas(#11'0 : Æ');
		SetupPathInput(16,8,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(24,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(25,_kbUp+' : P := 0;');
		_AddSpcUStrX(17,_kbDown+','+_kbTab+' : PP := 1;');
		_AddSpcUStrX(22,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'1 : Æ');
		SetupPathInput(16,11,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(24,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(25,_kbUp+' : PP := 0;');
		_AddSpcUStrX(17,_kbDown+','+_kbTab+' : PP := 2;');
		_AddSpcUStrX(22,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'2 : Æ');
		SetupPathInput(16,14,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(24,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(25,_kbUp+' : PP := 1;');
		_AddSpcUStrX(17,_kbDown+','+_kbTab+' : P := 2;');
		_AddSpcUStrX(22,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		_AddSpcUStrPas(#11'Ø');
	       End;
	   3 : Begin
		GetDataPath(IPath,a,b);
		_AddSpcUStr(10,'Case PP of');
		_AddSpcUStrPas(#11'0 : Æ');
		_AddSpcUStr(16,'If(T'+b+' = NIL)Then StrCopy(PathBuf,'''')');
		_AddSpcUStr(16+Length(b)+Length('If(T = NIL)'),
			    'Else StrCopy(PathBuf,T'+b+');');
		_AddSpcUStr(16,'K := W._Input(0,8,31,80,PPathBuf);');
		_AddSpcUStr(16,'StrDispose(T'+b+');');
		_AddSpcUStrX(16,'T'+b+' := '+_StrNew_+'PPathBuf);');
		_AddSpcUStrX(16,_W_SetColr_+'$8F);');
		_AddSpcUStr(16,'W.BarSelHor(0,8,31);');
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : P := 0;');
		_AddSpcUStrX(18,_kbDown+' : PP := 2;');
		_AddSpcUStrX(19,_kbTab+' : PP := 1;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'1 : Æ');
		_AddSpcUStrPas(#16'?(T'+b+' = NIL)® StrCopy(PathBuf,'''')');
		_AddSpcUStr(16+Length(b)+Length('If(T = NIL)'),
			    'Else StrCopy(PathBuf,T'+b+');');
		_AddSpcUStrX(16,'K := W._Input(34,8,'+_W_GetMaxXTxts+'-1,80,PPathBuf);');
		_AddSpcUStrX(16,_StrDispose_+'T'+b+');');
		_AddSpcUStrX(16,'T'+b+' := '+_StrNew_+'PPathBuf);');
		_AddSpcUStrX(16,_W_SetColr_+'$8F);');
		_AddSpcUStrX(16,'W.BarSelHor(34,8,'+_W_GetMaxXTxts+'-1);');
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : P := 0;');
		_AddSpcUStrX(18,_kbDown+' : PP := 3;');
		_AddSpcUStrX(19,_kbTab+' : PP := 2;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'2 : Æ');
		_AddSpcUStrPas(#16'?(T'+b+' = NIL)® StrCopy(PathBuf,'''')');
		_AddSpcUStr(16+Length(b)+Length('If(T = NIL)'),
			    'Else StrCopy(PathBuf,T'+b+');');
		_AddSpcUStr(16,'K := W._Input(0,11,31,80,PPathBuf);');
		_AddSpcUStrX(16,_StrDispose_+'T'+b+');');
		_AddSpcUStr(16,'T'+b+' := StrNew(PPathBuf);');
		_AddSpcUStrX(16,_W_SetColr_+'$8F);');
		_AddSpcUStr(16,'W.BarSelHor(0,11,31);');
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : PP := 0;');
		_AddSpcUStrX(18,_kbDown+' : P := 2;');
		_AddSpcUStrX(19,_kbTab+' : PP := 3;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'3 : Æ');
		_AddSpcUStrPas(#16'?(T'+b+' = NIL)® StrCopy(PathBuf,'''')');
		_AddSpcUStr(16+Length(b)+Length('If(T = NIL)'),
			    'Else StrCopy(PathBuf,T'+b+');');
		_AddSpcUStrX(16,'K := W._Input(34,11,'+_W_GetMaxXTxts+'-1,80,PPathBuf);');
		_AddSpcUStrX(16,_StrDispose_+'T'+b+');');
		_AddSpcUStrX(16,'T'+b+' := '+_StrNew_+'PPathBuf);');
		_AddSpcUStrX(16,_W_SetColr_+'$8F);');
		_AddSpcUStrX(16,'W.BarSelHor(34,11,'+_W_GetMaxXTxts+'-1);');
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : PP := 1;');
		_AddSpcUStrX(18,_kbDown+' : P := 2;');
		_AddSpcUStrX(19,_kbTab+' : P := 2;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		_AddSpcUStrPas(#11'Ø');
	       End;
	   8 : Begin
		_AddSpcUStr(10,'Case PP of');
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'0 : Æ');
		SetupPathInput3A(16,8,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : P := 0;');
		_AddSpcUStrX(18,_kbDown+' : PP := 3;');
		_AddSpcUStrX(19,_kbTab+' : PP := 1;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'1 : Æ');
		SetupPathInput3B(16,8,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : P := 0;');
		_AddSpcUStrX(16,_kbDown+' : PP := 4;');
		_AddSpcUStrX(17,_kbTab+' : PP := 2;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'2 : Æ');
		SetupPathInput3C(16,8,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : P := 0;');
		_AddSpcUStrX(16,_kbDown+' : PP := 5;');
		_AddSpcUStrX(17,_kbTab+' : PP := 3;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'3 : Æ');
		SetupPathInput3A(16,11,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : PP := 0;');
		_AddSpcUStrX(16,_kbDown+' : PP := 6;');
		_AddSpcUStrX(17,_kbTab+' : PP := 4;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'4 : Æ');
		SetupPathInput3B(16,11,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : PP := 1;');
		_AddSpcUStrX(16,_kbDown+' : PP := 7;');
		_AddSpcUStrX(17,_kbTab+' : PP := 5;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'5 : Æ');
		SetupPathInput3C(16,11,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : PP := 2;');
		_AddSpcUStrX(16,_kbDown+' : PP := 8;');
		_AddSpcUStrX(17,_kbTab+' : PP := 6;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'6 : Æ');
		SetupPathInput3A(16,14,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : PP := 3;');
		_AddSpcUStrX(16,_kbDown+' : P := 2;');
		_AddSpcUStrX(17,_kbTab+' : PP := 7;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'7 : Æ');
		SetupPathInput3B(16,14,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : PP := 4;');
		_AddSpcUStrX(16,_kbDown+' : P := 2;');
		_AddSpcUStrX(17,_kbTab+' : PP := 8;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		Inc(IPath);
		GetDataPath(IPath,a,b);
		_AddSpcUStrPas(#11'8 : Æ');
		SetupPathInput3C(16,14,b);
		_AddSpcUStr(16,'Case K of');
		_AddSpcUStrX(19,_kbEsc+' : '+_Break_);
		_AddSpcUStrX(20,_kbUp+' : PP := 5;');
		_AddSpcUStrX(16,_kbDown+' : P := 2;');
		_AddSpcUStrX(17,_kbTab+' : P := 2;');
		_AddSpcUStrX(17,_kbEnter+' : P := 2;');
		_AddSpcUStrPas(#16'Ø');
		_AddSpcUStrPas(#15'Ø');
		_AddSpcUStrPas(#11'Ø');
	       End;
	  Else Begin
		Return(TooManyPathInHeader);
		Exit;
	       End;
	  End;
	  _AddSpcUStrPas(#9'Ø');
	 End;
	 If(IPath > MaxBuf)Then Break;
	End;
	_AddSpcUStrPas(#8'Ø');
	_AddSpcUStrPas(#3'2 : Æ');
	_AddSpcUStr(8,'PP := 0;');
	_AddSpcUStr(8,'K := W.GetkHorDn(''Correcte|Annule'');');
	_AddSpcUStr(8,'Case K of');
	_AddSpcUStrX(11,_kbEsc+' : '+_Break_);
	_AddSpcUStrPas(#9'kbEnter : Æ');
	For IPath := 0 to MaxBuf do
	Begin
	 S := StrPas(BankSetupPath._GetBuf(IPath));
	 If(StrI(1,S) = #2)Then
	 Begin
	  GetDataPath(IPath,a,b);
	  _AddSpcUStrX(20,_StrDispose_+b+');');
	 End;
	End;
	For IPath := 0 to MaxBuf do
	Begin
	 S := StrPas(BankSetupPath._GetBuf(IPath));
	 If(StrI(1,S) = #2)Then
	 Begin
	  GetDataPath(IPath,a,b);
	  _AddSpcUStrX(20,StrUSpc(b,20)+' := '+_StrNew_+'T'+b+');');
	 End;
	End;
	_AddSpcUStrX(20,_Break_);
	_AddSpcUStrPas(#19'Ø');
	_AddSpcUStrX(11,_kbTab+' : P := 0;');
	_AddSpcUStrPas(#9'Ø');
	_AddSpcUStrPas(#8'Ø');
	_AddSpcUStrPas(#2'Ø');
	_AddSpcUStr(1,'Until False;');
	For IPath := 0 to MaxBuf do
	Begin
	 S := StrPas(BankSetupPath._GetBuf(IPath));
	 If(StrI(1,S) = #2)Then
	 Begin
	  GetDataPath(IPath,a,b);
	  _AddSpcUStrX(1,_StrDispose_+'T'+b+');');
	 End;
	End;
	_AddSpcUStr(1,'SetShade(True);');
	_AddSpcUStr(1,'W.Done;');
	_AddStrPas('Ø');
       End
	Else
       If(Func = 'HEADER')Then
       Begin
	SkipSpc;
	If Not(PChr[ErrI] = '"')Then
	Begin
	 Return(GuillExpected);
	 Exit;
	End;
	Inc(ErrI);
	S := ExtractNot('"');
	BankSetupPath.AddStr(#1+S);
	If Not(PChr[ErrI] = '"')Then
	Begin
	 Return(GuillExpected);
	 Exit;
	End;
	Inc(ErrI);
       End
	Else
       If(Func = 'PATH')Then
       Begin
	SkipSpc;
	If Not(PChr[ErrI] = '"')Then
	Begin
	 Return(GuillExpected);
	 Exit;
	End;
	Inc(ErrI);
	S := ExtractNot('"');
	If Not(PChr[ErrI] = '"')Then
	Begin
	 Return(GuillExpected);
	 Exit;
	End;
	Inc(ErrI);
	SkipSpc;
	If Not(PChr[ErrI] = ',')Then
	Begin
	 Return(CommaExpected);
	 Exit;
	End;
	Inc(ErrI,Length(','));
	SkipSpc;
	_Type := PExtractWord(ErrI,PChr);
	BankSetupPath.AddStr(#2+S+'"'+_Type);
       End
	Else
       Begin
	Return(SyntaxError);
	Exit;
       End;
      End
       Else
      Begin
       Func := PExtractWord(ErrI,PChr);
       If(StrUp(Func) = 'BEGIN')Then Inc(_Begin)
	Else
       Begin
	Return(BeginExpected);
	Exit;
       End;
      End;
     End;
     LoadIni:
     Begin
      If(_Begin = 1)Then
      Begin
       Func := StrUp(PExtractWord(ErrI,PChr));
       If(Func = 'BEGIN')Then
       Begin
	Return(MisplacedBeginSymbol);
	Exit;
       End
	else
       If(Func = 'END')Then
       Begin
	_InsStr(InsProc,'Procedure '+Name+';');
	_AddStrPas('û '+Name+';');
	_AddStr('Const MsgChoice = ''Presse une touche pour continuer '+
		'sans le fichier '+Files+' ou <ESC> pour quitter.'';');
	_AddStrPas('Var Handle:˝; õ,Ext,Header:$; Pá:è;');
	_AddSpcUStr(4,'FS,S:Long; Category:Byte;');
	_AddLn;
	_AddSpcUStrPas(#1'ü ê†(õ:$):$;');
	_AddSpcUStr(1,'Var P:Byte;');
	_AddSpcUStrPas(#1'Æ');
	_AddSpcUStrPas(#2'P := Pos(''='',õ);');
	_AddSpcUStrPas(#2'?(P = 0)® ê† := ''''');
	_AddSpcUStrPas(#12'˜ ê† := Copy(õ,P+1,255);');
	_AddSpcUStrPas(#1'Ø');
	_AddLn;
	_AddStrPas(' ü Isù(õ:$):Bool;');
	_AddSpcUStrPas(#1'Æ');
	_AddSpcUStrPas(#2'Isù := (õ = ''YES'')|(õ = ''TRUE'')|(õ = ''ON'');');
	_AddSpcUStrPas(#1'Ø');
	_AddLn;
	_AddStrPas(' ü IsÙ(õ:$):Bool;');
	_AddSpcUStrPas(#1'Æ');
	_AddSpcUStrPas(#2'IsÙ := (õ = ''NO'')|(õ = ''FALSE'')|(õ = ''OFF'');');
	_AddSpcUStrPas(#1'Ø');
	_AddLn;
	_AddStrPas('Æ');
	_AddStr(' Category := 0;');
	_AddStr(' FS       := 0;');
	_AddStrPas(' Handle := ¢('''+Files+''',ReadOnly);');
	_AddStrPas(' ?(IsHandleErr(Handle))® Exit;');
	_AddStr(' S := FileSize(Handle);');
	_AddStr(' SetFilePos(Handle,0);');
	_AddStrPas(' õ := GetFileTextLn(Handle);');
	_AddStr(' While (FS < S) do');
	_AddSpcUStrPas(#1'Æ');
	_AddSpcUStrPas(#2'Inc(FS,Length(õ)+2);');
	_AddSpcUStrPas(#2'õ := Delá(õö(õ),'' '');');
	_AddSpcUStrPas(#2'? !((õ = '''')|(õ[1] = ''/''))®');
	_AddSpcUStrPas(#2'Æ');
	_AddSpcUStrPas(#3'?(õ[1] = ''['')®');
	_AddSpcUStrPas(#3'Æ');
	_AddSpcUStrPas(#4'? !(õ[Length(õ)] = '']'')®');
	_AddSpcUStrPas(#4'Æ');
	_AddSpcUStr(5,'WriteLn(''Erreur '+Files+': '''']'''' attendue.'');');
	_AddStr('     WriteLn(MsgChoice);');
	_AddSpcUStrPas(#5'?(ReadKey = kbEsc)® Halt;');
	_AddStr('     Exit;');
	_AddSpcUStrPas(#4'Ø');
	_AddSpcUStrPas(#4'Header := Copy(õ,2,Length(õ)-2);');
	BankName.SetPtr(0);
	J := 1;
	For I := 0 to BankName.MaxBuf do
	Begin
	 S := StrPas(BankName._GetCurrBuf);
	 If(S[1] = #1)Then
	 Begin
	  If(J = NumHeader)Then
	  Begin
	   _AddSpcUStrPas(#4'?(Header = '''+Copy(S,2,Length(S)-1)+
			       ''')® Category := '+Str(J));
	   _AddSpcUStrPas(#5'˜');
	   _AddSpcUStrX(4,_Break_);
	   _AddSpcUStr(3,'End');
	   _AddSpcUStrPas(#4'˜');
	   _AddSpcUStr(3,'Case Category of');
	  End
	   Else
	  _AddSpcUStrPas(#4'?(Header = '''+Copy(S,2,Length(S)-1)+
			 ''')® Category := '+Str(J)+' ˜');
	  Inc(J);
	 End;
	 BankName.Next;
	End;
	BankName.SetPtr(0);
	J := 1;
	For I := 0 to BankName.MaxBuf do
	Begin
	 S := StrPas(BankName._GetCurrBuf);
	 If(S[1] = #1)Then
	 Begin
	  If(J > 1)Then _AddSpcUStrPas(#8'Ø');
	  _AddSpcUStrPas(#4+Str(J)+' : Æ');
	  Inc(J);
	 End;
	 If(S[1] = #2)Then
	 Begin
	  K := 2;
	  Name := ExtractWord(K,S);
	  Inc(K);
	  _Type := StrUp(ExtractWord(K,S));
	  Inc(K);
	  NameType := ExtractWord(K,S);
	  _AddSpcUStrPas(#9'?(CmpLeft(õ,'''+Name+'''))®');
	  _AddSpcUStrPas(#9'Æ');
	  _AddSpcUStrPas(#10'Ext := ê†(õ);');
	  If(_Type = 'BYTE')or(_Type = 'WORD')Then
	  Begin
	   _AddSpcUStrPas(#10+NameType+':=ValW(Ext);');
	  End
	   Else
	  If(_Type = 'BOOLEAN')Then
	  Begin
	   _AddSpcUStrPas(#10'? Isù(Ext)® '+NameType+' := ù ˜');
	   _AddSpcUStrPas(#10'? IsÙ(Ext)® '+NameType+' := Ù');
	   _AddSpcUStrPas(#25'˜ Break;');
	  End
	   Else
	  If(_Type = 'PCHAR')Then
	  Begin
	   _AddSpcUStrPas(#10'?(Ext[1] = ''"'')Ô(Ext[Length(Ext)] = ''"'')®');
	   _AddSpcUStrPas(#10'Æ');
	   _AddSpcUStrPas(#11'õPCopy(Pá,Copy(Ext,2,Length(Ext)-2));');
	   _AddSpcUStrPas(#11+NameType+' := õNew(Pá);');
	   _AddSpcUStrPas(#10'Ø');
	  End
	   Else
	  Begin
	   Return(UnknownType);
	   Exit;
	  End;
	  _AddSpcUStrPas(#9'Ø');
	 End;
	 BankName.Next;
	End;
	If(J > 1)Then _AddSpcUStrPas(#8'Ø')
		 Else Break;
	_AddSpcUStrPas(#3'Ø');
	_AddSpcUStrPas(#2'Ø');
	_AddSpcUStr(2,'SetFilePos(Handle,FS);');
	_AddSpcUStrPas(#2'õ := GetFileTextLn(Handle);');
	_AddSpcUStrPas(#1'Ø');
	_AddSpcUStr(1,'Close(Handle);');
	_AddStrPas('Ø');
       End
	Else
       If(Func = 'HEADER')Then
       Begin
	SkipSpc;
	If Not(PChr[ErrI] = '"')Then
	Begin
	 Return(GuillExpected);
	 Exit;
	End;
	Inc(ErrI);
	S := ExtractNot('"');
	BankName.AddStr(#1+S);
	If Not(PChr[ErrI] = '"')Then
	Begin
	 Return(GuillExpected);
	 Exit;
	End;
	Inc(ErrI);
	Inc(NumHeader);
       End
	Else
       If(Func = 'VARIABLE')Then
       Begin
	SkipSpc;
	If Not(PChr[ErrI] = '"')Then
	Begin
	 Return(GuillExpected);
	 Exit;
	End;
	Inc(ErrI);
	S := ExtractNot('"');
	If Not(PChr[ErrI] = '"')Then
	Begin
	 Return(GuillExpected);
	 Exit;
	End;
	Inc(ErrI);
	SkipSpc;
	If Not(PChr[ErrI] = ',')Then
	Begin
	 Return(CommaExpected);
	 Exit;
	End;
	Inc(ErrI,Length(','));
	SkipSpc;
	_Type := PExtractWord(ErrI,PChr);
	If Not(PChr[ErrI] = ',')Then
	Begin
	 Return(CommaExpected);
	 Exit;
	End;
	Inc(ErrI,Length(','));
	SkipSpc;
	NameType := PExtractWord(ErrI,PChr);
	BankName.AddStr(#2+S+' '+_Type+' '+NameType);
       End
	Else
       Begin
	Return(SyntaxError);
	Exit;
       End;
      End
       Else
      Begin
       Func := PExtractWord(ErrI,PChr);
       If(StrUp(Func) = 'BEGIN')Then Inc(_Begin)
	Else
       Begin
	Return(BeginExpected);
	Exit;
       End;
      End;
     End;
     Else
     Begin
      Return(SyntaxError);
      Exit;
     End;
    End;
    ' ' : Inc(ErrI);
    '/' : Case PChr[ErrI+1] of
	   '/' : Break;
	    Else Begin
		  Return(SyntaxError);
		  Exit;
		 End;
	  End;
    Else
    Begin
     Return(SyntaxError);
     Exit;
    End;
   End;
  End;
  WinPtr^.P.Edit.Lst.Next;
  PutMemory;
 End;
 _AddLn;
 _AddStr('BEGIN');
 _AddStr('END.');
 W.LineCode(BankTarget^.P.Edit.Lst.NmBuf);
 BankName.Done;
 BankSetupPath.Done;
 PutLastBarMsgOkCompile;
 ReadKey;
 W.Done;
 Ptr := BankTarget;
 SetWn(X1,Y1,X2,Y2);
 CompileRC := True;
End;

BEGIN
END.