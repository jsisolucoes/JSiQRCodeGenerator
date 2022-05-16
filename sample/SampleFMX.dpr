program SampleFMX;

uses
  System.StartUpCopy,
  FMX.Forms,
  view.main in 'view.main.pas' {viewMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TviewMain, viewMain);
  Application.Run;
end.
