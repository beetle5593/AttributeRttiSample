unit Ini;

interface

uses
  System.Rtti;

type
  IniValueAttribute = class(TCustomAttribute)
    private
      FSection: string;
      FName: string;
      FDefaultValue: string;
    public
      constructor Create(const aSection: String; const aName: String; const aDefaultValue: string = '');
      property Section: string read FSection write FSection;
      property Name: string read FName write FName;
      property DefaultValue: string read FDefaultValue write FDefaultValue;
  end;

  TIniPersist = class(TObject)
    private
      class procedure SetValue(aData: String; var aValue: TValue);
      class function GetIniAttribute(aObj: TRttiObject): IniValueAttribute;
    public
      class procedure Load(aFileName: string; aObj: TObject);
      class procedure Save(aFileName: string; aObj: TObject);
      
  end;

implementation

uses
  System.SysUtils, System.TypInfo, System.IniFiles, Winapi.Windows;

{ IniValueAttribute }

constructor IniValueAttribute.Create(const aSection, aName,
  aDefaultValue: string);
begin
  FSection := aSection;
  FName := aName;
  FDefaultValue := aDefaultValue;
end;

{ TIniPersist }

class procedure TIniPersist.SetValue(aData: String; var aValue: TValue);
var i: Integer;
begin
  case aValue.Kind of
    tkWChar,
    tkLString,
    tkWString,
    tkString,
    tkChar,
    tkUString: aValue := aData;
    tkInteger,
    tkInt64: aValue := StrToInt(aData);
    tkFloat: aValue := StrToFloat(aData);
    tkEnumeration: aValue := TValue.FromOrdinal(aValue.TypeInfo, GetEnumValue(aValue.TypeInfo, aData));
    tkSet: begin
      i := StringToSet(aValue.TypeInfo, aData);
      TValue.Make(@i, aValue.TypeInfo, aValue);
    end;
    else raise Exception.Create('Type not Supported');
  end;
end;

class function TIniPersist.GetIniAttribute(aObj: TRttiObject):
    IniValueAttribute;
begin
  for var A in aObj.GetAttributes do begin
    if A is IniValueAttribute then
      Exit(IniValueAttribute(A));
  end;
  Result := nil;
end;

class procedure TIniPersist.Load(aFileName: string; aObj: TObject);
var
  ctx : TRttiContext;
  objType : TRttiType;
  Prop  : TRttiProperty;
  Value : TValue;
  IniValue : IniValueAttribute;
  Ini : TIniFile;
  Data : String;
begin
  ctx := TRttiContext.Create;
  try
    Ini := TIniFile.Create(aFileName);
    try
      objType := ctx.GetType(aObj.ClassInfo);

      // Load value from ini to object
      for Prop in objType.GetProperties do begin
        IniValue := GetIniAttribute(Prop);
        if Assigned(IniValue) then begin
          // Read string value from ini file
          Data := Ini.ReadString(IniValue.Section, IniValue.Name, IniValue.DefaultValue);
          
          //Set value to instance
          Value := Prop.GetValue(aObj);
          SetValue(Data, Value);
          Prop.SetValue(aObj, Value);        
        end;
      end;    
    finally
      Ini.Free;
    end;
  finally
    ctx.Free;
  end;
end;

class procedure TIniPersist.Save(aFileName: string; aObj: TObject);
var ctx: TRttiContext;
    objType: TRttiType;
    Prop  : TRttiProperty;
    IniValue: IniValueAttribute;
    Ini: TIniFile;
begin
  ctx := TRttiContext.Create;
  try
    Ini := TIniFile.Create(aFileName);
    try
      objType := ctx.GetType(aObj.ClassInfo);

      for Prop in objType.GetProperties do begin
        // Get valur from instance
        IniValue := GetIniAttribute(Prop);

        // Write string value to ini file
        if Assigned(IniValue) then 
          Ini.WriteString(IniValue.Section, IniValue.Name, Prop.GetValue(aObj).ToString);
      end;         
    finally
      Ini.Free;
    end;
  finally
    ctx.Free;
  end;
end;

end.
