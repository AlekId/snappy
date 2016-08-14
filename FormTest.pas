unit FormTest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,

  // the following units are not used in Snappy, them are provided for a base benchmark;
  // you can delete them into your Snappy code
  SynLZ, SynCommons; // from Synopse mORMot Framework

type
  TTest = class(TForm)
    Compress: TButton;
    Uncompress: TButton;
    chkSynLZ: TCheckBox;
    Memo1: TMemo;
    procedure CompressClick(Sender: TObject);
    procedure UncompressClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Test: TTest;

implementation

{$R *.dfm}

uses Snappy;

const
  COUNT = 10000;
  FILE_TEST = 'C:\nanoserver\json.txt'; // a 50kb file, ecommerce web order

procedure TTest.CompressClick(Sender: TObject); // I did a test with 1GB vhd file, works md5 100%
var
  env: psnappy_env;
  StreamIN, StreamOUT: TMemoryStream;
  inlen, outlen: NativeUInt;
  timer: TPrecisionTimer;
  s: string;
  i: integer;
  SynLZ: boolean;
begin
  SynLZ := chkSynLZ.Checked;
  if SynLZ then
    s := 'SynLZ'
  else
    s := 'Snappy';
  StreamIN := TMemoryStream.Create;
  StreamOUT := TMemoryStream.Create;
  StreamIN.LoadFromFile(FILE_TEST);
  inlen := StreamIN.Size;
  StreamOUT.Size := inlen;
  try
    outlen := 0;
    sleep(100);
    timer.Start;
    for i := 1 to COUNT do
      if SynLZ then
        outlen := SynLZCompress1(StreamIN.Memory, StreamIN.Size, StreamOUT.Memory)
      else
      begin
        New(env);
{$IFDEF WIN64}
        snappy_init_env(env);
        snappy_compress(env, StreamIN.Memory, StreamIN.Size, StreamOUT.Memory, @outlen);
        snappy_free_env(env);
{$ENDIF}
{$IFDEF WIN32}
        _snappy_init_env(env);
        _snappy_compress(env, StreamIN.Memory, StreamIN.Size, StreamOUT.Memory, @outlen);
        _snappy_free_env(env);
{$ENDIF}
        Dispose(env);
      end;
    Memo1.Lines.Add(format('%s compress in %s, ratio=%d%%, %s/s', [s, timer.Stop, 100 - ((100 * outlen) div inlen),
      KB(timer.PerSec(inlen * COUNT))]));
    StreamOUT.Size := outlen;
    StreamOUT.SaveToFile(FILE_TEST + '.' + s);
  finally
    StreamIN.Free;
    StreamOUT.Free;
  end;
end;

procedure TTest.UncompressClick(Sender: TObject);
var
  env: psnappy_env;
  StreamIN, StreamOUT: TMemoryStream;
  outlen: NativeUInt;
  timer: TPrecisionTimer;
  s: string;
  i: integer;
  SynLZ: boolean;
begin
  SynLZ := chkSynLZ.Checked;
  if SynLZ then
    s := 'SynLZ'
  else
    s := 'Snappy';
  StreamIN := TMemoryStream.Create;
  StreamOUT := TMemoryStream.Create;
  StreamIN.LoadFromFile(FILE_TEST + '.' + s);
  if chkSynLZ.Checked then
    outlen := SynLZdecompressdestlen(StreamIN.Memory)
  else
{$IFDEF WIN64}
    snappy_uncompressed_length(StreamIN.Memory, StreamIN.Size, @outlen)
{$ENDIF}
{$IFDEF WIN32}
      _snappy_uncompressed_length(StreamIN.Memory, StreamIN.Size, @outlen)
{$ENDIF};
  StreamOUT.Size := outlen;
  sleep(100);
  try
    timer.Start;
    for i := 1 to COUNT do
      if SynLZ then
        outlen := SynLZDecompress1(StreamIN.Memory, StreamIN.Size, StreamOUT.Memory)
      else
      begin
        New(env);
{$IFDEF WIN64}
        snappy_init_env(env);
        snappy_uncompress(StreamIN.Memory, StreamIN.Size, StreamOUT.Memory);
        snappy_free_env(env);
{$ENDIF}
{$IFDEF WIN32}
        _snappy_init_env(env);
        _snappy_uncompress(StreamIN.Memory, StreamIN.Size, StreamOUT.Memory);
        _snappy_free_env(env);
{$ENDIF}
        Dispose(env);
      end;
    Memo1.Lines.Add(format('%s uncompress in %s, %s/s', [s, timer.Stop, KB(timer.PerSec(outlen * COUNT))]));
  finally
    StreamIN.Free;
    StreamOUT.SaveToFile(FILE_TEST + '2');
    StreamOUT.Free;
  end;
end;

end.
