{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³               Malte Genesis/Module du Curseur              ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Cursor;

INTERFACE

{$B-,E+,F+,I-,N+,Q-,R-,S-,X+}

Procedure AnimateCursor;
Procedure CloseCursor;
Procedure CursorInit;
Procedure FullCursor;
Procedure PopCursor;
Procedure PushCursor;
Procedure SetCursor(A,B:Byte);
Procedure SetCursorHome;
Procedure SetCursorPos(X,Y:Byte);
Procedure SimpleCursor;

IMPLEMENTATION

Uses Math,Systems,CardVideo,Video,Images,Mems;

Procedure AnimateCursor;
Begin
 With VideoBankSwitch do
 Begin
  Case (Mem[_0040:$6C] and $F) of
    0 : SetAttr(XCur,YCur,$0F);
    4 : SetAttr(XCur,YCur,$C0);
    8 : SetAttr(XCur,YCur,$90);
   12 : SetAttr(XCur,YCur,$E0);
  End;
 End;
End;

Procedure CloseCursor;
Assembler;
ASM
 CMP IVid.Graf,Byte(True);
 JE @@End;
 CMP DirectVideo,Byte(True);
 JE  @@DirectText;
@@BIOSText:
 MOV CX,$2020;
 MOV AH,$01;
 INT $10;
 JMP @@End;
@@DirectText:
 {$IFOPT G+}
  PUSH 0;
  POP  ES;
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
 {$ENDIF}
 MOV DX,ES:[$0463];
 MOV AX,$200A;
 OUT DX,AX;
 INC AL;
 OUT DX,AX;
@@End:
END;

Procedure FullCursor;
Begin
 SetCursor(0,IVid.HeightChr-1);
End;

Procedure PopCursor;
Var _CCube : TextCube Absolute CurrCube;
Begin
 With VideoBankSwitch do
 Begin
  If(IVid.Graf)Then PutSmlImg(XCur*8,YCur*IVid.HeightChr,(XCur*8)+7,((YCur+1)*IVid.HeightChr)-1,CurBuf^)
	       Else SetCube(XCur,YCur,_CCube.Chr,_CCube.Attr);
 End;
End;

Procedure PushCursor;
Begin
 With VideoBankSwitch do
 Begin
  If(IVid.Graf)Then GetSmlImg(XCur*8,YCur*IVid.HeightChr,(XCur*8)+7,((YCur+1)*IVid.HeightChr)-1,CurBuf^)
	       Else CurrCube := GetCube(XCur,YCur);
 End;
End;

Procedure SetCursorText(A,B:Byte);
Assembler;
ASM
 CMP DirectVideo,Byte(True);
 JE  @@DirectText;
@@BiosCursor:
 MOV CL,A;
 MOV CH,B;
 MOV AH,$01;
 INT $10;
 JMP @@End;
@@DirectText:
 {$IFOPT G+}
  PUSH $0000;
  POP  ES;
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
 {$ENDIF}
 MOV DX,ES:[$0463];
 MOV AL,$0A;
 MOV AH,A;
 OUT DX,AX;
 INC AL;
 MOV AH,B;
 OUT DX,AX;
@@End:
END;

Procedure SetCursor;
Begin
 If Not(IVid.Graf)Then SetCursorText(A,B);
End;

Procedure SetCursorHome;
Assembler;
ASM
 {$IFOPT G+}
  PUSH 0;
  PUSH 0;
 {$ELSE}
  XOR AX,AX;
  PUSH AX;
  PUSH AX;
 {$ENDIF}
 CALL SetCursorPos;
END;

Procedure SetCursorPos;
Assembler;
ASM
 CMP IVid.Graf,Byte(True);
 JE @@End;
 CMP DirectVideo,Byte(True);
 JE  @@Direct;
@@Bios:
 MOV AH,$02;
 MOV DL,X;
 MOV Byte Ptr VideoBankSwitch.XCur,DL;
 MOV DH,Y;
 MOV Byte Ptr VideoBankSwitch.YCur,DH;
 MOV BH,0;
 INT $10;
 JMP @@End;
@@Direct:
 {$IFOPT G+}
  PUSH $0000;
  POP  ES;
 {$ELSE}
  XOR AX,AX;
  MOV ES,AX;
 {$ENDIF}
 MOV AL,Y;
 MOV Byte Ptr VideoBankSwitch.YCur,AL;
 MOV AH,IVid.NmXTxts;
 MUL AH;
 XOR DH,DH;
 MOV DL,X;
 MOV Byte Ptr VideoBankSwitch.XCur,DL;
 ADD AX,DX;
 MOV DX,ES:[$0463];
 MOV BX,AX;
 MOV AL,$0E;
 OUT DX,AX;
 INC AL;
 MOV AH,BL;
 OUT DX,AX;
@@End:
END;

Procedure SimpleCursor;
Begin
 SetCursor(IVid.HeightChr-2,IVid.HeightChr-1);
End;

Procedure CursorInit;
Begin
 If(IVid.Graf)Then
 Begin
  CurBufSize := GetSizeSmlImg(0,0,31,31); CurBuf := MemAlloc(CurBufSize);
  If(MainData^.TBuffer = NIL)or(CurBuf = NIL)Then
  Begin
   WriteLn('Manque de m‚moire!');
   Halt;
  End;
  FillChar(CurBuf^,CurBufSize,0);
 End;
End;

END.