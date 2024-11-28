Program MalBook;

{$M 16384,0,0}

Uses MM,MalInit,ScrnSaver,MalInitOverlay,MLibrary,Video,MalMnu,MalEnv,
     Country;

{$O AppleII}
{$O COCO3}
{$O CK64}
{$O EditButt}
{$O Emulator}
{$O Protocol}
{$O QHexView}
{$O TOOLPRN}
{$O TOOLEDIT}
{$O TOOLLANG}
{$O TOOLMS}
{$O TOOLTERM}
{$O TOOLTM}
{$O TOOLVID}
{$O MALBKRES}
{$O MALENVOVERLAY}
{$O FILEMANAGERS}
{$O MALINITOVERLAY}
{$O MalCalc}
{$O MALCMPAS}
{$O MALCOMRC}
{$O MALCONV}
{$O MALINFO}
{$O MALMNU}
{$O MALSDIR}
{$O MalViewAscii}
{$O MalWatch}

BEGIN
 WinType := Robotic;
 InitOverlay;
 Run;
END.