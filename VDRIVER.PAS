Uses Systems;

{Var Driver:^NulDeviceRec;}

Var Country:CountryRec;

BEGIN
{ Driver := MainDataR.DosBlock^.Ver.Dos5.NulDevice.Next;
 Repeat
  WriteLn(Driver^.Name);
  Driver := Driver^.Next;
 Until (Driver = NIL)}
 GetCountry(Country);
 WriteLn(Country.CO_DATE);
END.