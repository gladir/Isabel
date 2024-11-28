Unit Spooler;

INTERFACE

Uses Math;

Const SpoolName:String[12] = 'SPOOLER.PR$';

Procedure InitSpooler;
Procedure TaskSpooler;
Procedure PushStrSpooler(S:String);
Procedure DoneSpooler;
Procedure Int17h(Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP:Word);

IMPLEMENTATION

Uses Mems,Systems,Printers,Keyboard;

Var HSpool:Word; PSpool,FSSpool:Long;
    BufSpool:^TChar; OldTask:Procedure;
    OldInt17h:Pointer;
    OldExitProc:Pointer;

Procedure InitSpooler;
Begin
 PSpool := 0; FSSpool := -1; BufSpool := MemAlloc(1024);
 If(BufSpool = NIL)Then Exit;
 Systems.Del(SpoolName);
 HSpool := Systems.New(SpoolName);
 If(Systems.IsHandle(HSpool))Then FSSpool := 0;
End;

Function BfSpool(P:Long):Char;
Begin
 If((PSpool mod 1024) = 0)Then Systems.GetRec(HSpool,PSpool div 1024,1024,BufSpool^);
 BfSpool := BufSpool^[PSpool mod 1024];
End;

Procedure TaskSpooler;
Var PortPrn:Word;
Begin
 OldTask;
 If(FSSpool > 0)Then
 Begin
  If(FSSpool > PSpool)Then
  Begin
   ASM
    MOV AL,PrnOutput;
    AND AL,3;
    SHL AL,1;
    ADD AL,8;
    MOV AH,$04;
    MOV DI,AX;
    XOR AX,AX;
    MOV ES,AX;
    MOV AX,ES:[DI];
    MOV PortPrn,AX;
   END;
   If Not(Port[PortPrn+1] and 128 = 0)Then
   Begin
    Port[PortPrn]:=Byte(BfSpool(PSpool));
    ASM
     MOV DX,PortPrn;
     INC DX;
     INC DX;
     IN  AL,DX;
     OR  AL,1;
     OUT DX,AL;
     IN  AL,DX;
     AND AL,NOT 1;
     OUT DX,AL;
    END;
    Inc(PSpool);
    If(PSpool >= FSSpool)Then Begin FSSpool := 0; PSpool := 0; End;
   End;
  End;
 End;
End;

Procedure PushStrSpooler(S:String);
Begin
 If(IsHandle(HSpool))Then
 Begin
  Systems.SetFilePos(HSpool,FSSpool);
  Systems._SetRec(HSpool,Byte(S[0]),S[1]);
  Inc(FSSpool,Length(S));
 End
  Else
 Printers.Print(S,PrnOutput);
End;

Procedure DoneSpooler;
Begin
 If(BufSpool <> NIL)Then
 Begin
  If(Systems.IsHandle(HSpool))Then
  Begin
   Systems.Close(HSpool);
   Systems.Del(SpoolName);
  End;
  FreeMem(BufSpool,1024);
  BufSpool := NIL;
 End;
End;

Procedure Int17h(Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP:Word);
Begin
 If(DX = PrnOutput)Then Case Hi(AX) of
  0:
  Begin
   PushStrSpooler(Char(AX));
   AX := $9000;
  End;
  1,2:
  AX := Port[Mem[$0040:8+((DX and 3) shl 1)]] shl 8;
 End
  Else
 ASM
  PUSHF;
  CALL OldInt17h;
 END;
End;

Procedure Done; Far;
Begin
 SetIntVec($17,OldInt17h);
 ExitProc := OldExitProc;
End;

BEGIN
 OldTask := _BackKbd; _BackKbd := TaskSpooler;
 BufSpool := NIL; HSpool := $FFFF; FSSpool := -1; PSpool := 0;
 GetIntVec($17,OldInt17h);
 SetIntVec($17,@Int17h);
 OldExitProc := ExitProc;
END.