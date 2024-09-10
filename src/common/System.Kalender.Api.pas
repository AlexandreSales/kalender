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
    { Config }
    KALENDER_NAME = 'Kalender';

    { Style Indicators }
    KALENDER_DAY = 'KalenderDay';
    KALENDER_DAY_LOCK_TEXT = 'KalenderDayLockText';
    KALENDER_DAY_INDICATOR_TXT = 'KalenderDayIndicatorText';
    KALENDER_DAY_SELECT_TXT = 'KalenderDaySelectText';
    KALENDER_DAY_NOTAMONTH_TEXT = 'KalenderDayNotAMonthText';

    { Size Indicators }
    MIN_HEIGHT_WEEK = 120;
    MIN_HEIGHT_MONTH = 270;
    MIN_WIDTH = 250;
    MODE_HEIGHT = 50;

implementation

end.
