unit System.Kalender.Api;

interface

uses
  { Delphi }
  System.SysUtils;

type
  {$SCOPEDENUMS ON}
    TKalenderMode = (
                     None,
                     Week,
                     Month,
                     Range
                    );

    TKalenderRangeMode = (
                      None,
                      Today,
                      Yesterday,
                      ThisWeek,
                      LastWeek,
                      ThisMonth,
                      LastMonth,
                      SixtyDays,
                      NinetyDays,
                      OneYear
                     );
  {$SCOPEDENUMS OFF}

  TKalenderRangeDate = record
    StartDate: TDate;
    EndDate: TDate;

    Public
      { public declarations }
      Constructor Create(const AStartDate, AEndDate: TDate);
  end;

const
  { Kalender }
    { Config }
    KALENDER_NAME = 'Kalender';

    { Style Indicators }
    KALENDER_DAY = 'KalenderDay';
    KALENDER_DAY_LOCK_TEXT = 'KalenderDayLockText';
    KALENDER_DAY_INDICATOR_TXT = 'KalenderDayIndicatorText';
    KALENDER_DAY_SELECT_TXT = 'KalenderDaySelectText';
    KALENDER_DAY_NOTAMONTH_TEXT = 'KalenderDayNotAMonthText';
    KALENDER_DAY_BACKGROUND = 'KalenderDayBackground';
    KALENDER_DAY_RANGE_BACKGROUND = 'KalenderDayRangeBackground';
    KALENDER_DAY_RANGESTART_BACKGROUND = 'KalenderDayRangeStartBackground';
    KALENDER_DAY_RANGEEND_BACKGROUND = 'KalenderDayRangeEndBackground';

    { Size Indicators }
    MIN_HEIGHT_WEEK = 125;
    MIN_HEIGHT_MONTH = 270;
    MIN_WIDTH = 250;
    MODE_HEIGHT = 50;

implementation

{ TKalenderRangeDate }

constructor TKalenderRangeDate.Create(const AStartDate, AEndDate: TDate);
begin
  Self.StartDate := AStartDate;
  Self.EndDate := AEndDate;
end;

end.
