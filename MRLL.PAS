Program MRLL;

{$M 16384,0,655360}
{$F+}

Uses Math,Mems,Systems;

Type
     Bool = Boolean;
     Long = LongInt;

     PhysicalInfoVideo = Record
      Card,Monitor:Byte;Memory:Long;Font,Hercule:Bool;Seg16C:Word;
      Palette,Color,BBlink,EGA,VGA,VGA320x400,VESA:Bool;
      ROM:Word;MousePort:Bool;VideoBits:Byte;ROMBits,DACBits:Byte;
      PVC:Bool; ProcSelBnkPg,ProcSetVideoMode:Word;
     End;

Var Ptr:^TByte;
    Handle,HandleIndex,S:Word;
    X1,X2:PhysicalInfoVideo;
    PtrFunc:Pointer;
    GetVideoCard:Procedure(CheckSVGA:Bool;Var Info1,Info2:PhysicalInfoVideo) Absolute PtrFunc;
    Pos:Long;

BEGIN
 Handle := Open('MAGICIAN.RLL',ReadOnly);
 If(IsHandleErr(Handle))Then Halt;
 HandleIndex := Open('MAGICIAN.GIR',ReadOnly);
 If(IsHandleErr(Handle))Then
 Begin
  Close(Handle);
  Halt;
 End;
 GetRec(HandleIndex,0,SizeOf(Long),Pos);
 Close(HandleIndex);
 S := FileSize(Handle);
 Ptr := MemAlloc(S);
 If(Ptr = NIL)Then Halt;
 GetRec(Handle,0,S,Ptr^);
 Close(Handle);
 PtrFunc := @Ptr^[Pos];
 GetVideoCard(True,X1,X2);
 WriteLn(X1.Card,X2.Card);
END.