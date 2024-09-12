unit FMX.Kalender.Calendar.Week;

interface

uses
  { Delphi }
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  System.DateUtils,
  FMX.Types,
  FMX.Graphics,
  FMX.Controls,
  FMX.Forms,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Layouts,
  FMX.Gestures,
  FMX.Ani,
  FMX.Controls.Presentation,

  { Kalender }
  System.Kalender.Api;

type
  TProcedureOnSetDate = procedure(const PDate: tdate) of object;

  TKalenderCalendarWeek = class(TFrame)
    layWeek00: TLayout;
    labWeek00: TLabel;
    labWeekDay00: TLabel;
    layWeek01: TLayout;
    labWeek01: TLabel;
    labWeekDay01: TLabel;
    layWeek02: TLayout;
    labWeek02: TLabel;
    labWeekDay02: TLabel;
    layWeek03: TLayout;
    labWeek03: TLabel;
    labWeekDay03: TLabel;
    layWeek04: TLayout;
    labWeek04: TLabel;
    labWeekDay04: TLabel;
    layWeek05: TLayout;
    labWeek05: TLabel;
    labWeekDay05: TLabel;
    layWeek06: TLayout;
    labWeek06: TLabel;
    labWeekDay06: TLabel;
    pnlDaySelect: TPanel;
    pnlDay: TPanel;
    flaPnlDaySelect: TFloatAnimation;
  private
    { Private declarations }
    FDate: TDate;
    FUpdate: Boolean;
    FFirstDate: TDate;
    FInternalSetdate: Boolean;
    FOnSetdate: TProcedureOnSetDate;
    FLastDate: TDate;

    procedure SetDate(const Value: tdate);
    procedure SetFirstDate(const value: tdate);
  public
    { Public declarations }
    constructor Create(FOwner: TComponent); Override;
    destructor Destroy; Override;

    function GetDatePosition(const point: tpointf; const setdate: boolean = false): TDate;
    procedure Update;

    property FirstDate: TDate read FFirstDate write SetFirstDate;
    property LastDate: TDate read FlastDate;
    property Date: TDate read FDate write SetDate;
    property OnSetdate: TProcedureOnSetDate read FOnSetdate write FOnSetdate;
  end;

implementation

{$R *.fmx}

uses
  System.Kalender.Loker;

{ Tfrm_calender_week }

constructor TKalenderCalendarWeek.create(FOwner: TComponent);
begin
  inherited;

  finternalSetdate := false;
  fupdate := false;
end;

destructor TKalenderCalendarWeek.Destroy;
begin
  for var lintCount := 0 to Self.Componentcount - 1 do
  begin
    if (Self.Components[lintCount] is TLabel) then
    begin
      TLabel(Self.Components[lintCount]).StyleLookup := '';
      TLabel(Self.Components[lintCount]).ApplyStyleLookup;
    end;

    if (Self.Components[lintCount] is TPanel) then
    begin
      TPanel(Self.Components[lintCount]).StyleLookup := '';
      TPanel(Self.Components[lintCount]).ApplyStyleLookup;
    end;
  end;

  inherited;
end;

function TKalenderCalendarWeek.getDatePosition(const point: tpointf; const setdate: boolean = false): TDate;
var
  lintCount: integer;
begin
  Result := 0;

  for lintCount := 0 to Self.Componentcount - 1 do
    if (Self.components[lintCount] is TLayout) and (System.Pos('layWeek', TLayout(Self.components[lintCount]).Name) > 0) and
     (TLayout(Self.components[lintCount]).Position.X < Point.X) and ((TLayout(Self.components[lintCount]).Position.X + TLayout(Self.components[lintCount]).width) > Point.X) then
    begin
      Result := TLayout(Self.components[lintCount]).Tag;
      Break;
    end;

  if setdate then
    date := Result;
end;

procedure TKalenderCalendarWeek.setDate(const Value: tdate);
var
  lintCount: Integer;

  llabWeek: TLabel;
  llabWeekDay: TLabel;
  llayWeek: tlayout;
  LbooUpdate: boolean;
begin
  try
    if (Value <> FDate) or FUpdate then
    begin
      FDate := Value;
      LbooUpdate := FUpdate;
      FUpdate := False;

      pnlDaySelect.visible := False;
      pnlDaySelect.Parent  := nil;

      for lintCount := 0 to 6 do
      begin
        llabWeek    := findComponent('labWeek' + formatfloat('00', lintCount)) as TLabel;
        llabWeekDay := findComponent('labWeekDay' + formatfloat('00', lintCount)) as TLabel;
        llayWeek    := findComponent('layWeek' + formatfloat('00', lintCount)) as tlayout;

        if (llabWeek <> nil) and (llabWeekDay <> nil) and (llayWeek <> nil) then
        begin
          if (trunc(incDay(ffirstDate, lintCount)) = trunc(FDate)) then
          begin
            pnlDaySelect.Parent  := llayWeek;
            pnlDaySelect.visible := true;
            if not(LbooUpdate) then
              flapnlDaySelect.start;

            pnlDaySelect.SendToBack;

            if (trunc(incDay(ffirstDate, lintCount)) = Trunc(System.Sysutils.Date)) then
              pnlDay.SendToBack;

            llabWeekDay.Parent := pnlDaySelect;
            llabWeekDay.StyleLookup := KALENDER_DAY_SELECT_TXT;
          end
          else
          begin
            if (trunc(incDay(ffirstDate, lintCount)) = Trunc(System.Sysutils.Date)) then
            begin
              llabWeekDay.StyleLookup := KALENDER_DAY_INDICATOR_TXT;
              llabWeekDay.Parent := pnlDay;
            end
            else
            begin
              if (KalenderLocker.indexOf(incDay(ffirstDate, lintCount)) >= 0) then
                llabWeekDay.StyleLookup := KALENDER_DAY_LOCK_TEXT
              else
                llabWeekDay.StyleLookup := KALENDER_DAY;
              llabWeekDay.Parent := llayWeek;
            end;
          end;

          flastDate := incDay(ffirstDate, lintCount);
        end;
      end;

      if assigned(fonSetdate) and (self.tag = 2) and not(finternalSetdate) then
        fonSetdate(FDate);
    end;
  finally
    finternalSetdate := False;
  end;
end;

procedure TKalenderCalendarWeek.setfirstDate(const value: tdate);
var
  lintCount: Integer;

  llabWeek: TLabel;
  llabWeekDay: TLabel;
  llayWeek: tlayout;
begin
  if (value <> ffirstDate) then
  begin
    ffirstDate := value;

    pnlDay.visible := false;
    pnlDay.parent  := nil;
    pnlDay.sendtoback;

    for lintCount := 0 to 6 do
    begin
      llabWeek     := findcomponent('labWeek' + formatfloat('00', lintCount)) as TLabel;
      llabWeekDay  := findcomponent('labWeekDay' + formatfloat('00', lintCount)) as TLabel;
      llayWeek     := findcomponent('layWeek' + formatfloat('00', lintCount)) as TLayout;

      if (llabWeek <> nil) and (llabWeekDay <> nil) and (llayWeek <> nil) then
      begin
        llabWeek.text     := stringReplace(ansiUpperCase(formatdatetime('ddd', incDay(ffirstDate, lintCount))), '.', '', [rfReplaceAll]);
        llabWeekDay.text  := formatdatetime('dd', incDay(ffirstDate, lintCount));
        llayWeek.tag      := Trunc(incDay(ffirstDate, lintCount));

        if Trunc(incDay(ffirstDate, lintCount)) = Trunc(system.sysUtils.date) then
        begin
          llabWeekDay.StyleLookup := KALENDER_DAY_INDICATOR_TXT;

          pnlDay.parent := llayWeek;
          pnlDay.visible := true;

          pnlDay.sendToBack;
        end
        else
        begin
          if trunc(incDay(ffirstDate, lintCount)) = trunc(fdate) then
            llabWeekDay.StyleLookup := KALENDER_DAY_SELECT_TXT
          else
          begin
            if trunc(incDay(ffirstDate, lintCount)) = trunc(system.sysUtils.date) then
              llabWeekDay.StyleLookup := KALENDER_DAY_INDICATOR_TXT
            else
            begin
              if (KalenderLocker.indexOf(incDay(ffirstDate, lintCount)) >= 0) then
                llabWeekDay.StyleLookup := KALENDER_DAY_LOCK_TEXT
              else
                llabWeekDay.StyleLookup := KALENDER_DAY;
            end;
          end;
        end;

        flastDate := incDay(ffirstDate, lintCount);
      end;
    end;
  end;
end;

procedure TKalenderCalendarWeek.update;
begin
  FUpdate := true;
  Date := FDate;
end;

end.
