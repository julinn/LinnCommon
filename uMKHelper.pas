unit uMKHelper;

interface

function GetString(): PChar; stdcall; external 'MKConnSQL.dll';
function GetMKString(sPassword: string = ''; sFileName: string = 'Licence.Linn'): PChar; stdcall; external 'MKConnSQL.dll';
function GetMKSubString(sBegin, sEnd: string; sPassword: string = ''; sFileName: string = 'Licence.Linn'): PChar; stdcall; external 'MKConnSQL.dll';

implementation

end.