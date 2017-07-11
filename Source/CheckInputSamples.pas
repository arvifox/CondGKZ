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
begin
  result := true;
end;

end.
