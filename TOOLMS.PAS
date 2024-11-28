(*********************************************************)
(*                                                       *)
(*               Malte Genesis/Tools Mouse               *)
(*    Phoenix Edition for Real Mode & Protected Mode     *)
(*                   II - Version 1.8                    *)
(*                      1994/12/29                       *)
(*                                                       *)
(*       Copyright (C) par les Chevaliers de Malte       *)
(*                                                       *)
(*********************************************************)

Unit ToolMs;

INTERFACE

Function GetStrMouse:String;
Function GetMsVer:String;
Function BusType:Byte;

IMPLEMENTATION

Uses Strs,Systems,Video;

Function GetMsVer:String;
Var _AX,_BX,_CX,a : Word;
Begin
 GetMsVer := 'Inconnue';
 ASM
  MOV AX,$0021;
  INT $33;
  MOV _AX,AX;
 END;
 If(_AX = $FFFF)Then
 Begin
  ASM
   MOV AX,$0070;
   MOV BX,$ABCD;
   INT $33;
   MOV _AX,AX;
   MOV _BX,BX;
   MOV _CX,CX;
  END;
  If(_AX = $ABCD)and(MemW[_BX:_CX] = $ABCD)and(MemW[_BX:_CX+8] = $ABCD)Then
  Begin
   a := MemW[MemW[_BX:_CX+4]:MemW[_BX:_CX+2]];
   GetMsVer := Str(Hi(a)) + '.' + Str(Lo(a));
   Exit;
  End;
  ASM
   MOV AX,$266C;
   XOR BX,BX;
   XOR CX,CX;
   INT $33;
   MOV _BX,BX;
   MOV _CX,CX;
  END;
  If(_BX = $5353)Then
  Begin
   GetMsVer := Str(Hi(_CX)) + '.' + Str(Lo(_CX));
   Exit;
  End;
 End;
 Begin
  ASM
   MOV AX,$0024;
   INT $33;
   MOV _AX,AX;
   MOV _BX,BX;
  END;
  If(_AX < $FFFF)Then GetMsVer := Str(Hi(_BX)) + '.' + Str(Lo(_BX));
 End;
End;

Function BusType:Byte;
Assembler;
ASM
 MOV AX,$0024;
 INT $33;
 CMP AX,$FFFF;
 JNE @@End;
 MOV AL,CH;
@@End:
End;

Function GetStrMouse:String;
Var S : String;
Begin
 Case BusType of
  $01 : S := 'Bus';
  $02 : S := 'S‚rie';
  $03 : S := 'Inport';
  $04 : S := 'PS/2';
  $05 : S := 'HP';
   Else Begin
	 If(PVid1^.MousePort)Then S := 'S‚rie sur carte vid‚o'
			     Else S := 'S‚rie';
        End;
 End;
 GetStrMouse := 'Souris ' + S + ', Version ' + GetMsVer;
End;

BEGIN
END.