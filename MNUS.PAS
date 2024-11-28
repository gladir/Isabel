(********************************************************)
(*                                                      *)
(*                  Malte Genesis/Menus                 *)
(*   Phoenix Edition for Real Mode & Protected Mode     *)
(*                   II - Version 1.8                   *)
(*                      1994/12/29                      *)
(*                                                      *)
(*      Copyiright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit Mnus;

INTERFACE

{$B-,E+,I-,N+,Q-,R-,S-,X+}

Uses Math,Mems;

Type

     PullMnuPtr    = ^PullMnuItem;
     PullSwitchPtr = ^PullSwitchItem;
     MainMenuPtr   = ^MainMenuRec;

     PullSwitchItem = TPChar;

     PullMnuItem = Record
      Option:PChar;
      HighChar:Char;
      KeyFunc,RtnCode:Word;
      SubMenu:Pointer;
      Switch:^Byte;
      PSwitch:PullSwitchPtr;
      Next:PullMnuPtr;
     End;

     MainMenuRec = Record
      Title:PChar;
      KeyCode:Word;
      List:PullMnuPtr;
      NumList:Word;
      P:Byte;
      NextMenu:MainMenuPtr;
     End;

     PullSubMnu = Object
      Constructor Init;
      Procedure AddFullItem(Option:PChar;KeyFunc,RtnCode:Word;SubMenu:Pointer);
      Procedure AddItemSwitch(Option:PChar;Var Value;Switch:PullSwitchPtr;RtnCode:Word);
      Procedure AddBarItem;
      Function Ptr:Pointer;
      Destructor Done;
      PRIVATE
      List:PullMnuPtr;
      NumList:Word;
     End;

     PullMnu = Object
      Constructor Init;
      Procedure AddMnu(Mnu:PChar);
      Procedure AddItem(Option:PChar;RtnCode:Word);
      Procedure AddItemKey(Option:PChar;KeyFunc,RtnCode:Word);
      Procedure AddFullItem(Option:PChar;KeyFunc,RtnCode:Word;SubMenu:Pointer);
      Procedure AddItemSwitch(Option:PChar;Var Value;Switch:PullSwitchPtr;RtnCode:Word);
      Procedure AddBarItem;
      Procedure PutMnuBar;
      Procedure GetMnuBar(X,Y:Byte);
      Procedure SetWinBar(X1,Y,X2:Byte);
      Function MnuPtr(Mnu:PChar):PullMnuPtr;
      Function ExecMnu(X,Y:Byte;List:PullMnuPtr;Var P:Byte):Word;
      Function WaitForMnuAction:Word;
      Destructor Done;
      PRIVATE
      RX1,RY,RX2:Byte;
      MainMenu:RBuf;
     End;

IMPLEMENTATION

Uses Systems,Keyboard,MLibrary,Strings,Strs,Video,Images,Windows,Dials,Mouse;

Constructor PullSubMnu.Init;
Begin
 List := NIL; NumList := 0;
End;

Procedure PullSubMnu.AddFullItem;
Var Chr:Char; TStr:String; TPull:PullMnuPtr; BPull:PullMnuItem;
Begin
 TStr := StrUp(SearchHigh(Option));
 If(TStr <> '')Then Chr := TStr[1];
 BPull.Option := Option; BPull.KeyFunc := KeyFunc; BPull.RtnCode := RtnCode;
 BPull.HighChar := Chr; BPull.SubMenu := SubMenu; BPull.Next := NIL;
 If(NumList = 0)Then
 Begin
  List := MemAlloc(SizeOf(List^));
  Move(BPull,List^,SizeOf(List^));
  NumList := 1;
 End
  Else
 Begin
  TPull := List;
  While Not(TPull^.Next = NIL) do TPull := TPull^.Next;
  TPull^.Next := MemAlloc(SizeOf(List^));
  Move(BPull,TPull^.Next^,SizeOf(List^));
  Inc(NumList);
 End;
End;

Procedure PullSubMnu.AddItemSwitch;
Var Chr:Char; TStr:String; TPull:PullMnuPtr; BPull:PullMnuItem;
Begin
 TStr := StrUp(SearchHigh(Option));
 If(TStr <> '')Then Chr := TStr[1];
 BPull.Option := Option; BPull.KeyFunc := 0; BPull.RtnCode := RtnCode;
 BPull.HighChar := Chr; BPull.SubMenu := NIL; BPull.Switch := @Value;
 BPull.PSwitch := Switch; BPull.Next := NIL;
 If(NumList = 0)Then
 Begin
  List := MemAlloc(SizeOf(List^));
  Move(BPull,List^,SizeOf(List^));
  NumList := 1;
 End
  Else
 Begin
  TPull := List;
  While Not(TPull^.Next = NIL) do TPull := TPull^.Next;
  TPull^.Next := MemAlloc(SizeOf(List^));
  Move(BPull,TPull^.Next^,SizeOf(List^));
  Inc(NumList);
 End;
End;

Procedure PullSubMnu.AddBarItem;
Var TPull:PullMnuPtr;
    BPull:PullMnuItem;
Begin
 BPull.Option := ''; BPull.KeyFunc := 0; BPull.RtnCode := 0;
 BPull.HighChar := #0; BPull.SubMenu := NIL; BPull.Next := NIL;
 If(NumList = 0)Then
 Begin
  List := MemAlloc(SizeOf(List^));
  Move(BPull,List^,SizeOf(List^));
  NumList := 1;
 End
  Else
 Begin
  TPull := List;
  While Not(TPull^.Next = NIL) do TPull := TPull^.Next;
  TPull^.Next := MemAlloc(SizeOf(List^));
  Move(BPull,TPull^.Next^,SizeOf(List^));
  Inc(NumList);
 End;
End;

Function PullSubMnu.Ptr;
Begin
 Ptr := List;
End;

Destructor PullSubMnu.Done;
Var TPull:PullMnuPtr;
Begin
 TPull := List;
 While Not(TPull = NIL) do
 Begin
  FreeMem(TPull,SizeOf(PullMnuItem));
  TPull := TPull^.Next;
 End;
End;

Procedure PullMnu.AddBarItem;
Begin
 AddFullItem('',kbNoKey,kbNoKey,NIL);
End;

Destructor PullMnu.Done;
Var TPull:PullMnuPtr; TMenu:MainMenuPtr; I:Int;
Begin
 For I := 0 to MainMenu.MaxBuf do
 Begin
  TMenu := MainMenu._GetBuf(I);
  TPull := TMenu^.List;
  While Not(TPull = NIL) do
  Begin
   FreeMem(TPull,SizeOf(TPull^));
   TPull := TPull^.Next;
  End;
 End;
 MainMenu.Done;
End;

Function PullMnu.ExecMnu;
Var Line:LineImage; Image:Wins; Actif:^TBoolean; K,IW,TL,J,Z:Word;
    X1,Y1,X2,Y2,XM,YM,L,I:Byte; Chr:Char; TList:PullMnuPtr; TStr:String;
    MX,MY,P1:Byte; BM:Word;

 Procedure PutBar;
 Begin
  Line.ReSave(X1+1,Y1+1+P,X2-1);
  Line.BarSelect(CurrColors.Menu.Select);
 End;

Begin
 ExecMnu := $FFFF;
 If(List = NIL)Then Exit;
 X1 := X; Y1 := Y;
 If(X1 > Video.MaxXTxts)Then
 Begin
  Inc(Y,(X1 div Video.GetNumXTexts));
  Y1 := Y; X := X mod Video.GetNumXTexts; X1 := X;
 End;
 L := 0; TList := List;
 While Not(TList = NIL) do
 Begin
  Inc(L); TList := TList^.Next;
 End;
 Actif := MemAlloc(L);
 If(Actif = NIL)Then Exit;
 TList := List; L := 0; XM := 0;
 While Not(TList = NIL) do
 Begin
  If(TList^.Option = NIL)or(TList^.Option^ = #0)Then Actif^[L] := False
   else
  Begin
   Actif^[L] := True; TL := LengthTyping(TList^.Option);
   If Not(TList^.KeyFunc = kbNoKey)Then Inc(TL,1+Length(KeyCode2Str(TList^.KeyFunc)));
   If(Not(TList^.Switch = NIL))and(TList^.PSwitch = NIL)and(TList^.Switch^ = 1)Then Inc(TL);
   If Not(TList^.SubMenu = NIL)Then Inc(TL);
   If(XM < TL)Then XM := TL;
  End;
  Inc(L); TList := TList^.Next;
 End;
 Inc(XM,3); YM := 1 + L; X2 := X + XM; Y2 := Y + YM;
 If(X1 = __Center__)Then
 Begin
  X1 := (GetNumXTexts-XM) shr 1; X2 := X1 + XM;
 End;
 If(Y1 = __Center__)Then
 Begin
  Y1 := (GetNumYTexts-YM) shr 1; Y2 := Y1 + YM;
 End;
 If(Y2 > Video.MaxYTxts)Then
 Begin
  For I := X to Video.MaxXTxts do If(GetChar(I,Y - 1) = '>')Then Break;
  X := I + 1; Y := Video.MaxYTxts - (YM + 1); X1 := X; Y1 := Y;
  X2 := X + XM; Y2 := Y + YM;
 End;
 If(X2 > Video.MaxXTxts)Then
 Begin
  X1 := Video.MaxXTxts - XM; X2 := Video.MaxXTxts;
 End;
 Image.Init(X1,Y1,X2+2,Y2+1);
 If(Image.PushWn)Then
 Begin
  If(IVid1^.Graf)Then
  Begin
   ClrWn(X1,Y1,X2,Y2,CurrColors.Menu.Normal);
   PutRect(X1*8,Y1*IVid.HeightChr,(X2*8)+7,(Y2+1)*IVid.HeightChr-1,CurrColors.Menu.Normal and $F);
   If(DegradSupport)Then
   Begin
    If((CurrColors.Menu.Normal and $F0) = $F0)and(IVid.HeightChr = 16)Then
    Begin
     For Z := 0 to 7 do
     Begin
      For J := Y1*IVid.HeightChr to (Y2+1)*IVid.HeightChr-1 do
      Begin
       SetPixel((X1*8)+Z,J,(Z shl 1)+32);
       SetPixel((X2*8)+Z,J,47-(Z shl 1));
      End;
     End;
     For J := 0 to 15 do
     Begin
      For Z := (X1*8)+(J shr 1) to ((X2+1)*8)-1-(J shr 1) do
      Begin
       SetPixel(Z,J+(Y1*IVid.HeightChr),J+32);
       SetPixel(Z,((Y2+1)*IVid.HeightChr)-1-J,J+32);
      End;
     End;
    End;
   End;
  End
   Else
  Begin
   SetBorderSimpleLuxe;
   PutFillBorder(X1,Y1,X2,Y2,CurrColors.Menu.Normal);
  End;
  SetAllColor(CurrColors.Menu.High,CurrColors.Menu.Normal);
  TList := List; IW := 1;
  While Not(TList = NIL) do
  Begin
   If(TList^.Option = NIL)or(TList^.Option^ = #0)Then
   Begin
    BarCharHori(X1+1,Y1+IW,X2-1,'Ä');
    If Not(((PVid1^.EGA)or(PVid1^.VGA)))Then
    Begin
     SetChar(X1,Y1+IW,'Ã');
     SetChar(X2,Y1+IW,'´');
    End;
   End
    Else
   Begin
    PutTypingXY(X1+2,Y1+IW,StrPas(TList^.Option));
    If Not(TList^.KeyFunc = kbNoKey)Then
    Begin
     TStr := KeyCode2Str(TList^.KeyFunc);
     PutTextXY(X2-Length(TStr),Y1+IW,TStr,CurrColors.Menu.High);
    End;
    If Not(TList^.Switch = NIL)Then
    Begin
     If(TList^.PSwitch = NIL)and(TList^.Switch^ = 1)Then SetChar(X2-1,Y1+IW,'û');
    End;
    If Not(TList^.SubMenu = NIL)Then SetChar(X2-1,Y1+IW,'>');
   End;
   Inc(IW); TList := TList^.Next;
  End;
  Line.Init;
  If(Line.Push(X1+1,Y1+1+P,X2-1))Then
  Begin
   Line.BarSelect(CurrColors.Menu.Select);
   _InitKbd;
   Repeat
     __ShowMousePtr;
     Repeat
      _BackKbd;
      __GetMouseTextSwitch(MX,MY,BM);
      If(BM > 0)Then
      Begin
(*       If(MY = RY)Then
       Begin
	{If(MX < X1)Then}
	Begin
	 ExecMnu := kbMouse;
	 __HideMousePtr;
	 Line.Pop;
	 Image.Done;
	 Exit;
	End;
       End;*)
       If(MX > X1)and(MX < X2)and(MY > Y1)and(MY < Y2)Then
       Begin
	P1 := MY - Y1 - 1;
	If(Actif^[P1])Then
	Begin
	 __HideMousePtr;
	 P := P1;
	 PutBar;
	 __ShowMousePtr;
	 Repeat Until (GetMouseButton = 0);
	 __HideMousePtr;
	 PushKey(kbEnter);
	End;
       End
	Else
       Begin
	ExecMnu := kbMouse;
	__HideMousePtr;
	Line.Pop;
	Image.Done;
	If(Actif <> NIL)Then FreeMem(Actif,L);
	Exit;
       End;
      End;
     Until KeyPressed;
     __HideMousePtr;
    K := ReadKey;
    Case K of
       kbUp : Begin
	       If(P > 0)Then
	       Begin
		Dec(P);
		If(P > 0)Then
		Begin
		 If Not(Actif^[P])Then Dec(P);
		End;
	       End
		Else
	       P := L-1;
	       PutBar;
	      End;
     kbDown : Begin
	       If(P < L-1)Then
	       Begin
		Inc(P);
		If Not(Actif^[P])Then Inc(P);
	       End
		Else
	       P := 0;
	       PutBar;
	      End;
     kbHome : If(P > 0)Then
	      Begin
	       P := 0;
	       PutBar;
	      End;
      kbEnd : If(P < (L-1))Then
	      Begin
	       P := L-1;
	       PutBar;
	      End;
    kbEnter : Begin
	       TList := List;
	       For I := 1 to P do TList := TList^.Next;
	       If Not(TList^.SubMenu = NIL)Then
	       Begin
		I := 0;
		K := ExecMnu(X1+1,Y1+2+P,TList^.SubMenu,I);
		If Not(K = kbEsc)Then Break;
	       End
		Else
	       Begin
		If(P = 0)Then K := List^.RtnCode
			 Else K := TList^.RtnCode;
		Break;
	       End;
	      End;
      kbEsc : Break;
	 else Begin
	       Chr := Char(Lo(K));
	       If Not(Chr in [#0,#$E0,#$F0])Then
	       Begin
		Chr := ChrUp(Chr);
		TList := List;
		While Not(TList^.Next = NIL) do
		Begin
		 If(ChrUp(TList^.HighChar) = Chr)Then
		 Begin
		  P := I; K := TList^.RtnCode;
		  PutBar;
		 End;
		 TList := TList^.Next;
		End;
	       End;
	       Break;
	      End;
     End;
    Until False;
  End;
  Line.Pop;
  ExecMnu := K;
 End;
 Image.Done;
 If(Actif <> NIL)Then FreeMem(Actif,L);
End;

Procedure PullMnu.AddItem;
Begin
 AddFullItem(Option,kbNoKey,RtnCode,NIL);
End;

Procedure PullMnu.AddItemKey;
Begin
 AddFullItem(Option,KeyFunc,RtnCode,NIL);
End;

Procedure PullMnu.AddFullItem;
Var Chr:Char; TStr:String; TPull:PullMnuPtr; TMenu:MainMenuPtr; BPull:PullMnuItem;
Begin
 If(MainMenu.IsEmpty)Then Exit;
 TMenu := MainMenu._GetBuf(MainMenu.MaxBuf);
 TStr := StrUp(SearchHigh(Option));
 If(TStr <> '')Then Chr := TStr[1];
 FillChar(BPull,SizeOf(BPull),0);
 BPull.Option   := Option;
 BPull.KeyFunc  := KeyFunc;
 BPull.RtnCode  := RtnCode;
 BPull.HighChar := Chr;
 BPull.SubMenu  := SubMenu;
 If(TMenu^.NumList = 0)Then
 Begin
  TMenu^.List := MemAlloc(SizeOf(TMenu^.List^));
  Move(BPull,TMenu^.List^,SizeOf(TMenu^.List^));
  TMenu^.NumList := 1;
 End
  Else
 Begin
  TPull := TMenu^.List;
  While Not(TPull^.Next = NIL) do TPull := TPull^.Next;
  TPull^.Next := MemAlloc(SizeOf(TMenu^.List^));
  Move(BPull,TPull^.Next^,SizeOf(TMenu^.List^));
  Inc(TMenu^.NumList);
 End;
End;

Constructor PullMnu.Init;
Begin
 MainMenu.Init;
 RX1 := 0; RY := 0; RX2 := MaxXTxts;
End;

Function PullMnu.MnuPtr;
Var TMenu:MainMenuPtr; Ptr:Pointer; I:Long;
Begin
 MnuPtr := NIL;
 If(MainMenu.IsEmpty)Then Exit;
 I := 0;
 Repeat
  Ptr := MainMenu._GetBuf(I); TMenu := Ptr;
  If(TMenu^.Title = Mnu)Then
  Begin
   MnuPtr := TMenu^.List;
   Exit;
  End;
  Inc(I);
 Until (Ptr = NIL);
End;

Procedure PullMnu.AddMnu;
Var Code:Word; TStr:String; BMenu:MainMenuRec; Ptr:Pointer;
Begin
 TStr := StrUp(SearchHigh(Mnu));
 If(TStr <> '')Then Code := ASCII2AltCode(TStr[1]);
 With BMenu do
 Begin
  Title := Mnu; KeyCode := Code; List := NIL; NumList := 0;
  P := 0; NextMenu := NIL;
 End;
 If(MainMenu.AddBuf(SizeOf(MainMenuRec),Ptr))Then
 Begin
  If(Ptr = NIL)Then Exit;
  Move(BMenu,Ptr^,SizeOf(MainMenuRec));
 End;
End;

Procedure PullMnu.GetMnuBar;
Var TMenu:MainMenuPtr; XP,L:Byte; T:Word; Next:Array[0..255] of Bool; I:Long;
Begin
 If(Y <> RY)Then Exit;
 XP := 3;
 For I := 0 to MainMenu.MaxBuf do
 Begin
  TMenu := MainMenu._GetBuf(I); L := LengthTyping(TMenu^.Title); T := (RX1+XP+L);
  If(T > MaxXTxts)Then
  Begin
   T := T div GetNumXTexts;
   If Not(Next[T])Then Next[T] := True;
  End;
  If(X >= RX1 + XP)and(X <= RX1 + XP + L)Then
  Begin
   PushKey(TMenu^.KeyCode);
   Exit;
  End;
  Inc(XP,L+SpcMnu);
 End;
End;

Procedure PullMnu.PutMnuBar;
Var TMenu:MainMenuPtr; XP,L:Byte; T:Word; Next:Array[0..255] of Bool; I:Long;
Begin
 Video.BarSpaceHori(RX1,RY,RX2,CurrColors.Menu.Normal);
 XP := 3;
 Video.SetAllColor(CurrColors.Menu.High,CurrColors.Menu.Normal);
 FillChar(Next,SizeOf(Next),Byte(False));
 For I := 0 to MainMenu.MaxBuf do
 Begin
  TMenu := MainMenu._GetBuf(I); L := LengthTyping(TMenu^.Title); T := (RX1+XP+L);
  If(T > MaxXTxts)Then
  Begin
   T := T div GetNumXTexts;
   If Not(Next[T])Then
   Begin
    Video.BarSpaceHori(RX1,RY+T,RX2,CurrColors.Menu.Normal);
    Next[T] := True;
   End;
  End;
  Video.PutTypingXY(RX1+XP,RY,^Q+StrPas(TMenu^.Title));
  Inc(XP,L+SpcMnu);
 End;
End;

Procedure PullMnu.SetWinBar;
Begin
 RX1 := X1; RY := Y; RX2 := X2;
 Video.BarSpaceHori(X1,Y,X2,CurrColors.Menu.Normal);
End;

Procedure PullMnu.AddItemSwitch;
Var Chr:Char; TStr:String; TPull:PullMnuPtr; TMenu:MainMenuPtr; BPull:PullMnuItem;
Begin
 If(MainMenu.IsEmpty)Then Exit;
 TMenu := MainMenu._GetBuf(MainMenu.MaxBuf);
 TStr := StrUp(SearchHigh(Option));
 If(TStr <> '')Then Chr := TStr[1];
 BPull.Option := Option; BPull.KeyFunc := 0; BPull.RtnCode := RtnCode;
 BPull.HighChar := Chr; BPull.SubMenu := NIL; BPull.Switch := @Value;
 BPull.PSwitch := Switch; BPull.Next := NIL;
 If(TMenu^.NumList = 0)Then
 Begin
  TMenu^.List := MemAlloc(SizeOf(TMenu^.List^));
  Move(BPull,TMenu^.List^,SizeOf(TMenu^.List^));
  TMenu^.NumList := 1;
 End
  Else
 Begin
  TPull := TMenu^.List;
  While Not(TPull^.Next = NIL) do TPull := TPull^.Next;
  TPull^.Next := MemAlloc(SizeOf(TMenu^.List^));
  Move(BPull,TPull^.Next^,SizeOf(TMenu^.List^));
  Inc(TMenu^.NumList);
 End;
End;

Function PullMnu.WaitForMnuAction;
Var K:Word; TMenu,SMenu:MainMenuPtr; L,XP,J:Byte; Ok:Bool; I:Long; Line:LineImage;

 Procedure PutBarHeader;
 Begin
  Line.ReSave(RX1+XP-1,RY,RX1+XP+L);
  Video.BarSelHor(RX1+XP-1,RY,RX1+XP+L,CurrColors.Menu.Select);
  {$IFNDEF NoGraf}
   Video.BarSpaceHoriRelief(RX1+XP-1,RY,RX1+XP+L,CurrColors.Menu.Select);
  {$ENDIF}
 End;

Begin
 K := ReadKey; XP := 3; I := 0;
 Line.Init;
 MainMenu.SetPtr(0);
 While (I < MainMenu.NmBuf) do
 Begin
  TMenu := MainMenu._GetCurrBuf; L := LengthTyping(TMenu^.Title);
  If(K = TMenu^.KeyCode)Then
  Begin
   PutBarHeader;
   Ok := False;
   Repeat
    K := ExecMnu(RX1-1+XP,RY+1,TMenu^.List,TMenu^.P);
    Case K of
       kbMouse : Begin
		  If(LastMsY = RY)Then
		  Begin
		   Ok := True; XP := 3;
		   For I := 0 to MainMenu.MaxBuf do
		   Begin
		    TMenu := MainMenu._GetBuf(I); L := LengthTyping(TMenu^.Title);
		    If(LastMsX >= (XP-1))and(LastMsX <= (XP + L + 1))Then
		    Begin
		     PutBarHeader;
		     Repeat Until (GetMouseButton = 0);
		     Ok := False;
		     Break;
		    End;
		    Inc(XP,L+SpcMnu);
		   End;
		   If(Ok)Then
		   Begin
		    Line.Pop;
		    WaitForMnuAction := kbNoKey;
		    Exit;
		   End;
		  End
		   Else
		  Begin
		   Line.Pop;
		   WaitForMnuAction := kbMouse;
		   Exit;
		  End;
		 End;
       kbLeft : Begin
		 If(I > 0)Then
		 Begin
		  MainMenu.Previous;
		  TMenu := MainMenu._GetCurrBuf;
		  Dec(I);
		  Dec(XP,LengthTyping(TMenu^.Title)+SpcMnu);
		 End
		  Else
		 Begin
		  I := MainMenu.MaxBuf; XP := 3;
		  For J := 0 to I-1 do
		  Begin
		   TMenu := MainMenu._GetBuf(J);
		   Inc(XP,LengthTyping(TMenu^.Title)+SpcMnu);
		  End;
		  MainMenu.SetPtr(I);
		  TMenu := MainMenu._GetCurrBuf;
		 End;
		 L := LengthTyping(TMenu^.Title);
		 PutBarHeader;
		End;
      kbRight : Begin
		 Inc(I);
		 MainMenu.Next;
		 TMenu := MainMenu._GetCurrBuf;
		 If(I >= MainMenu.NmBuf)Then
		 Begin
		  I := 0; XP := 3;
		  MainMenu.SetPtr(I);
		  TMenu := MainMenu._GetCurrBuf;
		 End
		  Else
		 Inc(XP,L+SpcMnu); L := LengthTyping(TMenu^.Title);
		 PutBarHeader;
		End;
	   Else Ok := True;
    End;
   Until Ok;
   Line.ReSave(RX1+XP-1,RY,RX1+XP+L);
   Break;
  End;
  Inc(XP,L+SpcMnu);
  MainMenu.Next;
  Inc(I);
 End;
 Line.Pop;
 WaitForMnuAction := K;
End;

BEGIN
END.