{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                               ³
 ³         Malte Genesis/Module du Temps         ³
 ³         Edition Isabel pour Mode R‚el         ³
 ³               III - Version 1.0               ³
 ³                  1995/02/02                   ³
 ³                                               ³
 ³   Copyright (C) par les Chevaliers de Malte   ³
 ³                                               ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Clock;

INTERFACE

{$D-,L-,Y-,I-,Q-,R-,S-,X+}

Uses Math;

Const
       DaysPerMonth: Array[1..12] of Byte = (31,28,31,30,31,30,31,31,30,31,30,31);

       GMTDifference:ShortInt = 0;

Type

     TimeFormatType = (MilitaryTime,AmPmTime);

Var
    Days4Month: Array[0..11] of Byte Absolute DaysPerMonth;

Procedure AdjustHour(Var Hour:Byte;Var AmPm:String);
Procedure Delay(Sec1000:Int);
Procedure GetUnixStyleDate(Date:Long;Var Year,Month,Day,Hour,Mins,Secs:Word);
Procedure SetOnTimer;
Procedure SetPosTime(X,Y:Byte);
Procedure SetPosTimeAfterEndOfDay(X,Y:Byte);
Procedure SetPosTimeInPrg(X,Y:Byte);
Procedure SetPosTimeMod(X,Y:Byte);
Procedure SetPosTimeOnLine(X,Y:Byte);
Procedure SetTimerMod;
Procedure SetTimerModOff;
Procedure SetTimerOnLine;
Procedure SetTimerOnLineOff;
Procedure SetUnixStyleDate(Var Date:Long;Year,Month,Day,Hour,Min,Secs:Word);
Procedure _Delay(Var OneMSDelay:Int);

Function GetPackTimer:Long;
Function StrTime(Time:Long):String;
Function TimeDiff(Timer1,Timer2:Long):Long;
Function TimeDiffH(Timer1,Timer2:Long):Long;
Function TimeOfDay:Long;
Function TimeOfDayH:Long;
Function TimeString(TimerValue:Long;TimerFormat:TimeFormatType):String;

IMPLEMENTATION

Uses Dos,Strings,Country,Strs,Video,Systems,Keyboard,Mouse,ScrnSaver;

Var
    TimeX,TimeY,TimeXA,TimeYA,TimeXIn,TimeYIn,TimeXMod,TimeYMod,
    TimeXOnLine,TimeYOnLine:Byte;
    TimerActived:Bool; TimeIn,TimeMod,TimeOnLine:Long;
    Old:Byte; OldBackKbd:Procedure;

Procedure BackTimer; Far;
Var Curr,Hour,Min,Sec,XM,YM,Page:Byte; Time,Timeb:Long; Str:String[10];
    BM:Word; LenStr:Byte Absolute Str;

  Procedure CheckInPtrMouseOff(X,Y:Byte);
  Begin
   If(YM = Y)Then If(XM >= X)and(XM <= (X+LenStr))Then __HideMousePtr;
  End;

  Procedure CheckInPtrMouseOn(X,Y:Byte);
  Begin
   If(YM = Y)Then If(XM >= X)and(XM <= (X+LenStr))Then __ShowMousePtr;
  End;

Begin
 OldBackKbd;
 If(TimerActived)Then
 Begin
  CLI;
  Curr := (Mem[$0040:$6C] and $F0);
  STI;
  If(Old <> Curr)Then
  Begin
   Old := Curr;
   If(IVid.Graf)Then Page := GetSelectPage;
   CLI;
   Time := MemL[$0040:$6C];
   STI;
   If Not(Time = 0)Then
   Begin
    Time := DivL(Time*10,182); Hour := DivL(Time,60 * 60);
    Min := ModW(DivL(Time,60),60); Sec := ModW(Time,60);
    If Not((TimeX = $FE)or(TimeXA = $FE)or(TimeXIn = $FE))Then
    __GetMouseTextSwitch(XM,YM,BM);
     { Heure courante }
    If Not(TimeX = $FE)Then
    Begin
     CheckInPtrMouseOff(TimeX,TimeY);
     PutTextXYUnCol(TimeX,TimeY,CStrTimeDos(Hour,Min,Sec));
     CheckInPtrMouseOn(TimeX,TimeY);
    End;
     { Heure avant minuit }
    If Not(TimeXA = $FE)Then
    Begin
     CheckInPtrMouseOff(TimeXA,TimeYA);
     PutTextXYUnCol(TimeXA,TimeYA,CStrTimeDos(23-Hour,59-Min,59-Sec));
     CheckInPtrMouseOn(TimeXA,TimeYA);
    End;
     { Nombre de temps en ".MOD" }
    If Not(TimeMod = 0)Then
    Begin
     Timeb := Long(Long(Time) - Long(TimeMod));
     If(Timeb > 0)Then
     Begin
      Hour := DivL(Timeb,60 * 60);
      Min := ModW(DivL(Timeb,60),60);
      Sec := ModW(Timeb,60);
      If Not(TimeXMod = $FE)Then
      Begin
       CheckInPtrMouseOff(TimeXMod,TimeYMod);
       PutTextXYUnCol(TimeXMod,TimeYMod,CStrTimeDos(Hour,Min,Sec));
       CheckInPtrMouseOn(TimeXMod,TimeYMod);
      End;
     End;
    End;
     { Nombre de temps en OnLine }
    If Not(TimeOnLine = 0)Then
    Begin
     Timeb := Time - TimeOnLine;
     If Not(Timeb = 0)Then
     Begin
      Hour := DivL(Timeb,60 * 60);
      Min := ModW(DivL(Timeb,60),60);
      Sec := ModW(Timeb,60);
      If Not(TimeXOnLine = $FE)Then
      Begin
       CheckInPtrMouseOff(TimeXOnLine,TimeYOnLine);
       PutTextXYUnCol(TimeXOnLine,TimeYOnLine,CStrTimeDos(Hour,Min,Sec));
       CheckInPtrMouseOn(TimeXOnLine,TimeYOnLine);
      End;
     End;
    End;
     { Nombre de temps dans le programme }
    Dec(Time,TimeIn);
    If Not(Time = 0)Then
    Begin
     Hour := DivL(Time,60 * 60);
     Min := ModW(DivL(Time,60),60);
     Sec := ModW(Time,60);
     If Not(TimeXIn = $FE)Then
     Begin
      CheckInPtrMouseOn(TimeXIn,TimeYIn);
      PutTextXYUnCol(TimeXIn,TimeYIn,CStrTimeDos(Hour,Min,Sec));
      CheckInPtrMouseOn(TimeXIn,TimeYIn);
     End;
    End;
   End;
   If(IVid.Graf)Then MainData^.SelBankPg(Page);
  End;
 End;
End;

Procedure Delay;
Var T,N:Word; Old,Curr:Byte;
Begin
 If(Sec1000 > 1000)Then
 Begin
  T := DivL(Sec1000,1000) * 18; N := 0;
  CLI;
  Old := Mem[$0040:$6C];
  STI;
  ActifScrSave := False;
  _InitKbd;
  Repeat
   _BackKbd;
   CLI;
   Curr := Mem[$0040:$6C];
   STI;
   If(Old <> Curr)Then
   Begin
    Old := Curr;
    Inc(N);
    If(N >= T)Then
    Begin
     ActifScrSave := True;
     Exit;
    End;
   End;
  Until False;
 End
  Else
 _Delay(Sec1000);
End;

Function GetPackTimer;
Var T:DateTime; H:Word; R:Long;
Begin
 GetDate(T.Year,T.Month,T.Day,H);
 Dos.GetTime(T.Hour,T.Min,T.Sec,H);
 PackTime(T,R);
 GetPackTimer := R;
End;

Procedure SetOnTimer;
Begin
 TimerActived := True;
End;

Procedure SetPosTime;
Begin
 TimeX := X; TimeY := Y;
End;

Procedure SetPosTimeAfterEndOfDay;
Begin
 TimeXA := X; TimeYA := Y;
End;

Procedure SetPosTimeInPrg;
Begin
 TimeXIn := X; TimeYIn := Y;
End;

Procedure SetPosTimeMod;
Begin
 TimeXMod := X; TimeYMod := Y;
End;

Procedure SetPosTimeOnLine;
Begin
 TimeXOnLine := X; TimeYOnLine := Y;
End;

Procedure SetTimerOnLine;
Begin
 CLI;
 TimeOnLine := DivL((MemL[_0040:$6C] * 10),182);
 STI;
End;

Procedure SetTimerMod;
Begin
 CLI;
 TimeMod := DivL((MemL[_0040:$6C] * 10),182);
 STI;
End;

Procedure SetTimerOnLineOff;
Begin
 CLI;
 TimeOnLine := 0;
 STI;
End;

Procedure SetTimerModOff;
Begin
 CLI;
 TimeMod := 0;
 STI;
End;

Function StrTime;
Var DT:DateTime; Target:String;
Begin
 UnpackTime(Time,DT);
 Target := Str2(DT.Year,4); IncStr(Target,'-');
 AddStr(Target,Str0(DT.Month,2)); IncStr(Target,'-');
 AddStr(Target,Str0(DT.Day,2));
 AddStr(Target,Str2(DT.Hour,3)); IncStr(Target,':');
 AddStr(Target,Str0(DT.Min,2)); IncStr(Target,':');
 AddStr(Target,Str0(DT.Sec,2));
 StrTime := Target;
End;

Function TimeDiff;
Const SecsPerDay = 86400;
Var TDiff:Long;
Begin
 TDiff := (Timer2 - Timer1);
 If(TDiff < 0)Then Inc(TDiff,SecsPerDay);
 TimeDiff := TDiff;
END;

Function TimeDiffH;
Const HundredthsSecsPerDay = 8640000;
Var TDiff:Long;
Begin
 TDiff := Timer2 - Timer1;
 If(Tdiff < 0)Then Inc(Tdiff,HundredthsSecsPerDay);
 TimeDiffH := Tdiff;
End;

Function TimeOfDay;
Var Hours,Minutes,Seconds,SecHun:Word;
    TimeVal:Long;
Begin
 Dos.GetTime(Hours,Minutes,Seconds,SecHun);
 TimeVal := Hours; TimeOfDay := (TimeVal * 3600) + (Minutes * 60) + Seconds;
End;

Function TimeOfDayH;
Var Hours,Minutes,Seconds,SecHun:Word; TimerVal:Long;
Begin
 Dos.GetTime(Hours,Minutes,Seconds,SecHun);
 TimerVal := Hours;
 TimeOfDayH := (TimerVal * 360000) + (Minutes * 6000) + (Seconds * 100) + SecHun;
End;

Procedure _Delay;
Assembler;
Const HiTimer:Int = 0; LoTimer:Int = 0; OutCount:Int = 0;
ASM
 XOR AX,AX;
 MOV ES,AX;
 MOV OutCount,0;
 CLI;
 MOV CX,ES:[$046E];
 MOV DX,ES:[$046C];
 STI;
 MOV HiTimer,CX;
 MOV LoTimer,DX;
@@Loop1:
 CLI;
 MOV CX,ES:[$046E];
 MOV DX,ES:[$046C];
 STI;
 MOV AX,CX;
 MOV BX,DX;
 SUB AX,HiTimer;
 SBB BX,LoTimer;
 JE  @@Loop1;
 MOV HiTimer,CX;
 MOV LoTimer,DX;
@@Loop2:
 MOV CX,110;
@@Delay:
 LOOP @@Delay;
 CLI;
 MOV CX,ES:[$046E];
 MOV DX,ES:[$046C];
 STI;
 INC OutCount;
 SUB CX,HiTimer;
 SBB DX,LoTimer;
 JE  @@Loop2;
 MOV AX,OutCount;
 SHL AX,1;
 LES DI,OneMSDelay;
 MOV ES:[DI],AX;
End;

Procedure GetUnixStyleDate;
Const SecsPerYear     = 31536000;
      SecsPerLeapYear = 31622400;
      SecsPerDay      = 86400;
      SecsPerHour     = 3600;
      SecsPerMinute   = 60;
Var RDate,T:Long;
Begin
 Year := 1970; Month := 1; Dec(RDate,GMTDifference * SecsPerHour);
 While(RDate > 0) do
 Begin
  If((Year mod 4) = 0)Then T := SecsPerLeapYear Else T := SecsPerYear;
  Dec(RDate,T); Inc(Year);
 End;
 Inc(RDate,T); Dec(Year);
 If((Year mod 4) = 0)Then DaysPerMonth[2] := 29 Else DaysPerMonth[2] := 28;
 While(RDate > 0) do
 Begin
  T := DaysPerMonth[Month] * SecsPerDay; Dec(RDate,T); Inc(Month);
 End;
 Inc(RDate,T); Dec(Month); Day := Trunc((RDate + Pred(SecsPerDay)) / SecsPerDay);
 Dec(RDate,Long(Pred(Day)) * SecsPerDay); Hour := Trunc(RDate / SecsPerHour);
 Dec(RDate,Long(Hour) * SecsPerHour); Mins := Trunc(RDate / SecsPerMinute);
 Secs := Trunc(RDate - Long(Mins) * SecsPerMinute);
End;

Procedure SetUnixStyleDate;
Const SecsPerYear=31536000; SecsPerLeapYear=31622400;
      SecsPerDay=86400; SecsPerHour=3600; SecsPerMinute=60;
Var RDate,T:Long; LeapYear:Bool; I:Int;
Begin
 Date := GMTDifference * SecsPerHour;
 For I := 1970 TO Pred(Year) DO
 Begin
  If((I mod 4) = 0)Then T := SecsPerLeapYear Else T := SecsPerYear;
  Inc(Date,T);
 End;
 If((Year mod 4) = 0)Then DaysPerMonth[2] := 29 Else DaysPerMonth[2] := 28;
 For I := 1 TO Month-1 do Inc(Date,LongInt(DaysPerMonth[I]) * SecsPerDay);
 Inc(Date,Long(Pred(Day))*SecsPerDay+Long(Hour) * SecsPerHour+
	  Long(Min)*SecsPerMinute+Secs);
End;

Procedure AdjustHour(Var Hour:Byte;Var AmPm:String);
Begin
 If(Hour < 12)Then
 Begin
  AmPm := 'am';
  If(Hour = 0)Then Hour := 12;
 End
  Else
 Begin
  AmPm := 'pm';
  If(Hour <> 12)Then Dec(Hour,12);
 End;
End;

Function TimeString;
Var Hours:Byte; SaveHrs,SaveH:Long; Minutes,Seconds:Int; AmPm:String[3];
Begin
 Hours := DivL(TimerValue,3600); SaveHrs := Hours; AmPm := '';
 If(TimerFormat = AmPmTime)Then
 Begin
  AdjustHour(Hours,AmPm);
  AmPm := ' ' + AmPm;
 End;
 SaveH := TimerValue - SaveHrs * 3600; Minutes := DivL(SaveH,60);
 Seconds := SaveH - Minutes * 60;
 If(TimerFormat <> AMPMTime)Then
  TimeString := Str0(Hours,2) + ':' + Str0(Minutes,2) + ':' + Str0(Seconds,2)
 Else
  TimeString := Str2(Hours,2) + ':' + Str0(Minutes,2) + ':' + Str0(Seconds,2) + AmPm;
End;

BEGIN { Main Unit }
 TimerActived := False; TimeX := $FE; TimeY := $FE; TimeXA := $FE;
 TimeYA := $FE; TimeXIn := $FE; TimeYIn := $FE; TimeXMod := $FE;
 TimeYMod := $FE; TimeXOnLine := $FE; TimeYOnLine := $FE; TimeMod := 0;
 TimeOnLine := 0;
 CLI;
 TimeIn := (MemL[_0040:$006C] * 10) div 182;
 Old := Mem[$0040:$6C];
 STI;
 OldBackKbd := _BackKbd;
 _BackKbd := BackTimer;
END.