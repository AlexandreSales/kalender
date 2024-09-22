
unit FMX.Kalender.Calendar.Month;

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
  FMX.Ani,
  FMX.Objects,
  FMX.Layouts,
  FMX.Controls.Presentation,

  { Kalender }
  System.Kalender.Api;

type
  TProcedureOnSetDate = procedure(const ADate: TDate; const AUpdate: Boolean = False) of Object;

  TKalenderCalendarMonth = class(TFrame)
    gridMonth: TGridPanelLayout;
    layWeek00: TLayout;
    labWeek00: TLabel;
    layWeek01: TLayout;
    labWeek01: TLabel;
    layWeek02: TLayout;
    labWeek02: TLabel;
    layWeek03: TLayout;
    labWeek03: TLabel;
    layWeek04: TLayout;
    labWeek04: TLabel;
    layWeek05: TLayout;
    labWeek05: TLabel;
    layWeek06: TLayout;
    labWeek06: TLabel;
    layWeek00Day01: TPanel;
    labWeek00Day01: TLabel;
    layWeek00Day02: TPanel;
    labWeek00Day02: TLabel;
    layWeek00Day03: TPanel;
    labWeek00Day03: TLabel;
    layWeek00Day04: TPanel;
    labWeek00Day04: TLabel;
    layWeek00Day05: TPanel;
    labWeek00Day05: TLabel;
    layWeek00Day06: TPanel;
    labWeek00Day06: TLabel;
    layWeek00Day07: TPanel;
    labWeek00Day07: TLabel;
    layWeek01Day01: TPanel;
    labWeek01Day01: TLabel;
    layWeek01Day02: TPanel;
    labWeek01Day02: TLabel;
    layWeek01Day03: TPanel;
    labWeek01Day03: TLabel;
    layWeek01Day04: TPanel;
    labWeek01Day04: TLabel;
    layWeek01Day05: TPanel;
    labWeek01Day05: TLabel;
    layWeek01Day06: TPanel;
    labWeek01Day06: TLabel;
    layWeek01Day07: TPanel;
    labWeek01Day07: TLabel;
    layWeek02Day01: TPanel;
    labWeek02Day01: TLabel;
    layWeek02Day02: TPanel;
    labWeek02Day02: TLabel;
    layWeek02Day03: TPanel;
    labWeek02Day03: TLabel;
    layWeek02Day04: TPanel;
    labWeek02Day04: TLabel;
    layWeek02Day05: TPanel;
    labWeek02Day05: TLabel;
    layWeek02Day06: TPanel;
    labWeek02Day06: TLabel;
    layWeek02Day07: TPanel;
    labWeek02Day07: TLabel;
    layWeek03Day01: TPanel;
    labWeek03Day01: TLabel;
    layWeek03Day02: TPanel;
    labWeek03Day02: TLabel;
    layWeek03Day03: TPanel;
    labWeek03Day03: TLabel;
    layWeek03Day04: TPanel;
    labWeek03Day04: TLabel;
    layWeek03Day05: TPanel;
    labWeek03Day05: TLabel;
    layWeek03Day06: TPanel;
    labWeek03Day06: TLabel;
    layWeek03Day07: TPanel;
    labWeek03Day07: TLabel;
    layWeek04Day01: TPanel;
    labWeek04Day01: TLabel;
    layWeek04Day02: TPanel;
    labWeek04Day02: TLabel;
    layWeek04Day03: TPanel;
    labWeek04Day03: TLabel;
    layWeek04Day04: TPanel;
    labWeek04Day04: TLabel;
    layWeek04Day05: TPanel;
    labWeek04Day05: TLabel;
    layWeek04Day06: TPanel;
    labWeek04Day06: TLabel;
    layWeek04Day07: TPanel;
    labWeek04Day07: TLabel;
    pnlDay: TPanel;
    pnlDaySelect: TPanel;
    flaDaySelect: TFloatAnimation;
    layWeek05Day01: TPanel;
    labWeek05Day01: TLabel;
    layWeek05Day02: TPanel;
    labWeek05Day02: TLabel;
    layWeek05Day03: TPanel;
    labWeek05Day03: TLabel;
    layWeek05Day04: TPanel;
    labWeek05Day04: TLabel;
    layWeek05Day05: TPanel;
    labWeek05Day05: TLabel;
    layWeek05Day06: TPanel;
    labWeek05Day06: TLabel;
    layWeek05Day07: TPanel;
    labWeek05Day07: TLabel;
    pnlEndDay: TPanel;
    flaEndDay: TFloatAnimation;
    pnlStartDay: TPanel;
    flaStartDay: TFloatAnimation;
  private
    { Private declarations }
    FInternalSetdate: Boolean;
    FUpdate: Boolean;
    FDate: TDate;
    FLastDate: TDate;
    FFirstDate: TDate;
    FRangeDate: TKalenderRangeDate;
    FOnSetdate: TProcedureOnSetdate;
    FDateLock: TArray<string>;
    FMode: TKalenderMode;
    function GetRangeDate: TKalenderRangeDate;
    procedure DisplayDate;
    procedure SetDate(const Value: TDate);
    procedure SetFirstDate(const Value: TDate);
    procedure SetCalenderMode(const Value: TKalenderMode);
    procedure SetRangeDate(const Value: TKalenderRangeDate);
  public
    { Public declarations }
    constructor Create(FOwner: TComponent); override;
    destructor Destroy; override;

    function GetDatePosition(point: tpointf; const SetDate: boolean = false): TDate;
    procedure Update;

    property FirstDate: TDate read FFirstDate write setFirstDate;
    property LastDate: TDate read FLastDate;
    property Date: TDate read FDate write SetDate;
    property Mode: TKalenderMode read FMode write SetCalenderMode;
    property OnSetDate: TProcedureOnSetdate read FonSetdate write FonSetdate;
    property RangeDate: TKalenderRangeDate read GetRangeDate write SetRangeDate;
  end;

implementation

{$R *.fmx}

uses
  System.Kalender.Loker;

{ Tfrm_calender_month }

constructor TKalenderCalendarMonth.Create(FOwner: TComponent);
begin
  inherited;
  FInternalSetdate := false;
  FUpdate := false;
end;

destructor TKalenderCalendarMonth.Destroy;
begin
  setLength(FDateLock, 0);
  inherited;
end;

function TKalenderCalendarMonth.GetDatePosition(point: tpointf; const SetDate: boolean): TDate;
var
  lintCount: integer;
begin
  Result := FDate;

  for lintCount := 0 to Self.componentcount - 1 do
    if (Self.components[lintCount] is TPanel) and (system.Pos('layWeek', TPanel(Self.components[lintCount]).name) > 0) and (system.Pos('Day', TPanel(Self.components[lintCount]).name) > 0) and
     (TPanel(Self.components[lintCount]).position.x < point.x) and ((TPanel(Self.components[lintCount]).position.x + TPanel(Self.components[lintCount]).width) > point.x) and
     (TPanel(Self.components[lintCount]).position.y < point.y) and ((TPanel(Self.components[lintCount]).position.y + TPanel(Self.components[lintCount]).height) > point.y) then
    begin
      if formatdatetime('MM', TPanel(Self.components[lintCount]).tag) <> FormatDateTime('MM', FDate) then
        Result := FDate
      else
        if TPanel(Self.components[lintCount]).tag > 0 then
          Result := TPanel(Self.components[lintCount]).tag;

      Break;
    end;

  if SetDate then
  begin
    if FMode = TKalenderMode.Range then
      Fupdate := True;
    Date := Result;
  end;
end;

function TKalenderCalendarMonth.getRangeDate: TKalenderRangeDate;
begin

end;

procedure TKalenderCalendarMonth.SetCalenderMode(const Value: TKalenderMode);
begin
  if Value <> FMode then
    FMode := Value;
end;

procedure TKalenderCalendarMonth.SetDate(const Value: TDate);
var
  LUpdate: Boolean;
begin
  try
    if (Value <> FDate) or FUpdate then
    begin
      LUpdate := FUpdate;
      FDate := Value;

      { Display }
      DisplayDate;

      if assigned(FonSetdate) and (Self.tag = 2) and not(FInternalSetdate) then
        FonSetdate(FDate, LUpdate);
    end;
  finally
    FInternalSetdate := false;
  end;
end;

procedure TKalenderCalendarMonth.DisplayDate;
var
  lincWeek: integer;
  ldateWeek: TDate;
  ldateMonth: TDate;
  ldateEndWeek: TDate;

  llabDay: TLabel;
  lpnlDay: TPanel;

  lUpDate: boolean;
begin
  lUpdate := FUpdate;
  FUpdate := False;

  pnlStartDay.visible := false;
  pnlEndDay.visible := false;
  pnlDaySelect.visible := false;
  pnlDaySelect.parent  := nil;

  for var lintCount := 0 to 5 do
  begin
    //incrementando a semana
    lincWeek := lintCount;
    if not(WeekOfTheMonth(FFirstDate) = 1) and (DayOfTheWeek(FFirstDate) = 7) then
    lincWeek := lintCount + 1;

    ldateWeek := incweek(FFirstDate, lincWeek);

    //primeiro dia da semana e decrementa 1 porque o delphi concidera o primeiro dia segunda-feira
    ldateMonth := Incday(startoftheweek(ldateWeek), -1);

    //ultimo dia da semana e decremata 1 porque o delphi considera o ultimo dia da semana domingo
    ldateEndWeek := Incday(endoftheweek(ldateWeek), -1);

    while ldateMonth <= ldateEndWeek do
    begin
      llabDay := findcomponent('labWeek' + formatfloat('00', lintCount) + 'Day' + formatfloat('00', dayofweek(ldateMonth))) as TLabel;
      lpnlDay := findcomponent('layWeek' + formatfloat('00', lintCount) + 'Day' + formatfloat('00', dayofweek(ldateMonth))) as TPanel;

      if llabDay <> nil then
        llabDay.StyleLookup := KALENDER_DAY;

      if (llabDay <> nil) and (lpnlDay <> nil) then
      begin
        lpnlDay.StyleLookup := KALENDER_DAY_BACKGROUND;

        if (formatdatetime('MM',  ldateMonth) <> formatdatetime('MM', FFirstDate)) then
          llabDay.StyleLookup := KALENDER_DAY_NOTAMONTH_TEXT
        else
        begin

          if (trunc(ldateMonth) = trunc(FDate)) or (trunc(ldateMonth) = trunc(FRangeDate.StartDate)) or (trunc(ldateMonth) = trunc(FRangeDate.EndDate))  then
          begin
            case FMode of
            TKalenderMode.Week, TKalenderMode.Month:
              begin
                llabDay.StyleLookup := KALENDER_DAY_SELECT_TXT;

                pnlStartDay.Visible := False;
                pnlEndDay.Visible := False;

                pnlDaySelect.parent  := lpnlDay;
                pnlDaySelect.visible := True;
                if not(lupdate) then
                  flaDaySelect.start;

                pnlDaySelect.sendtoback;

                if trunc(ldateMonth) = trunc(system.sysUtils.Date) then
                  pnlDay.sendtoback;
              end;
            TKalenderMode.Range:
              begin
                pnlDaySelect.visible := False;

                if trunc(ldateMonth) = trunc(FRangeDate.StartDate) then
                begin
                  llabDay.StyleLookup := KALENDER_DAY_SELECT_TXT;

                  if (trunc(FRangeDate.StartDate) <> trunc(FRangeDate.EndDate)) and (FRangeDate.EndDate > 0) then
                    lpnlDay.StyleLookup := KALENDER_DAY_RANGESTART_BACKGROUND;

                  pnlStartDay.Parent  := lpnlDay;
                  pnlStartDay.Visible := True;
                  if not(LupDate) then
                    flaStartDay.start;

                  pnlStartDay.sendtoback;

                  if trunc(ldateMonth) = trunc(system.sysUtils.Date) then
                    pnlDay.SendToBack;
                end;

                if trunc(ldateMonth) = trunc(FRangeDate.EndDate) then
                begin
                  llabDay.StyleLookup := KALENDER_DAY_SELECT_TXT;

                  if (trunc(FRangeDate.StartDate) <> trunc(FRangeDate.EndDate)) and (FRangeDate.EndDate > 0) then
                    lpnlDay.StyleLookup := KALENDER_DAY_RANGEEND_BACKGROUND;

                  pnlEndDay.Parent  := lpnlDay;
                  pnlEndDay.Visible := True;
                  if not(LupDate) then
                    flaStartDay.start;

                  pnlEndDay.sendtoback;

                  if trunc(ldateMonth) = trunc(system.sysUtils.Date) then
                    pnlDay.SendToBack;
                end;
              end;
            end;

          end
          else
          begin
            if (KalenderLocker.indexOf(ldateMonth) >= 0)  then
              llabDay.StyleLookup := KALENDER_DAY_LOCK_TEXT
            else
              llabDay.StyleLookup := KALENDER_DAY;
          end;

          if (FMode = TKalenderMode.Range) and VarInRange(trunc(ldateMonth), Trunc(IncDay(FRangeDate.StartDate, 1)), Trunc(IncDay(FRangeDate.EndDate, - 1))) then
            lpnlDay.StyleLookup := KALENDER_DAY_RANGE_BACKGROUND;

          if trunc(ldateMonth) = trunc(system.sysUtils.Date) then
          begin
            llabDay.StyleLookup := KALENDER_DAY_INDICATOR_TXT;

            pnlDay.parent := lpnlDay;
            pnlDay.visible := True;

            pnlDay.SendToBack;
          end;

          FLastDate := ldateMonth;
        end;
      end;

      ldateMonth := incDay(ldateMonth);
    end;
  end;
end;

procedure TKalenderCalendarMonth.setFirstDate(const Value: TDate);
var
  ldateMonth: TDate;
  ldateWeek: TDate;
  ldateEndWeek: TDate;

  lincWeek: integer;

  llabDay: TLabel;
  lpnlDay: TPanel;
begin
  if Value <> FFirstDate then
  begin
    //pega a data enviada e procurar o primeiro dia do mes
    FFirstDate := startofthemonth(Value);

    pnlDay.visible := false;
    pnlDay.parent := nil;
    pnlDay.sendToBack;

    for var lintCount := 0 to 5 do
    begin
      //incrementando a semana

      lincWeek := lintCount;
      if not(WeekOfTheMonth(FFirstDate) = 1) and (DayOfTheWeek(FFirstDate) = 7) then
        lincWeek := lintCount + 1;

      ldateWeek := incweek(FFirstDate, lincWeek);

      //primeiro dia da semana e decrementa 1 porque o delphi concidera o primeiro dia segunda-feira
      ldateMonth := incday(startoftheweek(ldateWeek), -1);

      //ultimo dia da semana e decremata 1 porque o delphi considera o ultimo dia da semana domingo
      ldateEndWeek := incday(endoftheweek(ldateWeek), -1);

      while ldateMonth <= ldateEndWeek do
      begin
        llabDay := findcomponent('labWeek' + formatfloat('00', lintCount) + 'Day' + formatfloat('00', dayofweek(ldateMonth))) as TLabel;
        lpnlDay := findcomponent('layWeek' + formatfloat('00', lintCount) + 'Day' + formatfloat('00', dayofweek(ldateMonth))) as TPanel;

        if (llabDay <> nil) and (lpnlDay <> nil) then
        begin
          llabDay.text := formatdatetime('dd', ldateMonth);
          lpnlDay.tag := trunc(ldateMonth);

          if (formatdatetime('MM',  ldateMonth) <> formatdatetime('MM', FFirstDate)) then
            llabDay.StyleLookup := KALENDER_DAY_NOTAMONTH_TEXT
          else
          begin
            if (trunc(ldateMonth) = trunc(FDate)) or (trunc(ldateMonth) = trunc(FRangeDate.StartDate)) or (trunc(ldateMonth) = trunc(FRangeDate.EndDate))  then
            begin
              case FMode of
              TKalenderMode.Week, TKalenderMode.Month:
                begin
                  llabDay.StyleLookup := KALENDER_DAY_SELECT_TXT;

                  pnlStartDay.Visible := False;
                  pnlEndDay.Visible := False;

                  pnlDaySelect.parent  := lpnlDay;
                  pnlDaySelect.visible := True;

                  pnlDaySelect.SendToBack;

                  if trunc(ldateMonth) = trunc(system.sysUtils.Date) then
                    pnlDay.sendtoback;
                end;
              TKalenderMode.Range:
                begin
                  pnlDaySelect.visible := False;

                  if trunc(ldateMonth) = trunc(FRangeDate.StartDate) then
                  begin
                    llabDay.StyleLookup := KALENDER_DAY_SELECT_TXT;

                    if (trunc(FRangeDate.StartDate) <> trunc(FRangeDate.EndDate)) and (FRangeDate.EndDate > 0) then
                      lpnlDay.StyleLookup := KALENDER_DAY_RANGESTART_BACKGROUND;

                    pnlStartDay.Parent  := lpnlDay;
                    pnlStartDay.Visible := True;

                    pnlStartDay.SendToBack;

                    if trunc(ldateMonth) = trunc(system.sysUtils.Date) then
                      pnlDay.SendToBack;
                  end;

                  if trunc(ldateMonth) = trunc(FRangeDate.EndDate) then
                  begin
                    llabDay.StyleLookup := KALENDER_DAY_SELECT_TXT;

                    if (trunc(FRangeDate.StartDate) <> trunc(FRangeDate.EndDate)) and (FRangeDate.EndDate > 0) then
                      lpnlDay.StyleLookup := KALENDER_DAY_RANGEEND_BACKGROUND;

                    pnlEndDay.Parent  := lpnlDay;
                    pnlEndDay.Visible := True;
                    pnlEndDay.SendToBack;

                    if trunc(ldateMonth) = trunc(system.sysUtils.Date) then
                      pnlDay.SendToBack;
                  end;
                end;
              end;

            end
            else
            begin
              if trunc(ldateMonth) = trunc(system.sysUtils.Date) then
              begin
                llabDay.StyleLookup := KALENDER_DAY_INDICATOR_TXT;

                pnlDay.parent := lpnlDay;
                pnlDay.visible := True;

                pnlDay.sendToBack;
              end
              else
              begin
                if (KalenderLocker.indexOf(ldateMonth) >= 0)  then
                  llabDay.StyleLookup := KALENDER_DAY_LOCK_TEXT
                else
                  llabDay.StyleLookup := KALENDER_DAY;
              end;
            end;

            if (FMode = TKalenderMode.Range) and VarInRange(trunc(ldateMonth), Trunc(IncDay(FRangeDate.StartDate, 1)), Trunc(IncDay(FRangeDate.EndDate, - 1))) then
              lpnlDay.StyleLookup := KALENDER_DAY_RANGE_BACKGROUND;

            FLastDate := ldateMonth;
          end;
        end;

        ldateMonth := incday(ldateMonth);
      end;
    end;
  end;
end;

procedure TKalenderCalendarMonth.setRangeDate(const Value: TKalenderRangeDate);
begin
  FRangeDate := Value;
  DisplayDate;
end;

procedure TKalenderCalendarMonth.Update;
begin
  DisplayDate;
end;

end.


