{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                           ³
 ³           Malte Genesis III/Module de Carte Vid‚o         ³
 ³                Edition Isabel pour Mode R‚el              ³
 ³                      III - Version 1.0                    ³
 ³                         1995/02/02                        ³
 ³                                                           ³
 ³       Copyright (C) par les Chevaliers de Malte           ³
 ³                                                           ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit CardVideo;

INTERFACE

{$IFNDEF Debug}
 {$D-,L-,Y-}
{$ENDIF}
{$I-,Q-,R-,S-,X+}

Uses Math,Systems,Video;

Type

     VideoBankSwitchRec = Record
      Shade:Bool; XP,YP:Byte; XL,YL:Int; XCur,YCur:Word; SelPg:Byte;
     End;

Var

    VideoBankSwitch:VideoBankSwitchRec;

Procedure DefGraf;
Procedure InitPalVGA;
Procedure PutLineHoriImg(X1,Y,X2:Int;BitsPerPixel:Byte;Var Buffer);
Procedure PutLineHoriImg8BitsSvga256(X1,Y,X2:Int;Var Buffer);
Procedure PutLineHoriSvga256(X1,Y,X2:Int;Color:Word);
Procedure ShowPg320x200x256c(Pg:Byte);
Procedure ShowPg320x400x256c(Pg:Byte);

Procedure DefTxt;
Procedure PutTapisDirect(Y1,Y2,Attr:Byte);
Procedure SPalEGA(Var Palette:RGB;Start,Num:Byte);
Procedure SPalRGB(Color,R,G,B:Byte);
Procedure SPalVGA(Var Palette:RGB;Start,Num:Word);

IMPLEMENTATION

Uses LibVideo,Mems;

Procedure DefGraf;
Begin
 QuickInitVideo(False);
End;

Procedure DefTxt;
Begin
 With IVid do
 Begin
  IbmLogic := Yes; BiosSupport := Yes;
  Colr := (MemW[_0040:$0063] = $3D4);
  If(Colr)Then
  Begin
   SegV := _B800; NmColrs := 16;
  End
   Else
  Begin
   SegV := _B000; NmColrs := 4;
  End;
  Graf := No; NmVidPgs := 2;
  NmXPixels := MemW[_0040:$4A] * 8; NmXTxts := Mem[_0040:$4A]; NmYTxts := Mem[_0040:$84];
  If(NmYTxts = 0)Then NmYTxts := 25 Else Inc(NmYTxts);
  BytesPerLn := MemW[_0040:$4A] * 2; HeightChr := Mem[_0040:$85];
  If(HeightChr = 0)Then HeightChr := 8;
  NmYPixels := HeightChr * NmYTxts;
 End;
End;

Procedure InitPalVGA;
Var Pal:Array[0..15] of RGB; I:Byte;
Begin
 Pal[0].R := 0; Pal[0].G := 0; Pal[0].B := 31 shl 2;
 Video.SetPaletteRGB(Pal[0],1,1);
 Pal[0].R := 0; Pal[0].G := 0; Pal[0].B := 63 shl 2;
 Video.SetPaletteRGB(Pal[0],9,1);
 For I := 0 to 15 do
 Begin
  Pal[I].R := (15-I) shl 4; Pal[I].G := (15-I) shl 4; Pal[I].B := ((I shl 1) + (15-I) shl 2) shl 2;
 End;
 Video.SetPaletteRGB(Pal[0],16,16);
 For I := 0 to 15 do
 Begin
  Pal[I].R := I shl 4; Pal[I].G := I shl 4; Pal[I].B := I shl 4;
 End;
 Video.SetPaletteRGB(Pal[0],32,16);
 For I := 0 to 15 do
 Begin
  Pal[I].R := (15-I) shl 4; Pal[I].G := (15-I) shl 4; Pal[I].B := (I shl 4) + (15-I) shl 4;
 End;
 Video.SetPaletteRGB(Pal[0],48,16);
 For I := 0 to 3 do
 Begin
  Pal[I].R := 0; Pal[I].G := 0; Pal[I].B := I shl 6;
 End;
 Video.SetPaletteRGB(Pal[0],252,4);
End;

Procedure PutLineHoriImg8BitsSvga256;
Var aY,a1,a2:Record Case Byte of 0:(L:Long); 1:(W:Word;Page:Byte); End;
    L1,L:Word; BufferPtr:TByte Absolute Buffer;
Begin
 L := (X2 - X1) + 1; aY.L := (Long(Y) * Long(IVid.BytesPerLn));
 a1.L := Long(X1) + aY.L; a2.L := Long(X2) + aY.L;
 MainData^.SelBankPg(a1.Page);
 If(a1.Page = a2.Page)Then Move(Buffer,Mem[IVid.SegV:a1.W],L)
  Else
 Begin
  L1 := ($FFFF - a1.W) + 1;
  Move(Buffer,Mem[IVid.SegV:a1.W],L1);
  MainData^.SelBankPg(a2.Page);
  Move(BufferPtr[L1],Mem[IVid.SegV:0],L-L1);
 End;
End;

Procedure PutLineHoriImg;
Var L,I:Int; BufPtr:^TByte; TBuf:TByte Absolute Buffer;

 Procedure Default8;
 Var I : Int;
 Begin
  For I := X1 to X2 do MainData^.SetPixel(I,Y,TBuf[I-X1]);
 End;

Begin
 If(IVid.Graf)Then
 Begin
  If(X1 > GetMaxXPixels)Then Exit;
  If(X2 > GetMaxXPixels)Then X2 := GetMaxXPixels;
  Case IVid.BitsPerPixel of
   8 : Case BitsPerPixel of
	 1 : Begin { 2 … 256 couleurs }
	      L := (X2-X1) + 1; BufPtr := MemAlloc(L);
	      If(BufPtr = NIL)Then Exit;
	      For I := 0 to ((X2 - X1) shr 3) do
	      Begin
	       BufPtr^[I shl 3]       := (TBuf[I] and 1) * 15;
	       BufPtr^[(I shl 3) + 1] := ((TBuf[I] shr 1) and 1) * 15;
	       BufPtr^[(I shl 3) + 2] := ((TBuf[I] shr 2) and 1) * 15;
	       BufPtr^[(I shl 3) + 3] := ((TBuf[I] shr 3) and 1) * 15;
	       BufPtr^[(I shl 3) + 4] := ((TBuf[I] shr 4) and 1) * 15;
	       BufPtr^[(I shl 3) + 5] := ((TBuf[I] shr 5) and 1) * 15;
	       BufPtr^[(I shl 3) + 6] := ((TBuf[I] shr 6) and 1) * 15;
	       BufPtr^[(I shl 3) + 7] := ((TBuf[I] shr 7) and 1) * 15;
	      End;
	      PutLineHoriImg8BitsSvga256(X1,Y,X2,BufPtr^);
	      FreeMem(BufPtr,L);
	     End;
	 2 : Begin { 4 … 256 couleurs }
	      L := (X2-X1) + 1; BufPtr := MemAlloc(L);
	      If(BufPtr = NIL)Then Exit;
	      For I := 0 to ((X2 - X1) shr 2) do
	      Begin
	       BufPtr^[I shl 2]       := (TBuf[I] and 3) shl 2;
	       BufPtr^[(I shl 2) + 1] := ((TBuf[I] shr 2) and 3) shl 2;
	       BufPtr^[(I shl 2) + 2] := ((TBuf[I] shr 4) and 3) shl 2;
	       BufPtr^[(I shl 2) + 3] := (TBuf[I] shr 6) shl 2;
	      End;
	      PutLineHoriImg8BitsSvga256(X1,Y,X2,BufPtr^);
	      FreeMem(BufPtr,L);
	     End;
	 4 : Begin { 16 … 256 couleurs }
	      L := (X2-X1) + 1; BufPtr := MemAlloc(L);
	      If(BufPtr = NIL)Then Exit;
	      For I := 0 to ((X2 - X1) shr 1) do
	      Begin
	       BufPtr^[I shl 1] := TBuf[I] and 15; BufPtr^[(I shl 1) + 1] := TBuf[I] shr 4;
	      End;
	      PutLineHoriImg8BitsSvga256(X1,Y,X2,BufPtr^);
	      FreeMem(BufPtr,L);
	     End;
	 8 : PutLineHoriImg8BitsSvga256(X1,Y,X2,Buffer);
       End;
  Else Case BitsPerPixel of
	 8 : Default8;
       End;
  End;
 End;
End;

Procedure PutLineHoriSVGA256;
Var aY,a1,a2:Record Case Byte of 0:(L:Long); 1:(W:Word;Page:Byte); End;
    L1,L:Word;
Begin
 L := (X2 - X1) + 1; aY.L := (Long(Y) * Long(IVid.BytesPerLn));
 a1.L := Long(X1) + aY.L; a2.L := Long(X2) + aY.L;
 MainData^.SelBankPg(a1.Page);
 If(a1.Page = a2.Page)Then FillChar(Mem[IVid.SegV:a1.W],L,Color)
  Else
 Begin
  L1 := ($FFFF - a1.W) + 1;
  FillChar(Mem[IVid.SegV:a1.W],L1,Color);
  MainData^.SelBankPg(a2.Page);
  FillChar(Mem[IVid.SegV:0],L-L1,Color);
 End;
End;

Procedure PutTapisDirect;
Var I,J,JD,ID,Y1M,Y2M:Byte; JDC,JDC1:Word; T0,T1:Array[0..1] of TextCube;
Begin
 If(_PVid1.Font)Then
 Begin
  T0[0].Chr := #29; T0[1].Chr := #30;
  T1[0].Chr := #30; T1[1].Chr := #29;
 End
  Else
 Begin
  T0[0].Chr := 'ú'; T0[1].Chr := ' ';
  T1[0].Chr := ' '; T1[1].Chr := 'ú';
 End;
 T0[0].Attr := Attr;
 T0[1].Attr := Attr;
 T1[0].Attr := Attr;
 T1[1].Attr := Attr;
 Y1M := (Y1 shr 1); Y2M := (Y2 shr 1);
 For J := Y1M to Y2M do
 Begin
  JD := J shl 1; JDC := JD * IVid.NmXTxts; JDC1 := Succ(JD) * IVid.NmXTxts;
  For I := 0 to (MaxXTxts shr 1) do
  Begin
   ID := I shl 1;
   Move(T0,Mem[IVid.SegV:(ID+JDC) shl 1],SizeOf(T0));
   Move(T1,Mem[IVid.SegV:(ID+JDC1) shl 1],SizeOf(T1));
  End;
 End;
End;

Procedure SPalEGA;
Var I,PckPal:Byte; PalPtr:Palette16RGB Absolute Palette;
Begin
 For I := Start to Start + (Num - 1) do
 Begin
  PckPal := ((PalPtr[I].B and 1) + ((PalPtr[I].B and 2) shl 2) +
	    ((PalPtr[I].G and 1) shl 1) + ((PalPtr[I].G and 2) shl 3) +
	    ((PalPtr[I].B and 1) shl 2) + ((PalPtr[I].B and 2) shl 4));
  ASM
   MOV AX,$1000;
   MOV BL,PckPal;
   MOV BH,I;
   INT $10;
  END;
 End;
End;

Procedure SPalRGB;
Assembler;
ASM
 MOV DX,$3C8;
 MOV AL,Color;
 OUT DX,AL;
 INC DX;
 MOV AL,R;
 OUT DX,AL;
 MOV AL,G;
 OUT DX,AL;
 MOV AL,B;
 OUT DX,AL;
END;

Procedure SPalVGA;
Var I:Word; P:Array[0..255] of RGB Absolute Palette;
Begin
 For I := 0 to Num - 1 do SPalRGB(Start+I,P[I].R,P[I].G,P[I].B);
End;

Procedure ShowPg320x200x256c;
Assembler;
Const CRTCIndex = $3D4; CCStartHi = $0C; VertRetrace = $3DA;
ASM
 MOV AL,64;
 MOV AH,Pg;
 MOV IVid.ShowPg,AH;
 MUL AH;
 MOV AH,AL;
 MOV DX,CRTCIndex;
 MOV AL,CCStartHi;
 OUT DX,AX;
 MOV DX,VertRetrace;
@@3:
 IN   AL,DX;
 TEST AL,8;
 JNE  @@3;
@@4:
 IN   AL,DX;
 TEST AL,8;
 JE   @@4;
END;

Procedure ShowPg320x400x256c;
Assembler;
Const CRTCIndex = $3D4; CCStartHi = $0C; VertRetrace = $3DA;
ASM
 MOV AL,Pg;
 MOV IVid.ShowPg,AL;
 OR  AL,AL;
 JE  @@2;
 MOV AL,$80;
@@2:
 MOV DX,CRTCIndex;
 MOV AH,AL;
 MOV AL,CCStartHi;
 OUT DX,AX;
 MOV DX,VertRetrace;
@@3:
 IN   AL,DX;
 TEST AL,8;
 JNE  @@3;
@@4:
 IN   AL,DX;
 TEST AL,8;
 JE   @@4;
@@End:
END;

BEGIN
END.