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
begin
  result := true;
end;

end.
