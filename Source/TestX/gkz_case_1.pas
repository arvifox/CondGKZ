unit gkz_case_1;

interface
uses
  DUnitX.TestFramework, IOTypes;

type

  [TestFixture]
  TGKZCase1 = class(TObject)
  private
    iarray: TISampleArray;
    oarray: TOSampleArray;
    function IsCase1: boolean;
    function compareoutput: boolean;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure CheckCase1;
  end;

implementation

uses
  ExportFunctions, System.Math;

procedure TGKZCase1.CheckCase1;
begin
  Assert.IsTrue(IsCase1, 'case 1 gkz');
end;

function TGKZCase1.compareoutput: boolean;
begin
  result := true;
  if (oarray[0].ctype <> 0) or (not SameValue(oarray[0].length, 19, 0.01)) or
    (not SameValue(oarray[0].grade, 2.56, 0.01)) or
    (not SameValue(oarray[0].metergrade, 48.6, 0.01)) then
    result := false;
end;

function TGKZCase1.IsCase1: boolean;
var
  r: HRESULT;
begin
  r := GetIntervals(iarray, oarray);
  if r <> S_OK then
    result := false
  else
    result := compareoutput;
end;

procedure TGKZCase1.Setup;
begin
  SetConditionConstants(1.5, 8.0, 8.0, 0.5, false);
  SetLength(oarray, 19);
  SetLength(iarray, 19);
  iarray[0]._from  := 79.0;
  iarray[0]._to    := 80.0;
  iarray[0]._grade := 1.9;

  iarray[1]._from  := 80.0;
  iarray[1]._to    := 81.0;
  iarray[1]._grade := 1.8;

  iarray[2]._from  := 81.0;
  iarray[2]._to    := 82.0;
  iarray[2]._grade := 0.8;

  iarray[3]._from  := 82.0;
  iarray[3]._to    := 83.0;
  iarray[3]._grade := 2.2;

  iarray[4]._from  := 83.0;
  iarray[4]._to    := 84.0;
  iarray[4]._grade := 5.0;

  iarray[5]._from  := 84.0;
  iarray[5]._to    := 85.0;
  iarray[5]._grade := 1.9;

  iarray[6]._from  := 85.0;
  iarray[6]._to    := 86.0;
  iarray[6]._grade := 5.8;

  iarray[7]._from  := 86.0;
  iarray[7]._to    := 87.0;
  iarray[7]._grade := 2.9;

  iarray[8]._from  := 87.0;
  iarray[8]._to    := 88.0;
  iarray[8]._grade := 0.0;

  iarray[9]._from  := 88.0;
  iarray[9]._to    := 89.0;
  iarray[9]._grade := 1.5;

  iarray[10]._from  := 89.0;
  iarray[10]._to    := 90.0;
  iarray[10]._grade := 0.2;

  iarray[11]._from  := 90.0;
  iarray[11]._to    := 91.0;
  iarray[11]._grade := 1.8;

  iarray[12]._from  := 91.0;
  iarray[12]._to    := 92.0;
  iarray[12]._grade := 1.3;

  iarray[13]._from  := 92.0;
  iarray[13]._to    := 93.0;
  iarray[13]._grade := 1.9;

  iarray[14]._from  := 93.0;
  iarray[14]._to    := 94.0;
  iarray[14]._grade := 0.0;

  iarray[15]._from  := 94.0;
  iarray[15]._to    := 95.0;
  iarray[15]._grade := 3.0;

  iarray[16]._from  := 95.0;
  iarray[16]._to    := 96.0;
  iarray[16]._grade := 3.8;

  iarray[17]._from  := 96.0;
  iarray[17]._to    := 97.0;
  iarray[17]._grade := 1.2;

  iarray[18]._from  := 97.0;
  iarray[18]._to    := 98.0;
  iarray[18]._grade := 11.6;
end;

procedure TGKZCase1.TearDown;
begin
  iarray := nil;
  oarray := nil;
end;

initialization
  TDUnitX.RegisterTestFixture(TGKZCase1);
end.
