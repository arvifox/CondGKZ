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
procedure SetIntervalsType;
procedure CombineAllIntervals;
procedure SetOutputIntervalArray;
procedure FreeEverything;

implementation

uses
  ParamsCI;

function getFirstSbInterval: integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to IntervalList.Count - 1 do
    if IntervalList[i].type1 then
    begin
      result := i;
      break;
    end;
end;

function GetNextSbInterval(_i, between: integer): integer;
var
  j, btw: integer;
begin
  result := -1;
  btw := 0;
  j := _i + 1;
  while j <= IntervalList.Count - 1 do
  begin
    if (IntervalList[j].type1) then
      if btw = between then
      begin
        result := j;
        break;
      end
      else
        inc(btw);
    inc(j);
  end;
end;

// ************

procedure CombineAllIntervals;
var
  i, interval_1, interval_2, btw: integer;
  f, fg: boolean;
begin
  btw := 0;
  while true do
  begin
    interval_1 := getFirstSbInterval;
    if interval_1 = -1 then
      break;
    interval_2 := GetNextSbInterval(interval_1, btw);
    if interval_2 = -1 then
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
