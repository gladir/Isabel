{ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
 ³                                                            ³
 ³              Malte Genesis/Module des SystŠmes             ³
 ³                Edition Isabel pour Mode R‚el               ³
 ³                      III - Version 1.0                     ³
 ³                         1995/02/02                         ³
 ³                                                            ³
 ³       Copyright (C) par les Chevaliers de Malte            ³
 ³                                                            ³
 ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ}

Unit Systems;

INTERFACE

{$IFNDEF Debug}
 {$D-,L-,Y-}
{$ENDIF}
{$I-,Q-,R-,S-,X+}

Uses Dos,Math;

Const

      Dir = Directory;

      errFonctionNotFound   = 1;
      errFileNotFound       = 2;
      errPathNotFound       = 3;
      errTooManyFileOpen    = 4;
      errAccessDenied       = 5;
      errHandleNotFound     = 6;
      errMCBDestroyed       = 7;
      errOutOfMemory        = 8;
      errInvalidAddr        = 9;
      errInvalidEnv         = 10;
      errInvalidCodeAccess  = 11;
      errDataError          = 12;
      errDiskNotFound       = 15;
      errDelMainPath        = 16;
      errIncompatibleDevice = 17;
      errTooManyHandle      = 18;
      errDiskWriteProtect   = 19;
      errInvalidDevice      = 20;
      errDeviceNotReady     = 21;
      errUnknownInstruction = 22;
      errCrcError           = 23;
      errLengthDataError    = 24;
      errNotFind            = 25;
      errUnknownDevice      = 26;
      errSectorNotFound     = 27;
      errOutOfPaper         = 28;
      errWriteError         = 29;
      errReadError          = 30;
      errGeneralError       = 31;
      errChangeDisk         = 34;
      errOutOfFCB           = 35;
      errMakeDirectoryError = 80;
      errFileExist          = 82;
      errBreakInt24h        = 83;
      errMakeFileError      = 254;
      errEndOfFile          = 255;

       { Handle }

      ReadOnly          = 0;
      WriteOnly         = 1;
      Normal            = 2;

      SeekStart         = 0;
      SeekCur           = 1;
      SeekEnd           = 2;

      TimeGet           = 0;
      TimeSet           = 1;

      HandleInput       = 0;
      HandleOutput      = 1;
      HandleOutputError = 2;
      HandleAux         = 3;
      HandlePrinter     = 4;
      HandlePrn         = HandlePrinter;
      HdlInput          = HandleInput;
      HdlOutput         = HandleOutput;
      HdlOutputError    = HandleOutputError;
      HdlAux            = HandleAux;
      HdlPrinter        = HandlePrinter;
      HdlPrn            = HandlePrn;

      hdReadOnly        = ReadOnly;
      hdWriteOnly       = WriteOnly;
      hdNormal          = Normal;

      hdInput           = HandleInput;
      hdOutput          = HandleOutput;
      hdOutputError     = HandleOutputError;
      hdAux             = HandleAux;
      hdPrinter         = HandlePrinter;

      faReadOnly        = $01;
      faHidden          = $02;
      faSysFile         = $04;
      faVolumeID        = $08;
      faDirectory       = $10;
      faArchive         = $20;
      faAnyFile         = $3F;
      faAll             = $FFFF - faVolumeID;

      fcExtension       = $0001;
      fcFileName        = $0002;
      fcDirectory       = $0004;
      fcWildCard        = $0008;

      fsPathName        = 79;
      fsDirectory       = 63;
      fsFileName        = 8;
      fsExtension       = 4;
      fsLabel           = 12;

      MinPart           = 1;
      MaxPart           = 4;

      FileError : Word = 0;

Type

     TableIntRec = Array[0..255] of Pointer;

     Proc = Procedure;

     FCBRec = Record
      Num:Byte;
      Name:Array[0..7] of Char;
      Ext:Array[0..2] of Char;
      CurrBlock,SizeRec:Word;
      SizeFile,LastTime:Long;
      Reserved:Array[0..7] of Byte;
      CurrRec:Byte;
      SelectAcces:Long;
     End;

     MCBRec = Record
      ID:Char;
      PSP,Size:Word;
      Reserved:Array[0..2] of Byte;
      Name:Array[0..7] of Char;
      Header:Record Case Byte of
       0:(Prg:Word);
       1:(Data:Array[0..511] of Byte);
       2:(Comspec:Array[0..7] of Char);
      End;
     End;

     DriveParamBlock1Rec = Record
      NumFat:Byte;
      SectorFirstDir:Word;
      HeaderDriverDevice:Pointer;
      ID:Char;
      DiskAcces:Byte;
      NextDPB:Pointer
     End;

     DriveParamBlock2Rec = Record
      NumFat:Byte; SectorFirstDir:Word; HeaderDriverDevice:Pointer;
      ID:Char; DiskAcces:Byte; NextDPB:Pointer; ClusterStartCurrDir:Word;
      Path:Array[0..63] of Char;
     End;

     DriveParamBlock3Rec = Record
      NmFat:Byte; SectorFirstDir:Word; HeaderDriverDevice:Pointer;
      ID:Char; DiskAcces:Byte; NextDPB:Pointer;
      ClusterSearchFree,NmFreeCluster:Word;
     End;

     DriveParamBlock4Rec = Record
      NmFat,SectorFirstDir:Word; HeaderDriverDevice:Pointer;
      ID:Char; DiskAcces:Byte; NextDPB:Pointer;
      ClusterSearchFree,NumFreeCluster:Word;
     End;

     DriveParamBlock5Rec = DriveParamBlock4Rec;

     DriveParamBlockRec = Record
      Disk,UnitNumber:Byte; BytesPerSector:Word;
      SectorByCluster,ClusterIntoSectors:Byte;
      ReservedSector:Word;
      Ver : Record Case Byte of
       0:(Dos1:DriveParamBlock1Rec);
       1:(Dos2:DriveParamBlock2Rec);
       2:(Dos3:DriveParamBlock3Rec);
       3:(Dos4:DriveParamBlock4Rec);
       4:(Dos5:DriveParamBlock5Rec);
      End;
     End;

     SystemFileTablesRec = Record
      Next:Pointer; Nm:Word;
     End;

     ClockRec = Record
      NumOfDay1980:Word; Min,Hour,Hund,Sec:Byte;
     End;

     ChainIFSRec = Record
      SizeOf:Word; Class:Byte; DosError:Word; IFSExitCode:Byte;
      Reserved:Array[0..15] of Byte; FuncCode:Byte;
     End;

     DiskBufInfoVer5Rec = Record
      BufHeader:Pointer; OfsBufChain:Word; LookAheadBuf:Pointer;
      NumLookAheadBuf:Word; BufLocation:Byte; WorkSpaceBuf:Pointer;
     End;

     NulDeviceRec = Record
      Next:Pointer;
      Data:Array[4..9] of Byte; Name:Array[0..7] of Char;
     End;

     ExtDosBlock2Rec = Record
      NmDrive:Byte; MaxBytesBlockDevice:Word;
      FirstDiskBuffer:Pointer; NulDevice:NulDeviceRec;
     End;

     ExtDosBlock3Rec = Record
      NmBlockDevice:Byte; MaxBytesBlockInBlockDevice:Word;
      FirstDiskBuf:Pointer; CurrDir:PChar; LastDrive:Byte;
      StringArea:Pointer; FCB:^FCBRec; NmFCBS:Word; NulDevice:NulDeviceRec;
     End;

     ExtDosBlock31Rec = Record
      MaxBytesPerSectorInBlockDevice:Word; FirstDiskBuf:Pointer;
      CurrDir:PChar; FCB:^FCBRec; NmFCBS:Word; NmBlockDevice,NmDrive:Byte;
      NulDevice:NulDeviceRec; NmJoinDrives:Byte;
     End;

     ExtDosBlock4Rec = Record
      MaxBytesPerSectorInBlockDevice:Word; DiskBufInfo:Pointer;
      CurrDir:PChar; FCB:^FCBRec; NmFCBS:Word; NmBlockDevice,LastDrive:Byte;
      NulDevice:NulDeviceRec; NmJoinDrives:Byte; ListPrgNameSeg:Word;
      IFS:Proc; ChainIFS:^ChainIFSRec; NmBufs,NumSubBufs:Word;
      BootDisk:Byte; Is32BitsUpCode:Bool; XmsSizeK:Word;
     End;

     ExtDosBlock5Rec = Record
      MaxBytesPerSectorInBlockDevice:Word; DiskBufInfo:^DiskBufInfoVer5Rec;
      CurrDir:PChar; FCB:^FCBRec; NmFCBS:Word; NmBlockDevice,LastDrive:Byte;
      NulDevice:NulDeviceRec; NmJoinDrives:Byte; ListPrgNameSeg:Word;
      SetVerListPrg:Pointer; CsDosFunc,IsDosInHma,NmBufs,NmSubBufs:Word;
      BootDisk:Byte; Is32BitsUpCode:Bool; XmsSizeK:Word;
     End;

     DosBlockRec = Record
      FirstMCB:^MCBRec;
      FirstDriveParm:^DriveParamBlockRec;
      SystemFileTables:^SystemFileTablesRec;
      Clock:^ClockRec;{ $CLOCK}
      Con:^FCBRec;{ $CON}
      Ver:Record Case Byte of
       0:(Dos2:ExtDosBlock2Rec);
       1:(Dos30:ExtDosBlock3Rec);
       2:(Dos31:ExtDosBlock31Rec);
       3:(Dos4:ExtDosBlock4Rec);
       4:(Dos5:ExtDosBlock5Rec);
       End;
      End;

     DosBlockPtr = ^DosBlockRec;

     TimeType = (__12__,__24__);

     CountryRec = Record
      CO_DATE:Word; CO_CURR:Array[0..4] of Char;
      CO_THSEP,CO_DESEP,CO_DTSEP,CO_TMSEP:Array[0..1] of Char;
      CO_CURRSTYLE,CO_DIGITS:Byte; CO_TIME:TimeType; CO_CASE:Pointer;
      CO_DASEP:Array[0..1] of Char; CO_FILL:Array[0..10] of Byte;
     End;

     SecPosType = Record
      Head:Byte; SectTrack:Word;
     End;

     PartEntryType = Record
      Status:Byte; StartSec:SecPosType; PartType:Byte;
      EndSec:SecPosType; SecOfs,NumSec:Long;
     End;

     PartSecType = Record
      BootCode  : Array[0..$1BD] of Byte;
      PartTable : Array[MinPart..MaxPart] of PartEntryType;
     End;

     DBaseIIIFileHeaderRec = Record
      HeadType,Year,Month,Day:Byte; RecordCount:Long;
      HeaderLength,RecordSize:Int; Fill:Array[1..20] of Byte;
     End;

     DBaseIIIFieldRec = Record
      FieldName:Array[1..11] of Char; FieldType:Char; Spare1,Spare2:Int;
      Width,Dec:Byte; WorkSpace:Array[1..14] of Byte;
     End;

     BackgroundCopy = Procedure(Pour:Byte;Curr,Total:Long);

     Int1EhRec = Record
      TimeTrack2Track,ModeDMA,TimeUpMotor,SectorSize:Byte;
      MaxSectorInTrack,GapLen,DataLen,SpcMarge,FormatValue:Byte;
     End;

     IntHardDiskRec = Record
      MaxTrack:Word;MaxHead:Byte;ReserveA,ReserveB:Word;
      LenVerSec,Option,TimeOut,TimeOutFormat,TimeOutTest:Byte;
     End;

     VideoParamTableRec = Record
      NumXTxts,MaxYTxts,HeightChr:Byte; SizeBuf:Word;
      SequencerRegs:Array[1..4] of Byte; Miscellinous:Byte;
      CRTC:Array[0..$18] of Byte;
      AttrCtrlRegs:Array[0..$13] of Byte; GrafCtrlRegs:Array[0..8] of Byte;
     End;

     DynamicParamSaveAreaRec = Record
      PaletteEGA:Array[0..15] of Byte; OverscanReg:Byte;
     End;

     TxtNmChrSetOverrideRec = Record
      LenChrInByte,ChrGeneratorRamBank:Byte;
      NmMatrixChr,FirstChrCodeInMatrix:Word;
      FontTable:Pointer;
      MaxYTxts,NmAppVidMode:Byte;
      BufApplicableVidMode:Array[0..$FF] of Byte;
     End;

     VGARec = Record
      NmTableEntry,DccVer,MaxDispTypeCode,Reserved,VidDispPrim,VidDispSec:Byte;
     End;

     SaveOverrideRec = Record
      VidParamTable:^VideoParamTableRec;
      DynamicParamSaveArea:^DynamicParamSaveAreaRec;
      TxtNmChrSetOverride:^TxtNmChrSetOverrideRec;
      GrafNmChrSetOverride:Pointer;
      VGA:^VGARec;
     End;

      { Type Sp‚cial d'Isabel }

     ModeInfoVideo = Record
      Mode:Word; IbmLogic,BiosSupport,Colr,Graf:Bool; SegV:Word;
      HeightChr:Byte; NmXPixels,NmYPixels:Word; NmXTxts,NmYTxts,NmVidPgs:Byte;
      NmColrs:Long; BitsPerPixel:Byte; BytesPerLn:Word; Pg:Byte; AddrPg:Word;
      ShowPg:Byte; TxtMtx:^TByte; ProcBarSpcHori,
      ProcClrWn,ProcPutFillBox,ProcSetPixel,FuncGetPixel,FuncGChar,
      FuncGCube,FuncGAttr,ProcCopT8Bin,ProcCopy8Bin,
      ProcPutTxtXYUnCol,ProcSAttr,ProcSChar,ProcSCube,ProcSGCube,
      ProcSGCubT,ProcShowPg,ProcPutTextXY,
      ProcFillBox:Word;
     End;

     PresInfVidMode = ModeInfoVideo;

     PhysicalInfoVideo=Record
      Card,Monitor:Byte;Memory:Long;Font,Hercule:Bool;Seg16C:Word;
      Palette,Color,BBlink,EGA,VGA,VGA320x400,VESA:Bool;
      ROM:Word;MousePort:Bool;VideoBits:Byte;ROMBits,DACBits:Byte;
      PVC:Bool; ProcSelBnkPg,ProcSetVideoMode:Word;
     End;

     TextCube=Record
      Chr:Char; Attr:Byte;
     End;

     TTextCube = Array[0..65520 div SizeOf(TextCube)] of TextCube;

     MainDataIsabel=Record
      CPU:Byte; Up32Bits:Bool;
      DosBlock:DosBlockPtr;
       { Video }
      TBuffer:^TTextCube;
      SizeOfProcSelBnkPg:Word;
      SizeOfBarSpcHori,
      SizeOfProcClrWn,SizeOfProcPutFillBox,SizeOfProcSetPixel,
      SizeOfFuncGetPixel,SizeOfFuncGChar,SizeOfFuncGCube,
      SizeOfFuncGAttr,SizeOfProcCopT8Bin,SizeOfProcCopy8Bin,
      SizeOfProcPutTxtXYUnCol,SizeOfProcSAttr,SizeOfProcSChar,
      SizeOfProcSCube,
      SizeOfProcShowPg,SizeOfProcPutTextXY,SizeOfProcFillBox:Word;
      SelBankPg:Procedure(Page:Byte);
      BarSpcHori:Procedure(X1,Y,X2,Attr:Byte);
      ClrWn:Procedure(X1,Y1,X2,Y2,Attr:Byte);
      FillBox:Procedure(X1,Y1,X2,Y2:Byte;Chr:Char;Attr:Byte);
      PutFillBox:Procedure(X1,Y1,X2,Y2:Int;Color:Word);
      PutLine:Procedure(X1,Y1,X2,Y2:Int;Color:Word);
      PutLineHori:Procedure(X1,Y,X2:Int;Color:Word);
      CopT8Bin:Procedure(X,Y:Word;Value,Fore:Byte);
      Copy8Bin:Procedure(X,Y:Word;Value,Back,Fore:Byte);
      GetAttr:Function(X,Y:Byte):Byte;
      GetChar:Function(X,Y:Byte):Char;
      GetCube:Function(X,Y:Byte):Word;
      SetAttr:Procedure(X,Y,Attr:Byte);
      SetChar:Procedure(X,Y:Byte;Chr:Char);
      SetCube:Procedure(X,Y:Byte;Chr:Char;Attr:Byte);
      SetGCube:Procedure(X,Y:Word;Chr:Char;Attr:Byte);
      SetGCubeT:Procedure(X,Y:Word;Chr:Char;Attr:Byte);
      PutTextXY:Procedure(X,Y:Byte;Str:String;Attr:Byte);
      PutTextXYUnCol:Procedure(X,Y:Byte;Str:String);
      SetPixel:Procedure(X,Y:Int;C:Word);
      GetPixel:Function(X,Y:Int):Word;
      ShowPg:Procedure(Pg:Byte);
      FreeMem:Procedure(Buffer:Pointer;Size:Word);
      CmpStr:Function(a,b:String):Bool;
      XCmpLeft:Function(a,b:String):Bool;
      FillWord:Procedure(Var X;Len,Value:Word);
      SizeOfProcSGCube,SizeOfProcSGCubT:Word;
     End;

Var TableInt:TableIntRec Absolute $0000:$0000;
    Int1Eh:^Int1EhRec Absolute $0000:$0078;
    Int41h:^IntHardDiskRec Absolute $0000:$0104;
    Int46h:^IntHardDiskRec Absolute $0000:$0118;
    EGAVGATable:^SaveOverrideRec Absolute $0040:$00A8;

     { Environnement Sp‚cial d'Isabel }

    PathSystems:PChar;
    MainDataR:MainDataIsabel;
    MainLib:Function(X:Word;Var SizeOf:Word):Pointer Absolute $0040:$00D8;
    MainData:^MainDataIsabel  Absolute $0040:$00DC;
    PVid1:^PhysicalInfoVideo  Absolute $0040:$00E0;
    PVid2:^PhysicalInfoVideo  Absolute $0040:$00E4;
    IVid1:^ModeInfoVideo      Absolute $0040:$00E8;
    IVid2:^ModeInfoVideo      Absolute $0040:$00EC;

Procedure AddRec(Handle,Size:Word;Var Buf);
Procedure Close(Var Handle:Word);
Procedure Dir2DateNTimeStr(Info:SearchRec;Var Date,Time:String);
Procedure GetIntVec(IntNo:Byte;Var Vector:Pointer);
Procedure GetCountry(Var Country:CountryRec);
Procedure GetRec(Handle:Word;P:Long;Size:Word;Var Buf);
Procedure PutFileLn(Handle:Word);
Procedure PutFileText(Handle:Word;X:String);
Procedure PutFileTextLn(Handle:Word;X:String);
Procedure Rename(Source,Target:PathStr);
Procedure ReDirHandle(ModelHandle,OtherHandle:Word);
Procedure SetDisk(Disk:Byte);
Procedure SetFilePos(Handle:Word;P:Long);
Procedure SetFileTime(Handle:Word;Func:Byte;Var Time,Date:Word);
Procedure SetFirstRec(Handle,Size:Word;Var Buf);
Procedure SetRec(Handle:Word;P:Long;Size:Word;Var X);
Procedure SetIntVec(IntNo:Byte;Vector:Pointer);
Procedure UnpackSecTrack(SecTrack:Word;Var Sec,Track:Word);
Procedure _SetFilePos(Handle:Word;P:Long;Method:Byte);
Procedure _SetRec(Handle,Size:Word;Var X);

Function CopyFile(Source,Target:PathStr):Byte;
Function Del(Name:PathStr):Word;
Function DirExist(Dir:DirStr):Bool;
Function Disk2Drive(Disk:Byte):Char;
Function DiskExist(Disk:Byte):Bool;
Function DiskFixed(Disk:Byte):Bool;
Function DiskFree(Disk:Byte):Long;
Function DiskSize(Disk:Byte):Long;
Function DiskUsed(Disk:Byte):Long;
Function Drive2Disk(Drive:Char):Byte;
Function DriveExist(Drive:Char):Bool;
Function Dos2UnixPath(Path:PathStr):PathStr;
Function DosVer:Word;
Function DuplHandle(Handle:Word):Word;
Function FileExist(Name:PathStr):Bool;
Function FileExpand(Path:PathStr):PathStr;
Function FileSize(Handle:Word):Long;
Function GetDrive:Char;
Function GetDisk:Byte;
Function GetDiskLabel(Disk:Byte):String;
Function GetDosBlock:DosBlockPtr;
Function GetDosErrMsg(X:Byte):PChar;
Function GetFile(Name:PathStr;P:Long;Size:Word;Var Buf):Word;
Function GetFileSize(Name:PathStr):Long;
Function GetFileTextLn(Handle:Word):String;
Function GetNmHardDisk:Byte;
Function GetPartSec(BDisk,Head:Byte;SecCyl:Word;Var Buf:PartSecType):Bool;
Function GetPath:PathStr;
Function GetSecTrack(BDisk:Byte):Word;
Function GetTime(Handle:Word;Var Time:Long):Word;
Function HardDiskPark:Bool;
Function IsIsabel:Bool;
Function IsAllCard(Path:PathStr):Bool;
Function IsAttrDir(Attr:Word):Bool;
Function IsHandle(Handle:Word):Bool;
Function IsHandleErr(Handle:Word):Bool;
Function IsNovell:Bool;
Function IsWildCard(Path:PathStr):Bool;
Function MoveFile(Source,Target:PathStr):Byte;
Function New(Name:PathStr):Word;
Function NewTmp(Name:PathStr):Word;
Function New_(Name:PathStr;Attr:Word):Word;
Function NewAttr(Name:PathStr;Attr:Word):Bool;
Function Open(Name:PathStr;Mode:Byte):Word;
Function OpenSearchPath(Path,Name:PathStr;Mode:Byte):Word;
Function OpenSearchPathNDos(Path,Name:PathStr;Mode:Byte):Word;
Function Path2Dir(Path:PathStr):DirStr;
Function Path2Disk(Path:PathStr):Byte;
Function Path2Drive(Path:PathStr):Char;
Function Path2Ext(Path:PathStr):ExtStr;
Function Path2Name(Path:PathStr):NameStr;
Function Path2NoDir(Path:PathStr):PathStr;
Function Path2NoExt(Path:PathStr):PathStr;
Function ReadChar(Handle:Word):Char;
Function SearchFile(Path:PathStr;Var Name:PathStr;Var Size,Time:Long):Bool;
Function SectorSize(Drive:Byte):Word;
Function SelectAllIfNoExt(Path:PathStr):PathStr;
Function SetFile(Name:PathStr;P:Long;Size:Word;Var Buf):Word;
Function SetFullName(Name:PathStr):PathStr;
Function SetPath4AddFile(Path:PathStr):PathStr;
Function Src2Target(Source,Target:PathStr):PathStr;
Function Unix2DosPath(Path:PathStr):PathStr;
Function _CopyFile(Source,Target:PathStr;Proc:BackgroundCopy):Byte;
Function _GetFile(Name:PathStr;Size:Word;Var Buf):Word;
Function _GetRec(Handle,Size:Word;Var X):Word;
Function _MoveFile(Source,Target:PathStr;Proc:BackgroundCopy):Byte;
Function _Open(Name:PathStr):Word;

IMPLEMENTATION

Uses Strs,Mems,RLL;

Const

      _FileAttribut = WordMax - (faVolumeID + faDirectory);
      _HandleError  = WordMax;

Procedure AddRec;
Begin
 SetRec(Handle,Long(FileSize(Handle) div Size),Size,Buf);
End;

Procedure Close;
Assembler;
ASM
 MOV AX,$3E00;
 LES DI,Handle;
 MOV BX,ES:[DI];
 INT $21;
 JNC @@1;
 LES DI,Handle;
 MOV AX,$FFFF;
 MOV ES:[DI],AX;
 XOR AX,AX;
@@1:
 MOV FileError,AX;
END;

Function CopyFile;
Var HSource,HTarget,NM:Word; Size,I,ND:Long; Buf:Array[0..1023] of Byte;
Begin
 CopyFile:=0; HSource:=Open(Source,ReadOnly);
 If(IsHandleErr(HSource))Then
 Begin
  CopyFile := errFileNotFound;
  Exit;
 End;
 Size:=FileSize(HSource); HTarget:=New(Target);
 If(IsHandleErr(HTarget))Then
 Begin
  Close(HSource);
  CopyFile := errMakeFileError;
  Exit;
 End;
 ND:=Size div SizeOf(Buf); NM:=Size mod SizeOf(Buf);
 For I := 0 to (ND - 1) do
 Begin
  GetRec(HSource,I,SizeOf(Buf),Buf);
  SetRec(HTarget,I,SizeOf(Buf),Buf);
  CopyFile := FileError;
 End;
 If(NM > 0)Then
 Begin
  SetFilePos(HSource,ND*SizeOf(Buf));
  _GetRec(HSource,NM,Buf);
  SetFilePos(HTarget,ND*SizeOf(Buf));
  _SetRec(HTarget,NM,Buf);
  CopyFile := FileError;
 End;
 Close(HTarget);
 Close(HSource);
End;

Function Del;
Assembler;
ASM
 PUSH DS;
  LDS DI,Name;
  MOV BL,DS:[DI];
  INC DI;
  MOV BH,0;
  MOV DS:[DI+BX],BH;
  MOV DX,DI;
  MOV AX,$4100;
  INT $21;
 POP DS;
 JC  @@2;
 XOR AX,AX;
@@2:
 MOV FileError,AX;
END;

Procedure Dir2DateNTimeStr;
Var DT:DateTime;
Begin
 UnpackTime(Info.Time,DT);
 Date := Str2(DT.Year,4)+'-'+Str0(DT.Month,2)+'-'+Str0(DT.Day,2);
 Time := Str2(DT.Hour,2)+':'+Str0(DT.Min,2)+':'+Str0(DT.Sec,2);
End;

Function DirExist;
Var Rec:SearchRec;
Begin
 FindFirst(Dir,Directory,Rec);
 DirExist := (DosError = 0);
End;

Function Disk2Drive;
Begin
 Disk2Drive := Char(Disk + Byte('@'))
End;

Function DiskExist;
Var Old:Byte;
Begin
 Old  := GetDisk;
 SetDisk(Disk);
 DiskExist := (Disk = GetDisk);
 SetDisk(Old);
End;

Function DiskFixed;
Assembler;
ASM
 MOV AX,$4408;
 MOV BL,Disk;
 INT $21;
 JNC @@End;
 MOV AL,Byte(False);
@@End:
END;

Function DiskFree;
Assembler;
ASM
 MOV DL,Disk;
 MOV AH,$36;
 INT $21;
 MOV DX,AX;
 CMP AX,$FFFF;
 JE  @@End;
@@Ok:
 MUL CX;
 MUL BX;
@@End:
END;

Function DiskSize;
Assembler;
ASM
 MOV DL,Disk;
 MOV AH,$36;
 INT $21;
 MOV BX,DX;
 MOV DX,AX;
 CMP AX,$FFFF;
 JE  @@End;
@@Ok:
 MUL CX;
 MUL BX;
@@End:
END;

Function DiskUsed;
Begin
 DiskUsed := (Long(DiskSize(Disk)) - Long(DiskFree(Disk)));
End;

Function DosVer;
Assembler;
ASM
 MOV AH,$30;
 INT $21;
END;

Function Drive2Disk;
Begin
 If(Drive in ['A'..'Z'])Then Drive2Disk := Byte(Drive) - Byte('A') + 1 Else
 If(Drive in ['a'..'z'])Then Drive2Disk := Byte(Drive) - Byte('a') + 1
			Else Drive2Disk := 0;
End;

Function DriveExist;
Begin
 DriveExist := DiskExist(Drive2Disk(Drive)-1);
End;

Function DuplHandle;
Assembler;
ASM
 MOV AH,$45;
 MOV BX,Handle;
 CMP BX,$FFFF;
 JE  @@2;
 INT $21;
 JNC @@2;
 MOV FileError,AX;
 XOR AX,AX;
@@2:
END;

Function FileExist;
Var Rec : SearchRec;
Begin
 FindFirst(Name,_FileAttribut,Rec);
 FileExist := (DosError = 0);
End;

Function FileExpand;
Begin
 If((Length(Path) >= 1)and(Path[1] = '\'))Then FileExpand := StrUp(GetDrive + ':' + Path)
					  Else FileExpand := StrUp(FExpand(Path));
End;

Function FileSize;
Assembler;
ASM
 MOV AX,$4202;
 MOV BX,Handle;
 CMP BX,$FFFF;
 JE  @@1;
 XOR CX,CX;
 XOR DX,DX;
 INT $21;
 JC  @@1;
 MOV BX,DX;
 MOV FileError,0;
 JMP @@2;
@@1:
 MOV FileError,AX;
 MOV AX,$FFFF;
 MOV BX,AX;
@@2:
END;

Procedure GetCountry;
Assembler;
ASM
 PUSH DS;
  MOV AX,$3800;
  LDS DX,Country;
  INT $21;
 POP DS;
END;

Function GetDisk;
Assembler;
ASM
 MOV AH,$19;
 INT $21;
End;

Function GetDiskLabel;
Var Info:SearchRec; I:Byte; Drive:Char;
Begin
 If Not(Bool(Disk))Then Drive := GetDrive Else Drive := Char(Disk + 64);
 FindFirst(Drive + ':\*.*',VolumeID,Info);
 If(DosError = 0)Then GetDiskLabel := Info.Name Else GetDiskLabel := '';
End;

Function GetDosBlock;
Assembler;
ASM
 MOV AH,$52;
 INT $21;
 MOV AX,BX;
 ADD AX,12;
 MOV DX,ES;
 DEC DX;
END;

Function GetDosErrMsg;
Begin
 Case X of
   errFonctionNotFound : GetDosErrMsg := 'Fonction inconnu.';
       errFileNotFound : GetDosErrMsg := 'Fichier introuvable.';
       errPathNotFound : GetDosErrMsg := 'R‚pertoire introuvable.';
    errTooManyFileOpen : GetDosErrMsg := 'Trop de fichier ouvert.';
       errAccessDenied : GetDosErrMsg := 'AccŠs refus‚.';
     errHandleNotFound : GetDosErrMsg := 'Handle inconnu.';
       errMCBDestroyed : GetDosErrMsg := 'MCB d‚truit.';
	errOutOfMemory : GetDosErrMsg := 'Manque de m‚moire.';
	errInvalidAddr : GetDosErrMsg := 'Adressage invalide.';
	 errInvalidEnv : GetDosErrMsg := 'Environnement invalide.';
  errInvalidCodeAccess : GetDosErrMsg := 'Code accŠs invalide.';
	  errDataError : GetDosErrMsg := 'Erreur de donn‚e.';
       errDiskNotFound : GetDosErrMsg := 'Disque inconnu.';
	errDelMainPath : GetDosErrMsg := 'Tentative de destruction du r‚pertoire de base.';
 errIncompatibleDevice : GetDosErrMsg := 'P‚riph‚rique incompatible.';
      errTooManyHandle : GetDosErrMsg := 'Manque de Handle.';
   errDiskWriteProtect : GetDosErrMsg := 'Support prot‚g‚ contre l''‚criture.';
      errInvalidDevice : GetDosErrMsg := 'P‚riph‚rique invalide.';
     errDeviceNotReady : GetDosErrMsg := 'P‚riph‚rique pas prˆte.';
 errUnknownInstruction : GetDosErrMsg := 'Instruction inconnu.';
	   errCrcError : GetDosErrMsg := 'Erreur CRC.';
    errLengthDataError : GetDosErrMsg := 'Erreur de longueur de donn‚e.';
	    errNotFind : GetDosErrMsg := 'Recherche infructueuse.';
      errUnknownDevice : GetDosErrMsg := 'P‚riph‚rique inconnue.';
     errSectorNotFound : GetDosErrMsg := 'Secteur introuvable.';
	 errOutOfPaper : GetDosErrMsg := 'Manque de papier.';
	 errWriteError : GetDosErrMsg := 'Erreur d''‚criture.';
	  errReadError : GetDosErrMsg := 'Erreur de lecture.';
       errGeneralError : GetDosErrMsg := 'Erreur g‚n‚ral.';
	 errChangeDisk : GetDosErrMsg := 'Changement de disque non-autoris‚.';
	   errOutOfFCB : GetDosErrMsg := 'Manque de FCB.';
 errMakeDirectoryError : GetDosErrMsg := 'Erreur de cr‚ation de r‚pertoire.';
	  errFileExist : GetDosErrMsg := 'Fichier d‚j… existant.';
	errBreakInt24h : GetDosErrMsg := 'Arrˆt par l''interruption 24h.';
      errMakeFileError : GetDosErrMsg := 'Erreur de cr‚ation de fichier.';
		    Else GetDosErrMsg := 'Erreur inconnu.';
 End;
End;

Function GetDrive;
Assembler;
ASM
 MOV AH,$19;
 INT $21;
 ADD AL,Byte('A');
End;

Function GetFile;
Var Handle:Word;
Begin
 Handle := Open(Name,ReadOnly);
 If(IsHandleErr(Handle))Then
 Begin
  GetFile := Handle;
  Exit;
 End;
 GetRec(Handle,P,Size,Buf);
 Close(Handle);
 GetFile := 0;
End;

Function GetFileSize;
Var Rec:SearchRec;
Begin
 FindFirst(Name,_FileAttribut,Rec);
 GetFileSize := Rec.Time;
End;

Function GetFileTextLn;
Var Str:String; I:Byte; Chr:Char;
Begin
 GetFileTextLn := ''; Str := '';
 For I := 1 to 255 do
 Begin
  Chr := ReadChar(Handle);
  If Not(FileError = 0)Then Break;
  If(Chr = #13)Then
  Begin
   Chr := ReadChar(Handle);
   If Not(FileError = 0)Then Break;
   If(Chr = #10)Then Break;
   IncStr(Str,#13); IncStr(Str,Chr);
  End
   Else
  IncStr(Str,Chr);
 End;
 GetFileTextLn := Str;
End;

Procedure GetIntVec;
Begin
 CLI;
 Vector := TableInt[IntNo];
 STI;
End;

Function GetNmHardDisk;
Begin
 GetNmHardDisk := Mem[_0040:$75];
End;

Function GetPath;
Var Path : String;
Begin
 GetDir(0,Path);
 GetPath := Path;
End;

Function GetPartSec;
Assembler;
ASM
 MOV AX,$0201;
 MOV DL,BDisk;
 MOV DH,Head;
 MOV CX,SecCyl;
 LES BX,Buf;
 INT $13;
 MOV AL,Byte(True);
 JNC @@End;
@@Error:
 MOV AL,Byte(False);
@@End:
END;

Procedure GetRec;
Begin
 SetFilePos(Handle,P*Long(Size));
 _GetRec(Handle,Size,Buf);
End;

Function GetSecTrack;
Assembler;
ASM
 MOV AH,8;
 MOV DL,BDisk;
 INT $13;
 MOV AX,CX;
END;

Function GetTime;
Assembler;
ASM
 MOV AX,$5700;
 MOV BX,Handle;
 CMP BX,$FFFF;
 JE  @@1;
 INT $21;
 JC  @@1;
 MOV Time.Word[0],CX;
 MOV Time.Word[SizeOfWord],DX;
 XOR AX,AX;
@@1:
 MOV FileError,AX;
END;

Function HardDiskPark;
Assembler;
Var Data_4,Data_3:Byte; Drive:Word;
ASM
 MOV Data_3,0;
 MOV Data_4,0;
 MOV Drive,$80;
 MOV AX,$8000;
 MOV CX,0;
 MOV DX,Drive;
 INT $13;
 JC  @@3
 CMP DL,0;
 JE  @@3;
 MOV DATA_3,DL;
 CMP DL,2;
 JBE @@2;
 MOV DATA_3,2;
@@2: CALL @@20;
 INC Drive;
 DEC DATA_3;
 JNZ  @@2;
@@3:
 TEST DATA_4,80H;
 JZ   @@4;
 MOV  AL,Byte(True);
 JMP  @@99;
@@4:
 MOV  AL,Byte(False);
 JMP  @@99;
@@20: { Procedure PositionHardDisk(Drive:Word); }
 MOV AX,$1100;
 XOR CX,CX;
 MOV DX,Drive;
 INT $13;
 JC  @@7;
 OR  DATA_4,$80;
 MOV AX,$0C00;
 XOR CX,CX;
 MOV DX,Drive;
 INT $13;
 MOV AX,$0800;
 XOR CX,CX;
 MOV DX,Drive;
 INT $13;
 MOV AX,$0C00;
 MOV DX,Drive;
 INT $13;
@@7:
 RETN;
@@99:
END;

Function IsIsabel;
Begin
 IsIsabel := Not(MainData = NIL);
End;

Function IsAllCard;
Begin
 IsAllCard := ((Pos('*.*',Path) > 0)or(Pos('????????.???',Path) > 0));
End;

Function IsAttrDir;
Begin
 IsAttrDir := ((Attr and Directory) = Directory);
End;

Function IsHandle;
Begin
 IsHandle := Not(Handle = $FFFF);
End;

Function IsHandleErr;
Begin
 IsHandleErr := (Handle = _HandleError);
End;

Function IsNovell;
Assembler;
ASM
 XOR CX,CX;
 MOV AX,$DC00;
 INT $21;
 CMP AL,0;
 JE  @@End;
 MOV AL,Byte(True);
@@End:
END;

Function IsWildCard;
Begin
 IsWildCard := (Pos('*',Path) > 0)or(Pos('?',Path) > 0);
End;

Function MoveFile;
Var Err : Byte;
Begin
 MoveFile := 0;
 Err := CopyFile(Source,Target);
 If(Err > 0)Then
 Begin
  MoveFile := Err;
  Exit;
 End;
 MoveFile := Del(Source);
End;

Function New;
Assembler;
ASM
 PUSH DS;
  LDS DI,Name;
  MOV BL,DS:[DI];
  INC DI;
  MOV BH,0;
  MOV DS:[DI+BX],BH; { Name := Name + #0 }
  XOR CX,CX;
  MOV DX,DI;
  MOV AH,$3C;
  INT $21;
 POP DS;
 JC  @@1;
 MOV FileError,0;
 JMP @@2;
@@1:
 MOV FileError,AX;
 MOV AX,_HandleError;
@@2:
END;

Function New_;
Assembler;
ASM
 PUSH DS;
  MOV CX,Attr;
  LDS DI,Name;
  MOV BL,DS:[DI];
  INC DI; { Set Name[1] }
  MOV BH,0;
  MOV DS:[DI+BX],BH; { Name := Name + #0 }
  MOV DX,DI;
  MOV AH,$3C;
  INT $21;
 POP DS;
 JC  @@1;
 MOV FileError,0;
 JMP @@2;
@@1:
 MOV FileError,AX;
 MOV AX,_HandleError;
@@2:
END;

Function NewAttr;
Begin
 NewAttr := Not(New_(Name,Attr) = _HandleError);
End;

Function NewTmp;
Assembler;
ASM
 PUSH DS;
  LDS DI,Name;
  MOV BL,DS:[DI];
  INC DI;
  MOV BH,0;
  MOV DS:[DI+BX],BH; { Name := Name + #0 }
  MOV DX,DI;
  MOV AH,$5A;
  XOR CX,CX;
  INT $21;
 POP DS;
 JC  @@1;
 MOV FileError,0;
 JMP @@2;
@@1:
 MOV FileError,AX;
 MOV AX,_HandleError;
@@2:
END;

Function Open;
Assembler;
ASM
 MOV AX,$3D40;
 OR  AL,Mode;
 PUSH DS;
  LDS DI,Name;
  MOV BL,DS:[DI];
  INC DI; { Set Name[1] }
  MOV BH,0;
  MOV DS:[DI+BX],BH; { Name := Name + #0 }
  MOV DX,DI;
  INT $21;
 POP DS;
 JC  @@1;
 MOV FileError,0;
 JMP @@2;
@@1:
 MOV FileError,AX;
 MOV AX,_HandleError;
@@2:
END;

Function OpenSearchPath;
Var Dir : PathStr;
Begin
 Dir := FSearch(Name,Path);
 OpenSearchPath := Open(FExpand(Dir),Mode);
End;

Function OpenSearchPathNDos;
Var Dir : PathStr;
Begin
 Dir := FSearch(Name,Path);
 If(Dir = '')Then Dir := FSearch(Name,GetEnv('PATH'));
 OpenSearchPathNDos := Open(FExpand(Dir),Mode);
End;

Function Path2Dir;
Var D:DirStr; N:NameStr; E:ExtStr;
Begin
 Path2Dir := '';
 If(Path = '')Then Exit;
 FSplit(Path,D,N,E);
 If(E = '')Then
 Begin
  If(D[Length(D)] = '\')Then AddStr(D,E) Else AddStr(D,'\' + E);
 End;
 If(D = '')Then Path2Dir := '' else
 If(D[Length(D)] = '\')Then Path2Dir := D Else Path2Dir := D + '\';
End;

Function Path2Disk;
Begin
 If((Path = '')or(Not(Path[1] in ['A'..'Z','a'..'z'])))Then Path2Disk := GetDisk
						       Else Path2Disk := Byte(ChrUp(Path[1])) - 65;
End;

Function Path2Drive;
Begin
 Path2Drive := Char(Path2Disk(Path) + 65);
End;

Function Path2Ext;
Var D:DirStr; N:NameStr; E:ExtStr;
Begin
 FSplit(Path,D,N,E);
 Path2Ext := E;
End;

Function Path2Name;
Var D:DirStr; N:NameStr; E:ExtStr;
Begin
 FSplit(Path,D,N,E);
 Path2Name := N;
End;

Function Path2NoDir;
Var D:DirStr; N:NameStr; E:ExtStr;
Begin
 FSplit(Path,D,N,E);
 Path2NoDir := N + E;
End;

Function Path2NoExt;
Var D:DirStr; N:NameStr; E:ExtStr;
Begin
 FSplit(Path,D,N,E);
 If Not(D[Length(D)] = '\')Then IncStr(D,'\');
 Path2NoExt := D + N;
End;

Procedure PutFileLn;
Begin
 PutFileTextLn(Handle,'');
End;

Procedure PutFileText;
Begin
 SetFilePos(Handle,FileSize(Handle));
 _SetRec(Handle,Byte(X[0]),X[1]);
End;

Procedure PutFileTextLn;
Begin
 PutFileText(Handle,X + #13#10);
End;

Function ReadChar;
Var X:Char;
Begin
 _GetRec(Handle,SizeOf(X),X);
 ReadChar := X;
End;

Procedure ReDirHandle;
Assembler;
ASM
 MOV AH,$46;
 MOV BX,ModelHandle;
 MOV CX,OtherHandle;
 INT $21;
 JC  @@2;
 XOR AX,AX;
@@2:
 MOV FileError,AX;
END;

Procedure Rename;
Assembler;
ASM
 PUSH DS;
  LDS SI,Source;
  MOV BL,DS:[SI];
  INC SI; { Set Source[1] }
  MOV BH,0;
  MOV DS:[SI+BX],BH; { Source := Source + #0 }
  MOV DX,SI;
  LES DI,Target;
  MOV BL,ES:[DI];
  INC DI; { Set Target[1] }
  MOV ES:[DI+BX],BH; { Target := Target + #0 }
  MOV AH,$56;
  INT $21;
 POP DS;
 JC  @@2;
 XOR AX,AX;
@@2:
 MOV FileError,AX;
END;

Function SearchFile;
Var X:SearchRec;
Begin
 FindFirst(Path,_FileAttribut,X);
 If(DosError = 0)Then
 Begin
  Name:=X.Name; Size:=X.Size; Time:=X.Time; SearchFile:=True;
 End
  Else
 SearchFile := False;
End;

Function SectorSize;
Assembler;
ASM
 MOV DL,Drive;
 MOV AH,$1C;
 PUSH DS;
  INT $21;
 POP DS;
 CMP AL,$FF;
 JNE @@1;
 XOR AX,AX;
 JMP @@2;
@@1:
 MOV AX,CX;
@@2:
End;

Function SelectAllIfNoExt;
Begin
 If(Path2Ext(Path) = '')Then Path := SetPath4AddFile(Path) + '*.*';
 SelectAllIfNoExt := Path;
End;

Procedure SetDisk;
Assembler;
ASM
 MOV AH,$0E;
 MOV DL,Disk;
 INT $21;
END;

Function SetFullName;
Begin
 If(Name = '..')Then SetFullName := StrUSpc(Name,12)
  Else
 SetFullName := StrUSpc(StrUSpc(Path2Name(Name),8) + Path2Ext(Name),12);
End;

Function SetFile;
Var Handle:Word;
Begin
 Handle := Open(Name,WriteOnly);
 If(IsHandleErr(Handle))Then
 Begin
  SetFile := Handle;
  Exit;
 End;
 SetRec(Handle,P,Size,Buf);
 Close(Handle);
 SetFile := 0;
End;

Procedure SetFilePos;
Assembler;
Const SizeOfWord = SizeOf(Word);
ASM
 LEA DI,P;
 MOV AX,$4200;
 MOV BX,Handle;
 CMP BX,$FFFF;
 JE  @@1;
 MOV CX,SS:[DI+SizeOfWord];
 MOV DX,SS:[DI];
 INT $21;
 JC  @@1;
 XOR AX,AX;
@@1:
 MOV FileError,AX;
END;

Procedure SetFileTime;
Assembler;
ASM
 MOV AH,$57;
 MOV AL,Func;
 MOV BX,Handle;
 CMP BX,$FFFF;
 JE  @@1;
 LES DI,Time;
 MOV CX,ES:[DI];
 LES DI,Date;
 MOV DX,ES:[DI];
 INT $21;
@@1:
 LES DI,Time;
 MOV ES:[DI],CX;
 LES DI,Date;
 MOV ES:[DI],DX;
END;

Procedure SetFirstRec;
Begin
 SetRec(Handle,0,Size,Buf);
End;

Procedure SetIntVec;
Begin
 CLI;
 TableInt[IntNo] := Vector;
 STI;
End;

Function SetPath4AddFile;
Begin
 If Not(Path[Length(Path)] = '\')Then IncStr(Path,'\');
 SetPath4AddFile := Path;
End;

Procedure SetRec;
Begin
 SetFilePos(Handle,P*LongInt(Size));
 _SetRec(Handle,Size,X);
End;

Function Src2Target;
Var D:DirStr; SN,N:NameStr; SE,E:ExtStr; Path:PathStr; I:Byte;
Begin
 If(Target = '')Then { Destination vide ? }
 Begin
  FSplit(Source,D,N,E);
  Target := N + E;
  Exit;
 End;
 If(Path2Ext(Target) = '')Then { Destination seulement avec R‚pertoire ? }
 Begin
  If((Length(Target) > 0)and(Not(Target[Length(Target)] = '\')))Then
   IncStr(Target,'\');
  FSplit(Source,D,N,E);
  Src2Target := FileExpand(Target + N + E);
  Exit;
 End;
 SN := Path2Name(Source); SE := Path2Ext(Source);
 FSplit(Target,D,N,E);
 If(E = '*')Then E := Path2Ext(Source);
 If(N = '*')Then N := Path2Name(Source);
  { Name * }
 I := Pos('*',N); If(I > 0)Then N := Copy(N,1,I-1) + Copy(SN,I,255);
  { Name ? }
 Repeat I := Pos('?',N); If(I > 0)Then N[I] := SN[I]; Until (I = 0);
  { Extension * }
 I := Pos('*',E); If(I > 0)Then N := Copy(E,1,I-1) + Copy(SE,I,255);
  { Extension ? }
 Repeat I := Pos('?',E); If(I > 0)Then E[I] := SE[I]; Until (I = 0);
 If((Length(D) > 0)and(Not(D[Length(D)] = '\')))Then IncStr(D,'\');
 Path := D + N + E;
 If((Length(Path) >= 1)and(Path[1] = '\'))Then Path := GetDrive + ':' + Path;
 Src2Target := Path;
End;

Procedure UnpackSecTrack;
Begin
 Sec:=SecTrack and 63; Track:=Hi(SecTrack)+(Lo(SecTrack) and 192) shl 2;
End;

Function _CopyFile;
Var HSource,HTarget,NM:Word; Size,I,ND,M:Long; Buf:Array[0..1023] of Byte;
Begin
 _CopyFile := 0; HSource := Open(Source,ReadOnly);
 If(IsHandleErr(HSource))Then  Begin _CopyFile := errFileNotFound; Exit; End;
 Size := FileSize(HSource); HTarget := New(Target);
 If(IsHandleErr(HTarget))Then
 Begin
  Close(HSource);
  _CopyFile := errMakeFileError;
  Exit;
 End;
 ND := Size div SizeOf(Buf); NM := Size mod SizeOf(Buf);
 For I := 0 to (ND - 1) do
 Begin
  GetRec(HSource,I,SizeOf(Buf),Buf);
  SetRec(HTarget,I,SizeOf(Buf),Buf);
  _CopyFile:=FileError; M:=Long(I)*SizeOf(Buf);
  Proc(Trunc((M/Size)*100),M,Size);
 End;
 If(NM > 0)Then
 Begin
  SetFilePos(HSource,ND*SizeOf(Buf));
  _GetRec(HSource,NM,Buf);
  SetFilePos(HTarget,ND*SizeOf(Buf));
  _SetRec(HTarget,NM,Buf);
  _CopyFile := FileError;
 End;
 Close(HTarget);
 Close(HSource);
End;

Function _GetFile;
Var Handle:Word;
Begin
 Handle := Open(Name,ReadOnly);
 If(IsHandleErr(Handle))Then  Begin _GetFile := Handle; Exit; End;
 GetRec(Handle,0,Size,Buf);
 Close(Handle);
 _GetFile := 0;
End;

Function _GetRec;
Assembler;
ASM
 CLD;
 MOV AL,0;
 MOV CX,Size;
 LES DI,X;
 REP STOSB;
 MOV AX,$3F00;
 MOV BX,Handle;
 CMP BX,$FFFF;
 JE  @@End;
 MOV CX,Size;
 LES DI,X;
 PUSH DS;
  PUSH ES;
  POP DS;
  MOV DX,DI;
  INT $21;
 POP DS;
 JC  @@1;
 MOV FileError,0;
 JMP @@End;
@@1:
 MOV FileError,AX;
@@End:
END;

Function _MoveFile;
Var Err:Byte;
Begin
 _MoveFile:=0; Err:=_CopyFile(Source,Target,Proc);
 If(Err > 0)Then  Begin _MoveFile := Err; Exit; End;
 _MoveFile := Del(Source);
End;

Function _Open;
Begin
 _Open := Open(Name,Normal);
End;

Procedure _SetFilePos;
Assembler;
Var Pos:Record Lo,Hi:Word; End Absolute P;
ASM
 MOV AH,$42;
 MOV AL,Method;
 MOV BX,Handle;
 CMP BX,$FFFF;
 JE  @@End;
 MOV CX,Pos.Hi;
 MOV DX,Pos.Lo;
 INT $21;
@@End:
END;

Procedure _SetRec;
Assembler;
ASM
 PUSH DS;
  LDS DX,X;
  MOV BX,Handle;
  CMP BX,$FFFF;
  JE  @@Bug;
  MOV CX,Size;
  MOV AX,$4000;
  INT $21;
@@Bug:
 POP DS;
 JC  @@1;
 XOR AX,AX;
@@1:
 MOV FileError,AX;
END;

Function Dos2UnixPath(Path:PathStr):PathStr;
Begin
 ChgChr(Path,';',':');
 ChgChr(Path,'/','\');
End;

Function Unix2DosPath(Path:PathStr):PathStr;
Begin
 ChgChr(Path,':',';');
 ChgChr(Path,'\','/');
 Unix2DosPath := Path;
End;

BEGIN { Main Unit }
 PathSystems := NIL;
 FillChar(MainDataR,SizeOf(MainDataR),0);
 MainLib := AllocMainFunc;
 MainDataR.CPU := Math.CPU; MainDataR.Up32Bits := Math.Up32Bits;
 MainDataR.DosBlock := GetDosBlock;
 MainDataR.FreeMem := Mems.FreeMem;
 MainDataR.CmpStr := Strs.CmpStr;
 MainDataR.XCmpLeft := Strs.XCmpLeft;
 MainDataR.FillWord := Math.FillWord;
 MainData := @MainDataR;
END.