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

library gkz_ci;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  System.Math,
  {$WARN}
  {$WARN}
  {$WARN}
  CalcInterval in 'CalcInterval.pas' {$WARN SYMBOL_PLATFORM DEFAULT},
  IOTypes in 'IOTypes.pas',
  ExportFunctions in 'ExportFunctions.pas',
  ParamsCI in 'ParamsCI.pas',
  CheckInputSamples in 'CheckInputSamples.pas',
  IntervalClass in 'IntervalClass.pas',
  IntervalListClass in 'IntervalListClass.pas';

{$R *.res}
{$R properties.res}

exports
  SetConditionConstants, GetIntervals;

begin
  Sb := 1.5;
  Mpp := 8.0;
  Mrt := 8.0;
  Mc := 12.0;
  Sbz := 0.5;
  CalcZabalans := false;

  roundValueLength := -3;
  roundValueGrade := -3;
  roundValueMetergrade := -3;
  precisionMode := pmDouble;
  comparePrecision := 0.001;

end.
