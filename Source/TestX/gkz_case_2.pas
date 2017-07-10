unit gkz_case_2;

interface

uses
  DUnitX.TestFramework, IOTypes;

type

  [TestFixture]
  TGKZCase2 = class(TObject)
  private
    iarray: TISampleArray;
    oarray: TOSampleArray;
    function IsCase2: boolean;
    function compareoutput: boolean;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure CheckCase2;
  end;

implementation

uses
  ExportFunctions, System.Math;

procedure TGKZCase2.CheckCase2;
begin
  Assert.IsTrue(IsCase2, 'case 2 gkz');
end;

function TGKZCase2.compareoutput: boolean;
begin
  result := true;
  if (oarray[0].ctype <> 2) or (not SameValue(oarray[0].length, 13, 0.01)) or
    (not SameValue(oarray[0].grade, 1.48, 0.01)) or
    (not SameValue(oarray[0].metergrade, 19.2, 0.01)) then
    result := false
  else if (oarray[19].ctype <> 0) or (not SameValue(oarray[19].length, 7, 0.01))
    or (not SameValue(oarray[19].grade, 3.14, 0.01)) or
    (not SameValue(oarray[19].metergrade, 22.0, 0.01)) then
    result := false;
end;

function TGKZCase2.IsCase2: boolean;
var
  r: HRESULT;
begin
  r := GetIntervals(iarray, oarray);
  if r <> S_OK then
    result := false
  else
    result := compareoutput;
end;

procedure TGKZCase2.Setup;
begin
  SetConditionConstants(1.5, 8.0, 8.0, 12.0, 0.5, false);
  SetLength(oarray, 20);
  SetLength(iarray, 20);

  iarray[0]._from := 100.0;
  iarray[0]._to := 101.0;
  iarray[0]._grade := 1.8;

  iarray[1]._from := 101.0;
  iarray[1]._to := 102.0;
  iarray[1]._grade := 2.3;

  iarray[2]._from := 102.0;
  iarray[2]._to := 103.0;
  iarray[2]._grade := 3.9;

  iarray[3]._from := 103.0;
  iarray[3]._to := 104.0;
  iarray[3]._grade := 0.5;

  iarray[4]._from := 104.0;
  iarray[4]._to := 105.0;
  iarray[4]._grade := 4.4;

  iarray[5]._from := 105.0;
  iarray[5]._to := 106.0;
  iarray[5]._grade := 1.2;

  iarray[6]._from := 106.0;
  iarray[6]._to := 107.0;
  iarray[6]._grade := 0.6;

  iarray[7]._from := 107.0;
  iarray[7]._to := 108.0;
  iarray[7]._grade := 0.4;

  iarray[8]._from := 108.0;
  iarray[8]._to := 109.0;
  iarray[8]._grade := 0.3;

  iarray[9]._from := 109.0;
  iarray[9]._to := 110.0;
  iarray[9]._grade := 1.0;

  iarray[10]._from := 110.0;
  iarray[10]._to := 111.0;
  iarray[10]._grade := 0.5;

  iarray[11]._from := 111.0;
  iarray[11]._to := 112.0;
  iarray[11]._grade := 1.5;

  iarray[12]._from := 112.0;
  iarray[12]._to := 113.0;
  iarray[12]._grade := 0.8;

  iarray[13]._from := 113.0;
  iarray[13]._to := 114.0;
  iarray[13]._grade := 1.6;

  iarray[14]._from := 114.0;
  iarray[14]._to := 115.0;
  iarray[14]._grade := 3.0;

  iarray[15]._from := 115.0;
  iarray[15]._to := 116.0;
  iarray[15]._grade := 1.2;

  iarray[16]._from := 116.0;
  iarray[16]._to := 117.0;
  iarray[16]._grade := 0.4;

  iarray[17]._from := 117.0;
  iarray[17]._to := 118.0;
  iarray[17]._grade := 1.4;

  iarray[18]._from := 118.0;
  iarray[18]._to := 119.0;
  iarray[18]._grade := 8.5;

  iarray[19]._from := 119.0;
  iarray[19]._to := 120.0;
  iarray[19]._grade := 5.9;
end;

procedure TGKZCase2.TearDown;
begin
  iarray := nil;
  oarray := nil;
end;

initialization

TDUnitX.RegisterTestFixture(TGKZCase2);

end.
