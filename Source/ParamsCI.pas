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
// � ����� ������� ���������� �������� ��������� �
// ��������� �������� � ����������
//

unit ParamsCI;

interface

uses
  System.Math;

var

  /// <summary>
  /// ����������� �������� ���������� �� ��� ���������� ���
  /// </summary>
  Sb: double;

  /// <summary>
  /// ���� ���������� �������� �������� ������ ����� ��� �������������� ���,
  ///  ���������� � ������ ������� ����
  /// </summary>
  Mpp: double;

  /// <summary>
  /// ����������� �������� �������� ������� ����
  /// </summary>
  Mrt: double;

  /// <summary>
  /// ����������� ������������ (����������) ������� ����
  /// </summary>
  Mc: double;

  /// <summary>
  ///   ����������� �������� ���������� �� ��� ������������ ���
  /// </summary>
  /// <remarks>
  ///   �� ����� <see cref="ParamsCI|CalcZabalans" /> ����������, ������� ��
  ///   ������ ������������
  /// </remarks>
  Sbz: double;

  /// <summary>
  ///   ����, ���������� ������� �� ������������ ���������
  /// </summary>
  CalcZabalans: boolean;

  comparePrecision: double;

  /// <summary>
  /// ���������� ������ ������� ����� ��� �����
  /// </summary>
  roundValueLength: integer;
  /// <summary>
  /// ���������� ������ ������� ����� ��� ��������
  /// </summary>
  roundValueGrade: integer;
  /// <summary>
  /// ���������� ������ ������� ����� ��� �������������
  /// </summary>
  roundValueMetergrade: integer;
  /// <summary>
  ///   ����� ��������, ������������ � ��������
  /// </summary>
  {$WARN SYMBOL_PLATFORM OFF}
  precisionMode: TFPUPrecisionMode;
  {$WARN SYMBOL_PLATFORM DEFAULT}

implementation

end.
