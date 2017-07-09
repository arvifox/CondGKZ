unit PimcuTestX;

interface
uses
  DUnitX.TestFramework;

type

  [TestFixture]
  TPimcuTestX = class(TObject) 
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    procedure Test1;
    // Test with TestCase Attribute to supply parameters.
    [Test]
    [TestCase('TestA','1,2')]
    [TestCase('TestB','3,4')]
    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

procedure TPimcuTestX.Setup;
begin
end;

procedure TPimcuTestX.TearDown;
begin
end;

procedure TPimcuTestX.Test1;
begin
  Assert.Pass('OK');
end;

procedure TPimcuTestX.Test2(const AValue1 : Integer;const AValue2 : Integer);
begin
  Assert.AreEqual(true, AValue1 + AValue2 > 0);
end;

initialization
  TDUnitX.RegisterTestFixture(TPimcuTestX);
end.
