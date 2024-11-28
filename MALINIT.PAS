Unit MalInit;

INTERFACE

IMPLEMENTATION

Uses {$IFDEF Overlay}Overlay,{$ENDIF}Memorys,Systems,Video,Dials{,MalBKRes};

BEGIN
 {$IFDEF Overlay}
 Repeat
  InitVideoDeluxe;
  OvrInit('MALBOOK.OVR');
  If(OvrResult <> OvrOk)Then
  Begin
   If(ErrorMsg('Fichier Overlay introuvable (MALBOOK.OVR) !',
      KeyRetry+KeyCancel) = kbRetry)Then Continue
    Else
   Begin
    DoneLuxeVideo;
    WriteLn('Erreur Overlay!');
    Halt;
   End;
  End;
 Until True;
 {$ENDIF}
END.