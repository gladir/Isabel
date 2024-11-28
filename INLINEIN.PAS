{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³    Malte Genesis/Module de Inline de Code Machine Intel    ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit InlineIntel;

INTERFACE

Const

 { Assembleur -> CPU 8088 }

 __BX_SI = $00;
 __BX_DI = $01;
 __BP_SI = $02;
 __BP_DI = $03;
 __SI = $04;
 __DI = $05;
 __BP = $06;
 __BX = $07;

 __AAA = $37;
 __CBW = $98;
 __CC = $CC;
 __CLC = $F8;
 __CLD = $FC;
 __CLI = $FA;
 __CMPSB = $A6;
 __CMPSW = $A7;
 __CS = $2E;
 __CWD = $99;
 __DS = $3E;
 __ES = $26;
 __INSB = $6C;
 __INSW = $6D;
 __IRET = $CF;
 __LAHF = $9F;
 __MOV_AH_AL = $E08A;
 __MOV_BX_CX = $D98B;
 __MOV_CX_BX = $CB8B;
 __MOVSB = $A4;
 __MOVSW = $A5;
 __NOP = $90;
 __OUTSB = $6E;
 __OUTSW = $6F;
 __POP__AX = $58;
 __POP__BX = $5B;
 __POP__CX = $59;
 __POP__DX = $5A;
 __POP__DI = $5F;
 __POP__DS = $1F;
 __POP__ES = $07;
 __POP__SS = $17;
 __POPF = $9D;
 __PUSH_AX = $50;
 __PUSH_BX = $53;
 __PUSH_CX = $51;
 __PUSH_CS = $0E;
 __PUSH_DX = $52;
 __PUSH_DI = $57;
 __PUSH_DS = $1E;
 __PUSH_ES = $06;
 __PUSH_SS = $16;
 __PUSHF = $9C;
 __REP = $F3;
 __RETF = $CB;
 __RETN = $C3;
 __RET = __RETN;
 __SAHF = $9E;
 __SCASB = $AE;
 __SCASW = $AF;
 __SHR_AX_ = $E8C1;
 __SHR_CX_ = $E9C1;
 __SS = $36;
 __STC = $F9;
 __STD = $FD;
 __STI = $FB;
 __STOSB = $AA;
 __STOSW = $AB;
 __XOR_ = $81;

 { Assembleur -> 80286 }

 __LEAVE = $C9;
 __PUSHA = $60;
 __POPA = $61;
 __XOR_AX_ = $35;

 { Assembleur -> 80386 }

 __FS = $64;
 __GS = $65;
 __MOV_EAX_ES_DI = $058B6626;
 __MOV_ES_DI_EAX = $05896626;
 __MOVSD = $A566;
 __OUTSD = $6F66;
 __PUSH_FS = $A00F;
 __PUSH_GS = $A80F;
 __POP__EAX = $5866;
 __POP__EBX = $5B66;
 __POP__ECX = $5966;
 __POP__EDX = $5A66;
 __POP__EDI = $66 + (__POP__DI shl 8);
 __POP__FS = $A10F;
 __POP__GS = $A90F;
 __PUSH_EAX = $5066;
 __PUSH_EBX = $5366;
 __PUSH_ECX = $5166;
 __PUSH_EDX = $5266;
 __PUSH_EDI = $66 + (__PUSH_DI shl 8);
 __STOSD = $AB66;
 __XCHG_EAX_DS_SI = $048B663E;

IMPLEMENTATION

BEGIN
END.