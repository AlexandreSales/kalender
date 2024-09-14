unit System.Kalender;

interface

uses
  { Kalender }
  FMX.Types,
  System.Kalender.Api;

type

  TProcedureOnChangeDate = procedure(const ADate: TDate) of Object;
  TProcedureOnChangeRangeDate = procedure(const AStartDate, AEndDate: TDate) of Object;
  TProcedureOnDblClick = procedure(Sender: TObject) of Object;

  {IKalender}
  IKalender = interface
  ['{22A5EA28-A445-4629-9396-C170C92452CB}']
    function Mode(const Value: TKalenderMode): IKalender;
    function Align(const Value: TAlignLayout): IKalender;
    function Date(const AValue: TDate): IKalender;
    function OnChangeDate(const AValue: TProcedureOnChangeDate): IKalender; Overload;
    function OnChangeDate(const AValue: TProcedureOnChangeRangeDate): IKalender; Overload;
  end;

  {IKalenderConfigInterface}
  IKalenderConstraints = interface
  ['{751612B8-EEB5-40DE-A602-0DBC44207E5A}']
    function GetMinHeight: Single;
    function GeMaxHeight: Single;
    function GetMinWidth: Single;
    function GetMaxWidth: Single;

    procedure SetMinHeight(const AValue: Single);
    procedure SetMaxHeight(const AValue: Single);
    procedure SetMinWidth(const AValue: Single);
    procedure SetMaxWidth(const AValue: Single);

    property MinHeight: Single read GetMinHeight write SetMinHeight;
    property MaxHeight: Single read GeMaxHeight write SetMaxHeight;
    property MinWidth: Single read GetMinWidth write SetMinWidth;
    property MaxWidth: Single read GetMaxWidth write SetMaxWidth;
  end;

  TKalenderConstraints = class(TInterfacedObject, IKalenderConstraints)
  private
    { Private declarations }
    FMinHeight: Single;
    FMaxHeight: Single;
    FMinWidth: Single;
    FMaxWidth: Single;

    function GetMinHeight: Single;
    function GeMaxHeight: Single;
    function GetMinWidth: Single;
    function GetMaxWidth: Single;

    procedure SetMinHeight(const AValue: Single);
    procedure SetMaxHeight(const AValue: Single);
    procedure SetMinWidth(const AValue: Single);
    procedure SetMaxWidth(const AValue: Single);
  public
    { Public declarations }
    Constructor Create;

    property MinHeight: Single read GetMinHeight write SetMinHeight;
    property MaxHeight: Single read GeMaxHeight write SetMaxHeight;
    property MinWidth: Single read GetMinWidth write SetMinWidth;
    property MaxWidth: Single read GetMaxWidth write SetMaxWidth;
  end;

implementation

{ TKalenderConstraints }

constructor TKalenderConstraints.Create;
begin
  FMinHeight := MIN_HEIGHT_WEEK;
  FMaxHeight := 0;
  FMinWidth := MIN_WIDTH;
  FMaxWidth := 0;
end;

function TKalenderConstraints.GeMaxHeight: Single;
begin
  Result := FMaxHeight;
end;

function TKalenderConstraints.GetMaxWidth: Single;
begin
  Result := FMaxWidth;
end;

function TKalenderConstraints.GetMinHeight: Single;
begin
  Result := FMinHeight;
end;

function TKalenderConstraints.GetMinWidth: Single;
begin
  Result := FMinWidth;
end;

procedure TKalenderConstraints.SetMaxHeight(const AValue: Single);
begin
  if AValue <> FMaxHeight then
    if AValue < FMinHeight then
      FMaxHeight := FMinHeight
    else
      FMaxHeight := AValue;
end;

procedure TKalenderConstraints.SetMaxWidth(const AValue: Single);
begin
  if AValue <> FMaxWidth then
    if AValue < FMinWidth then
      FMaxWidth := FMinWidth
    else
      FMaxWidth := AValue;
end;

procedure TKalenderConstraints.SetMinHeight(const AValue: Single);
begin
  if AValue <> FMinHeight then
    if (AValue >= MIN_HEIGHT_WEEK) or (AValue >= MIN_HEIGHT_MONTH) then
      FMinHeight := AValue;
end;

procedure TKalenderConstraints.SetMinWidth(const AValue: Single);
begin
  if AValue <> FMinWidth then
    if AValue > MIN_WIDTH then
      FMinWidth := AValue;
end;

end.
