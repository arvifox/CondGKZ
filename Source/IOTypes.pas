{ *********************************************************************** }
{ }
{ Mineframe System }
{ dll to calc conditioned intervals }
{ }
{ use technique by  }
// ���
{ Create date: 08.07.2017}
{ Developer: Alisov A.Y. }
{ }
{ *********************************************************************** }

unit IOTypes;

interface

type

  /// <summary>
  /// ������� ��� ������ ��� ����������
  /// </summary>
  TInputSample = record
    _length, _grade: double;
  end;

  /// <summary>
  /// �������� ��� ������ ��� ����������
  /// </summary>
  TOutputSample = record
    ctype: byte;
    length, grade, metergrade: double;
  end;

  TISampleArray = array of TInputSample;

  TOSampleArray = array of TOutputSample;

implementation

end.
