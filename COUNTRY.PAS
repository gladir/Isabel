{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                               ³
 ³                  Malte Genesis/Module des pays                ³
 ³                  Edition Isabel pour Mode R‚el                ³
 ³                        III - Version 1.0                      ³
 ³                         1995/03/11                            ³
 ³                                                               ³
 ³         Copyright (C) par les Chevaliers de Malte             ³
 ³                                                               ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Country;

INTERFACE

Uses Math,Systems;

Var Data:CountryRec;

Procedure InitCountry;
Function CStr(I:Long):String;
Function CStrDate(Time:Long):String;
Function CStrTime(Time:Long):String;
Function CStrTimeDos(Hour,Min,Sec:Byte):String;

IMPLEMENTATION

Uses Dos,Strings,Strs;

Procedure InitCountry;
Begin
 GetCountry(Data);
End;

Function CStr(I:Long):String;
Var S:String; I2:Long;
Begin
 S := Str(I); I2 := Abs(I);
 If(I2 > 1000000000)Then
  S := CopyStr(S,1,Length(S)-9) +
       Data.CO_THSEP + CopyStr(S,Length(S)-8,3) +
       Data.CO_THSEP + CopyStr(S,Length(S)-5,3) +
       Data.CO_THSEP + CopyStr(S,Length(S)-2,3)
  Else
 If(I2 > 1000000)Then
  S := CopyStr(S,1,Length(S)-6) +
       Data.CO_THSEP + CopyStr(S,Length(S)-5,3) +
       Data.CO_THSEP + CopyStr(S,Length(S)-2,3)
  Else
 If(I2 > 1000)Then
  S := CopyStr(S,1,Length(S)-3) + Data.CO_THSEP + CopyStr(S,Length(S)-2,3);
 CStr := S;
End;

Function CStrTime;
Var DT:DateTime; Target:String;
Begin
 UnpackTime(Time,DT);
 Target := Str2(DT.Hour,2); AddStr(Target,StrPas(Data.CO_TMSEP));
 AddStr(Target,Str0(DT.Min,2)); AddStr(Target,StrPas(Data.CO_TMSEP));
 AddStr(Target,Str0(DT.Sec,2));
 CStrTime := Target;
End;

Function CStrDate;
Var DT:DateTime; Target:String;
Begin
 UnpackTime(Time,DT);
 Case Data.CO_DATE of
  0:Begin
     Target := Str2(DT.Month,2); AddStr(Target,StrPas(Data.CO_DTSEP));
     AddStr(Target,Str0(DT.Day,2)); AddStr(Target,StrPas(Data.CO_DTSEP));
     AddStr(Target,Str0(DT.Year,4));
    End;
  1:Begin
     Target := Str2(DT.Day,2); AddStr(Target,StrPas(Data.CO_DTSEP));
     AddStr(Target,Str0(DT.Month,2)); AddStr(Target,StrPas(Data.CO_DTSEP));
     AddStr(Target,Str0(DT.Year,4));
    End;
Else Begin
     Target := Str2(DT.Year,4); AddStr(Target,StrPas(Data.CO_DTSEP));
     AddStr(Target,Str0(DT.Month,2)); AddStr(Target,StrPas(Data.CO_DTSEP));
     AddStr(Target,Str0(DT.Day,2));
    End;
 End;
 CStrDate := Target;
End;

Function CStrTimeDos;
Var Str:String;
Begin
 Str := Str0(Hour,2);
 AddStr(Str,StrPas(Data.CO_TMSEP));
 AddStr(Str,Str0(Min,2));
 AddStr(Str,StrPas(Data.CO_TMSEP));
 AddStr(Str,Str0(Sec,2));
 CStrTimeDos := Str;
End;

BEGIN
 FillChar(Data,SizeOf(Data),0);
END.