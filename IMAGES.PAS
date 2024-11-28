{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³             Malte Genesis III/Module des Images            ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Images;

INTERFACE

{$D-,L-,Y-,I-,Q-,R-,S-,X+}

Uses Dos,Memorys,Math,Video;

Const

      drwNone = 0;
      drwLine = 1;
      drwBox = 2;
      drwCircle = 3;
      drwPaint = 4;
      drwTrace = 5;
      drwText = 6;

Type

     ImgRec = Record
      Source:Byte;Handle:Word;BitsPerPixel:Byte;Length,Height:Word;
     End;

     HeaderBMP = Record
      Sign:PChar2;
      ReservedA:Array[3..17] of Byte;
      NumXPixels:Word; { 18-19 }
      FNumYPixels:Word; { 20-21 }
      NumYPixels:Word; { 22-23 }
      FBitsPerPixel:Byte; { 24 }
      ReservedC:Word; { 25-26 }
      ReservedD:Byte; { 27 }
      BitsPerPixel:Byte; { 28 }
     End;

     HeaderGIF = Record
      Sign,Ver:PChar2;
      NumXPixels,NumYPixels:Word;
      ExtInfo,Background,AspectRatio:Byte;
     End;

     HeaderImageGIF = Record
      LeftOfs,TopOfs,NumXPixels,NumYPixels:Word;
      ExtInfo:Byte;
     End;

      HeaderJFIF = Record
       Sign:PChar3;
       Ver,SubVer,DensityUnit:Byte;
       NumXPixels,NumYPixels:Word;
      End;

      HeaderPCX = Record
       MagicID,Version,Encoding,BitsPerPixel:Byte;
       X1,Y1,X2,Y2,NumXDPI,NumYDPI:Word;
       PaletteRGB:Palette16RGB;
       Reserved,NumPlanes:Byte;
       BytesPerLinePerPlane,PaletteInfo,NumXPixels,NumYPixels:Int;
       Filler:Array[74..127] of Byte;
      End;

     LoadBMP = Object
      Constructor Init;
      Function Open(Path:PathStr):Bool;
      Function CheckBMP:Bool;
      Function GetBitsPerPixel:Byte;
      Function GetNumXPixels:Word;
      Function GetNumYPixels:Word;
      Procedure GetLine(Y:Long;Var Buffer);
      Procedure SetPalette;
      Destructor Done;
      PRIVATE
      Info:HeaderBMP;
      Handle:Word;
      NumColor,Start:Long;
     End;

     LoadPCX = Object
      Constructor Init;
      Function Open(FileName:PathStr):Bool;
      Function CheckPCX:Bool;
      Procedure SetPalette;
      Function GetBitsPerPixel:Byte;
      Function GetNumXPixels:Word;
      Function GetNumYPixels:Word;
      Procedure GetLine(Var Line);
      Destructor Done;
      PRIVATE
      Handle:Word;
      BlockData:Array[0..1023] of Byte;
      Header:HeaderPCX;
      Palette256:Palette256RGB;
      NextByte,Colors,PicXsize,PicYsize:Int;
      Index,FilePtr:Long;
      Data:Byte;
      Function ReadHeader:Bool;
      Procedure Read256Palette;
      Function ReadByte:Byte;
     End;

Procedure FontMarble;
Procedure GetLineHoriImage8BitsSvga256(X1,Y,X2:Int;Var Buffer);
Procedure GetSmlImg(X1,Y1,X2,Y2:Int;Var Buffer);
Procedure PutSmlImg(X1,Y1,X2,Y2:Int;Var Buffer);

Function DegradSupport:Bool;
Function GetSizeSmlImg(X1,Y1,X2,Y2:Int):Word;
Function PutImage(X1,Y1,X2,Y2:Int;Var Info:ImgRec):Bool;
Function RestoreImage(X1,Y1,X2,Y2:Int;Var Info:ImgRec):Bool;
Function SaveImage(X1,Y1,X2,Y2:Int;Var Info:ImgRec):Bool;

Procedure PutTapis(Y1,Y2,Attr:Byte);
Procedure __PutTapis(Y1,Y2,Background,Foreground:Byte);
Function GetHeaderBMP(Handle:Word;Var Info:HeaderBMP):Bool;
Function IsBMP(Info:HeaderBMP):Bool;

IMPLEMENTATION

Uses Strings,CardVideo,Strs,Language,Systems,MLibrary,Keyboard,Mems;

Constructor LoadBMP.Init;
Begin
 FillChar(Info,SizeOf(Info),0);
 Handle := $FFFF;
End;

Procedure LoadBMP.SetPalette;
Var Pal:Palette256RGB;
Begin
 SetFilePos(Handle,70);
 _GetRec(Handle,SizeOf(Pal),Pal);
 SetPaletteRGB(Pal[0],0,256);
End;

Function LoadBMP.Open;
Begin
 Handle := Systems.Open(Path,ReadOnly); Open := Systems.IsHandle(Handle);
 NumColor := 0; Start := 0;
End;

Function LoadBMP.CheckBMP;
Begin
 CheckBMP := False;
 If Not(GetHeaderBMP(Handle,Info))Then Exit;
 NumColor := (1 shl Info.BitsPerPixel); Start := 70 + (NumColor * SizeOf(RGB));
 CheckBMP := True;
End;

Function LoadBMP.GetNumXPixels;
Begin
 GetNumXPixels := Info.NumXPixels;
End;

Function LoadBMP.GetNumYPixels;
Begin
 If(Info.Sign[2] = 'F')Then GetNumYPixels := Info.FNumYPixels
		       Else GetNumYPixels := Info.NumYPixels;
End;

Function LoadBMP.GetBitsPerPixel;
Begin
 If(Info.Sign[2] = 'F')Then GetBitsPerPixel := Info.FBitsPerPixel
		       Else GetBitsPerPixel := Info.BitsPerPixel;
End;

Procedure LoadBMP.GetLine;
Var TBuf:^TByte;XBuf:TByte Absolute Buffer;I:Word;
Begin
 If(Systems.IsHandleErr(Handle))Then Exit;
 If(Start = 0)Then
 Begin
  If Not(CheckBMP)Then Exit;
 End;
 If(Info.Sign[2] = 'F')Then
 Begin
  TBuf := MemAlloc(GetNumXPixels);
  If(TBuf = NIL)Then Exit;
  SetFilePos(Handle,Long(Start)+Long(Long(GetNumYPixels-Y-1)*Long(GetNumXPixels)));
  _GetRec(Handle,GetNumXPixels,TBuf^);
  For I := 0 to (GetNumXPixels - 1) shr 1 do
  Begin
   XBuf[I shl 1] := (TBuf^[I] and $F)+(TBuf^[I+GetNumXPixels] shr 4);
   XBuf[(I shl 1) + 1] := (TBuf^[I] shr 4)+(TBuf^[I+GetNumXPixels] and $F);
  End;
  FreeMem(TBuf,GetNumXPixels);
 End
  Else
 Begin
  SetFilePos(Handle,Long(Start)+Long(Long(GetNumYPixels-Y-1)*Long(GetNumXPixels)));
  _GetRec(Handle,GetNumXPixels,Buffer);
 End;
End;

Destructor LoadBMP.Done;
Begin
 Close(Handle);
End;

Constructor LoadPCX.Init;
Begin
 FillChar(Header,SizeOf(Header),0);
 Data := 0;
End;

Function LoadPCX.Open;
Begin
 Open := False; Handle := Systems.Open(FileName,ReadOnly);
 If(IsHandleErr(Handle))Then Exit;
 Open := True;
End;

Procedure LoadPCX.SetPalette;
Begin
 SetPaletteRGB(Palette256[0],64,256-64);
End;

Function LoadPCX.CheckPCX;
Begin
 CheckPCX := False;
 If Not(ReadHeader)Then
 Begin
  Close(Handle);
  Exit;
 End;
 CheckPCX := True;
End;

Function LoadPCX.GetBitsPerPixel;
Begin
 If(Header.NumPlanes = 4)and(Header.BitsPerPixel = 1)Then GetBitsPerPixel := 4
						     Else GetBitsPerPixel := Header.BitsPerPixel;
End;

Function LoadPCX.GetNumXPixels;
Begin
 GetNumXPixels := PicXSize;
End;

Function LoadPCX.GetNumYPixels;
Begin
 GetNumYPixels := PicYSize;
End;

Function LoadPCX.ReadHeader;
Begin
 ReadHeader := False;
 GetRec(Handle,0,SizeOf(Header),Header);
 Colors  := 0;
 If(Header.MagicID <> 10)or(Header.Encoding <> 1)Then
 Begin
  Close(Handle);
  Exit;
 End;
 PicYsize := Header.Y2-Header.Y1; PicXsize := Header.X2-Header.X1;
 If(Header.NumPlanes = 4)and(Header.BitsPerPixel = 1)Then Colors := 16 else
 If(Header.NumPlanes = 1)Then
 Begin
  Case Header.BitsPerPixel of
    1 : Colors := 2;
    2 : Colors := 4;
    8 : Begin
	 Colors := 256;
	 If(Header.Version = 5)Then Read256palette;
	End
   Else Exit;
  End;
 End
  Else
 Exit;
 Index := 0; NextByte := (SizeOf(BlockData)-1); FilePtr := Long(SizeOf(Header)); ReadHeader := True;
End;

Procedure LoadPCX.Read256Palette;
Var B:Byte;
Begin
 FilePtr := FileSize(Handle)-(SizeOf(Palette256)+1);
 SetFilePos(Handle,FilePtr);
 _GetRec(Handle,SizeOf(B),B);
 Inc(FilePtr,SizeOf(B));
 If Not(B = 12)Then
 Begin
  FilePtr := SizeOf(Header);
  Exit;
 End;
 SetFilePos(Handle,FilePtr);
 _GetRec(Handle,SizeOf(Palette256),Palette256);
 FilePtr := SizeOf(Header);
End;

Function LoadPCX.ReadByte;
Begin
 If(NextByte = (SizeOf(BlockData)-1))Then
 Begin
  SetFilePos(Handle,FilePtr);
  _GetRec(Handle,SizeOf(BlockData),BlockData);
  Inc(FilePtr,SizeOf(BlockData)); NextByte := 0;
 End;
 ReadByte := BlockData[NextByte]; Inc(NextByte);
End;

Procedure LoadPCX.GetLine;
Var Len,Z:Byte; BytesPerLine:Int; PCXLine:TByte Absolute Line;
Begin
 BytesPerLine := (Header.BytesPerLinePerPlane * Header.NumPlanes);
 FillChar(PCXLine,BytesPerLine,0);
 If(Index <> 0)Then FillChar(PCXLine[0],Index,Data+64);
 While (Index < BytesPerLine) do
 Begin
  Data := ReadByte;
  If((Data and $C0) = $C0)Then
  Begin
   Len := (Data and $3F); Data := ReadByte;
   If(Index + Len > BytesPerLine)Then
   Begin
    Z := (BytesPerLine - Index)-1;
    FillChar(PCXLine[Index],Z,Data+64);
   End
    Else
   FillChar(PCXLine[Index],Len,Data+64);
   Inc(Index,Len);
  End
   Else
  Begin
   PCXLine[Index] := Data+64;
   Inc(Index);
  End;
 End;
 Dec(Index,BytesPerLine);
End;

Destructor LoadPCX.Done;
Begin
 Close(Handle);
End;

Function DegradSupport:Bool;
Begin
 DegradSupport := (IVid.BitsPerPixel > 4)or((IsMonochrome)and(IVid.BitsPerPixel >= 4));
End;

Procedure FontMarble;
Var Handle,J:Word; Buf:Array[0..245] of Byte;
Begin
 Handle := Open(SetPath4AddFile(StrPas(PathSystems))+'MARBLE.MBF',ReadOnly);
 If(IsHandleErr(Handle))Then Exit;
 For J := 0 to 221 do
 Begin
  GetRec(Handle,J,246,Buf);
  PutLineHoriImg(0,J,245,8,Buf);
  PutLineHoriImg(246,J,246+245,8,Buf);
  PutLineHoriImg(246+246,J,246+246+245,8,Buf);
  If(J + 222 < IVid.NmYPixels)Then
  Begin
   PutLineHoriImg(0,222+J,246,8,Buf);
   PutLineHoriImg(246,222+J,246+245,8,Buf);
   PutLineHoriImg(246+246,222+J,246+246+245,8,Buf);
  End;
  If(J + 222 + 222 < IVid.NmYPixels)Then
  Begin
   PutLineHoriImg(0,222+222+J,246,8,Buf);
   PutLineHoriImg(246,222+222+J,246+245,8,Buf);
   PutLineHoriImg(246+246,222+222+J,246+246+245,8,Buf);
  End;
 End;
 Close(Handle);
End;

Function GetHeaderBMP(Handle:Word;Var Info:HeaderBMP):Bool;
Begin
 GetRec(Handle,0,SizeOf(Info),Info);
 GetHeaderBMP := (FileError = 0);
End;

Procedure GetLineHoriImage8BitsSvga256(X1,Y,X2:Int;Var Buffer);
Var aY,a1,a2:Record Case Byte of 0:(L:Long); 1:(W:Word;Page:Byte); End;
    L1,L:Word; BufferPtr:TByte Absolute Buffer;
Begin
 L := (X2 - X1) + 1; aY.L := (Long(Y) * Long(IVid.BytesPerLn));
 a1.L := Long(X1) + aY.L; a2.L := Long(X2) + aY.L;
 MainData^.SelBankPg(a1.Page);
 If(a1.Page = a2.Page)Then Move(Mem[IVid.SegV:a1.W],Buffer,L)
  Else
 Begin
  L1 := ($FFFF - a1.W) + 1;
  Move(Mem[IVid.SegV:a1.W],Buffer,L1);
  MainData^.SelBankPg(a2.Page);
  Move(Mem[IVid.SegV:0],BufferPtr[L1],L-L1);
 End;
End;

Procedure GetLineHoriImage8BitsDefault(X1,Y,X2:Int;Var Buffer);
Var I:Word; BufferPtr:TByte Absolute Buffer;
Begin
 For I := 0 to X2-X1 do BufferPtr[I] := GetPixel(I+X1,Y);
End;

Function GetSizeSmlImg(X1,Y1,X2,Y2:Int):Word;
Begin
 GetSizeSmlImg := ((X2 - X1 + 1) * (Y2 - Y1 + 1)) div (8 div IVid.BitsPerPixel);
End;

Procedure GetSmlImg(X1,Y1,X2,Y2:Int;Var Buffer);
Var TBuf:TByte Absolute Buffer; J,L:Word;
Begin
 With IVid do
 Begin
  If(Graf)Then
  Begin
   Case BitsPerPixel of
    8 : Begin
         L := (X2 - X1) + 1;
	 For J := 0 to Y2-Y1 do GetLineHoriImage8BitsSvga256(X1,J+Y1,X2,TBuf[J*L]);
	End;
   Else Begin
         L := (X2 - X1) + 1;
	 For J := 0 to Y2-Y1 do GetLineHoriImage8BitsDefault(X1,J+Y1,X2,TBuf[J*L]);
	End;
   End;
  End;
 End;
End;

Function IsBMP(Info:HeaderBMP):Bool;
Begin
 IsBMP := (Info.Sign[0] = 'B')and(Info.Sign[1] = 'M');
End;

Function PutImage;
Var _Handle,J:Word; GBuf:Pointer;
Begin
 PutImage := False;
 If(VSwp[Info.Source].Exist)Then
 Begin
  If Not(IsHandleErr(Info.Handle))Then
  Begin
   GBuf := MemAlloc(Info.Length);
   If(GBuf = NIL)Then Exit;
   For J := 0 to Info.Height-1 do
   Begin
    VSwp[Info.Source].GetRec(Info.Handle,J,Info.Length,GBuf^);
    If Not(IVid.BitsPerPixel = 8)Then PutLineHoriImg(X1,Y1+J,X2,8,GBuf^)
				 Else PutLineHoriImg8BitsSvga256(X1,Y1+J,X2,GBuf^);
   End;
   FreeMem(GBuf,Info.Length);
   PutImage := True;
   Exit;
  End;
 End;
End;

Procedure PutTapis;
Begin
 If(DirectVideo)Then PutTapisDirect(Y1,Y2,Attr)
  Else
 Begin
  If(IVid1^.BitsPerPixel = 1)Then ClrWn(0,Y1,MaxXTxts,Y2,$10)
			     Else FontMarble;
 End;
End;

Procedure PutSmlImg;
Var TBuf:TByte Absolute Buffer; J,L:Word;
Begin
 With ModeInfVid do
 Begin
  If(Graf)Then
  Begin
   L := (X2 - X1) + 1;
   Case BitsPerPixel of
    4 : For J := 0 to Y2-Y1 do PutLineHoriImg(X1,J+Y1,X2,8,TBuf[J*L]);
    8 : For J := 0 to Y2-Y1 do PutLineHoriImg8BitsSvga256(X1,J+Y1,X2,TBuf[J*L]);
   End;
  End;
 End;
End;

Function RestoreImage;
Begin
 RestoreImage := False;
 If Not(PutImage(X1,Y1,X2,Y2,Info))Then Exit;
 RestoreImage := VSwp[Info.Source]._Del(Info.Handle);
End;

Function SaveImage;
Var _Handle,J,L1:Word; GBuffer:Pointer; aY,a1,a2,Size:Long; J2:Byte;
Begin
 SaveImage := False;
 If(X2 < X1)or(Y2 < Y1)Then Exit;
 Info.Source := Memorys.__None; Info.Handle := $FFFF;
 Info.BitsPerPixel := ModeInfVid.BitsPerPixel;
 Info.Length := (X2-X1+1); Info.Height := (Y2-Y1+1);
 Size := Long(Info.Length) * Long(Info.Height);
 For J2 := 5 downto 1 do If(VSwp[J2].Exist)Then
 Begin
  Info.Handle := VSwp[J2].New(Size);
  If Not(IsHandleErr(Info.Handle))Then
  Begin
   Info.Source := J2; GBuffer := MemAlloc(Info.Length);
   If(GBuffer = NIL)Then Exit;
   For J := 0 to Info.Height-1 do
   Begin
    If Not(IVid.BitsPerPixel = 8)Then GetLineHoriImage8BitsDefault(X1,Y1+J,X2,GBuffer^)
				 Else GetLineHoriImage8BitsSvga256(X1,Y1+J,X2,GBuffer^);
    VSwp[J2].SetRec(Info.Handle,J,Info.Length,GBuffer^);
   End;
   FreeMem(GBuffer,Info.Length);
   SaveImage := True;
   Exit;
  End;
 End;
End;

Procedure __PutTapis(Y1,Y2,Background,Foreground:Byte);
Begin
 PutTapis(Y1,Y2,(Background shl 4) + Foreground);
End;

BEGIN { Main Unit }
END.