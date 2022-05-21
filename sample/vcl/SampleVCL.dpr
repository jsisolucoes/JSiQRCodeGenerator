program SampleVCL;

uses
  Vcl.Forms,
  view.main in 'view.main.pas' {viewMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TviewMain, viewMain);
  Application.Run;
end.
