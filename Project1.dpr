program Project1;

uses
  Vcl.Forms,
  Attribute in 'Attribute.pas',
  Main in 'Main.pas' {Form1},
  ConfigSetting in 'ConfigSetting.pas',
  Ini in 'Ini.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
