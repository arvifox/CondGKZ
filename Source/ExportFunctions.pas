unit ExportFunctions;

interface

uses IOTypes, ParamsCI;

function SetConditionConstants(_Sb, _Mpp, _Mrt, _Sbz: double; _Cz: boolean)
  : HRESULT; stdcall;

function GetIntervals(_SampleArray: TISampleArray;
  var _IntervalArray: TOSampleArray): HRESULT; stdcall;

implementation

uses
  CalcInterval, CheckInputSamples, System.Math;

function SetConditionConstants(_Sb, _Mpp, _Mrt, _Sbz: double; _Cz: boolean)
  : HRESULT; stdcall;
begin
  roundValueLength := -2;
  roundValueGrade := -2;
  roundValueMetergrade := -2;
  precisionMode := pmDouble;
  comparePrecision := 0.01;
  Sb := _Sb;
  Mpp := _Mpp;
  Mrt := _Mrt;
  Mc := Sb * Mrt;
  Sbz := _Sbz;
  CalcZabalans := _Cz;
  Result := S_OK;
end;

function GetIntervals(_SampleArray: TISampleArray;
  var _IntervalArray: TOSampleArray): HRESULT; stdcall;
begin
  ISampleArray := _SampleArray;
  OSampleArray := _IntervalArray;
  if CheckInput then
  begin
    CalcSamples;
    CalcIntervals;
    CombineAllIntervals;
    SetOutputIntervalArray;
    FreeEverything;
    Result := S_OK;
  end
  else
    Result := S_FALSE;
  ISampleArray := nil;
  OSampleArray := nil;
end;

end.
