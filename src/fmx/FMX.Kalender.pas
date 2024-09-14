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
  System.Rtti,
  System.TypInfo,
  System.DateUtils,
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
    verKalender: TVertScrollBox;
    flowKalender: TFlowLayout;
    layRange: TLayout;
    btnKalenderOptionToday: TButton;
    btnKalenderOptionYesterday: TButton;
    btnKalenderOptionThisWeek: TButton;
    btnKalenderOptionLastWeek: TButton;
    btnKalenderOptionThisMonth: TButton;
    btnKalenderOptionLastMonth: TButton;
    btnKalenderOption60Days: TButton;
    btnKalenderOption90Days: TButton;
    btnKalenderOptionOneYear: TButton;
    KalenderLine: TLine;
    KalenderBackground: TPanel;
    StyleKalender: TStyleBook;
    KalenderBackgroundOptions: TPanel;
    grdKalenderRangeDate: TGridPanelLayout;
    LayKalender: TLayout;
    grdKalenderRangeDateGap: TLayout;
    layKalenderRangeDateStart: TLayout;
    layKalenderRangeDateEnd: TLayout;
    pnlKalenderRangeDateStart: TPanel;
    pnlKalenderRangeDateEnd: TPanel;
    labKalenderRangeDateStart: TLabel;
    labKalenderRangeDateEnd: TLabel;
    procedure FrameResize(Sender: TObject);
    procedure KalenderOptionClick(Sender: TObject);
  private
    { Private declarations }
    FCalendarStart: TKalenderCalendar;
    FCalendarEnd: TKalenderCalendar;

    FChangeDate: TProcedureOnChangeDate;
    FChangeRangeDate: TProcedureOnChangeRangeDate;
    FRangeMode: TKalenderRangeMode;
    FConstraints: IKalenderConstraints;
    FMode: TKalenderMode;
    FOwner: TComponent;
    FRenderParent: TFmxObject;

    FStartDate: TDate;
    FEndDate: TDate;

    procedure OnStartChangeDate(const ACurrentDate, AFirstDate, ALastDate: TDate);
    procedure OnEndChangeDate(const ACurrentDate, AFirstDate, ALastDate: TDate);

    procedure OnSetStartDate(const ACurrentDate, AFirstDate, ALastDate: TDate);
    procedure OnSetEndDate(const ACurrentDate, AFirstDate, ALastDate: TDate);

    procedure SetMode(const Value: TKalenderMode);
    procedure SetRangeMode(const Value: TKalenderRangeMode);
    procedure SetEndDate(const Value: TDate);
    procedure SetStartDate(const Value: TDate);
  protected
    { Protected declarations }
    property StartDate: TDate read FStartDate write SetStartDate;
    property EndDate: TDate read FEndDate write SetEndDate;
    property RangeMode: TKalenderRangeMode read FRangeMode write setRangeMode;
    property Constraints: IKalenderConstraints read FConstraints write FConstraints;
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function New(AOwner: TComponent;
                       ARenderParent: TFmxObject
                       ): IKalender;

    function Align(const AValue: TAlignLayout): IKalender;
    function Date(const AValue: TDate): IKalender;
    function Mode(const AValue: TKalenderMode): IKalender;
    function OnChangeDate(const AValue: TProcedureOnChangeDate): IKalender; Overload;
    function OnChangeDate(const AValue: TProcedureOnChangeRangeDate): IKalender; Overload;
  end;

implementation

{$R *.fmx}

{ Global }

function createName(const AOwner: TComponent): String;
var
  lindex: integer;
begin
  lindex := 1;
  result :=  format('%s%d', [KALENDER_NAME, lindex]);
  while true do
  begin
    if AOwner.FindComponent(result) = nil then
      break;

    inc(lindex);
    result := format('%s%d', [KALENDER_NAME, lindex]);
  end;
end;

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

procedure TKalender.OnEndChangeDate(const ACurrentDate, AFirstDate, ALastDate: TDate);
begin
  if (FMode = TKalenderMode.Range) and Assigned(FCalendarStart) and (AFirstDate <= EndOfTheMonth(FCalendarStart.Date)) then
  begin
    FCalendarStart.ListeningRange := False;
    FCalendarStart.Date := IncMonth(FCalendarStart.Date, - 1)
  end;
end;

procedure TKalender.OnSetEndDate(const ACurrentDate, AFirstDate, ALastDate: TDate);
begin
  if not(FMode = TKalenderMode.Range) then
    Exit;

  if (StartDate = 0) or (EndDate > 0) then
  begin
    StartDate := ACurrentDate;
    EndDate := 0;
  end
  else
    EndDate := ACurrentDate;

  if (EndDate > 0) and (EndDate < StartDate) then
  begin
    var LTransitionDate := StartDate;

    StartDate := EndDate;
    EndDate := LTransitionDate;
  end;

  if Assigned(FCalendarEnd) then
  begin
    FCalendarEnd.RangeDate := TKalenderRangeDate.Create(StartDate, EndDate);
    FCalendarStart.RangeDate := TKalenderRangeDate.Create(StartDate, EndDate);
  end;
end;

procedure TKalender.OnSetStartDate(const ACurrentDate, AFirstDate, ALastDate: TDate);
begin
  if not(FMode = TKalenderMode.Range) then
    Exit;

  if (StartDate = 0) or (EndDate > 0) then
  begin
    StartDate := ACurrentDate;
    EndDate := 0;
  end
  else
    EndDate := ACurrentDate;

  if (EndDate > 0) and (EndDate < StartDate) then
  begin
    var LTransitionDate := StartDate;

    StartDate := EndDate;
    EndDate := LTransitionDate;
  end;

  if Assigned(FCalendarEnd) then
  begin
    FCalendarEnd.RangeDate := TKalenderRangeDate.Create(StartDate, EndDate);
    FCalendarStart.RangeDate := TKalenderRangeDate.Create(StartDate, EndDate);
  end;
end;

procedure TKalender.OnStartChangeDate(const ACurrentDate, AFirstDate, ALastDate: TDate);
begin
  if (FMode = TKalenderMode.Range) and Assigned(FCalendarEnd) and (AFirstDate >= StartOfTheMonth(FCalendarEnd.Date)) then
  begin
    FCalendarEnd.ListeningRange := False;
    FCalendarEnd.Date := IncMonth(FCalendarEnd.Date, 1);
  end;
end;

function TKalender.OnChangeDate(const AValue: TProcedureOnChangeDate): IKalender;
begin
  Result := Self;
  FChangeDate := AValue;
end;

constructor TKalender.Create(AOwner: TComponent);
begin
  inherited;
  StartDate := 0;
  EndDate := 0;

  LayRange.Visible := False;
  grdKalenderRangeDate.Visible := False;

  FConstraints := TKalenderConstraints.Create;
  FMode := TKalenderMode.None;

  Self.Size.Height := FConstraints.MinHeight;
  Self.Size.Width := FConstraints.MinWidth;

  FCalendarStart := TKalenderCalendar.Create(Self);
  FCalendarStart.Name := 'CalendarStart';

  FCalendarStart.flaKalenderHeigth.StartValue := MIN_HEIGHT_WEEK;
  FCalendarStart.flaKalenderHeigth.StopValue := MIN_HEIGHT_MONTH;

  FCalendarStart.Parent := flowKalender;
  FCalendarStart.Position.Point := TPointF.Zero;
  FCalendarStart.Size := Self.Size;
  FCalendarStart.Date := Now();
  FCalendarStart.Align := TAlignLayout.Left;

  FCalendarStart.OnSetDate := OnSetStartDate;
  FCalendarStart.OnChangeCalendar := OnStartChangeDate;

  FCalendarEnd := nil;
end;

function TKalender.Date(const AValue: TDate): IKalender;
begin
  Result := Self;
  if Assigned(FCalendarStart) then
    FCalendarStart.Date := AValue;
end;

destructor TKalender.Destroy;
begin
  if FCalendarStart <> nil then
    freeAndNil(FCalendarStart);

  inherited;
end;

procedure TKalender.FrameResize(Sender: TObject);
var
  lwidth: Single;
  lheight: Single;
begin

  { width }
    lwidth := Self.Size.Width - (self.Padding.Left + Self.Padding.Right);
    if (FMode = TKalenderMode.Range) then
    begin
      lwidth := (Self.Size.Width - (layRange.Width + 40)) / 2;

      if (FConstraints.MinWidth > 0) and (lwidth < FConstraints.MinWidth) then
        lwidth := (Self.Size.Width - layRange.Width);
    end;

    if not InRange(lwidth, FConstraints.MinWidth, ifThen(FConstraints.MaxWidth > 0, FConstraints.MaxWidth, lwidth)) then
    begin
      if (FConstraints.MinWidth > 0) and (lwidth < FConstraints.MinWidth) then
        lwidth := FConstraints.MinWidth;

      if (FConstraints.MaxWidth > 0) and (lwidth > FConstraints.MaxWidth) then
        lwidth := FConstraints.MaxWidth;

      self.size.width := lwidth;
    end;

    if assigned(FCalendarStart) then
      if not(FMode = TKalenderMode.Range) then
      begin
        flowKalender.size.width := lwidth;
        FCalendarStart.Size.Width := lwidth;
      end
      else
      begin
        if Self.Size.Width < lwidth then
          Self.Size.Width := lwidth;

        flowKalender.size.width := Self.Size.Width;

        FCalendarStart.Size.Width := lwidth;
        FCalendarEnd.Size.Width := lwidth;
      end;

  { height }
    lheight := Self.Size.Height - (Self.Padding.Top + Self.Padding.Bottom);
    if (FMode = TKalenderMode.Range) then
      lheight := Self.Size.Height - (Self.Padding.Top + Self.Padding.Bottom);

    if not InRange(lheight, FConstraints.MinHeight, ifThen(FConstraints.MaxHeight > 0, FConstraints.MaxHeight, lheight)) then
    begin
      if (FConstraints.MinHeight > 0) and (lheight < FConstraints.MinHeight) then
        lheight := FConstraints.MinHeight;

      if (FConstraints.MaxHeight > 0) and (lheight > FConstraints.MaxHeight) then
        lheight := FConstraints.MaxHeight;

      self.size.height := lheight;
    end;

    if FMode = TKalenderMode.Range then
      lheight := lheight - (grdKalenderRangeDate.Size.Height + grdKalenderRangeDate.Margins.Top + grdKalenderRangeDate.Margins.Bottom);

    flowKalender.size.height := lheight;

    if assigned(FCalendarStart) then
    begin
      FCalendarStart.flaKalenderHeigth.StopValue := lheight;
      FCalendarStart.Size.Height := lheight;
    end;

    if assigned(FCalendarEnd) then
    begin
      FCalendarEnd.flaKalenderHeigth.StopValue := lheight;
      FCalendarEnd.Size.Height := lheight;
    end;

    if assigned(FCalendarStart) then
      FCalendarStart.ActivePage := FCalendarStart.ActivePage;

    if assigned(FCalendarEnd) then
      FCalendarEnd.ActivePage := FCalendarEnd.ActivePage;
end;

procedure TKalender.KalenderOptionClick(Sender: TObject);
begin
   if not(Sender is TButton) then
    Exit;

  RangeMode := TKalenderRangeMode(GetEnumValue(TypeInfo(TKalenderRangeMode), TButton(Sender).Hint));
end;

function TKalender.Mode(const AValue: TKalenderMode): IKalender;
begin
  Result := Self;
  setMode(AValue);
end;

class function TKalender.New(AOwner: TComponent; ARenderParent: TFmxObject): IKalender;
begin
  Result := Self.Create(AOwner);
  TKalender(Result).Name := createName(AOwner);
  TKalender(Result).Parent := ARenderParent;
  TKalender(Result).BringToFront;
end;

procedure TKalender.SetEndDate(const Value: TDate);
begin
  if Value <> FEndDate then
  begin
    FEndDate := Value;

    if FEndDate > 0 then
      labKalenderRangeDateEnd.Text := FormatDateTime('dd/MM/yyyy', FEndDate)
    else
      labKalenderRangeDateEnd.Text := '-';
  end;
end;

procedure TKalender.SetMode(const Value: TKalenderMode);
begin
  if Assigned(FCalendarStart) and (FMode <> FCalendarStart.Mode) then
  begin
    FMode := Value;

    case FMode of
    TKalenderMode.Week: FConstraints.MinHeight := MIN_HEIGHT_WEEK;
    TKalenderMode.Month: FConstraints.MinHeight := MIN_HEIGHT_MONTH;
    TKalenderMode.Range: FConstraints.MinHeight := MIN_HEIGHT_MONTH;
    end;

    if (FMode = TKalenderMode.Range) then
    begin
      FCalendarStart.Mode := TKalenderMode.Month;

      if FCalendarEnd = nil then
      begin
        FCalendarEnd := TKalenderCalendar.Create(Self);
        FCalendarEnd.Name := 'CalendarEnd';

        FCalendarEnd.flaKalenderHeigth.StartValue := FCalendarStart.flaKalenderHeigth.StartValue;
        FCalendarEnd.flaKalenderHeigth.StopValue := FCalendarStart.flaKalenderHeigth.StopValue;

        FCalendarEnd.Parent := flowKalender;
        FCalendarEnd.Position.Point := TPointF.Create(FCalendarStart.Position.X + 10, FCalendarStart.Position.Y);
        FCalendarEnd.Size := FCalendarStart.Size;
        FCalendarEnd.Date := IncMonth(Now(), 1);
        FCalendarEnd.Align := TAlignLayout.Left;

        FCalendarEnd.OnSetDate := OnSetEndDate;
        FCalendarEnd.OnChangeCalendar := OnEndChangeDate;
      end;
    end;

    FCalendarStart.Mode := FMode;

    if Assigned(FCalendarEnd) then
      FCalendarEnd.Mode := FMode;

    LayRange.Visible := FMode = TKalenderMode.Range;
    grdKalenderRangeDate.Visible := FMode = TKalenderMode.Range;
    Self.Resize;
  end;
end;

procedure TKalender.setRangeMode(const Value: TKalenderRangeMode);
begin
  if Value <> FRangeMode then
  begin
    FRangeMode := Value;

    case FRangeMode of
    TKalenderRangeMode.Today:
      begin
        StartDate := Now();
        EndDate := Now();
      end;
    TKalenderRangeMode.Yesterday:
      begin
        StartDate := IncDay(Now(), -1);
        EndDate := IncDay(Now(), - 1);
      end;
    TKalenderRangeMode.ThisWeek:
      begin
        StartDate := IncDay(StartOfTheWeek(Now()), - 1);
        EndDate := IncDay(EndOfTheWeek(Now()), - 1);
      end;
    TKalenderRangeMode.LastWeek:
      begin
        StartDate := IncDay(StartOfTheWeek( IncWeek(Now(), - 1)) - 2);
        EndDate := IncDay(EndOfTheWeek( IncWeek(Now(), - 1)) - 2);
      end;
    TKalenderRangeMode.ThisMonth:
      begin
        StartDate := StartOfTheMonth(Now());
        EndDate := EndOfTheMonth(Now());
      end;
    TKalenderRangeMode.LastMonth:
      begin
        StartDate := StartOfTheMonth( IncMonth( Now(), - 1) );
        EndDate := EndOfTheMonth( IncMonth( Now(), - 1) );
      end;
    TKalenderRangeMode.SixtyDays:
      begin
        StartDate := IncDay( Now(), - 60);
        EndDate := Now();
      end;
    TKalenderRangeMode.NinetyDays:
      begin
        StartDate := IncDay( Now(), - 90);
        EndDate := Now();
      end;
    TKalenderRangeMode.OneYear:
      begin
        StartDate := IncYear( Now(), - 1);
        EndDate := Now();
      end;
    end;

    FCalendarEnd.RangeDate := TKalenderRangeDate.Create(StartDate, EndDate);
    FCalendarStart.RangeDate := TKalenderRangeDate.Create(StartDate, EndDate);

    FCalendarEnd.ListeningRange := False;
    FCalendarEnd.Date := EndDate;

    FCalendarStart.ListeningRange := False;
    FCalendarStart.Date := StartDate;
  end;
end;

procedure TKalender.SetStartDate(const Value: TDate);
begin
  if Value <> FStartDate then
  begin
    FStartDate := Value;

    if FStartDate > 0 then
      labKalenderRangeDateStart.Text := FormatDateTime('dd/MM/yyyy', FStartDate)
    else
      labKalenderRangeDateStart.Text := '-';
  end;
end;

end.
