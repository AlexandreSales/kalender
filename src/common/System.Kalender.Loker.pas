unit System.Kalender.Loker;

interface

uses
  System.SysUtils,
  Generics.Defaults,
  Generics.Collections;

type

  TKalenderLocker = class
  private
    {private declarations}
    FLockers: TArray<string>;
  public
    {public declarations}
    constructor Create;
    destructor destroy; override;

    function Add(const ADate: TDate): Integer;
    function IndexOf(const ADate: TDate): Integer;
    procedure Clear;
  end;

var
  KalenderLocker: TKalenderLocker;

implementation

{ TKalenderLocker }

function TKalenderLocker.Add(const ADate: TDate): Integer;
begin
  Insert(formatDateTime('dd/MM/yyyy', ADate),
         FLockers,
         High(FLockers) + 1);
  Result := High(FLockers);
end;

procedure TKalenderLocker.Clear;
begin
  setLength(FLockers, 0);
end;

constructor TKalenderLocker.Create;
begin
  setLength(FLockers, 0);
end;

destructor TKalenderLocker.destroy;
begin
  setLength(FLockers, 0);
  inherited;
end;

function TKalenderLocker.IndexOf(const ADate: TDate): Integer;
var
  lresultIndex: Integer;
begin
  Result := -1;
  if TArray.BinarySearch<string>(FLockers, formatDateTime('dd/MM/yyyy', ADate), lresultIndex, TStringComparer.Ordinal) then
    Result := lresultIndex;
end;

end.

