unit ConfigSetting;

interface

uses Ini;

type
  TConfigSetting = class(TObject)
  private
    FConnectString: String;
    FLogLevel: Integer;
    FLogDirectory: String;
    FSettingsFile: String;
  public
    constructor Create;
    // Use the IniValue attribute on any property or field
    // you want to showup in the INI File
    [IniValue('Database', 'ConnectString', '')]
    property Connectstring : String read FConnectString write FConnectString;
    [IniValue('Logging', 'Level', '0')]
    property LogLevel : Integer read FLogLevel write FLogLevel;
    [IniValue('Logging', 'Directory', '')]
    property LogDirectory: String read FLogDirectory write FLogDirectory;

    property SettingsFile : String read FSettingsFile write FSettingsFile;
    procedure Save;
    procedure Load;

    function ToString: string; override;
  end;

implementation

uses
  System.SysUtils, System.IniFiles;

{ TConfigSetting }

constructor TConfigSetting.create;
begin
  FSettingsFile := ExtractFilePath(ParamStr(0)) + 'Settings.ini';
end;

procedure TConfigSetting.Load;
begin
  // This loads the INI File Values into the properties
  TIniPersist.Load(FSettingsFile, Self);
end;

procedure TConfigSetting.Save;
begin
  // This saves the properties to the INI
  TIniPersist.Save(FSettingsFile, Self);
end;

function TConfigSetting.ToString: string;
begin
  Result := Connectstring + ', ' + IntToStr(LogLevel) + ', ' + LogDirectory;
end;

end.
