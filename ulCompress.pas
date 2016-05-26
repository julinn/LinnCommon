unit ulCompress;

interface

uses
  Classes, Graphics, SysUtils, Forms, ZLib, jpeg;

  //��ȡ��������·��
  function GetAppRunPath: string;
  function _FormatFileDir(sPath: string): string;
  //����ļ���·���Ƿ���ڣ�����������򴴽��ļ���·��
  procedure CheckFilePath(sFilePath: string);
  //��ȡ�ļ���չ����������.��
  function _GetFileType(FileName: string): string;
  //����ļ���չ���Ƿ����Ҫ��
  function _CheckFileType(FileName: string; sType: string = 'bmp'): Boolean;
  //ѹ��BMP
  procedure _CompressBitmap(var CompressedStream: TMemoryStream;const CompressionLevel: TCompressionLevel);
  //��ѹBMP
  procedure _UnCompressBitmap(const CompressedStream: TFileStream; var Bmp: TBitmap);
  //��ȡBMPͼƬѹ����
  function GetBitmapCompressStream(var CmpStream: TMemoryStream; FileName: string): Boolean;
  //��ѹJPG
  procedure _UnCompressJpg(const CompressedStream: TFileStream; var jpg: TJPEGImage);
  //�����ڴ������ݵ��ļ�  SavePath ĩβ��������\��
  function SaveMemoryStreamToFile(CmpStream: TMemoryStream; sSaveName: string; sSavePath: string = ''): Boolean;
  //��ȡJPGͼƬѹ����
  function GetJpgCompressStream(var CmpStream: TMemoryStream; FileName: string): Boolean;

  //ѹ����
  procedure _CompressionStream(var ASrcStream:TMemoryStream;ACompressionLevel:Integer = 2);
  //��ѹ��
  procedure _UnCompressionStream(var ASrcStream:TMemoryStream);

  {******************** BMP���� ***************}
  //��ԭ��ѹ����BMPͼƬ
  function GetBitmapPictrue(var Bmp: TBitmap; CmpFileName: string ): Boolean; 
  //����Ҫѹ����ͼƬ���ļ�  1��Ҫѹ����ͼƬ�� 2��ѹ���󱣴�����ƣ� 3������·��
  function SaveCmpBitmapToFile(FileName: string; SaveName: string; sSavePath: string = ''): Boolean;
  
  {******************** JPG���� ***************}
  //��ԭ��ѹ����JPGͼƬ
  function GetJpgPictrue(var Jpg: TJPEGImage; CmpFileName: string): Boolean;
  //����Ҫѹ����ͼƬ���ļ� 1��Ҫѹ����ͼƬ�� 2��ѹ���󱣴�����ƣ� 3������·��
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
    ForceDirectories(sFilePath);//ǿ�ƴ���
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
  // ���ͼ������ԭʼ�ߴ�
  Count := CompressedStream.Size;
  DestStream := TMemoryStream.Create;
  SourceStream:=TCompressionStream.Create(CompressionLevel, DestStream);
  Try
    //SourceStream �б�����ԭʼ��ͼ����
    CompressedStream.SaveToStream(SourceStream);
    // ��ԭʼͼ��������ѹ�� , DestStream �б�����ѹ�����ͼ����
    SourceStream.Free;
    CompressedStream.Clear;
    // д��ԭʼͼ��ĳߴ�
    CompressedStream.WriteBuffer(Count, SizeOf(Count));
    // д�뾭��ѹ����ͼ����
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
  // �ӱ�ѹ����ͼ�����ж���ԭʼͼ��ĳߴ�
  CompressedStream.ReadBuffer(Count, SizeOf(Count));
  // ����ͼ��ߴ��СΪ��Ҫ�����ԭʼͼ���������ڴ��
  GetMem(Buffer, Count);
  DestStream := TMemoryStream.Create;
  SourceStream := TDecompressionStream.Create(CompressedStream);
  Try
    // ����ѹ����ͼ������ѹ�� ,Ȼ�����  Buffer �ڴ����
    SourceStream.ReadBuffer(Buffer^, Count);
    // ��ԭʼͼ����������  DestStream ����
    DestStream.WriteBuffer(Buffer^, Count);
    DestStream.Position := 0;// ��λ��ָ��
    // ��  DestStream ��������ԭʼͼ����
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
    // ��  Bmp �����е�ͼ�񱣴����ڴ�����
    Bmp.SaveToStream(CmpStream);
    // ��ȱʡ��ѹ��������ԭʼͼ��������ѹ��
    _CompressBitmap(CmpStream, clDefault);
    // ��ѹ��֮���ͼ��������Ϊ�Զ����ʽ���ļ�
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
  // �ӱ�ѹ����ͼ�����ж���ԭʼͼ��ĳߴ�
  CompressedStream.ReadBuffer(Count, SizeOf(Count));
  // ����ͼ��ߴ��СΪ��Ҫ�����ԭʼͼ���������ڴ��
  GetMem(Buffer, Count);
  DestStream := TMemoryStream.Create;
  SourceStream := TDecompressionStream.Create(CompressedStream);
  Try
    // ����ѹ����ͼ������ѹ�� ,Ȼ�����  Buffer �ڴ����
    SourceStream.ReadBuffer(Buffer^, Count);
    // ��ԭʼͼ����������  DestStream ����
    DestStream.WriteBuffer(Buffer^, Count);
    DestStream.Position := 0;// ��λ��ָ��
    // ��  DestStream ��������ԭʼͼ����
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
    //����
    case ACompressionLevel of
      0:nCompressionLevel := clNone;
      1:nCompressionLevel := clFastest;
      2:nCompressionLevel := clDefault;
      3:nCompressionLevel := clMax;
    else
      nCompressionLevel := clMax;
    end;
    //��ʼѹ��
    nTmpStream := TCompressionStream.Create(nCompressionLevel,nDestStream);
    try
      ASrcStream.SaveToStream(nTmpStream);
    finally
      nTmpStream.Free;//�ͷź�nDestStream�Ż�������
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
      //����ʵ�ʴ�С
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
  // ���ļ�����ֻ����ʽ���Զ����ѹ����ʽ�ļ�
  CompressedStream := TFileStream.Create(CmpFileName , fmOpenRead);
  Try
    // ����ѹ����ͼ�������н�ѹ��
    _UnCompressBitmap(CompressedStream, Bmp);
    // ��ԭʼͼ������ԭΪָ����  BMP �ļ�
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
    // ����ѹ����ͼ�������н�ѹ��
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
