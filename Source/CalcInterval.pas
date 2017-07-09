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

  /// <summary>
  /// Тип проб
  /// </summary>
  TSampleType1 = (
    /// <summary>
    /// с содержанием &gt;= <see cref="CalcInterval|Sb" />
    /// </summary>
    stB,
    /// <summary>
    /// с содержанием &lt; <see cref="CalcInterval|Sb" /> и &gt;= <see cref="CalcInterval|Sz" />
    /// </summary>
    stZ,
    /// <summary>
    /// с содержанием &lt; <see cref="CalcInterval|Sz" />
    /// </summary>
    stP);

  TIntervalType2 = (itPP, itBK, itBN, itZ);

  TSample1 = record
    type1: TSampleType1;
    // расстояние
    lenght,
    // зона влияния пробы
    lengthA,
    // метропроцент
    metergrade: double;
  end;

  PInterval = ^TInterval;

  TInterval = record
    _from, _to: integer;
    type1: TSampleType1;
    type2: TIntervalType2;
    length, grade, metergrade: double;
  end;

var

  ISampleArray: TISampleArray;
  OSampleArray: TOSampleArray;
  Sample1Array: array of TSample1;
  IntervalList: TList<PInterval>;

function CheckInput: boolean;
procedure CalcSamples;
procedure CalcIntervals;
procedure CombineAloneIntervals;
procedure SetIntervalsType;
procedure CombineAllIntervals;
procedure CombineToIntersection;
procedure SetOutputIntervalArray;
procedure FreeEverything;

implementation

uses
  ParamsCI;

type
  TCombineCheck = reference to function(_i1, _i2: integer): boolean;

procedure CalcInterval1(_i: integer);
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
    IntervalList[_i].type1 := stB
  else if IntervalList[_i].grade < Mpp then
    IntervalList[_i].type1 := stP
  else
    IntervalList[_i].type1 := stZ;
  // type2
  if (IntervalList[_i].grade >= Mc) and (IntervalList[_i].metergrade >= Mrt)
  then
    IntervalList[_i].type2 := itBK
  else if ((IntervalList[_i].grade >= Sb) and
    (IntervalList[_i].metergrade < Mrt)) or
    ((IntervalList[_i].grade < Mc) and (IntervalList[_i].grade >= Sb) and
    (IntervalList[_i].metergrade >= Mrt)) then
    IntervalList[_i].type2 := itBN
  else if (IntervalList[_i].grade < Sb) and (IntervalList[_i].grade >= Mpp) then
    IntervalList[_i].type2 := itZ
  else
    IntervalList[_i].type2 := itPP;
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
  CalcInterval1(_i1);
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

procedure CombineToIntersectionType(_it: TIntervalType2;
  _CombineCheck: TCombineCheck);
var
  bk1, bk2, i: integer;
begin
  repeat
    bk1 := -1;
    bk2 := -1;
    for i := 0 to IntervalList.Count - 1 do
    begin
      if IntervalList[i].type2 = _it then
        if bk1 = -1 then
          bk1 := i
        else
        begin
          bk2 := i;
          if _CombineCheck(bk1, bk2) then
          begin
            CombineIntervalsBetween(bk1, bk2);
            break;
          end
          else
          begin
            bk1 := i;
            bk2 := -1;
          end;
        end;
    end;
  until (bk1 = -1) or (bk2 = -1);
end;

// ************

procedure CombineToIntersection;
begin
  roundValueMetergrade := -3;
  // объединяем интервалы в пересечения
  // сначала БК, потом БН, потом З
  CombineToIntersectionType(itBK,
    function(_i1, _i2: integer): boolean
    var
      i: integer;
      sum, sum2: double;
    begin
      result := false;
      sum := 0;
      for i := _i1 + 1 to _i2 - 1 do
        sum := sum + IntervalList[i].length;
      if sum > Sbz then
        exit;
      sum := 0;
      for i := _i1 to _i2 - 1 do
        sum := sum + IntervalList[i].metergrade;
      if sum < Mrt then
        exit;
      sum2 := 0;
      for i := _i1 to _i2 - 1 do
        sum2 := sum2 + IntervalList[i].length;
      if sum / sum2 < Mc then
        exit;
      sum := 0;
      for i := _i1 + 1 to _i2 do
        sum := sum + IntervalList[i].metergrade;
      if sum < Mrt then
        exit;
      sum2 := 0;
      for i := _i1 + 1 to _i2 do
        sum2 := sum2 + IntervalList[i].length;
      if sum / sum2 < Mc then
        exit;
      result := true;
    end);
  CombineToIntersectionType(itBN,
    function(_i1, _i2: integer): boolean
    var
      i: integer;
      sum, sum2: double;
    begin
      result := false;
      sum := 0;
      for i := _i1 + 1 to _i2 - 1 do
        sum := sum + IntervalList[i].length;
      if sum > Sbz then
        exit;
      sum := 0;
      for i := _i1 to _i2 - 1 do
        sum := sum + IntervalList[i].metergrade;
      sum2 := 0;
      for i := _i1 to _i2 - 1 do
        sum2 := sum2 + IntervalList[i].length;
      if sum / sum2 < Sb then
        exit;
      sum := 0;
      for i := _i1 + 1 to _i2 do
        sum := sum + IntervalList[i].metergrade;
      sum2 := 0;
      for i := _i1 + 1 to _i2 do
        sum2 := sum2 + IntervalList[i].length;
      if sum / sum2 < Sb then
        exit;
      for i := _i1 + 1 to _i2 - 1 do
        if IntervalList[i].grade >= Sb then
          exit;
      result := true;
    end);
  CombineToIntersectionType(itZ,
    function(_i1, _i2: integer): boolean
    var
      i: integer;
      sum, sum2: double;
    begin
      result := false;
      sum := 0;
      for i := _i1 + 1 to _i2 - 1 do
        sum := sum + IntervalList[i].length;
      if sum > Sbz then
        exit;
      sum := 0;
      for i := _i1 to _i2 - 1 do
        sum := sum + IntervalList[i].metergrade;
      sum2 := 0;
      for i := _i1 to _i2 - 1 do
        sum2 := sum2 + IntervalList[i].length;
      if sum / sum2 < Mpp then
        exit;
      sum := 0;
      for i := _i1 + 1 to _i2 do
        sum := sum + IntervalList[i].metergrade;
      sum2 := 0;
      for i := _i1 + 1 to _i2 do
        sum2 := sum2 + IntervalList[i].length;
      if sum / sum2 < Mpp then
        exit;
      for i := _i1 to _i2 do
        if IntervalList[i].grade >= Sb then
          exit;
      result := true;
    end);
end;

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
  i := 0;
  // объединяем однотипные по type1
  while i < IntervalList.Count - 1 do
  begin
    if IntervalList[i].type1 = IntervalList[i + 1].type1 then
      CombineIntervals(i, i + 1)
    else
      inc(i);
  end;
  repeat
    fg := true;
    // объединяем БН и З
    repeat
      f := true;
      i := 0;
      while i < IntervalList.Count - 1 do
      begin
        if ((IntervalList[i].type2 = itBN) and (IntervalList[i + 1].type2 = itZ)
          ) or ((IntervalList[i].type2 = itZ) and
          (IntervalList[i + 1].type2 = itBN)) then
        begin
          CombineIntervals(i, i + 1);
          f := false;
          fg := false;
        end;
        inc(i);
      end;
      i := 0;
      while i < IntervalList.Count - 1 do
      begin
        if IntervalList[i].type2 = IntervalList[i + 1].type2 then
        begin
          CombineIntervals(i, i + 1);
          f := false;
        end
        else
          inc(i);
      end;
    until f;
  until fg;
end;

procedure SetIntervalsType;
var
  i: integer;
begin
  for i := 0 to IntervalList.Count - 1 do
    SetIntervalType(i);
end;

procedure CombineAloneIntervals;
var
  i, m: integer;
  pi, pi2: PInterval;
begin
  i := 1;
  // попарное объединение соседних единичных интервалов
  while i < IntervalList.Count do
  begin
    pi := IntervalList[i];
    pi2 := IntervalList[i - 1];
    if (pi._from = pi._to) and (pi2._from = pi2._to) and
      (pi.length - 0.1 < 0.001) and (pi2.length - 0.1 < 0.001) then
      CombineIntervals(i - 1, i)
    else
      inc(i);
  end;
  i := 0;
  // объединение единичных к соседнему с меньшим качеством
  while (i < IntervalList.Count) and (IntervalList.Count > 1) do
  begin
    pi := IntervalList[i];
    if (pi._from = pi._to) and (pi.length - 0.1 < 0.001) then
    begin
      m := GetMinGradeNextInterval(i);
      if IntervalList[m]._from <> IntervalList[m]._to then
        if m < i then
          CombineIntervals(m, i)
        else
          CombineIntervals(i, m)
      else
        inc(i);
    end
    else
      inc(i);
  end;
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
    CalcInterval1(i);
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
      Sample1Array[i].type1 := stB
    else if ISampleArray[i]._grade < Mpp then
      Sample1Array[i].type1 := stP
    else
      Sample1Array[i].type1 := stZ;
    // вычисление зоны влияния пробы
    Sample1Array[i].lengthA :=
      SimpleRoundTo(ISampleArray[i]._to - ISampleArray[i]._from,
        roundValueLength);
    // метропроцент считаем
    Sample1Array[i].metergrade :=
      SimpleRoundTo(Sample1Array[i].lengthA * ISampleArray[i]._grade,
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
