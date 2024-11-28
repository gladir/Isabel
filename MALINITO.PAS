Unit MalInitOverlay;

INTERFACE

Procedure InitOverlay;

IMPLEMENTATION

Uses Memorys,Systems,Country,MalBKRes,Dials,Printers,Video,
     Editor,ToolVid,Overlay;

Procedure InitOverlay;
Begin
 ReadIniFile;
 If(SwapEms)Then
 Begin
  {$IFDEF Overlay} OvrInitEms; {$ENDIF}
  NoEms := False;
 End
  Else
 NoEms := True;
 InitCountry;
 SetCheckSVGA(CheckSVGA);
 InitVideoDeluxe;
 InitColorsDefault;
 If(IsMonochrome)Then CurrColors := Colors[MtxMonochrome]
		 Else CurrColors := Colors[MtxBleuet];
 PrnOutput := prnLPT1;
End;

BEGIN
END.