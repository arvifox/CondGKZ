unit IntervalListClass;

interface

uses
  IntervalClass, System.Generics.Collections;

type

  TIntervalList = class
  private
    list: TList<TInterval>;

  public
    constructor Create;
    destructor Destroy; override;
    function getList: TList<TInterval>;
    procedure CombineIntervals(i1, i2: integer);
    procedure CombineIntervalsBetween(i1, i2: integer);
    function GetLengthBetween(i1, i2: integer): double;
    function TryCombineIntervalsBetween(i1, i2: integer): boolean;
    function GetCount: integer;
    procedure SetTypeAllIntervals;
    procedure CalcParamAllIntervals;
    function add(i: TInterval): integer;
    function getIntervalForSample(n: integer): TInterval;
    function getAverageGradeBetweenIntervals(i1, i2: integer): double;
    function getFirstType1Interval: integer;
    function getNextType1Interval(_i, between: integer): integer;
    function getType1IntervalsCount: integer;
    procedure checkType1Intervals;
    procedure combineType1Intervals(f: boolean);
    function checkType1ToFalse(i1, i2: integer): boolean;
  end;

implementation

uses
  System.Math, ParamsCI;

{ TIntervalList }

function TIntervalList.add(i: TInterval): integer;
begin
  result := list.add(i);
end;

procedure TIntervalList.CalcParamAllIntervals;
var
  i: integer;
begin
  for i := 0 to list.Count - 1 do
    list[i].CalcParam;
end;

procedure TIntervalList.checkType1Intervals;
var
  i: integer;
begin
  for i := 0 to list.Count - 1 do
    if list[i].type2 = itNoCond then
      list[i].type1 := false;
end;

function TIntervalList.checkType1ToFalse(i1, i2: integer): boolean;
begin
  result := false;
  // i2 = i1 + 2 important
  if (list[i1 + 1].length < Mpp) or SameValue(list[i1 + 1].length, Mpp,
    comparePrecision) then
    if SameValue(list[i1].metergrade, list[i2].metergrade, comparePrecision)
    then
      result := false
    else if list[i1].metergrade < list[i2].metergrade then
    begin
      list[i1].type1 := false;
      result := true;
    end
    else
    begin
      list[i2].type1 := false;
      result := true;
    end;
end;

procedure TIntervalList.CombineIntervals(i1, i2: integer);
var
  pi: TInterval;
begin
  // ÂÀÆÍÎ
  // _i2 = _i1 + 1
  list[i1]._to := list[i2]._to;
  pi := list[i2];
  list.Delete(i2);
  pi.Free;
  list[i1].CalcParam;
  list[i1].SetType;
end;

procedure TIntervalList.CombineIntervalsBetween(i1, i2: integer);
begin
  while i1 <> i2 do
  begin
    CombineIntervals(i1, i1 + 1);
    dec(i2);
  end;
end;

procedure TIntervalList.combineType1Intervals(f: boolean);
var
  i: integer;
begin
  i := 1;
  while true do
  begin
    if i >= list.Count then
      break;
    if (list[i].type1 = f) and (list[i - 1].type1 = f) then
      CombineIntervals(i - 1, i)
    else
      inc(i);
  end;
end;

constructor TIntervalList.Create;
begin
  list := TList<TInterval>.Create;
end;

destructor TIntervalList.Destroy;
var
  i: TInterval;
begin
  while list.Count > 0 do
  begin
    i := list[list.Count - 1];
    list.Delete(list.Count - 1);
    i.Free;
  end;
  list.Free;
  inherited;
end;

function TIntervalList.getAverageGradeBetweenIntervals(i1, i2: integer): double;
var
  in1: TInterval;
  i: integer;
begin
  in1 := list[i1].clone;
  for i := i1 + 1 to i2 do
    in1 := in1.addInterval(list[i]);
  result := in1.grade;
  in1.Free;
end;

function TIntervalList.GetCount: integer;
begin
  result := list.Count;
end;

function TIntervalList.getFirstType1Interval: integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to list.Count - 1 do
    if list[i].type1 then
    begin
      result := i;
      break;
    end;
end;

function TIntervalList.getIntervalForSample(n: integer): TInterval;
var
  i: integer;
begin
  result := list[0];
  for i := 0 to list.Count - 1 do
    if (list[i]._from <= n) and (list[i]._to >= n) then
    begin
      result := list[i];
      break;
    end;
end;

function TIntervalList.GetLengthBetween(i1, i2: integer): double;
var
  i: integer;
begin
  result := 0;
  for i := i1 to i2 do
    result := result + list[i].length;
end;

function TIntervalList.getList: TList<TInterval>;
begin
  result := list;
end;

function TIntervalList.getNextType1Interval(_i, between: integer): integer;
var
  j, btw: integer;
begin
  result := -1;
  btw := 0;
  j := _i + 1;
  while j <= list.Count - 1 do
  begin
    if (list[j].type1) then
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

function TIntervalList.getType1IntervalsCount: integer;
var
  i: integer;
begin
  result := 0;
  for i := 0 to list.Count - 1 do
    if list[i].type1 then
      result := result + 1;
end;

procedure TIntervalList.SetTypeAllIntervals;
var
  i: integer;
begin
  for i := 0 to list.Count - 1 do
    list[i].SetType;
end;

function TIntervalList.TryCombineIntervalsBetween(i1, i2: integer): boolean;
var
  length: double;
  gr1, gr2: double;
begin
  result := true;
  length := GetLengthBetween(i1 + 1, i2 - 1);
  gr1 := getAverageGradeBetweenIntervals(i1, i2 - 1);
  gr2 := getAverageGradeBetweenIntervals(i1 + 1, i2);
  if (length > 0) and ((length < Mpp) or SameValue(length, Mpp,
    comparePrecision)) and ((gr1 > Sb) or SameValue(gr1, Sb, comparePrecision)
    and ((gr2 > Sb) or SameValue(gr2, Sb, comparePrecision))) then
    CombineIntervalsBetween(i1, i2)
  else
    result := false;
end;

end.
