unit ulConvertColor;

interface

uses
  Math, Graphics, SysUtils;

function ConvertColorStr_16To10(ColorStr: string): Integer;
function ConvertColorStr_RGB_BGR(RGBColorStr: string): Integer;

implementation

function ConvertColorStr_16To10(ColorStr: string): Integer;
var
  i,len: integer;
  res : real;
begin
  len := length(ColorStr);
  for i := 1 to len do
  begin
    case ColorStr[i] of
     '0'..'9': res := res + strToInt(ColorStr[i]) * power(16,(len-i));
     'a'..'f': res := res + (ord(ColorStr[i]) - ord('a') + 10) * power(16,(len-i));
     'A'..'F': res := res + (ord(ColorStr[i]) - ord('A') + 10) * power(16,(len-i));
    end; 
  end;
  try
    Result := StrToIntDef(FloatToStr(res), 0)
  except
    Result := 0;
  end;
end;

function ConvertColorStr_RGB_BGR(RGBColorStr: string): Integer;
var
  s, s1: string;
begin
  s := StringReplace(RGBColorStr, '#', '', [rfReplaceAll]);
  s1 := '$' + Copy(s, 5, 2) + Copy(s, 3, 2) + Copy(s, 1, 2);
  try
    Result := StringToColor(s1);
  except
    Result := 0;
  end;
end;

end.
