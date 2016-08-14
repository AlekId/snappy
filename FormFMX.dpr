program FormFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  FormTextFMX in 'FormTextFMX.pas' {FormArm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormArm, FormArm);
  Application.Run;
end.
