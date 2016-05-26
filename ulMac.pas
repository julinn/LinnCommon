unit ulMac;

interface

uses
  SysUtils, Windows, uMD5, ulSystem;

function _GetCPUID: string;
function _GetCnCPUID(): string;   //结果会变动
function _GetVolumeID: string;
function _EncString(sStr: string): string;
function _DecString(sStr: string): string;
//输出函数
function GetMacStr: string;
function GetRegStr(sMacStr: string): string;
function CheckRegStr(sRegStr: string): Boolean;


implementation

function _GetCPUID: string;
//const
//  CPUINFO = 'CPU制造商: %S   序列号: %x';
var
  s: array[0..19] of Char;  
  MyCpuID: Integer;
begin  
  FillChar(s, 20, 0);  
  asm  
     push ebx  
     push ecx  
     push edx  
     mov   eax, 0  
     cpuid  
     mov   dword   ptr   s[0],     ebx  
     mov   dword   ptr   s[4],     edx  
     mov   dword   ptr   s[8],     ecx  
     mov   eax,   1  
     cpuid  
     mov   MyCpuID,   edx  
     pop edx  
     pop ecx  
     pop ebx  
  end;  
  //Result := Format(CPUINFO, [s, MyCpuID]);
  Result := s + IntToStr(MyCpuID);
end;

function _GetCnCPUID(): string;
const  
  CPUINFO = '%.8x-%.8x-%.8x-%.8x';
var  
  iEax: Integer;  
  iEbx: Integer;  
  iEcx: Integer;  
  iEdx: Integer;  
begin  
  asm  
     push ebx  
     push ecx  
     push edx  
     mov   eax, 1  
     DW $A20F//cpuid  
     mov   iEax, eax  
     mov   iEbx, ebx  
     mov   iEcx, ecx  
     mov   iEdx, edx  
     pop edx  
     pop ecx  
     pop ebx  
  end;  
  Result := Format(CPUINFO, [iEax, iEbx, iEcx, iEdx]);  
end;

function _GetVolumeID: string;
var   
  vVolumeNameBuffer:   array[0..255]of   Char;
  vVolumeSerialNumber: DWORD;   
  vMaximumComponentLength:   DWORD;   
  vFileSystemFlags:   DWORD;   
  vFileSystemNameBuffer:   array[0..255]of   Char;
begin   
  if   GetVolumeInformation('C:\',   vVolumeNameBuffer,   SizeOf(vVolumeNameBuffer),   
      @vVolumeSerialNumber,   vMaximumComponentLength,   vFileSystemFlags,   
      vFileSystemNameBuffer,   SizeOf(vFileSystemNameBuffer))   then   
  begin   
      Result   :=   IntToHex(vVolumeSerialNumber,   8);   
  end;
end;

function _EncString(sStr: string): string;
begin
  Result := '';
end;

function _DecString(sStr: string): string;
begin
  Result := '';
end;

function GetMacStr: string;
var
  s, s1: string;
begin
  try
    s := uMD5.StrToMD5(_GetCPUID + '-' + _GetVolumeID);
    //32   8-8,  14- 6  18 - 4
    s1 := ulSystem.ReverseStr(Copy(s, 18, 4)) +ulSystem.ReverseStr(Copy(s, 8, 8)) + ulSystem.ReverseStr( Copy(s, 14, 6));
    Result := uMD5.StrToMD5(ReverseStr(s1));
  except
    Result := uMD5.StrToMD5('00D188059D460088F1');
  end;
end;

function GetRegStr(sMacStr: string): string;
var
  s, s1 :string;
begin
  //12345
  Result := '';
  s := ulSystem.ReverseStr(sMacStr) + uMD5.StrToMD5(sMacStr);
  s1 := ulSystem.ReverseStr(Copy(s, 18, 4)) +ulSystem.ReverseStr(Copy(s, 8, 8)) + ulSystem.ReverseStr( Copy(s, 14, 6));
  Result := uMD5.StrToMD5(ReverseStr(s1)) + uMD5.StrToMD5(sMacStr);
end;

function CheckRegStr(sRegStr: string): Boolean;
begin
  Result := GetRegStr(GetMacStr) = sRegStr;
end;

end.
