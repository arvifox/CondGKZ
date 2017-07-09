//***********************************************************************
//
// Mineframe System
//
// расчет кондиционных интервалов по методике √ «
//
// Create date: 09.07.2017
// Developer: Alisov A.Y.
//
//***********************************************************************

//
// в юните описаны глобальные вход€щие параметры и
// параметры точности и округлени€
//

unit ParamsCI;

interface

uses
  System.Math;

var

  /// <summary>
  /// минимальное бортовое содержание ѕ» дл€ балансовых руд
  /// </summary>
  Sb: double;

  /// <summary>
  /// макс допустима€ мощность прослоев пустых пород или некондиционных руд,
  ///  включаемых в контур рудного тела
  /// </summary>
  Mpp: double;

  /// <summary>
  /// минимальна€ истинна€ мощность рудного тела
  /// </summary>
  Mrt: double;

  /// <summary>
  /// минимальный метропроцент (метрограмм) рудного тела
  /// </summary>
  Mc: double;

  /// <summary>
  ///   минимальное бортовое содержание ѕ» дл€ забалансовых руд
  /// </summary>
  /// <seealso cref="ParamCI|CalcZabalans">
  ///   по этому флагу
  /// </seealso>
  Sbz: double;

  /// <summary>
  ///   флаг, показывает считать ли забалансовые интервалы
  /// </summary>
  CalcZabalans: boolean;

  /// <summary>
  /// количество знаков дробной части дл€ длины
  /// </summary>
  roundValueLength: integer;
  /// <summary>
  /// количество знаков дробной части дл€ качества
  /// </summary>
  roundValueGrade: integer;
  /// <summary>
  /// количество знаков дробной части дл€ метропроцента
  /// </summary>
  roundValueMetergrade: integer;
  /// <summary>
  ///   режим точности, используемый в расчетах
  /// </summary>
  {$WARN SYMBOL_PLATFORM OFF}
  precisionMode: TFPUPrecisionMode;
  {$WARN SYMBOL_PLATFORM DEFAULT}

implementation

end.
