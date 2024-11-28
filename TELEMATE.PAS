{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³             Malte Genesis/Module de T‚l‚matique            ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit TeleMate;

INTERFACE

{$D-,L-,Y-,I-,Q-,R-,S-,X+}

Uses Dos,Terminal,MLibrary,Video,Mems,Math;

Const

 teUnknown=0;
 teADM3a=1;
 teADM5=2;
 teANSI=3;
 teDumb=4;
 teGossipMode=5;
 teHostMode=6;
 teTektronix401=7;
 teTV925=8;
 teVT52=9;
 teVT100=10;

 UartTHR=$00;
 UartRBR=$00;
 UartIER=$01;
 UartIIR=$02;
 UartLCR=$03;
 UartMCR=$04;
 UartLSR=$05;
 UartMSR=$06;
 I8088IMR=$21;

 Com1Base=$03F8; Com2Base=$02F8; Com3Base=$03E8; Com4Base=$02E8;
 Com5Base=$4220; Com6Base=$4228; Com7Base=$5220; Com8Base=$5228;

 Com1Irq=4; Com2Irq=3; Com3Irq=4; Com4Irq=3;
 Com5Irq=4; Com6Irq=3; Com7Irq=4; Com8Irq=3;

 Com1Int=$0C; Com2Int=$0B; Com3Int=$0C; Com4Int=$0B;
 Com5Int=$0C; Com6Int=$0B; Com7Int=$0C; Com8Int=$0B;

 MaxComPorts=8; TimeOut=256;

 AsyncXon=^Q; AsyncXoff=^S;
 AsyncOverrunError=2; AsyncParityError=4;
 AsyncFramingError=8; AsyncBreakFound=16;

 AsyncCTS=$10; AsyncRTS=$20; AsyncDSR=$20; AsyncDTR=$10; AsyncRTSDTR=$30;

 DefaultComBase:Array[1..MaxComPorts] of Word = (
  Com1Base,Com2Base,Com3Base,Com4Base,Com5Base,Com6Base,Com7Base,Com8Base);

 DefaultComIrq:Array[1..MaxComPorts] of Byte = (
  Com1Irq,Com2Irq,Com3Irq,Com4Irq,Com5Irq,Com6Irq,Com7Irq,Com8Irq);

 DefaultComInt:Array[1..MaxComPorts] of Byte = (
  Com1Int,Com2Int,Com3Int,Com4Int,Com5Int,Com6Int,Com7Int,Com8Int);

 ModemCommandDelay:Word = 10;
 ModemInit:PChar = 'AT S0=0 Q0 E1 X4|~~~AT&C1|~';
 ModemDial:PChar = 'ATDT';
 ModemDialEnd:PChar = '|';
 ModemAnswer:PChar = 'ATA|';
 ModemHostSet:PChar = 'ATZ|~ATX1|~ATS0=1|';
 ModemHostUnSet:PChar = 'ATZ|~ATX1|~ATS0=0|';
 ModemBusy:PChar = NIL;
 ModemConnect:PChar = NIL;
 ModemNoCarrier:PChar = NIL;
 PrefixStr:PChar = '';
 PostfixStr:PChar = '';

 FKCR:Char='|';
 FKDelay:Char='~';
 FKCtrlMark:Char='^';
 FKScriptCh:Char='@';
 FKDelayTime:Int=10;

 DataBits:5..8 = 8;
 Parity:Char = 'N';
 StopBits:0..2 = 1;
 CommPort:1..4 = 1;
 BaudRate:110..38400 = 2400;
 CmdLinePort:0..4 = 0;

 ModemEscape:PChar = '+++';
 ModemEscapeTime:Int = 1500;
 ModemHangUp:PChar = 'ATH0|';

Type

 AsyncBufType=Array[0..1] of Char;
 AsyncPtr=^AsyncBufType;

 DialRecord=Record
  Name:Array[0..29] of Char;
  PassWord:Array[0..15] of Char;
  Script:Array[0..8] of Char;
  Log:Array[0..8] of Char;
  Phone:Array[0..20] of Char;
  Para:Array[0..8] of Char;
  Port:Char;
  f5:Char;
  Total:Array[0..5] of Char;
  Last:Array[0..9] of Char;
  Term:Char;
  Connect2:Char;
  LineFeed:Char;
  CarriageReturn:Char;
  LocalEcho:Char;
  Wrap:Char;
  DestBS:Char;
  AutoLog:Char;
  LongDistance:Char;
  StripHigh:Char;
  TagSeparator:Char;
  GuessInitial:Char;
  Reserved:Array[0..1] of Char;
  Prefix,Suffix:Char;
  Protocol:Char;
  CRLF:Array[0..1] of Char;
 End;

Var

 ComBase:Array[1..MaxComPorts] of Word;
 ComIrq:Array[1..MaxComPorts] of Byte;
 ComInt:Array[1..MaxComPorts] of Byte;

 AsyncBufPtr,AsyncOBufPtr:AsyncPtr;

 AsyncOpenFlag:Bool;
 AsyncPort,AsyncBase,AsyncRS232:Int; AsyncIrq,AsyncInt:Byte;

 AsyncBufOverflow:Bool;
 AsyncBufUsed,AsyncMaxBufUsed,AsyncBufHead,AsyncBufTail,AsyncBufNewTail:Int;
 AsyncOBufOverflow:Bool;
 AsyncOBufUsed,AsyncMaxOBufUsed,AsyncOBufHead,AsyncOBufTail,
 AsyncOBufNewTail,AsyncBufLow,AsyncBufHigh,AsyncBufHigh2:Int;
 AsyncXOFFSent,AsyncSenderOn,AsyncSendXOFF_,AsyncXOFFReceived,
 AsyncXOFFRecDisplay,AsyncXONRecDisplay:Bool;
 AsyncBaudRate:Word;
 AsyncSaveIAddr:Pointer;
 AsyncDoCTS,AsyncDoDSR,AsyncDoXonXoff,AsyncOVXonXoff,AsyncHardWiredOn:Bool;
 AsyncBreakLength:Int;
 AsyncLineStatus,AsyncModemStatus,AsyncLineErrorFlags:Byte;
 AsyncBufSize,AsyncOBufSize,AsyncUartIER,AsyncUartMCR,
 AsyncUartIIR,AsyncUartMSR,AsyncUartLSR,AsyncOutputDelay,
 AsyncOneMSDelay,AsyncBufLength,AsyncOBufLength:Int;
 AsyncSendAddr:AsyncPtr;

Procedure AsyncClose(DropDTR:Bool);
Procedure AsyncClearErrors;
Procedure AsyncDrainOutputBuf(MaxWaitTime:Int);
Procedure AsyncFlushOutputBuf;
Procedure AsyncInit(AsyncBufMax,AsyncOBufMax,AsyncHighLev1,AsyncHighLev2,AsyncLowLev:Int);
Procedure AsyncPurgeBuf;
Procedure AsyncReceiveWithTimeout(Secs:Int;Var C:Int);
Procedure AsyncReleaseBufs;
Procedure AsyncResetPort(ComPort:Int;BaudRate:Word;Parity:Char;WordSize,StopBits:Int);
Procedure AsyncSend(C:Char);
Procedure AsyncSendACK;
Procedure AsyncSendBreak;
Procedure AsyncSendBS;
Procedure AsyncSendCAN;
Procedure AsyncSendCR;
Procedure AsyncSendDLE;
Procedure AsyncSendEOT;
Procedure AsyncSendFFh;
Procedure AsyncSendNAK;
Procedure AsyncSendNow(C:Char);
Procedure AsyncSendNowXOFF;
Procedure AsyncSendNowXON;
Procedure AsyncSendNUL;
Procedure AsyncSendSOH;
Procedure AsyncSendStr(S:String);
Procedure AsyncSendStr2Com(S:String;Num:Byte);
Procedure AsyncSendStrWithDelays(S:String;CharDelay,EOSDelay:Int);
Procedure AsyncSendSUB;
Procedure AsyncSendSYN;
Procedure AsyncSendXOFF;
Procedure AsyncSendXON;
Procedure AsyncSetupPort(ComPort,BaseAddress,IRQLine,IntNumb:Int);
Procedure AsyncStuff(Ch:Char);
Procedure AsyncTermReady(ReadyStatus:Bool);
Procedure BackService(S:String);
Procedure BiosRS232Init(ComPort:Int;ComParm:Word);
Procedure ClearXoffReceived;
Procedure SendModemCmd(ModemText:String);

Function AsyncBufCheck:Bool;
Function AsyncCarrierDetect:Bool;
Function AsyncCarrierDrop:Bool;
Function AsyncLineError(Var ErrorFlags:Byte):Bool;
Function AsyncOpen(ComPort:Int;BaudRate:Word;Parity:Char;WordSize,StopBits:Integer):Bool;
Function AsyncPeek(Nchars:Int):Char;
Function AsyncPercentageUsed:Real;
Function AsyncPortAddressGiven(ComPort:Int):Bool;
Function AsyncReceive(Var C:Char):Bool;
Function AsyncRingDetect:Bool;
Function AsyncWaitForQuiet(MaxWait,WaitTime:Long):Bool;
Function ComExist(Num:Byte):Bool;
Function ComPortAddr(Num:Byte):Word;

IMPLEMENTATION

Uses Clock,Strs,Strings,Language,Printers,Keyboard,Systems,Mouse;

Function AsyncBufCheck;
Begin
 AsyncBufCheck := (AsyncBufHead <> AsyncBufTail);
End;

Function AsyncCarrierDetect;
Assembler;
ASM
 MOV DX,AsyncBase;
 ADD DX,UartMsr;
 IN  AL,DX;
 ROL AL,1;
 AND AL,1;
 OR  AL,AsyncHardWiredOn;
END;

Function AsyncCarrierDrop;
Begin
 AsyncCarrierDrop := Not(AsyncCarrierDetect);
End;

Procedure AsyncClearErrors;
Assembler;
ASM
 CLI;
 MOV BX,AsyncBase;
 MOV DX,BX;
 ADD DX,UartLCR;
 IN  AL,DX;
 AND AL,$7F;
 OUT DX,AL;
 MOV DX,BX;
 ADD DX,UartLSR;
 IN  AL,DX;
 MOV DX,BX;
 ADD DX,UartRBR;
 IN  AL,DX;
 MOV DX,I8088IMR;
 MOV CH,1;
 MOV CL,AsyncIrq;
 SHL CH,CL;
 XOR CH,$FF;
 IN  AL,DX;
 AND AL,CH;
 OUT DX,AL;
 MOV DX,BX;
 ADD DX,UartMCR;
 IN  AL,DX;
 OR  AL,$0B;
 OUT DX,AL;
 MOV DX,BX;
 ADD DX,UartIER;
 MOV AL,$0F;
 OUT DX,AL;
 MOV AL,$20;
 OUT $20,AL;
 STI;
END;

Procedure AsyncClose;
Begin
 If(AsyncOpenFlag)Then
 Begin
  ASM
   CLI;
   MOV DX,I8088IMR;
   MOV BL,1;
   MOV CL,AsyncIrq;
   SHL BL,CL;
   IN  AL,DX;
   OR  AL,BL;
   OUT DX,AL;
   MOV DX,AsyncBase;
   MOV BX,DX;
   ADD DX,UartIER;
   MOV AL,0;
   OUT DX,AL;
   MOV AL,DropDtr;
   NOT AL;
   AND AL,1;
   MOV DX,BX;
   ADD DX,UartMCR;
   OUT DX,AL;
   STI;
  END;
  AsyncOpenFlag := False; AsyncXOFFSent := False; AsyncSenderOn := False;
  SetIntVec(AsyncInt,AsyncSaveIaddr);
 End;
End;

Procedure AsyncDrainOutputBuf;
Var T1:Long;
Begin
 T1 := TimeOfDay;
 While((AsyncOBufHead <> AsyncOBufTail)and(TimeDiff(T1,TimeOfDay) <= MaxWaitTime))do;
END;

Procedure AsyncFlushOutputBuf;
Begin
 AsyncOBufHead := AsyncOBufTail; AsyncOBufUsed := 0;
End;

Procedure AsyncInit;
Var I:Int;
Begin
 AsyncOpenFlag := False; AsyncXOFFSent := False;
 AsyncXOFFReceived := False; AsyncXOFFRecDisplay := False;
 AsyncXONRecDisplay := False; AsyncSendXOFF_ := False;
 AsyncSenderOn := False; AsyncBufOverflow  := False;
 AsyncBufUsed := 0; AsyncMaxBufUsed := 0;
 AsyncBufHead := 0; AsyncBufTail := 0;
 AsyncOBufOverflow := False; AsyncOBufUsed := 0;
 AsyncMaxOBufUsed := 0; AsyncOBufHead := 0;
 AsyncOBufTail := 0; AsyncOutputDelay := 500;
 AsyncLineStatus := 0; AsyncModemStatus := 0;
 AsyncLineErrorFlags := 0;
 If(AsyncBufMax > 0)Then AsyncBufSize := AsyncBufMax - 1
		    Else AsyncBufSize := 4095;
 If(AsyncOBufMax > 0)Then AsyncOBufSize := AsyncOBufMax - 1
		     Else AsyncOBufSize := 1131;
 If(AsyncLowLev > 0)Then AsyncBufLow := AsyncLowLev
		    Else AsyncBufLow := AsyncBufSize div 4;
 If(AsyncHighLev1 > 0)Then AsyncBufHigh := AsyncHighLev1
		      Else AsyncBufHigh := (AsyncBufSize div 4) * 3;
 If(AsyncHighLev2 > 0)Then AsyncBufHigh2 := AsyncHighLev2
		      Else AsyncBufHigh2 := (AsyncBufSize div 10) * 9;
 AsyncBufPtr := MemAlloc(AsyncBufSize+1);
 AsyncOBufPtr := MemAlloc(AsyncOBufSize+1);
 AsyncUartIER := 0; AsyncUartIIR := 0;
 AsyncUartMSR := 0; AsyncUartLSR := 0;
 AsyncUartMCR := 0;
 For I := 1 to MaxComPorts do
 Begin
  ComBase[I] := DefaultComBase[I];
  ComIrq[I] := DefaultComIrq[I];
  ComInt[I] := DefaultComInt[I];
 End;
 _Delay(AsyncOneMSDelay);
End;

Procedure AsyncIsr(Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP:Word);
Interrupt;
Assembler;
ASM
 STI;
@@Poll:
 MOV DX,AsyncUartIIR;
 IN  AL,DX;
 TEST AL,1;
 JZ  @@Polla;
 JMP @@Back;
@@Polla:
 AND AL,6;
 CMP AL,4;
 JE  @@Pollb;
 JMP @@Int2;
@@Pollb:
 PUSH AX;
  CALL @@EnabWI;
 POP AX;
@@Int4:
 CMP AL,4;
 JE  @@Int4a;
 JMP @@Int2;
@@Int4a:
 MOV DX,AsyncBase;
 IN  AL,DX;
 TEST AsyncDoXonXoff,1;
 JZ  @@Int4d;
 CMP AL,XON;
 JE  @@Int4b;
 CMP AL,XOFF;
 JNE @@Int4d;
 MOV AsyncXOFFReceived,1;
 MOV AsyncXOFFRecDisplay,1;
 JMP @@Poll;
@@Int4b:
 MOV AsyncXOFFReceived,0;
 MOV AsyncXONRecDisplay,1;
 CALL @@EnabWI;
 JMP @@Int4z;
@@Int4d:
 TEST AsyncLineStatus,2;
 JZ  @@Int4e;
 JMP @@Int4z;
@@Int4e:
 MOV BX,AsyncBufHead;
 LES DI,AsyncBufPtr;
 ADD DI,BX;
 MOV ES:[DI],AL;
 INC AsyncBufUsed;
 MOV AX,AsyncBufUsed;
 CMP AX,AsyncMaxBufUsed;
 JLE @@Int4f;
 MOV AsyncMaxBufUsed,AX;
@@Int4f:
 INC BX;
 CMP BX,AsyncBufSize;
 JLE @@Int4h;
 XOR BX,BX;
@@Int4h:
 CMP AsyncBufTail,BX;
 JE  @@Int4s;
 MOV AsyncBufHead,BX;
 CMP AX,AsyncBufHigh;
 JL  @@Int4z;
 MOV DL,AsyncSenderOn;
 TEST AsyncOVXonXoff,1;
 JZ  @@Int4k;
 TEST AsyncXOFFSent,1;
 JZ  @@Int4j;
 CMP AX,AsyncBufHigh2;
 JNE @@Int4k;
@@Int4j:
 MOV AsyncSendXOFF_,1;
 CALL @@EnabWI;
 MOV AsyncSenderOn,0;
@@Int4k:
 TEST DL,1;
 JZ  @@Int4z;
 XOR AH,AH;
 TEST AsyncDoCTS,1;
 JZ  @@Int4l;
 MOV AH,AsyncRTS;
@@Int4l:
 TEST AsyncDoDSR,1;
 JZ  @@Int4m;
 OR  AH,AsyncDTR;
@@Int4m:
 CMP AH,0;
 JZ  @@Int4z;
 MOV DX,AsyncUartMCR;
 IN  AL,DX;
 NOT AH;
 AND AL,AH;
 OUT DX,AL;
 MOV AsyncSenderOn,0;
 JMP @@Int4z;
@@Int4s:
 OR  AsyncLineStatus,2;
@@Int4z:
 JMP @@Poll
@@Int2:
 CMP AL,2;
 JE  @@Int2a;
 JMP @@Int6;
@@Int2a:
 TEST AsyncSendXoff_,1;
 JZ  @@Int2d;
 TEST AsyncDoDSR,1;
 JZ  @@Int2b;
 MOV DX,AsyncUartMSR;
 IN  AL,DX;
 TEST AL,AsyncDSR;
 JZ  @@Int2e;
@@Int2b:
 TEST AsyncDoCTS,1;
 JZ  @@Int2c;
 MOV DX,AsyncUartMSR;
 IN  AL,DX;
 TEST AL,AsyncCTS;
 JZ  @@Int2e;
@@Int2c:
 MOV AL,XOFF;
 MOV DX,AsyncBase;
 OUT DX,AL;
 MOV AsyncSendXOFF_,0;
 MOV AsyncXOFFSent,1;
 JMP @@Poll;
@@Int2d:
 MOV BX,AsyncOBufTail;
 CMP BX,AsyncOBufHead;
 JNE @@Int2m;
@@Int2e:
 MOV DX,AsyncUartIER;
 IN  AL,DX;
 AND AL,$FD;
 OUT DX,AL;
 JMP @@Poll;
@@Int2m:
 TEST AsyncXOFFReceived,1;
 JNZ  @@Int2e;
 MOV DX,AsyncUartMSR;
 IN  AL,DX;
 MOV AsyncModemStatus,AL;
 TEST AsyncDoDSR,1;
 JZ  @@Int2n;
 TEST AL,AsyncDSR;
 JZ  @@Int2e;
@@Int2n:
 TEST AsyncDoCTS,1;
 JZ  @@Int2o;
 TEST AL,AsyncCTS;
 JZ  @@Int2e;
@@Int2o:
 LES DI,AsyncOBufPtr;
 ADD DI,BX;
 MOV AL,ES:[DI];
 MOV DX,AsyncBase;
 OUT DX,AL;
 DEC AsyncOBufUsed;
 INC BX;
 CMP BX,AsyncOBufSize;
 JLE @@Int2z;
 XOR BX,BX;
@@Int2z:
 MOV AsyncOBufTail,BX;
 JMP @@Poll;
@@Int6:
 CMP AL,6;
 JNE @@Int0;
 MOV DX,AsyncUartLSR;
 IN  AL,DX;
 AND AL,$1E;
 MOV AsyncLineStatus,AL;
 OR  AsyncLineErrorFlags,AL;
 JMP @@Poll;
@@Int0:
 CMP AL,0;
 JE  @@Int0a;
 JMP @@Poll;
@@Int0a:
 MOV DX,AsyncUartMSR;
 IN  AL,DX;
 MOV AsyncModemStatus,AL;
 CALL @@EnabWI;
 JMP @@Poll;
@@EnabWI:
 MOV DX,AsyncUartIER;
 IN  AL,DX;
 TEST AL,2;
 JNZ @@EnabRet;
 OR  AL,2;
 OUT DX,AL;
@@EnabRet:
 RET;
@@Back:
 MOV AL,$20;
 OUT $20,AL;
END;

Function AsyncLineError;
Begin
 AsyncLineError := (AsyncLineErrorFlags <> 0);
 ErrorFlags := AsyncLineErrorFlags; AsyncLineErrorFlags := 0;
END;

Function AsyncOpen;
Var _AL:Byte;
Begin
 If(AsyncOpenFlag)Then AsyncClose(False);
 If(ComPort < 1)Then ComPort := 1 else
 If(ComPort > MaxComPorts)Then ComPort := MaxComPorts;
 AsyncPort := ComPort;
 AsyncBase := ComBase[ComPort];
 AsyncIrq := ComIrq[ComPort];
 AsyncInt := ComInt[ComPort];
 ASM
  MOV DX,AsyncBase;
  MOV AX,DX;
  ADD AX,UartIER;
  MOV AsyncUartIER,AX;
  MOV AX,DX;
  ADD AX,UartMCR;
  MOV AsyncUartMCR,AX;
  MOV AX,DX;
  ADD AX,UartMSR;
  MOV AsyncUartMSR,AX;
  MOV AX,DX;
  ADD AX,UartLSR;
  MOV AsyncUartLSR,AX;
  ADD DX,UartIIR;
  MOV AsyncUartIIR,DX;
  IN  AL,DX;
  AND AL,$F8;
  MOV _AL,AL;
@@1:
 END;
 If(_AL <> 0)Then AsyncOpen := False
  Else
 Begin
  GetIntVec(AsyncInt,AsyncSaveIaddr);
  SetIntVec(AsyncInt,@AsyncIsr);
  AsyncResetPort(ComPort,BaudRate,Parity,WordSize,StopBits);
  AsyncOpen := True;
  AsyncOpenFlag := True;
 End;
End;

Function AsyncPeek;
Var I:Int;
Begin
 I := (AsyncBufTail + NChars) mod AsyncBufSize;
 If(I > AsyncBufHead)Then AsyncPeek := #0 Else AsyncPeek := AsyncBufPtr^[I];
End;

Function AsyncPercentageUsed;
Begin
 AsyncPercentageUsed := AsyncBufUsed / (AsyncBufSize + 1);
End;

Function AsyncPortAddressGiven;
Var I:Word;
Begin
 If((ComPort > 0)and(ComPort < MaxComPorts))Then
 Begin
  ASM
   MOV BX,ComPort;
   SHL BX,1;
   MOV AX,$0040;
   MOV ES,AX;
   MOV AX,ES:[BX];
   MOV I,AX;
  END;
  AsyncPortAddressGiven := (I <> 0);
 End
  Else
 AsyncPortAddressGiven := False;
End;

Procedure AsyncPurgeBuf;
Var C:Char; L:Int;
Begin
 L := 10000 div AsyncBaudRate;
 If(L <= 0)Then L := 3;
 Repeat
  _Delay(L)
 Until Not(AsyncReceive(C));
End;

Function AsyncReceive;
Assembler;
ASM
 MOV AX,AsyncBufTail;
 CMP AX,AsyncBufHead;
 JNE @@Rec1;
 LES DI,C;
 XOR AX,AX;
 MOV ES:[DI],AL;
 JMP @@Return;
@@Rec1:
 LES DI,AsyncBufPtr;
 ADD DI,AX;
 MOV BL,ES:[DI];
 LES DI,C;
 MOV ES:[DI],BL;
 INC AX;
 CMP AX,AsyncBufSize;
 JLE @@Rec2;
 XOR AX,AX;
@@Rec2:
 MOV AsyncBufTail,AX;
 MOV AX,AsyncBufUsed;
 DEC AX;
 MOV AsyncBufUsed,AX;
 TEST AsyncSenderOn,1;
 JNZ @@Rec6;
 CMP AX,AsyncBufLow;
 JG  @@Rec6;
 TEST AsyncXOffSent,1;
 JZ  @@Rec3;
 MOV AX,XON;
 PUSH AX;
 CALL AsyncSendAddr;
 MOV AsyncXOffSent,0;
@@Rec3:
 TEST AsyncDoCts,1;
 JZ  @@Rec4;
 MOV DX,AsyncUartMCR;
 IN  AL,DX;
 OR  AL,AsyncRTS;
 OUT DX,AL;
@@Rec4:
 TEST AsyncDoDsr,1;
 JZ  @@Rec5;
 MOV DX,AsyncUartMCR;
 IN  AL,DX;
 OR  AL,AsyncDTR;
 OUT DX,AL;
@@Rec5:
 MOV AsyncSenderOn,1;
@@Rec6:
 MOV AX,1;
@@Return:
 AND AsyncLineStatus,$FD;
END;

Procedure AsyncReceiveWithTimeout;
Assembler;
ASM
 MOV AX,AsyncBufTail;
 CMP AX,AsyncBufHead;
 JNE @@Rec1;
 MOV AX,Secs;
 {$IFOPT G+}
  SHL AX,10;
 {$ELSE}
  MOV CX,10;
  SHL AX,CL;
 {$ENDIF}
 MOV CX,AX;
@@Delay:
 PUSH  CX;
  MOV CX,AsyncOneMSDelay;
@@Delay1:
  LOOP @@Delay1;
 POP CX;
 MOV AX,AsyncBufTail;
 CMP AX,AsyncBufHead;
 JNE @@Rec1;
 LOOP @@Delay;
 MOV BX,TimeOut;
 LES DI,C;
 MOV ES:[DI],BX;
 JMP @@Return;
@@Rec1:
 LES DI,AsyncBufPtr;
 ADD DI,AX;
 MOV BL,ES:[DI];
 XOR BH,BH;
 LES DI,C;
 MOV ES:[DI],BX;
 INC AX;
 CMP AX,AsyncBufSize;
 JLE @@Rec2;
 XOR AX,AX;
@@Rec2:
 MOV AsyncBufTail,AX;
 MOV AX,AsyncBufUsed;
 DEC AX;
 MOV AsyncBufUsed,AX;
 TEST AsyncSenderOn,1;
 JNZ @@Return;
 CMP AX,AsyncBufLow;
 JG  @@Return;
 TEST AsyncXOffSent,1;
 JZ  @@Rec3;
 MOV AX,XON;
 PUSH AX;
 CALL AsyncSendAddr;
 MOV AsyncXOffSent,0;
@@Rec3:
 TEST AsyncDoCts,1;
 JZ  @@Rec4;
 MOV DX,AsyncUartMCR;
 IN  AL,DX;
 OR  AL,AsyncRTS;
 OUT DX,AL;
@@Rec4:
 TEST AsyncDoDsr,1;
 JZ  @@Rec5;
 MOV DX,AsyncUartMCR;
 IN  AL,DX;
 OR  AL,AsyncDTR;
 OUT DX,AL;
@@Rec5:
 MOV AsyncSenderOn,1;
@@Return:
 AND AsyncLineStatus,$FD;
END;

Procedure AsyncReleaseBufs;
Begin
 If(AsyncOpenFlag)Then AsyncClose(False);
 FreeMem(AsyncBufPtr,AsyncBufSize+1);
 FreeMem(AsyncOBufPtr,AsyncOBufSize+1);
END;

Procedure AsyncResetPort;
Const AsyncNumBauds = 11;
      AsyncBaudTable:Array[1..AsyncNumBauds] of Record
       Baud:Word;Bits:Byte;
      End = (
       (Baud:  110; Bits:$00),
       (Baud:  150; Bits:$20),
       (Baud:  300; Bits:$40),
       (Baud:  600; Bits:$60),
       (Baud:  1200;Bits:$80),
       (Baud:  2400;Bits:$A0),
       (Baud:  4800;Bits:$C0),
       (Baud:  9600;Bits:$E0),
       (Baud: 19200;Bits:$E0),
       (Baud: 38400;Bits:$E0),
       (Baud: 57600;Bits:$E0));
Var I,M,ComParm:Int;
Begin
 If(BaudRate > AsyncBaudTable[AsyncNumBauds].Baud)Then
  BaudRate := AsyncBaudTable[AsyncNumBauds].Baud else
 If(BaudRate < AsyncBaudTable[1].Baud)Then
  BaudRate := AsyncBaudTable[1].Baud;
 AsyncBaudRate := BaudRate; I := 0;
 Repeat
  Inc(I);
 Until ((I >= AsyncNumBauds)or(BaudRate = AsyncBaudTable[I].Baud));
 ComParm := AsyncBaudTable[I].Bits;
 Parity  := UpCase(Parity);
 Case Parity Of
  'E' : ComParm := ComParm OR $0018;
  'O' : ComParm := ComParm OR $0008;
 End;
 Dec(WordSize,5);
 If(WordSize < 0)or(WordSize > 3)Then WordSize := 3;
 ComParm := ComParm or WordSize;
 If(StopBits = 2)Then ComParm := ComParm or $0004;
 BiosRS232Init(ComPort - 1,ComParm);
 If(BaudRate >= 19200)Then
 Begin
  ASM
   MOV DX,AsyncBase;
   ADD DX,UartLCR;
   IN  AL,DX;
   OR  AL,$80;
   OUT DX,AL;
  END;
  Port[UartTHR + AsyncBase] := 115200 div BaudRate;
  ASM
   MOV DX,AsyncBase;
   MOV BX,DX;
   ADD DX,UartIER;
   MOV AL,0;
   OUT DX,AL;
   MOV DX,BX;
   ADD DX,UartLCR;
   IN  AL,DX;
   AND AL,$7F;
   OUT DX,AL;
  END;
 End;
 If(Parity in ['S','M'])Then
 ASM
  MOV DX,AsyncBase;
  ADD DX,UartLCR;
  IN  AL,DX;
  MOV AL,$80;
  OUT DX,AL;
  MOV BX,StopBits;
  DEC BX;
  {$IFOPT G+}
   SHL BX,2;
  {$ELSE}
   SHL BX,1;
   SHL BX,1;
  {$ENDIF}
  MOV AX,WordSize;
  OR  AX,BX;
  CMP Parity,Byte('M');
  JNE @@1;
  OR  AX,$0028;
  JMP @@2;
@@1:
  OR  AX,$0038;
@@2:
  OUT DX,AX;
 END;
 AsyncSenderOn := True;
 AsyncClearErrors;
End;

Function AsyncRingDetect:Bool;
Assembler;
ASM
 MOV DX,AsyncBase;
 ADD DX,UartMSR;
 IN  AL,DX;
 {$IFOPT G+}
  SHR AL,6;
 {$ELSE}
  MOV CL,6;
  SHR AL,CL;
 {$ENDIF}
 AND AL,1;
END;

Procedure AsyncSend(C:Char);
Assembler;
ASM
 MOV BX,AsyncOBufHead;
 LES DI,AsyncOBufPtr;
 ADD DI,BX;
 MOV DX,BX;
 INC BX;
 CMP BX,AsyncOBufSize;
 JLE @@Send1;
 XOR BX,BX;
@@Send1:
 CMP BX,AsyncOBufTail;
 JNE @@Send4;
 MOV CX,AsyncOutputDelay;
@@Send2:
 PUSH CX;
  MOV CX,AsyncOneMSDelay;
@@Send3:
  LOOP @@Send3;
 POP CX;
 CMP BX,AsyncOBufTail;
 JNE @@Send4;
 LOOP @@Send2;
 MOV AsyncOBufOverflow,1;
 JMP @@Send5;
@@Send4:
 MOV AsyncOBufHead,BX;
 MOV AL,C;
 MOV ES:[DI],AL;
 MOV AX,AsyncOBufUsed;
 INC AX;
 MOV AsyncOBufUsed,AX;
 CMP AX,AsyncMaxOBufUsed;
 JLE @@Send5;
 MOV AsyncMaxOBufUsed,AX;
@@Send5:
 MOV DX,AsyncUartIER;
 IN  AL,DX;
 TEST AL,2;
 JNZ @@Send6;
 OR  AL,2;
 OUT DX,AL;
@@Send6:
END;

Procedure AsyncSendNow(C:Char);
Var TimeOut:Word;
Begin
 Port[UartMCR + AsyncBase] := $0B;
 If(AsyncDoDSR)Then
 Begin
  TimeOut := 65535;
  While((Port[UartMSR + AsyncBase] and $20) = 0)and(TimeOut > 0) do Dec(TimeOut);
 End;
 If(AsyncDoCTS)Then
 Begin
  TimeOut := 65535;
  While ((Port[UartMSR + AsyncBase] and $10) = 0)and(TimeOut > 0) do Dec(TimeOut);
 End;
 If(TimeOut > 0)Then TimeOut := 65535;
 While ((Port[UartLSR + AsyncBase] and $20) = 0)and(TimeOut > 0) do Dec(TimeOut);
 CLI;
 Port[UartTHR + AsyncBase] := Byte(C);
 STI;
End;

Procedure AsyncSendBreak;
Var OldLcr:Byte;
Begin
 ASM
  MOV DX,AsyncBase;
  ADD DX,UartLCR;
  IN  AL,DX;
  MOV OldLcr,AL;
  AND AL,$7F;
  OR  AL,$40;
  OUT DX,AL;
 END;
 Delay(AsyncBreakLength * 10);
 ASM
  MOV DX,AsyncBase;
  ADD DX,UartLCR;
  MOV AL,OldLcr;
  OUT DX,AL;
 END;
End;

Procedure AsyncSendStr(S:String);
Var I:Byte;
Begin
 For I := 1 to Length(S) do AsyncSend(S[I]);
End;

Procedure AsyncSendStr2Com(S:String;Num:Byte);
Var OldPort:Word;
Begin
 If(Num >= MaxComPorts)Then Exit;
 OldPort   := AsyncBase;
 AsyncBase := DefaultComBase[Num-1];
 AsyncSendStr(S);
 AsyncBase := OldPort;
End;

Procedure AsyncSendStrWithDelays(S:String;CharDelay,EOSDelay:Int);
Var I:Byte;
Begin
 If(CharDelay <= 0)Then AsyncSendStr(S)
  Else
 Begin
  For I := 1 to Length(S) do
  Begin
   AsyncSend(S[I]);
   Delay(CharDelay);
  End;
 End;
 If(EOSDelay > 0)Then Delay(EOSDelay);
END;

Procedure AsyncSendCR;
Begin
 AsyncSend(Char(CR));
End;

Procedure AsyncSendNowXON;
Begin
 AsyncSendNow(Char(XON));
End;

Procedure AsyncSendNowXOFF;
Begin
 AsyncSendNow(Char(XOFF));
End;

Procedure AsyncSendXON;
Begin
 AsyncSend(Char(XON));
End;

Procedure AsyncSendCAN;
Begin
 AsyncSend(Char(CAN));
End;

Procedure AsyncSendBS;
Begin
 AsyncSend(Char(BS));
End;

Procedure AsyncSendDLE;
Begin
 AsyncSend(Char(DLE));
End;

Procedure AsyncSendSYN;
Begin
 AsyncSend(Char(SYN));
End;

Procedure AsyncSendEOT;
Begin
 AsyncSend(Char(EOT));
End;

Procedure AsyncSendACK;
Begin
 AsyncSend(Char(ACK));
End;

Procedure AsyncSendSUB;
Begin
 AsyncSend(Char(SUB));
End;

Procedure AsyncSendSOH;
Begin
 AsyncSend(Char(SOH));
End;

Procedure AsyncSendNUL;
Begin
 AsyncSend(Char(NUL));
End;

Procedure AsyncSendFFh;
Begin
 AsyncSend(Char($FF));
End;

Procedure AsyncSendXOFF;
Begin
 AsyncSend(Char(XOFF));
End;

Procedure AsyncSendNAK;
Begin
 AsyncSend(Char(NAK));
End;

Procedure AsyncSetupPort(ComPort,BaseAddress,IRQLine,IntNumb:Int);
Begin
 If((ComPort > 0)and(ComPort <= MaxComPorts))Then
 Begin
  If(BaseAddress = -1)Then BaseAddress := DefaultComBase[ComPort];
  If(IRQLine = -1)Then IRQLine := DefaultComIRQ[ComPort];
  If(IntNumb = -1)Then IntNumb := DefaultComInt[ComPort];
  ComBase[ComPort] := BaseAddress;
  ComIrq[ComPort]  := IRQLine;
  ComInt[ComPort]  := IntNumb;
  ASM
   MOV AX,$0040;
   MOV ES,AX;
   MOV BX,ComPort;
   CMP BX,3;
   JA  @@End;
   DEC BX;
   SHL BX,1;
   MOV AX,ES:[BX];
   MOV BaseAddress,AX;
@@End:
  END;
 End;
End;

Procedure AsyncStuff(Ch:Char);
Var NewHead:Int;
Begin
 AsyncBufPtr^[AsyncBufHead] := Ch;
 NewHead := succ(AsyncBufHead) mod succ(AsyncBufSize);
 If(NewHead = AsyncBufTail)Then AsyncBufOverflow := True
  else
 Begin
  AsyncBufHead := NewHead;
  Inc(AsyncBufUsed);
  If(AsyncBufUsed > AsyncMaxBufUsed)Then AsyncMaxBufUsed := AsyncBufUsed;
 End;
End;

Procedure AsyncTermReady(ReadyStatus:Bool);
Begin
 ASM
  MOV DX,AsyncBase;
  ADD DX,UartMCR;
  IN  AL,DX;
  AND AL,$FE;
  CMP ReadyStatus,Byte(True);
  JNE @@1;
  INC AL;
@@1:
  OUT DX,AL;
 END;
 AsyncClearErrors;
End;

Function AsyncWaitForQuiet(MaxWait,WaitTime:Long):Bool;
Var T1,W1:Long; Head:Int;
Begin
 T1 := TimeOfDayH;
 Repeat
  W1 := WaitTime;
  Repeat
   Delay(10);
   Dec(W1);
  Until ((W1 = 0)or(Head <> AsyncBufHead));
 Until ((TimeDiffH(T1,TimeOfDay) > MaxWait)or(Head = AsyncBufHead));
 AsyncWaitForQuiet := (Head = AsyncBufHead);
End;

Procedure BackService(S:String);
Begin
End;

Procedure BiosRS232Init(ComPort:Int;ComParm:Word);
Assembler;
ASM
 MOV AL,Byte(ComParm);
 MOV AH,0;
 MOV DX,ComPort;
 INT $14;
END;

Procedure ClearXoffReceived;
Var PortVal:Byte;
Begin
 If(AsyncXOffReceived)Then
 Begin
  AsyncXOffReceived := False;
  PortVal := Port[AsyncUartIer];
  If((PortVal and 2) = 0)Then Port[AsyncUartIer] := (PortVal or 2);
 End;
End;

Function ComExist(Num:Byte):Bool;
Begin
 ComExist := Not(MemW[_0040:Num shl 1] = 0);
End;

Function ComPortAddr(Num:Byte):Word;
Assembler;
ASM
 MOV BL,Num;
 AND BL,3;
 MOV BH,0;
 SHL BX,1;
 MOV AX,$0040;
 MOV ES,AX;
 MOV AX,ES:[BX];
END;

Procedure SendModemCmd;
Var I:Byte; Ch,MoChar:Char; Done:Bool; L:Byte Absolute ModemText;
Begin
 I := 1;
 Done := False;
 While(I <= L)and(Not(Done))do
 Begin
  MoChar := ModemText[I];
  If(MoChar = FKCR)Then AsyncSendNow(Char(CR)) else
  IF(MoChar = FKDelay)Then Delay(1000) else
  If(MOChar = FKCtrlMark)Then
  Begin
   If((I + 2) <= L)Then If(ModemText[SUCC(I)] = '''')Then Inc(I,2);
   AsyncSendNow(ModemText[I]);
  End
   Else
  Begin
   AsyncSendNow(ModemText[I]);
   If(ModemCommandDelay > 0)Then Delay(ModemCommandDelay);
  End;
  Inc(I);
 End;
End;

BEGIN
 AsyncDoCTS := False; AsyncDoDSR := False; AsyncHardWiredOn := False;
 AsyncBreakLength := 500; AsyncDoXonXoff := True; AsyncOVXonXoff := True;
 AsyncBufLength := 4096; AsyncOBufLength := 1132;
 DefaultComBase[1] := Com1Base; DefaultComBase[2] := Com2Base;
 DefaultComBase[3] := Com3Base; DefaultComBase[4] := Com4Base;
 DefaultComIrq[1] := Com1Irq; DefaultComIrq[2] := Com2Irq;
 DefaultComIrq[3] := Com3Irq; DefaultComIrq[4] := Com4Irq;
 AsyncSendAddr := @AsyncSend;
END.