//***********************************************************************
//
// Mineframe System
//
// ������ ������������ ���������� �� �������� ���
//
// Create date: 09.07.2017
// Developer: Alisov A.Y.
//
//***********************************************************************

//
// ������ ��� �������� �������� �� ������������
//

unit CheckInputSamples;

interface

/// <summary>
///   �������� �������� ������� ���� �� ������������
/// </summary>
/// <returns>
///   =true, �� ��� ��
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
