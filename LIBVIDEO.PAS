(********************************************************)
(*                                                      *)
(*               Malte Genesis/Library Video            *)
(*    Phoenix Edition for Real Mode & Protected Mode    *)
(*                   II - Version 1.8                   *)
(*                      1994/12/29                      *)
(*                                                      *)
(*      Copyiright (C) par les Chevaliers de Malte      *)
(*                                                      *)
(********************************************************)

Unit LibVideo;

INTERFACE

Uses Math,Systems;

Const

      vdUnknown = 0;  { Auto-Detect }
      vdAhead = 1;  { Ahead }
      vdAheadB = 2;  { Ahead B (Super VGA) }
      vdAheadBWizard3270 = 3;  { Ahead B - Wizard/3270 (Super VGA) }
      vdAheadEGA2001 = 4;  { Ahead EGA2001 (Super EGA) }
      vdAllstarPeacock = 5;  { Allstar Peacock (VGA) }
      vdASTVGAPlus = 6;  { AST VGA Plus (Super VGA) }
      vdATT = 7;  { AT&T }
      vdATT6300 = 8;  { AT&T 6300 (Super EGA) }
      vdATTVDC600 = 9;  { AT&T VDC600 (Super VGA) }
      vdCardinal = 10; { Cardinal (Super VGA) }
      vdCGA = 11; { CGA }
      vdCirrus = 12; { Cirrus (Super VGA) }
      vdCompaqPortable = 13;
      vdCompaqVGA = 14; { Compaq VGA (Super VGA) }
      vdCTI82C451 = 15; { CTI 82C451 (Super VGA) }
      vdCTI82C452 = 16; { CTI 82C452 (Super VGA) }
      vdDellVGA = 17; { Dell VGA (Super VGA) }
      vdEGA = 18; { EGA }
      vdEGAWonder800 = 19; { EGA Wonder 800+ (Super EGA) }
      vdEGAWonder800_18800 = 20; { EGA Wonder 800+ - 18800 (Super EGA) }
      vdEGAWonder800_18800_1 = 21; { EGA Wonder 800+ - 18800-1 (Super EGA)}
      vdEGAWonder800_28800_2 = 22; { EGA Wonder 800+ - 28800-2 (Super EGA)}
      vdEGAWonder800_28800_4 = 23; { EGA Wonder 800+ - 28800-4 (Super EGA)}
      vdEGAWonder800_28800_5 = 24; { EGA Wonder 800+ - 28800-5 (Super EGA)}
      vdEverex = 25; { Everex }
      vdEverexViewPoint = 26; { Everex ViewPoint }
      vdEverexUltraGraphicsII = 27; { Everex UltraGraphics II }
      vdEverexVision = 28; { Everex Vision }
      vdEverexEVGA = 29; { Everex EVGA }
      vdGenoa = 30; { Genoa }
      vdGenoa5100 = 31; { Genoa 5100 }
      vdGenoa5300 = 32; { Genoa 5300 }
      vdGenoa6100 = 33; { Genoa 6100 }
      vdGenoa6200 = 34; { Genoa 6200 }
      vdGenoa6400 = 35; { Genoa 6400 (Super VGA) }
      vdGraphicsSolution = 36; { Graphics Solution d'ATI (Super CGA) }
      vdGraphicsUltra = 37; { Graphics Ultra d'ATI (Super VGA) }
      vdGraphicsUltraPlus = 38; { Graphics Ultra d'ATI (Super VGA) }
      vdGraphicsUltraPro = 39; { Graphics Ultra d'ATI (Super VGA) }
      vdGS = vdGraphicsSolution;
      vdHeadLand = 40; { HeadLand (Super VGA) }
      vdHercule = 41; { Hercule (HGC) }
      vdHewlettPackardD1180A = 42; { Hewlett-Packard D1180A (Super VGA) }
      vdHP95LX = 43; { HP 95LX }
      vdIBM8514A = 44; { IBM 8514/A }
      vdImtec = 45; { Imtec (Super VGA) }
      vdITVGA2 = 46; { IT-VGA2 (Super VGA) }
      vdLavaChromeIIEGA = 47; { Lava Chrome II EGA (Super EGA) }
      vdLogix = 48; { Logix (Super VGA) }
      vdMCGA = 49; { MCGA }
      vdMDA = 50; { MDA }
      vdMaxxon = 51; { Maxxon }
      vdMorseVGA = 52; { Morse VGA (VGA) }
      vdNSISmartEGA = 53; { NSI Smart EGA+ (Super EGA) }
      vdOak = 54; { Oak Technologies (Super VGA) }
      vdOrchid = 55; { Orchid }
      vdOrchidProDesignerVGA = 56; { Orchid Prodesigner VGA (Super VGA) }
      vdOrchidProDesignerIIVGA = 57; { (Super VGA/32768 couleurs)           }
      vdParadise = 58; { Paradise }
      vdParadiseEGA480 = 59; { Paradise EGA-480, Super EGA }
      vdParadisePVGA1A = 60; { Paradise PVGA1A }
      vdParadiseWD90C00 = 61; { Paradise WD90C00 }
      vdParadiseWD90C10 = 62; { Paradise WD90C10 }
      vdParadiseWD90C11 = 63; { Paradise WD90C11 }
      vdPC3270 = 64; { PC 3270 }
      vdPC3270G = 65; { PC 3270G }
      vdPC3270GX = 66; { PC 3270GX }
      vdPCJr = 67; { PC Junior }
      vdPGA = 68; { PGA }
      vdPrismElite = 69; { Prism Elite d'ATI (Super VGA) }
      vdQuadramUltra = 70; { Quadram Ultra VGA (Super VGA) }
      vdSEFCOTVGA = 71; { SEFCO TVGA (Super VGA) }
      vdSigma = 72; { Sigma (Super VGA) }
      vdSTB = 73; { STB (Super VGA) }
      vdSTBVGAEM16Plus = 74; { STB VGA/EM-16 Plus (Super VGA) }
      vdTatungVGA = 75; { Tatung VGA (Super VGA) }
      vdTaxan565EGA = 76; { Taxan 565 EGA (Super EGA) }
      vdTecmarVGAAD = 77; { Tecmar VGA/AD (Super VGA) }
      vdTIGA = 78; { TIGA de Texas Instrument }
      vdTrident8800BR = 79; { Trident 8800BR (Super VGA) }
      vdTrident8800CS = 80; { Trident 8800CS (Super VGA) }
      vdTrident8900 = 81; { Trident 8900 (Super VGA) }
      vdTsengET3000 = 82; { Tseng ET3000 (Super VGA) }
      vdTsengET4000 = 83; { Tseng ET4000 (Super VGA) }
      vdTsengET4000HiColor = 84; { Tseng ET4000 HiColor (Super VGA) }
      vdTsengET4000HiColorSC = 85; { Tseng ET4000 HiColor SC (Super VGA) }
      vdUltraVisionEGA = 86; { Ultra Vision EGA (Super EGA) }
      vdVESA = 87; { VESA }
      vdVGA = 88; { VGA }
      vdVGAWonder = 89; { VGA Wonder d'ATI (Super VGA) }
      vdVGAWonder_18800 = 90; { VGA Wonder d'ATI 18800 (Super VGA) }
      vdVGAWonder_18800_1 = 91; { VGA Wonder d'ATI 18800-1 (Super VGA) }
      vdVGAWonder_28800_2 = 92; { VGA Wonder d'ATI 28800-2 (Super VGA) }
      vdVGAWonder_28800_4 = 93; { VGA Wonder d'ATI 28800-4 (Super VGA) }
      vdVGAWonder_28800_5 = 94; { VGA Wonder d'ATI 28800-5 (Super VGA) }
      vdVideo7 = 95; { Video 7 (Super VGA) }
      vdVideo7Vram = 96; { Video 7 Vram (Super VGA) }
      vdVideo7Vega = 97; { Video 7 Vega (Super VGA) }
      vdVideo7Version5 = 98; { Video 7 Version 5 (Super VGA) }
      vdVideo71024i = 99; { Video 7 1024i (Super VGA) }
      vdVIP = 100; { ATI VIP (Super VGA) }
      vdXGA = 101; { XGA (Super VGA) }
      vdZymos = 102; { Zymos (Super VGA) }
      vdZymosPoach = 103; { Zymos Poach (Super VGA) }

      moUnknown = 0;
      mo3295 = 1;
      mo5151 = 2;
      mo5272 = 3;
      mo5279 = 4;
      mo5379C01 = 5;
      mo5379M01 = 6;
      mo8514 = 7;
      moAnalog = 8;
      moAnalogColor = 9;
      moAnalogMonochrome = 10;
      moAnalogMultiSync = 11;
      moCGA = 12;
      moDigitalColor = 13;
      moDigitalMultiSync = 14;
      moDigitalTTL = 15;
      moEGA = 16;
      moFixedSync = 17;
      moMDA = 18;
      moMultiSync = 19;
      moMultiSync2A = 20;
      moNEC3D = 21;
      moNECMultiSync = 22;
      moRGBColor = 23;
      moSeiko1430 = 24;
      moSuperMultiSync = 25;
      moSuperVGA = 26;
      moTatungOmniScan = 27;
      moTTLDigital = 28;
      moTTLMonochrome = 29;
      moTVM2A = 30;
      moTVM3A = 31;
      moTVM3M = 32;
      moVGA = 33;

Var

    CheckSVGA : Bool;

Procedure SetCharWidth(L:Byte);

Function DirectTextSupport:Bool;
Procedure GetVideoCard(Var Info1,Info2:PhysicalInfoVideo);
Function IsGraphic:Bool;

IMPLEMENTATION

Uses Mems,RLL;

Function DirectTextSupport;
Var Ptr:Pointer;
    _DirectTextSupport:Function:Bool Absolute Ptr;
    S:Word;
Begin
 Ptr := AllocMainFunc(19,S);
 If(Ptr = NIL)Then HaltRLL;
 DirectTextSupport := _DirectTextSupport;
 FreeMem(Ptr,S);
End;

Procedure GetVideoCard;
Var Ptr:Pointer;
    _GetVideoCard:Procedure(CheckSVGA:Bool;Var Info1,Info2:PhysicalInfoVideo) Absolute Ptr;
    S:Word;
Begin
 Ptr := AllocMainFunc(0,S);
 If(Ptr = NIL)Then HaltRLL;
 _GetVideoCard(CheckSVGA,Info1,Info2);
 FreeMem(Ptr,S);
End;

Function IsGraphic;
Var Ptr:Pointer;
    _IsGraphic:Function:Bool Absolute Ptr;
    S:Word;
Begin
 Ptr := AllocMainFunc(20,S);
 If(Ptr = NIL)Then HaltRLL;
 IsGraphic := _IsGraphic;
 FreeMem(Ptr,S);
End;

Procedure SetCharWidth;
Assembler;
ASM
 MOV DX,$3CC;
 IN  AL,DX;
 AND AL,Not(4+8);
 MOV BX,$0001;
 CMP L,8;
 JE  @@EndInit;
 OR  AL,4;
 MOV BX,$0800;
@@EndInit:
 MOV DX,$3C2;
 OUT DX,AL;
 CLI;
 MOV DX,$3C4;
 MOV AX,$0100;
 OUT DX,AX;
 MOV AL,$01;
 MOV AH,BL;
 OUT DX,AX;
 MOV AX,$0300;
 OUT DX,AX;
 STI;
 MOV AX,$0100;
 MOV BL,$13;
 INT $10;
END;

BEGIN { Main Unit }
END.