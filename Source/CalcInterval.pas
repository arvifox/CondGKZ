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

uses
  IOTypes, System.Generics.Collections, System.Math, IntervalClass,
  IntervalListClass;

type

  TSample1 = record
    // больше бортового
    type1: boolean;
    // длина
    length,
    // метропроцент
    metergrade: double;
  end;

var

  ISampleArray: TISampleArray;
  OSampleArray: TOSampleArray;
  Sample1Array: array of TSample1;
  IntervalList: TIntervalList;

procedure CalcSamples;
procedure CalcIntervals;
procedure CombineAllIntervals;
procedure SetOutputIntervalArray;
procedure FreeEverything;

implementation

uses
  ParamsCI;

procedure CombineAllIntervals;
var
  interval_1, interval_2, btw: integer;
  f2: boolean;
begin
  btw := 0;
  while true do
  begin
    interval_1 := IntervalList.getFirstType1Interval;
    if interval_1 = -1 then
      break;
    f2 := false;
    while true do
    begin
      interval_2 := IntervalList.getNextType1Interval(interval_1, btw);
      if interval_2 = -1 then
        break;
      if IntervalList.TryCombineIntervalsBetween(interval_1, interval_2) then
      begin
        f2 := true;
        break;
      end
      else
        interval_1 := interval_2;
    end;
    if f2 then
      btw := 0
    else if btw < IntervalList.getType1IntervalsCount - 2 then
      inc(btw)
    else
      break;
  end;
  IntervalList.checkType1Intervals;
  IntervalList.combineType1Intervals(false);
  btw := 0;
  while true do
  begin
    interval_1 := IntervalList.getFirstType1Interval;
    if interval_1 = -1 then
      break;
    f2 := false;
    while true do
    begin
      interval_2 := IntervalList.getNextType1Interval(interval_1, btw);
      if interval_2 = -1 then
        break;
      if IntervalList.checkType1ToFalse(interval_1, interval_2) then
      begin
        f2 := true;
        IntervalList.combineType1Intervals(false);
        break;
      end
      else
        interval_1 := interval_2;
    end;
    if not f2 then
      break;
  end;
end;

procedure SetOutputIntervalArray;
var
  i: integer;
  pi: TInterval;
begin
  // установка значений для выходного массива
  for i := low(OSampleArray) to high(OSampleArray) do
  begin
    pi := IntervalList.getIntervalForSample(i);
    OSampleArray[i].ctype := ord(pi.type2);
    OSampleArray[i].length := pi.length;
    OSampleArray[i].grade := pi.grade;
    OSampleArray[i].metergrade := pi.metergrade;
  end;
end;

procedure CalcIntervals;
var
  pi: TInterval;
  i: integer;
begin
  // построение начального списка интервалов
  IntervalList := TIntervalList.Create;
  pi := TInterval.Create;
  pi._from := low(Sample1Array);
  pi._to := low(Sample1Array);
  IntervalList.Add(pi);
  for i := low(Sample1Array) + 1 to high(Sample1Array) do
    if Sample1Array[i].type1 <> Sample1Array[i - 1].type1 then
    begin
      pi := TInterval.Create;
      pi._from := i;
      pi._to := i;
      IntervalList.Add(pi);
    end
    else
      pi._to := i;
  IntervalList.CalcParamAllIntervals;
  IntervalList.SetTypeAllIntervals;
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
begin
  IntervalList.Free;
end;

end.
