{ *********************************************************************** }
{ }
{ Mineframe System }
{ dll to calc conditioned intervals }
{ }
{ use technique by  }
// ГКЗ
{ Create date: 08.07.2017}
{ Developer: Alisov A.Y. }
{ }
{ *********************************************************************** }

unit IOTypes;

interface

type

  /// <summary>
  /// входной тип данных для библиотеки
  /// </summary>
  TInputSample = record
    _length, _grade: double;
  end;

  /// <summary>
  /// выходной тип данных для библиотеки
  /// </summary>
  TOutputSample = record
    ctype: byte;
    length, grade, metergrade: double;
  end;

  TISampleArray = array of TInputSample;

  TOSampleArray = array of TOutputSample;

implementation

end.
