unit ulCodeConvert;

interface

uses
  SysUtils;

//URL
function URLEncode(const S: string; const InQueryString: Boolean = True): string;
function URLDecode(const S: string): string;
//
function Gb2312ToUnicode(sStr: string): string;
function UnicodeToGb2312(sStr: string): string;
//字符串转换成16进制字符串
function StrToHexStr(const S: string): string;
//16进制字符串转换成字符串
function HexStrToStr(const S: string): string;

{
//System 单元内置函数
function AnsiToUtf8(const S: string): string;
function Utf8ToAnsi(const S: string): string;
//
function Utf8ToUniCode
function UnicodeToUtf8
}

implementation

function URLEncode(const S: string; const InQueryString: Boolean = True): string;
var
  Idx: Integer; // loops thru characters in string
begin
  Result := '';
  for Idx := 1 to Length(S) do
  begin
    case S[Idx] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        Result := Result + S[Idx];
      ' ':
        if InQueryString then
          Result := Result + '+'
        else
          Result := Result + '%20';
    else
        Result := Result + '%' + SysUtils.IntToHex(Ord(S[Idx]), 2);
    end;
  end;
end;

function URLDecode(const S: string): string;
var
  Idx: Integer;   // loops thru chars in string
  Hex: string;    // string of hex characters
  Code: Integer; // hex character code (-1 on error)
begin
  // Intialise result and string index
  Result := '';
  Idx := 1;
  // Loop thru string decoding each character
  while Idx <= Length(S) do
  begin
    case S[Idx] of
      '%':
      begin
        // % should be followed by two hex digits - exception otherwise
        if Idx <= Length(S) - 2 then
        begin
          // there are sufficient digits - try to decode hex digits
          Hex := S[Idx+1] + S[Idx+2];
          Code := SysUtils.StrToIntDef('$' + Hex, -1);
          Inc(Idx, 2);
        end
        else
          // insufficient digits - error
          Code := -1;
        // check for error and raise exception if found
        if Code = -1 then
          raise SysUtils.EConvertError.Create(
            'Invalid hex digit in URL'
          );
        // decoded OK - add character to result
        Result := Result + Chr(Code);
      end;
      '+':
        // + is decoded as a space
        Result := Result + ' '
      else
        // All other characters pass thru unchanged
        Result := Result + S[Idx];
    end;
    Inc(Idx);
  end;
end;

function Gb2312ToUnicode(sStr: string): string;
var
  s: string;
  i, j, k: integer;
  a: array [1..160] of char;
begin
  s:='';
  StringToWideChar(sStr, @(a[1]), 500);
  i:=1;
  while ((a[i]<>#0) or (a[i+1]<>#0)) do
  begin
    j:=Integer(a[i]);
    k:=Integer(a[i+1]);
    s:=s+Copy(Format('%X ',[k*$100+j+$10000]) ,2,4);
    //S := S + Char(k)+Char(j);
    i:=i+2;
  end;
  Result:=s;
end;

function UnicodeToGb2312(sStr: string): string;
Var
  I: Integer;
begin
  I := Length(sStr);
  while I >=4 do
  begin
    try
      Result :=WideChar(StrToInt('$'+sStr[I-3]+sStr[I-2]+sStr[I-1]+sStr[I]))+ Result;
    except
      //
    end;
    I := I - 4;
  end;
end;

function StrToHexStr(const S: string): string;
var
 I: Integer;
begin
  for I := 1 to Length(S) do
  begin
     if I = 1 then
       Result := IntToHex(Ord(S[1]), 2)
     else Result := Result + IntToHex(Ord(S[I]), 2);
  end;
end;

function HexStrToStr(const S: string): string;
var
 t: Integer;
 ts: string;
 M, Code: Integer;
begin
  t := 1;
  Result := '';
  while t <= Length(S) do
  begin
     while not (S[t] in ['0'..'9', 'A'..'F', 'a'..'f']) do
       inc(t);
     if (t + 1 > Length(S)) or (not (S[t + 1] in ['0'..'9', 'A'..'F', 'a'..'f'])) then
       ts := '$' + S[t]
     else
       ts := '$' + S[t] + S[t + 1];
     Val(ts, M, Code);
     if Code = 0 then
       Result := Result + Chr(M);
     inc(t, 2);
  end;
end;

end.
