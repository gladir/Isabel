{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³           Malte Genesis III/Module des Dialogues           ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Dials;

INTERFACE

{$B-,E+,I-,N+,Q-,R-,S-,X+}

Uses Dos,Math,MLibrary,Video,Cursor,Windows,Mems;

Const

      KeyStrc : Array[0..8] of Word = (kbHelp,kbOk,kbCancel,kbYes,
		 kbNo,kbRetry,kbAbort,kbIgnore,kbDefault);

Type

     MultiInputPtr = ^MultiInputRec;

     MatrixColors = Record
      Name:PChar;
      Menu:Record
       Normal,High,Select:Byte;
      End;
      Dialog:Record
       Wins:MtxColors;
       Env:Record
	BarSelInactive,BarSelect:Byte;
       End;
      End;
      ErrorWin:Record
       Wins:MtxInputColors;
       Env:Record
	Input:Byte;
       End;
      End;
      WarningWin:MtxInputColors;
      RemWin:MtxInputColors;
      OpenWin:Record
       Wins:MtxColors;
       Env:Record
	Input,Dir:Byte;
       End;
      End;
      MalteDos:Record
       Wins:MtxColors;
       Env:Record
	Default,Prompt:Byte;
       End;
      End;
      Editor:Record
       Wins:MtxColors;
       Env:Record
	BarInfo,Default,Rem,ResWord,Chars,Symbol:Byte;
	AsmInst,Number,Z,Normal,Pos,Insert,Modified:Byte;
       End;
      End;
      PersonalJournal:Record
       Wins:MtxColors;
       Env:Record
	BarInfo,Default,Pos,Insert:Byte;
       End;
      End;
      ViewAscii:Record
       Wins:MtxColors;
       Env:Record
	BarInfo,Default,Rem,ResWord,Chars,Symbol:Byte;
	AsmInst,Number,Z,Normal,Pos,Insert,Modified:Byte;
       End;
      End;
      HexView:Record
       Wins:MtxColors;
       Env:Record
	Input:Byte;
       End;
      End;
      EditButt:MtxColors;
      Dial:Record
       Wins:MtxColors;
       Env:Record
	BarSelect,BarUnSelect,Number:Byte
       End;
      End;
      Draw:Record
       Wins:MtxColors;
      End;
      Help:Record
       Wins:MtxColors;
      End;
     End;

     MultiInputRec = Record
      X1,Y,X2:Byte;
      Msg,Buffer:PChar;
      MaxLen:Word;
      Next:MultiInputPtr;
     End;

     LineImage = Object
      Constructor Init;
      Function Push(X1,Y,X2:Byte):Bool;
      Procedure ReSave(X1,Y,X2:Byte);
      Procedure BarSelect(Color:Byte);
      Procedure _Pop;
      Destructor Pop;
      PRIVATE
      Size:Word;
      Buffer:Pointer;
      PX1,PY,PX2:Byte;
      Procedure Copy;
      Procedure Put;
     End;

     BlockButton = Record
      Name:String[19];
      Data:Array[0..31,0..31] of Byte;
     End;

     ButtonMnu = Object
      Constructor LoadAll(Name:PathStr;X,Y:Byte);
      Constructor LoadAllVert(Name:PathStr;X,Y,PerLine:Byte);
      Function UseXTexts:Byte;
      Function UseYTexts:Byte;
      Function GetBut(X,Y:Byte):Word;
      Destructor Done;
      PRIVATE
      FileName:PathStr;
      QX,QY,QPerLine:Byte;
      Direction:(Hori,Vert);
      NB:Word;
     End;

     LstMnu = Object(RBuf)
      P:Word;
      Constructor Init(X1,Y1,X2,Y2:Byte;Title:String;Kr:MtxColors);
      Constructor _QInit(X1,Y1,X2,Y2:Byte;Title:String;Kr:MtxColors);
      Constructor InitCenter(L,H:Byte;Title:String;Kr:MtxColors);
      Constructor QInit(X1,Y1,X2,Y2:Byte);
      Procedure SetEndBar(Attr:Byte);
      Procedure PutEndBar(X:Byte;Msg:String;Attr:Byte);
      Procedure PutSmallShade;
      Procedure PutBarMouseRight;
      Procedure Refresh;
      Procedure SelBar;
      Procedure SelBarInactive;
      Procedure UnSelBar;
      Procedure PutDataHome;
      Procedure kUp;
      Procedure kDn;
      Function GetVal:Word;
      Function Run:Word;
      Function RunKbd:Word;
      Destructor Done;
      PRIVATE
      W:Wins;
      Y:Byte;
     End;

     MultiInput = Object
      Constructor InitXY(X1,Y,X2:Byte);
      Procedure AddDescr(Msg:PChar;Var Buffer:PChar;MaxLen:Word);
      Procedure Ln;
      Procedure SetOrder;
      Procedure Refresh;
      Function Run(Var P:Word):Word;
      Destructor Done;
      PRIVATE
      Order:Bool;
      List:MultiInputPtr;
      RX1,RY,RX2:Byte;
     End;

     SelectFile = Object(Wins)
      Constructor Init(Title:String);
      Constructor InitXY(X,Y:Byte;Title:String);
      Function Run(Path:PathStr):PathStr;
      Destructor Done;
      PRIVATE
      Bank:BankFiles;
      P:Word;
      _Y:Byte;
      Procedure ChgPath(Var Path:PathStr);
      Procedure PutListAt(_P:Word);
      Procedure PutInput(Path:PathStr);
      Procedure PutItem;
      Procedure PutBar;
     End;

     SwitchOption = Object
      Constructor Init(X,Y:Byte;Name,Option:String;YP:Byte);
      Function Select:Word;
      Function GetPos:Byte;
      Destructor Done;
      PRIVATE
      L,P,_X_,_Y_,_X1,_Y1,_X2,_Y2:Byte;
      Title:String;
     End;

     SelectPrnOutput = Object
      Constructor Init(Default,X1,Y1,X2,Y2:Byte);
      Procedure PutSmallShade;
      Function Run:Word;
      Function GetPrnOut:Word;
      Destructor Done;
      PRIVATE
      M:LstMnu;
     End;

Var

    CurrColors:MatrixColors;
    ComInInput:Bool;

Procedure DialogMsgOk(Msg:String);
Procedure ErrorMsgOk(Msg:String);
Procedure MemInfo;
Procedure SetBlinkEnv;
Procedure SetPrnOutput;
Procedure WarningMsgOk(Msg:String);
Procedure __CreateError(FileName:PathStr);
Procedure __DirectoryFull;
Procedure __DiskFull;
Procedure __FileAccessDenied;
Procedure __FileNotFound(FileName:PathStr);
Procedure __HardDiskPark;
Procedure __OutOfMemory;
Procedure __PathNotFound;
Procedure __TooManyOpenFiles;
Procedure __UnknownCompress;

Function ErrorMsg(Msg:String;Key:Byte):Word;
Function Input(X1,Y,X2:Byte;MaxLen:Word;Var Str:PChar):Word;
Function InputMsg(Title,Msg:String;Key:Byte;Kr:MtxInputColors):Word;
Function OpenWin(Path:PathStr;Title:String):PathStr;
Function SelectBaseType(X1,Y1,X2,Y2:Byte;Title:String;Kr:MtxColors):Byte;
Function WarningMsg(Msg:String;Key:Byte):Word;
Function WarningMsgYesNo(Msg:String):Word;
Function WinInp(L:Byte;Title,Msg:String;Kr:MtxColors;Var Output:String):Word;
Function WinInpNmWord(L:Byte;Title,Msg:String;Kr:MtxColors;Min,Max:Word;Var Num:Word):Word;
Function __DiskNotReady(Disk:Byte):Word;
Function __InputExit(Msg:String):Bool;
Function __InputOverwriteFile:Bool;

IMPLEMENTATION

Uses Keyboard,Systems,Strings,Strs,Images,Mouse,Sound,CardVideo,
      Printers,TeleMate,Terminal,Memorys;

Constructor ButtonMnu.LoadAll;
Var I,J:Int; Buf:BlockButton; Handle,XR,YR,GY1:Word;
Begin
 If(IsGraf)Then
 Begin
  QX := X; QY := Y; Direction := Hori; FileName := Name;
  Handle := Systems.Open(Name,Systems.ReadOnly);
  If(Systems.IsHandleErr(Handle))Then Exit;
  NB := Systems.FileSize(Handle) div SizeOf(Buf);
  For I := 0 to NB - 1 do
  Begin
   Systems.GetRec(Handle,I,SizeOf(Buf),Buf);
   XR := X + (I * 4); YR := Y;
   If(XR > GetNumXTexts)Then
   Begin
    Case GetHeightChar of
     16 : Inc(YR,(XR div GetNumXTexts) * 2);
     Else Inc(YR,(XR div GetNumXTexts) * 4);
    End;
    XR := XR mod GetNumXTexts;
   End;
   GY1 := YR*GetHeightChar;
   PutSmlImg(XR*8,GY1,(XR+4)*8-1,GY1+31,Buf.Data[0,0]);
   If(DegradSupport)and(Buf.Data[1,0] = 9)Then For J := 0 to 3 do
   Begin
    PutLine(XR*8+J,GY1+J,XR*8+J,GY1+31-J,48+(J shl 2));
    PutLine(XR*8+31-J,GY1+J,XR*8+31-J,GY1+31-J,252+J);
    PutLineHori(XR*8+J,GY1+J,XR*8+31-J,48+(J shl 2));
    PutLineHori(XR*8+J,GY1+31-J,XR*8+31-J,252+J);
   End;
  End;
  Close(Handle);
 End;
End;

Constructor ButtonMnu.LoadAllVert;
Var I:Int; Buf:BlockButton; Handle,XR,YR,GY1:Word;
Begin
 If(IsGraf)Then
 Begin
  QX := X; QY := Y; Direction := Vert; FileName := Name; NB := 0;
  QPerLine := PerLine; Handle := Systems.Open(Name,Systems.ReadOnly);
  If(Systems.IsHandleErr(Handle))Then Exit;
  NB := Systems.FileSize(Handle) div SizeOf(Buf);
  For I := 0 to NB - 1 do
  Begin
   Systems.GetRec(Handle,I,SizeOf(Buf),Buf);
   XR := X + ((I mod PerLine) * 4);
   Case GetHeightChar of
    16 : YR := Y + (I div PerLine) * 2;
    Else YR := Y + (I div PerLine) * 4;
   End;
   If(XR > GetNumXTexts)Then
   Begin
    Case GetHeightChar of
     16 : Inc(YR,(XR div GetNumXTexts) * 2);
     Else Inc(YR,(XR div GetNumXTexts) * 4);
    End;
    XR := XR mod GetNumXTexts;
   End;
   GY1 := (YR*GetHeightChar);
   PutSmlImg(XR*8,GY1,(XR+4)*8-1,GY1+31,Buf.Data[0,0]);
  End;
  Close(Handle);
 End;
End;

Function ButtonMnu.UseXTexts;
Begin
 If(IsGraf)Then
 Begin
  If(Direction = Hori)Then UseXTexts := (NB * 4) mod GetNumXTexts
	              Else UseXTexts := ((NB div QPerLine) * 4) mod GetNumXTexts
 End
  Else
 UseXTexts := 0;
End;

Function ButtonMnu.UseYTexts;
Var Y:Byte;
Begin
 If(IsGraf)Then
 Begin
  If(GetHeightChar = 16)Then Y := Byte(NB > 0) * 2
		        Else Y := Byte(NB > 0) * 4;
  If(Direction = Vert)Then Y := Y * (NB div QPerLine);
  UseYTexts := Y;
 End
  else
 UseYTexts := 0;
End;

Function ButtonMnu.GetBut;
Var _Y : Byte;
Begin
 GetBut := $FFFF;
 If Not(IsGraf)Then Exit;
 If(Direction = Hori)Then
 Begin
  If(Y >= QY)and(Y <= QY+UseYTexts)and(X >= QX)and(X <= QX+UseXTexts)Then
  Begin
   GetBut := (X - QX) shr 2;
  End;
 End
  Else
 Begin
  If(Y >= QY)and(Y <= QY+UseYTexts)and(X >= QX)and(X <= QX+UseXTexts)Then
  Begin
   If(GetHeightChar = 16)Then _Y := Byte(NB > 0) * 2
		         Else _Y := Byte(NB > 0) * 4;
   GetBut := ((X - QX) shr 2) + (QPerLine * ((Y - QY) div _Y));
  End;
 End;
End;

Destructor ButtonMnu.Done;
Begin
End;

Constructor LineImage.Init;
Begin
 Size := 0; Buffer := NIL;
End;

Function LineImage.Push;
Begin
 Push := False; PX1 := X1; PY := Y; PX2 := X2; Size := (X2 - X1 + 1) shl 1;
 Buffer := MemAlloc(Size);
 If(Buffer = NIL)Then Exit;
 Copy;
 Push := True;
End;

Procedure LineImage.Copy;
Begin
 If(IsGraf)Then
  Move(MainData^.TBuffer^[(PY*GetNumXTexts)+PX1],Buffer^,(PX2-PX1+1) shl 1)
  Else
 CopyBox(PX1,PY,PX2,PY,Buffer^);
End;

Procedure LineImage.Put;
Var TCBuffer : ^TTextCube Absolute Buffer;
    I        : Byte;
Begin
 If(IVid.Graf)Then
 Begin
  For I := PX1 to PX2 do
   SetCube(I,PY,TCBuffer^[I-PX1].Chr,TCBuffer^[I-PX1].Attr);
 End
  Else
 PutBox(PX1,PY,PX2,PY,Buffer^);
End;

Procedure LineImage.ReSave;
Begin
 If(Buffer <> NIL)Then
 Begin
  Put;
  If Not(PX2-PX1 = X2-X2)Then
  Begin
   If(Buffer <> NIL)Then FreeMem(Buffer,Size);
   Buffer := NIL;
   Size   := 0;
   Push(X1,Y,X2);
  End
   Else
  Begin
   PX1 := X1; PY := Y; PX2 := X2;
   Copy;
  End;
 End
  Else
 Push(X1,Y,X2);
End;

Procedure LineImage.BarSelect;
Begin
 BarSelHor(PX1,PY,PX2,Color);
End;

Procedure LineImage._Pop;
Begin
 If(Buffer <> NIL)Then
 Begin
  Put;
  FreeMem(Buffer,Size);
 End;
 Buffer := NIL;
 Size   := 0;
End;

Destructor LineImage.Pop;
Begin
 _Pop;
End;

Constructor LstMnu.Init;
Begin
 RBuf.Init;
 W.Init(X1,Y1,X2,Y2);
 W.PushWn;
 W.PutWn(Title,Kr);
 W.PutBarMsRight;
 Y := 0; P := 0;
End;

Constructor LstMnu._QInit;
Begin
 RBuf.Init;
 If(IVid.Graf)and(WinType = Robotic)Then Inc(X2);
 W.Init(X1,Y1,X2,Y2);
 W.PutWn(Title,Kr);
 Y := 0; P := 0;
End;

Constructor LstMnu.InitCenter;
Var X1,Y1,X2,Y2 : Byte;
Begin
 Video.GetCenterText(L,H,X1,Y1,X2,Y2);
 Init(X1,Y1,X2,Y2,Title,Kr);
End;

Constructor LstMnu.QInit;
Begin
 RBuf.Init;
 W.Init(X1,Y1,X2,Y2);
 Y := 0; P := 0;
End;

Procedure LstMnu.PutSmallShade;
Begin
 W.PutSmallBorder;
End;

Procedure LstMnu.SetEndBar;
Begin
 W.SetEndBar(Attr);
End;

Procedure LstMnu.PutEndBar;
Begin
 W.SetEndBarTxtX(X,Msg,Attr);
End;

Procedure LstMnu.Refresh;
Var J         : Word;
    PCharByte : ^PCharByteRec;
Begin
 W.PutWn(W.RTitle,W.XColrs);
 If(MaxBuf > W.MaxYTxts)Then W.PutBarMsRight;
 W.SetPos(0,0);
 For J := P-Y to P-Y+W.MaxYTxts do
 Begin
  If(J > MaxBuf)Then Break;
  PCharByte := _GetBuf(J);
  If(PCharByte = NIL)Then Break;
  W.SetKrBorder;
  W.PutPTxtLn(PCharByte^.PChr);
 End;
End;

Procedure LstMnu.PutBarMouseRight;
Begin
 W.PutBarMsRight;
End;

Procedure LstMnu.PutDataHome;
Var J         : Byte;
    Size      : Word;
    PCharByte : ^PCharByteRec;
    PChr      : PChar Absolute PCharByte;
Begin
 If(MaxBuf > W.MaxYTxts)Then W.PutBarMsRight;
 For J := 0 to W.MaxYTxts do
 Begin
  PCharByte := GetBuf(J,Size);
  If(PCharByte = NIL)Then Break;
  W.SetKrBorder;
  Case Size of
     SizeOf(StrWordRec),SizeOf(StrByteRec),SizeOf(PCharWordRec),
   SizeOf(PCharByteRec) : W.PutPTxtLn(PCharByte^.PChr);
		     Else W.PutPTxtLn(PChr);
  End;
 End;
End;

Procedure LstMnu.SelBar;
Begin
 With W do
 Begin
  SetKrSel;
  BarSelHor(0,Y,wnMax);
 End;
End;

Procedure LstMnu.SelBarInactive;
Begin
 With W do
 Begin
  SetKr($8F);
  BarSelHor(0,Y,wnMax);
 End;
End;

Procedure LstMnu.UnSelBar;
Begin
 With W do
 Begin
  SetKrBorder;
  BarSelHor(0,Y,wnMax);
 End;
End;

Procedure LstMnu.kUp;
Var PCharByte : ^PCharByteRec;
Begin
 If(P > 0)Then
 Begin
  Dec(P);
  If(Y > 0)Then
  Begin
   UnSelBar;
   Dec(Y);
   SelBar;
  End
   else
  Begin
   UnSelBar;
   W._ScrollUp;
   PCharByte := _GetBuf(P);
   W.PutPTxt(PCharByte^.PChr);
   W.ClrEol;
   W.Ln;
   SelBar;
  End;
 End;
End;

Procedure LstMnu.kDn;
Var PCharByte : ^PCharByteRec;
Begin
 If(P < MaxBuf)Then
 Begin
  Inc(P);
  If(Y < W.MaxYTxts)Then
  Begin
   UnSelBar;
   Inc(Y);
   SelBar;
  End
   Else
  Begin
   UnSelBar;
   W._ScrollDn;
   PCharByte := _GetBuf(P);
   W.PutPTxt(PCharByte^.PChr);
   W.ClrEol;
   W.Ln;
   SelBar;
  End;
 End;
End;

Function LstMnu.GetVal;
Type PtrRec = Record Case Byte of
	       0:(PCharByte:PCharByteRec);
	       1:(PCharWord:PCharWordRec);
	       2:(StrByte:StrByteRec);
	       3:(StrWord:StrWordRec);
	      End;
Var Size : Word;
    Ptr  : ^PtrRec;
Begin
 GetVal := 0;
 If(P >= RBuf.NmBuf)Then Exit;
 Ptr := RBuf.GetBuf(P,Size);
 If(Ptr = NIL)Then Exit;
 Case Size of
    SizeOf(StrByteRec) : GetVal := Ptr^.StrByte.Nm;
    SizeOf(StrWordRec) : GetVal := Ptr^.StrWord.Nm;
  SizeOf(PCharByteRec) : GetVal := Ptr^.PCharByte.Nm;
  SizeOf(PCharWordRec) : GetVal := Ptr^.PCharWord.Nm;
		    Else GetVal := P;
 End;
End;

Function LstMnu.Run;
Var Ok:Bool; K:Word;
Begin
 Run := 0;
 With W do
 Begin
  PutDataHome;
  Ok := False;
  SelBar;
  Repeat
   K := ReadKey;
   Case K of
      kbInWn : If(Y <> (LastMsY - GetRY1))Then
	       Begin
		__HideMousePtr;
		UnSelBar;
		Dec(P,Y); Y := (LastMsY - GetRY1); Inc(P,Y);
		SelBar;
		__ShowMousePtr;
		Repeat Until (__GetMouseButton = 0);
		PushKey(kbEnter);
	       End;
kbRightBarMsUp:Begin
		__HideMousePtr;
		kUp;
		DelayMsPress(100);
		__ShowMousePtr;
	       End;
kbRightBarMsDn:Begin
		__HideMousePtr;
		kDn;
		DelayMsPress(100);
		__ShowMousePtr;
	       End;
	kbUp : kUp;
      kbDown : kDn;
       kbEsc : Ok := True;
     kbEnter : Begin
		Ok  := True;
		Run := GetVal;
	       End;
   End;
  Until Ok;
 End;
End;

Function LstMnu.RunKbd;
Var Ok : Boolean;
    K  : Word;
Begin
 RunKbd := 0;
 With W do
 Begin
  Refresh;
  Ok := False;
  SelBar;
  Repeat
   K := ReadKey;
   Case K of
      kbInWn : If(Y <> (LastMsY - GetRY1))Then
	       Begin
		__HideMousePtr;
		UnSelBar;
		P := P - Y;
		Y := (LastMsY - GetRY1);
		P := P + Y;
		SelBar;
		__ShowMousePtr;
		Repeat Until (__GetMouseButton = 0);
		PushKey(kbEnter);
	       End;
kbRightBarMsUp:Begin
		__HideMousePtr;
		kUp;
		DelayMsPress(100);
		__ShowMousePtr;
	       End;
kbRightBarMsDn:Begin
		__HideMousePtr;
		kDn;
		DelayMsPress(100);
		__ShowMousePtr;
	       End;
	kbUp : kUp;
      kbDown : kDn;
     kbEnter : Begin
		Ok     := True;
		RunKbd := GetVal;
	       End;
	  Else Begin
		Ok     := True;
		RunKbd := K;
	       End;
   End;
  Until Ok;
 End;
End;

Destructor LstMnu.Done;
Begin
 W.Done;
 RBuf.Done;
End;

Constructor MultiInput.InitXY;
Begin
 Order := False; RX1 := X1; RY := Y; RX2 := X2; List := NIL;
End;

Procedure MultiInput.AddDescr;
Var TMI : MultiInputPtr;
    BMI : MultiInputRec;
Begin
 Buffer := MemAlloc(MaxLen);
 If(Buffer = NIL)Then Exit;
 FillChar(Buffer[0],MaxLen-1,Byte(#0));
 BMI.X1 := RX1 + StrLength(Msg) + 2; BMI.Y := RY; BMI.X2 := RX2;
 BMI.MaxLen := MaxLen; BMI.Buffer := Buffer; BMI.Msg := Msg;
 BMI.Next := NIL; TMI := List;
 If Not(TMI = NIL)Then
 Begin
  While Not(TMI^.Next = NIL) do TMI := TMI^.Next;
  TMI^.Next := MemAlloc(SizeOf(List^));
  If(TMI^.Next = NIL)Then Exit;
  Move(BMI,TMI^.Next^,SizeOf(List^));
 End
  Else
 Begin
  TMI := MemAlloc(SizeOf(List^));
  If(TMI = NIL)Then Exit;
  List := TMI;
  Move(BMI,TMI^,SizeOf(List^));
 End;
 Ln;
 Ln;
End;

Procedure MultiInput.SetOrder;
Begin
 Order := True;
End;

Procedure MultiInput.Ln;
Begin
 Inc(RY);
End;

Procedure MultiInput.Refresh;
Var TMI     : MultiInputPtr;
    MaxL,TL : Word;
Begin
 TMI  := List;
 MaxL := 0;
 If(TMI = NIL)Then Exit;
 While Not(TMI = NIL) do
 Begin
  If(Order)Then
  Begin
   TL := StrLength(TMI^.Msg);
   If(MaxL < TL)Then MaxL := TL;
  End;
  TMI := TMI^.Next;
 End;
 If(Order)Then Inc(MaxL,2);
 TMI := List;
 While Not(TMI = NIL) do
 Begin
  PutPCharXY(RX1,TMI^.Y,TMI^.Msg,GetNorColor);
  If Not(Order)Then BarSpaceHoriShade(TMI^.X1,TMI^.Y,TMI^.X2,GetLastColor,
				      (GetAttr(TMI^.X2,TMI^.Y+1) and $F0) + $8)
	       Else BarSpaceHoriShade(RX1+MaxL,TMI^.Y,TMI^.X2,GetLastColor,
				      (GetAttr(TMI^.X2,TMI^.Y+1) and $F0) + $8);
  TMI := TMI^.Next;
 End;
End;

Function MultiInput.Run;
Var K,I,MaxP,MaxL,TL:Word; Ok:Bool; TMI:MultiInputPtr;
Begin
 Run := $FFFF; MaxP := 0; TMI := List; MaxL := 0;
 If(TMI = NIL)Then Exit;
 While Not(TMI = NIL) do
 Begin
  If(Order)Then
  Begin
   TL := StrLength(TMI^.Msg);
   If(MaxL < TL)Then MaxL := TL;
  End;
  Inc(MaxP); TMI := TMI^.Next;
 End;
 If(Order)Then Inc(MaxL,2);
 Dec(MaxP);
 Ok := False;
 Repeat
  TMI := List;
  If(P > 0)Then
  Begin
   For I := 1 to P do TMI := TMI^.Next;
  End;
  If Not(Order)Then
  Begin
   K := Input(TMI^.X1,TMI^.Y,TMI^.X2,TMI^.MaxLen-1,TMI^.Buffer);
   BarSelHor(TMI^.X1,TMI^.Y,TMI^.X2,GetLastColor);
  End
   Else
  Begin
   K := Input(RX1+MaxL,TMI^.Y,TMI^.X2,TMI^.MaxLen-1,TMI^.Buffer);
   BarSelHor(RX1+MaxL,TMI^.Y,TMI^.X2,GetLastColor);
  End;
  If(K = $FFFF)Then Exit;
  Case K of
	     kbUp : If(P = 0)Then P := MaxP else Dec(P);
   kbDown,kbEnter : If(P >= MaxP)Then P := 0 else Inc(P);
	    kbTab : If(P >= MaxP)Then Ok := True else Inc(P);
	       Else Ok := True;
  End;
 Until Ok;
 Run := K;
End;

Destructor MultiInput.Done;
Var TMI : MultiInputPtr;
Begin
 TMI := List;
 While Not(TMI = NIL) do
 Begin
  FreeMem(TMI,SizeOf(TMI^));
  TMI := TMI^.Next;
 End;
End;

Constructor SelectFile.Init;
Begin
 InitXY((Video.MaxXTxts-40) shr 1,(Video.MaxYTxts-15) shr 1,Title);
End;

Constructor SelectFile.InitXY;
Const L = 40; H = 15;
Var UpIcon:String; UpIconLen:Byte Absolute UpIcon;
Begin
 UpIcon := GetUpIcon^;
 Inherited Init(X,Y,X+L,Y+H);
 Inherited PushWn;
 Inherited PutWn(Title,CurrColors.OpenWin.Wins);
 Inherited SetKr(CurrColors.OpenWin.Env.Input);
 Inherited BarSelHor(0,1,25-UpIconLen);
 PutUpIcon(RX1+1+25-UpIconLen,RY1+1+1,CurrColors.OpenWin.Wins.Icon);
 Inherited ClrWn(0,3,11,3+7,CurrColors.OpenWin.Env.Input);
 Inherited ClrWn(13,3,13+11,3+7,CurrColors.OpenWin.Env.Input);
 Inherited ClrWn(0,H-3,L-2,H-2,CurrColors.OpenWin.Env.Input);
 Inherited PutkHor(27,1,12,'Correcte');
 Inherited PutkHor(27,3,12,'D‚part');
 Inherited PutkHor(27,5,12,'Principal');
 Inherited PutkHor(27,7,12,'Annule');
 Inherited SetKr(CurrColors.OpenWin.Env.Input);
 Bank.Init;
End;

Procedure SelectFile.PutListAt;
Var I:Word; X:SearchRec;
Begin
 For I := 0 to 7 do
 Begin
  If(_P+I > Bank.MaxFiles)Then
  Begin
   Inherited ClrWn(0,3+I,11,3+7,CurrColors.OpenWin.Env.Input);
   Inherited ClrWn(13,3,13+11,3+7,CurrColors.OpenWin.Env.Input);
   Exit;
  End;
  Bank.GetFile(_P+I,X);
  Case X.Attr of
   Directory : Inherited SetKr(CurrColors.OpenWin.Env.Dir);
	  else Inherited SetKr(CurrColors.OpenWin.Env.Input);
  End;
  Inherited PutTxtXY(0,3+I,SetFullName(X.Name));
 End;
 For I := 0 to 7 do
 Begin
  If(_P+I+8 > Bank.MaxFiles)Then
  Begin
   Inherited ClrWn(13,3+I,13+11,3+7,CurrColors.OpenWin.Env.Input);
   Exit;
  End;
  Bank.GetFile(_P+I+8,X);
  Case X.Attr of
   Directory : Inherited SetKr(CurrColors.OpenWin.Env.Dir);
	  else Inherited SetKr(CurrColors.OpenWin.Env.Input);
  End;
  Inherited PutTxtXY(13,3+I,SetFullName(X.Name));
 End;
End;

Procedure SelectFile.PutBar;
Var Info:SearchRec; T:DateTime;
Begin
 Inherited SetKr($0F);
 If(_Y <= 7)Then Inherited BarSelHor(0,3+_Y,11)
	    Else Inherited BarSelHor(13,3+_Y-8,24);
 Bank.GetFile(P+_Y,Info);
 Inherited SetKr(CurrColors.OpenWin.Env.Input);
 Inherited SetPos(0,MaxYTxts);
 Inherited PutTxt(SetFullName(Info.Name));
 If(Info.Attr = Dir)Then Inherited PutTxt(StrUSpc('<R‚p>',8))
		    Else Inherited PutTxt(Str2(Info.Size,8));
 UnpackTime(Info.Time,T);
 Inherited PutTxt(' '+Str2(T.Year,4)+'-'+Str0(T.Month,2)+'-'+Str0(T.Day,2));
 Inherited PutTxt(' '+Str2(T.Hour,2)+':'+Str0(T.Min,2));
End;

Procedure SelectFile.PutItem;
Var I:Word; X:SearchRec;
Begin
 If(_Y <= 7)Then
 Begin
  If(P + _Y <= Bank.MaxFiles)Then
  Begin
   Bank.GetFile(P+_Y,X);
   Case X.Attr of
    Dir : Inherited SetKr(CurrColors.OpenWin.Env.Dir);
     else Inherited SetKr(CurrColors.OpenWin.Env.Input);
   End;
   Inherited PutTxtXY(0,3+_Y,SetFullName(X.Name));
  End;
 End
  Else
 Begin
  If(P + _Y <= Bank.MaxFiles)Then
  Begin
   Bank.GetFile(P+_Y,X);
   Case X.Attr of
    Directory : Inherited SetKr(CurrColors.OpenWin.Env.Dir);
	   else Inherited SetKr(CurrColors.OpenWin.Env.Input);
   End;
   Inherited PutTxtXY(13,3+_Y-8,SetFullName(X.Name));
  End;
 End;
End;

Procedure SelectFile.ChgPath;
Begin
 P := 0; _Y := 0;
 If(Path = '')Then Bank.SelectPath('*.*',$FFFF-VolumeID)
  Else
 Begin
  Path := FileExpand(Path);
  Bank.SelectPath(Path,$FFFF-VolumeID);
 End;
 PutListAt(P);
 Video.PutTextXY(RX1+1,RY2-2,StrUSpc(Path,39),CurrColors.OpenWin.Env.Input);
 PutBar;
 PutInput(Path);
End;

Procedure SelectFile.PutInput;
Begin
 SetKr(CurrColors.OpenWin.Env.Input);
 PutTxtXY(0,1,Copy(StrUSpc(Path,24-Length(GetUpIcon^)),1,24-Length(GetUpIcon^)));
End;

Function SelectFile.Run;
Var K:Word; Ok:Bool; Box,KB:Byte; Buffer:Array[0..64] of Char;
    PBuffer:PChar; X:SearchRec; Start,T:PathStr; Yx:Byte;
Begin
 Run := ''; Start := Path; Box := 0; KB := 0;
 ChgPath(Path);
 Repeat
 Case Box of
  0 : Begin
       StrPCopy(Buffer,Path); PBuffer := Buffer;
       Inherited SetInpColrs(CurrColors.OpenWin.Env.Input,CurrColors.OpenWin.Env.Input);
       K := Inherited _Input(0,1,24-Length(GetUpIcon^),64,PBuffer);
       Case K of
      kbInWn : If((LastMsX >= GetRX1)and(LastMsY >= GetRY1 + 3)and
		  (LastMsX <= GetRX1+11)and(LastMsY <= GetRY1+10))or
		 ((LastMsX >= GetRX1+13)and(LastMsY >= GetRY1+3)and
		  (LastMsX <= GetRX1+24)and(LastMsY <= GetRY1+10))Then Box := 1;
kbDown,kbTab : Box := 1;
     kbEnter : Begin
		Path := StrPas(Buffer);
		If(Pos('*',Path) > 0)or(Pos('?',Path) > 0)Then ChgPath(Path)
		 Else
		Begin
		 If Not(Path[Length(Path)] = '\')Then IncStr(Path,'\');
		 If(DirExist(FileExpand(Path+'*.*')))Then ChgPath(Path)
		  Else
		 Begin
		  Dec(Byte(Path[0])); Run := Path;
		  Exit;
		 End;
		End;
	       End;
       kbEsc : Exit;
       End;
      End;
  1 : Repeat
       Ok := False; K := Inherited Readk;
       Case K of
   kbEsc : Exit;
  kbInWn : Begin
	    If((LastMsX >= GetRX1)and(LastMsY >= GetRY1 + 3)and
	       (LastMsX <= GetRX1+11)and(LastMsY <= GetRY1+10))Then
	    Begin
	     Yx := LastMsY - (GetRY1 + 3);
	     If((Yx + P) <= Bank.MaxFiles)Then
	     Begin
	      If(_Y <> Yx)Then
	      Begin
	       PutItem;
	       _Y := Yx;
	       PutBar;
	      End;
	     End;
	    End
	     Else
	    If((LastMsX >= GetRX1+13)and(LastMsY >= GetRY1+3)and
	       (LastMsX <= GetRX1+24)and(LastMsY <= GetRY1+10))Then
	    Begin
	     Yx := LastMsY - (GetRY1 + 3);
	     If((8 + Yx + P) <= Bank.MaxFiles)Then
	     Begin
	      If(_Y <> (8 + Yx))Then
	      Begin
	       PutItem;
	       _Y := (8 + Yx);
	       PutBar;
	      End;
	     End;
	    End
	     else
	    If(LastMsX >= GetRX1)and(LastMsY = GetRY1 + 1)and
	      (LastMsX <= GetRX1 + 24 - Length(GetUpIcon^))Then
	    Begin
	     Box := 0; Ok  := True;
	    End;
	   End;
 kbEnter : Begin
	    Bank.GetFile(P+_Y,X);
	    If((X.Attr and Directory) = Directory)Then
	    Begin
	     T := Path2NoDir(Path); Path := Path2Dir(Path) + X.Name;
	     If Not(Path[Length(Path)] = '\')Then IncStr(Path,'\');
	     AddStr(Path,T);
	     ChgPath(Path);
	    End
	     Else
	    Begin
	     Run := Path2Dir(Path) + X.Name;
	     Exit;
	    End;
	   End;
   kbTab : Begin
	    Box := 2; Ok := True;
	   End;
  kbLeft : Begin
	    PutItem;
	    If(_Y < 8)Then
	    Begin
	     If(P > 7)Then
	     Begin
	      Dec(P,8);
	      PutListAt(P);
	     End;
	    End
	     Else
	    Dec(_Y,8);
	    PutBar;
	   End;
 kbRight : Begin
	    PutItem;
	    If(_Y > 7)Then
	    Begin
	     If(P+16 < Bank.MaxFiles)Then
	     Begin
	      Inc(P,8);
	      PutListAt(P);
	     End;
	    End
	     Else
	    Begin
	     If(P + _Y + 8 <= Bank.MaxFiles)Then Inc(_Y,8);
	    End;
	    PutBar;
	   End;
    kbUp : Begin
	    PutItem;
	    If(_Y = 0)Then
	    Begin
	     If(P > 15)Then
	     Begin
	      _Y := 15;
	      Dec(P,16);
	      PutListAt(P);
	     End;
	    End
	     Else
	    Dec(_Y);
	    PutBar;
	   End;
  kbDown : Begin
	    PutItem;
	    If(_Y = 15)Then
	    Begin
	     If(P+16 <= Bank.MaxFiles)Then
	     Begin
	      _Y := 0;
	      Inc(P,16);
	      PutListAt(P);
	     End;
	    End
	     Else
	    If(P + _Y < Bank.MaxFiles)Then Inc(_Y);
	    PutBar;
	   End;
      Else Ok := True;
       End;
      Until Ok;
  2 : Begin
       SetKr(CurrColors.OpenWin.Wins.kSel);
       BarSelHor(27,1+KB*2,36);
       Repeat
	Ok := False; K := Inherited Readk;
	Case K of
	kbEsc : Exit;
      kbEnter : Begin
		 Case KB of
		   0 : Begin
			Bank.GetFile(P+_Y,X);
			If((X.Attr and Dir) = Dir)Then
			Begin
			 T := Path2NoDir(Path); Path := Path2Dir(Path) + X.Name;
			 If Not(Path[Length(Path)] = '\')Then IncStr(Path,'\');
			 AddStr(Path,T);
			 ChgPath(Path);
			End
			 Else
			Begin
			 Run := Path2Dir(Path) + X.Name;
			 Exit;
			End;
		       End;
		   1 : Begin
			Path := Start;
			ChgPath(Path);
			Box := 0; KB := 0; Ok := True;
		       End;
		   2 : Begin
			Path := Path2Drive(Path) + ':\' + Path2NoDir(Path);
			ChgPath(Path);
			Box := 0; KB := 0; Ok := True;
		       End;
		   3 : Exit;
		 End;
		End;
 kbDown,kbTab : Begin
		 SetKr(CurrColors.OpenWin.Wins.Key);
		 BarSelHor(27,1+KB*2,36);
		 If(KB = 3)Then
		 Begin
		  If(K = kbTab)Then
		  Begin
		   KB := 0; Box := 0; Ok := True;
		  End
		   Else
		  KB := 0;
		 End
		  Else
		 Inc(KB);
		 SetKr(CurrColors.OpenWin.Wins.kSel);
		 BarSelHor(27,1+KB*2,36);
		End;
	 kbUp : Begin
		 SetKr(CurrColors.OpenWin.Wins.Key);
		 BarSelHor(27,1+KB*2,36);
		 If(KB > 0)Then Dec(KB) Else KB := 3;
		 SetKr(CurrColors.OpenWin.Wins.kSel);
		 BarSelHor(27,1+KB*2,36);
		End;
	   Else Ok := True;
	End;
       Until Ok;
      End;
 End;
 Until False;
End;

Destructor SelectFile.Done;
Begin
 Bank.Done;
 Inherited Done;
End;

Constructor SelectPrnOutput.Init;
Begin
 With M do
 Begin
  _QInit(X1,Y1,X2,Y2,'Sortie Imprimante',CurrColors.Dialog.Wins);
  If Not(IsPlayMod)Then
  Begin
   If Not(GetModOutput in [sdLPT1,sdStereoLPT1_2,sdMonoLPT1_2,sdDisneySoundLPT1])Then
   Begin
    If(LPT1Exist)Then
    Begin
     AddPChrByte('LPT1:',prnLPT1);
     If(Default = prnLPT1)Then P := MaxBuf;
    End;
   End;
   If Not(GetModOutput in [sdLPT2,sdStereoLPT1_2,sdMonoLPT1_2,sdDisneySoundLPT2])Then
   Begin
    If(LPT2Exist)Then
    Begin
     AddPChrByte('LPT2:',prnLPT2);
     If(Default = prnLPT2)Then P := MaxBuf;
    End;
   End;
   If Not(GetModOutput in [sdLPT3,sdDisneySoundLPT3])Then
   Begin
    If(LPT3Exist)Then
    Begin
     AddPChrByte('LPT3:',prnLPT3);
     If(Default = prnLPT3)Then P := MaxBuf;
    End;
   End;
  End;
  If(LPT4Exist)Then
  Begin
   AddPChrByte('LPT4:',prnLPT4);
   If(Default = prnLPT4)Then P := MaxBuf;
  End;
  If(ComExist(1))Then
  Begin
   AddPChrByte('COM1:',prnCom1);
   If(Default = prnCOM1)Then P := MaxBuf;
  End;
  If(ComExist(2))Then
  Begin
   AddPChrByte('COM2:',prnCom2);
   If(Default = prnCOM2)Then P := MaxBuf;
  End;
  If(ComExist(3))Then
  Begin
   AddPChrByte('COM3:',prnCom3);
   If(Default = prnCOM3)Then P := MaxBuf;
  End;
  If(ComExist(4))Then
  Begin
   AddPChrByte('COM4:',prnCom4);
   If(Default = prnCOM4)Then P := MaxBuf;
  End;
  Refresh;
  SelBarInactive;
 End;
End;

Procedure SelectPrnOutput.PutSmallShade;
Begin
 M.PutSmallShade;
End;

Function SelectPrnOutput.Run;
Var K : Word;
Begin
 Run := 0;
 M.PutDataHome;
 M.SelBar;
 __ShowMousePtr;
 Repeat Until KeyPressed;
 __HideMousePtr;
 K := ReadKey;
 Case K of
	kbUp : Begin
		M.kUp;
		Run := $F000;
	       End;
      kbDown : Begin
		M.kDn;
		Run := $F000;
	       End;
     kbEnter : Run := M.GetVal;
	  Else Run := K;
 End;
 M.SelBarInactive;
End;

Function SelectPrnOutput.GetPrnOut;
Begin
 GetPrnOut := M.GetVal;
End;

Destructor SelectPrnOutput.Done;
Begin
 M.Done;
End;

Constructor SwitchOption.Init;
Var I,ML,LL : Byte; OldShade : Bool;
Begin
 P := YP; L := 0; ML := 0; LL := 0; _X_ := X; _Y_ := Y;
 For I := 1 to Length(Option) do
 Begin
  If(Option[I] = '|')Then
  Begin
   If(LL > ML)Then ML := LL;
   Inc(L); LL := 0;
  End
   Else
  Inc(LL);
 End;
 If(LL > ML)Then ML := LL;
 Inc(ML,2+5);
 SetBorderSimple;
 OldShade := GetShade;
 SetShade(False);
 _X1 := X; _Y1 := Y; _X2 := X + ML; _Y2 := Y + 2 + L;
 PutFillBorder(X,Y,_X2,_Y2,GetLastColor);
 SetBorderSimpleLuxe;
 SetShade(OldShade);
 Title := ' ' + Name + ' ';
 PutTextXY(X+1,Y,Title,GetNorColor);
 For I := 0 to L do PutTextXY(X+2,Y+1+I,GetUnSelectIcon^,GetLastColor);
 PutTextXY(X+2,Y+1+P,GetSelectIcon^,GetLastColor);
 PutTypingXY(X+6,Y+1,Option);
End;

Function SwitchOption.Select;
Var K  : Word;
    Ok : Boolean;
Begin
 SetBorderDouble;
 PutBorderUncolor(_X1,_Y1,_X2,_Y2);
 PutTextXY(_X1+1,_Y1,Title,GetNorColor);
 Repeat
  K := ReadKey; Ok := False;
  Case K of
      kbUp : Begin
	      PutTextXY(_X_+2,_Y_+1+P,GetUnSelectIcon^,GetLastColor);
	      If(P > 0)Then Dec(P) Else P := L;
	      PutTextXY(_X_+2,_Y_+1+P,GetSelectIcon^,GetLastColor);
	     End;
    kbDown : Begin
	      PutTextXY(_X_+2,_Y_+1+P,GetUnSelectIcon^,GetLastColor);
	      If(P < L)Then Inc(P) Else P := 0;
	      PutTextXY(_X_+2,_Y_+1+P,GetSelectIcon^,GetLastColor);
	     End;
	Else Ok := True;
  End;
 Until Ok;
 SetBorderSimple;
 PutBorderUncolor(_X1,_Y1,_X2,_Y2);
 PutTextXY(_X1+1,_Y1,Title,GetNorColor);
 SetBorderSimpleLuxe;
 Select := K;
End;

Function SwitchOption.GetPos;
Begin
 GetPos := P;
End;

Destructor SwitchOption.Done;
Begin
End;

Procedure DialogMsgOk;
Begin
 InputMsg('Remarque',Msg,Video.__Ok__,CurrColors.RemWin);
End;

Function ErrorMsg;
Begin
 ErrorMsg := InputMsg('Erreur',Msg,Key,CurrColors.ErrorWin.Wins);
End;

Procedure ErrorMsgOk;
Begin
 ErrorMsg(Msg,Video.__Ok__);
End;

Function Input;
Var P:PChar; LenPhr,K,WL,B:Word; XPos:Int;
    Ok:Bool; MX,MY : Byte; Chr:Char;

 Procedure PutPCharAtXY(X,Y:Byte;Str:PChar;Start,Len:Word;Color:Byte);
 Var I : Word;
 Begin
  For I := Start to Start + Len do
  Begin
   If(Str[I] = #0)Then Break;
   If(X+I-Start > X2)Then Break;
   SetCube(X+I-Start,Y,Str[I],Color);
  End;
 End;

 Procedure MoveRight;
 Var I : Byte;
 Begin
  For I := X2 downto X1+1 do SetChar(I,Y,GetChar(I-1,Y));
 End;

 Procedure MoveLeft;
 Var I : Byte;
 Begin
  For I := X1 to X2-1 do SetChar(I,Y,GetChar(I+1,Y));
 End;

 Procedure _MoveRight(X1,Y,X2:Byte);
 Var I : Byte;
 Begin
  For I := X2 downto X1+1 do SetChar(I,Y,GetChar(I-1,Y));
 End;

 Procedure _MoveLeft(X1,Y,X2:Byte);
 Var I : Byte;
 Begin
  For I := X1 to X2-1 do SetChar(I,Y,GetChar(I+1,Y));
 End;

 Procedure ClearBoard;
 Begin
  BarSpaceHori(X1,Y,X2,GetNorColor);
 End;

 Procedure ErrorBoard;
 Begin
  BarSelHor(X1,Y,X2,CurrColors.ErrorWin.Env.Input);
 End;

 Procedure NormalBoard;
 Begin
  _BarSelectHori(X1,Y,X2);
 End;

 Procedure AutoInsert;
 Begin
  If(GetModeIns)Then Cursor.SetCursor(GetheightChar shr 1,GetHeightChar-1)
		Else Cursor.SimpleCursor;
 End;

 Procedure EndKey;
 Begin
  If Not(LenPhr = 0)Then
  Begin
   If((X2-X1) < LenPhr)Then
   Begin
    WL := LenPhr; XPos := (X2-X1);
    PutPCharAtXY(X1,Y,P,WL-(X2-X1),X2-X1,GetNorColor);
    SetChar(X2,Y,' ');
   End
    Else
   Begin
    PutPCharAtXY(X1,Y,P,0,X2-X1,GetNorColor);
    WL := LenPhr; XPos := WL;
   End;
  End;
 End;

 Procedure PutBoard;
 Begin
  PutPCharAtXY(X1,Y,P,WL-XPos,X2-X1+1,GetNorColor);
  If(LenPhr < (WL-XPos + (X2-X1)))Then
   BarSpaceHori(X2-(((WL-XPos + (X2-X1))-LenPhr)),Y,X2,GetNorColor);
 End;

 Procedure HomeKey;
 Begin
  WL := 0; XPos := WL;
  PutPCharAtXY(X1,Y,P,0,X2-X1,GetNorColor);
  If(LenPhr < (X2-X1))Then BarSpaceHori(X1+LenPhr,Y,X2,GetNorColor);
 End;

 Function Init:Bool;
 Var I : Word; Chr : Array[0..1] of Char;
 Begin
  Init := False;
  ClearBoard;
  WL := 0; XPos := 0; P := MemAlloc(MaxLen);
  If(P = NIL)Then Exit;
  FillChar(P[0],MaxLen,Byte(#0));
  FillChar(Chr[0],2,Byte(#0));
  I := 0;
  While Not(Str[I] = #0) do
  Begin
   If(Str[I] > #31)Then
   Begin
    Chr[0] := Str[I]; StrCat(P,Chr);
   End;
   Inc(I);
  End;
  LenPhr := StrLen(P);
  If Not(LenPhr = 0)Then EndKey
		    else WL := 0;
  Init := True;
 End;

 Procedure Delete1;
 Begin
  StrDel(P,WL+1,1);
  Dec(LenPhr);
 End;

 Procedure CtrlLeftKey;
 Var Ok : Bool; I : Integer;
 Begin
  Ok := False; I := WL;
  Repeat
   Dec(I);
   If(I < 1)Then
   Begin
    HomeKey;
    Ok := True;
   End
    else
   If(P[I] in [#1..#41,'[',']'])Then
   Begin
    WL := I;
    If(WL < (X2-X1))Then XPos := WL;
    PutBoard;
    Ok := True;
   End
    else
   If(I > LenPhr)Then
   Begin
    EndKey;
    Ok := True;
   End;
  Until Ok;
 End;

 Procedure CtrlRightKey;
 Var Ok : Bool; I : Integer;
 Begin
  If(WL > LenPhr)Then EndKey;
  Ok := False; I := WL;
  If(I < 0)Then
  Begin
   HomeKey;
   Ok := True;
  End
   else
  Repeat
   Inc(I);
   If(P[I] in [#1..#41,'[',']'])Then
   Begin
    WL := I;
    If(WL < (X2-X1))Then XPos := WL;
    PutBoard;
    Ok := True;
   End
    else
   If(I > LenPhr)Then
   Begin
    EndKey;
    Ok := True;
   End;
  Until Ok;
  If(WL > LenPhr)Then WL := LenPhr;
 End;

 Procedure DeleteLineKey;
 Begin
  ClearBoard;
  P[0] := #0; LenPhr := 0; XPos := 0; WL := 0;
 End;

 Procedure BackSpaceKey;
 Begin
  If(LenPhr > 1)Then
  Begin
   If(WL > 0)Then
   Begin
    Dec(WL);
    StrDel(P,WL,1);
    If(XPos > 0)Then Dec(XPos);
    Dec(LenPhr);
    PutBoard;
   End;
  End
   else
  If(LenPhr = 1)Then DeleteLineKey
   Else
  Begin
   ErrorBoard;
   Beep;
   NormalBoard;
  End;
 End;

 Procedure DeleteKey;
 Begin
  If(LenPhr > 1)Then
  Begin
   If(LenPhr >= WL)Then
   Begin
    StrDel(P,WL,1);
    Dec(LenPhr);
    PutBoard;
   End;
  End
   else
  If(LenPhr = 1)Then DeleteLineKey
   Else
  Begin
   ErrorBoard;
   Beep;
   NormalBoard;
  End;
 End;

 Procedure DeleteEOLKey;
 Begin
  P[WL] := #0; LenPhr := WL;
  BarSpaceHori(X1+XPos,Y,X2,GetNorColor);
 End;

 Procedure DeleteWordKey;
 Var OldLen : Word;
     Ok     : Boolean;
 Begin
  If(WL+1 > LenPhr)Then
  Begin
   Ok := False; OldLen := LenPhr;
   Repeat
    If(P[WL+1] in [' ','A'..'Z','a'..'z'])and(WL+1<LenPhr)Then Delete1
							  Else Ok := True;
    If(WL >= LenPhr)Then Ok := True;
   Until Ok;
   If(OldLen = LenPhr)Then Delete1;
  End;
  ClearBoard;
  _PutPCharXY(X1,Y,P);
 End;

 Procedure LeftKey;
 Begin
  If(WL > 0)Then
  Begin
   Dec(WL);
   If(XPos = 0)Then
   Begin
    MoveRight;
    SetChar(X1,Y,P[WL]);
   End
    Else
   Dec(XPos);
  End
   else
  Begin
   ErrorBoard;
   Beep;
   NormalBoard;
  End;
 End;

 Procedure RightKey;
 Begin
  If(WL < LenPhr)Then
  Begin
   Inc(WL);
   If(XPos = (X2-X1))Then
   Begin
    MoveLeft;
    SetChar(X1+XPos,Y,P[WL]);
   End
    Else
   Inc(XPos);
  End
   else
  Begin
   ErrorBoard;
   Beep;
   NormalBoard;
  End;
 End;

 Procedure InsertChar;
 Var J2 : Word;
 Begin
  If(MaxLen > LenPhr)Then
  Begin
   If(GetModeIns)Then
   Begin
    If(WL < LenPhr)Then
    Begin
     If(WL = 0)Then
     Begin
      For J2 := LenPhr-1 downto 0 do P[J2+1] := P[J2];
      P[0] := Char(Lo(K)); WL := 1; Inc(LenPhr);
      If(XPos < (X2-X1))Then Inc(XPos);
      PutBoard;
     End
      Else
     Begin
      For J2 := LenPhr-1 downto WL do P[J2+1] := P[J2];
      P[WL] := Char(Lo(K)); P[LenPhr+1] := #0; Inc(LenPhr); Inc(WL);
      If(XPos < (X2-X1))Then Inc(XPos);
      PutBoard;
     End;
    End
     else
    Begin
     P[WL] := Char(Lo(K)); P[LenPhr+1] := #0;
     If(XPos = (X2-X1))Then
     Begin
      MoveLeft;
      SetChar(X1+XPos-1,Y,P[WL]);
     End
      Else
     Begin
      SetChar(X1+XPos,Y,P[WL]);
      Inc(XPos);
     End;
     Inc(WL); Inc(LenPhr);
    End;
   End
    else
   Begin
    If(LenPhr = 0)Then
    Begin
     P[0] := Char(Lo(K)); P[1] := #0; XPos := 1; WL := 1; LenPhr := 1;
     SetCube(X1,Y,P[0],GetNorColor);
    End
     else
    Begin
     P[WL] := Char(Lo(K));
     If(WL >= LenPhr)Then P[WL+1] := #0;
     If(XPos < (X2-X1))Then Inc(XPos);
     Inc(WL); Inc(LenPhr);
     PutBoard;
    End;
   End;
  End;
 End;

Begin
 Input := $FFFF;
 If Not(Init)Then Exit;
 AutoInsert;
 Repeat
  Ok := False;
  If(ComInInput)and(AsyncReceive(Chr))Then
  Begin
   Case Byte(Chr) of
    BS : K := kbBS;
    CR : K := kbEnter;
   ESC : K := kbEsc;
    Else K := Byte(Chr);
   End;
   Ok := True;
   Break;
  End;
  SetCursorPos(X1+XPos,Y);
  If(ModeInfVid.Graf)Then
  Begin
   PushCursor;
   __ShowMousePtr;
   _InitKbd;
   Repeat
    AnimateCursor;
    _BackKbd;
    __GetMouseTextSwitch(MX,MY,B);
    If(B > 0)Then
    Begin
     If((MY = Y)and(MX >= X1)and(MX <= X2))Then
     Begin
      If(LenPhr < MX - X1)Then
      Begin
       __HideMousePtr;
       ErrorBoard;
       Beep;
       NormalBoard;
       __ShowMousePtr;
      End
       Else
      Begin
       XPos := MX - X1;
       SetCursorPos(X1+XPos,Y);
      End;
     End
      Else
     Begin
      __HideMousePtr;
      CloseCursor;
      PopCursor;
      Input := kbMouse;
      Exit;
     End;
    End;
   Until Keypressed;
   __HideMousePtr;
   PopCursor;
  End
   Else
  Begin
   __ShowMousePtr;
   _InitKbd;
   Repeat
    _BackKbd;
    __GetMouseTextSwitch(MX,MY,B);
    If(B > 0)Then
    Begin
     If((MY = Y)and(MX >= X1)and(MX <= X2))Then
     Begin
      If(LenPhr < MX - X1)Then
      Begin
       __HideMousePtr;
       ErrorBoard;
       Beep;
       NormalBoard;
       __ShowMousePtr;
      End
       Else
      Begin
       XPos := MX - X1;
       SetCursorPos(X1+XPos,Y);
      End;
     End
      Else
     Begin
      __HideMousePtr;
      CloseCursor;
      Input := kbMouse;
      Exit;
     End;
    End;
   Until Keypressed;
   __HideMousePtr;
  End;
  If Not(Ok)Then K := ReadKey;
  Ok := False;
  Case K of
	kbHome : HomeKey;
	kbLeft : LeftKey;
       kbRight : RightKey;
	 kbEnd : EndKey;
	 kbIns : AutoInsert;
	 kbDel : DeleteKey;
    kbCtrlLeft : CtrlLeftKey;
   kbCtrlRight : CtrlRightKey;
	kbBack : BackSpaceKey;
	    else Begin
		  If(Char(Lo(K)) in [#32..#126,#128..#255])Then InsertChar
		   Else
		  Begin
		   Move(P[0],Str[0],LenPhr+1);
		   FreeMem(P,MaxLen);
		   Ok := True;
		  End;
		 End;
  End;
 Until Ok;
 CloseCursor;
 Input := K;
End;

Function InputMsg;
Var W:Wins; L,H,N,I:Byte; K:Word; StrKey:String; Buffer:Array[0..7] of Byte;
    MColors:MtxColors;
Begin
 L := (Key2Str(Key,StrKey) * 12) + 4;
 If(L < 40)and(Length(Msg) > 40)Then L := 40 else
 If(L < 20)and(Length(Msg) > 20)Then L := 20;
 If(Video.MaxXTxts > 40)Then If(Length(Msg) > 40)Then L := 50;
 H := 2 + GetNumLineMsg(0,L,Msg) + 2 + 1;
 N := 0;
 For I := 0 to 7 do
 Begin
  If(((Key shr I) and 1) = 1)Then
  Begin
   Buffer[I] := N;
   Inc(N);
  End
   else
  Buffer[I] := 16;
 End;
 W.InitO(L,H);
 SetBorderLuxe;
 W.PushWn;
 MColors.Title := Kr.Title; MColors.Border := Kr.Border;
 MColors.Key := Kr.KeyUnactif; MColors.kShade := Kr.KeyShade;
 MColors.kSel := Kr.KeyActif;
 W.PutWn(Title,MColors);
 W.SetY(1);
 W.SetKr(Kr.Msg);
 W.PutMsg(Msg);
 K := W.GetkHorDn(StrKey);
 W.Done;
 If(K < 8)Then
 Begin
  I := 0;
  While Not(Buffer[I] = K) do Inc(I);
  Case KeyStrc[I] of
   kbTitle : InputMsg := kbF1;
   kbClose : InputMsg := kbEsc;
	else InputMsg := KeyStrc[I];
  End;
 End
  else
 Case K of
  kbTitle : InputMsg := kbF1;
  kbClose : InputMsg := kbEsc;
       else InputMsg := K;
 End;
End;

Procedure MemInfo;
Var W : Wins; k:String;
Begin
 Key2Str(KeyOk,k);
 With W do
 Begin
  InitO(50,13);
  PushWn;
  PutWn('Status m‚moire',CurrColors.Dialog.Wins);
  Ln;
  If(VSwpInit)and(VSwp[__Disk].Exist)Then
  Begin
   PutTxtLn('Nom du fichier m‚moire disque : ' + Path2NoDir(PathDiskSwap));
   PutTxtLn('M‚moire disque total          : ' + Str2(VSwp[__Disk].GetSize,8) + ' octet(s)');
   PutTxtLn('M‚moire disque utilis‚        : ' + Str2(VSwp[__Disk].GetUsed,8) + ' octet(s)');
   PutTxtLn('M‚moire disque de libre       : ' + Str2(VSwp[__Disk].GetFree,8) + ' octet(s)');
  End;
  Ln;
  If(XmsExist)Then
   PutTxtLn('M‚moire XMS de libre          : ' + Str2(Long(QueryFreeMemXMS)*1024,8) + ' octet(s)');
  PutTxtLn('Total de m‚moire conventionel : ' + Str2(Long(MemW[_0040:$13])*1024,8) + ' octet(s)');
  PutTxtLn('M‚moire conventionel de libre : ' + Str2(MemAvail,8) + ' octet(s)');
  GetkHorDn(k);
  Done;
 End;
End;

Function OpenWin;
Var S:SelectFile;
Begin
 S.Init(Title);
 OpenWin := S.Run(Path);
 S.Done;
End;

Function SelectBaseType;
Const btNumber = 255;
Var M : LstMnu; C : Byte; Ok : Bool;

 Function SelNm:Byte;
 Var M : LstMnu;
 Begin
  With M do
  Begin
   Init(X1+4,Y1,X2-4,Y2,'Nombre',Kr);
   AddPChrByte('Naturel (0 … 255)',btByte);
   AddPChrByte('Naturel (0 … 65535)',btWord);
   AddPChrByte('Naturel (0 … 4294967295)',btLongWord);
   AddPChrByte('Entier (-128 … 127)',btShortInt);
   AddPChrByte('Entier (-32768 … 32767)',btInteger);
   AddPChrByte('Entier (-2147483648 … 2147483647)',btLongInt);
   AddPChrByte('Entier ((-9úEXP(63)10) … (9úEXP(63)10))',btComp);
   AddPChrByte('R‚el ((2,9úEXP(-39)10) … (1,7úEXP(38)10))',btReal);
   AddPChrByte('R‚el ((1,5úEXP(-45)10) … (3,4úEXP(38)10))',btSingle);
   AddPChrByte('R‚el ((5,0úEXP(-324)10) … (3,4úEXP(308)10))',btDouble);
   AddPChrByte('R‚el ((1,9úEXP(-4951)10) … (1,7úEXP(4932)10))',btExtended);
   SelNm := Run;
   Done;
  End;
 End;

Begin
 With M do
 Begin
  Init(X1,Y1,X2,Y2,Title,Kr);
  AddPChrByte('Logique (Vrai,Faux)',btBoolean);
  AddPChrByte('Nombre (Naturel, Entier, R‚el)',btNumber);
  AddPChrByte('Texte (0 … 65534 caractŠre(s))',btPChar);
  AddPChrByte('Date',btDate);
  AddPChrByte('Temps (date et l''heure)',btTime);
  AddPChrByte('Code postal (ex : H2B-2R3)',btZipCode);
  AddPChrByte('T‚l‚phone (ex: (514) 657-8934)',btPhone);
  AddPChrByte('Couleur (noir, bleu, vert, ...)',btColor);
  AddPChrByte('Prix (ex: $100,00; $199,94; ...)',btPrice);
  AddPChrByte('R‚pertoire (ex: C:\;C:\DOS,...)',btPath);
  AddPChrByte('Enum‚ration (ex : voiture, camion, sept, ...)',btEnum);
  Repeat
   Ok := True; C := Run;
   Case C of
    btNumber : Begin
		C := SelNm;
		If(C = 0)Then Ok := False;
	       End;
   End;
  Until Ok;
  SelectBaseType := C;
  Done;
 End;
End;

Procedure SetBlinkEnv;
Begin
 With CurrColors do
 Begin
  With Menu do
  Begin
   Normal := (Cyan shl 4) + White;
   High := (Cyan shl 4) + LightCyan;
   Select := (Magenta shl 4) + Yellow;
  End;
 End;
 With CurrColors.Dialog.Wins do
 Begin
  Title := (Cyan shl 4) + White;
  Border := (Green shl 4) + White;
  Icon := (Black shl 4) + White;
  Sel := (Magenta shl 4) + Yellow;
  Key := (Cyan shl 4) + White;
  kShade := (Green shl 4) + Black;
  kSel := (Cyan shl 4) + Yellow;
 End;
 With CurrColors.ErrorWin.Wins do
 Begin
  Border     := (Red shl 4) + White;
  Title      := (Cyan shl 4) + LightBlue;
  Msg        := (Red shl 4) + Yellow;
  KeyActif   := (Cyan shl 4) + Yellow;
  KeyUnactif := (Cyan shl 4) + White;
  KeyShade   := (Red shl 4) + Black;
 End;
 With CurrColors.WarningWin do
 Begin
  Border     := (Brown shl 4) + White;
  Title      := (Cyan shl 4) + LightBlue;
  Msg        := (Brown shl 4) + Black;
  KeyActif   := (Cyan shl 4) + Yellow;
  KeyUnactif := (Cyan shl 4) + White;
  KeyShade   := (Brown shl 4) + DarkGray
 End;
End;

Procedure SetPrnOutput;
Var M : LstMnu;
Begin
 PrnOutput := prnNUL;
 With M do
 Begin
  Init(16,8,MaxXTxts-16,MaxYTxts-8,'Sortie Imprimante',CurrColors.Dialog.Wins);
  If Not(IsPlayMod)Then
  Begin
   If Not(GetModOutput in [sdLPT1,sdStereoLPT1_2,sdMonoLPT1_2,sdDisneySoundLPT1])Then
   Begin
    If(LPT1Exist)Then AddPChrByte('LPT1:',prnLPT1);
   End;
   If Not(GetModOutput in [sdLPT2,sdStereoLPT1_2,sdMonoLPT1_2,sdDisneySoundLPT2])Then
   Begin
    If(LPT2Exist)Then AddPChrByte('LPT2:',prnLPT2);
   End;
   If Not(GetModOutput in [sdLPT3,sdDisneySoundLPT3])Then
   Begin
    If(LPT3Exist)Then AddPChrByte('LPT3:',prnLPT3);
   End;
  End;
  If(LPT4Exist)Then AddPChrByte('LPT4:',prnLPT4);
  If(ComExist(1))Then AddPChrByte('COM1:',prnCom1);
  If(ComExist(2))Then AddPChrByte('COM2:',prnCom2);
  If(ComExist(3))Then AddPChrByte('COM3:',prnCom3);
  If(ComExist(4))Then AddPChrByte('COM4:',prnCom4);
  If(IsEmpty)Then
  Begin
   Done;
   Exit;
  End;
  PrnOutput := Run;
  Done;
 End;
End;

Function WarningMsg;
Begin
 WarningMsg := InputMsg('Attention',Msg,Key,CurrColors.WarningWin);
End;

Function WarningMsgYesNo;
Begin
 WarningMsgYesNo := WarningMsg(Msg,Video.__Yes__ + Video.__No__);
End;

Procedure WarningMsgOk;
Begin
 WarningMsg(Msg,Video.__Ok__);
End;

Function WinInp;
Const Ok = 0; Cancel = 1; MaxBuffer = 255;
Var W:Wins; B:Array[0..MaxBuffer] of Char; S:String; K:Word; BP:PChar;
Begin
 WinInp := kbEsc;
 With W do
 Begin
  Key2Str(KeyOk+KeyCancel,S);
  InitO(L,7);
  PushWn;
  PutWn(Title,Kr);
  PutkHorDn(S);
  Ln;
  PutTxtLn(Msg);
  FillChar(B,SizeOf(B),Byte(#0));
  StrPCopy(B,Output);
  BP := B;
  Repeat
   K := Inp(BP,MaxBuffer);
   If(K = kbEsc)Then  Begin Done; Exit; End;
   K := GetkHorDn(S);
   If(K = Cancel)Then  Begin Done; Exit; End;
   If(K = Ok)Then K := kbEnter;
  Until (K = kbEnter);
  Output := StrPas(BP);
  Done;
 End;
 WinInp := kbEnter;
End;

Function WinInpNmWord;
Var K,N,Err:Word; I:Byte; S:String; Ok:Bool;
Begin
 WinInpNmWord := kbEsc;
 If(Num = 0)Then S := '' Else S := Str(Num);
 N := Num;
 Repeat
  Ok := True; K := WinInp(L,Title,Msg,Kr,S);
  If(K = kbEsc)Then Exit;
  For I := 1 to Length(S) do
  Begin
   If Not(S[I] in ['0'..'9'])Then
   Begin
    Ok := False;
    ErrorMsgOk('Nombre invalide!');
    Break;
   End;
  End;
  Val(S,N,Err);
  If(N < Min)or(N > Max)Then
  Begin
   Ok := False;
   ErrorMsgOk('Nombre en dehors de limite '+Str(Min)+' et '+Str(Max)+'!');
  End;
 Until Ok;
 Num := N; WinInpNmWord := kbEnter;
End;

Procedure __CreateError;
Begin
 ErrorMsgOk('Impossible de cr‚er le fichier : ' + FileName + '!');
End;

Procedure __DirectoryFull;
Begin
 ErrorMsgOk('R‚pertoire est plein.');
End;

Procedure __DiskFull;
Begin
 ErrorMsgOk('Disque plein.');
End;

Function __DiskNotReady;
Begin
 If(Disk = 0)Then Disk := GetDisk + 1;
 __DiskNotReady := ErrorMsg('Disque ' + Char(Disk + Byte('@')) +
 ': n''est pas prˆt! S.V.P. inser‚ une disquette dans le lecteur ' +
 Char(Disk+Byte('@'))+'.',Video.__Retry__ + Video.__Cancel__);
End;

Procedure __FileAccessDenied;
Begin
 ErrorMsgOk('AccŠs refus‚.');
End;

Procedure __FileNotFound;
Begin
 ErrorMsgOk('Fichier ' + FileName + ' introuvable!');
End;

Procedure __HardDiskPark;
Begin
 If(HardDiskPark)Then
 Begin
  DialogMsgOk('Disque(s) dur stationner avec succŠs. '+
	      'Vous pouvez maintenant fermer l''ordinateur ou '+
	      'continuer en pressant une touche.');
 End
  Else
 ErrorMsgOk('Disque dur introuvable !');
End;

Function __InputExit;
Begin
 __InputExit := (InputMsg('Attention',Msg,KeyYes+KeyNo,CurrColors.ErrorWin.Wins) = kbYes);
End;

Function __InputOverWriteFile;
Begin
 __InputOverWriteFile := (WarningMsgYesNo('Fichier existant! Je le remplace ?') = kbYes);
End;

Procedure __OutOfMemory;
Begin
 ErrorMsgOk('Manque de m‚moire');
End;

Procedure __PathNotFound;
Begin
 ErrorMsgOk('R‚pertoire introuvable.');
End;

Procedure __TooManyOpenFiles;
Begin
 ErrorMsgOk('Trop de fichier ouvert simultan‚ment.');
End;

Procedure __UnknownCompress;
Begin
 ErrorMsgOk('D‚sol‚! Technique de compression inconnue.');
End;

BEGIN
 ComInInput := False;
END.