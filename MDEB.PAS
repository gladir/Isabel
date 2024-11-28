{ Programme de debuguage - Version 1.0 }

Program MDeb;

 { Attention! Surtout maitre les fonctions de d‚bugage hors service... }
{$D-,L-,Y-}
{$M 16384, 32768, 32768}

Uses InlineIntel,Math,Keyboard,CmpilAsm,Strs,Systems,Video,Dials,Windows,ToolVid;

Var OldInt01h:Pointer;
    W:Wins;

Procedure Int01h(Flags,CS,IP,AX,BX,CX,DX,SI,DI,DS,ES,BP:Word);
Interrupt;
Var S:String; CurrCode:Byte;
Begin
 W.PutTxtXY(0,0,'CS:'+HexWord2Str(IP)+' ');
 S := '';
 CurrCode := Mem[CS:IP];
 Case CurrCode of
  __AAA: S := 'AAA';
  __CBW: S := 'CBW';
  __CC: S := 'INT 03h';
  __CLC: S := 'CLC';
  __CLD: S := 'CLD';
  __CLI: S := 'CLI';
  __CMPSB: S := 'CMPSB';
  __CMPSW: S := 'CMPSW';
  __CS:;
  __CWD: S := 'CWD';
  __DS:;
  __ES:;
  __IRET: S := 'IRET';
  __LAHF: S := 'LAHF';
  __MOVSB: S := 'MOVSB';
  __MOVSW: S := 'MOVSW';
  __NOP: S := 'NOP';
  __OUTSB: S := 'OUTSB';
  __POP__AX..__POP__DI: S := 'POP '+RegWord[CurrCode and 7];
  __POP__ES: S := 'POP ES';
  __POPF: S := 'POPF';
  __PUSH_AX..__PUSH_DI: S := 'PUSH '+RegWord[CurrCode and 7];
  Lo(__PUSH_FS):
   Case Mem[CS:IP+1] of
    Hi(__PUSH_FS): S := 'PUSH FS';
   End;
  Lo(__PUSH_GS):
   Case Mem[CS:IP+1] of
    Hi(__PUSH_GS): S := 'PUSH GS';
   End;
  __PUSHF: S := 'PUSHF';
  $6A: S := 'PUSH ' + HexWord2Str(Mem[CS:IP+1]);
  __REP:
  Begin
   S := 'REP ';
   Case Mem[CS:IP+1] of
  __CMPSB: AddStr(S,'CMPSB');
  __CMPSW: AddStr(S,'CMPSW');
   __INSB: AddStr(S,'INSB');
   __INSW: AddStr(S,'INSW');
  __MOVSB: AddStr(S,'MOVSB');
  __MOVSW: AddStr(S,'MOVSW');
  __OUTSB: AddStr(S,'OUTSB');
  __OUTSW: AddStr(S,'OUTSW');
  __SCASB: AddStr(S,'SCASB');
  __SCASW: AddStr(S,'SCASW');
  __STOSB: AddStr(S,'STOSB');
  __STOSW: AddStr(S,'STOSW');
   End;
  End;
  __RETF: S := 'RETF';
  __RETN: S := 'RETN';
  __SAHF: S := 'SAHF';
  __SCASB: S := 'SCASB';
  __SCASW: S := 'SCASW';
  Lo(__SHR_AX_):
   Case Mem[CS:IP+1] of
    Hi(__SHR_AX_)..Hi(__SHR_AX_)+7: S := 'SHR '+RegWord[Mem[CS:IP+1] and 7]+',1';
   End;
  __STC: S := 'STC';
  __STD: S := 'STD';
  __STI: S := 'STI';
  __STOSB: S := 'STOSB';
  __STOSW: S := 'STOSW';
  __XOR_AX_:
   S := 'XOR AX,'+HexWord2Str(MemW[CS:IP+1]);
  __XOR_:
   Case Mem[CS:IP+1] of
    $F0..$F7: S := 'XOR '+RegWord[Mem[CS:IP+1] and 7]+','+HexWord2Str(MemW[CS:IP+2]);
   End;
 End;
 W.PutTxt(S);
 W.ClrEol;
 W._Ln;
 Math.STI;
 Repeat Until Keypressed;
 ReadKey;
End;

BEGIN
 SetCheckSvga(False);
 PathSystems := 'D:\BP\SOURCE\ISABEL';
 InitVideoDeluxe;
 InitColorsDefault;
 If(IsMonochrome)Then CurrColors := Colors[MtxMonochrome]
		 Else CurrColors := Colors[MtxBleuet];
 W.Init(0,1,MaxXTxts,MaxYTxts-1);
 W.PushWn;
 W.PutWn('Traceur de d‚bugage',CurrColors.MalteDos.Wins);
 GetIntVec($01,OldInt01h);
 SetIntVec($01,@Int01h);
 ASM
  PUSHF;
  POP AX;
  OR  AX,1 shl 8;
  PUSH AX;
  POPF;
 END;
 ASM
  PUSHF;
  POP AX;
  XOR AX,1 shl 8;
  PUSH AX;
  POPF;
 END;
 SetIntVec($01,OldInt01h);
 W.Done;
 DoneLuxeVideo;
END.