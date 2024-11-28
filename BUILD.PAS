Program Build;

{ Simple programme pour compiler les unit‚s... }

Uses AC,AntiVirus,AppleII,CardVideo,CK64,Clock,CmpilAsm,Coco3,
     Cursor,Dials,EditButt,Editor,Emulator,FileManagers,
     Images,Keyboard,Language,LibVideo,Math,Memorys,Mems,MLibrary,
     MM,Mnus,Mouse,Printers,Protocol,QHexView,RLL,Sound,Strs,Systems,
     TeleMate,Terminal,TMDials,ToolEdit,ToolLang,ToolMS,ToolPrn,ToolTerm,
     ToolTM,ToolVid,Video,Windows,ScrnSaver,Spooler;

BEGIN
 InitVideoDeluxe;
 InitMemManagers;
 InitSpooler;
 __InitMouse;
 __DoneMouse;
 DoneSpooler;
 DoneLuxeVideo;
 DoneMemManagers;
END.