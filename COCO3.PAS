(********************************************************)
(*                                                      *)
(*            Malte Genesis/Coco 3 Emulateur            *)
(*   Phoenix Edition for Real Mode & Protected Mode     *)
(*                   II - Version 1.8                   *)
(*                      1994/12/29                      *)
(*                                                      *)
(*      Copyiright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit Coco3;

INTERFACE

Uses Math,Windows,Dials,Images,Video,Terminal,Memorys,Mems;

Const

      errNF = 0;
      errSN = 1;
      errRG = 2;
      errOD = 3;
      errFC = 4;
      errOV = 5;
      errOM = 6;
      errUL = 7;
      errBS = 8;
      errDD = 9;
      err_0 = 10;
      errID = 11;
      errTM = 12;
      errOS = 13;
      errLS = 14;
      errST = 15;
      errCN = 16;
      errFD = 17;
      errAO = 18;
      errDN = 19;
      errIO = 20;
      errFM = 21;
      errNO = 22;
      errIE = 23;
      errDS = 24;
      errHR = 38;
      errHP = 39;

Type

     Coco3Emul = Object
      Constructor Init(X,Y:Byte);
      Function Run:Word;
      Procedure Refresh;
      Function ExecCmd(S:String):Word;
      Destructor Done;
      PRIVATE
      W,Scr:Wins;
      Err,TxtMode,PMode,HighMode:Byte;
      Underline,Blink,Brk,RunErr,OnBrk,Caps:Bool;
      LnErr,LnBrk,OnBrkLn,_Goto:Word;
      List,Variable,HBuff:RBuf;
      Graf:WnImg;
      Procedure Ln;
      Procedure PutTxt(S:String);
      Procedure PutTxtLn(S:String);
      Procedure SetPlace(Num:Word;S:String);
      Function SearchLn(L:Word):Word;
      Function SearchVar(Name:String):Word;
      Procedure InitCmd;
      Procedure ClrScr;
      Procedure PutErr;
      Procedure CLS(N:Byte);
      Procedure _HBuff(N:Byte;Len:Word);
      Procedure HColor(C:Byte);
      Procedure HGet(X1,Y1,X2,Y2:Int;N:Byte);
      Procedure HPut(X1,Y1,X2,Y2:Int;N:Byte);
      Procedure HLine(X1,Y1,X2,Y2:Word);
      Procedure HScreen(Mode:Byte);
      Procedure Width(X:Byte);
     End;

IMPLEMENTATION

Uses Strs,Strings,Language,Keyboard,MLibrary,Systems,Emulator,Cursor;

Type

     HBuffRec = Record
      N:Byte; Buf:TByte;
     End;

Constructor Coco3Emul.Init;
Var Coco3_32x16 : MtxColors;
Begin
 Caps := True; HighMode := 0; Brk := False;
 List.Init;
 Variable.Init;
 HBuff.Init;
 W.Init(X,Y,X+33,Y+17);
 Graf.SetWnTxt(W.RX1,W.RY1,W.RX1+W.MaxXTxts,W.RY1+W.MaxYTxts);
 W.PushWn;
 Coco3_32x16 := CurrColors.Dialog.Wins; Coco3_32x16.Border := $F;
 W.PutWn('Emulateur Coco 3',Coco3_32x16);
 W.SetKr($A0);
 W.ClrScr;
 W.PutTxtLn('EXTENDED COLOR BASIC 2.0');
 W.PutTxtLn('COPR. 1982, 1986 BY TANDY');
 W.PutTxtLn('UNDER LICENSE FROM MICROSOFT');
 W.PutTxtLn('AND MICROWARE SYSTEMS CORP.');
 W.Ln;
 W.PutTxtLn('OK');
 SetShade(False);
 Scr.Init(W.RX1,W.RY1,W.RX2,W.RY2);
 SetShade(True);
 TxtMode := 32;
 Scr.PushWn;
 Err := $FF;
End;

Procedure Coco3Emul.Width;
Var Coco3_32x16:MtxColors; OldColor,OX,OY:Byte;
Begin
 If Not(X in [32,40,80])Then
 Begin
  Err := errFC;
  Exit;
 End;
 OldColor := W.RColr; OX := W.RY1; OY := W.RY1;
 If(X >= 40)Then
 Begin
  If((MaxXTxts+1) < X)or((MaxYTxts+1) < 24)Then
  Begin
   ErrorMsgOk('Impossible d''‚muler la commande WIDTH avec ce mode vid‚o!');
   OnBrk := True;
   Exit;
  End;
 End;
 Scr.Done;
 Case X of
  32 : W.ReInit(OX,OY,OX+33,OY+17);
  40 : W.ReInit(OX,OY,OX+42,OY+25);
  Else W.ReInit(OX,OY,OX+81,OY+25);
 End;
 Graf.Done;
 Graf.SetWnTxt(W.RX1,W.RY1,W.RX1+W.MaxXTxts,W.RY1+W.MaxYTxts);
 W.PushWn;
 Coco3_32x16 := CurrColors.Dialog.Wins; Coco3_32x16.Border := $F;
 W.PutWn('Emulateur Coco 3',Coco3_32x16);
 If(X = 32)Then W.SetKr($A0)
	   Else W.SetKr(OldColor);
 W.ClrScr;
 Scr.Init(W.RX1,W.RY1,W.RX2,W.RY2);
 TxtMode := X; HighMode := 0;
 Scr.PushWn;
End;

Procedure Coco3Emul.HScreen;
Var X,OX,OY,OldColor:Byte; Coco3_32x16:MtxColors;
Begin
 Case Mode of
    0 : Exit;
  1,2 : X := 40;
  3,4 : X := 80;
   Else Begin
	 Err := ErrFC;
	 Exit;
	End;
 End;
 If Not(IVid.Graf)Then
 Begin
  ErrorMsgOk('Impossible d''‚muler la commande HSCREEN avec ce mode vid‚o!');
  OnBrk := True;
  Exit;
 End;
 OldColor := W.RColr; OX := W.RY1; OY := W.RY1;
 If(X >= 40)Then
 Begin
  If((MaxXTxts+1) < X)or((MaxYTxts+1) < 24)Then
  Begin
   ErrorMsgOk('Impossible d''‚muler la commande HSCREEN avec ce mode vid‚o!');
   OnBrk := True;
   Exit;
  End;
 End;
 Scr.Done;
 W.ReInit(OX,OY,OX+X+1,OY+13);
 Graf.Done;
 Graf.SetWnTxt(W.GetRX1,W.GetRY1,W.GetRX1+W.MaxXTxts,W.GetRY1+W.MaxYTxts);
 Graf.SetColor(OldColor);
 W.PushWn;
 Coco3_32x16 := CurrColors.Dialog.Wins; Coco3_32x16.Border := $F;
 W.PutWn('Emulateur Coco 3',Coco3_32x16);
 W.SetKr(OldColor);
 W.ClrScr;
 Scr.Init(W.RX1,W.RY1,W.RX2,W.RY2);
 HighMode := Mode;
 Scr.PushWn;
End;

Procedure Coco3Emul.HColor;
Begin
 Graf.SetColor(C);
End;

Procedure Coco3Emul.HLine;
Begin
 Graf.PutLine(X1,Y1,X2,Y2);
End;

Procedure Coco3Emul.HGet;
Var Ptr:^HBuffRec; I,S,Size:Word; Ok:Bool;
Begin
 Ok := False;
 If(HBuff.NmBuf > 0)Then For I := 0 to HBuff.MaxBuf do
 Begin
  Ptr := HBuff.GetBuf(I,Size);
  If(Ptr^.N = N)Then
  Begin
   Ok := True;
   Break;
  End;
 End;
 If(Ok)Then
 Begin
  S := GetSizeSmlImg(X1,Y1,X2,Y2) + 1;
  If(Size < S)Then
  Begin
   Err := ErrBS;
   Exit;
  End;
  GetSmlImg(Graf.SGX1+X1,Graf.SGY1+Y1,Graf.SGX1+X2,Graf.SGY1+Y2,Ptr^.Buf);
 End
  Else
 Begin
  Err := ErrFC;
  Exit;
 End;
End;

Procedure Coco3Emul.HPut;
Var Ptr:^HBuffRec; I,S,Size:Word; Ok:Bool;
Begin
 Ok := False;
 If(HBuff.NmBuf > 0)Then For I := 0 to HBuff.MaxBuf do
 Begin
  Ptr := HBuff.GetBuf(I,Size);
  If(Ptr^.N = N)Then
  Begin
   Ok := True;
   Break;
  End;
 End;
 If(Ok)Then
  PutSmlImg(Graf.SGX1+X1,Graf.SGY1+Y1,Graf.SGX1+X2,Graf.SGY1+Y2,Ptr^.Buf)
  Else
 Begin
  Err := ErrFC;
  Exit;
 End;
End;

Procedure Coco3Emul._HBuff;
Var Ptr:^HBuffRec; I:Word;
Begin
 If(HBuff.NmBuf > 0)Then For I := 0 to HBuff.MaxBuf do
 Begin
  Ptr := HBuff._GetBuf(I);
  If(Ptr^.N = N)Then
  Begin
   Err := ErrDD;
   Exit;
  End;
 End;
 Ptr := HBuff._AddBuf((Len*8)+2);
 If(Ptr = NIL)Then
 Begin
  Err := ErrOM;
  Exit;
 End;
 Ptr^.N := N;
End;

Procedure Coco3Emul.Refresh;
Begin
 Scr.PopWn;
 Scr.PushWn;
End;

Procedure Coco3Emul.Ln;
Begin
 W.ClrEol;
 If(W.RY >= W.MaxYTxts)Then
 Begin
  W._ScrollDn;
  W.ClrEol;
 End
  Else
 W.Ln;
End;

Procedure Coco3Emul.PutTxt;
Var I : Int;
Begin
 If(S = '')Then Exit;
 If(W.RX = W.MaxXTxts + 1)Then Ln;
 If(Length(S)+W.RX > W.MaxXTxts+1)Then
 Begin
  I := 1;
  While (I <= Length(S)) do
  Begin
   W.PutTxt(Copy(S,I,W.MaxXTxts+1));
   Inc(I,W.MaxXTxts+1);
   If(I <= Length(S))Then Ln;
  End;
 End
  Else
 W.PutTxt(S);
End;

Procedure Coco3Emul.PutTxtLn;
Begin
 PutTxt(S);
 Ln;
End;

Procedure Coco3Emul.ClrScr;
Begin
 W.ClrScr;
End;

Procedure Coco3Emul.CLS;
Begin
 Err := $FF;
 Case N of
   0 : W.BackGround(0);
   1 : W.BackGround(2);
   2 : W.BackGround(14);
   3 : W.BackGround(9);
   4 : W.BackGround($C);
   5 : W.BackGround($F);
   6 : W.BackGround(5);
   7 : W.BackGround($D);
   8 : W.BackGround(6);
  Else Err := errDN;
 End;
 W.ClrScr;
End;

Function Coco3Emul.SearchLn;
Var I:Word; Ptr:^PCharWordRec;
Begin
 SearchLn := $FFFF;
 For I := 0 to List.MaxBuf do
 Begin
  Ptr := List._GetBuf(I);
  If(Ptr^.Nm = L)Then
  Begin
   SearchLn := I;
   Exit;
  End;
 End;
End;

Function Coco3Emul.SearchVar;
Var I:Word;
Begin
 SearchVar := $FFFF;
 If(Variable.NmBuf > 0)Then For I := 0 to Variable.MaxBuf do
 Begin
  If(CmpLeft(StrPas(Variable._GetBuf(I)),Name))Then
  Begin
   SearchVar := I;
   Exit;
  End;
 End;
End;

Function Coco3Emul.ExecCmd;
Label _HomeExec;
Var I:Byte; K,R,a,b,L,LErr,E,H:Word; KChr:Char Absolute K;
    P,FS:Long; T,Num,Word,Name:String;Ptr:^PCharWordRec;
    Ok:Bool; GX1,GY1,GX2,GY2:Int;

 Function IsSN(Cmp:Char):Bool;
 Begin
  IsSN := True;
  If(StrI(I,S) = Cmp)Then Inc(I)
   Else
  Begin
   Err := ErrSN; IsSN := False;
  End;
 End;

 Function IfChrInc(Cmp:Char):Bool;
 Begin
  If(StrI(I,S) = Cmp)Then
  Begin
   Inc(I); IfChrInc := True;
  End
   Else
  IfChrInc := False;
 End;

 Function IsEmptyFC(S:String):Bool;
 Begin
  If(S = '')Then
  Begin
   Err := ErrFC; IsEmptyFC := True;
  End
   Else
  IsEmptyFC := False;
 End;

 Function ExtractWord:String;
 Var Word : String;
 Begin
  Word := '';
  While(StrI(I,S) in ['A'..'Z'])do
  Begin
   IncStr(Word,S[I]); Inc(I);
  End;
  ExtractWord := Word;
 End;

 Function ExtractNum:String;
 Var Num : String;
 Begin
  Num := '';
  If(StrI(I,S) = '-')Then
  Begin
   IncStr(Num,'-'); Inc(I,Length('-'));
  End;
  While(StrI(I,S) in ['0'..'9'])do
  Begin
   IncStr(Num,S[I]); Inc(I);
  End;
  If(StrI(I,S) = '.')Then
  Begin
   Inc(I,Length('.')); IncStr(Num,'.');
   While(StrI(I,S) in ['0'..'9'])do
   Begin
    IncStr(Num,S[I]); Inc(I);
   End;
  End;
  If(StrI(I,S) = 'E')Then
  Begin
   IncStr(Num,'E'); Inc(I,Length('E'));
   If(StrI(I,S) = '+')Then
   Begin
    IncStr(Num,'+'); Inc(I,Length('+'));
    While(StrI(I,S) in ['0'..'9'])do
    Begin
     IncStr(Num,S[I]); Inc(I);
    End;
   End;
  End;
  ExtractNum := Num;
 End;

 Procedure SkipSpc;
 Begin
  If(StrI(I,S) = ' ')Then While(StrI(I,S) =  ' ') do Inc(I);
 End;

 Function GetString(All:Bool):String; Forward;

 Function ExtractNumV:String;
 Var N:Long; T,U,Target:String; R:Real; Mode:(_Word_,_Real_);
     J,L:System.Word; Ok:Bool;

  Procedure PushReal(Long:Real);
  Begin
   If(Mode = _Word_)Then Mode := _Real_;
   If(R = 0.0)Then
   Begin
    N := 0; Mode := _Word_;
   End
    Else
   R := Long;
  End;

  Procedure PushLong(L:Long);
  Begin
   If(Mode = _Real_)Then PushReal(L) Else N := L;
  End;

 Begin
  N := 0; R := 0.0; Mode := _Word_; Target := '';
  SkipSpc;
  Repeat
   Case StrI(I,S) of
	    '(' : Begin
		   Inc(I,Length('(')); T := ExtractNumV;
		   If(Err <> $FF)Then Exit;
		   Val(T,N,LErr);
		   If(Mode = _Real_)or(Pos('.',T) > 0)or(N = 0)Then
		   Begin
		    Mode := _Real_;
		    Val(T,R,LErr);
		    PushReal(R);
		   End
		    Else
		   PushLong(N);
		   If Not(IsSN(')'))Then Exit;
		  End;
'-','0'..'9','.' : Begin
		   T := ExtractNum;
		   If(T = '-')Then T := '-' + ExtractNumV;
		   If(Err <> $FF)Then Exit;
		   Val(T,N,LErr);
		   If(Mode = _Real_)or(Pos('.',T) > 0)or(N = 0)Then
		   Begin
		    Val(T,R,LErr);
		    PushReal(R);
		   End
		    Else
		   PushLong(N);
		  End;
       'A'..'Z' : Begin
		   T := ExtractWord;
		   If(T = 'ABS')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    U := ExtractNumV;
		    If(Err <> $FF)Then Exit;
		    Val(U,N,LErr);
		    If(Pos('.',U) > 0)or(N = 0)Then
		    Begin
		     Val(U,R,LErr);
		     PushReal(Abs(R));
		    End
		     Else
		    PushLong(Abs(N));
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'ASC')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    SkipSpc;
		    U := GetString(False);
		    If(Err <> $FF)Then Exit;
		    PushLong(Byte(StrI(1,U)));
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'ATN')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    U := ExtractNumV;
		    If(Err <> $FF)Then Exit;
		    Val(U,R,LErr);
		    PushReal(System.ArcTan(R));
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'COS')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    U := ExtractNumV;
		    If(Err <> $FF)Then Exit;
		    Val(U,R,LErr);
		    PushReal(System.Cos(R));
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'INT')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    SkipSpc;
		    U := ExtractNumV;
		    If(Err <> $FF)Then Exit;
		    Mode := _Word_;
		    Val(U,N,LErr);
		    If(Pos('.',U) > 0)or(N = 0)Then
		    Begin
		     Val(U,R,LErr);
		     PushReal(Trunc(R));
		    End
		     Else
		    PushLong(N);
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'JOYSTK')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    U := ExtractNumV;
		    If(Err <> $FF)Then Exit;
		    Val(U,N,LErr);
		    If Not(N in [0..3])Then
		    Begin
		     Err := ErrDN;
		     Exit;
		    End;
		    PushLong(JoystickPos(N));
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'LEN')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    U := GetString(False);
		    If(Err <> $FF)Then Exit;
		    PushLong(Length(U));
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'LOG')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    U := ExtractNumV;
		    If(Err <> $FF)Then Exit;
		    Val(U,R,LErr);
		    PushReal(System.Ln(R));
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'RND')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    U := ExtractNumV;
		    If(Err <> $FF)Then Exit;
		    Val(U,N,LErr);
		    If(Pos('.',U) > 0)or(N = 0)Then
		    Begin
		     Val(U,R,LErr);
		     PushReal(Random(Trunc(R)));
		    End
		     Else
		    PushLong(Random(N));
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'SGN')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    U := ExtractNumV;
		    If(Err <> $FF)Then Exit;
		    Val(U,N,LErr);
		    If(Pos('.',U) > 0)or(N = 0)Then
		    Begin
		     Val(U,R,LErr);
		     If(R < 0.0)Then PushReal(-1) Else
		     If(R = 0.0)Then PushReal(0)
				Else PushReal(1);
		    End
		     Else
		    Begin
		     If(N < 0)Then PushLong(-1) Else
		     If(N = 0)Then PushLong(0)
			      Else PushLong(1);
		    End;
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'SIN')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    U := ExtractNumV;
		    If(Err <> $FF)Then Exit;
		    Val(U,R,LErr);
		    PushReal(System.Sin(R));
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'SQR')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    U := ExtractNumV;
		    If(Err <> $FF)Then Exit;
		    Val(U,N,LErr);
		    If(Pos('.',U) > 0)or(N = 0)Then
		    Begin
		     Val(U,R,LErr);
		     PushReal(Sqr(R));
		    End
		     Else
		    PushReal(Sqr(N));
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'TAN')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    U := ExtractNumV;
		    If(Err <> $FF)Then Exit;
		    Val(U,R,LErr);
		    PushReal(System.Sin(R)/System.Cos(R));
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   If(T = 'VAL')Then
		   Begin
		    SkipSpc;
		    If Not(IsSN('('))Then Exit;
		    U := GetString(False);
		    If(Err <> $FF)Then Exit;
		    Val(U,N,b);
		    If(Pos('.',U) > 0)or(N = 0)Then
		    Begin
		     Val(U,R,b);
		     PushReal(R);
		    End
		     Else
		    PushReal(N);
		    SkipSpc;
		    If Not(IsSN(')'))Then Exit;
		   End
		    Else
		   Begin
		    If(Variable.NmBuf > 0)Then For J := 0 to Variable.MaxBuf do
		    Begin
		     Num := StrPas(Variable._GetBuf(J));
		     If(CmpLeft(Num,T+'='))Then
		     Begin
		      U := Copy(Num,Length(T)+1+Length('='),255);
		      Val(U,N,LErr);
		      If(Pos('.',U) > 0)or(N = 0)Then
		      Begin
		       Val(U,R,LErr);
		       PushReal(R);
		      End
		       Else
		      PushLong(N);
		      Break;
		     End;
		    End;
		   End;
		  End;
   End;
   SkipSpc;
   Ok := (StrI(I,S) in ['^','*','/','\','+','-']);
   Case Mode of
    _Real_ : If(R < 0.0)Then AddStr(Target,'_'+RealStr(Abs(R)))
			Else AddStr(Target,RealStr(R));
	Else If(N < 0)Then AddStr(Target,'_'+Str(Abs(N)))
		      Else AddStr(Target,Str(N));
   End;
   If(Ok)Then
   Begin
    IncStr(Target,StrI(I,S)); Inc(I);
   End
    Else
   Begin
    Ok := ((StrI(I,S) = 'O')and(StrI(I+1,S) = 'R'))or
	  ((StrI(I,S) = 'A')and(StrI(I+1,S) = 'N')and(StrI(I+2,S) = 'D'))or
	  ((StrI(I,S) = 'M')and(StrI(I+1,S) = 'O')and(StrI(I+2,S) = 'D'));
    If(Ok)Then
    Begin
     U := ExtractWord;
     If(U = 'OR')Then IncStr(Target,'|');
     If(U = 'AND')Then IncStr(Target,'ï');
     If(U = 'MOD')Then IncStr(Target,'%');
     SkipSpc;
    End;
   End;
  Until Not(Ok);
  Case Mode of
   _Real_ : Begin
	     R := FormulaReal(Target);
	     System.Str(R,T);
	     Val(Copy(T,Length(T)-4,4),L,LErr);
	     Inc(L,Length(T)-Pos('.',T));
	     If(Frac(R) = 0.0)Then ExtractNumV := RealStr2(R,0,0)
			      Else ExtractNumV := RealStr2(R,0,L-2);
	    End;
       Else Begin
	     ExtractNumV := Str(Formula(Target,Ok));
	     If Not(Ok)Then
	     Begin
	      R := FormulaReal(Target);
	      System.Str(R,T);
	      Val(Copy(T,Length(T)-4,4),L,LErr);
	      Inc(L,Length(T)-Pos('.',T));
	      If(Frac(R) = 0.0)Then ExtractNumV := RealStr2(R,0,0)
			       Else ExtractNumV := RealStr2(R,0,L-2);
	     End;
	    End;
  End;
 End;

 Function GetString(All:Bool):String;
 Var J:System.Word; T,Num,Word:String; Ok,NotFirst:Bool; OI:Byte;
 Begin
  GetString := ''; Word := ''; NotFirst := False;
  Repeat
   If(NotFirst)Then
   Begin
    IfChrInc('+');
    SkipSpc;
   End;
   Case StrI(I,S) of
    '"' : Begin
	   Inc(I,Length('"'));
	   While Not(StrI(I,S) in [#0,'"']) do
	   Begin
	    IncStr(Word,S[I]);
	    Inc(I);
	   End;
           IfChrInc('"');
          End;
'A'..'Z': Begin
           OI := I;
	   T  := ExtractWord;
           Case StrI(I,S) of
	    '$' : Begin
                   Inc(I,Length('$'));
                   IncStr(T,'$');
                   If(T = 'STR$')Then
                   Begin
                    SkipSpc;
                    If Not(IsSN('('))Then Exit;
                    SkipSpc;
                    Num := ExtractNumV;
                    SkipSpc;
                    If Not(IsSN(')'))Then Exit;
                    AddStr(Word,Num);
		   End
                    Else
		   If(T = 'RIGHT$')Then
                   Begin
                    SkipSpc;
		    If Not(IsSN('('))Then Exit;
                    SkipSpc;
                    T := GetString(False);
                    If(Err <> $FF)Then Exit;
                    SkipSpc;
                    If Not(IsSN(','))Then Exit;
                    SkipSpc;
                    Num := ExtractNumV;
                    If(Err <> $FF)Then Exit;
                    SkipSpc;
                    If Not(IsSN(')'))Then Exit;
		    Val(Num,a,LErr);
                    AddStr(Word,Copy(T,Length(T)-a+1,a));
		   End
                    Else
                   If(T = 'INKEY$')Then
                   Begin
		    Ok := False;
                    If(ShiftPressed)and(CtrlPressed)Then IncStr(Word,#1) Else
                    If(ShiftPressed)and(AltPressed)Then IncStr(Word,#19)
                     Else
                    If(Keypressed)Then
                    Begin
                     K := ReadKey;
                     Case K of
                        kbF2 : IncStr(Word,#4);
                       kbEsc,
		       kbF10 : Begin
                                IncStr(Word,#3);  { Break }
				Brk := True;
                                Exit;
                               End;
                      kbLeft : If(ShiftPressed)Then IncStr(Word,#21)
                                               Else IncStr(Word,#8);
		     kbRight : If(ShiftPressed)Then IncStr(Word,#93)
                                               Else IncStr(Word,#9);
                      kbDown : If(ShiftPressed)Then IncStr(Word,#91)
                                               Else IncStr(Word,#10);
                        kbF4 : IncStr(Word,#12); { Clear }
                     kbEnter : IncStr(Word,#13);
                   kbShiftF4 : IncStr(Word,#92); { Shift-Clear }
                        kbUp : If(ShiftPressed)Then IncStr(Word,#95)
                                               Else IncStr(Word,#94);
			  Else Begin
                                If(KChr > #31)Then
				Begin
                                 Case KChr of
                                  '^' : IncStr(Word,#96);
                                  '_' : IncStr(Word,#127);
                    ' '..'Z','a'..'~' : IncStr(Word,KChr);
                                 End;
				End;
                               End;
                     End;
                    End;
                   End
                    Else
                   If(T = 'HEX$')Then
                   Begin
		    SkipSpc;
                    If Not(IsSN('('))Then Exit;
		    Num := ExtractNum;
                    If(IsEmptyFC(Num))Then Exit;
                    Val(Num,L,b);
                    If(L > $FFFF)Then AddStr(Word,HexLong2Str(L)) Else
                    If(L > $FF)Then AddStr(Word,HexWord2Str(L))
                               Else AddStr(Word,HexByte2Str(L));
                    If Not(IsSN(')'))Then Exit;
		   End
                    Else
                   If(T = 'CHR$')Then
                   Begin
                    SkipSpc;
                    If Not(IsSN('('))Then Exit;
                    Num := ExtractNum;
		    If(IsEmptyFC(Num))Then Exit;
                    Val(Num,a,b);
		    IncStr(Word,Char(a));
                    If Not(IsSN(')'))Then Exit;
                   End
                    Else
		   If(Variable.NmBuf > 0)Then For J := 0 to Variable.MaxBuf do
                   Begin
                    Num := StrPas(Variable._GetBuf(J));
                    If(CmpLeft(Num,T+':'))Then
		    Begin
                     AddStr(Word,Copy(Num,Length(T)+1+Length(':'),255));
                     Break;
                    End;
                   End;
                  End;
	     Else Begin
                   I := OI;
		   AddStr(Word,ExtractNumV);
                   Break;
                  End;
           End;
          End;
'-','(','0'..'9','.':
          Begin
           If(All)Then
           Begin
	    AddStr(Word,ExtractNumV);
            If(Err <> $FF)Then Exit;
            Break;
           End
            Else
	   Begin
            Err := ErrTM;
	    Exit;
           End;
          End;
     Else Begin
	   Err := ErrSN;
	   Exit;
	  End;
   End;
   SkipSpc;
   NotFirst := True;
  Until Not(StrI(I,S) = '+');
  GetString := Word;
 End;

 Function XCmpLeft(Msg:String):Bool;
 Begin
  XCmpLeft := False;
  If(CmpLeft(Word,Msg))Then
  Begin
   If(Length(Word) <> Length(Msg))Then Dec(I,Length(Word)-Length(Msg));
   XCmpLeft := True;
  End;
 End;

Begin
 Err := $FF; Brk := False; LnBrk := $FFFF; ExecCmd := $FFFF;
 If(S = '')Then Exit;
 ExecCmd := 0; I := 1;
 While (I < Length(S)) do
 Begin
  a := NextKey;
  If(a = kbF10)or(a = kbEsc)Then
  Begin
   ReadKey;
   Brk := True; ExecCmd := $FFFF;
   Exit;
  End;
  Case S[I] of
    ' ',':' : Inc(I);
       '''' : Break;
   'A'..'Z' : Begin
	       Word := ExtractWord;
	       If(XCmpLeft('ATTR'))Then
	       Begin
		If(TxtMode = 32)Then
		Begin
		 Err := ErrHP;
		 Exit;
		End;
		Underline := False; Blink := False;
		SkipSpc;
		Num := ExtractNumV;
		If(Num = '')Then a := (W.RColr and $F)
			    Else Val(Num,a,LErr);
		SkipSpc;
		If(StrI(I,S) = ',')Then
		Begin
		 Inc(I,Length(','));
		 SkipSpc;
		 Num := ExtractNumV;
		 If(Num = '')Then a := (W.RColr shr 4)
			     Else Val(Num,b,LErr);
		 While (StrI(I,S) = ',') do
		 Begin
		  Inc(I,Length(','));
		  SkipSpc;
		  If(IfChrInc('B'))Then Blink := True Else
		  If(IfChrInc('U'))Then Underline := True
		   Else
		  Begin
		   Err := ErrSN;
		   Exit;
		  End;
		  SkipSpc;
		 End;
		End;
	       End
		Else
	       If(XCmpLeft('CLS'))Then
	       Begin
		SkipSpc;
		If(Length(S) >= I)Then
		Begin
		 Case S[I] of
		  '0'..'9' : Begin
			      Num := ExtractNumV;
			      If(Err <> $FF)Then Exit;
			      Val(Num,a,LErr);
			      Case a of
			       0 : W.BackGround(0);
			       1 : W.BackGround(2);
			       2 : W.BackGround(14);
			       3 : W.BackGround(9);
			       4 : W.BackGround($C);
			       5 : W.BackGround($F);
			       6 : W.BackGround(5);
			       7 : W.BackGround($D);
			       8 : W.BackGround(6);
			  9..255 : Begin
				    W.BackGround(2);
				    W.ClrScr;
				    PutTxtLn('MICROWARE SYSTEMS CORP.');
				   End;
			      Else Begin
				    Err := errDN;
				    Exit;
				   End;
			      End;
			     End;
		 End;
		End;
		If(a < 9)Then W.ClrScr;
	       End
		Else
	       If(XCmpLeft('GOTO'))Then
	       Begin
		SkipSpc;
		Num := ExtractNum;
		If(Num = '')Then
		Begin
		 Err := ErrUL;
		 Exit;
		End;
		Val(Num,_Goto,LErr);
		Break;
	       End
		Else
	       If(XCmpLeft('HBUFF'))Then
	       Begin
		SkipSpc;
		Num := ExtractNumV;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,a,LErr);
		If Not(IsSN(','))Then Exit;
		Num := ExtractNumV;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,b,LErr);
		_HBuff(a,b);
	       End
		Else
	       If(XCmpLeft('HCOLOR'))Then
	       Begin
		SkipSpc;
		Num := ExtractNumV;
		Val(Num,a,LErr);
		If(IsEmptyFC(Num))Then Exit;
		HColor(a);
	       End
		Else
	       If(XCmpLeft('HDRAW'))Then
	       Begin
		SkipSpc;
		Graf.Draw(GetString(False));
	       End
		Else
	       If(XCmpLeft('HGET'))Then
	       Begin
		SkipSpc;
		If Not(IsSN('('))Then Exit;
		SkipSpc;
		Num := ExtractNumV;
		SkipSpc;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GX1,LErr);
		If Not(IsSN(','))Then Exit;
		Num := ExtractNumV;
		SkipSpc;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GY1,LErr);
		If Not(IsSN(')'))Then Exit;
		SkipSpc;
		If Not(IsSN('-'))Then Exit;
		Skipspc;
		If Not(IsSN('('))Then Exit;
		SkipSpc;
		Num := ExtractNumV;
		SkipSpc;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GX2,LErr);
		If Not(IsSN(','))Then Exit;
		Num := ExtractNumV;
		SkipSpc;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GY2,LErr);
		If Not(IsSN(')'))Then Exit;
		SkipSpc;
		If Not(IsSN(','))Then Exit;
		Num := ExtractNumV;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,a,LErr);
		If(GX1 > GX2)Then SwapInt(GX1,GX2);
		If(GY1 > GY2)Then SwapInt(GY1,GY2);
		HGet(GX1,GY1,GX2,GY2,a);
	       End
		Else
	       If(XCmpLeft('HLINE'))Then
	       Begin
		SkipSpc;
		If Not(IsSN('('))Then Exit;
		SkipSpc;
		Num := ExtractNumV;
		SkipSpc;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GX1,LErr);
		If Not(IsSN(','))Then Exit;
		Num := ExtractNumV;
		SkipSpc;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GY1,LErr);
		If Not(IsSN(')'))Then Exit;
		SkipSpc;
		If Not(IsSN('-'))Then Exit;
		Skipspc;
		If Not(IsSN('('))Then Exit;
		SkipSpc;
		Num := ExtractNumV;
		SkipSpc;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GX2,LErr);
		If Not(IsSN(','))Then Exit;
		Num := ExtractNumV;
		SkipSpc;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GY2,LErr);
		If Not(IsSN(')'))Then Exit;
		SkipSpc;
		If Not(IsSN(','))Then Exit;
		Num := ExtractWord;
		If Not(Num = 'PSET')Then
		Begin
		 Err := ErrFC;
		 Exit;
		End;
		SkipSpc;
		If(StrI(I,S) = ',')Then
		Begin
		 Inc(I,Length(','));
		 Num := ExtractWord;
		 If(Num = 'BF')or(Num = 'FB')Then
		 Begin
		  Graf.PutFillBox(GX1,GY1,GX2,GY2);
		 End
		  Else
		 If(Num = 'B')Then
		 Begin
		  HLine(GX1,GY1,GX2,GY1);
		  HLine(GX1,GY2,GX2,GY2);
		  HLine(GX1,GY1,GX1,GY2);
		  HLine(GX2,GY1,GX2,GY2);
		 End
		  Else
		 Begin
		  Err := ErrSN;
		  Exit;
		 End;
		End
		 Else
		HLine(GX1,GY1,GX2,GY2);
	       End
		Else
	       If(XCmpLeft('HPRINT'))Then
	       Begin
		SkipSpc;
		If Not(IsSN('('))Then Exit;
		Num := ExtractNum;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GX1,LErr);
		SkipSpc;
		If Not(IsSN(','))Then Exit;
		Num := ExtractNum;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GY1,LErr);
		SkipSpc;
		If Not(IsSN(')'))Then Exit;
		SkipSpc;
		If Not(IsSN(','))Then Exit;
		Word := GetString(True);
		If(Err <> $FF)Then Exit;
		Graf.PutTTextXY(GX1,GY1,8,Word);
	       End
		Else
	       If(XCmpLeft('HPUT'))Then
	       Begin
		SkipSpc;
		If Not(IsSN('('))Then Exit;
		SkipSpc;
		Num := ExtractNumV;
		SkipSpc;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GX1,LErr);
		If Not(IsSN(','))Then Exit;
		Num := ExtractNumV;
		SkipSpc;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GY1,LErr);
		If Not(IsSN(')'))Then Exit;
		SkipSpc;
		If Not(IsSN('-'))Then Exit;
		Skipspc;
		If Not(IsSN('('))Then Exit;
		SkipSpc;
		Num := ExtractNumV;
		SkipSpc;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GX2,LErr);
		If Not(IsSN(','))Then Exit;
		Num := ExtractNumV;
		SkipSpc;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,GY2,LErr);
		If Not(IsSN(')'))Then Exit;
		SkipSpc;
		If Not(IsSN(','))Then Exit;
		Num := ExtractNumV;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,a,LErr);
		SkipSpc;
		If(StrI(I,S) = ',')Then
		Begin
		 Inc(I,Length(','));
		 SkipSpc;
		 Num := ExtractWord;
		 If Not(Num = 'PSET')Then
		 Begin
		  Err := ErrFC;
		  Exit;
		 End;
		End;
		If(GX1 > GX2)Then SwapInt(GX1,GX2);
		If(GY1 > GY2)Then SwapInt(GY1,GY2);
		HPut(GX1,GY1,GX2,GY2,a);
	       End
		Else
	       If(XCmpLeft('HSCREEN'))Then
	       Begin
		SkipSpc;
		Num := ExtractNumV;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,a,b);
		HScreen(a);
	       End
		Else
	       If(XCmpLeft('IF'))Then
	       Begin
		Ok := False;
		SkipSpc;
		Word := GetString(True);
		If(Err <> $FF)Then Exit;
		SkipSpc;
		If(StrI(I,S) = '=')Then
		Begin
		 Inc(I,Length('='));
		 Num := GetString(True);
		 If(Err <> $FF)Then Exit;
		 Ok  := (Word = Num);
		End
		 Else
		If(StrI(I,S) = '<')Then
		Begin
		 Inc(I,Length('<'));
		 Case StrI(I,S) of
		  '=' : Begin
			 Inc(I,Length('='));
			 Num := GetString(True);
			 If(Err <> $FF)Then Exit;
			 Ok := (Word <= Num);
			End;
		  '>' : Begin
			 Inc(I,Length('>'));
			 Num := GetString(True);
			 If(Err <> $FF)Then Exit;
			 Ok := (Word <> Num);
			End;
		   Else Begin
			 Num := GetString(True);
			 If(Err <> $FF)Then Exit;
			 Ok := (Word < Num);
			End;
		 End;
		End
		 Else
		If(StrI(I,S) = '>')Then
		Begin
		 Inc(I,Length('>'));
		 If(StrI(I,S) = '=')Then
		 Begin
		  Inc(I,Length('='));
		  Num := GetString(True);
		  If(Err <> $FF)Then Exit;
		  Ok := (Word >= Num);
		 End
		  Else
		 Begin
		  Num := GetString(True);
		  If(Err <> $FF)Then Exit;
		  Ok := (Word > Num);
		 End;
		End
		 Else
		Begin
		 Err := ErrSN;
		 Exit;
		End;
		SkipSpc;
		Word := ExtractWord;
		If Not(XCmpLeft('THEN'))Then
		Begin
		 Err := ErrSN;
		 Exit;
		End;
		SkipSpc;
		If Not(Ok)Then While Not(StrI(I,S) = #0) do
		Begin
		 If(StrI(I,S) = 'E')and(StrI(I+1,S) = 'L')and
		   (StrI(I+2,S) = 'S')and(StrI(I+3,S) = 'E')Then
		 Begin
		  Ok := True;
		  Break;
		 End;
		 Inc(I);
		End;
		If(StrI(I,S) in ['0'..'9'])Then
		Begin
		 If(Ok)Then
		 Begin
		  Num := ExtractNum;
		  Val(Num,_Goto,LErr);
		  Break;
		 End;
		End;
	       End
		Else
	       If(XCmpLeft('LIST'))Then
	       Begin
		SkipSpc;
		Num := ExtractNum;
		If(Num = '')Then H := 0
			    Else Val(Num,H,LErr);
		If(StrI(I,S) = '-')Then
		Begin
		 Inc(I,Length('-'));
		 Num := ExtractNum;
		 If(Num = '')Then E := $FFFF
			     Else Val(Num,E,LErr);
		End
		 Else
		Begin
		 If(Num = '')Then E := $FFFF
			     Else E := H;
		End;
		List.SetPtr(0);
		If(LIst.NmBuf > 0)Then For a := 0 to List.MaxBuf do
		Begin
		 Ptr := List._GetCurrBuf;
		 If(Ptr^.Nm >= H)and(Ptr^.Nm <= E)Then
		  PutTxtLn(Str(Ptr^.Nm)+' '+StrPas(Ptr^.PChr));
		 List.Next;
		 If(NextKey = kbF10)or(NextKey = kbEsc)Then
		 Begin
		  ReadKey;
		  Brk := True;
		  Break;
		 End;
		End;
		Continue;
	       End
		Else
	       If(XCmpLeft('LOAD'))Then
	       Begin
		SkipSpc;
		Name := '';
		If(StrI(I,S) = '"')Then
		Begin
		 Inc(I,Length('"'));
		 While Not(StrI(I,S) in [#0,'"']) do
		 Begin
		  IncStr(Name,S[I]);
		  Inc(I);
		 End;
		 IfChrInc('"');
		 P := 0;
		 If(Path2Ext(Name) = '')Then AddStr(Name,'.BAS');
		 a := Open(Name,ReadOnly);
		 If(IsHandleErr(a))Then
		 Begin
		  Err := errIO;
		  Exit;
		 End;
		 List.Done;
		 List.Init;
		 FS := FileSize(a);
		 Repeat
		  SetFilePos(a,P);
		  S := GetFileTextLn(a);
		  Inc(P,Length(S)+2);
		  If(S <> '')Then
		  Begin
		   Num := '';
		   I   := 1;
		   While(StrI(I,S) in ['0'..'9'])do
		   Begin
		    IncStr(Num,S[I]);
		    Inc(I);
		   End;
		   If(Num <> '')Then
		   Begin
		    Val(Num,L,LErr);
		    S := DelAllSpcLeft(Copy(S,I,255));
		    List.AddStrWord(S,L);
		   End;
		  End;
		 Until (P > FS);
		 Close(a);
		 ExecCmd := $FFFF;
		 Exit;
		End
		 Else
		Begin
		 Err := errIO;
		 Exit;
		End;
	       End
		Else
	       If(XCmpLeft('ON'))Then
	       Begin
		SkipSpc;
		Word := ExtractWord;
		If(XCmpLeft('BRK'))Then
		Begin
		 SkipSpc;
		 Word := ExtractWord;
		 If(XCmpLeft('GOTO'))Then
		 Begin
		  SkipSpc;
		  Num := ExtractNum; OnBrk := True;
		  Val(Num,L,LErr);
		  OnBrkLn := L;
		 End
		  Else
		 Begin
		  Err := ErrSN;
		  Exit;
		 End;
		End
		 Else
		Begin
		 Err := ErrSN;
		 Exit;
		End;
	       End
		Else
	       If(XCmpLeft('PALETTE'))Then
	       Begin
		SkipSpc;
		Num := ExtractNumV;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,a,LErr);
		SkipSpc;
		If Not(IsSN(','))Then Exit;
		Num := ExtractNumV;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,b,LErr);
	       End
		Else
	       If(XCmpLeft('PRINT'))Then
	       Begin
		SkipSpc;
		If(StrI(I,S) in [#0,':'])Then Ln
		 Else
		Begin
		 Repeat
		  Ok := True; Word := GetString(True);
		  If(Word <> '')and(Err <> $FF)Then Exit;
		  Case StrI(I,S) of
		   ',' : Begin
			  Ok := False; Inc(I);
			  PutTxt(SpcTab+Word);
			 End;
		   ';' : Begin
			  Ok := False; Inc(I);
			  PutTxt(Word);
			 End;
		    Else PutTxtLn(Word);
		  End;
		 Until Ok;
		End;
	       End
		Else
	       If(XCmpLeft('REM'))Then Break Else
	       If(XCmpLeft('RUN'))Then
	       Begin
		For R := 0 to List.MaxBuf do
		Begin
_HomeExec:
		 Ptr := List._GetBuf(R);
		 If(ExecCmd(StrPas(Ptr^.PChr)) = 0)Then
		 Begin
		  LnErr := Ptr^.Nm; RunErr := True;
		  Exit;
		 End;
		 If(_Goto < $FFFF)Then
		 Begin
		  _Goto := SearchLn(_Goto);
		  If(_Goto = $FFFF)Then
		  Begin
		   Err := ErrUL;
		   Exit;
		  End;
		  R := _Goto; _Goto := $FFFF;
		  Goto _HomeExec;
		 End;
		 If(Brk)Then
		 Begin
		  If(OnBrk)Then
		  Begin
		   OnBrkLn := SearchLn(OnBrkLn);
		   If(OnBrkLn = $FFFF)Then
		   Begin
		    Err := ErrUL;
		    Exit;
		   End;
		   R := OnBrkLn;
		   Goto _HomeExec;
		  End
		   Else
		  Begin
		   LnBrk := Ptr^.Nm;
		   Break;
		  End;
		 End;
		End;
		Break;
	       End
		Else
	       If(XCmpLeft('WIDTH'))Then
	       Begin
		SkipSpc;
		Num := ExtractNumV;
		If(IsEmptyFC(Num))Then Exit;
		Val(Num,a,b);
		Width(a);
		If(Err <> $FF)Then Exit;
	       End
		Else
	       Begin
		If(StrI(I,S) = '$')Then { Variable$ ? }
		Begin
		 Inc(I,Length('$'));
		 Name := Word + '$';
		 SkipSpc;
		 If Not(IsSN('='))Then Exit;
		 Word := GetString(False); a := SearchVar(Name);
		 If(a < $FFFF)Then Variable.DelBuf(a);
		 If Not(Variable.AddStr(Name+':'+Word))Then
		 Begin
		  Err := ErrOM;
		  Exit;
		 End;
		End
		 Else
		Begin { Variable }
		 Name := Word;
		 SkipSpc;
		 If Not(IsSN('='))Then Exit;
		 Word := ExtractNumV; a := SearchVar(Name);
		 If(a < $FFFF)Then Variable.DelBuf(a);
		 If Not(Variable.AddStr(Name+'='+Word))Then
		 Begin
		  Err := ErrOM;
		  Exit;
		 End;
		End;
		SkipSpc;
		IfChrInc(':');
	       End;
	      End;
	 Else Begin
	       Err := errSN;
	       Exit;
	      End;
  End;
 End;
 ExecCmd := $FFFF;
End;

Procedure Coco3Emul.PutErr;
Begin
 If Not(RunErr)Then PutTxt('?');
 Case Err of
  errNF : PutTxt('NF');
  errSN : PutTxt('SN');
  errRG : PutTxt('RG');
  errOD : PutTxt('OD');
  errFC : PutTxt('FC');
  errOV : PutTxt('OV');
  errOM : PutTxt('OM');
  errUL : PutTxt('UL');
  errBS : PutTxt('BS');
  errDD : PutTxt('DD');
  err_0 : PutTxt('/0');
  errID : PutTxt('ID');
  errTM : PutTxt('TM');
  errOS : PutTxt('OS');
  errLS : PutTxt('LS');
  errST : PutTxt('ST');
  errCN : PutTxt('CN');
  errFD : PutTxt('FD');
  errAO : PutTxt('AO');
  errDN : PutTxt('DN');
  errIO : PutTxt('IO');
  errFM : PutTxt('FM');
  errNO : PutTxt('NO');
  errIE : PutTxt('IE');
  errDS : PutTxt('DS');
  errHR : PutTxt('HR');
  errHP : PutTxt('HP');
 End;
 PutTxt(' ERROR');
 If(RunErr)Then PutTxt(' IN '+Str(LnErr));
 Ln;
End;

Procedure Coco3Emul.SetPlace;
Var I,NB:Word; Ptr:^PCharWordRec;
Begin
 NB := List.NmBuf;
 If(NB = 1)Then
 Begin
  Ptr := List._GetBuf(0);
  If(Ptr^.Nm > Num)Then List.InsStrWord(0,S,Num) Else
  If(Ptr^.Nm = Num)Then
  Begin
   List.DelBuf(0);
   If(S <> '')Then List.AddStrWord(S,Num);
  End
   Else
  List.AddStrWord(S,Num);
 End
  Else
 Begin
  For I := 0 to List.MaxBuf do
  Begin
   Ptr := List._GetBuf(I);
   If(Ptr^.Nm = Num)Then
   Begin
    List.DelBuf(I);
    If(S <> '')Then List.InsStrWord(I,S,Num);
    Exit;
   End;
   If(Ptr^.Nm > Num)Then
   Begin
    List.InsStrWord(I,S,Num);
    Exit;
   End;
  End;
  List.AddStrWord(S,Num);
 End;
End;

Procedure Coco3Emul.InitCmd;
Begin
 RunErr := False; OnBrk := False; OnBrkLn := $FFFF; _Goto := $FFFF;
 LnErr := $FFFF; LnBrk := $FFFF;
End;

Function Coco3Emul.Run;
Var Input,Num:String; K,L,LErr:Word; I:Byte; Chr:Char Absolute K;
    OldCaps:Bool; Save:Wins;
Begin
 Run := 0; Input := '';
 Scr.PopWn;
 OldCaps := GetCapsLock;
 SetCapsLock(Caps);
 Repeat
  W.SetCurPos(W.RX,W.RY);
  PushCursor;
  If(TxtMode = 32)Then
  Begin
   Repeat
    AnimateCursor;
   Until Keypressed;
  End
   Else
  CursorBlock(W.GetRealX,W.GetRealY);
  Caps := GetCapsLock;
  PopCursor;
  K := W.Readk;
  Case K of
   kbF4 :
   Begin
    InitCmd;
    ExecCmd('CLS');
   End;
   kbF9,kbCtrlF9 :
   Begin
    InitCmd;
    PushKey(Byte('R'));
    PushKey(Byte('U'));
    PushKey(Byte('N'));
    PushKey(kbEnter);
   End;
   kbEnter :
   Begin
    InitCmd;
    Ln;
    Input := DelAllSpcRight(DelAllSpcLeft(Input));
    If(Input <> '')Then
    Begin
     If(Input[1] in ['0'..'9'])Then
     Begin
      Num := ''; I := 1;
      While(StrI(I,Input) in ['0'..'9'])do
      Begin
       IncStr(Num,Input[I]); Inc(I);
      End;
      Val(Num,L,LErr);
      Input := DelAllSpcLeft(Copy(Input,I,255));
      If(List.NmBuf = 0)Then List.AddStrWord(Input,L)
			Else SetPlace(L,Input);
     End
      Else
     Begin
      If(ExecCmd(Input) = 0)Then
      Begin
       If(HighMode > 0)Then Width(TxtMode);
       PutErr;
      End;
      If(TxtMode = 32)Then W.SetKr($A0);
      If(Brk)Then
      Begin
       If(HighMode > 0)Then Width(TxtMode);
       If(LnBrk = $FFFF)Then PutTxtLn('BREAK')
			Else PutTxtLn('BREAK IN '+Str(LnBrk));
      End;
      PutTxtLn('OK');
     End;
     Input := '';
    End;
   End;
   kbBackSpace :
   Begin
    If(Input <> '')Then
    Begin
     BackStr(Input);
     If(W.RX = 0)Then
     Begin
      W._Up;
      W.RX := W.MaxXTxts;
     End
      Else
     W._Left;
     W.SetChr(W.RX,W.RY,' ');
    End;
   End;
   Else
   Begin
    If(Chr > #31)Then
    Begin
     IncStr(Input,Chr);
     PutTxt(Chr);
     If(W.RX = W.MaxXTxts)Then Ln;
    End
     Else
    Break;
   End;
  End;
 Until False;
 Scr.PushWn;
 SetCapsLock(OldCaps);
 InitCmd;
 Run := K;
End;

Destructor Coco3Emul.Done;
Begin
 HBuff.Done;
 Variable.Done;
 Scr.Done;
 List.Done;
 W.Done;
End;

BEGIN
END.