unit Main;

interface

uses
  Winapi.Windows, System.Classes, Vcl.Controls, Vcl.Forms, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    btnSave: TButton;
    procedure btnLoadClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  ConfigSetting;

{$R *.dfm}

procedure TForm1.btnLoadClick(Sender: TObject);
begin
  var T := TConfigSetting.Create;
  T.Load;
  OutputDebugString(PChar(T.ToString));
end;

procedure TForm1.btnSaveClick(Sender: TObject);
begin
  var T := TConfigSetting.Create;
  T.Connectstring := '\\198.162.0.1\Database';
  T.LogLevel := 0;
  T.LogDirectory := '\Log';

  T.Save;
end;

end.
