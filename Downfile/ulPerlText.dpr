library ulPerlText;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  Classes,
  pcre in '.\TPerlRegEx\pcre.pas',
  PerlRegEx in '.\TPerlRegEx\PerlRegEx.pas';

{$R *.res}

function GetPerlData(sData: string; sMatch: string; sDel: string = '#';
  sMatchBegin: string = ''; sMatchEnd: string = ''): PChar; stdcall; export;
var
  reg: TPerlRegEx;
  sTemp: string;
begin
  reg := TPerlRegEx.Create;
  try
    if ((sMatch = '') and (sMatchBegin <> '') and (sMatchEnd <> '')) then
       sMatch := sMatchBegin + '.*?[\s\S]*?' + sMatchEnd; 
    try
      sTemp := '';
      reg.Subject := sData;
      reg.RegEx := sMatch;
      while reg.MatchAgain do
      begin
        if sTemp = '' then
          sTemp := reg.MatchedText
        else
          sTemp := sTemp + sDel + reg.MatchedText;
      end;
      Result := PChar(sTemp);
    except
      Result := '';
    end;
  finally
    reg.Free;
  end;
end;

exports
  GetPerlData;

begin
end.
