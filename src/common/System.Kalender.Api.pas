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
  {$SCOPEDENUMS OFF}

const
  { Kalender }
    { Style Indicators }
    KALENDER_DAY = 'KalenderDay';
    KALENDER_DAY_LOCK_TEXT = 'KalenderDayLockText';
    KALENDER_DAY_INDICATOR_TXT = 'KalenderDayIndicatorText';
    KALENDER_DAY_SELECT_TXT = 'KalenderDaySelectText';
    KALENDER_DAY_NOTAMONTH_TEXT = 'KalenderDayNotAMonthText';


implementation

end.
