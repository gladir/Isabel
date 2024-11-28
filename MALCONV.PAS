Unit MalConv;

INTERFACE

Uses Dos,Math,Video,Windows;

Type

     WinsWorking = Object
		    Constructor Init;
		    Procedure SetConv;
		    Procedure SetCompiler;
		    Procedure SetCompress;
		    Procedure MainFile(NameIn,NameOut:String;PathInput,PathOutput:PathStr);
		    Procedure Target(Msg:String);
		    Procedure TargetFormat(Msg:String);
		    Procedure FormatProcessor(Msg:String);
		    Procedure Line(L:Long);
		    Procedure LineCode(L:Long);
		    Procedure TotalLine(L:Long);
		    Destructor Done;
		    PRIVATE
		    W:Wins;
		    Model:(Conv,Compiler,Compress);
		    Procedure SetWin(Title:String);
		   End;

IMPLEMENTATION

Uses Strings,Strs,Language,Systems,Keyboard,MLibrary,Dials,MalEnv;

Constructor WinsWorking.Init;
Begin
End;

Procedure WinsWorking.SetWin;
Begin
 W.InitO(70,20);
 W.PushWn;
 W.PutWn(Title,CurrColors.Dialog.Wins);
 W.SetPos(0,4);
 W.PutTxtLn('Source Fichier     :');
 W.PutTxtLn('Format Destination :');
 W.PutTxtLn('Format Processeur  :');
 W.Ln;
 W.PutTxtLn(StrUSpc('Source    :',35)+'Destination :');
 W.Ln;
 W.PutTxtLn(StrUSpc('Constante :',35)+'Total Ligne :');
 W.PutTxtLn(StrUSpc('Variable  :',35)+'Ligne local :');
 W.PutTxtLn(StrUSpc('Procedure :',35)+'Ligne code  :');
 W.PutTxtLn(        'Type      :');
 W.Ln;
 W.PutTxtLn(                'Message Attention :');
 W.PutTxtLn(Spc(Length('Message '))+'Erreur    :');
 W.PutkHorDn('Stop');
End;

Procedure WinsWorking.Target;
Begin
 W.SetKr($9B);
 W.PutTxtXY(49,8,Msg);
End;

Procedure WinsWorking.TotalLine;
Begin
 W.SetKr($9B);
 W.PutTxtXY(49,10,Str(L));
End;

Procedure WinsWorking.Line;
Begin
 W.SetKr($9B);
 W.PutTxtXY(49,11,Str(L));
End;

Procedure WinsWorking.LineCode;
Begin
 W.SetKr($9B);
 W.PutTxtXY(49,12,Str(L));
End;

Procedure WinsWorking.TargetFormat;
Begin
 W.SetKr($9B);
 W.PutTxtXY(21,5,Msg);
End;

Procedure WinsWorking.FormatProcessor;
Begin
 W.SetKr($9B);
 W.PutTxtXY(21,6,Msg);
End;

Procedure WinsWorking.SetConv;
Begin
 Model := Conv;
 SetWin('Convertisseur');
End;

Procedure WinsWorking.SetCompiler;
Begin
 Model := Compiler;
 SetWin('Compilateur');
End;

Procedure WinsWorking.SetCompress;
Begin
 Model := Compress;
 SetWin('Compresseur');
End;

Procedure WinsWorking.MainFile;
Begin
 W.PutTxtXY(0,1,'Main');
 W.PutTxtXY(5,1,StrUSpc(NameIn,12)+': ');
 W.SetKr($9B);
 W.PutTxt(PathInput);
 W.SetKr($9F);
 W.PutTxtXY(5,2,StrUSpc(NameOut,12)+': ');
 W.SetKr($9B);
 W.PutTxt(PathOutput);
 W.SetKr($9F);
End;

Destructor WinsWorking.Done;
Begin
 W.Done;
End;

BEGIN
END.