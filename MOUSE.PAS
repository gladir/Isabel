{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³               Malte Genesis/Module de Souris               ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Mouse;

INTERFACE

{$I-,Q-,R-,S-,X+}

Uses Math;

Procedure DelayMsPress(Milli:Word);
Procedure GetMouseSwitch(Var X,Y,B:Word);
Procedure HideMousePtr;
Procedure InstallMouseSub(Flags:Word;Addr:Pointer);
Procedure SetMouse(Use:Bool);
Procedure SetMouseMoveArea(X1,Y1,X2,Y2:Word);
Procedure ShowMousePtr;
Procedure __DoneMouse;
Procedure __GetMouseTextSwitch(Var X,Y:Byte;Var B:Word);
Procedure __HideMousePtr;
Procedure __InitMouse;
Procedure __ShowMousePtr;

Function GetMouseButton:Byte;
Function InitMouse:Bool;
Function MouseDriverExist:Bool;
Function __GetMouseButton:Byte;

Var LastMsX,LastMsY:Byte;
    MouseInstalled:Bool;

IMPLEMENTATION

Uses Mems,Video,Images;

Const PtrMs : Array[0..31] of Word =
    (($3FFF),  {0011111111111111}
     ($1FFF),  {0001111111111111}
     ($0FFF),  {0000111111111111}
     ($07FF),  {0000011111111111}
     ($03FF),  {0000001111111111}
     ($01FF),  {0000000111111111}
     ($00FF),  {0000000011111111}
     ($007F),  {0000000001111111}
     ($003F),  {0000000000111111}
     ($001F),  {0000000000011111}
     ($01FF),  {0000000111111111}
     ($10FF),  {0001000011111111}
     ($30FF),  {0011000011111111}
     ($F87F),  {1111100001111111}
     ($F87F),  {1111100001111111}
     ($FC7F),  {1111110001111111}

     ($0000),  {0000000000000000}
     ($4000),  {0100000000000000}
     ($6000),  {0110000000000000}
     ($7000),  {0111000000000000}
     ($7800),  {0111100000000000}
     ($7C00),  {0111110000000000}
     ($7E00),  {0111111000000000}
     ($7F00),  {0111111100000000}
     ($7F80),  {0111111110000000}
     ($7C00),  {0111110000000000}
     ($6C00),  {0110110000000000}
     ($4600),  {0100011000000000}
     ($0600),  {0000011000000000}
     ($0300),  {0000001100000000}
     ($0300),  {0000001100000000}
     ($0000)); {0000000000000000}

Var MouseOldTextX,MouseOldTextY,MouseOldTextAttr:Byte;
    Button,BufMsSize:Word; MouseOldX,MouseOldY:Int;
    ShowMouse:Bool; BufMs:^TByte;

Procedure DelayMsPress(Milli:Word);
Var T,N:Word; TL:Long; Old,Curr:Byte;
Begin
 TL := Long((Long(Milli) * 182) div 10000); T := TL; N := 0; Old := Mem[_0040:$6C];
 Repeat
  If(__GetMouseButton = 0)Then Exit;
  Curr := Mem[_0040:$6C];
  If(Old <> Curr)Then
  Begin
   Old := Curr;
   Inc(N);
   If(N >= T)Then Exit;
  End;
 Until False;
End;

Procedure SavePtr;
Begin
 If Not(BufMs = NIL)Then GetSmlImg(MouseOldX,MouseOldY,MouseOldX+15,MouseOldY+15,BufMs^);
End;

Procedure RestorePtr;
Begin
 If Not(BufMs = NIL)Then
  PutSmlImg(MouseOldX,MouseOldY,MouseOldX+15,MouseOldY+15,BufMs^);
End;

Procedure PutPtr(X,Y:Int);
Var I,J:Int;
Begin
 For J := 0 to 15 do For I := 0 to 15 do
 Begin
  If(((PtrMs[J] shr I) and 1) = 0)Then SetPixel(X+(15-I),Y+J,0);
  If(((PtrMs[16+J] shr I) and 1) = 1)Then SetPixel(X+(15-I),Y+J,15);
 End;
End;

{$L MsPtr.Obj}

{$F+} Procedure GAssHand; External; {$F-}

Procedure GMouEventHandler(EvFlags,ButState,X,Y:Int); { *** NEAR *** }
Begin
 If((EvFlags and 1) = 1)Then
 Begin
  If((MouseOldX <> X)or(MouseOldY <> Y))Then
  Begin
   If(ShowMouse)Then RestorePtr;
   MouseOldX := X; MouseOldTextX := X shr 3; MouseOldY := Y; MouseOldTextY := Y div IVid.HeightChr;
   SavePtr;
   If(ShowMouse)Then PutPtr(X,Y);
  End;
 End;
 Button := ButState;
End;

{$L SourisPascal.Obj}

{$F+} Procedure AssHand; External; {$F-}

Procedure MouEventHandler(EvFlags,ButState,X,Y:Int); { *** NEAR *** }
Begin
 If((EvFlags and 1) = 1)Then
 Begin
  If((MouseOldTextX <> X)or(MouseOldTextY <> Y))Then
  Begin
   If(ShowMouse)Then SetAttr(MouseOldTextX,MouseOldTextY,MouseOldTextAttr);
   MouseOldTextX := X; MouseOldTextY := Y; MouseOldTextAttr := GetAttr(X,Y);
   If(ShowMouse)Then SetAttr(X,Y,Not(MouseOldTextAttr));
  End;
 End;
 Button := ButState;
End;

Procedure __InitMouse;
Var X,Y,B:Word;
Begin
 If(BufMs <> NIL)Then
 Begin
  FreeMem(BufMs,BufMsSize);
  BufMs := NIL; BufMsSize := 0;
 End;
 InitMouse;
 ShowMouse := False;
 If Not((IVid.Graf)and(IVid.BitsPerPixel in [1,2,4]))Then
 Begin
 If(IVid.Graf)Then SetMouseMoveArea(0,0,MaxXTxts*8,MaxYTxts*IVid.HeightChr)
	      Else SetMouseMoveArea(0,0,MaxXTxts shl 3,MaxYTxts shl 3);
 GetMouseSwitch(X,Y,B);
 MouseOldX := X; MouseOldY := Y;
 MouseOldTextX := X shr 3; MouseOldTextY := Y shr 3;
 If(IVid.Graf)Then
 Begin
  BufMsSize := GetSizeSmlImg(0,0,15,15); BufMs := MemAlloc(BufMsSize);
  If(BufMs = NIL)Then Exit;
  SavePtr;
  InstallMouseSub(127,@GAssHand);
 End
  Else
 Begin
  MouseOldTextAttr := GetAttr(MouseOldTextX,MouseOldTextY);
  InstallMouseSub(127,@AssHand);
 End;
 End;
End;

Procedure __DoneMouse;
Begin
 __HideMousePtr;
 InitMouse;
End;

Procedure __HideMousePtr;
Begin
 ShowMouse := False;
 If((IVid.Graf)and(IVid.BitsPerPixel in [1,2,4]))Then HideMousePtr Else
 If(IVid.Graf)Then RestorePtr
	      Else SetAttr(MouseOldTextX,MouseOldTextY,MouseOldTextAttr);
End;

Procedure __ShowMousePtr;
Begin
 If((IVid.Graf)and(IVid.BitsPerPixel in [1,2,4]))Then ShowMousePtr Else
 If(IVid.Graf)Then
 Begin
  SavePtr;
  PutPtr(MouseOldX,MouseOldY);
 End
  Else
 Begin
  MouseOldTextAttr := GetAttr(MouseOldTextX,MouseOldTextY);
  SetAttr(MouseOldTextX,MouseOldTextY,Not(MouseOldTextAttr));
 End;
 ShowMouse := True;
End;

Function MouseDriverExist:Bool;
Assembler;
ASM
 MOV AX,$3533;
 INT $21;
 MOV AX,ES;
 OR  AX,BX;
 JZ  @@NoDriver;
 MOV AL,Byte(True);
 JMP @@End;
@@NoDriver:
 MOV AL,Byte(False);
@@End:
END;

Function InitMouse:Bool;
Assembler;
ASM
 CMP MouseInstalled,Byte(True);
 JNE @@End;
 XOR AX,AX;
 INT $33;
@@End:
END;

Procedure ShowMousePtr;
Assembler;
ASM
 CMP MouseInstalled,Byte(True);
 JNE @@End;
 MOV AX,$0001;
 INT $33;
@@End:
END;

Procedure HideMousePtr;
Assembler;
ASM
 CMP MouseInstalled,Byte(True);
 JNE @@End;
 MOV AX,$0002;
 INT $33;
@@End:
END;

Procedure GetMouseSwitch(Var X,Y,B:Word);
Assembler;
ASM
 CMP MouseInstalled,Byte(True);
 JNE @@NoDriver;
 MOV AX,$0003;
 INT $33;
 LES DI,X;
 MOV ES:[DI],CX;
 LES DI,Y;
 MOV ES:[DI],DX;
 LES DI,B;
 MOV ES:[DI],BX;
 JMP @@End;
@@NoDriver:
 XOR AX,AX;
 LES DI,X;
 MOV ES:[DI],AX;
 LES DI,Y;
 MOV ES:[DI],AX;
 LES DI,B;
 MOV ES:[DI],AX;
@@End:
END;

Procedure SetMouseMoveArea(X1,Y1,X2,Y2:Word);
Assembler;
ASM
 CMP MouseInstalled,Byte(True);
 JNE @@End;
 MOV AX,$0008;
 MOV CX,Y1;
 MOV DX,Y2;
 INT $33;
 MOV AX,$0007;
 MOV CX,X1;
 MOV DX,X2;
 INT $33;
@@End:
END;

Procedure InstallMouseSub(Flags:Word;Addr:Pointer);
Assembler;
ASM
 CMP MouseInstalled,Byte(True);
 JNE @@End;
 MOV AX,$000C;
 MOV CX,Flags;
 LES DX,Addr;
 INT $33;
@@End:
END;

Function GetMouseButton:Byte;
Var X,Y,B:Word;
Begin
 GetMouseSwitch(X,Y,B);
 GetMouseButton := B;
End;

Function __GetMouseButton:Byte;
Begin
 __GetMouseButton := GetMouseButton
End;

Procedure __GetMouseTextSwitch(Var X,Y:Byte;Var B:Word);
Var XW,YW:Word;
Begin
 If((IVid.Graf)and(IVid.BitsPerPixel in [1,2,4]))Then
 Begin
  GetMouseSwitch(XW,YW,B);
  X := XW div 8; Y := YW div 8;
 End
  Else
 Begin
  CLI;
  X := MouseOldTextX; Y := MouseOldTextY; B := Button;
  STI;
 End;
 LastMsX := X; LastMsY := Y;
End;

Procedure SetMouse(Use:Bool);
Begin
 If(Use)Then MouseInstalled := MouseDriverExist Else MouseInstalled := False;
End;

BEGIN
 MouseInstalled := MouseDriverExist; LastMsX := $FF; LastMsY := $FF;
 BufMs := NIL; BufMsSize := 0;
END.