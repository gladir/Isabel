Unit MalCalc;

INTERFACE

Uses Dos,Math,Memorys,Mems,Video,Windows;

Type

     Calc = Object
      Constructor Init(X1,Y1,X2,Y2,Model:Byte);
      Constructor Load(X1,Y1,X2,Y2,Model:Byte;Path:PathStr);
      Procedure Refresh;
      Function Run:Word;
      Destructor Done;
      PRIVATE
      FileName:PathStr;
      Mode:Byte;
      W:Wins;
      Buf:IBuf;
      PX,PY,PZ:Long;
      XS,YS:Byte;
      Moved:Bool;
      BufChr:String;
      Procedure PutUnselect;
      Procedure PutSelect;
      Procedure PushData(S:String);
      Procedure PutData(_XS,_YS:Byte;_PX,_PY:Long);
     End;

IMPLEMENTATION

Uses Strings,Strs,Keyboard,MLibrary,Dials;

Function Tab2Str(X:Long):String;
Var S : String;
Begin
 Inc(X);
 If(X > 9999)Then
 Begin
  S := Str((X mod 10000) * 10000);
  If((X mod 10000) > 0)Then AddStr(S,'+');
 End
  Else
 S := '';
 Case ((X mod 10000) div 1000) of
  9 : AddStr(S,'MMMMMMMMM');
  8 : AddStr(S,'MMMMMMMM');
  7 : AddStr(S,'MMMMMMM');
  6 : AddStr(S,'MMMMMM');
  5 : AddStr(S,'MMMMM');
  4 : AddStr(S,'MMMM');
  3 : AddStr(S,'MMM');
  2 : AddStr(S,'MM');
  1 : IncStr(S,'M');
 End;
 Case ((X mod 1000) div 100) of
  9 : AddStr(S,'CM');
  8 : AddStr(S,'DCCC');
  7 : AddStr(S,'DCC');
  6 : AddStr(S,'DC');
  5 : IncStr(S,'D');
  4 : AddStr(S,'CD');
  3 : AddStr(S,'CCC');
  2 : AddStr(S,'CC');
  1 : IncStr(S,'C');
 End;
 Case ((X mod 100) div 10) of
  9 : AddStr(S,'XC');
  8 : AddStr(S,'LXXX');
  7 : AddStr(S,'LXX');
  6 : AddStr(S,'LX');
  5 : IncStr(S,'L');
  4 : AddStr(S,'XL');
  3 : AddStr(S,'XXX');
  2 : AddStr(S,'XX');
  1 : IncStr(S,'X');
 End;
 Case (X mod 10) of
  9 : AddStr(S,'IX');
  8 : AddStr(S,'VIII');
  7 : AddStr(S,'VII');
  6 : AddStr(S,'VI');
  5 : IncStr(S,'V');
  4 : AddStr(S,'IV');
  3 : AddStr(S,'III');
  2 : AddStr(S,'II');
  1 : IncStr(S,'I');
 End;
 Tab2Str := S;
End;

Function Col2Str(C:Long):String;
Var S : String[6];
Begin
 Inc(C);
 If(C > 308915802)Then S := Char(Byte('A') + ((C - 308915803) div 308915776))
		  Else S := '';
 If(C > 11881402)Then IncStr(S,Char(Byte('A') + ((C - 11881403) div 11881376)));
 If(C > 457002)Then IncStr(S,Char(Byte('A') + ((C - 457003) div 456976)));
 If(C > 18278)Then IncStr(S,Char(Byte('A') + ((C - 18279) div 17576)));
 If(C > 702)Then IncStr(S,Char(Byte('A') + (((C - 703) mod 17576) div 676)));
 If(C > 26)Then IncStr(S,Char(Byte('A') + (((C - 27) mod 676) div 26)));
 IncStr(S,Char(Byte('A') + ((C - 1) mod 26)));
 Col2Str := S;
End;

Constructor Calc.Init;
Begin
 Case Model of
   3 : Mode := 3;
  Else Mode := 2;
 End;
 Buf.Init;
 W.Init(X1,Y1,X2,Y2);
 W.PushWn;
 PX := 0; PY := 0; PZ := 0; XS := 0; YS := 0; Moved := False; BufChr := '';
 Refresh;
End;

Constructor Calc.Load;
Begin
 Case Model of
   3 : Mode := 3;
  Else Mode := 2;
 End;
 Buf.Init;
 W.Init(X1,Y1,X2,Y2);
 W.PushWn;
 PX := 0; PY := 0; PZ := 0; XS := 0; YS := 0;
 Refresh;
End;

Procedure Calc.Refresh;
Var Title : PathStr; J : Long; H : Byte;
Begin
 Case Mode of
   2 : Title := 'Chiffrier êlectronique';
   3 : Title := 'Chiffrier Tri-êlectronique';
  Else Title := '';
 End;
 If(FileName <> '')Then AddStr(Title,' - '+FileName);
 W.PutWn(Title,CurrColors.Dialog.Wins);
 H := (1 + Byte(Mode = 3));
 W.SetKr($B0);
 If(Buf.NmBuf = 0)Then
 Begin
  W.SetPos(10,H-1);
  For J := 0 to (W.MaxXTxts div 10) do W.PutTxt(CenterStr(Col2Str(J),10));
  W.SetPos(0,H);
  For J := PY to PY + (W.MaxYTxts - H) do W.PutTxtLn(Str2(J,10));
 End;
 W.SetKrBorder;
 PutSelect;
End;

Procedure Calc.PutData;
Var Size:Word; PChr:PChar; PBufX:^IBuf; S:String;
Begin
 PBufX := Buf.GetBuf(_PY,Size);
 If(PBufX = NIL)Then S := ''
  Else
 Begin
  PChr := PBufX^.GetBuf(_PX,Size);
  If(Size = 0)Then S := ''
              Else S := StrPas(PChr);
 End;
 W.PutTxtXYU(10+_XS,_YS+1+Byte(Mode = 3),StrUSpc(S,10));
End;

Procedure Calc.PutSelect;
Begin
 W.SetKr($1F);
 PutData(XS,YS,PX,PY);
 W.BarSelHor(10+XS,YS+1+Byte(Mode = 3),19+XS);
 W.SetKrBorder;
End;

Procedure Calc.PutUnSelect;
Begin
 W.SetKrBorder;
 W.BarSelHor(10+XS,YS+1+Byte(Mode = 3),19+XS);
End;

Procedure Calc.PushData;
Var Size:Word; PChr:PChar; PBufX:^IBuf;
Begin
 PBufX := Buf.GetBuf(PY,Size);
 If(PBufX = NIL)Then
 Begin
  PBufX := Buf.SetBuf(PY,SizeOf(IBuf));
  If(PBufX = NIL)Then  Begin __OutOfMemory; Exit; End;
  PBufX^.Init;
 End;
 PChr := PBufX^.SetBuf(PX,Length(S)+1);
 If(PChr = NIL)Then __OutofMemory
               Else StrPCopy(PChr,S);
End;

Function Calc.Run;
Var K:Word; I : Byte;
Begin
 Repeat
  K := W.Readk;
  Case K of
   kbLeft : If(PX > 0)Then
            Begin
             PutUnSelect;
             Dec(PX);
             If(XS-10 >= 0)Then Dec(XS,10)
              Else
             Begin
             End;
             PutSelect;
             Moved := True;
            End
             Else
            Beep;
     kbUp : If(PY > 0)Then
	    Begin
	     PutUnSelect;
	     Dec(PY);
	     If(YS > 0)Then Dec(YS)
	      Else
	     Begin
	      W.ScrollUp(0,1+Byte(Mode = 3),wnMax,wnMax);
	      W.SetKr($B0);
	      W.PutTxtXY(0,1+Byte(Mode = 3),Str2(PY,10));
	      W.SetKrBorder;
	     End;
             For I := 0 to (W.MaxXTxts div 10)-1 do PutData(I*10,YS,I,PY);
	     PutSelect;
	     Moved := True;
	    End
	     Else
	    Beep;
  kbRight : If(PX < 2147483647)Then
            Begin
             PutUnSelect;
             Inc(PX);
             If(XS+10 < W.MaxXTxts)Then Inc(XS,10)
              Else
             Begin
             End;
             PutSelect;
             Moved := True;
            End
             Else
            Beep;
   kbDown : If(PY < 2147483647)Then
	    Begin
	     PutUnSelect;
	     Inc(PY);
	     If(YS < W.MaxYTxts-(1+(Byte(Mode = 3))))Then Inc(YS)
	      Else
	     Begin
	      W.ScrollDn(0,1+Byte(Mode = 3),wnMax,wnMax);
	      W.SetKr($B0);
	      W.PutTxtXY(0,W.MaxYTxts,Str2(PY,10));
	      W.SetKrBorder;
	     End;
             For I := 0 to (W.MaxXTxts div 10)-1 do PutData(I*10,YS,I,PY);
	     PutSelect;
	     Moved := True;
	    End
	     Else
	    Beep;
kbBackSpace:If(Moved)Then
	    Begin
	     Moved := False; BufChr := '';
	    End
	     Else
	    Begin
	     BackStr(BufChr);
	     W.PutTxtXYU(10+XS,YS+1+Byte(Mode = 3),CopyStr(BufChr,1,10));
	    End;
  kbEnter : PushData(BufChr);
       Else If(Char(K) > #31)Then
	    Begin
	     If(Moved)Then
	     Begin
	      Moved := False; BufChr := '';
	     End;
	     IncStr(BufChr,Char(K));
	     W.PutTxtXYU(10+XS,YS+1+Byte(Mode = 3),CopyStr(BufChr,1,10));
	    End
	     Else
	    Break;
  End;
 Until False;
 Run := K;
End;

Destructor Calc.Done;
Begin
 W.Done;
 Buf.Done;
End;

BEGIN
END.