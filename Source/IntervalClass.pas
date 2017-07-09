unit IntervalClass;

interface

type

  TIntervalType2 = (itCondBal, itCondZab, itNoCond);

  TInterval = class
  private

  public
    _from, _to: integer;
    type1: boolean;
    type2: TIntervalType2;
    length, grade, metergrade: double;
    constructor Create();
    destructor Destroy(); override;
    procedure CalcParam;
    procedure SetType;
    function clone: TInterval;
    function addInterval(i: TInterval): TInterval;
  end;

implementation

uses
  System.Math, CalcInterval, ParamsCI;

{ TInterval }

function TInterval.addInterval(i: TInterval): TInterval;
begin
  _to := i._to;
  CalcParam;
  SetType;
  result := self;
end;

procedure TInterval.CalcParam;
var
  j: integer;
  rm: TRoundingMode;
  pm: TFPUPrecisionMode;
begin
  rm := GetRoundMode;
  SetRoundMode(rmUp);
  length := SimpleRoundTo(ISampleArray[_to]._to - ISampleArray[_from]._from,
    roundValueLength);
  metergrade := 0;
  for j := _from to _to do
    metergrade := metergrade + Sample1Array[j].metergrade;
  metergrade := SimpleRoundTo(metergrade, roundValueMetergrade);
  pm := GetPrecisionMode;
  SetPrecisionMode(pmDouble);
  grade := SimpleRoundTo(metergrade / length, roundValueGrade);
  SetPrecisionMode(pm);
  SetRoundMode(rm);
end;

function TInterval.clone: TInterval;
begin
  result := TInterval.create;
  result._from := _from;
  result._to := _to;
  result.type1 := type1;
  result.type2 := type2;
  result.grade := grade;
  result.metergrade := metergrade;
  result.length := length;
end;

constructor TInterval.Create;
begin

end;

destructor TInterval.Destroy;
begin

  inherited;
end;

procedure TInterval.SetType;
begin
  // type1
  type1 := grade >= Sb;
  // type2
  if (length < Mrt) and (metergrade < Mc) then
    type2 := itNoCond
  else
    type2 := itCondBal;
end;

end.
