{ *********************************************************************** }
{ }
{ Mineframe System }
{ dll to calc conditioned intervals }
{ }
{ use technique by }
{ Priargunsky Industrial Mining and Chemical Union }
{ (Priargunsky)(Trans-Baikal Territory, Krasnokamensk) }
{ }
{ Create date: 30.05.2015 }
{ Developer: Alisov A.Y. }
{ }
{ *********************************************************************** }

{
  расчет кондиционных интервалов по методике ППГХО
}

unit CalcInterval;

interface

uses IOTypes, System.Generics.Collections, System.Math;

type

  TIntervalType2 = (itCondBal, itCondZab, itNoCond);

  TSample1 = record
    // больше бортового
    type1: boolean;
    // длина
    length,
    // метропроцент
    metergrade: double;
  end;

  PInterval = ^TInterval;

  TInterval = record
    _from, _to: integer;
    type1: boolean;
    type2: TIntervalType2;
    length, grade, metergrade: double;
  end;

var

  ISampleArray: TISampleArray;
  OSampleArray: TOSampleArray;
  Sample1Array: array of TSample1;
  IntervalList: TList<PInterval>;

procedure CalcSamples;
procedure CalcIntervals;
procedure SetIntervalsType;
procedure CombineAllIntervals;
procedure SetOutputIntervalArray;
procedure FreeEverything;

implementation

uses
  ParamsCI;

type
  TCombineCheck = reference to function(_i1, _i2: integer): boolean;

procedure CalcIntervalParams(_i: integer);
var
  j: integer;
  rm: TRoundingMode;
  pm: TFPUPrecisionMode;
begin
  rm := GetRoundMode;
  SetRoundMode(rmUp);
  IntervalList[_i].length := SimpleRoundTo(ISampleArray[IntervalList[_i]._to]
    ._to - ISampleArray[IntervalList[_i]._from]._from, roundValueLength);
  IntervalList[_i].metergrade := 0;
  for j := IntervalList[_i]._from to IntervalList[_i]._to do
    IntervalList[_i].metergrade := IntervalList[_i].metergrade + Sample1Array[j]
      .metergrade;
  IntervalList[_i].metergrade := SimpleRoundTo(IntervalList[_i].metergrade,
    roundValueMetergrade);
  pm := GetPrecisionMode;
  SetPrecisionMode(pmDouble);
  IntervalList[_i].grade := SimpleRoundTo(IntervalList[_i].metergrade /
    IntervalList[_i].length, roundValueGrade);
  SetPrecisionMode(pm);
  SetRoundMode(rm);
end;

procedure SetIntervalType(_i: integer);
begin
  // type1
  if IntervalList[_i].grade >= Sb then
    IntervalList[_i].type1 := true
  else
    IntervalList[_i].type1 := false;
  // type2
  if (IntervalList[_i].length < Mrt) and (IntervalList[_i].metergrade < Mc)
  then
    IntervalList[_i].type2 := itNoCond
  else
    IntervalList[_i].type2 := itCondBal;
end;

procedure CombineIntervals(_i1, _i2: integer);
var
  pi: PInterval;
begin
  // ВАЖНО
  // _i2 = _i1 + 1
  IntervalList[_i1]._to := IntervalList[_i2]._to;
  pi := IntervalList[_i2];
  IntervalList.Delete(_i2);
  Dispose(pi);
  CalcIntervalParams(_i1);
  SetIntervalType(_i1);
end;

procedure CombineIntervalsBetween(_i1, _i2: integer);
begin
  while _i1 <> _i2 do
  begin
    CombineIntervals(_i1, _i1 + 1);
    dec(_i2);
  end;
end;

function GetMinGradeNextInterval(_i: integer): integer;
begin
  if (_i = 0) and (IntervalList.Count > 1) then
    result := 1
  else if (_i = IntervalList.Count - 1) then
    result := IntervalList.Count - 2
  else if IntervalList[_i - 1].grade < IntervalList[_i + 1].grade then
    result := _i - 1
  else
    result := _i + 1;
end;

function GetInterval(_n: integer): PInterval;
var
  i: integer;
begin
  result := IntervalList[0];
  for i := 0 to IntervalList.Count - 1 do
    if (IntervalList[i]._from <= _n) and (IntervalList[i]._to >= _n) then
    begin
      result := IntervalList[i];
      break;
    end;
end;

// ************

procedure SetOutputIntervalArray;
var
  i: integer;
  pi: PInterval;
begin
  // установка значений для выходного массива
  for i := low(OSampleArray) to high(OSampleArray) do
  begin
    pi := GetInterval(i);
    OSampleArray[i].ctype := ord(pi.type2);
    OSampleArray[i].length := pi.length;
    OSampleArray[i].grade := pi.grade;
    OSampleArray[i].metergrade := pi.metergrade;
  end;
end;

procedure CombineAllIntervals;
var
  i: integer;
  f, fg: boolean;
begin
  
end;

procedure SetIntervalsType;
var
  i: integer;
begin
  for i := 0 to IntervalList.Count - 1 do
    SetIntervalType(i);
end;

procedure CalcIntervals;
var
  pi: PInterval;
  i: integer;
begin
  // построение начального списка интервалов
  IntervalList := TList<PInterval>.Create;
  new(pi);
  pi._from := low(Sample1Array);
  pi._to := low(Sample1Array);
  IntervalList.Add(pi);
  for i := low(Sample1Array) + 1 to high(Sample1Array) do
    if Sample1Array[i].type1 <> Sample1Array[i - 1].type1 then
    begin
      new(pi);
      pi._from := i;
      pi._to := i;
      IntervalList.Add(pi);
    end
    else
      pi._to := i;
  for i := 0 to IntervalList.Count - 1 do
  begin
    CalcIntervalParams(i);
    SetIntervalType(i);
  end;
end;

procedure CalcSamples;
var
  i: integer;
  rm: TRoundingMode;
begin
  rm := GetRoundMode;
  SetRoundMode(rmUp);
  SetLength(Sample1Array, length(ISampleArray));
  for i := low(ISampleArray) to high(ISampleArray) do
  begin
    // сначала определяем тип каждой пробы
    if ISampleArray[i]._grade >= Sb then
      Sample1Array[i].type1 := true
    else
      Sample1Array[i].type1 := false;
    // метропроцент считаем
    Sample1Array[i].metergrade :=
      SimpleRoundTo(Sample1Array[i].length * ISampleArray[i]._grade,
        roundValueMetergrade);
  end;
  SetRoundMode(rm);
end;

procedure FreeEverything;
var
  pi: PInterval;
begin
  Sample1Array := nil;
  while IntervalList.Count <> 0 do
  begin
    pi := IntervalList[0];
    IntervalList.Delete(0);
    Dispose(pi);
  end;
  IntervalList.Free;
end;

end.
