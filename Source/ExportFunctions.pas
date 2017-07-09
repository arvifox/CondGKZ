unit ExportFunctions;

interface

uses IOTypes, ParamsCI;

function SetConditionConstants(_Sb, _Mpp, _Mrt, _Mc, _Sbz: double; _Cz: boolean)
  : HRESULT; stdcall;

function GetIntervals(_SampleArray: TISampleArray;
  var _IntervalArray: TOSampleArray): HRESULT; stdcall;

implementation

uses CalcInterval, CheckInputSamples;

function SetConditionConstants(_Sb, _Mpp, _Mrt, _Mc, _Sbz: double; _Cz: boolean)
  : HRESULT; stdcall;
begin
  Sb := _Sb;
  Mpp := _Mpp;
  Mrt := _Mrt;
  Mc := _Mc;
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
