Unit MalCmPas;

INTERFACE

Function CompressPas:Boolean;

IMPLEMENTATION

Uses Dos,Math,Strs,Mems,Language,Systems,MLibrary,
     Keyboard,Video,MalConv,MalComRC,MalEnv;

Function CompressPas:Boolean;
Const BufSize = 32768;
Var Source,Target:PathStr; W:WinsWorking; Buffer:^TChar; BP,Handle:Word;
    Ok:Bool; Data,NS:Word; PChr:PChar; Word,WordU:String;

 Procedure Push(Chr:Char);
 Begin
  If(BP < BufSize)Then
  Begin
   Buffer^[BP] := Chr;
   Inc(BP);
   W.LineCode(BP);
  End;
 End;

 Procedure PushStr(Str:String);
 Var I : Byte;
 Begin
  For I := 1 to Length(Str) do Push(Str[I]);
 End;

 Procedure DelStr(Len:Byte);
 Begin
  Word := DeleteStr(Word,1,Len);
  Ok   := (Word = '')
 End;

Begin
 CompressPas := False;
 BP := 0;
 Buffer := MemAlloc(BufSize);
 If(Buffer = NIL)Then Exit;
 Source := WinPtr^.P.Edit.GetName;
 Target := Path2NoExt(Source) + '.PPA';
 SetAllColor($1B,$1F);
 PutLastBar(2,'Compression en cours: Presse ^Enter^ pour arrˆter');
 W.Init;
 W.SetCompress;
 W.MainFile('Pascal','PackPascal',Source,Target);
 W.TargetFormat('PackPascal (PPA)');
 W.FormatProcessor('Mode R‚el');
 W.Target('Disque');
 WinPtr^.P.Edit.Lst.SetPtr(0);
 For ErrJ := 0 to WinPtr^.P.Edit.MaxLns do
 Begin
  W.Line(ErrJ+1);
  W.TotalLine(ErrJ+1);
  PChr := WinPtr^.P.Edit.Lst._GetCurrBuf;
  If(PChr = NIL)Then
  Begin
   WinPtr^.P.Edit.Lst.Next;
   Continue;
  End;
  ErrI := 0;
  While Not(PChr[ErrI] = #0) do
  Begin
   Case PChr[ErrI] of
    'A'..'Z','a'..'z','_' :
    Begin
     Word := PExtractWord(ErrI,PChr);
     Repeat
      Ok    := True;
      WordU := StrUp(Word);
      If(CmpLeft(WordU,'ALLSTAR'))Then
      Begin
       Push(#1);
       Data := Byte(IsMaj(Word[1])) +
	       (Byte(IsMaj(Word[2])) shl 1) +
	       (Byte(IsMaj(Word[3])) shl 2) +
	       (Byte(IsMaj(Word[4])) shl 3) +
	       (Byte(IsMaj(Word[5])) shl 4) +
	       (Byte(IsMaj(Word[6])) shl 5) +
	       (Byte(IsMaj(Word[7])) shl 6);
       Push(Char(Data));
       DelStr(Length('ALLSTAR'));
       Continue;
      End;
      If(CmpLeft(WordU,'ANALOG'))Then
      Begin
       Push(#2);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5);
       Push(Char(Data));
       DelStr(Length('ANALOG'));
       Continue;
      End;
      If(CmpLeft(WordU,'ARRAY'))Then
      Begin
       Push(#3);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('ARRAY'));
       Continue;
      End;
      If(CmpLeft(Word,'ASM'))Then
      Begin
       Push(#4);
       DelStr(Length('ASM'));
       Continue;
      End;
      If(CmpLeft(Word,'Asm'))Then
      Begin
       Push(#5);
       DelStr(Length('Asm'));
       Continue;
      End;
      If(CmpLeft(WordU,'ASSEMBLER'))Then
      Begin
       Push(#6);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5) +
               (Byte(IsMaj(Word[7])) shl 6) +
               (Byte(IsMaj(Word[8])) shl 7);
       Push(Char(Data));
       DelStr(Length('ASSEMBLER'));
       Continue;
      End;
      If(CmpLeft(WordU,'ASYNC'))Then
      Begin
       Push(#7);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('ASYNC'));
       Continue;
      End;
      If(CmpLeft(WordU,'BASE'))Then
      Begin
       Push(#8);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('TRUE'));
       Continue;
      End;
      If(CmpLeft(WordU,'BASE'))Then
      Begin
       Push(#9);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('BASE'));
       Continue;
      End;

      If(CmpLeft(WordU,'BAUD'))Then
      Begin
       Push(#10);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('BAUD'));
       Continue;
      End;
      If(CmpLeft(WordU,'BEGIN'))Then
      Begin
       Push(#11);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('BEGIN'));
       Continue;
      End;
      If(CmpLeft(WordU,'BREAK'))Then
      Begin
       Push(#12);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('BREAK'));
       Continue;
      End;
      If(CmpLeft(WordU,'BUFFER'))Then
      Begin
       Push(#13);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5);
       Push(Char(Data));
       DelStr(Length('BUFFER'));
       Continue;
      End;
      If(CmpLeft(WordU,'CALL'))Then
      Begin
       Push(#14);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('CALL'));
       Continue;
      End;
      If(CmpLeft(WordU,'CLOSE'))Then
      Begin
       Push(#15);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('CLOSE'));
       Continue;
      End;
      If(CmpLeft(WordU,'COLOR'))Then
      Begin
       Push(#16);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('COLOR'));
       Continue;
      End;
      If(CmpLeft(WordU,'COMM'))Then
      Begin
       Push(#17);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('COMM'));
       Continue;
      End;
      If(CmpLeft(WordU,'COMPAQ'))Then
      Begin
       Push(#18);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5);
       Push(Char(Data));
       DelStr(Length('COMPAQ'));
       Continue;
      End;
      If(CmpLeft(WordU,'DELAY'))Then
      Begin
       Push(#19);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('DELAY'));
       Continue;
      End;
      If(CmpLeft(WordU,'DIGITAL'))Then
      Begin
       Push(#20);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5) +
               (Byte(IsMaj(Word[7])) shl 6);
       Push(Char(Data));
       DelStr(Length('DIGITAL'));
       Continue;
      End;
      If(CmpLeft(WordU,'DONE'))Then
      Begin
       Push(#21);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('DONE'));
       Continue;
      End;
      If(CmpLeft(WordU,'DOWN'))Then
      Begin
       Push(#22);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('DOWN'));
       Continue;
      End;
      If(CmpLeft(Word,'do'))Then
      Begin
       Push(#23);
       DelStr(Length('do'));
       Continue;
      End;
      If(CmpLeft(Word,'END'))Then
      Begin
       Push(#24);
       DelStr(Length('END'));
       Continue;
      End;
      If(CmpLeft(Word,'End'))Then
      Begin
       Push(#25);
       DelStr(Length('End'));
       Continue;
      End;
      If(CmpLeft(WordU,'EVEREX'))Then
      Begin
       Push(#26);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5);
       Push(Char(Data));
       DelStr(Length('EVEREX'));
       Continue;
      End;
      If(CmpLeft(WordU,'FALSE'))Then
      Begin
       Push(#27);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('FALSE'));
       Continue;
      End;
      If(CmpLeft(WordU,'FLUSH'))Then
      Begin
       Push(#28);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('FLUSH'));
       Continue;
      End;
      If(CmpLeft(Word,'For'))Then
      Begin
       Push(#29);
       DelStr(Length('For'));
       Continue;
      End;
      If(CmpLeft(Word,'ge'))Then
      Begin
       Push(#30);
       DelStr(Length('ge'));
       Continue;
      End;
      If(CmpLeft(Word,'Get'))Then
      Begin
       Push(#128);
       DelStr(Length('Get'));
       Continue;
      End;
      If(CmpLeft(WordU,'HEIGHT'))Then
      Begin
       Push(#129);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5);
       Push(Char(Data));
       DelStr(Length('HEIGHT'));
       Continue;
      End;
      If(CmpLeft(WordU,'IFDEF'))Then
      Begin
       Push(#130);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('IFDEF'));
       Continue;
      End;
      If(CmpLeft(WordU,'IMAGE'))Then
      Begin
       Push(#131);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('IMAGE'));
       Continue;
      End;
      If(CmpLeft(WordU,'IMPLEMENTATION'))Then
      Begin
       Push(#132);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5) +
               (Byte(IsMaj(Word[7])) shl 6) +
               (Byte(IsMaj(Word[8])) shl 7);
       Push(Char(Data));
       Data := Byte(IsMaj(Word[9])) +
               (Byte(IsMaj(Word[10])) shl 1) +
               (Byte(IsMaj(Word[11])) shl 2) +
               (Byte(IsMaj(Word[12])) shl 3) +
               (Byte(IsMaj(Word[13])) shl 4) +
               (Byte(IsMaj(Word[14])) shl 5);
       Push(Char(Data));
       DelStr(Length('IMPLEMENTATION'));
       Continue;
      End;
      If(CmpLeft(WordU,'INIT'))Then
      Begin
       Push(#133);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('INIT'));
       Continue;
      End;
      If(CmpLeft(WordU,'INTEGER'))Then
      Begin
       Push(#134);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5) +
               (Byte(IsMaj(Word[7])) shl 6);
       Push(Char(Data));
       DelStr(Length('INTEGER'));
       Continue;
      End;
      If(CmpLeft(WordU,'INTERFACE'))Then
      Begin
       Push(#135);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5) +
               (Byte(IsMaj(Word[7])) shl 6) +
               (Byte(IsMaj(Word[8])) shl 7);
       Push(Char(Data));
       Data := Byte(IsMaj(Word[9]));
       Push(Char(Data));
       DelStr(Length('INTERFACE'));
       Continue;
      End;
      If(CmpLeft(Word,'Is'))Then
      Begin
       Push(#136);
       DelStr(Length('Is'));
       Continue;
      End;
      If(CmpLeft(WordU,'LIBRARY'))Then
      Begin
       Push(#1);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5) +
               (Byte(IsMaj(Word[7])) shl 6);
       Push(Char(Data));
       DelStr(Length('LIBRARY'));
       Continue;
      End;
      If(CmpLeft(Word,'Lib'))Then
      Begin
       Push(#137);
       DelStr(Length('Lib'));
       Continue;
      End;
      If(CmpLeft(WordU,'LIST'))Then
      Begin
       Push(#138);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('LIST'));
       Continue;
      End;
      If(CmpLeft(Word,'Ln'))Then
      Begin
       Push(#139);
       DelStr(Length('Ln'));
       Continue;
      End;
      If(CmpLeft(WordU,'OPEN'))Then
      Begin
       Push(#140);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('OPEN'));
       Continue;
      End;
      If(CmpLeft(WordU,'OVERLAY'))Then
      Begin
       Push(#141);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5) +
               (Byte(IsMaj(Word[7])) shl 6);
       Push(Char(Data));
       DelStr(Length('OVERLAY'));
       Continue;
      End;
      If(CmpLeft(WordU,'PALETTE'))Then
      Begin
       Push(#142);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5) +
               (Byte(IsMaj(Word[7])) shl 6);
       Push(Char(Data));
       DelStr(Length('PALETTE'));
       Continue;
      End;
      If(CmpLeft(WordU,'PCHAR'))Then
      Begin
       Push(#143);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('PCHAR'));
       Continue;
      End;
      If(CmpLeft(WordU,'PCHR'))Then
      Begin
       Push(#144);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('PCHR'));
       Continue;
      End;
      If(CmpLeft(WordU,'PEEK'))Then
      Begin
       Push(#145);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('PEEK'));
       Continue;
      End;
      If(CmpLeft(WordU,'PIXEL'))Then
      Begin
       Push(#146);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('PIXEL'));
       Continue;
      End;
      If(CmpLeft(WordU,'PORT'))Then
      Begin
       Push(#147);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('PORT'));
       Continue;
      End;
      If(CmpLeft(WordU,'PROCEDURE'))Then
      Begin
       Push(#148);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5) +
               (Byte(IsMaj(Word[7])) shl 6) +
               (Byte(IsMaj(Word[8])) shl 7);
       Push(Char(Data));
       Data := Byte(IsMaj(Word[9]));
       Push(Char(Data));
       DelStr(Length('PROCEDURE'));
       Continue;
      End;
      If(CmpLeft(Word,'Put'))Then
      Begin
       Push(#149);
       DelStr(Length('Put'));
       Continue;
      End;
      If(CmpLeft(WordU,'PROGRAM'))Then
      Begin
       Push(#150);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5) +
               (Byte(IsMaj(Word[7])) shl 6);
       Push(Char(Data));
       DelStr(Length('PROGRAM'));
       Continue;
      End;
      If(CmpLeft(WordU,'RECORD'))Then
      Begin
       Push(#151);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5);
       Push(Char(Data));
       DelStr(Length('RECORD'));
       Continue;
      End;
      If(CmpLeft(WordU,'REPEAT'))Then
      Begin
       Push(#152);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5);
       Push(Char(Data));
       DelStr(Length('REPEAT'));
       Continue;
      End;
      If(CmpLeft(Word,'Set'))Then
      Begin
       Push(#153);
       DelStr(Length('Set'));
       Continue;
      End;
      If(CmpLeft(WordU,'SIZE'))Then
      Begin
       Push(#154);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('SIZE'));
       Continue;
      End;
      If(CmpLeft(WordU,'STRING'))Then
      Begin
       Push(#155);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5);
       Push(Char(Data));
       DelStr(Length('STRING'));
       Continue;
      End;
      If(CmpLeft(Word,'Str'))Then
      Begin
       Push(#156);
       DelStr(Length('Str'));
       Continue;
      End;
      If(CmpLeft(WordU,'TRIDENT'))Then
      Begin
       Push(#157);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5) +
               (Byte(IsMaj(Word[7])) shl 6);
       Push(Char(Data));
       DelStr(Length('TRIDENT'));
       Continue;
      End;
      If(CmpLeft(WordU,'TRUE'))Then
      Begin
       Push(#158);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('TRUE'));
       Continue;
      End;
      If(CmpLeft(WordU,'TSENG'))Then
      Begin
       Push(#159);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('TSENG'));
       Continue;
      End;
      If(CmpLeft(WordU,'TOOL'))Then
      Begin
       Push(#160);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('TOOL'));
       Continue;
      End;
      If(CmpLeft(Word,'to'))Then
      Begin
       Push(#161);
       DelStr(Length('to'));
       Continue;
      End;
      If(CmpLeft(WordU,'TYPE'))Then
      Begin
       Push(#162);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('TYPE'));
       Continue;
      End;
      If(CmpLeft(WordU,'UART'))Then
      Begin
       Push(#163);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('UART'));
       Continue;
      End;
      If(CmpLeft(WordU,'UNTIL'))Then
      Begin
       Push(#164);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('UNTIL'));
       Continue;
      End;
      If(CmpLeft(WordU,'USES'))Then
      Begin
       Push(#165);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('USES'));
       Continue;
      End;
      If(CmpLeft(Word,'Var'))Then
      Begin
       Push(#166);
       DelStr(Length('Var'));
       Continue;
      End;
      If(CmpLeft(WordU,'VIDEO'))Then
      Begin
       Push(#167);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('VIDEO'));
       Continue;
      End;
      If(CmpLeft(WordU,'VISION'))Then
      Begin
       Push(#168);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5);
       Push(Char(Data));
       DelStr(Length('VISION'));
       Continue;
      End;
      If(CmpLeft(WordU,'WINDOW'))Then
      Begin
       Push(#169);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5);
       Push(Char(Data));
       DelStr(Length('WINDOW'));
       Continue;
      End;
      If(CmpLeft(WordU,'WITH'))Then
      Begin
       Push(#170);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3);
       Push(Char(Data));
       DelStr(Length('WITH'));
       Continue;
      End;
      If(CmpLeft(WordU,'WONDER'))Then
      Begin
       Push(#171);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4) +
               (Byte(IsMaj(Word[6])) shl 5);
       Push(Char(Data));
       DelStr(Length('WONDER'));
       Continue;
      End;
      If(CmpLeft(WordU,'ZYMOS'))Then
      Begin
       Push(#172);
       Data := Byte(IsMaj(Word[1])) +
               (Byte(IsMaj(Word[2])) shl 1) +
               (Byte(IsMaj(Word[3])) shl 2) +
               (Byte(IsMaj(Word[4])) shl 3) +
               (Byte(IsMaj(Word[5])) shl 4);
       Push(Char(Data));
       DelStr(Length('ZYMOS'));
       Continue;
      End;
      If(Word <> '')Then
      Begin
       Push(Word[1]);
       DelStr(1);
       Continue;
      End;
     Until Ok;
    End;
    ' ' :
    Begin
     NS := 0;
     While (PChr[ErrI] = ' ') do
     Begin
      Inc(NS);
      Inc(ErrI);
     End;
     Case NS of
      0,1 : Push(' ');
        2 : Push(#240);
        3 : Push(#241);
        4 : Push(#242);
        5 : Push(#243);
        6 : Push(#244);
        7 : Push(#245);
        8 : Push(#246);
        9 : Push(#247);
       10 : Push(#248);
       11 : Push(#249);
       12 : Push(#250);
       13 : Push(#251);
       14 : Push(#252);
       15 : Push(#253);
       16 : Push(#254);
  17..255 : Begin
             Push(#239);
             Push(Char(NS));
            End;
       Else Begin
             Push(#238);
             Push(Char(Lo(NS)));
             Push(Char(Hi(NS)));
            End;
     End;
    End;
    Else
    Begin
     If(PChr[ErrI] in [#1..#31,#128..#255])Then Push(#255);
     Push(PChr[ErrI]);
     Inc(ErrI);
    End;
   End;
  End;
  Push(#31);
  WinPtr^.P.Edit.Lst.Next;
 End;
 SetAllColor($1B,$1F);
 PutLastBar(2,'Sauvegarde...');
 Del(Target);
 Handle := New(Target);
 Close(Handle);
 SetFile(Target,0,BP,Buffer^[0]);
 PutLastBar(2,'Compression R‚ussit: Presse ^Enter^ pour arrˆter');
 ReadKey;
 W.Done;
 CompressPas := True;
End;

BEGIN
END.