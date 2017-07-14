unit gkz_case_3;

interface

uses
  DUnitX.TestFramework, IOTypes;

type

  [TestFixture]
  TGKZCase3 = class(TObject)
  private
    iarray: TISampleArray;
    oarray: TOSampleArray;
    function IsCase3: boolean;
    function compareoutput: boolean;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    [Test]
    procedure CheckCase3;
  end;

implementation

uses
  ExportFunctions, System.Math;

procedure TGKZCase3.CheckCase3;
begin
  Assert.IsTrue(IsCase3, 'case 3 gkz');
end;

function TGKZCase3.compareoutput: boolean;
begin
  result := true;
  if (oarray[0].ctype <> 2) or (not SameValue(oarray[0].length, 2, 0.01)) then
    result := false
  else
    if (oarray[2].ctype <> 0) or (not SameValue(oarray[2].length, 6, 0.01)) then
      result := false
    else
      if (oarray[41].ctype <> 2) or (not SameValue(oarray[41].length, 33, 0.01)) then
        result := false;
end;

function TGKZCase3.IsCase3: boolean;
var
  r: HRESULT;
begin
  r := GetIntervals(iarray, oarray);
  if r <> S_OK then
    result := false
  else
    result := compareoutput;
end;

procedure TGKZCase3.Setup;
begin
  SetConditionConstants(0.4, 5.0, 5.0, 0.2, false);
  SetLength(oarray, 41);
  SetLength(iarray, 41);

  iarray[0]._length  := 3.1;
  iarray[0]._grade := 0.0;

  iarray[1]._length  := 0.89;
  iarray[1]._grade := 0.0;

  iarray[2]._length  := 0.89;
  iarray[2]._grade := 6.77;

  iarray[3]._length  := 0.71;
  iarray[3]._grade := 1.27;

  iarray[4]._length  := 0.62;
  iarray[4]._grade := 0.36;

  iarray[5]._length  := 0.89;
  iarray[5]._grade := 0.0;

  iarray[6]._length  := 0.89;
  iarray[6]._grade := 0.35;

  iarray[7]._length  := 0.89;
  iarray[7]._grade := 1.2;

  iarray[8]._length  := 0.89;
  iarray[8]._grade := 0.0;

  iarray[9]._length  := 0.97;
  iarray[9]._grade := 0.0;

  iarray[10]._length  := 0.8;
  iarray[10]._grade := 0.43;

  iarray[11]._length  := 0.89;
  iarray[11]._grade := 0.45;

  iarray[12]._length  := 0.89;
  iarray[12]._grade := 0.0;

  iarray[13]._length  := 0.71;
  iarray[13]._grade := 0.62;

  iarray[14]._length  := 0.62;
  iarray[14]._grade := 2.26;

  iarray[15]._length  := 0.44;
  iarray[15]._grade := 0.0;

  iarray[16]._length  := 0.89;
  iarray[16]._grade := 0.0;

  iarray[17]._length  := 0.89;
  iarray[17]._grade := 0.0;

  iarray[18]._length  := 0.62;
  iarray[18]._grade := 0.0;

  iarray[19]._length  := 0.89;
  iarray[19]._grade := 0.81;

  iarray[20]._length  := 0.62;
  iarray[20]._grade := 0.0;

  iarray[21]._length  := 0.71;
  iarray[21]._grade := 0.0;

  iarray[22]._length  := 0.71;
  iarray[22]._grade := 0.64;

  iarray[23]._length  := 0.89;
  iarray[23]._grade := 0.0;

  iarray[24]._length  := 0.89;
  iarray[24]._grade := 0.0;

  iarray[25]._length  := 0.89;
  iarray[25]._grade := 0.0;

  iarray[26]._length  := 0.89;
  iarray[26]._grade := 0.0;

  iarray[27]._length  := 0.98;
  iarray[27]._grade := 0.0;

  iarray[28]._length  := 0.98;
  iarray[28]._grade := 0.0;

  iarray[29]._length  := 0.8;
  iarray[29]._grade := 0.5;

  iarray[30]._length  := 0.8;
  iarray[30]._grade := 0.0;

  iarray[31]._length  := 0.89;
  iarray[31]._grade := 0.42;

  iarray[32]._length  := 0.89;
  iarray[32]._grade := 0.0;

  iarray[33]._length  := 0.89;
  iarray[33]._grade := 0.0;

  iarray[34]._length  := 0.89;
  iarray[34]._grade := 0.0;

  iarray[35]._length  := 0.89;
  iarray[35]._grade := 0.0;

  iarray[36]._length  := 0.89;
  iarray[36]._grade := 0.0;

  iarray[37]._length  := 0.62;
  iarray[37]._grade := 0.0;

  iarray[38]._length  := 0.98;
  iarray[38]._grade := 0.0;

  iarray[39]._length  := 0.98;
  iarray[39]._grade := 0.0;

  iarray[40]._length  := 0.98;
  iarray[40]._grade := 0.0;
end;

procedure TGKZCase3.TearDown;
begin
  iarray := nil;
  oarray := nil;
end;

initialization
  TDUnitX.RegisterTestFixture(TGKZCase3);
end.
