program Form;

uses
  Vcl.Forms,
  FormTest in 'FormTest.pas' {Test};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TTest, Test);
  Application.Run;
end.
