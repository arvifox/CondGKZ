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
    procedure CombineIntervals(i1, i2: integer);
    procedure CombineIntervalsBetween(i1, i2: integer);
    function GetLengthBetween(i1, i2: integer): double;
    function TryCombineIntervalsBetween(i1, i2: integer): boolean;
    function GetCount: integer;
    procedure SetTypeAllIntervals;
    procedure CalcParamAllIntervals;
    function add(i: TInterval): integer;
    function getIntervalForSample(n: integer): TInterval;
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

function TIntervalList.GetCount: integer;
begin
  result := list.Count;
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
begin
  result := true;
  length := GetLengthBetween(i1 + 1, i2 - 1);
  if (length > 0) and (length <= Mpp) and (true) then
    CombineIntervalsBetween(i1, i2)
  else
    result := false;
end;

end.
