{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³              Malte Genesis/Module des M‚moires             ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Memorys;

INTERFACE

{$F+,I-,Q-,R-,S-,X+}

Uses Dos,Math,Mems;

Const

      __None = 0; __Disk = 1; __EMS = 2; __XMS = 3; __VRAM = 4; __EXTBIOS = 5;

       { Disk }

      ReadOnly = 0; WriteOnly = 1; Normal = 2;

       { Cmos }

      portCmosAT = $70; portCmosXT = $E0;
      CmosTimeBinary = 0; CmosTimeBCD = 1;

       { Vram }

      VramAutoDetectMemory = $FFFFFFFF;

Type

       { Disk }

     VSIndexRec = Record Lo,Hi:Long; Methode:Byte; Pos:Long; End;

       { Cmos }

     CmosType = Array[0..63] of Byte;

       { XMS }
     Bit32Struct = Long;

     ExtMemMoveStruct = Record
      Length:Bit32Struct;
      SourceHandle:Word;
      SourceOffset:Bit32Struct;
      DestHandle:Word;
      DestOffset:Bit32Struct;
     End;

     EMBHandleStruct = Record
      LockCount:Byte;
      FreeHandles:Byte;
      BlockLenKB:Word;
     End;

     UMBSegStruct = Record
      Seg,UMBSizeKB:Word;
     End;

     MemSwp = Object
      BytesSize:Long;
      Constructor Init;
      Function SetSize(Size:Long):Bool;
      Procedure GetRec(P:Long;Size:Word;Var Buf);
      Procedure SetRec(P:Long;Size:Word;Var Buf);
      Procedure _GetRec(Size:Word;Var Buf);
      Procedure _SetRec(Size:Word;Var Buf);
      Procedure SetPos(P:Long);
      Function GetPos:Long;
      Destructor Done;
      PRIVATE
      Output:Byte;
      Handle:Word;
     End;

     VirtuelSwp = Object
      Exist,OptSize:Bool;
      Err:^Byte;
      Constructor Init(Size:Long);
      Procedure Reset;
      Procedure SetOff;
      Procedure SetOn;
      Function GetFree:Long;
      Function GetUsed:Long;
      Function GetSize:Long;
      Function GetPos(_Handle:Word):Long;
      Function New(Size:Long):Word;
      Function ReSize(_Handle:Word;NewSize:Long):Bool;
      Procedure SetMethode(_Handle:Word;Methode:Byte);
      Procedure SetPos(_Handle:Word;Pos:Long);
      Procedure GetRec(_Handle:Word;P:Long;Size:Word;Var Buf);
      Procedure SetRec(_Handle:Word;P:Long;Size:Word;Var Buf);
      Function _Del(_Handle:Word):Bool;
      Procedure _GetRec(_Handle,Size:Word;Var Buf);
      Procedure _SetRec(_Handle,Size:Word;Var Buf);
      Destructor Done;
      PRIVATE
      InitManager:Function:Bool;
      DoneManager:Function:Bool;
      IOGetSize:Function:Long;
      IOSetPos:Procedure(P:Long);
      IO_GetRec:Procedure(Size:Word;Var Buf);
      IO_SetRec:Procedure(Size:Word;Var Buf);
      SizeMem,FreeMem,MaxAddr,UsedAddr,FreeAddr:Long;
      Index:RBuf;
      Function PosIsUsed(Pos,Size:Long):Bool;
     End;

Var

    PathDiskSwap:PathStr; EmmError:Byte;
    XmsError,ExtBiosError:Byte;
    VSwp:Array[__Disk..__ExtBios] of VirtuelSwp;
    NoEms,VSwpInit:Bool;

Procedure DoneMemManagers;
Procedure ExtBiosCopy(Start,But:Long;Len:Word);
Procedure ExtBiosRead(ExtAddr:Long;BuPtr:Pointer;Len:Word);
Procedure ExtBiosWrite(BuPtr:Pointer;ExtAddr:Long;Len:Word);
Procedure GetCmos(PortIO:Word;Var Cmos:CmosType);
Procedure InitMemManagers;
Procedure VramSetOff;
Procedure VramSetOn;

Function AllocExtMemBlockXMS(Malloc:Word):Word;
Function CmosExist:Bool;
Function CmosTimeFormat(Cmos:CmosType):Byte;
Function CmosVideo(Cmos:CmosType):Byte;
Function CmosWord(Cmos:CmosType;P:Byte):Word;
Function EMBHandleInfoXMS(Handle:Word;Var HStructure:EMBHandleStruct):Word;
Function EmmExist:Bool;
Function EmmFreePage:Int;
Function EmmNumPage:Int;
Function EmmAlloc(Size:Word):Word;
Function EmmSeg:Word;
Function EmmSetMapping(Handle:Word;Plane:Byte;Page:Word):Byte;
Function EmmSaveMapping(Handle:Word):Byte;
Function ExtBiosExist:Bool;
Function FreeExtMemBlockXMS(Handle:Word):Word;
Function FreeMemHMA:Word;
Function GetCmosPortIO:Word;
Function GetMemHMA(Malloc:Word):Word;
Function GetRevHiMem:Byte;
Function GetVerHiMem:Byte;
Function GlobalDisableA20:Word;
Function GlobalEnableA20:Word;
Function LocalDisableA20:Word;
Function LocalEnableA20:Word;
Function LockExtMemBlockXMS(Handle:Word):Bit32Struct;
Function MoveExtMemBlockXMS(Var MoveStructure:ExtMemMoveStruct):Word;
Function QueryA20:Word;
Function QueryFreeBlockXMS:Word;
Function QueryFreeMemXMS:Word;
Function ReallocExtMemBlockXMS(Handle,KBsize:Word):Word;
Function RelUpperMemBlockUMB(_Seg:Word):Word;
Function ReqUpperMemBlockUMB(Malloc:Word;Var USeg:UMBSegStruct):Word;
Function ToBcd(Nb:Byte):Byte;
Function UnlockExtMemBlockXms(Handle:Word):Word;
Function XmsErrorMsg:String;
Function XmsExist:Bool;

IMPLEMENTATION

Uses Strings,Strs,Systems,Video,Clock;

Procedure DiskSwpInitFile; Forward;
Function DiskSwpDoneManager:Bool; Forward;
Function DiskSwpGetSize:Long; Forward;
Function DiskSwpInitManager:Bool; Forward;
Function EmsDoneManager:Bool; Forward;
Function EmsGetSize:Long; Forward;
Function EmsInitManager:Bool; Forward;
Function VramDoneManager:Bool; Forward;
Function VramGetSize:Long; Forward;
Function VramInitManager:Bool; Forward;

Const

      { XMS }
     XmsInit:Bool = False;
     IsXMS:Bool = False;
     XMM_Control:Array[0..1] of Word = (0,0);
      { EMM }
     IsEmm:Bool = False;
     PosAbs = 0;
     PosCur = 1;
     PosEnd = 2;
     EMMName:Array[0..7] of Char = 'EMMXXXX0';
Var

    DiskSwp:Record Init:Bool; MaxAddr:Long; Handle:Word; End;
    Ems:Record Init:Bool;MaxAddr:Long;Handle,Seg:Word;End;
    ExtBios:Record SizeK:Word; End;
    Vram:Record
     Init:Bool; MaxAddr,HomeAddr:Long;
     Memory:Record Case Byte of 0:(L:Long); 1:(W:Word;Page:Byte); End;
    End;

Procedure IODiskSetPos(P:Long);
Begin
 Systems.SetFilePos(DiskSwp.Handle,P);
End;

Procedure IODiskGetRec(Size:Word;Var Buf);
Begin
 Systems._GetRec(DiskSwp.Handle,Size,Buf);
End;

Procedure IODiskSetRec(Size:Word;Var Buf);
Begin
 Systems._SetRec(DiskSwp.Handle,Size,Buf);
End;

Var IOEmsP:Long;

Procedure IOEmsSetPos(P:Long);
Begin
 IOEmsP := P;
End;

Procedure IOEms_GetRec(Size:Word;Var Buffer);
Const SzPg = 16384;
Var a1,a2:Long; l,a1W:Word; EBuf:TByte Absolute Buffer;
Begin
 If(Ems.Init)Then
 Begin
  a1 := IOEmsP; a2 := a1 + (Size - 1); a1W := (a1 mod SzPg);
  EmmSetMapping(Ems.Handle,0,a1 div SzPg);
  If((a1 div SzPg) = (a2 div SzPg))Then Move(Mem[Ems.Seg:a1W],Buffer,Size)
   Else
  Begin
   l := (SzPg - (1+a1W));
   Move(Mem[Ems.Seg:a1W],Buffer,l);
   EmmSetMapping(Ems.Handle,0,a2 div SzPg);
   Move(Mem[Ems.Seg:0],EBuf[l],Size-l);
  End;
 End;
End;

Procedure IOEms_SetRec(Size:Word;Var Buffer);
Const SzPg = 16384;
Var a1,a2:Long; l,a1W:Word; EBuf:TByte Absolute Buffer;
Begin
 If(Ems.Init)Then
 Begin
  a1 := IOEmsP; a2 := a1 + (Size - 1);
  a1W := (a1 mod SzPg);
  EmmSetMapping(Ems.Handle,0,a1 div SzPg);
  If((a1 div SzPg) = (a2 div SzPg))Then Move(Buffer,Mem[Ems.Seg:a1W],Size)
   Else
  Begin
   l := (SzPg - (1+a1W));
   Move(Buffer,Mem[Ems.Seg:a1W],l);
   EmmSetMapping(Ems.Handle,0,a2 div SzPg);
   Move(EBuf[l],Mem[Ems.Seg:0],Size-l);
  End;
 End;
End;

Var IOVramP:Long;

Procedure IOVramSetPos(P:Long);
Begin
 IOVramP := P;
End;

Procedure IOVram_GetRec(Size:Word;Var Buffer);
Var a1,a2:Record Case Byte of 0:(L:Long); 1:(W:Word;Page:Byte); End;
    VBuf:TByte Absolute Buffer; l:Word;
Begin
 If(Vram.Init)Then
 Begin
  a1.L := Vram.HomeAddr + IOVramP; a2.L := a1.L + Long(Size - 1);
  MainData^.SelBankPg(a1.Page);
  If(a1.Page = a2.Page)Then Move(Mem[IVid.SegV:a1.W],Buffer,Size)
   Else
  Begin
   l := ($FFFF - a1.W);
   Move(Mem[IVid.SegV:a1.W],Buffer,l);
   MainData^.SelBankPg(a2.Page);
   Move(Mem[IVid.SegV:0],VBuf[l],Size - l);
  End;
 End;
End;

Procedure IOVram_SetRec(Size:Word;Var Buffer);
Var a1,a2:Record Case Byte of 0:(L:Long); 1:(W:Word;Page:Byte); End;
    VBuf:TByte Absolute Buffer; l:Word;
Begin
 If(Vram.Init)Then
 Begin
  a1.L := Vram.HomeAddr + IOVramP; a2.L := a1.L + Long(Size - 1);
  MainData^.SelBankPg(a1.Page);
  If(a1.Page = a2.Page)Then Move(Buffer,Mem[ModeInfVid.SegV:a1.W],Size)
   Else
  Begin
   l := ($FFFF - a1.W);
   Move(Buffer,Mem[IVid.SegV:a1.W],l);
   MainData^.SelBankPg(a2.Page);
   Move(VBuf[l],Mem[IVid.SegV:0],Size - l);
  End;
 End;
End;

Constructor VirtuelSwp.Init;
Begin
 Exist := False; OptSize := False; SizeMem := Size; FreeMem := Size;
 FreeAddr := 0; UsedAddr := FreeAddr; MaxAddr := Size - 1;
 Index.Init;
End;

Function VirtuelSwp.GetSize;
Begin
 If(Exist)Then GetSize := SizeMem Else GetSize := 0;
End;

Function VirtuelSwp.GetFree;
Begin
 If(Exist)Then GetFree := FreeMem Else GetFree := 0;
End;

Function VirtuelSwp.GetUsed;
Begin
 If(Exist)Then GetUsed := (SizeMem - FreeMem) Else GetUsed := 0;
End;

Procedure VirtuelSwp.Reset;
Begin
 If(Exist)Then
 Begin
  Index.Done;
  Index.Init;
  SizeMem := IOGetSize; FreeMem := SizeMem; FreeAddr := 0;
  UsedAddr := FreeAddr; MaxAddr := SizeMem - 1;
 End;
End;

Procedure VirtuelSwp.SetOff;
Begin
 If(Exist)Then
 Begin
  DoneManager;
  Index.Done;
  Index.Init;
  Exist := False;
 End;
End;

Procedure VirtuelSwp.SetOn;
Begin
 If Not(Exist)Then
 Begin
  InitManager;
  SizeMem := IOGetSize; FreeMem := SizeMem; FreeAddr := 0;
  UsedAddr := FreeAddr; MaxAddr  := SizeMem - 1; Exist := True;
 End;
End;

Function VirtuelSwp.PosIsUsed;
Var I:Long; TIndex:^VSIndexRec;
Begin
 PosIsUsed := False;
 If(Exist)Then
 Begin
  If(Pos > MaxAddr)Then
  Begin
   If(Pos + Size <= SizeMem)Then Exit
    Else
   Begin
    PosIsUsed := True;
    Exit;
   End;
  End;
  Index.SetPtr(0);
  For I := 0 to Index.MaxBuf do
  Begin
   TIndex := Index._GetCurrBuf;
   If(((TIndex^.Lo >= Pos)and(TIndex^.Hi <= Pos))or
     ((TIndex^.Lo >= Pos + Size)and(TIndex^.Hi <= Pos + Size)))Then
   Begin
    PosIsUsed := True;
    Exit;
   End;
   Index.Next;
  End;
 End
  Else
 PosIsUsed := True;
End;

Function VirtuelSwp.New;
Var I,_Handle,Pos:Long; TIndex:VSIndexRec; PIndex:^VSIndexRec;
    Ptr:Pointer Absolute PIndex; Ok:Bool;
Begin
 New := $FFFF;
 If(Exist)Then
 Begin
  If(FreeMem < Size)Then Exit Else Dec(FreeMem,Size);
  If(Index.IsEmpty)Then Pos := 0
   else
  Begin
   Ok := False;
   If(OptSize)Then
   Begin
    Index.SetPtr(0);
    For I := 0 to Index.MaxBuf do
    Begin
     PIndex := Index._GetCurrBuf; Pos := PIndex^.Hi + 1;
     If Not(PIndex^.Lo = $FFFFFFFF)Then
     Begin
      If Not(PosIsUsed(Pos,Size))Then
      Begin
       Ok := True;
       Break;
      End;
     End;
     Index.Next;
    End;
   End
    Else
   For I := Index.MaxBuf downto 0 do
   Begin
    PIndex := Index._GetBuf(I); Pos := PIndex^.Hi + 1;
    If Not(PosIsUsed(Pos,Size))Then
    Begin
     Ok := True;
     Break;
    End;
   End;
   If Not(Ok)Then Exit;
  End;
  TIndex.Methode := Normal; TIndex.Lo := Pos; TIndex.Hi := Pos + Size;
  If(TIndex.Hi > UsedAddr)Then UsedAddr := TIndex.Hi;
  TIndex.Pos := 0; Ok := False;
  Index.SetPtr(0);
  For I := 0 to Index.MaxBuf do
  Begin
   PIndex := Index._GetCurrBuf; Pos := PIndex^.Hi + 1;
   If(PIndex^.Lo = $FFFFFFFF)Then
   Begin
    Ok := True;
    Break;
   End;
   Index.Next;
  End;
  If Not(Ok)Then
  Begin
   If Not(Index.AddBuf(SizeOf(Index),Ptr))Then Exit;
   If(Ptr = NIL)Then Exit;
  End;
  Move(TIndex,Ptr^,SizeOf(Index));
  New := Index.MaxBuf;
 End;
End;

Function VirtuelSwp.ReSize;
Var TIndex:^VSIndexRec;
Begin
 ReSize := False;
 If(Exist)Then
 Begin
  TIndex := Index._GetBuf(_Handle);
  If(TIndex = NIL)Then Exit;
  If(NewSize < (TIndex^.Hi - TIndex^.Lo))Then
  Begin
   If(NewSize = 0)Then TIndex^.Hi := TIndex^.Lo
		  Else TIndex^.Hi := TIndex^.Lo + NewSize - 1;
   ReSize := True;
  End;
 End;
End;

Procedure VirtuelSwp.SetMethode;
Var TIndex:^VSIndexRec;
Begin
 If(Exist)Then
 Begin
  TIndex := Index._GetBuf(_Handle);
  If(TIndex = Nil)Then Exit;
  TIndex^.Methode := Methode;
 End;
End;

Procedure VirtuelSwp.SetPos;
Var TIndex:^VSIndexRec;
Begin
 If(Exist)Then
 Begin
  TIndex := Index._GetBuf(_Handle);
  If(TIndex = Nil)Then Exit;
  TIndex^.Pos := Pos;
 End;
End;

Function VirtuelSwp.GetPos;
Var TIndex:^VSIndexRec;
Begin
 If(Exist)Then
 Begin
  TIndex := Index._GetBuf(_Handle);
  If(TIndex = Nil)Then Exit;
  GetPos := TIndex^.Pos;
 End;
End;

Procedure VirtuelSwp.SetRec;
Begin
 SetPos(_Handle,P*Long(Size));
 _SetRec(_Handle,Size,Buf);
End;

Procedure VirtuelSwp.GetRec;
Begin
 SetPos(_Handle,P*Long(Size));
 _GetRec(_Handle,Size,Buf);
End;

Function VirtuelSwp._Del;
Var TInd,NInd:^VSIndexRec; Size:Long;
Begin
 _Del := False;
 If(Exist)Then
 Begin
  If(_Handle >= Index.NmBuf)Then Exit;
  TInd := Index._GetBuf(_Handle);
  If(TInd = NIL)Then Exit;
  Size := (TInd^.Hi - TInd^.Lo); Inc(FreeMem,Size);
  If(_Handle < Index.MaxBuf)Then
  Begin
   TInd^.Lo := $FFFFFFFF; TInd^.Hi := $FFFFFFFF;
  End
   Else
  _Del := Index.DelBuf(_Handle);
 End;
End;

Procedure VirtuelSwp._GetRec;
Var TInd:^VSIndexRec;
Begin
 If(Exist)Then
 Begin
  TInd := Index._GetBuf(_Handle);
  If(TInd = NIL)or(TInd^.Methode = WriteOnly)Then
  Begin
   FillChar(Buf,Size,0);
   Exit;
  End;
  IOSetPos(TInd^.Pos + TInd^.Lo);
  IO_GetRec(Size,Buf);
 End;
End;

Procedure VirtuelSwp._SetRec;
Var TInd:^VSIndexRec;
Begin
 If(Exist)Then
 Begin
  TInd := Index._GetBuf(_Handle);
  If(TInd^.Methode = ReadOnly)Then Exit;
  IOSetPos(TInd^.Pos + TInd^.Lo);
  IO_SetRec(Size,Buf);
 End;
End;

Destructor VirtuelSwp.Done;
Var Ptr:Pointer Absolute DoneManager;
Begin
 If(Exist)Then If Not(Ptr = NIL)Then DoneManager;
 Index.Done;
End;

Procedure InitMemManagers;
Var I:Byte;
Begin
 DiskSwpInitManager;
 VSwp[__Disk].Init(DiskSwpGetSize);
 VSwp[__Disk].Exist := True; VSwp[__Disk].OptSize := True;
 VSwp[__Disk].Err := @FileError;
 VSwp[__Disk].InitManager := DiskSwpInitManager;
 VSwp[__Disk].IOSetPos := IODiskSetPos;
 VSwp[__Disk].IO_GetRec := IODiskGetRec;
 VSwp[__Disk].IO_SetRec := IODiskSetRec;
 VSwp[__Disk].IOGetSize := DiskSwpGetSize;
 VSwp[__Disk].DoneManager := DiskSwpDoneManager;
 VSwp[__EMS].Init(EmsGetSize);
 VSwp[__EMS].Exist := (EmmExist)and(Not(NoEms));
 VSwp[__EMS].Err := @EmmError;
 VSwp[__EMS].InitManager := EmsInitManager;
 VSwp[__EMS].IOSetPos := IOEmsSetPos;
 VSwp[__EMS].IO_GetRec := IOEms_GetRec;
 VSwp[__EMS].IO_SetRec := IOEms_SetRec;
 VSwp[__EMS].IOGetSize := EmsGetSize;
 VSwp[__EMS].DoneManager := EmsDoneManager;
 VSwp[__XMS].Init(0);
 VSwp[__XMS].Exist := {XmsExist}False;
 VSwp[__XMS].Err := @XmsError;
 VSwp[__VRAM].Init(VramGetSize);
 VSwp[__VRAM].Exist := False;
 VSwp[__VRAM].Err := NIL;
 VSwp[__VRAM].InitManager := VramInitManager;
 VSwp[__VRAM].IOSetPos := IOVramSetPos;
 VSwp[__VRAM].IO_GetRec := IOVram_GetRec;
 VSwp[__VRAM].IO_SetRec := IOVram_SetRec;
 VSwp[__VRAM].IOGetSize := VramGetSize;
 VSwp[__VRAM].DoneManager := VramDoneManager;
 VSwp[__EXTBIOS].Init(0);
 VSwp[__EXTBIOS].Exist := False;
 VSwp[__EXTBIOS].Err := @ExtBiosError;
 For I := __EMS to __EXTBIOS do If(VSwp[I].Exist)Then VSwp[I].InitManager;
 VSwpInit := True;
End;

Procedure DoneMemManagers;
Var I:Byte;
Begin
 If(VSwpInit)Then For I := __Disk to __ExtBios do VSwp[I].Done;
 VSwpInit := False;
End;

Constructor MemSwp.Init;
Begin
 Output := __None; Handle := 65535; BytesSize := -1;
End;

Function MemSwp.SetSize;
Var I:Byte;
Begin
 SetSize := False; BytesSize := Size;
 For I := 5 downto 1 do
 Begin
  If(Not(I = __VRAM))and(VSwp[I].Exist)Then
  Begin
   Handle := VSwp[I].New(Size);
   If(IsHandle(Handle))Then
   Begin
    Output := I; SetSize := True;
    Exit;
   End;
  End;
 End;
End;

Procedure MemSwp.GetRec;
Begin
 VSwp[Output].GetRec(Handle,P,Size,Buf);
End;

Procedure MemSwp.SetRec;
Begin
 VSwp[Output].SetRec(Handle,P,Size,Buf);
End;

Procedure MemSwp._GetRec;
Begin
 VSwp[Output]._GetRec(Handle,Size,Buf);
End;

Procedure MemSwp._SetRec;
Begin
 VSwp[Output]._SetRec(Handle,Size,Buf);
End;

Procedure MemSwp.SetPos;
Begin
 VSwp[Output].SetPos(Handle,P);
End;

Function MemSwp.GetPos;
Begin
 GetPos := VSwp[Output].GetPos(Handle);
End;

Destructor MemSwp.Done;
Begin
 VSwp[Output]._Del(Handle);
 Output := __None;
End;

Function AllocExtMemBlockXMS(Malloc:Word):Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXMS,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV DX,Malloc;
 MOV AH,$09;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,BL;
 MOV AX,DX;
@@End:
End;

Function CmosExist:Bool;
Var I : Word;
Begin
 If(Mem[$FFFF:$E] = 252)Then CMOSExist := True
  else
 Begin
  For I := 0 to $FFF0 do
 Begin
   If(Char(Mem[$F000:I]) = 'C')Then
   Begin
    If(Char(Mem[$F000:I+1]) = 'M')Then
    Begin
     If(Char(Mem[$F000:I+2]) = 'O')Then
     Begin
      If(Char(Mem[$F000:I+3]) = 'S')Then
      Begin
       CmosExist := True;
       Exit;
      End;
     End;
    End;
   End;
  End;
  CmosExist := False;
  Exit;
 End;
End;

Function CmosTimeFormat(Cmos:CmosType):Byte;
Begin
 If(Cmos[11] and 4 = 0)Then CmosTimeFormat := CmosTimeBCD
		       Else CmosTimeFormat := CmosTimeBinary;
End;

Function CmosVideo(Cmos:CmosType):Byte;
Begin
 CmosVideo := ((Cmos[$14] and 63) shr 4);
End;

Function CmosWord(Cmos:CmosType;P:Byte):Word;
Begin
 CmosWord := Cmos[P] + (Cmos[P+1] shl 8);
End;

Function DiskSwpDoneManager:Bool;
Begin
 Systems.Close(DiskSwp.Handle);
 Systems.Del(PathDiskSwap);
 DiskSwp.Init := False; DiskSwpDoneManager := True;
End;

Function DiskSwpGetSize:Long;
Begin
 DiskSwpGetSize := DiskSwp.MaxAddr + 1;
End;

Procedure DiskSwpInitFile;
Begin
 Systems.Del(PathDiskSwap);
 DiskSwp.Handle := Systems.New(PathDiskSwap);
 If(Systems.IsHandleErr(DiskSwp.Handle))Then Exit;
End;

Function DiskSwpInitManager:Bool;
Var Disk:Byte;
Begin
 If Not(DiskSwp.Init)Then
 Begin
  Disk := Path2Disk(PathDiskSwap) + 1;
  DiskSwp.MaxAddr := Dos.DiskFree(Disk) - 1;
  DiskSwp.Init := (DiskSwp.MaxAddr > 0);
  DiskSwpInitManager := DiskSwp.Init;
  DiskSwpInitFile;
 End
  Else
 DiskSwpInitManager := True;
End;

Function EMBHandleInfoXms(Handle:Word;Var HStructure:EMBHandleStruct):Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXMS,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV DX,Handle;
 MOV AH,$0E;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 LES DI,HStructure;
 XCHG BL,BH;
 MOV ES:[DI],BX;                { LockCount & FreeHandles }
 MOV ES:[DI+(SizeOfByte*2)],DX; { BlockLenKB }
 MOV XmsError,0;
@@End:
End;

Function EmmExist:Bool;
Var Address:Pointer; Table:^TChar; I:Byte;
Begin
 EmmError := 0;
 GetIntVec($67,Address);
 If(Address = NIL)Then EmmExist := False
  Else
 Begin
  Table := Ptr(Seg(Address^),10);
  For I := 0 to 7 do
  Begin
   If(EmmName[I] <> Table^[I])Then
   Begin
    EmmExist := False;
    Exit;
   End;
  End;
  EmmExist := True; IsEmm := True;
 End;
End;

Function EmmFreePage:Int;
Assembler;
ASM
 XOR AX,AX;
 CMP IsEmm,Byte(False);
 JE  @@End;
 MOV AH,$42;
 INT $67;
 CMP AH,0;
 JE  @@NumPage;
 MOV EmmError,AH;
 XOR AX,AX;
@@NumPage:
 MOV AX,BX;
@@End:
END;

Function EmmNumPage:Int;
Assembler;
ASM
 XOR AX,AX;
 CMP IsEmm,Byte(False);
 JE  @@End;
 MOV AH,$42;
 INT $67;
 MOV EmmError,AH;
 CMP AH,0;
 JE  @@NumPage;
 XOR AX,AX;
@@NumPage:
 MOV AX,DX;
@@End:
END;

Function EmmRestore(Handle:Word):Byte;
Assembler;
ASM
 CMP IsEmm,Byte(False);
 JE  @@End;
 MOV AH,$45;
 MOV DX,Handle;
 INT $67;
 MOV AL,AH;
 MOV EmmError,AH;
@@End:
END;

Function EmmAlloc(Size:Word):Word;
Assembler;
ASM
 CMP IsEmm,Byte(False);
 JE  @@End;
 MOV AH,$43;
 MOV BX,Size;
 INT $67;
 MOV EmmError,AH;
 CMP AH,0;
 JE  @@Ok;
 MOV AX,-1;
 JMP @@End;
@@Ok:
 MOV AX,DX;
@@End:
END;

Function EmmSeg:Word;
Assembler;
ASM
 CMP IsEmm,Byte(False);
 JE  @@End;
 MOV AH,$41;
 INT $67;
 MOV AX,BX;
@@End:
END;

Function EmmSetMapping(Handle:Word;Plane:Byte;Page:Word):Byte;
Assembler;
ASM
 CMP IsEmm,Byte(False);
 JE  @@End;
 MOV AH,$44;
 MOV AL,Plane;
 MOV BX,Page;
 MOV DX,Handle;
 INT $67;
 MOV EmmError,AH;
 MOV AL,AH;
@@End:
END;

Function EmmSaveMapping(Handle:Word):Byte;
Assembler;
ASM
 CMP IsEmm,Byte(False);
 JE  @@End;
 MOV AH,$47;
 MOV DX,Handle;
 INT $67;
 MOV EmmError,AH;
 MOV AL,AH;
@@End:
END;

Function EmsDoneManager:Bool;
Begin
 If(Ems.Init)Then
 Begin
  EmmRestore(Ems.Handle);
  Ems.Init := False; EmsDoneManager := True;
 End
  Else
 EmsDoneManager := False;
End;

Function EmsGetSize:Long;
Begin
 If(Ems.Init)Then EmsGetSize := Ems.MaxAddr + 1 Else EmsGetSize := 0;
End;

Function EmsInitManager:Bool;
Var NumPages:Word;
Begin
 EmsInitManager := False;
 If Not(NoEms)Then
 Begin
  If Not(Ems.Init)Then
  Begin
   EmmExist;
   If Not(IsEmm)Then Exit;
   NumPages := EmmFreePage;
   Ems.Seg := EmmSeg;
   Ems.Handle := EmmAlloc(NumPages);
   If Not(EmmError = 0)Then Exit;
   Ems.MaxAddr := (LongInt(NumPages) * 16384) - 1;
   Ems.Init := True;
   EmsInitManager := Ems.Init;
  End
   Else
  EmsInitManager := True;
 End;
End;

Procedure ExtBiosCopy(Start,But:Long;Len:Word);
Type SDES=Record
      Length,AdrLo:Word; AdrHi,Attribut:Byte; Res:Word;
     End;
     GDT=Record
      Dummy,GDTS,Start,But,Code,Stack:SDES;
     End;
     LI=Record
      LoWord:Word; HiByte,Dummy:Byte;
     End;
Var GTab:GDT; Adr:Long; _Seg,_Ofs:Word;
Begin
 FillChar(GTab,SizeOf(GTab),0);
 GTab.Start.AdrLo := LI(Start).LoWord;
 GTab.Start.AdrHi := LI(Start).HiByte;
 GTab.Start.Attribut := $92;
 GTab.Start.Length := Len;
 GTab.But.AdrLo := LI(But).LoWord;
 GTab.But.AdrHi := LI(But).HiByte;
 GTab.But.Attribut := $92;
 GTab.But.Length := Len;
 _Seg := Seg(GTab); _Ofs := Ofs(GTab);
 ASM
  MOV AH,$87;
  MOV ES,_Seg;
  MOV SI,_Ofs;
  MOV CX,Len;
  SHR CX,1;
  INT $15;
  MOV ExtBiosError,AH;
 END;
End;

Function ExtBiosExist:Bool;
Assembler;
ASM
 MOV AH,$88;
 INT $15;
 CMP AX,0;
 JE  @@End;
 MOV ExtBios.SizeK,AX;
 MOV AL,Byte(True);
@@End:
END;

Procedure ExtBiosRead(ExtAddr:Long;BuPtr:Pointer;Len:Word);
Begin
 ExtBiosCopy(ExtAddr,AddrExt2Conv(BuPtr),Len);
End;

Procedure ExtBiosWrite(BuPtr:Pointer;ExtAddr:Long;Len:Word);
Begin
 ExtBiosCopy(AddrExt2Conv(BuPtr),ExtAddr,Len);
End;

Function FreeExtMemBlockXms(Handle:Word):Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXms,Byte(False);
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV DX,Handle;
 MOV AH,$0A;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,BL;
@@End:
END;

Function FreeMemHMA:Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXMS,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV AH,$02;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,BL;
@@End:
END;

Procedure GetCmos(PortIO:Word;Var Cmos:CmosType);
Var I:Byte;
Begin
 FillChar(Cmos,SizeOf(Cmos),0);
 For I := 0 to 63 do
 Begin
  Port[PortIO] := I;
  Delay(1);
  Cmos[I] := Port[PortIO+1];
 End;
End;

Function GetCmosPortIO:Word;
Begin
 If(Mem[$FFFF:$E] <= 252)Then GetCmosPortIO := portCmosAT
			 Else GetCmosPortIO := portCmosXT;
End;

Function GetMemHMA(Malloc:Word):Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXMS,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV DX,Malloc;
 MOV AH,$01;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,BL;
@@End:
END;

Function GetRevHiMem:Byte;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXMS,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,0;
 MOV AX,BX;
@@End:
End;

Function GetVerHiMem:Byte;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXMS,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,0;
@@End:
END;

Function GlobalDisableA20:Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXms,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV AH,$04;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,BL;
@@End:
END;

Function GlobalEnableA20:Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXMS,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV AH,$03;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,BL;
@@End:
END;

Function LocalDisableA20:Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXms,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV AH,$06;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,BL;
@@End:
END;

Function LocalEnableA20:Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXms,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV AH,$05;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,BL;
@@End:
END;

Function LockExtMemBlockXMS(Handle:Word):Bit32Struct;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 XOR DX,DX;
 CMP IsXms,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV DX,Handle;
 MOV AH,$0C;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV AX,BX;
 MOV BX,DX;
 MOV XmsError,0;
@@End:
END;

Function MoveExtMemBlockXms(Var MoveStructure:ExtMemMoveStruct):Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXms,AL;
 JE  @@End;
@@CallFunc:
 PUSH DS;
  PUSH DS;
  POP  ES;
  MOV DI,Offset XMM_Control;
  LDS SI,MoveStructure;
  MOV AH,$0B;
  PUSH BP;
   DB $26,$FF,$1D; { CALL FAR ES:[DI] }
  POP BP;
 POP  DS;
 MOV XmsError,BL;
@@End:
END;

Function QueryA20:Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXms,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV AH,$07;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,0;
@@End:
END;

Function QueryFreeBlockXms:Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXms,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV AH,$08;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP  BP;
 MOV XmsError,BL;
 MOV AX,DX;
@@End:
END;

Function QueryFreeMemXms:Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXms,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV AH,$08;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,BL;
@@End:
END;

Function ReallocExtMemBlockXMS(handle,KBsize:Word):Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXms,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV DX,Handle;
 MOV BX,KBSize;
 MOV AH,$0F;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP  BP;
 MOV XmsError,BL;
@@End:
END;

Function RelUpperMemBlockUMB(_Seg:Word):Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXms,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV DX,_Seg;
 MOV AX,$1100;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,BL;
@@End:
END;

Function ReqUpperMemBlockUMB(Malloc:Word;Var USeg:UMBSegStruct):Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXms,AL;
 JE  @@End;
@@CallFunc:
 MOV DI,Offset XMM_Control;
 MOV DX,Malloc;
 MOV AH,$10;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 LES DI,USeg;
 MOV ES:[DI],BX;            { USeg.Segment }
 CMP AX,1;
 JNE @@Next;
 MOV DX,Malloc;
@@Next:
 MOV ES:[DI+SizeOfWord],DX; { USeg.UMBSizeKB }
@@End:
END;

Function ToBcd(Nb:Byte):Byte;
Begin
 ToBcd := ((Nb and $F0) shr 4) * 10 + (Nb and $0F);
End;

Function UnlockExtMemBlockXms(Handle:Word):Word;
Assembler;
ASM
 MOV XmsError,$80;
 XOR AX,AX;
 CMP IsXms,AL;
 JE  @@End;
 MOV DI,Offset XMM_Control;
 MOV DX,Handle;
 MOV AH,$0D;
 PUSH BP;
  DB $FF,$1D; { CALL FAR [DI] }
 POP BP;
 MOV XmsError,BL;
@@End:
END;

Function VramDoneManager:Bool;
Begin
 Vram.Init := False; VramDoneManager := True;
End;

Function VramGetSize:Long;
Begin
 If(Vram.Init)Then VramGetSize := Vram.MaxAddr + 1
	      Else VramGetSize := 0;
End;

Function VramInitManager:Bool;
Begin
 VramInitManager := False;
 If Not(Vram.Init)Then
 Begin
  If(Vram.Memory.L = VramAutoDetectMemory)Then Vram.Memory.L := Video.GetVideoMemory;
  If(IVid.Graf)Then
  Begin
   If(Mem[_0040:$49] < $12)Then Vram.HomeAddr := $40000
			   Else Vram.HomeAddr := Long(GetNumXPixels) * Long(GetNumYPixels);
  End
   Else
  Vram.HomeAddr := (GetNumXTexts * GetNumYTexts) * 2;
  Vram.MaxAddr := Vram.Memory.L - Vram.HomeAddr - 1;
  If((Vram.Memory.L - Vram.HomeAddr) <= 0)Then Exit;
  Vram.Init := True; VramInitManager := True;
 End
  Else
 VramInitManager := True;
End;

Function XmsErrorMsg:String;
Var XmsMsg:String;
Begin
 XmsMsg := '';
 Case XmsError of
  $00 : XmsMsg := 'Aucun erreur';
  $80 : XmsMsg := 'Fonction XMS appel‚e inconnue';
  $81 : XmsMsg := 'VDISK d‚tect‚';
  $82 : XmsMsg := 'Erreur sur canal d''adressage A20';
  $8E : XmsMsg := 'Erreur g‚n‚ral du driver';
  $8F : XmsMsg := 'Erreur irratrapable';
  $90 : XmsMsg := 'HMA n''existe pas';
  $91 : XmsMsg := 'HMA in use by another process';
  $92 : XmsMsg := 'Memory requested less than /HMAMIN= parameter';
  $93 : XmsMsg := 'HMA non-allou‚';
  $94 : XmsMsg := 'A20 est activ‚';
  $A0 : XmsMsg := 'All of Extended Memory is allocated';
  $A1 : XmsMsg := 'No Extended Memory Handles available';
  $A2 : XmsMsg := 'Extended Memory Handle is invalid';
  $A3 : XmsMsg := 'Extended Move Structure: Source Handle is invalid';
  $A4 : XmsMsg := 'Extended Move Structure: Source Offset is invalid';
  $A5 : XmsMsg := 'Extended Move Structure: Destination Handle is invalid';
  $A6 : XmsMsg := 'Extended Move Structure: Destination Offset is invalid';
  $A7 : XmsMsg := 'Extended Move Structure: Length is invalid';
  $A8 : XmsMsg := 'Extended Move Structure: Move has invalid overlap';
  $A9 : XmsMsg := 'Parity Error';
  $AA : XmsMsg := 'Block is not locked';
  $AB : XmsMsg := 'Block is locked';
  $AC : XmsMsg := 'Block Lock Count has overflowed';
  $AD : XmsMsg := 'Block Lock has failed';
  $B0 : XmsMsg := 'A smaller Upper Memory Block is available';
  $B1 : XmsMsg := 'No Upper Memory Blocks are available';
  $B2 : XmsMsg := 'Upper Memory Block Segment Number is invalid'
   Else XmsMsg := 'Unknown Error has occured'
 End;
 If(XmsMsg <> '')Then XmsErrorMsg := 'Erreur XMS ' +
				     HexByte2Str(XmsError) + 'h ' + XmsMsg;
End;

Function XmsExist:Bool;
Assembler;
ASM
 MOV AX,$4300;
 INT $2F;
 CMP AL,$80;
 JNE @@End;
 MOV AX,$4310;
 INT $2F;
 MOV XMM_Control.Word[0],BX;
 MOV XMM_Control.Word[SizeOfWord],ES;
 MOV AL,Byte(True);
 MOV IsXms,AL;
@@End:
END;

Var OldExitProc:Pointer;

Procedure Done; Far;
Begin
 If(Ems.Init)Then EmsDoneManager;
 If(DiskSwp.Init)Then DiskSwpDoneManager;
 ExitProc := OldExitProc;
End;

Procedure VramSetOff;
Begin
 If(VSwpInit)Then VSwp[__VRAM].SetOff;
End;

Procedure VramSetOn;
Begin
 If(VSwpInit)Then VSwp[__VRAM].SetOn;
End;

BEGIN
 PathDiskSwap := '\'; DiskSwp.Init := False; DiskSwp.Handle := $FFFF;
 NoEms := False; VSwpInit := False;
 Ems.Init := False; Ems.MaxAddr := 0; Ems.Handle := $FFFF;
 Vram.Init := False; Vram.Memory.L := VramAutoDetectMemory;
 OldExitProc := ExitProc; ExitProc := @Done;
 XmsError := 0; ExtBiosError := 0; EmmError := 0;
END.