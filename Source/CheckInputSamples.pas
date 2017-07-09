//***********************************************************************
//
// Mineframe System
//
// расчет кондиционных интервалов по методике ГКЗ
//
// Create date: 09.07.2017
// Developer: Alisov A.Y.
//
//***********************************************************************

//
// модуль для проверки значений на корректность
//

unit CheckInputSamples;

interface

/// <summary>
///   проверка входного массива проб на корректность
/// </summary>
/// <returns>
///   =true, то все ОК
/// </returns>
function CheckInput: boolean;

implementation

uses
  CalcInterval;

function CheckInput: boolean;
var
  i: integer;
begin
  result := true;
  for i := low(ISampleArray) to high(ISampleArray) do
    if ISampleArray[i]._to <= ISampleArray[i]._from then
    begin
      result := false;
      break;
    end;
  for i := low(ISampleArray) + 1 to high(ISampleArray) do
    if ISampleArray[i]._from < ISampleArray[i - 1]._to then
    begin
      result := false;
      break;
    end;
end;

end.
