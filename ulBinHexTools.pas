unit ulBinHexTools;

interface

function HexToBin(HexNr : string): string; //把十六进制字符串转换为二进制字符串
function HexCharToInt(HexToken : char):Integer; //转换一个十六进制字符为整数
function HexCharToBin(HexToken : char): string;//转换一个十六进制字符为二进制字符串
function pow(base, power: integer): integer;//指数函数
function BinStrToInt(BinStr : string) : integer;//把二进制字符串转换为整数
function DecodeSMS7Bit(PDU : string):string;// 解码一个7-bit SMS (GSM 03.38) 为ASCII码
function ReverseStr(SourceStr : string) : string; //反转一个字符串
function StrToHexStr(const S: string): string;//字符串转换成16进制字符串
function HexStrToStr(const S: string): string;//16进制字符串转换成字符串
//
function SimpleEnc(sStr: string): string;

implementation

uses sysutils, dialogs;  

function HexCharToInt(HexToken : char):Integer;  
begin  
   {if HexToken>#97 then HexToken:=Chr(Ord(HexToken)-32);  
   { use lowercase aswell }    
   Result:=0;
   if (HexToken>#47) and (HexToken<#58) then { chars 0....9 }
     Result:=Ord(HexToken)-48
   else if (HexToken>#64) and (HexToken<#71) then { chars A....F }
     Result:=Ord(HexToken)-65 + 10;
end;

function HexCharToBin(HexToken : char): string;
var DivLeft : integer;
begin
   DivLeft:=HexCharToInt(HexToken); { first HEX->BIN }
   Result:='';
   { Use reverse dividing }
   repeat { Trick; divide by 2 }
   if odd(DivLeft) then { result = odd ? then bit = 1 }
     Result:='1'+Result { result = even ? then bit = 0 }
   else
     Result:='0'+Result;
     DivLeft:=DivLeft div 2; { keep dividing till 0 left and length = 4 }
   until (DivLeft=0) and (length(Result)=4); { 1 token = nibble = 4 bits }
end;

function HexToBin(HexNr : string): string;  
{ only stringsize is limit of binnr }  
var Counter : integer;  
begin
   Result:='';
   for Counter:=1 to length(HexNr) do
     Result:=Result+HexCharToBin(HexNr[Counter]);
end;

function pow(base, power: integer): integer;  
var counter : integer;  
begin  
   Result:=1;
   for counter:=1 to power do  
     Result:=Result*base;
end;  

function BinStrToInt(BinStr : string) : integer;  
var counter : integer;  
begin  
   if length(BinStr)>16 then  
   raise ERangeError.Create(#13+BinStr+#13+  
   'is not within the valid range of a 16 bit binary.'+#13);
   Result:=0;
   for counter:=1 to length(BinStr) do  
     if BinStr[Counter]='1' then
       Result:=Result+pow(2,length(BinStr)-counter);
end;  

function DecodeSMS7Bit(PDU : string):string;  
var
   OctetStr : string;  
   OctetBin : string;  
   Charbin : string;  
   PrevOctet: string;  
   Counter : integer;  
   Counter2 : integer;  
begin  
   PrevOctet:='';  
   Result:='';  

   for Counter:=1 to length(PDU) do  
   begin  
     if length(PrevOctet)>=7 then { if 7 Bit overflow on previous }
     begin  
       if BinStrToInt(PrevOctet)<>0 then
         Result:=Result+Chr(BinStrToInt(PrevOctet))
       else Result:=Result+' ';

       PrevOctet:='';
     end;  

     if Odd(Counter) then { only take two nibbles at a time }  
     begin  
       OctetStr:=Copy(PDU,Counter,2);
       OctetBin:=HexToBin(OctetStr);

       Charbin:='';
       for Counter2:=1 to length(PrevOctet) do
         Charbin:=Charbin+PrevOctet[Counter2];

       for Counter2:=1 to 7-length(PrevOctet) do  
         Charbin:=OctetBin[8-Counter2+1]+Charbin;

       if BinStrToInt(Charbin)<>0 then Result:=Result+Chr(BinStrToInt(CharBin))  
       else Result:=Result+' ';  

       PrevOctet:=Copy(OctetBin,1,length(PrevOctet)+1);
     end;
   end;  
end;  

function ReverseStr(SourceStr : string) : string;  
var Counter : integer;  
begin  
   Result:='';
   for Counter:=1 to length(SourceStr) do  
     Result:=SourceStr[Counter]+Result;
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

function SimpleEnc(sStr: string): string;
var
  s: string;
begin
  s := StrToHexStr(sStr);
end;

end.
