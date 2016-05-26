unit ulLoadDLL;

{
使用说明示例:

【一】
//定义一个函数类型，注意一点过程类型种的参数应该与DLL
type
  Tmyfun = function (a,b:integer):Integer; stdcall;

【二】
//声明变量
var
myhandle:THandle;
FPointer:Pointer;
Myfun :Tmyfun;

if  GetDllHandl（DllName, FuncName, myhandle, FPointer) then
begin
  Myfun := Tmyfun(FPointer);
  //
  Result := Myfun (a, b);
end;

}

interface

uses
  Windows, Forms, SysUtils;

  function GetDllHandl(DllName, FuncName: string; var DllHandle: THandle; var FuncPointer: Pointer;
    sDllPath: string = ''): Boolean;
  procedure FreeDll(DllHandle: THandle);
  function _GetAppRunPath(sAppPath: string = ''): string;

implementation

function _GetAppRunPath(sAppPath: string = ''): string;
var
  s, stemp: string;
begin
  if sAppPath = '' then
    s := ExtractFilePath(Application.ExeName)
  else
    s := sAppPath;
  stemp := Copy(s, Length(s), 1);
  if s = '\' then
    Result := s
  else
    Result := s + '\';
end;

function GetDllHandl(DllName,FuncName: string; var DllHandle: THandle; var FuncPointer: Pointer;
  sDllPath: string = ''): Boolean;
begin
  Result := False;
  sDllPath := _GetAppRunPath(sDllPath) + DllName;
  try
    DllHandle := LoadLibrary(PChar(sDllPath));
    if DllHandle > 0 then
    begin
      try
        FuncPointer := GetProcAddress(DllHandle, PChar(FuncName));
        if FuncPointer <> nil then
          Result := True
        else
        begin   
          FreeLibrary(DllHandle);
          Result := False;
        end;
      except
        FreeLibrary(DllHandle);
        Result := False;
      end;
    end
    else
      Result := False;
  except
    Result := False;
  end;  
end;

procedure FreeDll(DllHandle: THandle);
begin
  FreeLibrary(DllHandle);
end;

end.
