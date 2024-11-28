{⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø
 ≥                                                            ≥
 ≥           Malte Genesis III/Module des Fenàtres            ≥
 ≥                Edition Isabel pour Mode RÇel               ≥
 ≥                      III - Version 1.0                     ≥
 ≥                         1995/02/02                         ≥
 ≥                                                            ≥
 ≥       Copyright (C) par les Chevaliers de Malte            ≥
 ≥                                                            ≥
 ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ}

Unit Windows;

INTERFACE

{$B-,E+,I-,N+,Q-,R-,S-,X+}

Uses Dos,Math,Video,Memorys;

Const

      wnMax = $FF;

Type

     MtxColors = Record
      Title,Border,Icon,Sel,High,Key,kShade,kSel:Byte;
     End;

     Wins = Object
      RX,RY,RColr,RX1,RY1,RX2,RY2:Byte;
      XColrs:MtxColors;
      RTitle:String[99];
      NotFullScrnX,NotFullScrnY:Bool;
      Matrix:MatrixType;
      Constructor InitO(L,H:Byte);
      Constructor Init(X1,Y1,X2,Y2:Byte);
      Constructor PushEndBar;
      Procedure ReInit(X1,Y1,X2,Y2:Byte);
      Procedure SetMatrix(X:MatrixType);
      Procedure SubWins(X1,Y1,X2,Y2:Byte;Var W:Wins);
      Procedure SetSubWn(Title:String;Var W:Wins);
      Procedure SetEndBar(Attr:Byte);
      Procedure SetEndBarCTitle;
      Procedure SetEndBarTxtX(X:Byte;Str:String;Attr:Byte);
      Procedure Background(Attr:Byte);
      Procedure BarSelHor(X1,Y,X2:Byte);
      Procedure BarSpcHor(X1,Y,X2:Byte);
      Procedure BarSpcHorShade(X1,Y,X2:Byte);
      Procedure ClrScr;
      Procedure ClrEol;
      Procedure ClrWn(X1,Y1,X2,Y2,Attr:Byte);
      Procedure ClrWnBorder(X1,Y1,X2,Y2:Byte);
      Procedure CloseIcon;
      Procedure Dn(N:Byte);
      Procedure Foreground(Attr:Byte);
      Procedure ZoomIcon;
      Procedure Left(N:Byte);
      Procedure Ln;
      Procedure PutBarMsRight;
      Procedure PutChrGAttr(Chr:Char;GAttr:Byte);
      Procedure PutCube(Chr:Char);
      Procedure PutkHor(X,Y,JK:Byte;kStr:String);
      Procedure PutkHorDn(Key:String);
      Procedure PutkHorO(Y:Byte;k:String);
      Procedure PutMsg(Msg:String);
      Procedure PutOTxt(Msg:String);
      Procedure PutOTxtU(Msg:String);
      Procedure PutPTxt(Msg:PChar);
      Procedure PutPTxtLn(Msg:PChar);
      Procedure PutPTxtXY(X,Y:Byte;Msg:PChar);
      Procedure PutPTxtXY2(X,Y:Byte;S:Word;Msg:PChar);
      Procedure PutPTxtXYAtChr(X,Y:Byte;Chr:Char;Msg:PChar);
      Procedure PutSmallBorder;
      Procedure PutTxt(Msg:String);
      Procedure PutTxtLn(Msg:String);
      Procedure PutTxtXY(X,Y:Byte;Msg:String);
      Procedure PutTxtXYU(X,Y:Byte;Msg:String);
      Procedure PutTyping(Msg:String);
      Procedure PutWn(Title:String;Colrs:MtxColors);
      Procedure Right(N:Byte);
      Procedure ScrollLeft(X1,Y1,X2,Y2,N:Byte);
      Procedure ScrollRight(X1,Y1,X2,Y2,N:Byte);
      Procedure ScrollDn(X1,Y1,X2,Y2:Byte);
      Procedure ScrollUp(X1,Y1,X2,Y2:Byte);
      Procedure SetAttr(X,Y,Attr:Byte);
      Procedure SetChr(X,Y:Byte;Chr:Char);
      Procedure SetCube(X,Y:Byte;Chr:Char);
      Procedure SetCurPos(X,Y:Byte);
      Procedure SetInpColrs(Normal,Select:Byte);
      Procedure SetKr(Colr:Byte);
      Procedure SetKrBorder;
      Procedure SetKrBorderF(F:Byte);
      Procedure SetKrHigh;
      Procedure SetKrSel;
      Procedure SetKrSelF(F:Byte);
      Procedure SetPos(X,Y:Byte);
      Procedure SetTitle(Title:String;Color:Byte);
      Procedure SetY(Y:Byte);
      Procedure Up(N:Byte);
      Procedure _Dn;
      Procedure _HL; { SetHomeLine }
      Procedure _Left;
      Procedure _LL; { SetLastLine }
      Procedure _Ln;
      Procedure _PutWn(Title:String);
      Procedure _Right;
      Procedure _SetCube(X,Y:Byte;Chr:Char;Attr:Byte);
      Procedure _SetCubeCSel(X,Y:Byte;Chr:Char);
      Procedure _SetCubeCSelF(X,Y:Byte;Chr:Char;F:Byte);
      Procedure _SetTitle(Title:String);
      Procedure _SetTitleF(Title:String;F:Byte);
      Procedure _ScrollDn;
      Procedure _ScrollUp;
      Procedure _Up;
      Procedure PushCur;
      Procedure AniCur;
      Procedure PopCur;
      Function _Input(X1,Y,X2:Byte;Len:Word;Var PChr:PChar):Word;
      Function BackReadk:Word;
      Function GetkHor(X,Y,JK:Byte;kStr:String):Byte;
      Function GetkHorDn(k:String):Word;
      Function GetkHorO(Y:Byte;k:String):Word;
      Function GetStr(X,Y:Byte):String;
      Function GetRX1:Byte;
      Function GetRY1:Byte;
      Function GetRealY:Byte;
      Function GetRealX:Byte;
      Function InCloseIcon(X,Y:Byte):Bool;
      Function Inp(Var Str:PChar;MaxLen:Word):Word;
      Function InRightBarMs(X,Y:Byte):Word;
      Function InTitle(X,Y:Byte):Bool;
      Function InWn(X,Y:Byte):Bool;
      Function MaxXTxts:Byte;
      Function MaxYTxts:Byte;
      Function Readk:Word;
      Function XIsOut:Bool;
      Function YIsOut:Bool;
      Function PopWn:Bool;
      Function PushWn:Bool;
      Destructor Done;
      PRIVATE
      _CloseIcon,BarMouseRight,Shade:Bool;
      Buf:Pointer;
      SizeBuf:Word;
      InpColr1,InpColr2:Byte;
      Procedure PutTxt6x6(X,Y:Byte;S:String;Attr:Byte);
     End;

     ImgStruct = Record
      X1,Y1,X2,Y2,BitsPerPix:Byte;NmXPixs,NmYPixs,BaseColor:Word;
     End;

     WnImg = Object
      Struct:ImgStruct;
      SGX1,SGY1,SGX2,SGY2,SGXM,SGYM,DrawX,DrawY:Word;
      DrawS:Byte;
      Constructor Init(Inf:ImgStruct);
      Constructor SetWnTxt(X1,Y1,X2,Y2:Byte);
      Function IsInit:Bool;
      Function XMoveWn:Word;
      Function YMoveWn:Word;
      Procedure Draw(S:String);
      Procedure MoveWnX(X:Word);
      Procedure MoveWnY(Y:Word);
      Procedure MoveWn(X,Y:Word);
      Procedure CopyAllLn(Y:Word;Var XBuf);
      Procedure CopyAllLnNoUpDate(Y:Word;Var XBuf);
      Procedure SetColor(Color:Word);
      Procedure PutFillBox(X1,Y1,X2,Y2:Word);
      Procedure PutTTextXY(X,Y,Height:Byte;S:String);
      Procedure PutLnHor(X1,Y,X2:Word);
      Procedure PutPixel(X,Y:Word);
      Procedure SetPixel(X,Y,Color:Word);
      Procedure PutLine(X1,Y1,X2,Y2:Word);
      Procedure UpDateLn(Y:Word);
      Function GetPixel(X,Y:Word):Word;
      Destructor Done;
      PRIVATE
      XMove,YMove,CurrColor:Word;
      H:MemSwp;
      BInit:Bool;
      Procedure _1SetPixel(Formule:Long;Color:Byte);
      Procedure _4SetPixel(Formule:Long;Color:Byte);
     End;

     DrawWins = Object
      Constructor Init(Path:PathStr;Inf:ImgStruct);
      Procedure Refresh;
      Procedure SetMode(M:Byte);
      Function Run:Word;
      Destructor Done;
      PRIVATE
      BufCur:Pointer;
      BufCurSize,XC,YC,XO,YO,Mode,XPtr,YPtr:Word;
      SM,Modified:Bool;
      FileName:PathStr;
      W:Wins;
      WImg:WnImg;
      Procedure PutCur(Color:Byte);
     End;

IMPLEMENTATION

Uses RLL,Strings,Mouse,CardVideo,LibVideo,Keyboard,Cursor,Images,Strs,
     Mems,Systems,Dials;

Constructor DrawWins.Init;
Var Kr:MtxColors;Ext:ExtStr;BMP:LoadBMP;PCX:LoadPCX;
    Buf,BufT:^TByte;Shift:Word;I:Long;

 Procedure Header;
 Begin
  W.SetEndBar(Kr.Title);
  W.SetEndBarTxtX(16,'≥ '+Str(Inf.NmXPixs)+'x'+Str(Inf.NmYPixs)+'c'+
	  Str(1 shl Inf.BitsPerPix)+' : '+Str(Long(Inf.NmXPixs)*
	  Long(Inf.NmYPixs))+' octet(s)',Kr.Title);
  Inc(Inf.X1); Inc(Inf.Y1); Dec(Inf.X2); Dec(Inf.Y2);
  WImg.Init(Inf);
  If Not(WImg.IsInit)Then ErrorMsgOk('Impossible de crÇe un tampon mÇmoire pour le dessin!');
 End;

 Procedure PutCount;
 Var S : String[20];
 Begin
  S := '(' + Str(Inf.NmXPixs) + ',' + Str(I) + ')';
  W.SetEndBarTxtX(0,Spc(15-Length(S))+S,W.XColrs.Title);
 End;

Begin
 XPtr := $FFFF; YPtr := $FFFF; FileName := Path;
 W.Init(Inf.X1,Inf.Y1,Inf.X2,Inf.Y2);
 W.PushWn;
 Kr.Title := $A0; Kr.Border := $0A+(Inf.BaseColor shl 4); Kr.Icon := $0F;
 If(Path = '')Then
 Begin
  W.PutWn('Pasnom',Kr);
  Header;
  Buf := MemAlloc(Inf.NmXPixs);
  If Not(Buf = NIL)Then
  Begin
   FillChar(Buf^,Inf.NmXPixs,Inf.BaseColor);
   For I := 0 to Inf.NmYPixs-1 do WImg.CopyAllLn(I,Buf^);
   Freemem(Buf,Inf.NmXPixs);
  End
   Else
  Begin
   __OutOfMemory;
   Header;
  End;
 End
  Else
 Begin
  W.PutWn(Path,Kr);
  Ext := Path2Ext(Path);
  If(Ext = '.BMP')Then
  Begin
   BMP.Init;
   If(BMP.Open(Path))Then
   Begin
    If(BMP.CheckBMP)Then
    Begin
     Inf.NmXPixs := BMP.GetNumXPixels; Inf.NmYPixs := BMP.GetNumYPixels;
     Header;
     Buf := MemAlloc(Inf.NmXPixs);
     If Not(Buf = NIL)Then
     Begin
      For I := 0 to Inf.NmYPixs-1 do
      Begin
       PutCount;
       BMP.GetLine(I,Buf^);
       WImg.CopyAllLn(I,Buf^);
      End;
      Freemem(Buf,Inf.NmXPixs);
     End
      Else
     Begin
      __OutOfMemory;
      Header;
     End;
    End;
   End
    else
   Header;
   BMP.Done;
  End;
  If(Ext = '.PCX')Then
  Begin
   PCX.Init;
   If(PCX.Open(Path))Then
   Begin
    If(PCX.CheckPCX)Then
    Begin
     PCX.SetPalette;
     Inf.NmXPixs := PCX.GetNumXPixels; Inf.NmYPixs := PCX.GetNumYPixels;
     Header;
     BufT := MemAlloc(Inf.NmXPixs);
     If Not(BufT = NIL)Then
     Begin
      Buf := MemAlloc(Inf.NmXPixs);
      If Not(Buf = NIL)Then
      Begin
       For I := 0 to Inf.NmYPixs-1 do
       Begin
	PutCount;
	PCX.GetLine(BufT^);
	If(I > 142)Then
	Begin
	 Shift := ((I - 22) div 3) + 20;
	 Move(BufT^[Inf.NmXPixs-Shift],Buf^[0],Shift);
	 Move(BufT^[0],Buf^[Shift],Inf.NmXPixs-Shift);
	End
	 Else
	If(I > 55)Then
	Begin
	 Shift := ((I + 11) div 3);
	 Move(BufT^[Inf.NmXPixs-Shift],Buf^[0],Shift);
	 Move(BufT^[0],Buf^[Shift],Inf.NmXPixs-Shift);
	End
	 Else
	If(I > 4)Then
	Begin
	 Shift := (I div 3);
	 Move(BufT^[Inf.NmXPixs-Shift],Buf^[0],Shift);
	 Move(BufT^[0],Buf^[Shift],Inf.NmXPixs-Shift);
	End
	 else
	Move(BufT^[0],Buf^[0],Inf.NmXPixs);
	WImg.CopyAllLn(I,Buf^);
       End;
       Freemem(Buf,Inf.NmXPixs);
      End
       Else
      Begin
       __OutOfMemory;
       Header;
      End;
      Freemem(BufT,Inf.NmXPixs);
     End
      Else
     Begin
      __OutOfMemory;
      Header;
     End;
    End
     Else
    Begin
     __OutOfMemory;
     Header;
    End;
   End
    else
   Header;
   PCX.Done;
  End;
 End;
 XC := ((Inf.X2 - Inf.X1 + 1) * 8) shr 1; YC := ((Inf.Y2 - Inf.Y1 + 1) * GetHeightChar) shr 1;
 BufCurSize := GetSizeSmlImg(0,0,15,15); BufCur := MemAlloc(BufCurSize);
 SM := False; Modified := False; XO := 0; YO := 0; Mode := 0;
End;

Procedure DrawWins.SetMode;
Begin
 Mode := M;
End;

Procedure DrawWins.Refresh;
Begin
End;

Procedure DrawWins.PutCur;
Var J,XH,YH,XM,YM,XE,YE : Int;
Begin
 XH := WImg.SGX1 + XC; YH := WImg.SGY1 + YC; XM := XH - 6;
 YM := YH - 6; XE := XH + 6; YE := YH + 6;
 If(XM < WImg.SGX1)Then XM := WImg.SGX1;
 If(YM < WImg.SGY1)Then YM := WImg.SGY1;
 If(XE > WImg.SGX2)Then XE := WImg.SGX2;
 If(YE > WImg.SGY2)Then YE := WImg.SGY2;
 PutLineHori(XM,YH,XE,Color);
 For J := YM to YE do SetPixel(XH,J,Color);
End;

Function DrawWins.Run;
Var K : Word; Ok,ScrollLck : Bool; XM,YM,XE,YE : Int; S : String[20];
Begin
 If(BufCur = NIL)Then
 Begin
  Run := W.Readk;
  Exit;
 End;
 Ok := False;
 Repeat
  If Not(KeyPressed)Then
  Begin
   If(XC <> XPtr)or(YC <> YPtr)Then
   Begin
    XPtr := XC; YPtr := YC; S := '(' + Str(XPtr) + ',' + Str(YPtr) + ')';
    W.SetEndBarTxtX(0,Spc(15-Length(S))+S,W.XColrs.Title);
   End;
  End;
  XM := WImg.SGX1 + XC - 6; YM := WImg.SGY1 + YC - 6;
  XE := WImg.SGX1 + XC + 6; YE := WImg.SGY1 + YC + 6;
  If(XM < WImg.SGX1)Then XM := WImg.SGX1;
  If(YM < WImg.SGY1)Then YM := WImg.SGY1;
  If(XE > WImg.SGX2)Then XE := WImg.SGX2;
  If(YE > WImg.SGY2)Then YE := WImg.SGY2;
  Images.GetSmlImg(XM,YM,XE,YE,BufCur^);
  Repeat
   PutCur(Mem[_0040:$6C] and $F);
   K := W.BackReadk;
   If(K > 0)Then
   Begin
    Images.PutSmlImg(XM,YM,XE,YE,BufCur^);
    Run := K;
    Exit;
   End;
  Until Keypressed;
  Images.PutSmlImg(XM,YM,XE,YE,BufCur^);
  K := W.Readk; ScrollLck := GetScrollLock;
  Case K of
     kbUp : If(ScrollLck)Then
            Begin
	     If(WImg.YMoveWn > 0)Then WImg.MoveWnY(WImg.YMoveWn-8);
	    End
	     Else
	    Begin
	     If(YC > 0)Then Dec(YC) Else YC := WImg.SGYM;
	    End;
   kbDown : If(ScrollLck)Then
            Begin
	     If(WImg.YMoveWn < (WImg.Struct.NmYPixs-WImg.SGYM+8))Then
	      WImg.MoveWnY(WImg.YMoveWn+8);
	    End
	     Else
	    Begin
	     If(YC < WImg.SGYM)Then Inc(YC) Else YC := 0;
	    End;
  kbRight : If(ScrollLck)Then
            Begin
	     If(WImg.XMoveWn < (WImg.Struct.NmXPixs-WImg.SGXM+8))Then
	      WImg.MoveWnX(WImg.XMoveWn+8);
	    End
	     Else
	    Begin
	     If(XC < WImg.SGXM)Then Inc(XC) Else XC := 0;
	    End;
   kbLeft : If(ScrollLck)Then
	    Begin
	     If(WImg.XMoveWn > 0)Then WImg.MoveWnX(WImg.XMoveWn-8);
	    End
	     Else
	    Begin
	     If(XC > 0)Then Dec(XC) Else XC := WImg.SGXM;
	    End;
  kbEnter : Case Mode of
	     drwBox:
	     Begin
	      If Not(SM)Then
	      Begin
	       XO := XC; YO := YC;
	      End
	       Else
	      WImg.PutFillBox(XC,YC,XO,YO);
	      SM := Not(SM);
	     End;
	    End;
       Else Ok := True;
  End;
 Until Ok;
 Run := K;
End;

Destructor DrawWins.Done;
Begin
 WImg.Done;
 W.Done;
End;

Constructor Wins.PushEndBar;
Begin
 Init(0,Video.MaxYTxts,Video.MaxXTxts,Video.MaxYTxts);
 PushWn;
End;

Constructor Wins.InitO;
Var X1,Y1,X2,Y2 : Byte;
Begin
 If(L >= Video.MaxXTxts)Then
 Begin
  X1 := 0; X2 := Video.MaxXTxts;
 End
  else
 Begin
  X1 := (Video.GetNumXTexts - L) shr 1; X2 := X1 + L;
 End;
 Y1 := (Video.GetNumYTexts - H) shr 1; Y2 := Y1 + H;
 Init(X1,Y1,X2,Y2);
End;

Constructor Wins.Init;
Begin
 Shade := GetShade; Matrix := Default;
 If(X1 > X2)Then SwapByte(X1,X2);
 RX1 := X1; RY1 := Y1; RX2 := X2; RY2 := Y2;
 If(RX1 <> 0)Then If(X2-X1+1 >= Video.MaxXTxts)Then
 Begin
  RX1 := 0; RX2 := Video.MaxXTxts;
 End;
 If(RY1 <> 0)Then If(RY2-RY1+1 >= Video.MaxYTxts)or(RY2 > Video.MaxYTxts)Then
 Begin
  RY1 := 0; RY2 := Y2-Y1-2;
  If(RY2 > Video.MaxYTXts)Then RY2 := Video.MaxYTxts;
 End;
 NotFullScrnX := Not((RX2-RX1) >= Video.MaxXTxts); NotFullScrnY := Not((RY2-RY1+1) >= Video.MaxYTxts);
 RX := 0; RY := 0; RColr := 7; Buf := NIL; SizeBuf := 0; _CloseIcon := False; BarMouseRight := False;
End;

Procedure Wins.SetMatrix;
Begin
 If(X <> Matrix)Then If(IVid.Graf)Then Matrix := X;
End;

Procedure Wins.PutTxt6x6;
Type Matrix6x6Rec = Array[0..255,0..5] of Byte;
Var I,J,K,Masque:Byte; GX1,GY1,Xx,Yx:Word;
    Matrix6x6:^Matrix6x6Rec; SizeOf_:Word;
Begin
 Matrix6x6 := AllocFunc(0,SetPath4AddFile(StrPas(PathSystems))+'FONTS.*',SizeOf_);
 GX1 := GetRX1 * 8; GY1 := (GetRY1 * IVid.HeightChr) + (Y * 6);
 For J := 0 to Length(S)-1 do For I := 0 to 5 do
 Begin
  Masque := Matrix6x6^[Byte(S[J+1]),I]; Xx := GX1 + ((X+J) * 6); Yx := GY1 + I;
  If(Masque = 0)Then PutLineHori(Xx,Yx,Xx+5,Attr shr 4) Else
  For K := 0 to 5 do
  Begin
   If(Masque and 128 <> 0)Then SetPixel(Xx+K,Yx,Attr and $F)
			  Else SetPixel(Xx+K,Yx,Attr shr 4);
   Masque := Masque shl 1;
  End;
 End;
 FreeMem(Matrix6x6,SizeOf_);
End;

Procedure Wins.PushCur;
Begin
 If(Matrix = _6x6)Then GetSmlImg(GetRX1*8+(RX*6),(GetRY1*IVid.HeightChr)+(RY*6),
				   GetRX1*8+(RX*6)+5,(GetRY1*IVid.HeightChr)+(RY*6)+5,CurBuf^) Else
 If(IVid.Graf)Then GetSmlImg(GetRealX*8,GetRealY*IVid.HeightChr,
		  (GetRealX*8)+7,((GetRealY+1)*IVid.HeightChr)-1,CurBuf^)
		Else CurrCube := GetCube(GetRealX,GetRealY);
End;

Procedure Wins.AniCur;
Begin
 Case (Mem[_0040:$6C] and $F) of
   0 : SetAttr(RX,RY,$0F);
   4 : SetAttr(RX,RY,$C0);
   8 : SetAttr(RX,RY,$90);
  12 : SetAttr(RX,RY,$E0);
 End;
End;

Procedure Wins.PopCur;
Var _CCube : TextCube Absolute CurrCube;
Begin
 If(Matrix = _6x6)Then PutSmlImg(GetRX1*8+(RX*6),(GetRY1*IVid.HeightChr)+(RY*6),
				   GetRX1*8+(RX*6)+5,(GetRY1*IVid.HeightChr)+(RY*6)+5,CurBuf^) Else
 If(IVid.Graf)Then PutSmlImg(GetRealX*8,GetRealY*IVid.HeightChr,
		  (GetRealX*8)+7,((GetRealY+1)*IVid.HeightChr)-1,CurBuf^)
		Else Video.SetCube(GetRealX,GetRealY,_CCube.Chr,_CCube.Attr);
End;

Procedure Wins.ReInit;
Begin
 PopWn; Matrix := Default;
 If(X1 > X2)Then SwapByte(X1,X2);
 RX1 := X1; RY1 := Y1; RX2 := X2; RY2 := Y2;
 If(RX1 <> 0)Then If(X2-X1+1 >= Video.MaxXTxts)Then
 Begin
  RX1 := 0; RX2 := Video.MaxXTxts;
 End;
 If(RY1 <> 0)Then If(RY2-RY1+1 >= Video.MaxYTxts)or(RY2 > Video.MaxYTxts)Then
 Begin
  RY1 := 0; RY2 := Y2-Y1-2;
  If(RY2 > Video.MaxYTXts)Then RY2 := Video.MaxYTxts;
 End;
 NotFullScrnX := Not((RX2-RX1) >= Video.MaxXTxts); NotFullScrnY := Not((RY2-RY1+1) >= Video.MaxYTxts);
 RX := 0; RY := 0; Buf := NIL; SizeBuf := 0; _CloseIcon := False;
End;

Procedure Wins.SubWins;
Begin
 If(X2 > MaxXTxts)Then X2 := MaxXTxts else
 If(IVid.Graf)and(WinType = Robotic)Then Inc(X2);
 If(Y2 > MaxYTxts)Then Y2 := MaxYTxts;
 W.Init(GetRX1+X1,GetRY1+Y1,GetRX1+X2,GetRY1+Y2);
End;

Function Wins.GetRX1;
Var _NotFScrX:Byte Absolute NotFullScrnX;
Begin
 GetRX1 := RX1 + _NotFScrX;
End;

Function Wins.GetRY1;
Var _NotFScrY:Byte Absolute NotFullScrnY;
Begin
 GetRY1 := RY1 + _NotFScrY;
End;

Function Wins.InRightBarMs;
Begin
 InRightBarMs := 0;
 If(BarMouseRight)Then
 Begin
  If(X >= RX2 - (Length(Video.GetCloseIcon^)) + 1)and(X <= RX2)Then
  Begin
   If(Y = GetRY1)Then
   Begin
    InRightBarMs := kbRightBarMsUp;
    Exit;
   End;
   If(Y = GetRY1 + MaxYTxts)Then
   Begin
    InRightBarMs := kbRightBarMsDn;
    Exit;
   End;
   If(Y >= GetRY1)and(Y <= GetRY1+MaxYTxts)Then
   Begin
    If((Y-GetRY1) > (MaxYTxts shr 1))Then InRightBarMs := kbRightBarMsPgDn
				     Else InRightBarMs := kbRightBarMsPgUp;
    Exit;
   End;
  End;
 End;
End;

Function Wins.InTitle;
Begin
 InTitle := ((Y = RY1)and(X >= (RX1+Length(Video.GetCloseIcon^)))and(X <= RX2));
End;

Function Wins.BackReadk;
Var MX,MY:Byte; B,V1:Word; _NotFScrX:Byte Absolute NotFullScrnX; _NotFScrY:Byte Absolute NotFullScrnY;
Begin
 BackReadk := 0;
 __GetMouseTextSwitch(MX,MY,B);
 If(B > 0)Then
 Begin
  If(InCloseIcon(MX,MY))Then  Begin BackReadk := kbCloseWin; Exit; End;
  V1 := InRightBarMs(MX,MY);
  If(V1 > 0)Then  Begin BackReadk := V1; Exit; End;
  If(InWn(MX,MY))Then  Begin BackReadk := kbInWn; Exit; End;
  If(InTitle(MX,MY))Then  Begin BackReadk := kbTitle; Exit; End;
  If(MY = 0)Then
  Begin
   If(MX >= Length(Video.GetCloseIcon^))Then BackReadk := kbPrgTitle Else BackReadk := kbPrgCloseIcon;
   Exit;
  End;
  If(MY = 1)Then  Begin BackReadk := kbPrgMnuBar; Exit; End;
 End;
End;

Function Wins.Readk;
Var K : Word;
Begin
 _InitKbd;
 __ShowMousePtr;
 Repeat
  K := BackReadk;
  If(K > 0)Then
  Begin
   __HideMousePtr;
   Readk := K;
   Exit;
  End;
  _BackKbd;
 Until Keypressed;
 __HideMousePtr;
 Readk := Keyboard.ReadKey;
End;

Procedure Wins.PutBarMsRight;
Begin
 If(MouseInstalled)Then
 Begin
  Video.PutUpIcon(RX2+1-Length(GetUpIcon^),RY1+Byte(NotFullScrnY),XColrs.Icon);
  If(Length(GetUpIcon^) = 1)Then Video.BarSpaceVert(RX2,RY1+1+Byte(NotFullScrnY),RY2-(1+Byte(NotFullScrnY)),XColrs.Icon)
   Else
  Begin
   If(IVid.Graf)Then
   Begin
    Video.ClrWn(RX2-1,RY1+1+Byte(NotFullScrnY),RX2,RY2-(1+Byte(NotFullScrnY)),(XColrs.Icon shr 4) + XColrs.Icon shl 4);
    Video.PutRect((RX2-1)*8,(RY1+1+Byte(NotFullScrnY))*IVid.HeightChr,
		  (RX2*8)+7,(RY2-(1+Byte(NotFullScrnY))+1)*IVid.HeightChr-1,XColrs.Icon shr 4);
   End
    Else
   Begin
    Video.BarTextVert(RX2-1,RY1+1+Byte(NotFullScrnY),RY2-(1+Byte(NotFullScrnY)),#1,(XColrs.Icon shr 4) + XColrs.Icon shl 4);
    Video.BarTextVert(RX2,RY1+1+Byte(NotFullScrnY),RY2-(1+Byte(NotFullScrnY)),#2,(XColrs.Icon shr 4) + XColrs.Icon shl 4);
   End;
  End;
  Video.PutDownIcon(RX2+1-Length(GetDownIcon^),RY2-Byte(NotFullScrnY),XColrs.Icon);
  BarMouseRight := True;
 End;
End;

Procedure Wins.SetSubWn;
Begin
 W.PutWn(Title,XColrs);
End;

Procedure Wins.SetInpColrs;
Begin
 InpColr1 := Normal; InpColr2 := Select;
End;

Procedure Wins.SetKrBorder;
Begin
 SetKr(XColrs.Border);
End;

Procedure Wins.SetKrHigh;
Begin
 SetKr(XColrs.High);
End;

Procedure Wins.SetEndBarCTitle;
Begin
 SetEndBar(XColrs.Title);
End;

Procedure Wins._SetCubeCSel;
Begin
 _SetCube(X,Y,Chr,XColrs.Sel);
End;

Procedure Wins._SetCubeCSelF;
Begin
 _SetCube(X,Y,Chr,(XColrs.Sel and $F0) + F);
End;

Procedure Wins._SetTitle;
Begin
 SetTitle(Title,XColrs.Title);
End;

Procedure Wins._SetTitleF;
Begin
 SetTitle(Title,(XColrs.Title and $F0) + F);
End;

Procedure Wins.PutSmallBorder;
Begin
 If(IVid.Graf)and(WinType = Robotic)Then Exit;
 If(RX2+1 > Video.MaxXTxts)Then
  Video.BarTextHori(RX1+1,RY2+1,Video.MaxXTxts,'ﬂ',GetAttr(RX1+1,RY2+1) and $F0)
  Else
 Begin
  Video.SetCube(RX2+1,RY1,'‹',GetAttr(RX2+1,RY1) and $F0);
  Video.BarSpaceVert(RX2+1,RY1+1,RY2,0);
  Video.BarTextHori(RX1+1,RY2+1,RX2+1,'ﬂ',GetAttr(RX1+1,RY2+1) and $F0);
 End;
End;

Function Wins._Input;
Var K : Word;
Begin
 Video.SetAllColor(InpColr1,InpColr2);
 K := Dials.Input(GetRX1+X1,GetRY1+Y,GetRX1+X2,Len,PChr);
 Case K of
  kbMouse : If(InCloseIcon(LastMsX,LastMsY))Then K := kbCloseWin Else
	    If(InWn(LastMsX,LastMsY))Then K := kbInWn;
 End;
 _Input := K;
End;

Function Wins.PushWn;
Type PImgRec = ^ImgRec;
Var Info : PImgRec Absolute Buf; X2,Y2 : Byte;
Begin
 If Not(Buf = NIL)Then PopWn;
 PushWn := False;
 If(IVid.Graf)Then
 Begin
  Buf := MemAlloc(SizeOf(ImgRec));
  If(Buf = NIL)Then Exit;
  If Not(SaveImage(RX1*8,RY1*IVid.HeightChr,(RX2*8)+7,((RY2+1)*IVid.HeightChr)-1,Info^))Then
  Begin
   FreeMem(Buf,SizeOf(ImgRec));
   Buf := NIL;
   Exit;
  End;
 End
  Else
 Begin
  X2 := RX2 + 2;
  If(X2 > Video.MaxXTxts)Then X2 := Video.MaxXTxts;
  If(Shade)Then SizeBuf := SizeBox(RX1,RY1,X2,RY2+1) Else SizeBuf := SizeBox(RX1,RY1,X2,RY2);
  Buf := MemAlloc(SizeBuf);
  If(Buf = NIL)Then  Begin SizeBuf := 0; Exit; End;
  If(Shade)Then CopyBox(RX1,RY1,X2,RY2+1,Buf^) Else CopyBox(RX1,RY1,X2,RY2,Buf^);
 End;
 PushWn := True;
End;

Function Wins.PopWn;
Var Info : ^ImgRec Absolute Buf; X2 : Byte;
Begin
 PopWn := False;
 If Not(Buf = NIL)Then
 Begin
  If(IVid.Graf)Then
  Begin
   If Not(RestoreImage(RX1*8,RY1*IVid.HeightChr,(RX2*8)+7,((RY2+1)*IVid.HeightChr)-1,Info^))Then Exit;
   FreeMem(Buf,SizeOf(ImgRec));
  End
   Else
  If Not(SizeBuf = 0)Then
  Begin
   X2 := RX2 + 2;
   If(X2 > Video.MaxXTxts)Then X2 := Video.MaxXTxts;
   If(Shade)Then PutBox(RX1,RY1,X2,RY2+1,Buf^) Else PutBox(RX1,RY1,X2,RY2,Buf^);
   FreeMem(Buf,SizeBuf);
  End;
 End;
 SizeBuf := 0; Buf := NIL; PopWn := True;
End;

Procedure Wins._PutWn;
Begin
 PutWn(Title,XColrs);
End;

Procedure Wins.PutWn;
Var J,L,I,GX1,GY1,GX2,GY2:Word; BP:Byte;
    LenTitle:Byte Absolute Title;
    _W : Record Case Byte of 0:(T:Word); 1:(Chr:Char;Attr:Byte); End;
Begin
 XColrs := Colrs;
 If(IVid.Graf)Then
 Begin
  If(CurBorder = '…Õª∫∫»Õº')Then
  Begin
   Video.PutFillBorder(RX1,RY1,RX2,RY2,Colrs.Border);
   Video.PutTextXY((RX2-(RX1+1+LenTitle)) shr 1,RY1,' '+Title+' ',Colrs.Border)
  End
   Else
  Begin
   Video.ClrWn(RX1,RY1,RX2,RY2,Colrs.Border);
   GX1 := RX1 * 8; GY1 := RY1 * IVid.HeightChr; GX2 := RX2 * 8;
   GY2 := ((RY2+1) * IVid.HeightChr) - 1;
   PutRect(GX1,GY1,GX2+7,GY2,Colrs.Border and $F);
   If(DegradSupport)Then
   Begin
    If(WinType = Robotic)Then
    Begin
     If(NotFullScrnX)Then
     Begin
      For I := 0 to 3 do
      Begin
       For J := GY1 to GY2 do
       Begin
	SetPixel(GX1+I,J,36+I);
	SetPixel(GX2+I,J,36+I);
       End;
      End;
      For I := 0 to 3 do
      Begin
       For J := GY1 to GY2 do
       Begin
	SetPixel(GX1+I+4,J,40-I);
	SetPixel(GX2+I+4,J,40-I);
       End;
      End;
      PutLineHori(GX1,GY1+24,GX1+7,0);
      PutLineHori(GX1,GY1+((GY2-GY1) shr 1),GX1+7,0);
      PutLineHori(GX1,GY2-24,GX1+7,0);
      PutLineHori(GX2,GY1+24,GX2+7,0);
      PutLineHori(GX2,GY1+((GY2-GY1) shr 1),GX2+7,0);
      PutLineHori(GX2,GY2-24,GX2+7,0);
     End;
     If(NotFullScrnY)Then
     Begin
      For J := 0 to 7 do
      Begin
       For I := GX1+J to GX2+7-J do
       Begin
	If(J < 4)Then SetPixel(I,GY2-J,J+36) Else SetPixel(I,GY2-J,40-(J and 3));
       End;
      End;
      PutLine(GX1+24,GY2-7,GX1+24,GY2,0);
      PutLine(GX1+((GY2-GY1) shr 1),GY2-7,GX1+((GY2-GY1) shr 1),GY2,0);
      PutLine(GX2-24,GY2-7,GX2-24,GY2,0);
     End;
    End
     Else
    Begin
     Case Colrs.Border of
      $11..$1F : BP := 16;
      $F0..$FF : BP := 32;
      $90..$9F : BP := 48;
	    Else BP := 0;
     End;
     If(BP > 0)Then
     Begin
      If(NotFullScrnX)Then For I := 0 to 7 do
      Begin
       For J := GY1 to GY2 do
       Begin
	SetPixel(GX1+I,J,(I shl 1)+BP);
	SetPixel(GX2+I,J,BP + 15 - (I shl 1));
       End;
      End;
      If(NotFullScrnY)Then For J := 0 to 15 do
      Begin
       For I := GX1+(J shr 1) to GX2+7-(J shr 1) do SetPixel(I,GY2-J,J+BP);
      End;
     End;
    End;
   End;
   _W.Chr  := ' '; _W.Attr := Colrs.Border; L := (RX2 - RX1) + 1;
   For J := RY1 to RY2 do FillWord(MainData^.TBuffer^[RX1 + (IVid.NmXTxts * J)],L,_W.T);
   If(Title <> '')Then SetTitle(Title,Colrs.Title);
  End;
 End
  Else
 Begin
  If(NotFullScrnX)and(NotFullScrnY)Then
  Begin
   Video.PutFillBorder(RX1,RY1,RX2,RY2,Colrs.Border);
   If(CurBorder = '…Õª∫∫»Õº')Then
    Video.PutTextXY((RX2-(RX1+1+LenTitle)) shr 1,RY1,' '+Title+' ',Colrs.Border)
     Else
   If(Title <> '')Then SetTitle(Title,Colrs.Title);
  End
   Else
  Begin
   Video.ClrWn(RX1,RY1,RX2,RY2,Colrs.Border);
   If(Title <> '')Then SetTitle(Title,Colrs.Title);
  End;
 End;
 RColr := (Colrs.Border and $F0) + $F;
End;

Function SrchK(P,NK:Byte;KeyStr:String):String;
Var I,Start,Len,NC : Byte;
Begin
 If(NK = 0)Then SrchK := KeyStr
  else
 Begin
  I := 0; NC := 0;
  While(NC < P) do
  Begin
   Inc(I);
   If(KeyStr[I] = '|')Then Inc(NC);
  End;
  If(P > 0)Then Inc(I);
  Start := I;
  While(KeyStr[I] <> '|') do Inc(I);
  If(P = NK)Then Len := 255 else
  If(P <> 0)Then Len := I - Start Else Len := I - Start - 1;
  SrchK := Copy(KeyStr,Start,Len);
 End;
End;

Procedure Wins.PutkHor;
Var I,LK,NK,_X1:Byte; kStrLen:Byte Absolute kStr;
Begin
 LK := JK - 3; NK := 0; _X1 := GetRX1 + X;
 For I := 1 to kStrLen do If(kStr[I] = '|')Then Inc(NK);
 For I := 0 to NK do
  Video.PutKeyHori(_X1+(I*JK),GetRY1+Y,_X1+(I*JK)+LK,SrchK(I,NK,kStr),XColrs.Key,XColrs.kShade);
End;

Function Wins.GetkHor;
Var I,J,LK,NK,_X1:Byte; K,BM,XM,YM,NB,NX,NY:Word;
    kStrLen:Byte Absolute kStr; _NotFScrX:Byte Absolute NotFullScrnX;

 Procedure PutBar(Color:Byte);
 Var XM,YM,_X1,Xa1,Xa2,Ya,I1:Byte; B:Word;
 Begin
  _X1 := GetRX1 + X + (I * JK);
  If Not((Color and $F0) = (XColrs.kSel and $F0))Then
   Video.PutKeyHori(_X1,GetRY1+Y,_X1+LK,SrchK(I,NK,kStr),XColrs.Key,XColrs.kShade)
   Else
  Begin
    Xa1 := _X1; Xa2 := (_X1+LK); Ya := GetRY1 + Y;
    __GetMouseTextSwitch(XM,YM,B);
    If(YM = Ya)Then
    Begin
     If(XM >= Xa1)and(XM <= Xa2)Then
     Begin
      If(IVid.Graf)Then
      Begin
       __HideMousePtr;
       Video.BarSelHor(Xa1,Ya,Xa2,Color);
       __ShowMousePtr;
      End
       Else
      If(XM = Xa1)Then
      Begin
       Video.SetAttr(Xa1,Ya,Not(Color));
       Video.BarSelHor(Xa1,Ya,Xa2,Color);
      End
       Else
      If(XM = Xa2)Then
      Begin
       Video.BarSelHor(Xa1,Ya,Xa2-_NotFScrX,Color);
       Video.SetAttr(Xa2,Ya,Not(Color));
      End
       Else
      Begin
       Video.BarSelHor(Xa1,Ya,XM-_NotFScrX,Color);
       Video.SetAttr(XM,Ya,Not(Color));
       Video.BarSelHor(XM+1,Ya,Xa2,Color);
      End;
      If(B = 1)Then
      Begin
       Repeat
	__GetMouseTextSwitch(XM,YM,B);
	If Not((XM >= Xa1)and(XM <= Xa2)and(YM = Ya))Then Exit;
       Until (B = 0);
       PushKey(kbEnter);
      End;
     End
      Else
     If(B = 1)Then
     Begin
      For I1 := 0 to NK do
      Begin
       _X1 := GetRX1 + X;
       If(XM >= _X1 + (I1 * JK))and(XM <= _X1 + (I1 * JK)+LK)Then
       Begin
	_X1 := GetRX1 + X + (I * JK);
	Video.PutKeyHori(_X1,GetRY1+Y,_X1+LK,SrchK(I,NK,kStr),XColrs.Key,XColrs.kShade);
	I := I1; _X1 := GetRX1 + X + (I * JK);
	Repeat
	 __GetMouseTextSwitch(XM,YM,B);
	 If Not((XM >= Xa1)and(XM <= Xa2)and(YM = Ya))Then Exit;
	Until (B = 0);
	PushKey(kbEnter);
	Video.BarSelHor(_X1,GetRY1+Y,_X1+LK,XColrs.kSel);
	Break;
       End;
      End;
     End;
    End
     Else
    Video.BarSelHor(_X1,GetRY1+Y,_X1+LK,Color);
  End;
 End;

Begin
 LK := JK - 3; NK := 0; _X1 := GetRX1 + X;
 For I := 1 to kStrLen do If(kStr[I] = '|')Then Inc(NK);
 For I := 0 to NK do
  Video.PutKeyHori(_X1 + (I * JK),GetRY1+Y,_X1 + (I * JK)+LK,SrchK(I,NK,kStr),XColrs.Key,XColrs.kShade);
 I := 0;
 Repeat
  _InitKbd;
  __ShowMousePtr;
  Repeat
   _BackKbd;
   Case (Mem[_0040:$6C] and $F) of
     0 : PutBar(XColrs.kSel);
     4 : PutBar((XColrs.kSel and $F0) + Yellow);
     8 : PutBar((XColrs.kSel and $F0) + LightBlue);
    12 : PutBar((XColrs.kSel and $F0) + LightGreen);
   End;
  Until KeyPressed;
   __HideMousePtr;
  PutBar(XColrs.kSel);
  K := Readk;
  Case K of
    kbF1 : Begin GetkHor := 253; Exit; End;
   kbTab : Begin
	    PutBar(XColrs.Key);
	    If(I < NK)Then Inc(I) else  Begin GetkHor := 254; Exit; End;
	    PutBar(XColrs.kSel);
	   End;
   kbEsc : Begin GetkHor := 255; Exit; End;
  kbLeft : If(NK > 0)Then
	   Begin
	    PutBar(XColrs.Key);
	    If(I > 0)Then Dec(I) else I := NK;
	    PutBar(XColrs.kSel);
	   End;
 kbRight : If(NK > 0)Then
	   Begin
	    PutBar(XColrs.Key);
	    If(I < NK)Then Inc(I) else I := 0;
	    PutBar(XColrs.kSel);
	   End;
  End;
 Until (K = kbEnter);
 GetkHor := I;
End;

Procedure Wins.PutkHorO;
Var ML,I,L,NK:Byte; kLen:Byte Absolute k;
Begin
 ML := 0; L := 0; NK := 0;
 For I := 1 to kLen do
 Begin
  If(k[I] = '|')Then
  Begin
   If(L > ML)Then ML := L;
   Inc(NK); L := 0;
  End
   else
  If Not(k[I] in ['^','~'])Then Inc(L);
 End;
 If(L > ML)Then ML := L;
 Inc(ML,4); If(ML < 8)Then ML := 8;
 PutkHor(((RX2-RX1-(((NK+1)*ML) - 2)) shr 1),Y,ML,k);
End;

Function Wins.GetkHorO;
Var ML,I,L,_K,NK:Byte; kLen:Byte Absolute k;
Begin
 ML := 0; L := 0; NK := 0;
 For I := 1 to kLen do
 Begin
  If(k[I] = '|')Then
  Begin
   If(L > ML)Then ML := L;
   Inc(NK); L := 0;
  End
   else
  If Not(k[I] in ['^','~'])Then Inc(L);
 End;
 If(L > ML)Then ML := L;
 Inc(ML,4);
 If(ML < 8)Then ML := 8;
 _K := GetkHor(((RX2-RX1-(((NK+1)*ML) - 2)) shr 1),Y,ML,k);
 Case _K of
  253 : GetkHorO := kbF1;
  254 : GetkHorO := kbTab;
  255 : GetkHorO := kbEsc
   else GetkHorO := _K;
 End;
End;

Procedure Wins.PutkHorDn;
Begin
 PutkHorO(MaxYTxts-1,Key);
End;

Function Wins.GetkHorDn;
Begin
 GetkHorDn := GetkHorO(MaxYTxts-1,k);
End;

Procedure Wins.ScrollLeft;
Var _X1 : Byte;
Begin
 If(X2 > MaxXTxts)Then X2 := MaxXTxts;
 If(Y2 > MaxYTxts)Then Y2 := MaxYTxts;
 _X1 := GetRX1 + X1;
 MoveText(_X1+N,GetRY1+Y1,GetRX1+X2,GetRY1+Y2,_X1,GetRY1+Y1);
End;

Procedure Wins.ScrollRight;
Var __Y1 : Byte;
Begin
 If(X2 > MaxXTxts)Then X2 := MaxXTxts;
 If(Y2 > MaxYTxts)Then Y2 := MaxYTxts;
 __Y1 := GetRY1 + Y1;
 MoveText(GetRX1+X1,__Y1,GetRX1+X2-N,GetRY1+Y2,GetRX1+X1+N,__Y1);
End;

Function Wins.InWn;
Begin
 InWn := ((X >= GetRX1)and(X <= GetRX1 + MaxXTxts)and(Y >= GetRY1)and(Y <= GetRY1 + MaxYTxts));
End;

Function Wins.InCloseIcon;
Begin
 InCloseIcon := (_CloseIcon)and(Y = RY1)and(X >= RX1)and(X <= (RX1+Length(GetCloseIcon^)-1));
End;

Procedure Wins.SetTitle;
Var Len,_X : Byte;
Begin
 If(NotFullScrnY)Then
 Begin
  If(_CloseIcon)Then Len := Length(GetCloseIcon^) Else Len := 0;
  RTitle := Title;
  BarSpaceHori(RX1,RY1,RX2,Color);
  If(Length(Title) > RX2-RX1)Then _X := RX1 Else _X := RX1+(RX2-RX1+1-Length(Title)) shr 1;
  If(IVid.Graf)Then
  Begin
   Video.BarSpaceHoriRelief(RX1+Len,RY1,RX2,Color);
   Video.PutTextXYT(_X,RY1,RTitle,Color);
  End
   Else
  Video.PutTextXY(_X,RY1,CopyStr(RTitle,1,RX2-RX1+1),Color);
  If(_CloseIcon)Then CloseIcon;
 End;
End;

Procedure Wins.SetEndBar;
Begin
 Video.BarSpaceHori(RX1,RY2,RX2,Attr);
End;

Procedure Wins.SetEndBarTxtX;
Begin
 If(RX1 + X > RX2)Then Exit;
 If(RX1 + X + Length(Str) > RX2)Then Str[0] := Char(RX2 - X - RX1 + 1);
 Video.PutTextXY(RX1+X,RY2,Str,Attr);
End;

Function Wins.Inp;
Begin
 Video.SetNorColor(XColrs.Sel);
 Inp := Dials.Input(GetRealX,GetRealY,GetRX1+MaxXTxts,MaxLen,Str);
End;

Procedure Wins.SetY;
Var YMax : Byte;
Begin
 YMax := MaxYTxts;
 If(Y > YMax)Then RY := YMax Else RY := Y;
End;

Procedure Wins.SetPos;
Begin
 RX := X; RY := Y;
End;

Procedure Wins.ClrScr;
Begin
 Video.ClrWn(GetRX1,GetRY1,GetRX1+MaxXTxts,GetRY1+MaxYTxts,RColr);
 RX := 0; RY := 0;
End;

Procedure Wins.ClrEol;
Begin
 If(RX <= MaxXTxts)Then BarSpcHor(RX,RY,MaxXTxts);
End;

Procedure Wins.Ln;
Begin
 Inc(RY); RX := 0;
End;

Procedure Wins._HL;
Begin
 RX := 0;
End;

Procedure Wins._LL;
Begin
 RY := MaxYTxts;
End;

Function Wins.XIsOut:Bool;
Begin
 XIsOut := (RX > MaxXTxts);
End;

Function Wins.YIsOut:Bool;
Begin
 YIsOut := (RY > MaxYTxts);
End;

Procedure Wins._Left;
Begin
 If(RX > 0)Then Dec(RX);
End;

Procedure Wins._Right;
Begin
 If(RX < MaxXTxts)Then Inc(RX)
  Else
 Begin
  RX := 0;
  _Dn;
 End;
End;

Procedure Wins._Dn;
Begin
 If(RY < MaxYTxts)Then Inc(RY);
End;

Procedure Wins._Up;
Begin
 If(RY > 0)Then Dec(RY);
End;

Procedure Wins.PutCube;
Begin
 SetCube(RX,RY,Chr);
End;

Procedure Wins.Background;
Begin
 RColr := (RColr and $F) + (Attr shl 4);
End;

Procedure Wins.Foreground;
Begin
 RColr := (RColr and $F8) + Attr;
End;

Procedure Wins.Dn;
Var I : Byte;
Begin
 For I := 1 to N do _Dn;
End;

Procedure Wins.Up;
Var I : Byte;
Begin
 For I := 1 to N do _Up;
End;

Procedure Wins.Left;
Var I : Byte;
Begin
 For I := 1 to N do _Left;
End;

Procedure Wins.Right;
Var I : Byte;
Begin
 For I := 1 to N do _Right;
End;

Procedure Wins._Ln;
Begin
 Ln;
 If(YIsOut)Then
 Begin
  _LL;
  _ScrollDn;
  ClrEol;
 End;
End;

Function Wins.GetRealY:Byte;
Begin
 GetRealY := GetRY1 + RY;
End;

Function Wins.GetRealX:Byte;
Begin
 GetRealX := GetRX1 + RX;
End;

Procedure Wins.CloseIcon;
Begin
 If(NotFullScrnY)Then
 Begin
  Video.PutCloseIcon(RX1,RY1,XColrs.Icon);
  _CloseIcon := True;
 End;
End;

Procedure Wins.ZoomIcon;
Begin
 If(NotFullScrnY)Then
  Video.PutTextXY(RX2-Length(Video.GetZoomIcon^)+1,RY1,Video.GetZoomIcon^,XColrs.Icon);
End;

Procedure Wins.SetKr;
Begin
 RColr := Colr;
End;

Procedure Wins.SetKrSel;
Begin
 RColr := XColrs.Sel;
End;

Procedure Wins.SetKrSelF;
Begin
 RColr := (XColrs.Sel and $F0) + F;
End;

Procedure Wins.SetKrBorderF;
Begin
 RColr := (XColrs.Border and $F0) + F;
End;

Procedure Wins.PutMsg;
Var _NotFScrX : Byte Absolute NotFullScrnX;
    _NotFScrY : Byte Absolute NotFullScrnY;
Begin
 Video.PutMsg(GetRealX,GetRealY,RX2-_NotFScrX,Msg,RColr);
 Inc(RY,Video.GetNumLineMsg(GetRealX,RX2-_NotFScrX,Msg)+_NotFScrY);
End;

Procedure Wins.PutTxt;
Begin
 PutTxtXY(RX,RY,Msg);
End;

Procedure Wins.PutPTxt;
Begin
 PutPTxtXY(RX,RY,Msg);
End;

Procedure Wins.PutPTxtLn;
Begin
 PutPTxt(Msg);
 Ln;
End;

Procedure Wins.PutTyping;
Begin
 Video.PutTypingXY(GetRealX,GetRealY,Msg);
End;

Procedure Wins.PutTxtXY;
Var _X,_Y,_XM:Byte; MsgLen:Byte Absolute Msg;
Begin
 _XM := MaxXTxts;
 If(X > _XM)or(Y > MaxYTxts)Then Exit;
 _X := GetRX1 + X; _Y := GetRY1 + Y;
 If((X + MsgLen) > (_XM + 1))Then
 Begin
  MsgLen := _XM - X;
  Case Matrix of
   _6x6 : PutTxt6x6(X,Y,Msg,RColr);
     Else Video.PutTextXY(_X,_Y,Msg,RColr);
  End;
 End
  Else
 Case Matrix of
  _6x6 : PutTxt6x6(X,Y,Msg,RColr);
    Else Video.PutTextXY(_X,_Y,Msg,RColr);
 End;
 RX := X + MsgLen; RY := Y;
End;

Procedure Wins.PutTxtXYU;
Var _X,_Y,_XM:Byte; MsgLen:Byte Absolute Msg;
Begin
 _XM := MaxXTxts;
 If(X > _XM)or(Y > MaxYTxts)Then Exit;
 _X := GetRX1 + X; _Y := GetRY1 + Y;
 If((X + MsgLen) > (_XM + 1))Then
 Begin
  MsgLen := _XM - X;
  Case Matrix of
   _6x6 : PutTxt6x6(X,Y,Msg,RColr);
     Else Video.PutTextXYUnCol(_X,_Y,Msg);
  End;
 End
  Else
 Case Matrix of
  _6x6 : PutTxt6x6(X,Y,Msg,RColr);
    Else Video.PutTextXYUnCol(_X,_Y,Msg);
 End;
 RX := X + MsgLen; RY := Y;
End;

Procedure Wins.PutPTxtXY;
Var _X,_Y,_XM : Byte;
    I         : Word;
Begin
 RX := X; RY := Y;
 If(Msg = NIL)Then Exit;
 _XM := MaxXTxts;
 If(X > _XM)or(Y > MaxYTxts)Then Exit;
 _X := GetRX1 + X; _Y := GetRY1 + Y;
 For I := 0 to _XM-X do
 Begin
  If(Msg[I] = #0)Then
  Begin
   RX := X + I;
   Exit;
  End;
  Case Matrix of
   _6x6 : PutTxt6x6(X+I,Y,Msg[I],RColr);
     Else Video.SetCube(_X+I,_Y,Msg[I],RColr);
  End;
 End;
 RX := _XM;
End;

Procedure Wins.PutPTxtXY2;
Var _X,_Y,_XM : Byte;
    I         : Word;
Begin
 _XM := MaxXTxts;
 If(X > _XM)or(Y > MaxYTxts)Then Exit;
 _X := GetRX1 + X; _Y := GetRY1 + Y;
 For I := 0 to S do If(Msg[I] = #0)Then
 Begin
  RX := X;
  Exit;
 End;
 For I := S to _XM-X do
 Begin
  If(Msg[I] = #0)Then
  Begin
   RX := X + I - S;
   Exit;
  End;
  Case Matrix of
   _6x6 : PutTxt6x6(X+I-S,Y,Msg[I],RColr);
     Else Video.SetCube(_X+I-S,_Y,Msg[I],RColr);
  End;
 End;
 RX := X + I - S;
End;

Procedure Wins.PutPTxtXYAtChr;
Var _X,_Y,_XM : Byte;
    I         : Word;
Begin
 RX := X; RY := Y;
 If(Msg = NIL)Then Exit;
 _XM := MaxXTxts;
 If(X > _XM)or(Y > MaxYTxts)Then Exit;
 _X := GetRX1 + X; _Y := GetRY1 + Y;
 For I := 0 to _XM-X do
 Begin
  If(Msg[I] = #0)or(Msg[I] = Chr)Then
  Begin
   RX := X + I;
   Exit;
  End;
  Case Matrix of
   _6x6 : PutTxt6x6(X+I,Y,Msg[I],RColr);
     Else Video.SetCube(_X+I,_Y,Msg[I],RColr);
  End;
 End;
 RX := X + I;
End;

Procedure Wins.PutTxtLn;
Begin
 PutTxtXY(RX,RY,Msg);
 RX := 0; Inc(RY);
End;

Procedure Wins.PutOTxt;
Var MsgLen : Byte Absolute Msg;
Begin
 PutTxtXY((RX2-RX1+1-MsgLen) shr 1,RY,Msg);
 RX := 0; Inc(RY);
End;

Procedure Wins.PutOTxtU;
Var MsgLen : Byte Absolute Msg;
Begin
 Video.PutTextXYUnCol(GetRX1+(RX2-RX1+1-MsgLen) shr 1,GetRY1+RY,Msg);
 RX := 0; Inc(RY);
End;

Procedure Wins.SetAttr;
Begin
 Case Matrix of
  _6x6 : PutTxt6x6(X,Y,' ',Attr);
    Else Video.SetAttr(GetRX1+X,GetRY1+Y,Attr);
 End;
End;

Procedure Wins.SetChr;
Begin
 Case Matrix of
  _6x6 : PutTxt6x6(X,Y,Chr,GetAttr(GetRX1+X,GetRY1+Y));
    Else Video.SetChar(GetRX1+X,GetRY1+Y,Chr);
 End;
End;

Procedure Wins.SetCube;
Begin
 If(X <= MaxXTxts)Then
 Case Matrix of
  _6x6 : PutTxt6x6(X,Y,Chr,RColr);
    Else Video.SetCube(GetRX1+X,GetRY1+Y,Chr,RColr);
 End;
 RX := X + 1; RY := Y;
End;

Procedure Wins.PutChrGAttr;
Begin
 If(RX > MaxXTxts)or(RY > MaxYTxts)Then Exit;
 Case Matrix of
  _6x6 : PutTxt6x6(RX,RY,Chr,RColr);
    Else Video.PutCharGAttr(GetRX1+RX,GetRY1+RY,Chr,RColr,GAttr);
 End;
 _Right;
 If((GAttr and $10) = $10)Then _Right;
End;

Procedure Wins.ScrollUp;
Var XM,YM:Byte;
Begin
 XM := MaxXTxts; YM := MaxYTxts;
 If(X2 > XM)Then X2 := XM;
 If(Y2 > YM)Then Y2 := YM;
 MoveText(GetRX1+X1,GetRY1+Y1,GetRX1+X2,GetRY1+Y2-1,GetRX1+X1,GetRY1+Y1+1);
End;

Procedure Wins.ScrollDn;
Var XM,YM:Byte;
Begin
 XM := MaxXTxts; YM := MaxYTxts;
 If(X2 > XM)Then X2 := XM;
 If(Y2 > YM)Then Y2 := YM;
 MoveText(GetRX1+X1,GetRY1+Y1+1,GetRX1+X2,GetRY1+Y2,GetRX1+X1,GetRY1+Y1);
End;

Function Wins.MaxXTxts;
Var X:Byte; _NotFScrX:Byte Absolute NotFullScrnX;
Begin
 X := RX2 - (RX1+(2*_NotFScrX))-((Byte(BarMouseRight)*Length(GetUpIcon^))-
      _NotFScrX*Byte(BarMouseRight));
 Case Matrix of
  _6x6 : MaxXTxts := (X * 8) div 6;
    Else MaxXTxts := X;
 End;
End;

Function Wins.MaxYTxts;
Var Y:Byte; _NotFScrY:Byte Absolute NotFullScrnY;
Begin
 Y := RY2 - (RY1+(2*_NotFScrY));
 Case Matrix of
  _6x6 : MaxYTxts := (Y * IVid.HeightChr) div 6;
    Else MaxYTxts := Y;
 End;
End;

Procedure Wins._ScrollDn;
Var MY : Byte;
Begin
 MY := MaxYTxts;
 MoveText(GetRX1,GetRY1+1,GetRX1+MaxXTxts,GetRY1+MY,GetRX1,GetRY1);
 RY := MY; RX := 0;
End;

Procedure Wins._ScrollUp;
Var _NotFScrY : Byte Absolute NotFullScrnY;
Begin
 MoveText(GetRX1,GetRY1,GetRX1+MaxXTxts,RY2-_NotFScrY-1,GetRX1,GetRY1+1);
 RY := 0; RX := 0;
End;

Procedure Wins.BarSpcHor;
Var GX1,GY1 : Word;
Begin
 If(Y > MaxYTxts)Then Exit;
 Case Matrix of
  _6x6 : Begin
	  GX1 := GetRX1 * 8; GY1 := GetRY1 * IVid.HeightChr;
	  PutFillBox(GX1+X1*6,GY1+Y*6,GX1+(X2*6)+5,GY1+(Y*6)+5,RColr shr 4);
	 End;
    Else Video.BarSpaceHori(GetRX1+X1,GetRY1+Y,GetRX1+X2,RColr);
 End;
End;

Procedure Wins.BarSpcHorShade;
Begin
 If(Y > MaxYTxts)Then Exit;
 Video.BarSpaceHoriShade(GetRX1+X1,GetRY1+Y,GetRX1+X2,RColr,XColrs.kShade);
End;

Procedure Wins.BarSelHor;
Var XM:Byte;
Begin
 If(Y > MaxYTxts)Then Exit;
 XM := MaxXTxts; If(X2 > XM)Then X2 := XM;
 Video.BarSelHor(GetRX1+X1,GetRY1+Y,GetRX1+X2,RColr);
End;

Procedure Wins._SetCube;
Begin
 If(Y > MaxYTxts)Then Exit;
 If(X <= MaxXTxts)Then
 Begin
  Case Matrix of
   _6x6 : PutTxt6x6(X,Y,Chr,Attr);
     Else Video.SetCube(GetRX1+X,GetRY1+Y,Chr,Attr);
  End;
 End;
 RX := X + 1; RY := Y;
End;

Procedure Wins.ClrWn;
Var XM,YM,XH,YH : Byte;
Begin
 XM := MaxXTxts; YM := MaxYTxts;
 If(Y1 > YM)Then Exit;
 If(X2 > XM)Then X2 := XM;
 If(Y2 > YM)Then Y2 := YM;
 XH := GetRX1; YH := GetRY1;
 Video.ClrWn(XH+X1,YH+Y1,XH+X2,YH+Y2,Attr);
End;

Procedure Wins.ClrWnBorder;
Begin
 ClrWn(X1,Y1,X2,Y2,XColrs.Border);
End;

Procedure Wins.SetCurPos;
Begin
 Cursor.SetCursorPos(GetRX1+X,GetRY1+Y);
End;

Function Wins.GetStr;
Var S:String; I:Byte; C:Char;
Begin
 S := '';
 For I := 1 to Wins.MaxXTxts do
 Begin
  C := Video.GetChar(GetRX1+X+I-1,GetRY1+Y);
  If(C = #0)Then Break;
  IncStr(S,C);
 End;
 GetStr := S;
End;

Destructor Wins.Done;
Begin
 PopWn;
End;

Constructor WnImg.SetWnTxt(X1,Y1,X2,Y2:Byte);
Begin
 XMove := 0; YMove := 0; BInit := False; SGX1 := (X1 * 8);
 SGY1 := (Y1 * GetHeightChar); SGX2 := ((X2 + 1) * 8) - 1;
 SGY2 := ((Y2 + 1) * GetHeightChar) - 1; SGXM := (SGX2 - SGX1);
 SGYM := (SGY2 - SGY1); DrawX := SGXM shr 1; DrawY := SGYM shr 1;
 DrawS := 4; CurrColor := $F;
End;

Constructor WnImg.Init;
Var S : Long;
Begin
 XMove := 0; YMove := 0; Struct := Inf; CurrColor := $F;
 With Inf do
 Begin
  H.Init;
  S := Long(Struct.NmXPixs) * Long(Struct.NmYPixs);
  Case BitsPerPix of
    1 : S := S shr 3;
 2..4 : S := S shr 1;
9..16 : S := S shl 1;
  End;
  BInit := H.SetSize(S); SGX1 := (X1 * 8); SGY1 := (Y1 * GetHeightChar);
  SGX2 := ((X2 + 1) * 8) - 1; SGY2 := ((Y2 + 1) * GetHeightChar) - 1;
  SGXM := (SGX2 - SGX1); SGYM := (SGY2 - SGY1); DrawX := SGXM shr 1;
  DrawY := SGYM shr 1; DrawS := 4;
  Video.ClrWn(X1,Y1,X2,Y2,(BaseColor shl 4));
 End;
End;

Procedure WnImg.PutTTextXY;
Var Mtx : ^TByte; _BH,I,J,K,Masque : Byte; _ES,_BP:Word;
Begin
 Case Height of
   8..10 : _BH := $03;
  13..14 : _BH := $02;
  15..16 : _BH := $06;
 End;
 ASM
  MOV AX,$1130;
  MOV BH,_BH;
  PUSH BP;
   INT $10;
   MOV BX,BP;
  POP BP;
  MOV _BP,BX;
  MOV _ES,ES;
 END;
 Mtx := Ptr(_ES,_BP);
 For J := 0 to Length(S)-1 do For I := 0 to Height-1 do
 Begin
  Masque := Mtx^[(Height*Byte(S[J+1]))+I];
  For K := 0 to 7 do
  Begin
   If(Masque and 128 <> 0)Then PutPixel((X+J)*8+K,Y*Height+I);
   Masque := Masque shl 1;
  End;
 End;
End;

Procedure WnImg.MoveWn;
Var XBuf:Pointer; X2M,J:Word;
Begin
 XBuf := MemAlloc(Struct.NmXPixs);
 If(XBuf = NIL)Then Exit;
 XMove := X; YMove := Y;
 If(SGX1 + Struct.NmXPixs < SGX2)Then X2M := SGX1 + Struct.NmXPixs - 1
				 Else X2M := SGX2;
 For J := 0 to SGYM do
 Begin
  H.GetRec(YMove+J,Struct.NmXPixs,XBuf^);
  PutLineHoriImg(SGX1,SGY1+J,X2M,Struct.BitsPerPix,XBuf^);
 End;
 FreeMem(XBuf,Struct.NmXPixs);
End;

Function WnImg.XMoveWn;
Begin
 XMoveWn := XMove;
End;

Function WnImg.YMoveWn;
Begin
 YMoveWn := YMove;
End;

Procedure WnImg.MoveWnX;
Begin
 MoveWn(X,YMove);
End;

Procedure WnImg.MoveWnY;
Begin
 MoveWn(XMove,Y);
End;

Function WnImg.IsInit;
Begin
 IsInit := BInit;
End;

Procedure WnImg.SetColor;
Begin
 CurrColor := Color;
End;

Procedure WnImg.Draw;
Var I:Byte; N:String; Mode:(_None_,_NoTrace_,_UnMove_); a,b:Word;

 Function ExtractNm:Int;
 Var N:String; a,b:Int;
 Begin
  N := '';
  While (StrI(I,S) in ['0'..'9']) do
  Begin
   IncStr(N,S[I]); Inc(I);
  End;
  If(N = '')Then a := 1 Else Val(N,a,b);
  ExtractNm := a;
 End;

 Function ExtractNmV:Int;
 Begin
  ExtractNmV := ExtractNm * (DrawS div 4);
 End;

 Procedure SetPos(X,Y:Int);
 Begin
  If Not(Mode = _UnMove_)Then  Begin DrawX := X; DrawY := Y; End;
  Mode := _None_;
 End;

Begin
 I := 1; Mode := _None_;
 While (I <= Length(S)) do
 Begin
  Case StrI(I,S) of
    'B' : Begin Inc(I); Mode := _NoTrace_; End;
    'C' : Begin Inc(I); CurrColor := ExtractNm; End;
    'D' : Begin
	   Inc(I); a := ExtractNmV;
	   If(Mode <> _NoTrace_)Then PutLine(DrawX,DrawY,DrawX,DrawY+a);
	   SetPos(DrawX,DrawY+a);
	  End;
    'E' : Begin
	   Inc(I); a := ExtractNmV;
	   If(Mode <> _NoTrace_)Then PutLine(DrawX,DrawY,DrawX+a,DrawY-a);
	   SetPos(DrawX+a,DrawY-a);
	  End;
    'F' : Begin
	   Inc(I); a := ExtractNmV;
	   If(Mode <> _NoTrace_)Then PutLine(DrawX,DrawY,DrawX+a,DrawY+a);
	   SetPos(DrawX+a,DrawY+a);
	  End;
    'G' : Begin
	   Inc(I); a := ExtractNmV;
	   If(Mode <> _NoTrace_)Then PutLine(DrawX,DrawY,DrawX-a,DrawY+a);
	   SetPos(DrawX-a,DrawY+a);
	  End;
    'H' : Begin
	   Inc(I); a := ExtractNmV;
	   If(Mode <> _NoTrace_)Then PutLine(DrawX,DrawY,DrawX-a,DrawY-a);
	   SetPos(DrawX-a,DrawY-a);
	  End;
    'L' : Begin
	   Inc(I); a := ExtractNmV;
	   If(Mode <> _NoTrace_)Then PutLine(DrawX,DrawY,DrawX-a,DrawY);
	   SetPos(DrawX-a,DrawY);
	  End;
    'M' : Begin
	   Inc(I); a := ExtractNm;
	   If(StrI(I,S) = ',')Then Begin Inc(I); b := ExtractNm; End
			      Else b := DrawY;
	   If(Mode <> _NoTrace_)Then PutLine(DrawX,DrawY,a,b);
	   SetPos(a,b);
	  End;
    'N' : Begin
	   Inc(I); Mode := _UnMove_;
	  End;
    'R' : Begin
	   Inc(I); a := ExtractNmV;
	   If(Mode <> _NoTrace_)Then PutLine(DrawX,DrawY,DrawX+a,DrawY);
	   SetPos(DrawX+a,DrawY);
	  End;
    'U' : Begin
	   Inc(I); a := ExtractNmV;
	   If(Mode <> _NoTrace_)Then PutLine(DrawX,DrawY,DrawX,DrawY-a);
	   SetPos(DrawX,DrawY-a);
	  End;
 ' ',';': Inc(I);
     Else Break;
  End;
 End;
End;

Procedure WnImg.PutFillBox;
Var P:^TByte; S,I:Word; F:Long;
Begin
 If(IsInit)Then
 Begin
  If(X1 > X2)Then SwapWord(X1,X2);
  If(Y1 > Y2)Then SwapWord(Y1,Y2);
  If(BInit)Then Case Struct.BitsPerPix of
       1 : Begin
	    P := MemAlloc(Struct.NmXPixs shr 3);
	    If(P = NIL)Then Exit;
	    For I := Y1 to Y2 do
	    Begin
	     H.SetPos((Struct.NmXPixs shr 3)*I);
	     H._GetRec(S,P^);
	     FillBoolAt(P^,X1,(X2-X1)+1,Bool(CurrColor));
	     H.SetPos((Struct.NmXPixs shr 3)*I);
	     H._SetRec(S,P^);
	    End;
	    FreeMem(P,Struct.NmXPixs shr 3);
	   End;
    2..4 : Begin
	    S := ((X2 - X1) + 1); P := MemAlloc(S);
	    If(P = NIL)Then Exit;
	    FillChar(P^,S shr 1,CurrColor + (CurrColor shl 4));
	    For I := Y1 to Y2 do
	    Begin
	     F := ((Long(I) * Long(Struct.NmXPixs)) + Long(X1));
	     H.SetPos(F shr 1);
	     H._SetRec(S shr 1,P^);
	     _4SetPixel(F + Long(S-1),CurrColor);
	     Inc(F,Struct.NmXPixs shr 1);
	    End;
	    FreeMem(P,S);
	   End;
    5..8 : Begin
	    S := (X2 - X1) + 1; P := MemAlloc(S);
	    If(P = NIL)Then Exit;
	    FillChar(P^,S,CurrColor);
	    For I := Y1 to Y2 do
	    Begin
	     F := ((Long(YMove+I) * Long(Struct.NmXPixs)) + Long(XMove+X1));
	     H.SetPos(F);
	     H._SetRec(S,P^);
	     Inc(F,Struct.NmXPixs);
	    End;
	    FreeMem(P,S);
	   End;
   9..16 : Begin
	    S := ((X2 - X1) + 1) shl 1; P := MemAlloc(S);
	    If(P = NIL)Then Exit;
	    FillWord(P^,S shl 1,CurrColor);
	    For I := Y1 to Y2 do
	    Begin
	     F := ((Long(I) * Long(Struct.NmXPixs)) + Long(X1));
	     H.SetPos(F shl 1);
	     H._SetRec(S,P^);
	     Inc(F,Struct.NmXPixs shl 1);
	    End;
	    FreeMem(P,S);
	   End;
  End;
  If((Y1 < SGYM)and(X1 < SGXM))Then
  Begin
   If(X2 > SGXM)Then X2 := SGXM;
   If(Y2 > SGYM)Then Y2 := SGYM;
   Video.PutFillBox(SGX1+X1,SGY1+Y1,SGX1+X2,SGY1+Y2,CurrColor);
  End;
 End;
End;

Procedure WnImg.PutLnHor;
Begin
 PutFillBox(X1,Y,X2,Y);
End;

Procedure WnImg.PutLine;
Var D,DX,DY,Aincr,Bincr,Xincr,Yincr,X,Y:Int;
Begin
 If((X2-X1) < Y2-Y1)Then
 Begin
  If(Y1 > Y2)Then
  Begin
   SwapWord(X1,X2);
   SwapWord(Y1,Y2);
  End;
  If(X2 > X1)Then XIncr := 1 Else XIncr := -1;
  DY := Y2 - Y1; DX := X2-X1; D := 2 * DX - DY; Aincr := 2 * (DX - DY);
  Bincr := DX shl 1; X := X1; Y := Y1;
  SetPixel(X,Y,CurrColor);
  For Y := Y1+1 to Y2 do
  Begin
   If(D >= 0)Then Begin Inc(X,Xincr); Inc(D,Aincr); End
             else Inc(D,Bincr);
   SetPixel(X,Y,CurrColor);
  End;
 End
  else
 Begin
  If(X1 > X2)Then
  Begin
   SwapWord(X1,X2);
   SwapWord(Y1,Y2);
  End;
  If(Y2 > Y1)Then YIncr := 1 else YIncr := -1;
  DX := (X2 - X1); DY := abs(Y2-Y1); D := 2 * DY - DX; AIncr := (DY - DX) shl 1;
  BIncr := (DY shl 1); X := X1; Y := Y1;
  SetPixel(X,Y,CurrColor);
  For X := X1 + 1 to X2 do
  Begin
   If(D >= 0)Then Begin Inc(Y,Yincr); Inc(D,Aincr); End
             else Inc(D,Bincr);
   SetPixel(X,Y,CurrColor);
  End;
 End;
End;

Procedure WnImg.PutPixel;
Begin
 SetPixel(X,Y,CurrColor);
End;

Procedure WnImg._1SetPixel;
Var C : Byte;
Begin
 H.GetRec(Formule shr 3,SizeOf(Byte),C);
 Color := C and Not(1 shl (Formule and 7));
 H.GetRec(Formule shr 3,SizeOf(Byte),Color);
End;

Procedure WnImg._4SetPixel;
Var C : Byte;
Begin
 H.GetRec(Formule shr 1,SizeOf(Byte),C);
 If((Formule and 1) = 1)Then Color := C and $F0	Else Color := C and $F;
 H.SetRec(Formule shr 1,SizeOf(Byte),Color);
End;

Procedure WnImg.SetPixel;
Var F:Long; C:Byte;
Begin
 If(BInit)Then
 Begin
  F := (Long(YMove+Y) * Long(Struct.NmXPixs)) + Long(XMove+X);
  Case Struct.BitsPerPix of
       1 : _1SetPixel(F,Color);
    2..4 : _4SetPixel(F,Color);
    5..8 : H.SetRec(F,SizeOf(Byte),Color);
   9..16 : H.SetRec(F,SizeOf(Word),Color);
  End;
 End;
 If((X < SGXM)and(Y < SGYM))Then Video.SetPixel(SGX1+X,SGY1+Y,Color);
End;

Procedure WnImg.UpDateLn;
Var XBuf:Pointer; X2M:Word;
Begin
 If(BInit)Then
 Begin
  XBuf := MemAlloc(Struct.NmXPixs);
  If(XBuf = NIL)Then Exit;
  H.GetRec(YMove+Y,Struct.NmXPixs,XBuf);
  If(SGX1 + Struct.NmXPixs < SGX2)Then X2M := SGX1 + Struct.NmXPixs - 1
				  Else X2M := SGX2;
  PutLineHoriImg(SGX1,SGY1+Y,X2M,Struct.BitsPerPix,XBuf);
  FreeMem(XBuf,Struct.NmXPixs);
 End;
End;

Procedure WnImg.CopyAllLn;
Var PBuffer : ^TByte Absolute XBuf; X2M : Word;
Begin
 Case Struct.BitsPerPix of
  5..8 : Begin
	  If(BInit)Then H.SetRec(Y,Struct.NmXPixs,XBuf);
	  If Not(SGY1+Y > SGY2)Then
	  Begin
	   If(SGX1 + Struct.NmXPixs < SGX2)Then X2M := SGX1 + Struct.NmXPixs - 1
					   Else X2M := SGX2;
	   CardVideo.PutLineHoriImg(SGX1,SGY1+Y,X2M,Struct.BitsPerPix,XBuf);
	  End;
	 End;
 End;
End;

Procedure WnImg.CopyAllLnNoUpDate;
Begin
 Case Struct.BitsPerPix of
  5..8 : H.SetRec(Y,Struct.NmXPixs,XBuf);
 End;
End;

Function WnImg.GetPixel;
Var Z:Byte; W:Word; F:Long;
Begin
 If(BInit)Then
 Begin
  F := (Long(Y) * Long(Struct.NmXPixs)) + Long(X);
  Case Struct.BitsPerPix of
      1 : Begin
	   H.GetRec(F shr 3,SizeOf(Byte),Z);
	   GetPixel := Z and (1 shl (F and 7));
	  End;
   2..4 : Begin
	   H.GetRec(F shr 1,SizeOf(Byte),Z);
	   If((F and 1) = 1)Then GetPixel := Z shr 4 Else GetPixel := Z and $F;
	  End;
   5..8 : Begin
	   H.GetRec(F,SizeOf(Byte),Z);
	   GetPixel := Z;
	  End;
  9..16 : Begin
	   H.GetRec(F,SizeOf(Word),W);
	   GetPixel := W;
	  End;
  End;
 End;
End;

Destructor WnImg.Done;
Begin
 H.Done;
End;

BEGIN
END.