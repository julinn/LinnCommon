unit ulImageConvert;

interface

uses
  Graphics, jpeg, Types;

function BmpToJpg(SrcFileName,DestFileName:AnsiString): Boolean;
function JpgToBmp(SrcFileName,DestFileName:AnsiString): Boolean;
function CreateJpgMinViewImage(SourceFileName,DescFileName: String;
  MaxWidth: Integer = 200; MaxHigth: Integer = 200): Boolean;
function CreateBmpMinViewImage(SourceFileName,DescFileName: String;
  MaxWidth: Integer = 200; MaxHigth: Integer = 200): Boolean;


implementation

function BmpToJpg(SrcFileName,DestFileName:AnsiString): Boolean;
var
  JpgFile: TJPEGImage;
  BitFile: TBitmap;
begin
  Result := False;
  JpgFile:=TJPEGImage.Create();
  BitFile:=TBitmap.Create();
  try
    try
      BitFile.LoadFromFile(SrcFileName);
      JpgFile.Width:=BitFile.Width;
      JpgFile.Height:=BitFile.Height;
      JpgFile.Assign(BitFile);
      JpgFile.SaveToFile(DestFileName);
      Result := True;
    except
      Result := False;
    end;
  finally
    BitFile.Free;
    JpgFile.Free;
  end;
end;

function JpgToBmp(SrcFileName,DestFileName:AnsiString): Boolean;
var
  JpgFile: TJPEGImage;
  BitFile: TBitmap;
begin
  //把jpg格式的文件转换成为Bmp格式
  Result := False;
  JpgFile:=TJPEGImage.Create();
  BitFile:=TBitmap.Create();
  try
    try
      JpgFile.LoadFromFile(SrcFileName);
      BitFile.Width:=JpgFile.Width;
      BitFile.Height:=JpgFile.Height;
      BitFile.Assign(JpgFile);
      BitFile.SaveToFile(DestFileName);
      Result := True;
    except
      Result := False;
    end;
  finally
    BitFile.Free;
    JpgFile.Free;
  end; 
end;

function CreateJpgMinViewImage(SourceFileName,DescFileName: String;
  MaxWidth: Integer = 200; MaxHigth: Integer = 200): Boolean;
var
   jpg: TJPEGImage;
   bmp: TBitmap;
   SourceJpg: TJPEGImage;
   Width, Height,tmpInt: Integer;
begin
  Result := False;
  try
    try
      bmp := TBitmap.Create;
      SourceJpg := TJPEGImage.Create;
      Jpg:= TJPEGImage.Create;
      //读取源文件
      SourceJpg.LoadFromFile(SourceFileName);
      //计算缩小比例
      if SourceJpg.Width >= SourceJpg.Height then
        tmpInt := Round(SourceJpg.Width div MaxWidth) 
      else
        tmpInt := Round(SourceJpg.Height div MaxHigth) ;
      Width  := SourceJpg.Width  div tmpInt ;
      Height := SourceJpg.Height div tmpInt ; 
      //缩小
      bmp.Width := Width;
      bmp.Height := Height;
      bmp.PixelFormat := pf24bit;
      bmp.Canvas.StretchDraw(Rect(0,0,Width,Height), SourceJpg);
      //保存
      jpg.Assign(bmp);
      jpg.SaveToFile(DescFileName);
    except
      Result := False;
    end;
  finally
    bmp.Free;
    jpg.Free;
    SourceJpg.Free;
  end;
end;

function CreateBmpMinViewImage(SourceFileName,DescFileName: String;
  MaxWidth: Integer = 200; MaxHigth: Integer = 200): Boolean;
var
   bmp, SourceBmp: TBitmap;
   Width, Height,tmpInt: Integer;
begin
  Result := False;
  try
    try
      bmp := TBitmap.Create;
      SourceBmp := TBitmap.Create;
      //读取源文件
      SourceBmp.LoadFromFile(SourceFileName);
      //计算缩小比例
      if SourceBmp.Width >= SourceBmp.Height then
        tmpInt := Round(SourceBmp.Width div MaxWidth)
      else
        tmpInt := Round(SourceBmp.Height div MaxHigth) ;
      Width  := SourceBmp.Width  div tmpInt ;
      Height := SourceBmp.Height div tmpInt ;
      //缩小
      bmp.Width := Width;
      bmp.Height := Height;
      bmp.PixelFormat := pf24bit;
      bmp.Canvas.StretchDraw(Rect(0,0,Width,Height), SourceBmp);
      //保存
      bmp.SaveToFile(DescFileName);
    except
      Result := False;
    end;
  finally
    bmp.Free;
    SourceBmp.Free;
  end;
end;

end.
