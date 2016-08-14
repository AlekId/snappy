unit FormTextFMX;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls;

type
  TFormArm = class(TForm)
    Compress: TButton;
    Uncompress: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure CompressClick(Sender: TObject);
    procedure UncompressClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormArm: TFormArm;

implementation

{$R *.fmx}

uses SnappyArm; // arm android ios

var
  P1, P2: TBytes;

procedure TFormArm.CompressClick(Sender: TObject);
var
  env: psnappy_env;
  outlen: NativeUInt;
begin
  New(env);
  snappy_init_env(env);
  SetLength(P1, 100000);
  SetLength(P2, 100000);
  try
    snappy_compress(env, @P1[0], 100000, @P2[0], @outlen);
    SetLength(P2, outlen);
  finally
    ShowMessage(IntToStr(outlen));
    snappy_free_env(env);
    Dispose(env);
  end;
end;

procedure TFormArm.UncompressClick(Sender: TObject);
var
  env: psnappy_env;
  outlen: NativeUInt;
begin
  New(env);
  snappy_init_env(env);
  try
    snappy_uncompressed_length(@P2[0], Length(P2), @outlen); // needs a real snappy compressed buffer
    SetLength(P1, outlen);
    snappy_uncompress(@P2[0], Length(P2), @P1[0]);
  finally
    ShowMessage(IntToStr(outlen));
    snappy_free_env(env);
    Dispose(env);
  end;
end;

end.
