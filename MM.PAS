(*********************************************************)
(*                                                       *)
(*             Malte Genesis/Memory Manager              *)
(*          Phoenix Edition for Real Mode Only           *)
(*                   II - Version 1.8                    *)
(*                      1994/12/29                       *)
(*                                                       *)
(*       Copyright (C) par les Chevaliers de Malte       *)
(*                                                       *)
(*********************************************************)

Unit MM;

INTERFACE

Uses Math;

Var SegAlloc,SizeParagraph:Word;

Procedure FreeAllHeap;
Procedure FreeMaxHeap;
Procedure MaxExpandHeap;

Function FreeHeap(SizeP:Word):Bool;

IMPLEMENTATION

Var

    OldExitProc : Pointer;

Procedure Done; Far;
Begin
 If(SegAlloc > 0)Then
 ASM
  MOV AH,$49;
  MOV ES,SegAlloc;
  INT $21;
 END;
 ExitProc := OldExitProc;
End;

Procedure FreeAllHeap;
Begin
 FreeHeap(SizeParagraph);
End;

Procedure FreeMaxHeap;
Begin
 FreeHeap(PtrRec(HeapEnd).Seg-PtrRec(FreeList).Seg);
End;

Function FreeHeap(SizeP:Word):Bool;
Var FreeAll : Bool;
Begin
 FreeHeap := False;
 If(SizeP > SizeParagraph)Then Exit;
 FreeAll := (SizeP = SizeParagraph);
 If(SegAlloc+SizeP < PtrRec(HeapPtr).Seg)Then Exit;
 If(SegAlloc+SizeP < PtrRec(FreeList).Seg)Then Exit;
 ASM
  MOV AH,$4A;
  MOV BX,SizeParagraph;
  SUB BX,SizeP;
  MOV ES,SegAlloc;
  INT $21;
 END;
 If(FreeAll)Then
 Begin
  SegAlloc := 0;
  HeapOrg  := NIL;
  FreeList := HeapOrg;
  HeapPtr  := HeapOrg;
  HeapEnd  := HeapOrg;
 End
  Else
 HeapEnd := Ptr(SegAlloc+SizeP - 1,0);
 FreeHeap := True;
End;

Procedure MaxExpandHeap;
Begin
 If(SegAlloc = 0)Then
 Begin
  ASM
   MOV AH,$48;
   MOV BX,$FFFF;
   INT $21;
   MOV SizeParagraph,BX;
   MOV AH,$48;
   INT $21;
   MOV SegAlloc,AX;
  END;
  If(SizeParagraph > 0)Then
  Begin
   HeapOrg  := Ptr(SegAlloc,0);
   FreeList := HeapOrg;
   HeapPtr  := HeapOrg;
   HeapEnd  := Ptr(SegAlloc + SizeParagraph - 1,0);
  End
   Else
  SegAlloc := 0;
 End
  Else
 Begin
  ASM
   MOV AH,$4A;
   MOV ES,SegAlloc;
   MOV BX,$FFFF;
   INT $21;
   MOV AH,$4A;
   MOV SizeParagraph,BX;
   MOV ES,SegAlloc;
   INT $21;
  END;
  HeapEnd := Ptr(SegAlloc+SizeParagraph - 1,0);
 End;
End;

BEGIN
 ASM
  MOV AH,$48;
  MOV BX,$FFFF;
  INT $21;
  MOV SizeParagraph,BX;
  MOV AH,$48;
  INT $21;
  MOV SegAlloc,AX;
 END;
 If(SizeParagraph > 0)Then
 Begin
  HeapOrg  := Ptr(SegAlloc,0);
  FreeList := HeapOrg;
  HeapPtr  := HeapOrg;
  HeapEnd  := Ptr(SegAlloc + SizeParagraph - 1,0);
 End
  Else
 SegAlloc := 0;
 OldExitProc := ExitProc;
 ExitProc := @Done;
END.