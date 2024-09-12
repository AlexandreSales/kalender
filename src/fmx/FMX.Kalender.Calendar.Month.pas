
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
  TProcedureOnSetDate = procedure(const PDate: TDate) of Object;

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
    layWeek00Day01: TLayout;
    labWeek00Day01: TLabel;
    layWeek00Day02: TLayout;
    labWeek00Day02: TLabel;
    layWeek00Day03: TLayout;
    labWeek00Day03: TLabel;
    layWeek00Day04: TLayout;
    labWeek00Day04: TLabel;
    layWeek00Day05: TLayout;
    labWeek00Day05: TLabel;
    layWeek00Day06: TLayout;
    labWeek00Day06: TLabel;
    layWeek00Day07: TLayout;
    labWeek00Day07: TLabel;
    layWeek01Day01: TLayout;
    labWeek01Day01: TLabel;
    layWeek01Day02: TLayout;
    labWeek01Day02: TLabel;
    layWeek01Day03: TLayout;
    labWeek01Day03: TLabel;
    layWeek01Day04: TLayout;
    labWeek01Day04: TLabel;
    layWeek01Day05: TLayout;
    labWeek01Day05: TLabel;
    layWeek01Day06: TLayout;
    labWeek01Day06: TLabel;
    layWeek01Day07: TLayout;
    labWeek01Day07: TLabel;
    layWeek02Day01: TLayout;
    labWeek02Day01: TLabel;
    layWeek02Day02: TLayout;
    labWeek02Day02: TLabel;
    layWeek02Day03: TLayout;
    labWeek02Day03: TLabel;
    layWeek02Day04: TLayout;
    labWeek02Day04: TLabel;
    layWeek02Day05: TLayout;
    labWeek02Day05: TLabel;
    layWeek02Day06: TLayout;
    labWeek02Day06: TLabel;
    layWeek02Day07: TLayout;
    labWeek02Day07: TLabel;
    layWeek03Day01: TLayout;
    labWeek03Day01: TLabel;
    layWeek03Day02: TLayout;
    labWeek03Day02: TLabel;
    layWeek03Day03: TLayout;
    labWeek03Day03: TLabel;
    layWeek03Day04: TLayout;
    labWeek03Day04: TLabel;
    layWeek03Day05: TLayout;
    labWeek03Day05: TLabel;
    layWeek03Day06: TLayout;
    labWeek03Day06: TLabel;
    layWeek03Day07: TLayout;
    labWeek03Day07: TLabel;
    layWeek04Day01: TLayout;
    labWeek04Day01: TLabel;
    layWeek04Day02: TLayout;
    labWeek04Day02: TLabel;
    layWeek04Day03: TLayout;
    labWeek04Day03: TLabel;
    layWeek04Day04: TLayout;
    labWeek04Day04: TLabel;
    layWeek04Day05: TLayout;
    labWeek04Day05: TLabel;
    layWeek04Day06: TLayout;
    labWeek04Day06: TLabel;
    layWeek04Day07: TLayout;
    labWeek04Day07: TLabel;
    pnlDay: TPanel;
    pnlDaySelect: TPanel;
    flaDaySelect: TFloatAnimation;
    layWeek05Day01: TLayout;
    labWeek05Day01: TLabel;
    layWeek05Day02: TLayout;
    labWeek05Day02: TLabel;
    layWeek05Day03: TLayout;
    labWeek05Day03: TLabel;
    layWeek05Day04: TLayout;
    labWeek05Day04: TLabel;
    layWeek05Day05: TLayout;
    labWeek05Day05: TLabel;
    layWeek05Day06: TLayout;
    labWeek05Day06: TLabel;
    layWeek05Day07: TLayout;
    labWeek05Day07: TLabel;
  private
    { Private declarations }
    FInternalSetdate: Boolean;
    FUpdate: Boolean;
    FDate: TDate;
    FFirstDate: TDate;
    FLastDate: TDate;
    FonSetdate: TProcedureOnSetdate;
    FDateLock: TArray<string>;
    procedure SetDate(const Value: TDate);
    procedure setFirstDate(const Value: TDate);
  public
    { Public declarations }
    constructor Create(FOwner: TComponent); override;
    destructor Destroy; override;

    function GetDatePosition(point: tpointf; const SetDate: boolean = false): TDate;
    procedure Update;

    property FirstDate: TDate read FFirstDate write setFirstDate;
    property LastDate: TDate read FLastDate;
    property Date: TDate read FDate write SetDate;
    property OnSetDate: TProcedureOnSetdate read FonSetdate write FonSetdate;
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
    if (Self.components[lintCount] is tlayout) and (system.Pos('layWeek', tlayout(Self.components[lintCount]).name) > 0) and (system.Pos('Day', tlayout(Self.components[lintCount]).name) > 0) and
     (tlayout(Self.components[lintCount]).position.x < point.x) and ((tlayout(Self.components[lintCount]).position.x + tlayout(Self.components[lintCount]).width) > point.x) and
     (tlayout(Self.components[lintCount]).position.y < point.y) and ((tlayout(Self.components[lintCount]).position.y + tlayout(Self.components[lintCount]).height) > point.y) then
    begin
      if formatdatetime('MM', tlayout(Self.components[lintCount]).tag) <> FormatDateTime('MM', FDate) then
        Result := FDate
      else
        if tlayout(Self.components[lintCount]).tag > 0 then
          Result := tlayout(Self.components[lintCount]).tag;

      Break;
    end;

  if SetDate then
    Date := Result;
end;

procedure TKalenderCalendarMonth.SetDate(const Value: TDate);
var
  ldateWeek: TDate;
  ldateMonth: TDate;
  ldateEndWeek: TDate;
  ldateTest: TDate;

  lincWeek: integer;

  llabDay: TLabel;
  llayDay: tlayout;

  lupdate: boolean;
begin
  try
    if (Value <> FDate) or FUpdate then
    begin
      FDate := Value;
      lupdate := FUpdate;
      FUpdate := false;

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
        ldateMonth := incday(startoftheweek(ldateWeek), -1);

        //ultimo dia da semana e decremata 1 porque o delphi considera o ultimo dia da semana domingo
        ldateEndWeek := incday(endoftheweek(ldateWeek), -1);

        while ldateMonth <= ldateEndWeek do
        begin
          llabDay := findcomponent('labWeek' + formatfloat('00', lintCount) + 'Day' + formatfloat('00', dayofweek(ldateMonth))) as TLabel;
          llayDay := findcomponent('layWeek' + formatfloat('00', lintCount) + 'Day' + formatfloat('00', dayofweek(ldateMonth))) as tlayout;

          if (llabDay <> nil) and (llayDay <> nil) then
          begin
            if (formatdatetime('MM',  ldateMonth) <> formatdatetime('MM', FFirstDate)) then
              llabDay.StyleLookup := KALENDER_DAY_NOTAMONTH_TEXT
            else
            begin
              if trunc(ldateMonth) = trunc(FDate) then
              begin
                llabDay.StyleLookup := KALENDER_DAY_SELECT_TXT;

                pnlDaySelect.parent  := llayDay;
                pnlDaySelect.visible := True;
                if not(lupdate) then
                  flaDaySelect.start;

                pnlDaySelect.sendtoback;

                if trunc(ldateMonth) = trunc(system.sysUtils.Date) then
                  pnlDay.sendtoback;
              end
              else
                if trunc(ldateMonth) = trunc(system.sysUtils.Date) then
                  llabDay.StyleLookup := KALENDER_DAY_INDICATOR_TXT
                else
                begin
                  if (KalenderLocker.indexOf(ldateMonth) >= 0)  then
                    llabDay.StyleLookup := KALENDER_DAY_LOCK_TEXT
                  else
                    llabDay.StyleLookup := KALENDER_DAY;
                end;

              FLastDate := ldateMonth;
            end;
          end;

          ldateMonth := incDay(ldateMonth);
        end;
      end;

      if assigned(FonSetdate) and (Self.tag = 2) and not(FInternalSetdate) then
        FonSetdate(FDate);
    end;
  finally
    FInternalSetdate := false;
  end;
end;

procedure TKalenderCalendarMonth.setFirstDate(const Value: TDate);
var
  ldateMonth: TDate;
  ldateWeek: TDate;
  ldateEndWeek: TDate;

  lincWeek: integer;

  llabDay: TLabel;
  llayDay: tlayout;
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
        llayDay := findcomponent('layWeek' + formatfloat('00', lintCount) + 'Day' + formatfloat('00', dayofweek(ldateMonth))) as tlayout;

        if (llabDay <> nil) and (llayDay <> nil) then
        begin
          llabDay.text := formatdatetime('dd', ldateMonth);
          llayDay.tag := trunc(ldateMonth);

          if (formatdatetime('MM',  ldateMonth) <> formatdatetime('MM', FFirstDate)) then
            llabDay.StyleLookup := KALENDER_DAY_NOTAMONTH_TEXT
          else
          begin
            if trunc(ldateMonth) = trunc(system.sysutils.Date) then
            begin
              llabDay.StyleLookup := KALENDER_DAY_INDICATOR_TXT;

              pnlDay.parent := llayDay;
              pnlDay.visible := True;

              pnlDay.sendToBack;
            end
            else
              if trunc(ldateMonth) = trunc(FDate) then
                llabDay.StyleLookup := KALENDER_DAY_SELECT_TXT
              else
              begin
                if  (KalenderLocker.indexOf(ldateMonth) >= 0)  then
                  llabDay.StyleLookup := KALENDER_DAY_LOCK_TEXT
                else
                  llabDay.StyleLookup := KALENDER_DAY;
              end;

            FLastDate := ldateMonth;
          end;
        end;

        ldateMonth := incday(ldateMonth);
      end;
    end;
  end;
end;

procedure TKalenderCalendarMonth.Update;
begin
  FUpdate := True;
  Date := FDate;
end;

end.


