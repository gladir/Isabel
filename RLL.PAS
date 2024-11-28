{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³              Malte Genesis III/Module des RLL              ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit RLL;

INTERFACE

Uses Dos;

Procedure HaltOutOfMem;
Procedure HaltRLL;
Function AllocMainFunc(X:Word;Var _SizeOf:Word):Pointer;
Function AllocFunc(X:Word;FileName:PathStr;Var _SizeOf:Word):Pointer;

IMPLEMENTATION

Uses Math,Mems,Systems;

Procedure HaltOutOfMem;
Begin
 WriteLn('0002: Manque de m‚moire');
End;

Procedure HaltRLL;
Begin
 WriteLn('0001: Erreur interne RLL');
 Halt;
End;

Function AllocMainFunc;
Begin
 AllocMainFunc := AllocFunc(X,FileExpand('MAGICIAN.*'),_SizeOf);
End;

Function AllocFunc;
Var Handle:Word;
    X1,X2:PhysicalInfoVideo;
    Pos1,Pos2:Long;
    PtrFunc:Pointer;
Begin
 AllocFunc := NIL;
 Handle := OpenSearchPathNDos(';'+Path2Dir(FileName),Path2Name(FileName)+'.GIR',ReadOnly);
 If(IsHandleErr(Handle))Then Exit;
 GetRec(Handle,X,SizeOf(Long),Pos1);
 GetRec(Handle,X+1,SizeOf(Long),Pos2);
 Close(Handle);
 _SizeOf := Pos2-Pos1; PtrFunc := MemAlloc(_SizeOf);
 If(PtrFunc = NIL)Then Exit;
 Handle := OpenSearchPathNDos(';'+Path2Dir(FileName),Path2Name(FileName)+'.RLL',ReadOnly);
 If(IsHandleErr(Handle))Then Exit;
 SetFilePos(Handle,Pos1);
 _GetRec(Handle,_SizeOf,PtrFunc^);
 Close(Handle);
 AllocFunc := PtrFunc;
End;

BEGIN
END.