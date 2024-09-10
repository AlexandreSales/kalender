unit FMX.Kalender;

interface

uses
  { Delphi }
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.Math,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.Layouts,

  { Kalender }
  System.Kalender.Api,
  System.Kalender,
  FMX.Kalender.Calendar;

const
  KalenderVersion =  '0.1';

type
  TKalender = class(TFrame, IKalender)
    StyleKalender: TStyleBook;
    layControls: TLayout;
    btnCancel: TButton;
    btnOkay: TButton;
    procedure FrameResize(Sender: TObject);
  private
    { Private declarations }
    FCalendar: TKalenderCalendar;
    FChangeDate: TProcedureOnChangeDate;
    FChangeRangeDate: TProcedureOnChangeRangeDate;
    FConstraints: IKalenderConstraints;
    FMode: TKalenderMode;
    FOwner: TComponent;
    FRenderParent: TFmxObject;

    procedure SetMode(const Value: TKalenderMode);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function New(AOwner: TComponent;
                       ARenderParent: TFmxObject
                       ): IKalender;

    function Align(const AValue: TAlignLayout): IKalender;
    function Date(const AValue: TDateTime): IKalender;
    function Mode(const AValue: TKalenderMode): IKalender;
    function OnChangeDate(const AValue: TProcedureOnChangeDate): IKalender; Overload;
    function OnChangeDate(const AValue: TProcedureOnChangeRangeDate): IKalender; Overload;

    property Constraints: IKalenderConstraints read FConstraints write FConstraints;
  end;

implementation

{$R *.fmx}

{ TKalender }

function TKalender.Align(const AValue: TAlignLayout): IKalender;
begin
  Result := Self;
  TFrame(Self).Align := AValue;
end;

function TKalender.OnChangeDate(const AValue: TProcedureOnChangeRangeDate): IKalender;
begin
  Result := Self;
  FChangeRangeDate := AValue;
end;

function TKalender.OnChangeDate(const AValue: TProcedureOnChangeDate): IKalender;
begin
  Result := Self;
  FChangeDate := AValue;
end;

constructor TKalender.Create(AOwner: TComponent);
begin
  inherited;

  FConstraints := TKalenderConstraints.Create;
  FMode := TKalenderMode.None;

  Self.Size.Height := FConstraints.MinHeight;
  Self.Size.Width := FConstraints.MinWidth;

  FCalendar := TKalenderCalendar.Create(Self);
  FCalendar.Parent := Self;
  FCalendar.Position.Point := TPointF.Zero;
  FCalendar.Size := Self.Size;
  FCalendar.Date := Now();

  FCalendar.SendToBack;
end;

function TKalender.Date(const AValue: TDateTime): IKalender;
begin
  Result := Self;
  if Assigned(FCalendar) then
    FCalendar.Date := AValue;
end;

destructor TKalender.Destroy;
begin
  if FCalendar <> nil then
    freeAndNil(FCalendar);

  inherited;
end;

procedure TKalender.FrameResize(Sender: TObject);
begin
  if not InRange(Self.Size.Width, FConstraints.MinWidth, ifThen(FConstraints.MaxWidth > 0, FConstraints.MaxWidth, Self.Size.Width)) then
  begin
    if (FConstraints.MinWidth > 0) and (Self.Size.Width < FConstraints.MinWidth) then
      Self.Size.Width := FConstraints.MinWidth;

    if (FConstraints.MaxWidth > 0) and (Self.Size.Width > FConstraints.MaxWidth) then
      Self.Size.Width := FConstraints.MaxWidth;
  end;

  if not InRange(Self.Size.Height, FConstraints.MinHeight, ifThen(FConstraints.MaxHeight > 0, FConstraints.MaxHeight, Self.Size.Height)) then
  begin
    if (FConstraints.MinHeight > 0) and (Self.Size.Height < FConstraints.MinHeight) then
      Self.Size.Height := FConstraints.MinHeight;

    if (FConstraints.MaxHeight > 0) and (Self.Size.Height > FConstraints.MaxHeight) then
      Self.Size.Height := FConstraints.MaxHeight;
  end;

  if Assigned(FCalendar) then
    FCalendar.Size := Self.Size;
end;

function TKalender.Mode(const AValue: TKalenderMode): IKalender;
begin
  Result := Self;
  setMode(AValue);
end;

class function TKalender.New(AOwner: TComponent; ARenderParent: TFmxObject): IKalender;
begin
  Result := Self.Create(AOwner);
  TKalender(Result).Parent := ARenderParent;
end;

procedure TKalender.SetMode(const Value: TKalenderMode);
begin
  if Assigned(FCalendar)  then
    FCalendar.Mode := Value;
end;

end.
