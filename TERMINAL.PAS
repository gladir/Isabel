{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³             Malte Genesis III/Module du Terminal           ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Terminal;

INTERFACE

{$D-,L-,Y-,I-,Q-,R-,S-,X+}

Uses Dos,Math,Systems,Video,Dials,Windows;

Const

      NUL  = 0;
      SOH  = $01;
      STX  = $02;
      ETX  = 3;
      EOT  = $04;
      ENQ  = 5;
      ACK  = $06;
      BELL = 7;
      BS   = 8;
      HT   = 9;
      LF   = 10;
      VT   = 11;
      FF   = 12;
      CR   = 13;
      SO   = 14;
      SI   = 15;
      DLE  = 16;
      XON  = 17;
      XOFF = 19;
      NAK  = $15;
      SYN  = $16;
      CAN  = $18;
      SUB  = 26;
      ESC  = 27;
      FS   = 28;
      GS   = 29;
      RS   = 30;
      US   = 31;
      SP   = 32;
      DEL  = 127;

Type

     Ansi = Object(Wins)
      OX,OY:Byte;
      PauseLn:Bool;
      Constructor AnsiInit(X1,Y1,X2,Y2,L,H:Byte);
      Procedure SubList(X1,Y1,X2,Y2:Byte;Title:String;Var L:LstMnu);
      Procedure PushCursor;
      Procedure PopCursor;
      Function Put(S:PChar):Bool;
      Function AnsiLn:Bool;
      Function PutLn(S:PChar):Bool;
      Function TypeFile(Path:PathStr):Bool;
      Function Read(S:PChar):String;
      Procedure SetPause(X:Bool);
      PRIVATE
      Lns:Byte;
      Procedure SetAttribut(S:String);
     End;

IMPLEMENTATION

Uses MLibrary,Language,Memorys,Clock,Keyboard,Strings;

Constructor Ansi.AnsiInit;
Begin
 Inherited Init(X1,Y1,X2,Y2);
 PauseLn := False;
End;

Procedure Ansi.SetPause;
Begin
 PauseLn := X; Lns := 0;
End;

Procedure Ansi.SubList;
Begin
 L._QInit(GetRX1+X1,GetRY1+Y1,GetRX1+X2,GetRY1+Y2,Title,XColrs);
End;

Procedure Ansi.SetAttribut;
Begin
 If(S = '0')Then RColr := 7;
 If(S = '1')Then RColr := RColr or 8;
 If(S = '2')Then RColr := RColr and $F7;
 If(S = '5')Then RColr := (RColr and $7F) + 8;
 If(S = '30')Then Inherited Foreground(Black);
 If(S = '31')Then Inherited Foreground(Red);
 If(S = '32')Then Inherited Foreground(Green);
 If(S = '33')Then Inherited Foreground(Brown);
 If(S = '34')Then Inherited Foreground(Blue);
 If(S = '35')Then Inherited Foreground(Magenta);
 If(S = '36')Then Inherited Foreground(Cyan);
 If(S = '37')Then Inherited Foreground(LightGray);
 If(S = '40')Then Inherited Background(Black);
 If(S = '41')Then Inherited Background(Red);
 If(S = '42')Then Inherited Background(Green);
 If(S = '43')Then Inherited Background(Brown);
 If(S = '44')Then Inherited Background(Blue);
 If(S = '45')Then Inherited Background(Magenta);
 If(S = '46')Then Inherited Background(Cyan);
 If(S = '47')Then Inherited Background(LightGray);
 If(S = '49')Then Put('^');
End;

Procedure Ansi.PushCursor;
Begin
 OX := RX; OY := RY;
End;

Procedure Ansi.PopCursor;
Begin
 RX := OX; RY := OY;
End;

Function Ansi.Put;
Var I,J,I2:Word; SN:String; Header:Char; Value,Err:Int;

 Function XLn:Bool;
 Begin
  XLn := True;
  Inherited _Ln;
  If(PauseLn)Then
  Begin
   If((Lns + 1) >= Wins.MaxYTxts)Then
   Begin
    Lns := 0;
    Ansi.Put('Esc pour arrˆter, ou presse une autre touche pour continuer...');
    If(Inherited Readk = kbEsc)Then
    Begin
     Inherited _Ln;
     Put := True;
     Exit;
    End;
    Inherited _Ln;
   End
    Else
   Inc(Lns);
  End;
  XLn := False;
 End;

Begin
 I := 0; Put := False;
 While True do Case S[I] of
  #0 : Exit;
  #7 : Begin
	Beep;
	Inc(I);
       End;
  #8 : Begin
	Inc(I);
	_Left;
	SetChr(RX,RY,' ');
       End;
  #9 : Begin
	Inc(I);
	For I2 := 0 to 7 do Ansi.Put(' ');
       End;
 #13 : Begin
	Inc(I);
	If(XLn)Then Exit;
       End;
 #10 : Inc(I);
 #27 : Begin
	Inc(I);
	Case S[I] of
	 '[' : Begin
		Inc(I);
		Case S[I] of
		     'A' : Inherited _Up;
		     'B' : Inherited _Dn;
		     'C' : Inherited _Right;
		     'D' : Inherited _Left;
		     'K' : Inherited ClrEol;
		     'r' : PushCursor;
		     's' : PopCursor;
		'0'..'9' : Begin
			    SN := PExtractCNum(I,S);
			    Val(SN,Value,Err);
			    Case S[I] of
				 ';' : Begin
					Header := GetNextLetter(I,S);
					If(Header = #0)Then Exit;
					While (S[I] = ';') do
					Begin
					 Inc(I);
					 SN := PExtractWord(I,S);
					End;
				       End;
				 'm' : SetAttribut(SN);
				 'A' : Inherited Up(Value);
				 'B' : Inherited Dn(Value);
				 'C' : Inherited Right(Value);
				 'D' : Inherited Left(Value);
				 'J' : If(SN = '2')Then
				       Begin
					Inherited ClrScr;
					Inc(I);
				       End;
				  Else Exit;
			    End;
			    Exit;
			   End;
		 Else Exit;
		End;
		Inc(I);
	       End;
	  Else Exit;
	 End;
	End;
   Else Begin
	 PutCube(S[I]);
	 Inc(I);
	 If(XIsOut)Then If(XLn)Then Exit;
	End;
 End;
End;

Function Ansi.PutLn;
Var X:Bool;
Begin
 X := Put(S);
 If Not(X)Then X := Put(#13#10);
 PutLn := X;
End;

Function Ansi.AnsiLn;
Begin
 AnsiLn := PutLn('');
End;

Function Ansi.TypeFile;
Var Handle,J:Word; I,Size:Long;
    Buffer:Record PChr:Array[0..511] of Char;_End:Char; End;
Begin
 TypeFile := False;
 Handle := Systems.Open(Path,Systems.ReadOnly); Buffer._End := #0;
 If(IsHandleErr(Handle))Then PutLn(GetDosErrMsg(FileError))
  Else
 Begin
  Size := Systems.FileSize(Handle);
  If(Size > 0)Then
  Begin
   For I := 0 to (Size div SizeOf(Buffer.PChr)) - 1 do
   Begin
    Systems.GetRec(Handle,I,SizeOf(Buffer.PChr),Buffer.PChr);
    If(FileError > 0)Then PutLn(GetDosErrMsg(FileError));
    If(Ansi.Put(Buffer.PChr))Then
    Begin
     Systems.Close(Handle);
     Exit;
    End;
    If Not(PauseLn)Then If(Keypressed)Then
    Begin
     ClrKbd;
     AnsiLn;
     Wins.PutTxtXY(0,RY,'Dois-je annuler l''op‚ration (O/N) ?');
     If(Char(ReadKey) in ['o','O'])Then
     Begin
      Systems.Close(Handle);
      Exit;
     End;
    End;
   End;
   If((Size mod SizeOf(Buffer)) > 0)Then
   Begin
    FillChar(Buffer,SizeOf(Buffer),0);
    Systems.SetFilePos(Handle,(Size div SizeOf(Buffer.PChr)) * SizeOf(Buffer.PChr));
    Systems._GetRec(Handle,Size mod SizeOf(Buffer.PChr),Buffer.PChr);
    Ansi.Put(Buffer.PChr);
   End;
  End;
  Systems.Close(Handle);
  TypeFile := True;
 End;
End;

Function Ansi.Read;
Begin
End;

BEGIN
END.