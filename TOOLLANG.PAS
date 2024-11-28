(*********************************************************)
(*                                                       *)
(*               Malte Genesis/Tools Language            *)
(*    Phoenix Edition for Real Mode & Protected Mode     *)
(*                    II - Verision 1.8                  *)
(*                        1994/12/29                     *)
(*                                                       *)
(*      Copyright (C) par les Chevaliers de Malte        *)
(*                                                       *)
(*********************************************************)

Unit ToolLang;

INTERFACE

Function ErrStr(Code:Integer):String;
Function IsReservedWordAsm(Word:String):Boolean;
Function IsReservedWordBasic(Word:String):Boolean;
Function IsReservedWordC(Word:String):Boolean;
Function IsReservedWordEuphoria(Word:String):Boolean;
Function IsReservedWordPascal(Word:String):Boolean;
Function KeyCode2MGPConst(Code:Word):String;
Function StrRC2MGP(Str:String;Var K:Word):String;

IMPLEMENTATION

Uses Strs,Keyboard,Language;

Function ErrStr(Code:Integer):String;
Begin
 Case Code of
         PointCommaExpected : ErrStr := ''';'' attendue';
            OpenEnsExpected : ErrStr := '''{'' attendue';
           CloseEnsExpected : ErrStr := '''}'' attendue';
          OpenArrayExpected : ErrStr := '''['' attendue';
         CloseArrayExpected : ErrStr := ''']'' attendue';
            OpenParExpected : ErrStr := '''('' attendue';
           CloseParExpected : ErrStr := ''')'' attendue';
            AsterixExpected : ErrStr := '''*'' attendue';
                NumExpected : ErrStr := '''#'' attendue';
                 GrExpected : ErrStr := '''>'' attendue';
              GuillExpected : ErrStr := '''"'' attendue';
              CommaExpected : ErrStr := ''','' attendue';
               EnumExpected : ErrStr := 'Enumeration attendue';
      NumberOfArrayExpected : ErrStr := 'Nombre de chaine attendue';
      EndOfFunctionExpected : ErrStr := 'Fin de fonction attendue';
        EndOfSourceExpected : ErrStr := 'Fin de source attendue';
        EndOfStringExpected : ErrStr := 'Fin de chaine attendue';
       EndOfCommentExpected : ErrStr := 'Fin de remarque attendue';
       EndOfCommandExpected : ErrStr := 'Fin de commande attendue';
      EndOfArgumentExpected : ErrStr := 'Fin d''argument attendue';
            TypeVarExpected : ErrStr := 'Type de la variable attendue';
            VarNameExpected : ErrStr := 'Name de la variable attendue';
   DirectiveCommandExpected : ErrStr := 'Commande de directive attendue';
        TypedefNameExpected : ErrStr := 'Nom du "typedef" attendue';
    IncludeFileNameExpected : ErrStr := 'Nom de fichier du "include" attendue';
       IfDirectNameExpected : ErrStr := 'Nom de la directive "if" attendue';
    IfDefDirectNameExpected : ErrStr := 'Nom de la directive "ifdef" attendue';
   IfNDefDirectNameExpected : ErrStr := 'Nom de la directive "ifndef" attendue';
              WhileExpected : ErrStr := '"while" attendue';
              BeginExpected : ErrStr := 'Commande de dÇbut attendue';
               NameExpected : ErrStr := 'Nom attendue';
              ValueExpected : ErrStr := 'Valeur attendue';
               TypeExpected : ErrStr := 'Type attendue';
                 OfExpected : ErrStr := '"Of" attendue';
              LabelExpected : ErrStr := 'Label attendue';
                   EnumDupl : ErrStr := 'Duplication d''ênumeration';
              VarStructDupl : ErrStr := 'Duplication de structure de variable';
UsePascalReservedWordForVar : ErrStr := 'Utilise un mots rÇservÇ par le pascal comme variable';
                  EnumEmpty : ErrStr := '"enum" vide';
                StructEmpty : ErrStr := '"struc" vide';
        TooManyPathInHeader : ErrStr := 'Trop d''item PATH dans l''item HEADER';
             TooManyWarning : ErrStr := 'Trop de message d''attention';
          UnknownIdentifier : ErrStr := 'Identificateur inconnue';
                UnknownType : ErrStr := 'Type inconnue';
                SyntaxError : ErrStr := 'Erreur de syntaxe';
               SyntaxNumber : ErrStr := 'Syntaxe du nombre';
       MisplacedBeginSymbol : ErrStr := 'Commande de dÇbut mal placÇ';
     MisplacedCondDirective : ErrStr := 'Directive conditional mal placÇ';
         MisplacedEndSymbol : ErrStr := 'Symbol de fin mal placÇ';
        MisplacedPointComma : ErrStr := ''';'' mal placÇ';
               TooBigNumber : ErrStr := 'Nombre trop gros (en dehors de l''intervale)';
               FileNotFound : ErrStr := 'Fichier introuvable';
           CannotCreateFile : ErrStr := 'Impossible de crÇer un fichier';
              FileReadError : ErrStr := 'Erreur de lecture de fichier';
                OutOfMemory : ErrStr := 'Manque de mÇmoire';
              InternalError : ErrStr := 'Erreur interne du compilateur';
 End;
End;

Function IsReservedWordAsm(Word:String):Boolean;
Begin
 IsReservedWordAsm :=
  (Word = 'ASSUME')or
  (Word = 'CODE')or
  (Word = 'DATA')or
  (Word = 'ELSE')or
  (Word = 'END')or
  (Word = 'ENDIF')or
  (Word = 'ENDM')or
  (Word = 'ENDP')or
  (Word = 'ENDS')or
  (Word = 'EXTRN')or
  (Word = 'FAR')or
  (Word = 'IFB')or
  (Word = 'INCLUDE')or
  (Word = 'MACRO')or
  (Word = 'NEAR')or
  (Word = 'OFFSET')or
  (Word = 'PAGE')or
  (Word = 'PRIVATE')or
  (Word = 'PROC')or
  (Word = 'PUBLIC')or
  (Word = 'SEGMENT')or
  (Word = 'STRUC')or
  (Word = 'TITLE');
End;

Function IsReservedWordBasic(Word:String):Boolean;
Begin
 IsReservedWordBasic :=
  (Word = 'AND')or
  (Word = 'BASE')or
  (Word = 'CALL')or
  (Word = 'CASE')or
  (Word = 'CHAIN')or
  (Word = 'COMMON')or
  (Word = 'DATA')or
  (Word = 'DIM')or
  (Word = 'DO')or
  (Word = 'DYNAMIC')or
  (Word = 'ELSE')or
  (Word = 'END')or
  (Word = 'ERASE')or
  (Word = 'FOR')or
  (Word = 'GOSUB')or
  (Word = 'GOTO')or
  (Word = 'IF')or
  (Word = 'INTERRUPT')or
  (Word = 'LOOP')or
  (Word = 'ON')or
  (Word = 'OPTION')or
  (Word = 'OR')or
  (Word = 'NEXT')or
  (Word = 'NOT')or
  (Word = 'REM')or
  (Word = 'RUN')or
  (Word = 'SELECT')or
  (Word = 'STEP')or
  (Word = 'STOP')or
  (Word = 'SUB')or
  (Word = 'THEN')or
  (Word = 'TO')or
  (Word = 'TROFF')or
  (Word = 'TRON')or
  (Word = 'WEND')or
  (Word = 'WHILE')or
  (Word = 'XOR');
End;

Function IsReservedWordC(Word:String):Boolean;
Begin
 IsReservedWordC :=
                    (Word = 'asm')or
                    (Word = 'auto')or
                    (Word = 'break')or
                    (Word = 'case')or
                    (Word = 'cdcel')or
                    (Word = 'constant')or
                    (Word = 'continue')or
                    (Word = 'default')or
                    (Word = 'do')or
                    (Word = 'else')or
                    (Word = 'enum')or
                    (Word = 'extern')or
                    (Word = 'far')or
                    (Word = 'for')or
                    (Word = 'goto')or
                    (Word = 'huge')or
                    (Word = 'if')or
                    (Word = 'interrupt')or
                    (Word = 'near')or
                    (Word = 'pascal')or
                    (Word = 'register')or
                    (Word = 'return')or
                    (Word = 'signed')or
                    (Word = 'static')or
                    (Word = 'struct')or
                    (Word = 'switch')or
                    (Word = 'typdef')or
                    (Word = 'union')or
                    (Word = 'unsigned')or
                    (Word = 'void')or
                    (Word = 'volatile')or
                    (Word = 'while')or
                    (Word = '_cs')or
                    (Word = '_ds')or
                    (Word = '_es')or
                    (Word = '_ss')or
                    (Word = '_AH')or
                    (Word = '_AL')or
                    (Word = '_AX')or
                    (Word = '_BH')or
                    (Word = '_BL')or
                    (Word = '_BP')or
                    (Word = '_BX')or
                    (Word = '_CH')or
                    (Word = '_CL')or
                    (Word = '_CX')or
                    (Word = '_DH')or
                    (Word = '_DI')or
                    (Word = '_DL')or
                    (Word = '_DX')or
                    (Word = '_SI')or
                    (Word = '_SP');
End;

Function IsReservedWordEuphoria(Word:String):Boolean;
Begin
 IsReservedWordEuphoria :=
  (Word = 'AND')or
  (Word = 'BY')or
  (Word = 'CONSTANT')or
  (Word = 'DO')or
  (Word = 'DOWNTO')or
  (Word = 'END')or
  (Word = 'ELSE')or
  (Word = 'ELSIF')or
  (Word = 'EXIT')or
  (Word = 'FOR')or
  (Word = 'FUNCTION')or
  (Word = 'GLOBAL')or
  (Word = 'IF')or
  (Word = 'INCLUDE')or
  (Word = 'OR')or
  (Word = 'PROCEDURE')or
  (Word = 'RETURN')or
  (Word = 'THEN')or
  (Word = 'TO')or
  (Word = 'TYPE')or
  (Word = 'WHILE')or
  (Word = 'WITHOUT')or
  (Word = 'XOR');
End;

Function IsReservedWordPascal(Word:String):Boolean;
Begin
 IsReservedWordPascal :=
                   (Word = 'AND')or
                   (Word = 'ASSEMBLER')or
                   (Word = 'ASM')or
                   (Word = 'ARRAY')or
                   (Word = 'BEGIN')or
                   (Word = 'CASE')or
                   (Word = 'CONST')or
                   (Word = 'CONSTRUCTOR')or
                   (Word = 'DESTRUCTOR')or
                   (Word = 'DIV')or
                   (Word = 'DO')or
                   (Word = 'DOWNTO')or
                   (Word = 'ELSE')or
                   (Word = 'END')or
                   (Word = 'EXPORTS')or
                   (Word = 'FILE')or
                   (Word = 'FOR')or
                   (Word = 'FUNCTION')or
                   (Word = 'GOTO')or
                   (Word = 'IF')or
                   (Word = 'IMPLEMENTATION')or
                   (Word = 'IN')or
                   (Word = 'INHERITED')or
                   (Word = 'INLINE')or
                   (Word = 'INTERFACE')or
                   (Word = 'LABEL')or
                   (Word = 'LIBRARY')or
                   (Word = 'MOD')or
                   (Word = 'NIL')or
                   (Word = 'NOT')or
                   (Word = 'OBJECT')or
                   (Word = 'OF')or
                   (Word = 'OR')or
                   (Word = 'PACKED')or
                   (Word = 'PROCEDURE')or
                   (Word = 'PROGRAM')or
                   (Word = 'RECORD')or
                   (Word = 'REPEAT')or
                   (Word = 'SET')or
                   (Word = 'SHL')or
                   (Word = 'SHR')or
                   (Word = 'STRING')or
                   (Word = 'THEN')or
                   (Word = 'TO')or
                   (Word = 'TYPE')or
                   (Word = 'UNIT')or
                   (Word = 'UNTIL')or
                   (Word = 'USES')or
                   (Word = 'VAR')or
                   (Word = 'VIRTUEL')or
                   (Word = 'WHILE')or
                   (Word = 'WITH')or
                   (Word = 'XOR');
End;

Function KeyCode2MGPConst(Code:Word):String;
Const StrFunc : Array[0..9] of String[3] =
                (
                 'F1','F2','F3','F4','F5','F6','F7','F8','F9','F10'
                );
Begin
 Case Code of
  kbShiftF1..kbShiftF10 : KeyCode2MGPConst := 'kbShift' + StrFunc[Hi(Code)-Hi(kbShiftF1)];
    kbCtrlF1..kbCtrlF10 : KeyCode2MGPConst := 'kbCtrl' + StrFunc[Hi(Code)-Hi(kbCtrlF1)];
      kbAltF1..kbAltF10 : KeyCode2MGPConst := 'kbAlt' + StrFunc[Hi(Code)-Hi(kbAltF1)];
         kbAlt1..kbAlt9 : KeyCode2MGPConst := 'kbAlt' + Char(Byte('1')+(Hi(Code) - Hi(kbAlt1)));
                 kbAlt0 : KeyCode2MGPConst := 'kbAlt0';
                  kbEsc : KeyCode2MGPConst := 'kbEsc';
             kbAltSpace : KeyCode2MGPConst := 'kbAltSpace';
              kbCtrlIns : KeyCode2MGPConst := 'kbCtrlIns';
             kbShiftIns : KeyCode2MGPConst := 'kbShiftIns';
              kbCtrlDel : KeyCode2MGPConst := 'kbCtrlDel';
             kbShiftDel : KeyCode2MGPConst := 'kbShiftDel';
                 kbBack : KeyCode2MGPConst := 'kbBack';
              kbAltBkSp : KeyCode2MGPConst := 'kbAltBkSp';
             kbCtrlBack : KeyCode2MGPConst := 'kbCtrlBack';
             kbShiftTab : KeyCode2MGPConst := 'kbShiftTab';
                  kbTab : KeyCode2MGPConst := 'kbTab';
            kbCtrlEnter : KeyCode2MGPConst := 'kbCtrlEnter';
                kbEnter : KeyCode2MGPConst := 'kbEnter';
            kbF1..kbF10 : KeyCode2MGPConst := 'kb'+StrFunc[Hi(Code)-Hi(kbF1)];
                 kbHome : KeyCode2MGPConst := 'kbHome';
                   kbUp : KeyCode2MGPConst := 'kbUp';
                 kbPgUp : KeyCode2MGPConst := 'kbPgUp';
                 kbLeft : KeyCode2MGPConst := 'kbLeft';
                kbRight : KeyCode2MGPConst := 'kbRight';
                  kbEnd : KeyCode2MGPConst := 'kbEnd';
                 kbDown : KeyCode2MGPConst := 'kbDown';
                 kbPgDn : KeyCode2MGPConst := 'kbPgDn';
                  kbIns : KeyCode2MGPConst := 'kbIns';
                  kbDel : KeyCode2MGPConst := 'kbDel';
            kbCtrlPrtSc : KeyCode2MGPConst := 'kbCtrlPrtSc';
             kbCtrlLeft : KeyCode2MGPConst := 'kbCtrlLeft';
            kbCtrlRight : KeyCode2MGPConst := 'kbCtrlRight';
              kbCtrlEnd : KeyCode2MGPConst := 'kbCtrlEnd';
             kbCtrlPgDn : KeyCode2MGPConst := 'kbCtrlPgDn';
             kbCtrlHome : KeyCode2MGPConst := 'kbCtrlHome';
             kbAltEqual : KeyCode2MGPConst := 'kbAltEqual';
             kbCtrlPgUp : KeyCode2MGPConst := 'kbCtrlPgUp';
                  kbF11 : KeyCode2MGPConst := 'kbF11';
                  kbF12 : KeyCode2MGPConst := 'kbF12';
             kbShiftF11 : KeyCode2MGPConst := 'kbShiftF11';
             kbShiftF12 : KeyCode2MGPConst := 'kbShiftF12';
              kbCtrlF11 : KeyCode2MGPConst := 'kbCtrlF11';
              kbCtrlF12 : KeyCode2MGPConst := 'kbCtrlF12';
               kbAltF11 : KeyCode2MGPConst := 'kbAltF11';
               kbAltF12 : KeyCode2MGPConst := 'kbAltF12';
               kbCtrlUp : KeyCode2MGPConst := 'kbCtrlUp';
             kbCtrlDown : KeyCode2MGPConst := 'kbCtrlDown';
                 kbAltA : KeyCode2MGPConst := 'kbAltA';
                 kbAltB : KeyCode2MGPConst := 'kbAltB';
                 kbAltC : KeyCode2MGPConst := 'kbAltC';
                 kbAltD : KeyCode2MGPConst := 'kbAltD';
                 kbAltE : KeyCode2MGPConst := 'kbAltE';
                 kbAltF : KeyCode2MGPConst := 'kbAltF';
                 kbAltG : KeyCode2MGPConst := 'kbAltG';
                 kbAltH : KeyCode2MGPConst := 'kbAltH';
                 kbAltI : KeyCode2MGPConst := 'kbAltI';
                 kbAltJ : KeyCode2MGPConst := 'kbAltJ';
                 kbAltK : KeyCode2MGPConst := 'kbAltK';
                 kbAltL : KeyCode2MGPConst := 'kbAltL';
                 kbAltM : KeyCode2MGPConst := 'kbAltM';
                 kbAltN : KeyCode2MGPConst := 'kbAltN';
                 kbAltO : KeyCode2MGPConst := 'kbAltO';
                 kbAltP : KeyCode2MGPConst := 'kbAltP';
                 kbAltQ : KeyCode2MGPConst := 'kbAltQ';
                 kbAltR : KeyCode2MGPConst := 'kbAltR';
                 kbAltS : KeyCode2MGPConst := 'kbAltS';
                 kbAltT : KeyCode2MGPConst := 'kbAltT';
                 kbAltU : KeyCode2MGPConst := 'kbAltU';
                 kbAltV : KeyCode2MGPConst := 'kbAltV';
                 kbAltW : KeyCode2MGPConst := 'kbAltW';
                 kbAltX : KeyCode2MGPConst := 'kbAltX';
                 kbAltY : KeyCode2MGPConst := 'kbAltY';
                 kbAltZ : KeyCode2MGPConst := 'kbAltZ';
                     Else KeyCode2MGPConst := Str(Code);
 End;
End;

Function StrRC2MGP(Str:String;Var K:Word):String;
Var PStr,UStr : String;
    I         : Byte;
    StrLen    : Byte Absolute Str;

 Function UCmp(Msg:String):Boolean;
 Var MsgLen : Byte Absolute Msg;
 Begin
  UCmp := False;
  If Not(K = $FFFF)Then Exit;
  If(Copy(UStr,I,MsgLen) = Msg)Then
  Begin
   Inc(I,MsgLen);
   UCmp := True;
  End;
 End;

Begin
 PStr := '';
 K    := 0;
 I    := 1;
 While (I <= StrLen) do
 Begin
  If(Str[I] = #7)Then
  Begin
   If((I + 1) <= StrLen)Then
   Begin
    K := $FFFF;
    Inc(I);
    UStr := StrUp(Str);
    If(UCmp('^A'))Then K := kbCtrlA;
    If(UCmp('^B'))Then K := kbCtrlB;
    If(UCmp('^C'))Then K := kbCtrlC;
    If(UCmp('^D'))Then K := kbCtrlD;
    If(UCmp('^E'))Then K := kbCtrlE;
    If(UCmp('^F'))Then K := kbCtrlF;
    If(UCmp('^G'))Then K := kbCtrlG;
    If(UCmp('^H'))Then K := kbCtrlH;
    If(UCmp('^I'))Then K := kbCtrlI;
    If(UCmp('^J'))Then K := kbCtrlJ;
    If(UCmp('^K'))Then K := kbCtrlK;
    If(UCmp('^L'))Then K := kbCtrlL;
    If(UCmp('^M'))Then K := kbCtrlM;
    If(UCmp('^N'))Then K := kbCtrlN;
    If(UCmp('^O'))Then K := kbCtrlO;
    If(UCmp('^P'))Then K := kbCtrlP;
    If(UCmp('^Q'))Then K := kbCtrlQ;
    If(UCmp('^R'))Then K := kbCtrlR;
    If(UCmp('^S'))Then K := kbCtrlS;
    If(UCmp('^T'))Then K := kbCtrlT;
    If(UCmp('^U'))Then K := kbCtrlU;
    If(UCmp('^V'))Then K := kbCtrlV;
    If(UCmp('^W'))Then K := kbCtrlW;
    If(UCmp('^X'))Then K := kbCtrlX;
    If(UCmp('^Y'))Then K := kbCtrlY;
    If(UCmp('^Z'))Then K := kbCtrlZ;
    If(UCmp('ALT+0'))Then K := kbAlt0;
    If(UCmp('ALT-0'))Then K := kbAlt0;
    If(UCmp('ALT+1'))Then K := kbAlt1;
    If(UCmp('ALT-1'))Then K := kbAlt1;
    If(UCmp('ALT+2'))Then K := kbAlt2;
    If(UCmp('ALT-2'))Then K := kbAlt2;
    If(UCmp('ALT+3'))Then K := kbAlt3;
    If(UCmp('ALT-3'))Then K := kbAlt3;
    If(UCmp('ALT+4'))Then K := kbAlt4;
    If(UCmp('ALT-4'))Then K := kbAlt4;
    If(UCmp('ALT+5'))Then K := kbAlt5;
    If(UCmp('ALT-5'))Then K := kbAlt5;
    If(UCmp('ALT+6'))Then K := kbAlt6;
    If(UCmp('ALT-6'))Then K := kbAlt6;
    If(UCmp('ALT+7'))Then K := kbAlt7;
    If(UCmp('ALT-7'))Then K := kbAlt7;
    If(UCmp('ALT+8'))Then K := kbAlt8;
    If(UCmp('ALT-8'))Then K := kbAlt8;
    If(UCmp('ALT+9'))Then K := kbAlt9;
    If(UCmp('ALT-9'))Then K := kbAlt9;
    If(UCmp('ALT+A'))Then K := kbAltA;
    If(UCmp('ALT-A'))Then K := kbAltA;
    If(UCmp('ALT+BKSP'))Then K := kbAltBKSP;
    If(UCmp('ALT-BKSP'))Then K := kbAltBKSP;
    If(UCmp('ALT+B'))Then K := kbAltB;
    If(UCmp('ALT-B'))Then K := kbAltB;
    If(UCmp('ALT+C'))Then K := kbAltC;
    If(UCmp('ALT-C'))Then K := kbAltC;
    If(UCmp('ALT+D'))Then K := kbAltD;
    If(UCmp('ALT-D'))Then K := kbAltD;
    If(UCmp('ALT+EQUAL'))Then K := kbAltEqual;
    If(UCmp('ALT-EQUAL'))Then K := kbAltEqual;
    If(UCmp('ALT+E'))Then K := kbAltE;
    If(UCmp('ALT-E'))Then K := kbAltE;
    If(UCmp('ALT+F1'))Then K := kbAltF1;
    If(UCmp('ALT-F1'))Then K := kbAltF1;
    If(UCmp('ALT+F2'))Then K := kbAltF2;
    If(UCmp('ALT-F2'))Then K := kbAltF2;
    If(UCmp('ALT+F3'))Then K := kbAltF3;
    If(UCmp('ALT-F3'))Then K := kbAltF3;
    If(UCmp('ALT+F4'))Then K := kbAltF4;
    If(UCmp('ALT-F4'))Then K := kbAltF4;
    If(UCmp('ALT+F5'))Then K := kbAltF5;
    If(UCmp('ALT-F5'))Then K := kbAltF5;
    If(UCmp('ALT+F6'))Then K := kbAltF6;
    If(UCmp('ALT-F6'))Then K := kbAltF6;
    If(UCmp('ALT+F7'))Then K := kbAltF7;
    If(UCmp('ALT-F7'))Then K := kbAltF7;
    If(UCmp('ALT+F8'))Then K := kbAltF8;
    If(UCmp('ALT-F8'))Then K := kbAltF8;
    If(UCmp('ALT+F9'))Then K := kbAltF9;
    If(UCmp('ALT-F9'))Then K := kbAltF9;
    If(UCmp('ALT+F10'))Then K := kbAltF10;
    If(UCmp('ALT-F10'))Then K := kbAltF10;
    If(UCmp('ALT+F11'))Then K := kbAltF11;
    If(UCmp('ALT-F11'))Then K := kbAltF11;
    If(UCmp('ALT+F12'))Then K := kbAltF12;
    If(UCmp('ALT-F12'))Then K := kbAltF12;
    If(UCmp('ALT+F'))Then K := kbAltF;
    If(UCmp('ALT-F'))Then K := kbAltF;
    If(UCmp('ALT+G'))Then K := kbAltG;
    If(UCmp('ALT-G'))Then K := kbAltG;
    If(UCmp('ALT+H'))Then K := kbAltH;
    If(UCmp('ALT-H'))Then K := kbAltH;
    If(UCmp('ALT+I'))Then K := kbAltI;
    If(UCmp('ALT-I'))Then K := kbAltI;
    If(UCmp('ALT+J'))Then K := kbAltJ;
    If(UCmp('ALT-J'))Then K := kbAltJ;
    If(UCmp('ALT+K'))Then K := kbAltK;
    If(UCmp('ALT-K'))Then K := kbAltK;
    If(UCmp('ALT+L'))Then K := kbAltL;
    If(UCmp('ALT-L'))Then K := kbAltL;
    If(UCmp('ALT+M'))Then K := kbAltM;
    If(UCmp('ALT-M'))Then K := kbAltM;
    If(UCmp('ALT+N'))Then K := kbAltN;
    If(UCmp('ALT-N'))Then K := kbAltN;
    If(UCmp('ALT+O'))Then K := kbAltO;
    If(UCmp('ALT-O'))Then K := kbAltO;
    If(UCmp('ALT+P'))Then K := kbAltP;
    If(UCmp('ALT-P'))Then K := kbAltP;
    If(UCmp('ALT+Q'))Then K := kbAltQ;
    If(UCmp('ALT-Q'))Then K := kbAltQ;
    If(UCmp('ALT+R'))Then K := kbAltR;
    If(UCmp('ALT-R'))Then K := kbAltR;
    If(UCmp('ALT+SPACE'))Then K := kbAltSpace;
    If(UCmp('ALT-SPACE'))Then K := kbAltSpace;
    If(UCmp('ALT+SP'))Then K := kbAltSpace;
    If(UCmp('ALT-SP'))Then K := kbAltSpace;
    If(UCmp('ALT+S'))Then K := kbAltS;
    If(UCmp('ALT-S'))Then K := kbAltS;
    If(UCmp('ALT+T'))Then K := kbAltT;
    If(UCmp('ALT-T'))Then K := kbAltT;
    If(UCmp('ALT+U'))Then K := kbAltU;
    If(UCmp('ALT-U'))Then K := kbAltU;
    If(UCmp('ALT+V'))Then K := kbAltV;
    If(UCmp('ALT-V'))Then K := kbAltV;
    If(UCmp('ALT+W'))Then K := kbAltW;
    If(UCmp('ALT-W'))Then K := kbAltW;
    If(UCmp('ALT+X'))Then K := kbAltX;
    If(UCmp('ALT-X'))Then K := kbAltX;
    If(UCmp('ALT+Y'))Then K := kbAltY;
    If(UCmp('ALT-Y'))Then K := kbAltY;
    If(UCmp('ALT+Z'))Then K := kbAltZ;
    If(UCmp('ALT-Z'))Then K := kbAltZ;
    If(UCmp('BACKSPACE'))Then K := kbBack;
    If(UCmp('BACK'))Then K := kbBack;
    If(UCmp('BS'))Then K := kbBack;
    If(UCmp('CTRL+A'))Then K := kbCtrlA;
    If(UCmp('CTRL-A'))Then K := kbCtrlA;
    If(UCmp('CTRL+BACKSPACE'))Then K := kbCtrlBack;
    If(UCmp('CTRL-BACKSPACE'))Then K := kbCtrlBack;
    If(UCmp('CTRL+BACK'))Then K := kbCtrlBack;
    If(UCmp('CTRL-BACK'))Then K := kbCtrlBack;
    If(UCmp('CTRL+BS'))Then K := kbCtrlBack;
    If(UCmp('CTRL-BS'))Then K := kbCtrlBack;
    If(UCmp('CTRL+B'))Then K := kbCtrlB;
    If(UCmp('CTRL-B'))Then K := kbCtrlB;
    If(UCmp('CTRL+C'))Then K := kbCtrlC;
    If(UCmp('CTRL-C'))Then K := kbCtrlC;
    If(UCmp('CTRL+DELETE'))Then K := kbCtrlDel;
    If(UCmp('CTRL-DELETE'))Then K := kbCtrlDel;
    If(UCmp('CTRL+DEL'))Then K := kbCtrlDel;
    If(UCmp('CTRL+DN'))Then K := kbCtrlDown;
    If(UCmp('CTRL-DN'))Then K := kbCtrlDown;
    If(UCmp('CTRL+DOWN'))Then K := kbCtrlDown;
    If(UCmp('CTRL-DOWN'))Then K := kbCtrlDown;
    If(UCmp('CTRL+D'))Then K := kbCtrlD;
    If(UCmp('CTRL-D'))Then K := kbCtrlD;
    If(UCmp('CTRL+END'))Then K := kbCtrlEnd;
    If(UCmp('CTRL-END'))Then K := kbCtrlEnd;
    If(UCmp('CTRL+ENTER'))Then K := kbCtrlEnter;
    If(UCmp('CTRL-ENTER'))Then K := kbCtrlEnter;
    If(UCmp('CTRL+ENT'))Then K := kbCtrlEnter;
    If(UCmp('CTRL-ENT'))Then K := kbCtrlEnter;
    If(UCmp('CTRL+E'))Then K := kbCtrlE;
    If(UCmp('CTRL-E'))Then K := kbCtrlE;
    If(UCmp('CTRL+F1'))Then K := kbCtrlF1;
    If(UCmp('CTRL-F1'))Then K := kbCtrlF1;
    If(UCmp('CTRL+F2'))Then K := kbCtrlF2;
    If(UCmp('CTRL-F2'))Then K := kbCtrlF2;
    If(UCmp('CTRL+F3'))Then K := kbCtrlF3;
    If(UCmp('CTRL-F3'))Then K := kbCtrlF3;
    If(UCmp('CTRL+F4'))Then K := kbCtrlF4;
    If(UCmp('CTRL-F4'))Then K := kbCtrlF4;
    If(UCmp('CTRL+F5'))Then K := kbCtrlF5;
    If(UCmp('CTRL-F5'))Then K := kbCtrlF5;
    If(UCmp('CTRL+F6'))Then K := kbCtrlF6;
    If(UCmp('CTRL-F6'))Then K := kbCtrlF6;
    If(UCmp('CTRL+F7'))Then K := kbCtrlF7;
    If(UCmp('CTRL-F7'))Then K := kbCtrlF7;
    If(UCmp('CTRL+F8'))Then K := kbCtrlF8;
    If(UCmp('CTRL-F8'))Then K := kbCtrlF8;
    If(UCmp('CTRL+F9'))Then K := kbCtrlF9;
    If(UCmp('CTRL-F9'))Then K := kbCtrlF9;
    If(UCmp('CTRL+F10'))Then K := kbCtrlF10;
    If(UCmp('CTRL-F10'))Then K := kbCtrlF10;
    If(UCmp('CTRL+F11'))Then K := kbCtrlF11;
    If(UCmp('CTRL-F11'))Then K := kbCtrlF11;
    If(UCmp('CTRL+F12'))Then K := kbCtrlF12;
    If(UCmp('CTRL-F12'))Then K := kbCtrlF12;
    If(UCmp('CTRL+F'))Then K := kbCtrlF;
    If(UCmp('CTRL-F'))Then K := kbCtrlF;
    If(UCmp('CTRL+G'))Then K := kbCtrlG;
    If(UCmp('CTRL-G'))Then K := kbCtrlG;
    If(UCmp('CTRL+HOME'))Then K := kbCtrlH;
    If(UCmp('CTRL-HOME'))Then K := kbCtrlH;
    If(UCmp('CTRL+H'))Then K := kbCtrlH;
    If(UCmp('CTRL-H'))Then K := kbCtrlH;
    If(UCmp('CTRL+INSERT'))Then K := kbCtrlIns;
    If(UCmp('CTRL-INSERT'))Then K := kbCtrlIns;
    If(UCmp('CTRL+INS'))Then K := kbCtrlIns;
    If(UCmp('CTRL-INS'))Then K := kbCtrlIns;
    If(UCmp('CTRL+I'))Then K := kbCtrlI;
    If(UCmp('CTRL-I'))Then K := kbCtrlI;
    If(UCmp('CTRL+J'))Then K := kbCtrlJ;
    If(UCmp('CTRL-J'))Then K := kbCtrlJ;
    If(UCmp('CTRL+K'))Then K := kbCtrlK;
    If(UCmp('CTRL-K'))Then K := kbCtrlK;
    If(UCmp('CTRL+LEFT'))Then K := kbCtrlLeft;
    If(UCmp('CTRL-LEFT'))Then K := kbCtrlLeft;
    If(UCmp('CTRL+L'))Then K := kbCtrlL;
    If(UCmp('CTRL-L'))Then K := kbCtrlL;
    If(UCmp('CTRL+M'))Then K := kbCtrlM;
    If(UCmp('CTRL-M'))Then K := kbCtrlM;
    If(UCmp('CTRL+N'))Then K := kbCtrlN;
    If(UCmp('CTRL-N'))Then K := kbCtrlN;
    If(UCmp('CTRL+O'))Then K := kbCtrlO;
    If(UCmp('CTRL-O'))Then K := kbCtrlO;
    If(UCmp('CTRL+PAGE DOWN'))Then K := kbCtrlPgDn;
    If(UCmp('CTRL-PAGE DOWN'))Then K := kbCtrlPgDn;
    If(UCmp('CTRL+PAGE UP'))Then K := kbCtrlPgUp;
    If(UCmp('CTRL-PAGE UP'))Then K := kbCtrlPgUp;
    If(UCmp('CTRL+PAGEDOWN'))Then K := kbCtrlPgDn;
    If(UCmp('CTRL-PAGEDOWN'))Then K := kbCtrlPgDn;
    If(UCmp('CTRL+PAGEUP'))Then K := kbCtrlPgDn;
    If(UCmp('CTRL-PAGEUP'))Then K := kbCtrlPgDn;
    If(UCmp('CTRL+PGDN'))Then K := kbCtrlPgDn;
    If(UCmp('CTRL-PGDN'))Then K := kbCtrlPgDn;
    If(UCmp('CTRL+PGUP'))Then K := kbCtrlPgDn;
    If(UCmp('CTRL-PGUP'))Then K := kbCtrlPgDn;
    If(UCmp('CTRL+PRINTSCREEN'))Then K := kbCtrlPrtSc;
    If(UCmp('CTRL-PRINTSCREEN'))Then K := kbCtrlPrtSc;
    If(UCmp('CTRL+PRTSC'))Then K := kbCtrlPrtSc;
    If(UCmp('CTRL-PRTSC'))Then K := kbCtrlPrtSc;
    If(UCmp('CTRL+P'))Then K := kbCtrlP;
    If(UCmp('CTRL-P'))Then K := kbCtrlP;
    If(UCmp('CTRL+Q'))Then K := kbCtrlQ;
    If(UCmp('CTRL-Q'))Then K := kbCtrlQ;
    If(UCmp('CTRL+RIGHT'))Then K := kbCtrlRight;
    If(UCmp('CTRL-RIGHT'))Then K := kbCtrlRight;
    If(UCmp('CTRL+R'))Then K := kbCtrlR;
    If(UCmp('CTRL-R'))Then K := kbCtrlR;
    If(UCmp('CTRL+S'))Then K := kbCtrlS;
    If(UCmp('CTRL-S'))Then K := kbCtrlS;
    If(UCmp('CTRL+T'))Then K := kbCtrlT;
    If(UCmp('CTRL-T'))Then K := kbCtrlT;
    If(UCmp('CTRL+UP'))Then K := kbCtrlUp;
    If(UCmp('CTRL-UP'))Then K := kbCtrlUp;
    If(UCmp('CTRL+U'))Then K := kbCtrlU;
    If(UCmp('CTRL-U'))Then K := kbCtrlU;
    If(UCmp('CTRL+V'))Then K := kbCtrlV;
    If(UCmp('CTRL-V'))Then K := kbCtrlV;
    If(UCmp('CTRL+W'))Then K := kbCtrlW;
    If(UCmp('CTRL-W'))Then K := kbCtrlW;
    If(UCmp('CTRL+X'))Then K := kbCtrlX;
    If(UCmp('CTRL-X'))Then K := kbCtrlX;
    If(UCmp('CTRL+Y'))Then K := kbCtrlY;
    If(UCmp('CTRL-Y'))Then K := kbCtrlY;
    If(UCmp('CTRL+Z'))Then K := kbCtrlZ;
    If(UCmp('CTRL-Z'))Then K := kbCtrlZ;
    If(UCmp('DEL'))Then K := kbDel;
    If(UCmp('DOWN'))Then K := kbDown;
    If(UCmp('END'))Then K := kbEnd;
    If(UCmp('ENTER'))Then K := kbEnter;
    If(UCmp('ESCAPE'))Then K := kbEsc;
    If(UCmp('ESC'))Then K := kbEsc;
    If(UCmp('F1'))Then K := kbF1;
    If(UCmp('F2'))Then K := kbF2;
    If(UCmp('F3'))Then K := kbF3;
    If(UCmp('F4'))Then K := kbF4;
    If(UCmp('F5'))Then K := kbF5;
    If(UCmp('F6'))Then K := kbF6;
    If(UCmp('F7'))Then K := kbF7;
    If(UCmp('F8'))Then K := kbF8;
    If(UCmp('F9'))Then K := kbF9;
    If(UCmp('F10'))Then K := kbF10;
    If(UCmp('F11'))Then K := kbF11;
    If(UCmp('F12'))Then K := kbF12;
    If(UCmp('HOME'))Then K := kbHome;
    If(UCmp('INSERT'))Then K := kbIns;
    If(UCmp('INS'))Then K := kbIns;
    If(UCmp('LEFT'))Then K := kbLeft;
    If(UCmp('PAGE DOWN'))Then K := kbPgDn;
    If(UCmp('PAGE UP'))Then K := kbPgUp;
    If(UCmp('PAGEDOWN'))Then K := kbPgDn;
    If(UCmp('PAGEUP'))Then K := kbPgUp;
    If(UCmp('PGDN'))Then K := kbPgDn;
    If(UCmp('PGUP'))Then K := kbPgUp;
    If(UCmp('RIGHT'))Then K := kbRight;
    If(UCmp('SHIFT+DELETE'))Then K := kbShiftDel;
    If(UCmp('SHIFT-DELETE'))Then K := kbShiftDel;
    If(UCmp('SHIFT+DEL'))Then K := kbShiftDel;
    If(UCmp('SHIFT-DEL'))Then K := kbShiftDel;
    If(UCmp('SHIFT+F1'))Then K := kbF1;
    If(UCmp('SHIFT-F1'))Then K := kbF1;
    If(UCmp('SHIFT+F2'))Then K := kbF2;
    If(UCmp('SHIFT-F2'))Then K := kbF2;
    If(UCmp('SHIFT+F3'))Then K := kbF3;
    If(UCmp('SHIFT-F3'))Then K := kbF3;
    If(UCmp('SHIFT+F4'))Then K := kbF4;
    If(UCmp('SHIFT-F4'))Then K := kbF4;
    If(UCmp('SHIFT+F5'))Then K := kbF5;
    If(UCmp('SHIFT-F5'))Then K := kbF5;
    If(UCmp('SHIFT+F6'))Then K := kbF6;
    If(UCmp('SHIFT-F6'))Then K := kbF6;
    If(UCmp('SHIFT+F7'))Then K := kbF7;
    If(UCmp('SHIFT-F7'))Then K := kbF7;
    If(UCmp('SHIFT+F8'))Then K := kbF8;
    If(UCmp('SHIFT-F8'))Then K := kbF8;
    If(UCmp('SHIFT+F9'))Then K := kbF9;
    If(UCmp('SHIFT-F9'))Then K := kbF9;
    If(UCmp('SHIFT+F10'))Then K := kbF10;
    If(UCmp('SHIFT-F10'))Then K := kbF10;
    If(UCmp('SHIFT+F11'))Then K := kbF11;
    If(UCmp('SHIFT-F11'))Then K := kbF11;
    If(UCmp('SHIFT+F12'))Then K := kbF12;
    If(UCmp('SHIFT-F12'))Then K := kbF12;
    If(UCmp('SHIFT+INS'))Then K := kbShiftIns;
    If(UCmp('SHIFT+TAB'))Then K := kbShiftTab;
    If(UCmp('TABULATION'))Then K := kbTab;
    If(UCmp('TAB'))Then K := kbTab;
   End;
  End
   Else
  If(Str[I] = '&')Then
  Begin
   If((I + 1) <= StrLen)Then
   Begin
    Inc(I);
    AddStr(PStr,'^' + Str[I] + '^');
   End;
  End
   Else
  IncStr(PStr,Str[I]);
  Inc(I);
 End;
 StrRC2MGP := PStr;
End;

BEGIN
END.