unit ulCompress;

interface

uses
  Classes, Graphics, SysUtils, Forms, ZLib, jpeg;

  //获取程序运行路径
  function GetAppRunPath: string;
  function _FormatFileDir(sPath: string): string;
  //检查文件夹路径是否存在，如果不存在则创建文件夹路径
  procedure CheckFilePath(sFilePath: string);
  //获取文件拓展名，不带【.】
  function _GetFileType(FileName: string): string;
  //检查文件拓展名是否符合要求
  function _CheckFileType(FileName: string; sType: string = 'bmp'): Boolean;
  //压缩BMP
  procedure _CompressBitmap(var CompressedStream: TMemoryStream;const CompressionLevel: TCompressionLevel);
  //解压BMP
  procedure _UnCompressBitmap(const CompressedStream: TFileStream; var Bmp: TBitmap);
  //获取BMP图片压缩流
  function GetBitmapCompressStream(var CmpStream: TMemoryStream; FileName: string): Boolean;
  //解压JPG
  procedure _UnCompressJpg(const CompressedStream: TFileStream; var jpg: TJPEGImage);
  //保存内存流数据到文件  SavePath 末尾不包含【\】
  function SaveMemoryStreamToFile(CmpStream: TMemoryStream; sSaveName: string; sSavePath: string = ''): Boolean;
  //获取JPG图片压缩流
  function GetJpgCompressStream(var CmpStream: TMemoryStream; FileName: string): Boolean;

  //压缩流
  procedure _CompressionStream(var ASrcStream:TMemoryStream;ACompressionLevel:Integer = 2);
  //解压缩
  procedure _UnCompressionStream(var ASrcStream:TMemoryStream);

  {******************** BMP操作 ***************}
  //还原已压缩的BMP图片
  function GetBitmapPictrue(var Bmp: TBitmap; CmpFileName: string ): Boolean; 
  //保存要压缩的图片到文件  1，要压缩的图片； 2，压缩后保存的名称； 3，保存路径
  function SaveCmpBitmapToFile(FileName: string; SaveName: string; sSavePath: string = ''): Boolean;
  
  {******************** JPG操作 ***************}
  //还原已压缩的JPG图片
  function GetJpgPictrue(var Jpg: TJPEGImage; CmpFileName: string): Boolean;
  //保存要压缩的图片到文件 1，要压缩的图片； 2，压缩后保存的名称； 3，保存路径
  function SaveCmpJpgToFile(FileName: string; SaveName: string; sSavePath: string = ''): Boolean;

implementation

//
function GetAppRunPath: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

function _FormatFileDir(sPath: string): string;
var
  s: string;
begin
  s := Copy(sPath, Length(sPath), 1);     
  if s = '\' then
    Result := sPath
  else
    Result := sPath + '\';
end;

procedure CheckFilePath(sFilePath: string);
begin
  if not DirectoryExists(sFilePath) then
    ForceDirectories(sFilePath);//强制创建
end;

function _GetFileType(FileName: string): string;
begin
  Result := StringReplace(ExtractFileExt(FileName), '.', '', [rfReplaceAll]);
end;

function _CheckFileType(FileName: string; sType: string = 'bmp'): Boolean;
var
  s: string;
begin
  Result := False;
  if not FileExists(FileName) then
    Exit;
  s := _GetFileType(FileName);
  if UpperCase(s) = UpperCase(sType) then
    Result := True;
end;

procedure _CompressBitmap(var CompressedStream: TMemoryStream;const CompressionLevel: TCompressionLevel);
var
  SourceStream: TCompressionStream;
  DestStream: TMemoryStream;
  Count: Integer;
Begin
  // 获得图像流的原始尺寸
  Count := CompressedStream.Size;
  DestStream := TMemoryStream.Create;
  SourceStream:=TCompressionStream.Create(CompressionLevel, DestStream);
  Try
    //SourceStream 中保存着原始的图像流
    CompressedStream.SaveToStream(SourceStream);
    // 将原始图像流进行压缩 , DestStream 中保存着压缩后的图像流
    SourceStream.Free;
    CompressedStream.Clear;
    // 写入原始图像的尺寸
    CompressedStream.WriteBuffer(Count, SizeOf(Count));
    // 写入经过压缩的图像流
    CompressedStream.CopyFrom(DestStream, 0);
  finally
    DestStream.Free;
  end;
end;

procedure _UnCompressBitmap(const CompressedStream: TFileStream; var Bmp: TBitmap);
var
  SourceStream: TDecompressionStream;
  DestStream: TMemoryStream;
  Buffer: PChar;
  Count: Integer;
Begin
  // 从被压缩的图像流中读出原始图像的尺寸
  CompressedStream.ReadBuffer(Count, SizeOf(Count));
  // 根据图像尺寸大小为将要读入的原始图像流分配内存块
  GetMem(Buffer, Count);
  DestStream := TMemoryStream.Create;
  SourceStream := TDecompressionStream.Create(CompressedStream);
  Try
    // 将被压缩的图像流解压缩 ,然后存入  Buffer 内存块中
    SourceStream.ReadBuffer(Buffer^, Count);
    // 将原始图像流保存至  DestStream 流中
    DestStream.WriteBuffer(Buffer^, Count);
    DestStream.Position := 0;// 复位流指针
    // 从  DestStream 流中载入原始图像流
    Bmp.LoadFromStream(DestStream);
  finally
    FreeMem(Buffer);
    DestStream.Free;
  end;
end;

function GetBitmapCompressStream(var CmpStream: TMemoryStream; FileName: string): Boolean;
var
  Bmp: TBitmap;
begin
  Result := False;
  if not _CheckFileType(FileName) then
    Exit;
  Bmp := TBitmap.Create;
  Try
    Bmp.LoadFromFile(FileName);
    // 将  Bmp 对象中的图像保存至内存流中
    Bmp.SaveToStream(CmpStream);
    // 按缺省的压缩比例对原始图像流进行压缩
    _CompressBitmap(CmpStream, clDefault);
    // 将压缩之后的图像流保存为自定义格式的文件
    //CmpStream.SaveToFile('E:\DelphiObjects\ZlibApp\Img\cj.dat');
    Result := True;
  finally
    Bmp.Free;
  end;
end;

procedure _UnCompressJpg(const CompressedStream: TFileStream; var jpg: TJPEGImage);
var
  SourceStream: TDecompressionStream;
  DestStream: TMemoryStream;
  Buffer: PChar;
  Count: Integer;
Begin
  // 从被压缩的图像流中读出原始图像的尺寸
  CompressedStream.ReadBuffer(Count, SizeOf(Count));
  // 根据图像尺寸大小为将要读入的原始图像流分配内存块
  GetMem(Buffer, Count);
  DestStream := TMemoryStream.Create;
  SourceStream := TDecompressionStream.Create(CompressedStream);
  Try
    // 将被压缩的图像流解压缩 ,然后存入  Buffer 内存块中
    SourceStream.ReadBuffer(Buffer^, Count);
    // 将原始图像流保存至  DestStream 流中
    DestStream.WriteBuffer(Buffer^, Count);
    DestStream.Position := 0;// 复位流指针
    // 从  DestStream 流中载入原始图像流
    jpg.LoadFromStream(DestStream);
  finally
    FreeMem(Buffer);
    DestStream.Free;
  end;
end;

function GetJpgCompressStream(var CmpStream: TMemoryStream; FileName: string): Boolean;
var
  Jpg: TJPEGImage;
begin
  Result := False;
  if not _CheckFileType(FileName, 'jpg') then
    Exit;
  Jpg := TJPEGImage.Create;
  Try
    Jpg.LoadFromFile(FileName);
    Jpg.SaveToStream(CmpStream);
    _CompressBitmap(CmpStream, clDefault);
    Result := True;
  finally
    Jpg.Free;
  end;
end;

procedure _CompressionStream(var ASrcStream:TMemoryStream;ACompressionLevel:Integer = 2);
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

procedure _UnCompressionStream(var ASrcStream:TMemoryStream);
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
    until
      (nSrcCount = 0);
    ASrcStream.Clear;
    ASrcStream.LoadFromStream(nDestStream);
    ASrcStream.Position := 0;
  finally
    nDestStream.Clear;
    nDestStream.Free;
    nTmpStream.Free;
  end;
end;

function GetBitmapPictrue(var Bmp: TBitmap; CmpFileName: string ): Boolean;
var
  CompressedStream: TFileStream;
begin
  Result := False;
  // 以文件流的只读方式打开自定义的压缩格式文件
  CompressedStream := TFileStream.Create(CmpFileName , fmOpenRead);
  Try
    // 将被压缩的图像流进行解压缩
    _UnCompressBitmap(CompressedStream, Bmp);
    // 将原始图像流还原为指定的  BMP 文件
    //Bmp.SaveToFile('E:\DelphiObjects\ZlibApp\Img\cj.bmp' );
    Result := True;
  finally
    //Bmp.Free;
    CompressedStream.Free;
  end;
end;

function SaveMemoryStreamToFile(CmpStream: TMemoryStream; sSaveName: string; sSavePath: string = ''): Boolean;
begin
  Result := False;
  if sSavePath = '' then
    sSavePath := GetAppRunPath + 'CompressFile';
  CheckFilePath(sSavePath);
  CmpStream.SaveToFile(_FormatFileDir(sSavePath)+ sSaveName);
  Result := True;
end;

function SaveCmpBitmapToFile(FileName: string; SaveName: string; sSavePath: string = ''): Boolean;
var
  CompressedStream: TMemoryStream;
begin
  Result := False;
  CompressedStream := TMemoryStream.Create;
  try
    GetBitmapCompressStream(CompressedStream, FileName);
    Result := SaveMemoryStreamToFile(CompressedStream, SaveName, sSavePath);
  finally
    CompressedStream.Free;
  end;
end;

function GetJpgPictrue(var Jpg: TJPEGImage; CmpFileName: string): Boolean;
var
  CompressedStream: TFileStream;
begin
  Result := False;
  CompressedStream := TFileStream.Create(CmpFileName , fmOpenRead);
  Try
    // 将被压缩的图像流进行解压缩
    _UnCompressJpg(CompressedStream, Jpg);
    Result := True;
  finally
    CompressedStream.Free;
  end;
end;

function SaveCmpJpgToFile(FileName: string; SaveName: string; sSavePath: string = ''): Boolean;
var
  CompressedStream: TMemoryStream;
begin
  Result := False;
  CompressedStream := TMemoryStream.Create;
  try
    GetJpgCompressStream(CompressedStream, FileName);
    Result := SaveMemoryStreamToFile(CompressedStream, SaveName, sSavePath);
  finally
    CompressedStream.Free;
  end;
end;
end.
