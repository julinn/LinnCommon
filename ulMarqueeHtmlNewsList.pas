unit ulMarqueeHtmlNewsList;

{
  Linn
  2013-10-15 
  ====
  function GetMarqueeHtml(sDataList: string): string;
  function GetFmtData(sTitle, sUrl: string; sHint: string = ''): string;
  function GetDataList_ByKbmTable(kbmTable: TkbmMemTable): string;
  procedure LoadHTMLToWebBrowser(WebBrowser: TWebBrowser; HTMLCode: string) ;
}

interface

uses
  SysUtils, kbmMemTable, SHDocVw, ActiveX, Forms, Classes;

const
  cFmtData = '<li><a href="%s" target="_blank" title="%s">%s</a></li>';
  cHtml =
  '<style>'+#13#10
  +'*{margin:0px;padding:0px;border:0px;}'+#13#10
  +'body{font-size:12px; border:0px; overflow:hidden;}'+#13#10
  +'#demo1{'+#13#10
  +'height:auto;'+#13#10
  +'text-align:left;'+#13#10
  +'}'+#13#10
  +'#demo2{'+#13#10
  +'height:auto;'+#13#10
  +'text-align:left;'+#13#10
  +'}'+#13#10
  +'#demo1  li{'+#13#10
  +'list-style-type:none;'+#13#10
  +'height:22px;'+#13#10
  +'background:url() no-repeat left center;'+#13#10
  +'text-align:left;'+#13#10
  +'text-indent:15px;'+#13#10
  +'}'+#13#10
  +'#demo2  li{'+#13#10
  +'list-style-type:none;'+#13#10
  +'height:22px;'+#13#10
  +'background:url() no-repeat left center;'+#13#10
  +'text-align:left;'+#13#10
  +'text-indent:15px;'+#13#10
  +'}'+#13#10
  +'</style>'+#13#10
  +'<div id="demo" style="overflow:hidden;height:%dpx;width:%dpx;">'+#13#10
  +'<div id="demo1">'+#13#10
  +'<ul>'+#13#10
  +'%s'
  +'</ul>'+#13#10
  +'</div>'+#13#10
  +'<div id="demo2"></div>'+#13#10
  +'</div>'+#13#10
  +'<script>'
  +'var speed=%d'+#13#10
  +'var demo=document.getElementById("demo");'+#13#10
  +'var demo2=document.getElementById("demo2");'+#13#10
  +'var demo1=document.getElementById("demo1");'+#13#10
  +'demo2.innerHTML=demo1.innerHTML'+#13#10
  +'function Marquee(){'+#13#10
  +'if(demo2.offsetTop-demo.scrollTop<=0)'+#13#10
  +'  demo.scrollTop-=demo1.offsetHeight'+#13#10
  +'else{'+#13#10
  +'  demo.scrollTop++'+#13#10
  +'}'+#13#10
  +'}'+#13#10
  +'var MyMar=setInterval(Marquee,speed)'+#13#10
  +'demo.onmouseover=function() {clearInterval(MyMar)}'+#13#10
  +'demo.onmouseout=function() {MyMar=setInterval(Marquee,speed)}'+#13#10
  +'</script>';

  cTestDataList =
   '<li><a href="http://www.cnhis.com" target="_blank" title="XP Menu ��QQ�˵����������˵�">XP Menu ��QQ�˵����������˵�</a></li> '
  +'<li><a href="http://www.cnhis.com" target="_blank" title="���Ƕ�׵�һ����չ��">���Ƕ�׵�һ����չ��</a></li> '
  +'<li><a href="http://www.cnhis.com" target="_blank" title="��Java2���ļ�����2:�߼����ԡ���7��">��Java2���ļ�����2:�߼����ԡ���7��</a></li> '
  +'<li><a href="http://www.cnhis.com" target="_blank" title="CSS��HTML�̴̳������ (CHM)">CSS��HTML�̴̳������ (CHM)</a></li> '
  +'<li><a href="http://www.cnhis.com" target="_blank" title="��C++ Primer�����ĵ��İ� chm">��C++ Primer�����ĵ��İ� chm</a></li> '
  +'<li><a href="http://www.cnhis.com" target="_blank" title="C++���ʹ���ϵͳ(Access)">C++���ʹ���ϵͳ(Access)</a></li> '
  +'<li><a href="http://www.cnhis.com" target="_blank" title="�ǳ�ţ�������JS�۵��˵�">�ǳ�ţ�������JS�۵��˵�</a></li> ';

function GetMarqueeHtml(sDataList: string; iSpeed: Integer = 60;
  iDemoHeight: Integer = 80; iDemoWidth: Integer = 280): string;
function GetFmtData(sTitle, sUrl: string; sHint: string = ''): string;
function GetDataList_ByKbmTable(kbmTable: TkbmMemTable): string;
procedure LoadHTMLToWebBrowser(WebBrowser: TWebBrowser; HTMLCode: string) ;

implementation

function GetMarqueeHtml(sDataList: string; iSpeed: Integer = 60;
  iDemoHeight: Integer = 80; iDemoWidth: Integer = 280): string;
begin
  Result := Format(cHtml, [iDemoHeight, iDemoWidth, sDataList, iSpeed]);
end;

function GetFmtData(sTitle, sUrl: string; sHint: string = ''): string;
begin
  sTitle := StringReplace(sTitle, '''', '"', [rfReplaceAll]);
  Result := Format(cFmtData, [sUrl, sHint, sTitle]);
end;

function GetDataList_ByKbmTable(kbmTable: TkbmMemTable): string;
var
  s, sTitle, sUrl, sHint: string;
begin
  Result := '';
  if kbmTable.IsEmpty then
    Exit;
  try
    kbmTable.First;
    while not kbmTable.Eof do
    begin
      sTitle := kbmTable.FieldByName('TITLE').AsString;
      sUrl := kbmTable.FieldByName('URL').AsString;
      sHint := kbmTable.FieldByName('HINT').AsString;
      s := GetFmtData(sTitle, sUrl, sHint);
      Result := Result + s;
      kbmTable.Next;
    end;
  except
    Result := '';
  end;
end;

procedure LoadHTMLToWebBrowser(WebBrowser: TWebBrowser; HTMLCode: string) ;
var
   sl: TStringList;
   ms: TMemoryStream;
begin
   WebBrowser.Navigate('about:blank') ;
   while WebBrowser.ReadyState < READYSTATE_INTERACTIVE do
    Application.ProcessMessages;

   if Assigned(WebBrowser.Document) then
   begin
     sl := TStringList.Create;
     try
       ms := TMemoryStream.Create;
       try
         sl.Text := HTMLCode;
         sl.SaveToStream(ms) ;
         ms.Seek(0, 0) ;
         (WebBrowser.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms)) ;
       finally
         ms.Free;
       end;
     finally
       sl.Free;
     end;
   end;
end;

end.
