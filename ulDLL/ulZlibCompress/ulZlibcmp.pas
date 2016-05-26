unit ulZlibcmp;

interface

uses
  ZLib, Forms, Classes, SysUtils;

  function _GetAppRunpath: string;
  function FormatFilepathDir(Filepath: string): string;
  procedure CheckFilepathDir(Filepath: string);
  function GetFileExtensionName(FileName: string): string;
  function CheckFileExtensionName(FileName, ExtName: string): Boolean;

   //压缩流
  procedure CompressionStream(var ASrcStream:TMemoryStream;ACompressionLevel:Integer = 2);
  //解压缩
  procedure UnCompressionStream(var ASrcStream:TMemoryStream);

  //获取文件压缩流
  procedure GetFileCmpStream(FileName: string; var ACmpStream: TMemoryStream; ACmpLevel: Integer = 2);stdcall;
  //获取文件解压缩流
  procedure GetFileUnCmpStream(FileName: string; var AUnCmpStream: TMemoryStream);stdcall;

  //压缩文件保存为文件
  function SaveCmpFileToFile(FileName: string; SaveName: string; sSavepath: string = '';
     CmpLevel: Integer = 2): Boolean;stdcall;
  //解压缩文件保存为文件
  function SaveUnCmpFileToFile(FileName: string; SaveName: string; sSavepath: string = ''): Boolean;stdcall;

implementation

function _GetAppRunpath: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

function FormatFilepathDir(Filepath: string): string;
begin
  if Filepath[Length(Filepath)] = '\' then
    Result := Filepath
  else
    Result := Filepath + '\';
end;

procedure CheckFilepathDir(Filepath: string);
begin
  if not DirectoryExists(Filepath) then
    ForceDirectories(Filepath);//强制创建
end;

function GetFileExtensionName(FileName: string): string;
begin
  Result := StringReplace(ExtractFileExt(FileName), '.', '', [rfReplaceAll]);
  Result := LowerCase(Result);
end;

function CheckFileExtensionName(FileName, ExtName: string): Boolean;
var
  sExt: string;
begin
  Result := False;
  sExt := GetFileExtensionName(FileName);
  Result := sExt = LowerCase(ExtName);
end;

procedure CompressionStream(var ASrcStream:TMemoryStream;ACompressionLevel:Integer = 2);
var
  nDestStream:TMemoryStream;
  nTmpStream:TCompressionStream;
  nCompressionLevel:TCompressionLevel;
begin
  ASrcStream.Position := 0;
  nDestStream := TMemoryStream.Create;
  try
    //级别
    case ACompressionLevel of
      0:nCompressionLevel := clNone;
      1:nCompressionLevel := clFastest;
      2:nCompressionLevel := clDefault;
      3:nCompressionLevel := clMax;
    else
      nCompressionLevel := clMax;
    end;
    //开始压缩
    nTmpStream := TCompressionStream.Create(nCompressionLevel,nDestStream);
    try
      ASrcStream.SaveToStream(nTmpStream);
    finally
      nTmpStream.Free;//释放后nDestStream才会有数据
    end;
    ASrcStream.Clear;
    ASrcStream.LoadFromStream(nDestStream);
    ASrcStream.Position := 0;
  finally
    nDestStream.Clear;
    nDestStream.Free;
  end;
end;

procedure UnCompressionStream(var ASrcStream:TMemoryStream); //解压缩
var
  nTmpStream:TDecompressionStream;
  nDestStream:TMemoryStream;
  nBuf: array[1..512] of Byte;
  nSrcCount: integer;
begin
  ASrcStream.Position := 0;
  nDestStream := TMemoryStream.Create;
  nTmpStream := TDecompressionStream.Create(ASrcStream);
  try
    repeat
      //读入实际大小
      nSrcCount := nTmpStream.Read(nBuf, SizeOf(nBuf));
      if nSrcCount > 0 then
        nDestStream.Write(nBuf, nSrcCount);
    until (nSrcCount = 0);
    ASrcStream.Clear;
    ASrcStream.LoadFromStream(nDestStream);
    ASrcStream.Position := 0;
  finally
    nDestStream.Clear;
    nDestStream.Free;
    nTmpStream.Free;
  end;
end;

procedure GetFileCmpStream(FileName: string; var ACmpStream: TMemoryStream; ACmpLevel: Integer = 2);
begin
  ACmpStream.LoadFromFile(FileName);
  CompressionStream(ACmpStream, ACmpLevel);
end;

procedure GetFileUnCmpStream(FileName: string; var AUnCmpStream: TMemoryStream);
begin
  AUnCmpStream.LoadFromFile(FileName);
  UnCompressionStream(AUnCmpStream);
end;

function SaveCmpFileToFile(FileName: string; SaveName: string; sSavepath: string = '';
  CmpLevel: Integer = 2): Boolean;
var
  CmpStream: TMemoryStream;    
begin
  Result := False;
  if not FileExists(FileName) then
  begin
    Exit;
  end;
  if sSavepath = '' then
    sSavepath := _GetAppRunpath + 'TempCmpFile\';
  CmpStream := TMemoryStream.Create;
  try
    try
      CmpStream.LoadFromFile(FileName);
      CompressionStream(CmpStream, CmpLevel);
      CheckFilepathDir(sSavepath);
      CmpStream.SaveToFile(FormatFilepathDir(sSavepath)+SaveName);
      Result := FileExists(FormatFilepathDir(sSavepath)+SaveName);
    except
      Result := False;
    end;
  finally
    CmpStream.Free;
  end;
end;

function SaveUnCmpFileToFile(FileName: string; SaveName: string; sSavepath: string = ''): Boolean;
var
  CmpStream: TMemoryStream;
begin
  Result := False;
  if not FileExists(FileName) then
  begin
    Exit;
  end;
  if sSavepath = '' then
    sSavepath := _GetAppRunpath + 'TempUnCmpFile\';
  CmpStream := TMemoryStream.Create;
  try
    try
      CmpStream.LoadFromFile(FileName);
      UnCompressionStream(CmpStream);
      CheckFilepathDir(sSavepath);
      CmpStream.SaveToFile(FormatFilepathDir(sSavepath)+SaveName);
      Result := FileExists(FormatFilepathDir(sSavepath)+SaveName);
    except
      Result := False;
    end;
  finally
    CmpStream.Free;
  end;
end;

end.
