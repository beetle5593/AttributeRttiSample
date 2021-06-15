unit Attribute;

interface

type
  TestAttribute = class(TCustomAttribute)
    private
      FValue: String;
    public
      constructor Create(const aValue: String);
      property Value: string read FValue write FValue;
  end;

  [Test('ClassTTest')]
  TTest = class(TObject)
  private
    FField: String;
    
  public
    [Test('PropValue')]
    property Value : string read FField write FField;
    constructor Create(const aField: string);
    class procedure ShowAttribute(aObj: TObject);
  end;

implementation

uses
  System.Rtti, Winapi.Windows;

{ TestAttribute }

constructor TestAttribute.Create(const aValue: String);
begin
  FValue := aValue;
end;

{ TTest }

constructor TTest.Create(const aField: string);
begin
  FField := aField;
end;

class procedure TTest.ShowAttribute(aObj: TObject);
var lContext: TRttiContext;
    lType: TRttiType;
    lProp: TRttiProperty;
    lAttr: TCustomAttribute;
begin
  lContext := TRttiContext.Create;
  try
    lType := lContext.GetType(aObj.ClassInfo);

    // Loop All Class Attributes
    for lAttr in lType.GetAttributes do begin
      if lAttr is TestAttribute then
        OutputDebugString(PChar((TestAttribute(lAttr).Value)));
    end;

    // Loop All Properties Attributes
    for lProp in lType.GetProperties do begin
      for lAttr in lProp.GetAttributes do begin
        if lAttr is TestAttribute then
          OutputDebugString(PChar((TestAttribute(lAttr).Value)));
      end;
    end;
  finally
    lContext.Free;
  end;
end;

end.
