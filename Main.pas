unit Main;

interface

uses
  Winapi.Messages, Winapi.Windows, System.Classes, System.SysUtils, 
  System.Variants, Vcl.Controls, Vcl.Dialogs, Vcl.Forms, Vcl.Graphics, 
  Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    procedure AfterConstruction; override;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  Attribute;

{$R *.dfm}


{ TForm1 }

procedure TForm1.AfterConstruction;
begin
  inherited;
  var T := TTest.Create('Test');
  TTest.ShowAttribute(T);
end;

end.
