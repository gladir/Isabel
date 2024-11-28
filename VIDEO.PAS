{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                           ³
 ³             Malte Genesis/Module Centrale du Vid‚o        ³
 ³                Edition Isabel pour Mode R‚el              ³
 ³                      III - Version 1.0                    ³
 ³                         1995/02/02                        ³
 ³                                                           ³
 ³       Copyright (C) par les Chevaliers de Malte           ³
 ³                                                           ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Video;

INTERFACE

{$B-,E+,I-,N+,Q-,R-,S-,X+}

Uses Dos,Math,Keyboard,LibVideo,Systems,Memorys;

Const

      _TextBW40 = 0;
      _TextC40 = 1;
      _TextC40x25 = _TextC40;
      _TextC40x28 = $1257;
      _TextC40x43 = $1258;
      _TextC40x50 = $1259;
      _TextBW80 = 2;
      _TextC80 = 3;
      _TextC80x25 = _TextC80;
      _TextC80x28 = $1260;
      _TextC80x30 = $1261;
      _TextC80x33 = $1262;
      _TextC80x34 = $1263;
      _TextC80x43 = $1264;
      _TextC80x50 = $1265;
      _TextC80x60 = $1266;
      _TextC80x66 = $1267;
      _TextC100x30 = $1268;
      _TextC100x37 = $1269;
      _TextC100x40 = $126A;
      _TextC100x50 = $1270;
      _TextC100x60 = $1271;
      _TextC100x75 = $1272;
      _TextC120x25 = $1273;
      _TextC120x43 = $1274;
      _TextC132 = $1275;
      _TextC132x25 = _TextC132;
      _TextC132x28 = $1276;
      _TextC132x30 = $1277;
      _TextC132x43 = $1278;
      _TextC132x44 = $1279;
      _TextC132x50 = $1280;
      _TextC132x60 = $1281;
      _TextC160x50 = $1282;
      _TextMono = 7;
      _TextMono80x25 = _TextMono;
      _TextMono80x28 = $1283;
      _TextMono80x43 = $1284;
      _TextMono80x50 = $1285;
      _TextMono132x25 = $1286;
      _TextMono132x28 = $1287;
      _TextMono132x43 = $1288;
      _TextMono132x44 = $1289;
      _Hercule = $128A;
      _MinColorMode320x200 = $128B;
      _MaxColorMode320x200 = $128C;
      _Graph240x128c2 = $1290;
      _Graph320x200c4 = 5;
      _Graph320x200c16 = 13;
      _Graph320x200c256 = 19;
      _Graph320x200C32768 = $1291;
      _Graph320x200C65536 = $1292;
      _Graph320x400c256 = $1293;
      _Graph360x480c256 = $1294;
      _Graph512x512c16 = $1295;
      _Graph512x512c256 = $1296;
      _MinColorMode640x200 = 6;
      _MaxColorMode640x200 = $1297;
      _Graph640x200c2 = 6;
      _Graph640x200c4 = 10;
      _Graph640x200c16 = 14;
      _MinColorMode640x350 = $1298;
      _MaxColorMode640x350 = $1299;
      _Graph640x350c4 = $1300;
      _Graph640x350c16 = $1301;
      _Graph640x350c256 = $1302;
      _Graph640x350c32768 = $1303;
      _MinColorMode640x400 = $1304;
      _MaxColorMode640x400 = $1305;
      _Graph640x400c2 = $1306;
      _Graph640x400c16 = $1307;
      _Graph640x400c256 = $1308;
      _Graph640x400c32768 = $1309;
      _Graph640x462c16 = $130A;
      _MinColorMode640x480 = 17;
      _MaxColorMode640x480 = $130B;
      _Graph640x480c2 = 17;
      _Graph640x480c16 = $1310;
      _Graph640x480c256 = $1311;
      _Graph640x480c32768 = $1312;
      _Graph720x350c2 = $1313;
      _Graph720x392c16 = $1314;
      _Graph720x512c16 = $1315;
      _Graph720x512c256 = $1316;
      _Graph720x540c16 = $1317;
      _Graph720x540c256 = $1318;
      _Graph752x410c16 = $1319;
      _Graph768x1024c16 = $1320;
      _Graph800x560c16 = $1321;
      _MinColorMode800x600 = $1322;
      _MaxColorMode800x600 = $1323;
      _Graph800x600c2 = $1324;
      _Graph800x600c16 = $1325;
      _Graph800x600c256 = $1326;
      _Graph800x600c32768 = $1327;
      _Graph960x720c16 = $1328;
      _MinColorMode1024x768 = $1329;
      _MaxColorMode1024x768 = $1330;
      _Graph1024x768c2 = $1331;
      _Graph1024x768c4 = $1332;
      _Graph1024x768c16 = $1333;
      _Graph1024x768c256 = $1334;
      _Graph1024x768c32768 = $1135;
      _TextDefault = $1336; { 80x25 Color or Mono }
      _TextMaxRes80 = $1337;
      _TextMaxRes = $1338;
      _NoMode = $FFFE;

      KeyHelp = $01;
      KeyOk = $02;
      KeyCancel = $04;
      KeyYes = $08;
      KeyNo = $10;
      KeyRetry = $20;
      KeyAbort = $40;
      KeyIgnore = $80;
      KeyDefault = $100;

      __Help__ = KeyHelp;
      __Ok__ = KeyOk;
      __Cancel__ = KeyCancel;
      __Yes__ = KeyYes;
      __No__ = KeyNo;
      __Retry__ = KeyRetry;
      __Abort__ = KeyAbort;
      __Ignore__ = KeyIgnore;
      __Default__ = KeyDefault;

      kbPrgOutWin = $E700;
      kbPrgLastBar = $E800;
      kbPrgMnuBar = $E900;
      kbPrgTitle = $EA00;
      kbPrgCloseIcon = $EB00;
      kbDnBar = $EC00;
      kbDnBarMs = $ED00;
      kbRightBarMsPgUp = $EE00;
      kbRightBarMsPgDn = $EF00;
      kbRightBarMsUp = $FFF0;
      kbRightBarMsDn = $FFF1;
      kbRightBarMs = $FFF2;
      kbInWn = $FFF3;
      kbDefault = $FFF4;
      kbHelp = $FFF6;
      kbOk = kbEnter;
      kbCancel = kbEsc;
      kbYes = kbEnter;
      kbNo = kbEsc;
      kbIgnore = $FFF7;
      kbRetry = $FFF9;
      kbAbort = $FFF8;
      kbClose = $FFFA;
      kbCloseWin = $FFFA;
      kbExit = $FFFB;
      kbTitle = $FFFC;
      kbZoom = $FFFD;
      kbMouse = $FFFE;
      kbUnknown = $FFFF;

      MaxWin = $FF;

      Black = 0;
      Blue = 1;
      Green = 2;
      Cyan = 3;
      Red = 4;
      Magenta = 5;
      Brown = 6;
      LightGray = 7;
      DarkGray = 8;
      LightBlue = 9;
      LightGreen = 10;
      LightCyan = 11;
      LightRed = 12;
      LightMagenta = 13;
      Yellow = 14;
      White = 15;

      WinType : (Robotic,Normal) = Normal;

Type

     VideoModeType = (__None__,__Text__,__Graph__,__Two__);

     PointType = Record
      X,Y:Int;
     End;

     MatrixType = (Default,_6x6);

     CenterType = (__Left__,__Justified__,__Right__);

     BorderType = Array[0..7] of Char;

     InfoVid = Record
      Mode,Seg:Word;
      Colr,Graf:Bool;
      BitsPerPixel:Byte;
      NmColrs:Long;
      NmXPixels,NmYPixels:Word;
      NmXTxts,NmYTxts,HeightChr,CurrPage:Byte;
      Shade,SpcBorder:Bool;
      LastColr,NorColr:Byte;
     End;

     RGB = Record
      R,G,B:Byte;
     End;

     PaletteMode = Array[0..127] of Word;

     PaletteModeRec = Record
      Mode:Word; AccesMode,CodeMode:Byte;
     End;

     Palette16RGB = Array[0..15] of RGB;

     Palette256RGB = Array[0..255] of RGB;

     MtxInputColors = Record
      Border,Title,Msg,KeyActif,KeyUnactif,KeyShade:Byte;
     End;

Var

    ModeInfVid:PresInfVidMode;
    IVid:PresInfVidMode Absolute ModeInfVid;
    CurBuf:^TByte;
    CurBufSize,CurrCube:Word;
    CurBorder:BorderType;
    DirectVideo:Bool;
    _PVid1,_PVid2:PhysicalInfoVideo;

Procedure BarCharHori(X1,Y,X2:Byte;Chr:Char);
Procedure BarCharVert(X,Y1,Y2:Byte;Chr:Char);
Procedure BarSelHor(X1,Y,X2,Attr:Byte);
Procedure BarSelVer(X,Y1,Y2,Attr:Byte);
Procedure BarSpaceHori(X1,Y,X2,Attr:Byte);
Procedure BarSpaceHoriRelief(X1,Y,X2,Attr:Byte);
Procedure BarSpaceHoriShade(X1,Y,X2,Attr,BackAttr:Byte);
Procedure BarSpaceVert(X,Y1,Y2,Attr:Byte);
Procedure BarTextHori(X1,Y,X2:Byte;Chr:Char;Attr:Byte);
Procedure BarTextVert(X,Y1,Y2:Byte;Chr:Char;Attr:Byte);
Procedure Circle(X,Y,Rayon:Int;Color:Word);
Procedure ClearLine(Y:Byte;Chr:Char;Attr:Byte);
Procedure ClearScreenBlack;
Procedure ClearScreen(Attr:Byte);
Procedure ClrWn(X1,Y1,X2,Y2,Attr:Byte);
Procedure Copy8Bin(X,Y:Word;Value,Fore,Back:Byte);
Procedure CopyBox(X1,Y1,X2,Y2:Byte;Var Buffer);
Procedure DoneLuxeVideo;
Procedure DrawPoly(Num:Word;Var _PointType;Color:Word);
Procedure FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Attr:Byte);
Procedure GetBorder(Var Border:BorderType);
Procedure GetCenterText(L,H:Byte;Var X1,Y1,X2,Y2:Byte);
Procedure GetPaletteRGB(Var Palette:RGB;Start,Num:Word);
Procedure InitVideo;
Procedure InitVideoDeluxe;
Procedure MoveText(X1,Y1,X2,Y2,X3,Y3:Byte);
Procedure PopScr(Var M:MemSwp);
Procedure PushScr(Var M:MemSwp);
Procedure PutBorderUncolor(X1,Y1,X2,Y2:Byte);
Procedure PutBox(X1,Y1,X2,Y2:Byte;Var Buffer);
Procedure PutCharGAttr(X,Y:Byte;Chr:Char;Attr,GAttr:Byte);
Procedure PutCloseIcon(X,Y,Attr:Byte);
Procedure PutDownIcon(X,Y,Attr:Byte);
Procedure PutPCharXY(X,Y:Byte;Str:PChar;Attr:Byte);
Procedure PutFillBorder(X1,Y1,X2,Y2,Attr:Byte);
Procedure PutFillBox(X1,Y1,X2,Y2:Int;Color:Word);
Procedure PutFillCircle(X,Y,Rayon:Int;Color:Word);
Procedure PutKeyHori(X1,Y,X2:Byte;Msg:String;Attr,Shade:Byte);
Procedure PutLine(X1,Y1,X2,Y2:Int;Color:Word);
Procedure PutLineHori(X1,Y,X2:Int;Color:Word);
Procedure PutMsg(X1,Y1,X2:Byte;Msg:String;Attr:Byte);
Procedure PutMsgTyping(X1,Y1,X2:Byte;Msg:String);
Procedure PutRect(X1,Y1,X2,Y2,Color:Int);
Procedure PutRotateRect(X1,Y1,X2,Y2,Color:Int);
Procedure PutRoundRect(X1,Y1,X2,Y2,B,Color:Int);
Procedure PutTextCenter(Y:Byte;Center:CenterType;Msg:String;Attr:Byte);
Procedure PutTextXY(X,Y:Byte;Str:String;Attr:Byte);
Procedure PutTextXYT(X,Y:Byte;Str:String;Attr:Byte);
Procedure PutTextXYUnCol(X,Y:Byte;Str:String);
Procedure PutTyping(Msg:String);
Procedure PutTypingXY(X,Y:Byte;Msg:String);
Procedure PutUpIcon(X,Y,Attr:Byte);
Procedure QuickInitVideo(Reset:Bool);
Procedure ScrollDown(X1,Y1,X2,Y2,Attr:Byte);
Procedure ScrollUp(X1,Y1,X2,Y2,Attr:Byte);
Procedure SetAddress(Segment:Word);
Procedure SetAllColor(Last,New:Byte);
Procedure SetAngle(Angle:Int);
Procedure SetAttr(X,Y,Attr:Byte);
Procedure SetBlink(X:Bool);
Procedure SetBorderDouble;
Procedure SetBorderLuxe;
Procedure SetBorderSimple;
Procedure SetBorderSimpleLuxe;
Procedure SetChar(X,Y:Byte;Chr:Char);
Procedure SetCheckSVGA(X:Bool);
Procedure SetCube(X,Y:Byte;Chr:Char;Attr:Byte);
Procedure SetMatrix(Palette,Height:Byte;Number,Start:Word;Var Buffer);
Procedure SetNorColor(Color:Byte);
Procedure SetPaletteRGB(Var P:RGB;Start,Num:Word);
Procedure SetPage(Page:Byte);
Procedure SetPixel(X,Y:Int;C:Word);
Procedure SetPos(X,Y:Byte);
Procedure SetShade(X:Bool);
Procedure SetSpace(X,Y,Attr:Byte);
Procedure SetVideoCard(Card:Byte);
Procedure _BarSelectHori(X1,Y,X2:Byte);
Procedure _Circle(X,Y,Rayon:Int);
Procedure _Down;
Procedure _Left;
Procedure _Line(X1,Y1,X2,Y2:Int);
Procedure _Line2(X,Y:Int);
Procedure _LineHori(X1,Y,X2:Int);
Procedure _Move2(X,Y:Int);
Procedure _PutFillCircle(X,Y,Rayon:Int);
Procedure _PutPCharXY(X,Y:Byte;Str:PChar);
Procedure _PutRotateRect(X1,Y1,X2,Y2:Int);
Procedure _PutTextXY(X,Y:Byte;Msg:String);
Procedure _Right;
Procedure _SetChar(Chr:Char);
Procedure _SetColor(Color:Word);
Procedure _SetCube(Chr:Char);
Procedure _Up;
Procedure __BarSpaceHori(X1,Y,X2,Background,Foreground:Byte);
Procedure __PutFillBorder(X1,Y1,X2,Y2,Background,Foreground:Byte);
Procedure __PutTextCenter(Y:Byte;Center:CenterType;Msg:String;BG,FG:Byte);
Procedure __PutTextXY(X,Y:Byte;Msg:String;BG,FG:Byte);
Procedure __SetAllColor(LastBG,LastFG,NewBG,NewFG:Byte);

Function GetAttr(X,Y:Byte):Byte;
Function GetBitsPerPixel:Byte;
Function GetChar(X,Y:Byte):Char;
Function GetCloseIcon:PString;
Function GetCube(X,Y:Byte):Word;
Function GetCurrPage:Byte;
Function GetDownIcon:PString;
Function GetHeightChar:Byte;
Function GetInfo(Var Info:InfoVid):Bool;
Function GetLastColor:Byte;
Function GetLeftIcon:PString;
Function GetMaxPalette:Word;
Function GetMaxXPixels:Word;
Function GetMaxYPixels:Word;
Function GetNorColor:Byte;
Function GetNumLineMsg(X1,X2:Byte;Msg:String):Byte;
Function GetNumColor:Long;
Function GetNumXPixels:Word;
Function GetNumXTexts:Byte;
Function GetNumYPixels:Word;
Function GetNumYTexts:Byte;
Function GetPixel(X,Y:Int):Word;
Function GetRealSizeScreen:Long;
Function GetRightIcon:PString;
Function GetSelectIcon:PString;
Function GetSelectPage:Byte;
Function GetShade:Bool;
Function GetString(X,Y,Len:Byte):String;
Function GetUnSelectIcon:PString;
Function GetUpIcon:PString;
Function GetVideoAddress:Word;
Function GetVideoCard:Byte;
Function GetVideoMemKb:Word;
Function GetVideoMemory:Long;
Function GetVideoMonitor:Byte;
Function GetVideoMode:Byte;
Function GetVideoPort:Word;
Function GetWordFormuleXY(X,Y:Word):Long;
Function GetZoomIcon:PString;
Function IsColor:Bool;
Function IsDirect:Bool;
Function IsGraf:Bool;
Function IsInitVideoData:Bool;
Function IsMCGA:Bool;
Function IsMonochrome:Bool;
Function IsSVGA:Bool;
Function IsVGA:Bool;
Function LoadPaletteRGB(Path:PathStr):Bool;
Function MaxXTxts:Byte;
Function MaxYTxts:Byte;
Function SavePaletteRGB(Path:PathStr):Bool;
Function SetVideoMode(Mode:Word):Bool;
Function SetVideoModeDeluxe(Mode:Word):Bool;
Function SizeBox(X1,Y1,X2,Y2:Byte):Long;

IMPLEMENTATION

Uses Dials,CardVideo,Cursor,Strs,Strings,Mems,RLL;

Procedure BarSpaceHori256(X1,Y,X2,Attr:Byte); Forward;
Procedure PutTxtLuxe(X,Y:Byte;S:String;Attr:Byte); Forward;

Const

      _Init:Bool = False;
      RGBFileHeader:PChar = 'P:RGB-MG1.0' + #26;

Type

     StrIcon = String[7];

Var


     UnselectIcon,SelectIcon,CloseIcon:StrIcon;
     CloseIconLen:Byte Absolute CloseIcon;
     ZoomIcon,LeftIcon,RightIcon,UpIcon,DownIcon:StrIcon;
     NorColor,LastColor:Byte;
     TBufSize:Word;
     _Angle,_LineWidth:Int;
     GraphColor:Word;

Procedure BarSpaceHori;
Begin
 MainData^.BarSpcHori(X1,Y,X2,Attr);
 If(IVid.Graf)Then
  FillWord(MainData^.TBuffer^[(Y*IVid.NmXTxts)+X1],X2-X1+1,Byte(' ')+Attr shl 8);
End;

Procedure ClrWn;
Var J:Byte;
Begin
 MainData^.ClrWn(X1,Y1,X2,Y2,Attr);
 If(IVid.Graf)Then
 Begin
  For J := Y1 to Y2 do
   FillWord(MainData^.TBuffer^[(J*IVid.NmXTxts)+X1],X2-X1+1,Byte(' ')+Attr shl 8);
 End;
End;

Procedure Copy8Bin(X,Y:Word;Value,Fore,Back:Byte);
Begin
 MainData^.Copy8Bin(X,Y,Value,Fore,Back);
End;

Procedure FillBox;
Begin
 MainData^.FillBox(X1,Y1,X2,Y2,Chr,Attr);
End;

Function GetAttr;
Begin
 GetAttr := MainData^.GetAttr(X,Y);
End;

Function GetChar;
Begin
 GetChar := MainData^.GetChar(X,Y);
End;

Function GetCube;
Begin
 GetCube := MainData^.GetCube(X,Y);
End;

Function GetPixel;
Begin
 GetPixel := MainData^.GetPixel(X,Y);
End;

Function IsGraf;
Begin
 IsGraf := IVid1^.Graf;
End;

Procedure PutFillBox;
Begin
 MainData^.PutFillBox(X1,Y1,X2,Y2,Color);
End;

Procedure PutTextXY;
Begin
 MainData^.PutTextXY(X,Y,Str,Attr);
End;

Procedure PutTextXYUnCol;
Begin
 MainData^.PutTextXYUnCol(X,Y,Str);
End;

Procedure SetAttr;
Begin
 MainData^.SetAttr(X,Y,Attr);
End;

Procedure SetChar;
Begin
 MainData^.SetChar(X,Y,Chr);
End;

Procedure SetCube;
Begin
 MainData^.SetCube(X,Y,Chr,Attr);
End;

Procedure SetPixel;
Begin
 MainData^.SetPixel(X,Y,C);
End;

Procedure SetDefaultIcon;
Begin
 UnselectIcon := '( )'; SelectIcon := '(' + #7 + ')'; CloseIcon := ' - ';
 ZoomIcon := ' ' + #31 + ' '; LeftIcon := '<'; RightIcon := '>';
 UpIcon := #$18; DownIcon := #$19;
End;

Procedure SetDefaultGraphIcon;
Begin
 UnselectIcon := #19+#20; SelectIcon := #21+#22; CloseIcon := #8+#9;
 ZoomIcon := #12+#13; UpIcon := #10+#11; DownIcon := #12+#13;
 LeftIcon := #17+#9; RightIcon := #8+#16;
End;

Function GetNumLineMsg(X1,X2:Byte;Msg:String):Byte;
Var XS,a,b,I:Byte;
Begin
 XS := (X2 - X1) + 1; b := 0; a := 0;
 While ((Length(Msg) - a) >= XS) do
 Begin
  I := a + XS;
  While (((Msg[I-1] > ' ')and(Not(Msg[I-1] = '-')))and(I > a)) do Dec(I);
  a := I - 1; Inc(b);
 End;
 GetNumLineMsg := (b + 1);
End;

Procedure PutMsg(X1,Y1,X2:Byte;Msg:String;Attr:Byte);
Var XS, AX, AY, I, J : Byte;
Begin
 XS := (X2-X1)+1; AY := Y1; AX := 0;
 While ((Length(Msg) - AX) >= XS) do
 Begin
  I := AX + XS;
  While (((Msg[I-1] > ' ')and(Not(Msg[I-1] = '-')))and(I > AX)) do Dec(I);
  For J := AX to I-2 do SetCube(X1+J-AX,AY,Msg[J+1],Attr);
  AX := J+1; Inc(AY);
 End;
 For J := AX to Length(Msg)-1 do SetCube(X1+J-AX,AY,Msg[J+1],Attr);
End;

Procedure PutMsgTyping(X1,Y1,X2:Byte;Msg:String);
Var XS, AX, AY, I, NC : Byte;
Begin
 XS := (X2-X1)+2; AY := Y1; AX := 0;
 While ((Length(Msg) - AX) >= XS) do
 Begin
  I := AX + XS; NC := 0;
  While ((Not(Msg[I-1] in [#0..' ','-','|']))and((I-NC) > AX)) do
  Begin
   If(Msg[I] = '^')Then Inc(NC);
   Dec(I);
  End;
  PutTypingXY(X1,AY,Copy(Msg,AX,I-2-Succ(AX)));
  AX := I; Inc(AY);
 End;
 PutTypingXY(X1,AY,Copy(Msg,AX,Length(Msg)-Succ(AX)));
End;

Procedure PutKeyHori(X1,Y,X2:Byte;Msg:String;Attr,Shade:Byte);
Begin
 Video.BarSpaceHoriShade(X1,Y,X2,Attr,Shade);
 PutTextXY(X1+1+((X2-X1-Length(Msg)) shr 1),Y,Msg,Attr);
End;

Procedure BarCharHori;
Var I : Byte;
Begin
 For I := X1 to X2 do SetChar(I,Y,Chr);
End;

Procedure BarCharVert;
Var J : Byte;
Begin
 For J := Y1 to Y2 do SetChar(X,J,Chr);
End;

Procedure BarSelHor;
Var I : Byte;
Begin
 For I := X1 to X2 do SetAttr(I,Y,Attr);
End;

Procedure BarSelVer;
Var J : Byte;
Begin
 For J := Y1 to Y2 do SetAttr(X,J,Attr);
End;

Procedure BarSpaceHori256(X1,Y,X2,Attr:Byte);
Begin
 PutFillBox(X1*8,Y * IVid.HeightChr,X2*8 + 7,((Y+1) * IVid.HeightChr) - 1,Attr);
 FillWord(MainData^.TBuffer^[(Y*IVid.NmXTxts)+X1],X2-X1+1,Byte(' ')+Attr shl 8);
End;

Procedure BarSpaceHoriRelief(X1,Y,X2,Attr:Byte);
Var GX1,GY1,GX2,GY2 : Word;
Begin
 GX1 := X1 * 8; GY1 := Y * IVid.HeightChr; GX2 := (X2 * 8) + 7; GY2 := ((Y+1)*IVid.HeightChr)-1;
 Case Attr and $F0 of
  $B0 : _SetColor($F);
   Else _SetColor(7);
 End;
 _Line(GX1,GY1,GX1,GY2);
 If(IVid.NmXPixels >= 640)Then _Line(GX1+1,GY1,GX1+1,GY2);
 _LineHori(GX1,GY1,GX2);
 If(IVid.HeightChr > 8)Then _LineHori(GX1,GY1+1,GX2);
 Case Attr and $F0 of
  $B0 : _SetColor(3);
   Else _SetColor(8);
 End;
 If(IVid.NmXPixels >= 640)Then _Line(GX2-1,GY1+1,GX2-1,GY2);
 _Line(GX2,GY1+1,GX2,GY2);
 If(IVid.HeightChr > 8)Then _LineHori(GX1+1,GY2-1,GX2);
 _LineHori(GX1+1,GY2,GX2);
End;

Procedure BarSpaceHoriShade;
Begin
 BarSpaceHori(X1,Y,X2,Attr);
 SetCube(X2+1,Y,'Ü',BackAttr);
 Video.BarTextHori(X1+1,Y+1,X2+1,'ß',BackAttr);
End;

Procedure BarSpaceVert;
Var J : Byte;
Begin
 If(IVid.Graf)Then
 PutFillBox(X * 8,(Y1 * IVid.HeightChr),(X * 8) + 7,((Y2 + 1) * IVid.HeightChr) - 1,Attr shr 4)
  Else
 For J := Y1 to Y2 do SetCube(X,J,' ',Attr);
End;

Procedure BarTextHori;
Var I : Byte;
Begin
 For I := X1 to X2 do SetCube(I,Y,Chr,Attr);
End;

Procedure BarTextVert;
Var J : Byte;
Begin
 For J := Y1 to Y2 do SetCube(X,J,Chr,Attr);
End;

Procedure Circle;
Var _End,Step,I:Real; A,B:Int;
Begin
 If(IVid.Graf)Then
 Begin
  _End := (11 / 7); Step := _End / (Rayon shl 1); I := 0;
  Repeat
   A := Trunc(Cos(I) * Rayon); B := Trunc(Sin(I) * Rayon);
   SetPixel(X+A,Y+B,Color);
   SetPixel(X+A,Y-B,Color);
   SetPixel(X-A,Y+B,Color);
   SetPixel(X-A,Y-B,Color);
   I := I + Step;
  Until (I > _End);
 End;
End;

Procedure ClearLine;
Begin
 BarTextHori(0,Y,MaxXTxts,Chr,Attr);
End;

Procedure ClearScreen;
Begin
 Case IVid.Graf of
  False : ClrWn(0,0,MaxXTxts,MaxYTxts,Attr);
     Else PutFillBox(0,0,GetMaxXPixels,GetMaxYPixels,Attr shr 4);
 End;
End;

Procedure ClearScreenBlack;
Begin
 ClearScreen(LightGray);
End;

Procedure CopyBox;
Var J,XS,YS:Byte; DXS:Word; TBuffer:TByte Absolute Buffer;
Begin
 If Not(IVid.Graf)Then
 Begin
  If(DirectVideo)Then
  Begin
   XS := (X2 - X1) + 1; DXS := XS shl 1;
   If(Y2 = Y1)Then Move(Mem[IVid.SegV:IVid.AddrPg+((X1+(Y1*IVid.NmXTxts)) shl 1)],Buffer,DXS)
    else
   Begin
    YS := Y2 - Y1;
    For J := 0 to YS do
     Move(Mem[IVid.SegV:IVid.AddrPg+(X1+((Y1+J)*IVid.NmXTxts)) shl 1],TBuffer[((XS * J) shl 1)],DXS);
   End;
  End;
 End;
End;

Procedure DoneLuxeVideo;
Begin
 If(_PVid1.Font)Then Case IVid.HeightChr of
    8 : ASM
	 MOV AX,$1102;
	 MOV BL,0;
	 INT $10;
	END;
   16 : ASM
	 MOV AX,$1104;
	 MOV BL,0;
	 INT $10;
	END;
   Else ASM
	 MOV AX,$1101;
	 MOV BL,0;
	 INT $10;
	END;
 End;
 If(MemW[_0040:$63] = $3D4)Then SetVideoMode(_TextC80x25)
  Else
 ASM
  MOV AX,7;
  INT $10;
 END;
End;

Procedure DrawPoly;
Var P : Array[0..65520 div SizeOf(PointType)] of PointType Absolute _PointType;
    J : Int;
Begin
 For J := 0 to Num-1 do PutLine(P[J].X,P[J].Y,P[J+1].X,P[J+1].Y,Color);
 PutLine(P[0].X,P[0].Y,P[Num-1].X,P[Num-1].Y,Color);
End;

Procedure GetCenterText;
Begin
 X1 := (IVid.NmXTxts - L) shr 1; X2 := X1 + L; Y1 := (IVid.NmYTxts - H) shr 1; Y2 := Y1 + H;
End;

Function GetString;
Var I:Byte; S:String;
Begin
 S[0] := Char(Len);
 For I := 1 to Len do S[I] := MainData^.GetChar(X+I-1,Y);
 GetString := S;
End;

Function GetHeightChar;
Assembler;
ASM
 MOV AL,IVid.HeightChr;
END;

Function GetCloseIcon;
Begin
 GetCloseIcon := @CloseIcon;
End;

Function GetDownIcon;
Begin
 GetDownIcon := @DownIcon;
End;

Function GetLeftIcon;
Begin
 GetLeftIcon := @LeftIcon;
End;

Function GetRightIcon;
Begin
 GetRightIcon := @RightIcon;
End;

Function GetSelectIcon;
Begin
 GetSelectIcon := @SelectIcon;
End;

Function GetUnSelectIcon;
Begin
 GetUnselectIcon := @UnSelectIcon;
End;

Function GetUpIcon;
Begin
 GetUpIcon := @UpIcon;
End;

Function GetZoomIcon;
Begin
 GetZoomIcon := @ZoomIcon;
End;

Function GetInfo;
Begin
 Info.Mode := Mem[_0040:$49]; Info.Seg := IVid.SegV; Info.Colr := Yes; Info.Graf := Yes;
 Info.BitsPerPixel := IVid.BitsPerPixel; Info.NmColrs := IVid.NmColrs;
 Info.NmXPixels := IVid.NmXPixels; Info.NmYPixels := IVid.NmYPixels;
 Info.NmXTxts := IVid.NmXTxts; Info.NmYTxts := IVid.NmYTxts; Info.HeightChr := IVid.HeightChr;
 Info.CurrPage := 0; Info.Shade := VideoBankSwitch.Shade; Info.SpcBorder := False;
 Info.LastColr := LastColor; Info.NorColr := NorColor; GetInfo := True;
End;

Function GetBitsPerPixel;
Assembler;
ASM
 MOV AL,IVid.BitsPerPixel;
END;

Procedure GetBorder;
Assembler;
Const LenBorder = SizeOf(BorderType);
ASM
 LES DI,Border;
 CLD;
 PUSH DS;
  LDS SI,Border;
  {$IFDEF G+}
   MOV CX,LenBorder shr 1;
   REP MOVSW;
  {$ELSE}
   MOV CX,LenBorder;
   REP MOVSB;
  {$ENDIF}
 POP DS;
@@End:
END;

Function GetCurrPage;
Assembler;
ASM
 XOR AX,AX;
 MOV ES,AX;
 MOV AL,ES:[$044C];
END;

Function GetLastColor;
Assembler;
ASM
 MOV AL,LastColor;
END;

Function GetMaxPalette;
Assembler;
ASM
 MOV AX,Word Ptr IVid.NmColrs;
 DEC AX;
END;

Function GetMaxXPixels;
Assembler;
ASM
 MOV AX,IVid.NmXPixels;
 DEC AX;
END;

Function GetMaxYPixels;
Assembler;
ASM
 MOV AX,IVid.NmYPixels;
 DEC AX;
END;

Function MaxXTxts;
Assembler;
ASM
 CALL GetNumXTexts;
 DEC  AL;
END;

Function MaxYTxts;
Assembler;
ASM
 CALL GetNumYTexts;
 DEC  AL;
END;

Function GetNorColor;
Assembler;
ASM
 MOV AL,NorColor;
END;

Function GetNumColor;
Assembler;
ASM
 MOV AX,Word Ptr IVid.NmColrs;
 MOV DX,Word Ptr IVid.NmColrs[2];
END;

Function GetNumXPixels;
Assembler;
ASM
 MOV AX,IVid.NmXPixels;
END;

Function GetNumYPixels;
Assembler;
ASM
 MOV AX,IVid.NmYPixels;
END;

Function GetNumXTexts;
Assembler;
ASM
 MOV AL,IVid.NmXTxts;
END;

Function GetNumYTexts;
Assembler;
ASM
 MOV AL,IVid.NmYTxts;
END;

Function GetSelectPage;
Assembler;
ASM
 MOV AL,VideoBankSwitch.SelPg;
END;

Function GetShade;
Assembler;
ASM
 MOV AL,VideoBankSwitch.Shade;
END;

Function GetVideoPort;
Assembler;
ASM
 MOV AX,$FFFF;
 CMP DirectVideo,Byte(True);
 JNE @@End;
 XOR AX,AX;
 MOV ES,AX;
 MOV AX,ES:[$0463];
@@End:
END;

Procedure GetPaletteVGA(Var Palette:RGB;Start,Num:Word);
Assembler;
ASM
 MOV AX,$1017;
 LES DX,Palette;
 MOV BX,Start;
 MOV CX,Num;
 INT $10;
END;

Procedure GetPaletteRGB;
Type PaletteRec = Array[0..21000] of RGB;
Var PPal : PaletteRec Absolute Palette; I : Word;
Begin
 If(_PVid1.VGA)Then GetPaletteVGA(Palette,Start,Num) else
 If(IsMCGA)Then GetPaletteVGA(Palette,Start,Num);
 If Not(_PVid1.DacBits in [0,8])Then
 Begin
  For I := Start to Start + (Num - 1) do
  Begin
   PPal[I].R := PPal[I].R shl (8-_PVid1.DacBits);
   PPal[I].G := PPal[I].G shl (8-_PVid1.DacBits);
   PPal[I].B := PPal[I].B shl (8-_PVid1.DacBits);
  End;
 End;
End;

Function GetRealSizeScreen;
Assembler;
ASM
 CMP IVid.Graf,Byte(False);
 JE  @@TextSize;
@@Graphics:
 MOV AX,IVid.NmXPixels;
 MUL IVid.NmYPixels;
 MOV CL,IVid.BitsPerPixel;
 CMP Up32Bits,Byte(True);
 JE  @@32Bits;
 CMP CL,4;
 JE  @@4Bits;
 CMP CL,16;
 JE  @@16Bits;
 MOV AX,$FFFF;
 MOV DX,AX;
 JMP @@End;
@@32Bits:  { Processeur Intel 80386 ou post‚rieur }
  PUSH DX;           { PUSH DX     - 1 octet   }
  PUSH AX;           { PUSH AX     - 1 octet   }
  DB $66; POP AX;    { POP  EAX    - 2 octets  }
  DB $E9,$03;        { SHR  CL,3   - 2 octets  }
  DB $66; SHR AX,CL; { SHR  EAX,CL - 3 octets  }
  DB $66; PUSH AX;   { PUSH EAX    - 2 octets  }
  POP AX;            { POP  AX     - 1 octet   }
  POP DX;            { POP  DX     - 1 octet   }
  JMP @@End;                       { 13 octets }
@@4Bits:
  SHR AX,1;
  SHR DX,1;
  ADC AX,0;
  JMP @@End;
@@16Bits:
  SHL AX,1;
  ADC DX,0;
  SHL DX,1;
  JMP @@End;
@@TextSize:
  MOV AL,IVid.NmXTxts;
  MUL IVid.NmYTxts;
  SHL AX,1;
  XOR DX,DX;
@@End:
END;

Function GetVideoMemKb;
Begin
 If(_PVid1.Memory = 0)Then
 Begin
  If(VBiosAreaColor)Then GetVideoMemKb := 16 Else GetVideoMemKb := 4;
 End
  Else
 GetVideoMemKb := (_PVid1.Memory div 1024);
End;

Function GetVideoMemory;
Begin
 GetVideoMemory := _PVid1.Memory;
End;

Function GetVideoAddress;
Assembler;
ASM
 MOV AX,IVid.SegV;
END;

Function GetVideoCard;
Begin
 GetVideoCard := _PVid1.Card;
End;

Function GetVideoMonitor;
Assembler;
ASM
 MOV AL,_PVid1.Monitor;
END;

Function GetVideoMode;
Begin
 GetVideoMode := IVid.Mode;
End;

Function GetWordFormuleXY;
Begin
 With IVid do GetWordFormuleXY := Long((Long(NmXPixels) * Long(Y)) + Long(X));
End;

Procedure InitVideo;
Var SelBankPg:Procedure(Pg:Byte);
    Ptr:Pointer Absolute SelBankPg;
    InitVid:Procedure Absolute SelBankPg;
    SizeOf_:Word;
Begin
 If(_PVid1.Card = vdUnknown)Then LibVideo.GetVideoCard(_PVid1,_PVid2);
 SelBankPg := MainData^.SelBankPg;
 If Not(Ptr = NIL)Then FreeMem(Ptr,MainDataR.SizeOfProcSelBnkPg);
 Ptr := AllocMainFunc(_PVid1.ProcSelBnkPg,MainDataR.SizeOfProcSelBnkPg);
 If(Ptr = NIL)Then HaltOutOfMem;
 MainData^.SelBankPg := SelBankPg;
 If(IVid1^.ProcBarSpcHori = 0)Then
 Begin
  Ptr := AllocMainFunc(141,SizeOf_);
  InitVid;
  FreeMem(Ptr,SizeOf_);
 End;
 QuickInitVideo(True);
End;

Procedure InitVideoDeluxe;
Var Addr:Pointer; H:Byte; MCGA,VGA:Bool;
    Path:PathStr; SizeOf_:Word;
Begin
 InitVideo;
 If Not(IVid.Graf)Then
 Begin
  If(_PVid1.Font)Then
  Begin
   MCGA := IsMCGA; VGA := IsVGA;
   H := GetHeightChar; Path := SetPath4AddFile(StrPas(PathSystems))+'FONTS.*';
   Case H of
      8,9,10 : Addr := AllocFunc(1,Path,SizeOf_);
       13,14 : Addr := AllocFunc(2,Path,SizeOf_);
       15,16 : Addr := AllocFunc(3,Path,SizeOf_);
   End;
   If(H in [8..10,13..16])Then
   Begin
    If(MCGA)or(VGA)Then SetCharWidth(8);
    Case H of
      9,10 : SetMatrix(0,8,32,0,Addr^);
	13 : SetMatrix(0,14,32,0,Addr^);
	15 : SetMatrix(0,16,32,0,Addr^);
	Else SetMatrix(0,H,32,0,Addr^);
    End;
    SetBlink(False);
    If(MCGA)or(VGA)Then SetCharWidth(8);
    SetDefaultGraphIcon;
    SetBorderSimpleLuxe;
   End
    Else
   Begin
    SetBlink(False);
    SetDefaultIcon;
    SetBorderSimple;
   End;
   FreeMem(Addr,SizeOf_);
   CloseCursor;
  End
   Else
  Begin
   SetBlink(False);
   CloseCursor;
   SetDefaultIcon;
   SetBorderSimple;
  End;
 End
  Else
 Begin
  SetDefaultGraphIcon;
  SetBorderSimpleLuxe;
 End;
End;

Function IsColor;
Begin
 IsColor := IVid.Colr;
End;

Function IsDirect;
Assembler;
ASM
 MOV AL,DirectVideo;
END;

Function IsInitVideoData;
Assembler;
ASM
 MOV AL,_Init;
END;

Function IsMCGA;
Begin
 IsMCGA := (_PVid1.Card = vdMCGA);
End;

Function IsMonochrome;
Assembler;
ASM
 CALL IsColor;
 XOR  AL,1;
END;

Function IsSVGA;
Var Buffer : PhysicalInfoVideo;
Begin
 IsSVGA := (PVid1^.Card in [vdAhead,vdCardinal,vdCirrus,
	    vdCTI82C451,vdCTI82C452,vdEverex,vdEverexViewPoint,
	    vdEverexUltraGraphicsII,vdEverexVision,vdEverexEVGA,
	    vdGenoa,vdGenoa5100,vdGenoa5300,vdGenoa6100,vdGenoa6200,
	    vdGenoa6400,vdHeadLand,vdIBM8514A,vdITVGA2,vdOak,vdParadise,
	    vdParadisePVGA1A,vdParadiseWD90C00,vdParadiseWD90C10,
	    vdParadiseWD90C11,vdQuadramUltra,vdTIGA,vdTrident8800BR,
	    vdTrident8800CS,vdTrident8900,vdTsengET3000,vdTsengET4000,
	    vdTsengET4000HiColor,vdTsengET4000HiColorSC,vdVESA,vdVGA,
	    vdVGAWonder,vdVGAWonder_18800,vdVGAWonder_18800_1,
	    vdVGAWonder_28800_2,vdVGAWonder_28800_4,vdVGAWonder_28800_5,
	    vdVideo7,vdVideo7VEGA,vdVideo7Version5,vdVideo71024i,vdVideo7Vram,
	    vdXGA,vdZyMos]);
End;

Function IsVGA;
Begin
 IsVGA := _PVid1.VGA;
End;

Function LoadPaletteRGB;
Var Palette : Palette256RGB; Handle,J,HeaderSize : Word; Str : Array[0..255] of Char;
Begin
 LoadPaletteRGB := False;
 Handle := Systems.Open(Path,ReadOnly);
 If(IsHandleErr(Handle))Then Exit;
 HeaderSize := StrLen(RGBFileHeader);
 FillChar(Str,SizeOf(Str),Byte(#0));
 GetRec(Handle,0,HeaderSize,Str);
 If Not(RGBFileHeader = Str)Then Exit;
 For J := 0 to (IVid.NmColrs shr 8) do
 Begin
  GetRec(Handle,J,((IVid.NmColrs and $FF)+1),Palette);
  SetPaletteRGB(Palette[0],Long(HeaderSize)+(Long(J) * $100),(IVid.NmColrs and $FF));
 End;
 Close(Handle);
 LoadPaletteRGB := True;
End;

Procedure MoveText;
Var I,J,L,L2:Word;

 Procedure TextI;
 Begin
  Move(Mem[IVid.SegV:((Y1+I)*IVid.NmXTxts+X1) shl 1],Mem[IVid.SegV:((Y3+I)*IVid.NmXTxts+X3) shl 1],L)
 End;

 Procedure MoveB;
 Begin
  Move(MainData^.TBuffer^[(Y1+J)*IVid.NmXTxts+X1],MainData^.TBuffer^[(Y3+J)*IVid.NmXTxts+X3],L);
 End;

 Procedure GraphI;
 Begin
  Move(Mem[IVid.SegV:((((J+Y1)*8)+I)*320)+(X1*8)],Mem[IVid.SegV:((((J+Y3)*8)+I)*320)+(X3*8)],L2);
 End;

 Procedure Graph640x200c2;
 Var L1,L2,YL1,YL2:Word;
 Begin
  YL1 := ((J+Y1)*8)+I; L1 := ($2000 * (YL1 and 1)) + (80 * (YL1 shr 1)) + X1;
  YL2 := ((J+Y3)*8)+I; L2 := ($2000 * (YL2 and 1)) + (80 * (YL2 shr 1)) + X3;
  Move(Mem[IVid.SegV:L1],Mem[IVid.SegV:L2],L);
 End;

 Procedure GraphGS640x200c16;
 Var L1,L2,YL1,YL2:Word;
 Begin
  YL1 := ((J+Y1)*8)+I;
  L1 := (YL1 and 3) * $2000 + (X1 shr 2) + (YL1 shr 2) * 160;
  YL2 := ((J+Y3)*8)+I;
  L2 := (YL2 and 3) * $2000 + (X3 shr 2) + (YL2 shr 2) * 160;
  Move(Mem[$B000:L1],Mem[$B000:L2],L shl 1);
  Move(Mem[$B800:L1],Mem[$B800:L2],L shl 1);
 End;

 Procedure DefGraph;
 Var Attr:Byte; I:Word;
 Begin
  L := (X2-X1+1) shl 1; Attr := MainData^.TBuffer^[Y2*IVid.NmXTxts].Attr;
  If(Y3 < Y1)Then
  Begin
   For I := 0 to Y2-Y1 do
   Begin
    J := I;
    MoveB;
   End;
   ScrollDown(X1,Y3,X2,Y2,Attr);
  End
   Else
  Begin
   For I := Y2-Y1 downto 0 do
   Begin
    J := I;
    MoveB;
   End;
   ScrollUp(X1,Y1,X2,Y2+Y3-Y1,Attr);
  End;
 End;

Begin
 If(X2 < X1)or(Y2 < Y1)Then Exit;
 If Not(IVid.Graf)Then
 Begin
  L := Succ(X2 - X1) shl 1;
  With IVid do
  Begin
   If(Y3 < Y1)Then
   Begin
    If(X3 < X1)Then For I := 0 to Y2 - Y1 do TextI
	       Else For I := 0 to Y2 - Y1 do TextI;
   End
    else
   Begin
    If(X3 < X1)Then For I := Y2 - Y1 downto 0 do TextI
	       Else For I := Y2 - Y1 downto 0 do TextI;
   End;
  End;
 End
  Else
 Begin
  Case IVid.BitsPerPixel of
    1 : Case IVid.NmXPixels of
	 640 : Case IVid.NmYPixels of
		0..204 : Begin
			  L := (X2-X1+1) shl 1;
			  If(Y3 < Y1)Then
			  Begin
			   For J := 0 to Y2-Y1 do
			   Begin
			    MoveB;
			    For I := 0 to 7 do Graph640x200c2;
			   End;
			  End
			   Else
			  Begin
			   For J := Y2-Y1 downto 0 do
			   Begin
			    MoveB;
			    For I := 0 to 7 do Graph640x200c2;
			   End;
			  End;
			 End;
		    Else DefGraph;
	       End;
	  Else DefGraph;
	End;
    4 : Begin
	 If(_PVid1.Card = vdGS)Then
	 Begin
	  If(IVid.NmXPixels = 640)Then
	  Begin
	   L := (X2-X1+1) shl 1;
	   If(Y3 < Y1)Then
	   Begin
	    For J := 0 to Y2-Y1 do
	    Begin
	     MoveB;
	     For I := 0 to 7 do GraphGS640x200c16;
	    End;
	   End
	    Else
	   Begin
	    For J := Y2-Y1 downto 0 do
	    Begin
	     MoveB;
	     For I := 0 to 7 do GraphGS640x200c16;
	    End;
	   End;
	  End
	  Else
	  DefGraph;
	 End
	 Else DefGraph;
	End;
    8 : Case IVid.NmXPixels of
	 320 : Case IVid.NmYPixels of
		0..200 : Begin
			  L := (X2-X1+1) shl 1; L2 := L * 4;
			  If(Y3 < Y1)Then
			  Begin
			   For J := 0 to Y2-Y1 do
			   Begin
			    MoveB;
			    For I := 0 to 7 do GraphI;
			   End;
			  End
			   Else
			  Begin
			   For J := Y2-Y1 downto 0 do
			   Begin
			    MoveB;
			    For I := 0 to 7 do GraphI;
			   End;
			  End;
			 End;
		    Else DefGraph;
	       End;
	  Else DefGraph;
	End;
   Else DefGraph;
  End;
 End;
End;

Procedure PutBorderUncolor;
Begin
 BarCharVert(X1,Y1+1,Y2-1,CurBorder[3]);
 BarCharVert(X2,Y1+1,Y2-1,CurBorder[4]);
 BarCharHori(X1+1,Y1,X2-1,CurBorder[1]);
 BarCharHori(X1+1,Y2,X2-1,CurBorder[6]);
 SetChar(X1,Y1,CurBorder[0]);
 SetChar(X1,Y2,CurBorder[5]);
 SetChar(X2,Y1,CurBorder[2]);
 SetChar(X2,Y2,CurBorder[7]);
End;

Procedure PutBox;
Var J,XS,YS : Byte;
    DXS     : Word;
    TBuf    : Array[0..65520] of Byte Absolute Buffer;
Begin
 If Not(IVid.Graf)Then
 Begin
  If(DirectVideo)Then
  Begin
   XS := (X2 - X1) + 1; DXS := XS shl 1;
   If(Y2 = Y1)Then Move(Buffer,Mem[IVid.SegV:IVid.AddrPg+((X1+(Y1*IVid.NmXTxts)) shl 1)],DXS)
    else
   Begin
    YS := Y2 - Y1;
    For J := 0 to YS do
    Begin
     Move(TBuf[((XS * J) shl 1)],Mem[IVid.SegV:IVid.AddrPg+
	  ((X1+((Y1+J)*IVid.NmXTxts)) shl 1)],DXS);
    End;
   End;
  End;
 End;
End;

Procedure PutCharGAttr;
Var Bold,Underline,Italic,Inverse,Double : Bool;

 Procedure SetGCubeDouble(X,Y:Word;Chr:Char;Attr:Byte);
 Var I,K,Masque,_X,Base : Word; Fore,Back : Byte;
 Begin
  Fore := Attr and $F; Back := Attr shr 4;
  Base := (IVid.HeightChr*Byte(Chr));
  For I := 0 to IVid.HeightChr-1 do
  Begin
   Masque := IVid1^.TxtMtx^[Base+I];
   For K := 0 to 7 do
   Begin
    _X := X + (K shl 1);
    If(Masque and 128 <> 0)Then
    Begin
     SetPixel(_X,Y+I,Fore);
     SetPixel(_X + 1,Y+I,Fore);
    End
     Else
    Begin
     SetPixel(_X,Y+I,Back);
     SetPixel(_X + 1,Y+I,Back);
    End;
    Masque := Masque shl 1;
   End;
  End;
 End;

Begin
 Bold := ((GAttr and 1) = 1); Inverse := ((GAttr and 8) = 8);
 Underline := ((GAttr and 2) = 2); Italic := ((GAttr and 4) = 4);
 Double := ((GAttr and 16) = 16);
 If(IVid.Graf)Then
 Begin
  If(Double)Then
  Begin
   SetGCubeDouble(X*8,Y*IVid.HeightChr,Chr,(Attr and $F0)+$7+(Byte(Bold)*8));
   If(Underline)Then PutLineHori(X*8,((Y+1)*IVid.HeightChr)-2,(X*8)+15,Attr and $F);
  End
   Else
  Begin
   If(Bold)Then
   Begin
    MainData^.SetGCube(X*8+1,Y*IVid.HeightChr+1,Chr,(Attr and $F0)+$7);
    MainData^.SetGCubeT(X*8,Y*IVid.HeightChr,Chr,$F);
   End
    Else
   SetCube(X,Y,Chr,(Attr and $F0)+$7);
   If(Underline)Then PutLineHori(X*8,((Y+1)*IVid.HeightChr)-2,(X*8)+7,Attr and $F);
  End;
 End
  Else
 Begin
  If(Inverse)Then SetCube(X,Y,Chr,(Attr shl 4)+(GAttr and $F)) Else
  If(Bold)Then SetCube(X,Y,Chr,(Attr and $F0)+$F)
	  Else SetCube(X,Y,Chr,(Attr and $F0)+(GAttr and $7)+$7);
  If(Double)Then SetCube(X+1,Y,' ',(Attr and $F0)+(GAttr and $7)+$7);
 End;
End;

Procedure PutCloseIcon;
Begin
 If(IVid.Graf)Then Video.PutTxtLuxe(X,Y,CloseIcon,Attr)
              Else PutTextXY(X,Y,CloseIcon,Attr);
End;

Procedure PutLineHori;
Var I : Int;
Begin
 If(IVid.Graf)Then
 Begin
  Case IVid.BitsPerPixel of
    4 : If(PVid1^.Card = vdGS)Then For I := X1 to X2 do SetPixel(I,Y,Color)
			      Else PutFillBox(X1,Y,X2,Y,Color);
    8 : PutLineHoriSvga256(X1,Y,X2,Color);
   Else Begin { Par d‚faut, prendre une m‚thode lente, mais qui fonctionne. }
	 For I := X1 to X2 do SetPixel(I,Y,Color);
	End;
  End;
 End;
End;

Procedure PutUpIcon;
Begin
 If(IVid.Graf)Then Video.PutTxtLuxe(X,Y,UpIcon,Attr)
	      Else PutTextXY(X,Y,UpIcon,Attr);
End;

Procedure PutDownIcon;
Begin
 If(IVid.Graf)Then Video.PutTxtLuxe(X,Y,DownIcon,Attr)
              Else PutTextXY(X,Y,DownIcon,Attr);
End;

Procedure PutFillBorder;
Var I : Byte;
Begin
 If((X1 <> X2)and(Y1 <> Y2))Then
 Begin
  ClrWn(X1,Y1,X2,Y2,Attr);
  PutBorderUncolor(X1,Y1,X2,Y2);
  If(VideoBankSwitch.Shade)Then
  Begin
   If(X2 < IVid.NmXTxts)Then
   Begin
    If(Y2 > (IVid.NmYTxts-3))Then Dec(Y2) Else BarSelHor(X1+2,Y2+1,X2,7);
    If(X2 + 1 < IVid.NmXTxts)Then
    Begin
     BarSelVer(X2+1,Y1+1,Y2+1,7);
     If(X2 + 2 < IVid.NmXTxts)Then BarSelVer(X2+2,Y1+1,Y2+1,7);
    End;
   End;
  End;
 End;
End;

Procedure PutFillCircle;
Var _End,Step,I:Real; A,B:Int;
Begin
 If(IVid.Graf)Then
 Begin
  _End := (11 / 7); Step := _End / (Rayon shl 1); I := 0;
  Repeat
   A := Trunc(Cos(I) * Rayon); B := Trunc(Sin(I) * Rayon);
   PutLineHori(X-A,Y-B,X+A,Color);
   PutLineHori(X-A,Y+B,X+A,Color);
   I := I + Step;
  Until (I > _End);
 End;
End;

Procedure PutLine;
Var D,DX,DY,X,Y,Aincr,Bincr,Xincr,Yincr:Int;
Begin
 If(IVid.Graf)Then
 Begin
  If(Y2 = Y1)Then
  Begin
   PutLineHori(X1,Y1,X2,Color);
   Exit;
  End;
  If(abs(X2-X1) < abs(Y2-Y1))Then
  Begin
   If(Y1 > Y2)Then
   Begin
    SwapInt(X1,X2);
    SwapInt(Y1,Y2);
   End;
   If(X2 > X1)Then XIncr := 1 Else XIncr := -1;
   DY := Y2 - Y1; DX := Abs(X2-X1); D := 2 * DX - DY;
   Aincr := 2 * (DX - DY); Bincr := DX shl 1; X := X1; Y := Y1;
   SetPixel(X,Y,Color);
   For Y := Y1+1 to Y2 do
   Begin
    If(D >= 0)Then
    Begin
     Inc(X,Xincr); Inc(D,Aincr);
    End
     else
    Inc(D,Bincr);
    SetPixel(X,Y,Color);
   End;
  End
   else
  Begin
   If(X1 > X2)Then
   Begin
    SwapInt(X1,X2);
    SwapInt(Y1,Y2);
   End;
   If(Y2 > Y1)Then YIncr := 1 else YIncr := -1;
   DX := (X2 - X1); DY := Abs(Y2-Y1); D := 2 * DY - DX;
   AIncr := (DY - DX) shl 1; BIncr := (DY shl 1); X := X1; Y := Y1;
   SetPixel(X,Y,Color);
   For X := X1 + 1 to X2 do
   Begin
    If(D >= 0)Then
    Begin
     Inc(Y,Yincr); Inc(D,Aincr);
    End
     else
    Inc(D,Bincr);
    SetPixel(X,Y,Color);
   End;
  End;
 End;
End;

Procedure PutPCharXY;
Var I:Word;
Begin
 I := 0;
 While Not(Str[I] = #0) do
 Begin
  SetCube(X+I,Y,Str[I],Attr);
  Inc(I);
 End;
End;

Procedure PutRect;
Var J:Word;
Begin
 If(IVid.Graf)Then
 Begin
  PutLineHori(X1,Y1,X2,Color);
  For J := Y1+1 to Y2-1 do
  Begin
   SetPixel(X1,J,Color);
   SetPixel(X2,J,Color);
  End;
  PutLineHori(X1,Y2,X2,Color);
 End;
End;

Procedure PutRotateRect;
Var nx1,nx2,nx3,nx4,ny1,ny2,ny3,ny4,x1C,y1C,x2C,y2C,LineWidth2:Int;
    Angle,AngleCos,AngleSin,CosX1,SinX1,CosX2,SinX2:Real;
Begin
 Angle := 0.01745329 * (360 - _Angle); AngleCos := Cos(Angle); AngleSin := Sin(Angle);
 CosX1 := x1C * AngleCos; SinX1 := x1C * AngleSin; CosX2 := x2C * AngleCos; SinX2 := x2C * AngleSin;
 x1C := (x1 - VideoBankSwitch.XL); y1C := (y1 - VideoBankSwitch.YL);
 x2C := (x2 - VideoBankSwitch.XL); y2C := (y2 - VideoBankSwitch.YL);
 nx1 := Trunc(CosX1 - y1C * AngleSin + VideoBankSwitch.XL);
 ny1 := Trunc(SinX1 + y1C * AngleCos + VideoBankSwitch.YL);
 nx3 := Trunc(CosX2 - y2C * AngleSin + VideoBankSwitch.XL);
 ny3 := Trunc(SinX2 + y2C * AngleCos + VideoBankSwitch.YL);
 nx2 := Trunc(CosX2 - y2C * AngleSin + VideoBankSwitch.XL);
 ny2 := Trunc(SinX2 + y2C * AngleCos + VideoBankSwitch.YL);
 nx4 := Trunc(CosX1 - y1C * AngleSin + VideoBankSwitch.XL);
 ny4 := Trunc(SinX1 + y1C * AngleCos + VideoBankSwitch.YL);
 LineWidth2 := _LineWidth shr 1;
 PutLine(nx1-LineWidth2,ny1,nx2+LineWidth2,ny2,Color);
 PutLine(nx2-LineWidth2,ny2,nx3+LineWidth2,ny3,Color);
 PutLine(nx3,ny3+LineWidth2,nx4,ny4-LineWidth2,Color);
 PutLine(nx4,ny4+LineWidth2,nx1,ny1-LineWidth2,Color);
End;

Procedure PutRoundRect;
Var a,xr,yr,col,i,j,row,xend,yend:Int;
    asquare,bsquare,twoasquare,twobsquare,fourasquare,fourbsquare,d:Long;
Begin
 yr := a; xr := b; xend := x2 - xr; yend := y2 - yr;
 For J := -(_LineWidth shr 1) to (_LineWidth shr 1) do
 Begin
  For I := x1 + xr to xend do
  Begin
   SetPixel(i,y1-j,Color);
   SetPixel(i,y2-j,Color);
  End;
 End;
 For J := -(_LineWidth shr 1) to (_LineWidth shr 1) do
 Begin
  For I := y1 + yr downto yend do
  Begin
   SetPixel(x1+j,i,Color);
   SetPixel(x2+j,i,Color);
  End;
 End;
 Dec(b,_LineWidth shr 1);
 a := b;
 For I := 0 to _LineWidth do
 Begin
  bsquare := b * b; asquare := a * a; row := b; col := 0;
  twoasquare := asquare shl 1; fourasquare := asquare shl 2;
  fourbsquare := bsquare shl 2; twoasquare := bsquare shl 1;
  d := twoasquare * ((row - 1) * row) + asquare +
       twobsquare * (1-asquare);
  While (asquare * row > bsquare * col) do
  Begin
   SetPixel(col+xend,yend-row,Color);
   SetPixel(col+xend,y1-yr+row,Color);
   SetPixel(x1+xr-col,yend-row,Color);
   SetPixel(x1+xr-col,y1-yr+row,Color);
   If(D >= 0)Then
   Begin
    Dec(Row); D := fourasquare * row;
   End;
   Inc(D,twobsquare*(3+col shl 1)); Inc(Col);
  End;
  D := twobsquare * (col + 1) * col + twoasquare * (row * (row - 2) + 1) +
       (1 - twoasquare) * bsquare;
  While Not(row = 0) do
  Begin
   SetPixel(col+xend,yend-row,Color);
   SetPixel(col+xend,y1-yr+row,Color);
   SetPixel(x1+xr-col,yend-row,Color);
   SetPixel(x1+xr-col,y1-yr+row,Color);
   If(D >= 0)THen
   Begin
    Inc(Col);
    Inc(D,fourbsquare*col);
   End;
   Dec(Row);
   Inc(D,twoasquare * (3 - (row shl 1)));
  End;
  Inc(b); Inc(a);
 End;
End;

Procedure PutTextCenter;
Begin
 Case Center of
      __Left__ : PutTextXY(0,Y,Msg,Attr);
 __Justified__ : PutTextXY((MaxXTxts-Length(Msg)) shr 1,Y,Msg,Attr);
     __Right__ : PutTextXY(MaxXTxts-Length(Msg),Y,Msg,Attr);
 End;
End;

Procedure PutTextXYT;
Var I:Byte; B:Word;
Begin
 If(IVid.Graf)Then For I := 0 to Length(Str)-1 do
 Begin
  MainData^.SetGCubeT((X+I)*8,Y*GetHeightChar,Str[I+1],Attr);
  B := X + (Y*GetNumXTexts); MainData^.TBuffer^[B].Chr  := Str[I+1];
  MainData^.TBuffer^[B].Attr := (MainData^.TBuffer^[B].Attr and $F0) + Attr;
 End;
End;

Procedure PutTyping;
Var I:Word; J,X:Byte; F,Trans:Bool;
Begin
 With VideoBankSwitch do
 Begin
  X := XP;
  If(XP > MaxXTxts)Then
  Begin
   Inc(YP,XP div GetNumXTexts); XP := XP mod GetNumXTexts;
  End;
  F := True; Trans := False;
  For J := 1 to Length(Msg) do
  Begin
   If((Msg[J] > #31)and Not(Msg[J] in ['^','|','~']))Then
   Begin
    If(IVid.Graf)and(Trans)Then
    Begin
     PutTextXYT(XP,YP,Msg[J],NorColor and $F);
     _Right;
    End
     else
    If(F)Then _SetCube(Msg[J]) else _SetChar(Msg[J]);
   End
    else
   Case Msg[J] of
    '|': Begin
	  XP := X;
	  _Down;
	 End;
    '~': ;
     #2: _Up;
     #1: Begin
	  Inc(J); F := True; LastColor := NorColor; NorColor  := Byte(Msg[J]);
	 End;
     #4: Begin
	  Inc(J);
	  If(Bool(Msg[J]))Then
	  Begin
	   If(F)Then BarSpaceHori(XP,YP,XP+Length(Msg[J])-1,NorColor)
		Else BarCharHori(XP,YP,XP+Length(Msg[J])-1,' ');
	  End;
	 End;
     #5: _Down;
     #6: _Left;
     #8: _Right;
     #9: Begin
	  If(F)Then BarSpaceHori(XP,YP,XP+7,NorColor)
	       Else BarCharHori(XP,YP,XP+7,' ');
	  Inc(XP,7);
	 End;
    #10: Begin
	  _Right;
	  _Down;
	 End;
    #11: Begin
	  _Left;
	  _Down;
	 End;
    #12: Begin
	  _Right;
	  _Up;
	 End;
     #1: Begin
	  _Left;
	  _Up;
	 End;
    #14: Begin
	  Dec(XP,2);
	  _Up;
	 End;
    #15: Begin
	  Dec(XP,2);
	  _Down;
	 End;
    #16: Begin
	  Inc(J); XP := Byte(Msg[J]); Inc(J); YP := Byte(Msg[J]);
	 End;
    ^Q : Trans := True;
    '^': Begin
	  F := True;
	  ASM
	   MOV AL,LastColor;
	   MOV AH,NorColor;
	   MOV LastColor,AH;
	   MOV NorColor,AL;
	  END;
	 End;
    #28: F := False;
    #29: ClearLine(YP,' ',NorColor);
    #30: Begin
	  Inc(J);
	  _SetChar(Msg[J]);
	 End;
    #31: Begin
	  SetAttr(XP,YP,NorColor);
	  _Right;
	 End;
    Else _SetCube(Msg[J]);
   End;
  End;
 End;
End;

Procedure PutTypingXY;
Begin
 SetPos(X,Y);
 PutTyping(Msg);
End;

Procedure ScrollDown;
Assembler;
ASM
 MOV AX,$0601;
 MOV BH,Attr;
 MOV CL,X1;
 MOV CH,Y1;
 MOV DL,X2;
 MOV DH,Y2;
 INT $10;
END;

Procedure ScrollUp;
Assembler;
ASM
 MOV AX,$0701;
 MOV BH,Attr;
 MOV CL,X1;
 MOV CH,Y1;
 MOV DL,X2;
 MOV DH,Y2;
 INT $10;
END;

Function SavePaletteRGB;
Var Palette : Palette256RGB; Handle,J,HeaderSize : Word;
Begin
 SavePaletteRGB := False; Handle := Open(Path,WriteOnly);
 If(IsHandleErr(Handle))Then Exit;
 HeaderSize := StrLen(RGBFileHeader);
 SetRec(Handle,0,HeaderSize,RGBFileHeader);
 For J := 0 to (IVid.NmColrs shr 8) do
 Begin
  GetPaletteRGB(Palette[0],Long(HeaderSize)+(Long(J)*$100),(IVid.NmColrs and $FF));
  SetRec(Handle,J,((IVid.NmColrs and $FF)+1),Palette);
 End;
 Close(Handle);
 SavePaletteRGB := True;
End;

Procedure SetAddress;
Assembler;
ASM
 MOV AX,Segment;
 MOV IVid.SegV,AX;
END;

Procedure SetAllColor;
Assembler;
ASM
 MOV AL,Last;
 MOV LastColor,AL;
 MOV AL,New;
 MOV NorColor,AL;
END;

Procedure SetAngle;
Assembler;
ASM
 MOV AX,Angle;
 MOV _Angle,AX;
END;

Procedure SetBlink;
Assembler;
ASM
 MOV AX,$1003;
 MOV BL,X;
 INT $10;
 CMP _PVid1.EGA,Byte(True);
 JE  @@End;
 {$IFOPT G+}
  PUSH $0000;
  POP  ES;
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
 {$ENDIF}
 MOV DX,ES:[$0463];
 ADD DX,4;
 MOV AL,X;
 {$IFOPT G+}
  ROR AL,2;
 {$ELSE}
  ROR AL,1;
  ROR AL,1;
 {$ENDIF}
 ADD AL,$09;
 OUT DX,AL;
@@End:
END;

Procedure SetBorderLuxe;
Begin
 If(CloseIcon = ' - ')Then CurBorder := 'ÛÛÛ     '
		      Else CurBorder := 'ÛÛÛ'#1#2#5#4#6;
End;

Procedure SetBorderDouble;
Begin
 CurBorder := 'ÉÍ»ººÈÍ¼';
End;

Procedure SetBorderSimple;
Begin
 CurBorder := 'ÚÄ¿³³ÀÄÙ';
End;

Procedure SetBorderSimpleLuxe;
Begin
 If(CloseIcon = ' - ')Then CurBorder := 'ÚÄ¿³³ÀÄÙ'
		      Else CurBorder := #31#3#7#1#2#5#4#6;
End;

Procedure SetCheckSVGA;
Begin
 CheckSVGA := X;
End;

Procedure SetCubeGraph256(X,Y:Word;Chr:Char;BG,FG:Byte);
Var I : Byte;
Begin
 For I := 0 to IVid1^.HeightChr-1 do MainData^.Copy8Bin(X,Y+I,IVid1^.TxtMtx^[(IVid1^.HeightChr*Byte(Chr))+I],BG,FG);
End;

Procedure SetMatrix;
Assembler;
ASM
 MOV AX,$1100;
 MOV BL,Palette;
 MOV BH,Height;
 MOV DX,Start;
 MOV CX,Number;
 LES DI,Buffer;
 PUSH BP;
  MOV BP,DI;
  INT $10;
 POP BP;
END;

Procedure SetNorColor;
Begin
 NorColor := Color;
End;

Procedure SetPage;
Begin
 IVid.Pg := Page; IVid.AddrPg := Word(Page) * (IVid.NmXTxts*IVid.NmYTxts);
End;

Procedure SetPaletteRGB;
Type PalRec = Array[0..21000] of RGB;
Var PPal : PalRec Absolute P;
    I    : Word;
Begin
 If Not(_PVid1.DacBits in [0,8])Then
 Begin
  For I := 0 to Num - 1 do
  Begin
   PPal[I].R := PPal[I].R shr (8-_PVid1.DacBits);
   PPal[I].G := PPal[I].G shr (8-_PVid1.DacBits);
   PPal[I].B := PPal[I].B shr (8-_PVid1.DacBits);
  End;
 End;
 If(_PVid1.VGA)Then CardVideo.SPalVGA(P,Start,Num) else
 If(IsMCGA)Then CardVideo.SPalVGA(P,Start,Num) else
 If(_PVid1.EGA)Then CardVideo.SPalEGA(P,Start,Num);
End;

Procedure SetPos;
Begin
 VideoBankSwitch.XP := X; VideoBankSwitch.YP := Y;
End;

Procedure SetShade;
Assembler;
ASM
 MOV AL,X;
 MOV VideoBankSwitch.Shade,AL;
END;

Procedure SetSpace;
Begin
 SetCube(X,Y,' ',Attr);
End;

Procedure SetVideoCard;
Begin
 If(Card = vdUnknown)Then Exit;
 _PVid1.Card := Card;
End;

Function SetVideoMode;
Var S:Word; Ptr:Pointer; _SetVideoMode:Function(Mode:Word;Var Info:ModeInfoVideo):Bool Absolute Ptr;
Begin
 SetVideoMode := False;
 InitVideo;
 Ptr := AllocMainFunc(_PVid1.ProcSetVideoMode,S);
 If(Ptr = NIL)Then HaltRLL;
 SetVideoMode := _SetVideoMode(Mode,IVid);
 FreeMem(Ptr,S);
 QuickInitVideo(False);
End;

Function SetVideoModeDeluxe;
Begin
 InitVideo;
 SetVideoModeDeluxe := SetVideoMode(Mode);
 If(IVid.Graf)Then
 Begin
  SetDefaultGraphIcon;
  SetBorderSimpleLuxe;
 End
  Else
 InitVideoDeluxe;
End;

Function SizeBox;
Assembler;
ASM
 CMP IVid.Graf,Byte(False);
 JE  @@Text;
 MOV AX,$FFFF;
 MOV DX,AX;
 JMP @@End;
@@Text:
 MOV AL,X2;
 SUB AL,X1;
 INC AL;
 MOV AH,Y2;
 SUB AH,Y1;
 INC AH;
 MUL AH;
 SHL AX,1;
 XOR DX,DX;
 MOV BX,DX;
@@End:
END;

Procedure _BarSelectHori;
Begin
 BarSelHor(X1,Y,X2,GetNorColor);
End;

Procedure _Circle;
Begin
 Circle(X,Y,Rayon,GraphColor);
End;

Procedure _Down;
Begin
 Inc(VideoBankSwitch.YP);
End;

Procedure _Left;
Begin
 Dec(VideoBankSwitch.XP);
End;

Procedure _Line;
Begin
 PutLine(X1,Y1,X2,Y2,GraphColor);
End;

Procedure _LineHori;
Begin
 PutLineHori(X1,Y,X2,GraphColor);
End;

Procedure _Line2;
Begin
 _Line(VideoBankSwitch.XL,VideoBankSwitch.YL,X,Y);
 VideoBankSwitch.XL := X; VideoBankSwitch.YL := Y;
End;

Procedure _Move2;
Begin
 VideoBankSwitch.XL := X; VideoBankSwitch.YL := Y;
End;

Procedure _PutFillCircle;
Begin
 PutFillCircle(X,Y,Rayon,GraphColor);
End;

Procedure _PutPCharXY;
Begin
 PutPCharXY(X,Y,Str,NorColor);
End;

Procedure _PutTextXY;
Begin
 PutTextXY(X,Y,Msg,NorColor);
End;

Procedure _PutRotateRect;
Begin
 PutRotateRect(X1,Y1,X2,Y2,GraphColor);
End;

Procedure _Right;
Begin
 With VideoBankSwitch do
 Begin
  Inc(XP);
  If(XP > MaxXTxts)Then
  Begin
   Inc(YP,XP div GetNumXTexts); XP := XP mod GetNumXTexts;
  End;
 End;
End;

Procedure _SetChar;
Begin
 SetChar(VideoBankSwitch.XP,VideoBankSwitch.YP,Chr);
 _Right;
End;

Procedure _SetColor;
Begin
 GraphColor := Color;
End;

Procedure _SetCube;
Begin
 SetCube(VideoBankSwitch.XP,VideoBankSwitch.YP,Chr,NorColor);
 _Right;
End;

Procedure _Up;
Begin
 Dec(VideoBankSwitch.YP);
End;

Procedure __BarSpaceHori;
Begin
 BarSpaceHori(X1,Y,X2,(Background shl 4) + Foreground);
End;

Procedure __PutFillBorder;
Begin
 PutFillBorder(X1,Y1,X2,Y2,(Background shl 4) + Foreground);
End;

Procedure __PutTextCenter;
Begin
 PutTextCenter(Y,Center,Msg,(BG shl 4) + FG);
End;

Procedure __PutTextXY;
Var I,J : Byte; MsgLen : Byte Absolute Msg;
Begin
 If(IVid.Graf)Then
 Begin
  If(BG = FG)Then BarSpaceHori256(X,Y,X+MsgLen-1,BG)
   Else
  For I := 1 to MsgLen do
  Begin
   If(Msg[I] = ' ')Then
   Begin
    J := I;
    For I := J to MsgLen do If(Not(Msg[I] = ' '))Then Break;
    BarSpaceHori256(X+J-1,Y,X+I-1,BG);
   End;
   SetCubeGraph256((X+I-1)*8,Y*IVid.HeightChr,Msg[I],BG,FG);
   MainData^.TBuffer^[X+Y*IVid.NmXTxts].Chr := Msg[I];
  End;
 End
  Else
 For I := 1 to Length(Msg) do SetCube(X+I-1,Y,Msg[I],(BG shl 4)+(FG and $F));
End;

Procedure __SetAllColor;
Begin
 SetAllColor((LastBG shl 4) + LastFG,(NewBG shl 4) + NewFG);
End;

Procedure QuickInitVideo(Reset:Bool);
Var BarSpcHori:Procedure(X1,Y,X2,Attr:Byte);
    PtrBarSpcHori:Pointer Absolute BarSpcHori;
    ClrWn:Procedure(X1,Y1,X2,Y2,Attr:Byte);
    PtrClrWn:Pointer Absolute ClrWn;
    PutFillBox:Procedure(X1,Y1,X2,Y2:Int;Color:Word);
    PtrPutFillBox:Pointer Absolute PutFillBox;
    SetPixel:Procedure(X,Y:Int;C:Word);
    PtrSetPixel:Pointer Absolute SetPixel;
    GetPixel:Function(X,Y:Int):Word;
    PtrGetPixel:Pointer Absolute GetPixel;
    GetChar:Function(X,Y:Byte):Char;
    PtrGChar:Pointer Absolute GetChar;
    GetCube:Function(X,Y:Byte):Word;
    PtrGCube:Pointer Absolute GetCube;
    GetAttr:Function(X,Y:Byte):Byte;
    PtrGAttr:Pointer Absolute GetAttr;
    CopT8Bin:Procedure(X,Y:Word;Value,Fore:Byte);
    PtrCopT8Bin:Pointer Absolute CopT8Bin;
    Copy8Bin:Procedure(X,Y:Word;Value,Back,Fore:Byte);
    PtrCopy8Bin:Pointer Absolute Copy8Bin;
    PutTxtXYUnCol:Procedure(X,Y:Byte;Str:String);
    PtrPutTxtXYUnCol:Pointer Absolute PutTxtXYUnCol;
    SetAttr:Procedure(X,Y,Attr:Byte);
    PtrSAttr:Pointer Absolute SetAttr;
    SetChar:Procedure(X,Y:Byte;Chr:Char);
    PtrSChar:Pointer Absolute SetChar;
    SetCube:Procedure(X,Y:Byte;Chr:Char;Attr:Byte);
    PtrSCube:Pointer Absolute SetCube;
    SetGCube:Procedure(X,Y:Word;Chr:Char;Attr:Byte);
    PtrSGCube:Pointer Absolute SetGCube;
    SetGCubT:Procedure(X,Y:Word;Chr:Char;Attr:Byte);
    PtrSGCubT:Pointer Absolute SetGCubT;
    ShowPg:Procedure(Pg:Byte);
    PtrShowPg:Pointer Absolute ShowPg;
    PutTextXY:Procedure(X,Y:Byte;Str:String;Attr:Byte);
    PtrPutTextXY:Pointer Absolute PutTextXY;
    FillBox:Procedure(X1,Y1,X2,Y2:Byte;Chr:Char;Attr:Byte);
    PtrFillBox:Pointer Absolute FillBox;
Begin
 VramSetOff;
 Mems.FreeMem(MainData^.TBuffer,TBufSize);
 Mems.FreeMem(CurBuf,CurBufSize);
 FreeMem(@MainData^.BarSpcHori,MainDataR.SizeOfBarSpcHori);
 PtrBarSpcHori := AllocMainFunc(IVid.ProcBarSpcHori,MainDataR.SizeOfBarSpcHori);
 MainData^.BarSpcHori := BarSpcHori;
 FreeMem(@MainData^.ClrWn,MainDataR.SizeOfProcClrWn);
 PtrClrWn := AllocMainFunc(IVid.ProcClrWn,MainDataR.SizeOfProcClrWn);
 MainData^.ClrWn := ClrWn;
 FreeMem(@MainData^.PutFillBox,MainDataR.SizeOfProcPutFillBox);
 PtrPutFillBox := AllocMainFunc(IVid.ProcPutFillBox,MainDataR.SizeOfProcPutFillBox);
 MainData^.PutFillBox := PutFillBox;
 FreeMem(@MainData^.SetPixel,MainDataR.SizeOfProcSetPixel);
 PtrSetPixel := AllocMainFunc(IVid.ProcSetPixel,MainDataR.SizeOfProcSetPixel);
 MainData^.SetPixel := SetPixel;
 FreeMem(@MainData^.GetPixel,MainDataR.SizeOfFuncGetPixel);
 PtrGetPixel := AllocMainFunc(IVid.FuncGetPixel,MainDataR.SizeOfFuncGetPixel);
 MainData^.GetPixel := GetPixel;
 FreeMem(@MainData^.GetChar,MainDataR.SizeOfFuncGChar);
 PtrGChar := AllocMainFunc(IVid.FuncGChar,MainDataR.SizeOfFuncGChar);
 MainData^.GetChar := GetChar;
 FreeMem(@MainData^.GetCube,MainDataR.SizeOfFuncGCube);
 PtrGCube := AllocMainFunc(IVid.FuncGCube,MainDataR.SizeOfFuncGCube);
 MainData^.GetCube := GetCube;
 FreeMem(@MainData^.GetAttr,MainDataR.SizeOfFuncGAttr);
 PtrGAttr := AllocMainFunc(IVid.FuncGAttr,MainDataR.SizeOfFuncGAttr);
 MainData^.GetAttr := GetAttr;
 FreeMem(@MainData^.CopT8Bin,MainDataR.SizeOfProcCopT8Bin);
 PtrCopT8Bin := AllocMainFunc(IVid.ProcCopT8Bin,MainDataR.SizeOfProcCopT8Bin);
 MainData^.CopT8Bin := CopT8Bin;
 FreeMem(@MainData^.Copy8Bin,MainDataR.SizeOfProcCopy8Bin);
 PtrCopy8Bin := AllocMainFunc(IVid.ProcCopy8Bin,MainDataR.SizeOfProcCopy8Bin);
 MainData^.Copy8Bin := Copy8Bin;
 FreeMem(@MainData^.PutTextXYUnCol,MainDataR.SizeOfProcPutTxtXYUnCol);
 PtrPutTxtXYUnCol := AllocMainFunc(IVid.ProcPutTxtXYUnCol,MainDataR.SizeOfProcPutTxtXYUnCol);
 MainData^.PutTextXYUnCol := PutTxtXYUnCol;
 FreeMem(@MainData^.SetAttr,MainDataR.SizeOfProcSAttr);
 PtrSAttr := AllocMainFunc(IVid.ProcSAttr,MainDataR.SizeOfProcSAttr);
 MainData^.SetAttr := SetAttr;
 FreeMem(@MainData^.SetChar,MainDataR.SizeOfProcSChar);
 PtrSChar := AllocMainFunc(IVid.ProcSChar,MainDataR.SizeOfProcSChar);
 MainData^.SetChar := SetChar;
 FreeMem(@MainData^.SetCube,MainDataR.SizeOfProcSCube);
 PtrSCube := AllocMainFunc(IVid.ProcSCube,MainDataR.SizeOfProcSCube);
 MainData^.SetCube := SetCube;
 FreeMem(@MainData^.SetGCube,MainDataR.SizeOfProcSGCube);
 PtrSGCube := AllocMainFunc(IVid.ProcSGCube,MainDataR.SizeOfProcSGCube);
 MainData^.SetGCube := SetGCube;
 FreeMem(@MainData^.SetGCubeT,MainDataR.SizeOfProcSGCubT);
 PtrSGCubT := AllocMainFunc(IVid.ProcSGCubT,MainDataR.SizeOfProcSGCubT);
 MainData^.SetGCubeT := SetGCubT;
 FreeMem(@MainData^.ShowPg,MainDataR.SizeOfProcShowPg);
 PtrShowPg := AllocMainFunc(IVid.ProcShowPg,MainDataR.SizeOfProcShowPg);
 MainData^.ShowPg := ShowPg;
 FreeMem(@MainData^.PutTextXY,MainDataR.SizeOfProcPutTextXY);
 PtrPutTextXY := AllocMainFunc(IVid.ProcPutTextXY,MainDataR.SizeOfProcPutTextXY);
 MainData^.PutTextXY := PutTextXY;
 FreeMem(@MainData^.FillBox,MainDataR.SizeOfProcFillBox);
 PtrFillBox := AllocMainFunc(IVid.ProcFillBox,MainDataR.SizeOfProcFillBox);
 MainData^.FillBox := FillBox;
 CurBuf := NIL; CurBufSize := 0; MainData^.TBuffer := NIL; TBufSize := 0;
 With IVid do
 Begin
  If(Reset)Then
  Begin
   NmXTxts := Mem[_0040:$4A]; NmYTxts := (Mem[_0040:$84] + 1);
   If(NmYTxts = 1)Then NmYTxts := 25;
   HeightChr := Mem[_0040:$85];
   If(HeightChr = 0)Then HeightChr := 8;
   NmXPixels := NmXTxts * 8; NmYPixels := NmYTxts * HeightChr; Colr := VBiosAreaColor;
   If(DirectTextSupport)Then
   Begin
    Graf := False; DirectVideo := True;
    VramSetOn;
   End
    Else
   Begin
    Graf := IsGraphic; DirectVideo := False;
   End;
  End
   Else
  Begin
   If Not(Graf)Then
   Begin
    DirectVideo := DirectTextSupport;
    VramSetOn;
   End
    Else
   DirectVideo := False;
  End;
  If(Graf)Then
  Begin
   If(IVid.BitsPerPixel >= 8)Then
   Begin
    InitPalVGA;
    VramSetOn;
   End;
   If(Reset)Then
   Begin
    Case Mem[_0040:$49] of
      4,5 : Begin
	     NmColrs := 4; SegV := _B800;
	    End;
	6 : Begin
	     NmColrs := 2; SegV := _B800;
	    End;
      Else Begin
	    NmColrs := 16; SegV := _PVid1.Seg16C;
	   End;
    End;
   End;
   TBufSize := (Word(IVid.NmXTxts)*Word(IVid.NmYTxts)) * SizeOf(TextCube);
   MainData^.TBuffer := MemAlloc(TBufSize);
   CursorInit;
   FillChar(MainData^.TBuffer^,TBufSize,0);
  End
   Else
  Begin
   If(Colr)Then
   Begin
    NmColrs := 16; SegV := _B800;
   End
    Else
   Begin
    NmColrs := 4; SegV := _B000;
   End;
  End;
 End;
 _Init := True;
End;

Procedure PopScr(Var M:MemSwp);
Begin
 M.GetRec(0,M.BytesSize,Mem[IVid.SegV:0]);
 M.Done;
End;

Procedure PushScr(Var M:MemSwp);
Var Size:Long;
Begin
 M.Init;
 Case Ivid.Mode of
  _Graph640x200c2: Size := 16384;
  _Graph640x200c16:Size := 65520;
	      Else Size := 65520;
 End;
 If(M.SetSize(Size))Then M.SetRec(0,Size,Mem[IVid.SegV:0])
		    Else __OutOfMemory;
End;

Procedure PutTxtLuxe;
Var Mtx:^TByte; I,J,K,Masque:Byte; Path:PathStr; SizeOf_:Word;
Begin
 Path := SetPath4AddFile(StrPas(PathSystems))+'FONTS.*';
 Case IVid.HeightChr of
     13,14 : Mtx := AllocFunc(2,Path,SizeOf_);
     15,16 : Mtx := AllocFunc(3,Path,SizeOf_);
	Else Mtx := AllocFunc(1,Path,SizeOf_);
 End;
 For J := 0 to Length(S)-1 do For I := 0 to IVid.HeightChr-1 do
 Begin
  Masque := Mtx^[(IVid.HeightChr*Byte(S[J+1]))+I];
  Copy8Bin((X+J)*8,Y*IVid.HeightChr+I,Masque,Attr shr 4,Attr and $F);
 End;
 FreeMem(Mtx,SizeOf_);
End;

Procedure IniUnitVideo;
Begin
 PVid1 := @_PVid1; PVid2 := @_PVid2;
 IVid1 := @IVid; MainData^.PutLineHori := PutLineHori;
 DirectVideo := False;
 If(Mem[_0040:$84] = 0)Then Mem[_0040:$84] := 24;
 If(Mem[_0040:$85] = 0)Then Mem[_0040:$85] := 8;
 _LineWidth := 0;
 GraphColor := White;
 TBufSize := 0; MainData^.TBuffer := NIL; CurBufSize := 0; CurBuf := NIL;
 FillChar(VideoBankSwitch,SizeOf(VideoBankSwitch),0);
 VideoBankSwitch.Shade := True;
 VideoBankSwitch.SelPg := $FF;
 FillChar(_PVid1,SizeOf(_PVid1),0);
 FillChar(_PVid2,SizeOf(_PVid2),0);
 _PVid1.Color := VBiosAreaColor;
 FillChar(IVid,SizeOf(IVid),0);
 IVid.Colr := _PVid1.Color;
 CheckSVGA := False;
 CurBorder := 'ÚÄ¿³³ÀÄÙ';
 NorColor := LightGray + (Black shl 4); LastColor := White + (Black shl 4);
 SetDefaultIcon;
End;

BEGIN { Main Unit }
 IniUnitVideo;
END.