unit FMX.Kalender.Calendar;

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
  FMX.Ani,
  FMX.Gestures,
  FMX.Controls.Presentation,
  FMX.Effects,

  { Kalender }
  System.Kalender.Api,
  System.Kalender.Loker,
  FMX.Kalender.Calendar.Week,
  FMX.Kalender.Calendar.Month;

type
  tprocedureOnSetDate = procedure(const pcurrentDate, pfirstDate, plastDate: tdate) of object;

  TKalenderCalendar = class(TFrame)
    layKalender: TLayout;
    layKalenderTitle: TLayout;
    labKalenderTitle: TLabel;
    layWeeksScroll: TLayout;
    layWeeks: TLayout;
    flaLayWeek: TFloatAnimation;
    layMonthsScroll: TLayout;
    layMonths: TLayout;
    flaLayMonth: TFloatAnimation;
    flaWeeksOpacity: TFloatAnimation;
    flaMonthsOpacity: TFloatAnimation;
    flaKalenderHeigth: TFloatAnimation;
    rctKalenderBackground: TPanel;
    efcKalenderBackShadow: TShadowEffect;
    btnKalenderBack: TButton;
    btnKalendarNext: TButton;
    btnKalenderMode: TButton;

    procedure layWeeksScrollMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure layWeeksScrollMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure layWeeksScrollMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure layWeeksScrollMouseLeave(Sender: TObject);
    procedure flaLayWeekFinish(Sender: TObject);
    procedure layWeeksScrollTap(Sender: TObject; const Point: TPointF);
    procedure btnKalenderBackClick(Sender: TObject);
    procedure btnKalendarNextClick(Sender: TObject);
    procedure layWeeksScrollResize(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure flaLayMonthFinish(Sender: TObject);
    procedure flaKalenderHeigthFinish(Sender: TObject);
    procedure btnKalenderModeClick(Sender: TObject);
    procedure flaKalenderHeigthProcess(Sender: TObject);
  private
    { Private declarations }
    factivePage: integer;
    fdownIndex: integer;
    fstartDrag: boolean;
    fupdate: boolean;
    fdonwPos: tpointf;
    fdate: tdate;
    fonSetDate: tprocedureOnSetDate;
    FMode: TKalenderMode;

    FWeek1: TKalenderCalendarWeek;
    FWeek2: TKalenderCalendarWeek;
    FWeek3: TKalenderCalendarWeek;

    FMonth1: TKalenderCalendarMonth;
    FMonth2: TKalenderCalendarMonth;
    FMonth3: TKalenderCalendarMonth;

    procedure setEndDrag(sender: tobject);

    procedure setEndWeek;
    procedure setEndMonth;

    procedure setActivePage(const value: integer);
    procedure setDate(const value: tdate);
    procedure SetCalenderMode(const value: TkalenderMode);
    function  Getlockers: TKalenderLocker;
  protected
    { protected declarations }
    procedure SetParent(const value: tfmxObject); override;
    procedure SetAlign(const value: talignLayout); Override;
  public
    { public declarations }
    Constructor Create(FOwner: TComponent); Override;
    Destructor  Destroy; Override;

    procedure UpDate;
    procedure Resize(const psetPosition: boolean = true);

    property ActivePage: integer read factivePage write setActivePage;
    property Date: tdate read fdate write setDate;
    property OnSetDate: tprocedureOnSetDate read fonSetDate write fonSetDate;
    property Mode: TKalenderMode read FMode write SetCalenderMode;
    property Lockers: TKalenderLocker read getlockers;
  end;

implementation

{$R *.fmx}

{ Tfrm_calender }

  function remainder(const pdbl_numerator, pdbl_denominator: Double): Double;
  begin
    result := trunc((pdbl_numerator / pdbl_denominator) * 100) - (trunc(pdbl_numerator / pdbl_denominator) * 100);
  end;

constructor TKalenderCalendar.create(FOwner: TComponent);
begin
  inherited;
  FMode := TKalenderMode.Week;
  fdate := 0;

  factivePage  := 1;
  fstartDrag   := false;

  fupdate := false;

  fdonwPos     := pointf(0, 0);
  fdownIndex   := -1;

  KalenderLocker := TKalenderLocker.Create;

  FWeek1 := TKalenderCalendarWeek.create(nil);
  with FWeek1 do
  begin
    name := 'Week1';

    parent      := layWeeks;
    position.X  := 0;
    align       := talignlayout.left;
    tag         := 1;
    onSetdate   := setDate;
    hitTest     := false;

    width := self.width;
  end;

  FWeek2 := TKalenderCalendarWeek.create(nil);
  with FWeek2 do
  begin
    name := 'Week2';

    parent      := layWeeks;
    position.X  := FWeek1.position.x + FWeek1.size.width + 1;
    align       := talignlayout.left;
    tag         := 2;
    onSetdate   := setDate;
    hitTest     := false;

    width := self.width;
  end;

  FWeek3 := TKalenderCalendarWeek.create(nil);
  with FWeek3 do
  begin
    name := 'Week3';

    parent      := layWeeks;
    position.X  := FWeek2.position.x + FWeek2.size.width + 1;
    align       := talignlayout.left;
    tag         := 3;
    onSetdate   := setDate;
    hitTest     := false;

    width := self.width;
  end;

  FMonth1 := TKalenderCalendarMonth.create(nil);
  with FMonth1 do
  begin
    name := 'Month1';

    parent      := layMonths;
    position.X  := 0;
    align       := talignlayout.left;
    tag         := 1;
    onSetdate   := setDate;
    hitTest     := false;

    width := self.width;
  end;

  FMonth2 := TKalenderCalendarMonth.create(nil);
  with FMonth2 do
  begin
    name := 'Month2';

    parent      := layMonths;
    position.X  := FMonth1.position.x + FMonth1.size.width + 1;
    align       := talignlayout.left;
    tag         := 2;
    onSetdate   := setDate;
    hitTest     := false;

    width := self.width;
  end;

  FMonth3 := TKalenderCalendarMonth.create(nil);
  with FMonth3 do
  begin
    name := 'Month3';

    parent      := layMonths;
    position.X  := FMonth2.position.x + FMonth2.size.width + 1;
    align       := talignlayout.left;
    tag         := 3;
    onSetdate   := setDate;
    hitTest     := false;

    width := self.width;
  end;

  resize;

  FMode := TKalenderMode.Week;
  date := date;
end;

destructor TKalenderCalendar.Destroy;
begin
  if FWeek1 <> nil then
    freeandnil(FWeek1);

  if FWeek2 <> nil then
    freeandnil(FWeek2);

  if FWeek3 <> nil then
    freeandnil(FWeek3);

  if FMonth1 <> nil then
    freeAndNil(FMonth1);

  if FMonth2 <> nil then
    freeAndnil(FMonth2);

  if FMonth3 <> nil then
    freeAndNil(FMonth3);

  if KalenderLocker <> nil then
    freeandnil(KalenderLocker);

  inherited;
end;

procedure TKalenderCalendar.flaKalenderHeigthFinish(Sender: TObject);
begin
  layweeksscroll.visible := FMode = TKalenderMode.Week;
  layMonthsScroll.visible := FMode in [TKalenderMode.Month, TKalenderMode.Range];

  case FMode of
  TKalenderMode.Week: btnKalenderMode.StylesData['icon.RotationAngle'] := 0;
  TKalenderMode.Month, TKalenderMode.Range: btnKalenderMode.StylesData['icon.RotationAngle'] := 180;
  end;

  TControl(Self.Parent).Size.Height := Self.Size.Height;
end;

procedure TKalenderCalendar.flaKalenderHeigthProcess(Sender: TObject);
begin
  TControl(Self.Parent).Size.Height := Self.Size.Height;
end;

procedure TKalenderCalendar.flaLayMonthFinish(Sender: TObject);
begin
  setEndMonth;
end;

procedure TKalenderCalendar.flaLayWeekFinish(Sender: TObject);
begin
  setEndWeek;
end;

procedure TKalenderCalendar.FrameResize(Sender: TObject);
begin
  resize;
end;

function TKalenderCalendar.getlockers: TKalenderLocker;
begin
  Result := KalenderLocker;
end;

procedure TKalenderCalendar.btnKalenderBackClick(Sender: TObject);
begin
  case FMode of
  TKalenderMode.Week: date := incWeek(date, -1);
  TKalenderMode.Month, TKalenderMode.Range: date := incMonth(date, -1);
  end;
end;

procedure TKalenderCalendar.btnKalendarNextClick(Sender: TObject);
begin
  case FMode of
  TKalenderMode.Week: date := incWeek(date, 1);
  TKalenderMode.Month, TKalenderMode.Range: date := incMonth(date, 1);
  end;
end;

procedure TKalenderCalendar.btnKalenderModeClick(Sender: TObject);
begin
  case FMode of
  TKalenderMode.Week: Mode := TKalenderMode.Month;
  TKalenderMode.Month, TKalenderMode.Range: Mode := TKalenderMode.Week;
  end;
end;

procedure TKalenderCalendar.layWeeksScrollMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if (activePage >= 0) and (Button = TMouseButton.mbLeft) then
  begin
    fstartDrag := true;
    fdonwPos   := pointf(x, y);
    fdownIndex := activePage;
    
    {$if defined(mswindows) or defined(osx)}
      if (sender is tlayout) then
        case TKalenderMode(tlayout(sender).tag) of
        TKalenderMode.Week: FWeek2.getDatePosition(pointf(x, y), true);
        TKalenderMode.Month, TKalenderMode.Range: FMonth2.getDatePosition(pointf(x, y), true);
        end;
    {$endif}
  end;
end;

procedure TKalenderCalendar.layWeeksScrollMouseLeave(Sender: TObject);
begin
  inherited;
  setEndDrag(Sender);
end;

procedure TKalenderCalendar.layWeeksScrollMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
var
  lsglDeltaX: single;
  lsglNewX: single;
begin
  inherited;

  if fstartDrag then
  begin
    lsglDeltaX  := x - fdonwPos.x;
    lsglNewX := - fdownIndex * Width + lsglDeltaX;

    if (sender is tlayout) then
      case TKalenderMode(tlayout(sender).tag) of
      TKalenderMode.Week: layWeeks.position.x := lsglNewX;
      TKalenderMode.Month, TKalenderMode.Range: layMonths.position.x := lsglNewX;
      end;
  end;
end;

procedure TKalenderCalendar.layWeeksScrollMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;   
  setEndDrag(sender);
end;

procedure TKalenderCalendar.layWeeksScrollResize(Sender: TObject);
begin
  resize;
end;

procedure TKalenderCalendar.layWeeksScrollTap(Sender: TObject; const Point: TPointF);
begin
  if (sender is tlayout) then
    case TKalenderMode(tlayout(sender).tag) of
    TKalenderMode.Week: FWeek2.getDatePosition(point, true);
    TKalenderMode.Month, TKalenderMode.Range:
      begin

      {$if defined(mswindows) or defined(osx)}
        FMonth2.getDatePosition(point, true);
      {$else}
        var linduc := tlayout(sender).position.y + tframe(tlayout(sender).parent.parent).position.y + tcontrol(tlayout(sender).parent.parent.parent.parent.parent.parent.parent.parent).position.y;
        FMonth2.getDatePosition(tpointf.create(point.x, point.y - linduc), true);
      {$endif}
      end;
    end;
end;


procedure TKalenderCalendar.resize(const psetPosition: boolean = true);
begin
  if FWeek1 <> nil then
    FWeek1.size.width := self.width;

  if FWeek2 <> nil then
    FWeek2.size.width := self.width;

  if FWeek3 <> nil then
    FWeek3.size.width := self.width;

  layWeeks.size.width := (self.width * 3);

  if FMonth1 <> nil then
    FMonth1.size.width := self.width;

  if FMonth2 <> nil then
    FMonth2.size.width := self.width;

  if FMonth3 <> nil then
    FMonth3.size.width := self.width;

  layWeeks.size.width := (self.width * 3);
  layWeeks.size.height := layWeeksScroll.height;

  layMonths.size.height := layMonthsScroll.height;

  if psetPosition then
    layWeeks.position.x := - self.width;
end;

procedure TKalenderCalendar.SetAlign(const Value: talignLayout);
begin
  inherited;
  resize;
end;

procedure TKalenderCalendar.setEndDrag(sender: tobject);
var
  lintPage: integer;
begin
  inherited;

  if (sender is tlayout) and fstartDrag then
  begin
    fstartDrag := false;

    case TKalenderMode(tlayout(sender).tag) of
    TKalenderMode.Week:
      begin
        lintPage := abs(trunc(layWeeks.position.x / width));
        if (abs(remainder(layWeeks.position.x, width)) > 50) then
          lintPage := lintPage + 1;
      end;
    TKalenderMode.Month, TKalenderMode.Range:
      begin
        lintPage := abs(trunc(layMonths.position.x / width));
        if (abs(remainder(layMonths.position.x, width)) > 50) then
          lintPage := lintPage + 1;
      end;
    end;                                 

    if lintPage > 2 then
      lintPage := 2
    else
      if lintPage < 0 then
        lintPage := 0;

    activePage := lintPage;
  end;
end;

procedure TKalenderCalendar.setEndMonth;
var
  lcalenderMonth : TKalenderCalendarMonth;
begin

  case  factivePage of
  0:
    begin
      lcalenderMonth := findcomponent('Month3') as TKalenderCalendarMonth;
      if lcalenderMonth <> nil then
      begin
        lcalenderMonth.DisposeOf;
        lcalenderMonth := nil;
      end;

      lcalenderMonth := findcomponent('Month2') as TKalenderCalendarMonth;
      if lcalenderMonth <> nil then
      begin
        lcalenderMonth.name := 'Month3';
        lcalenderMonth.tag  := 3;
        lcalenderMonth := nil;
      end;

      lcalenderMonth := findcomponent('Month1') as TKalenderCalendarMonth;
      if lcalenderMonth <> nil then
      begin
        lcalenderMonth.name := 'Month2';
        lcalenderMonth.tag  :=2;
        lcalenderMonth := nil;
      end;

      lcalenderMonth := findcomponent('Month2') as TKalenderCalendarMonth;
      if lcalenderMonth <> nil then
        with TKalenderCalendarMonth.create(self) do
        begin
          name := 'Month1';

          Parent      := layMonths;
          Position.X  := lcalenderMonth.position.x - (lcalenderMonth.width + 1);
          Align       := talignlayout.left;
          tag         := 1;
          onSetdate  := setDate;

          lcalenderMonth := nil;

          width := self.width;
        end;

      factivePage := 1;
      layMonths.position.x := - self.width;

      date := IncMonth(date, -1);
    end;
  2:
    begin
      lcalenderMonth := findcomponent('Month1') as TKalenderCalendarMonth;
      if lcalenderMonth <> nil then
      begin
        lcalenderMonth.disposeof;
        lcalenderMonth := nil;
      end;

      lcalenderMonth := findcomponent('Month2') as TKalenderCalendarMonth;
      if lcalenderMonth <> nil then
      begin
        lcalenderMonth.name := 'Month1';
        lcalenderMonth.tag  := 1;
        lcalenderMonth := nil;
      end;

      lcalenderMonth := findcomponent('Month3') as TKalenderCalendarMonth;
      if lcalenderMonth <> nil then
      begin
        lcalenderMonth.name := 'Month2';
        lcalenderMonth.tag  := 2;

        lcalenderMonth := nil;
      end;

      lcalenderMonth := findcomponent('Month2') as TKalenderCalendarMonth;
      if lcalenderMonth <> nil then
        with TKalenderCalendarMonth.create(self) do
        begin
          name := 'Month3';

          Parent      := layMonths;
          Position.X  := lcalenderMonth.position.x + (lcalenderMonth.width + 1);
          Align       := talignlayout.left;
          Tag         := 3;
          onSetdate  := setDate;

          width := self.width;

          lcalenderMonth := nil;
        end;

      factivePage := 1;
      layMonths.position.x := - self.width;

      date := incmonth(date, 1);
    end;
  end;
end;

procedure TKalenderCalendar.setEndWeek;
var
  lWeek : TKalenderCalendarWeek;
begin

  case  factivePage of
  0:
    begin
      lWeek := findcomponent('Week3') as TKalenderCalendarWeek;
      if lWeek <> nil then
      begin
        lWeek.DisposeOf;
        lWeek := nil;
      end;

      lWeek := findcomponent('Week2') as TKalenderCalendarWeek;
      if lWeek <> nil then
      begin
        lWeek.name := 'Week3';
        lWeek.tag  := 3;
        lWeek := nil;
      end;

      lWeek := findcomponent('Week1') as TKalenderCalendarWeek;
      if lWeek <> nil then
      begin
        lWeek.name := 'Week2';
        lWeek.tag  := 2;
        lWeek := nil;
      end;

      lWeek := findcomponent('Week2') as TKalenderCalendarWeek;
      if lWeek <> nil then
        with TKalenderCalendarWeek.create(self) do
        begin
          name := 'Week1';

          Parent      := layWeeks;
          Position.X  := lWeek.Position.x - (lWeek.Width + 1);
          Align       := talignlayout.left;
          tag         := 1;
          onSetdate  := setDate;

          lWeek := nil;

          width := self.width;
        end;

      factivePage := 1;
      layWeeks.position.x := - self.width;

      date := IncWeek(date, -1);
    end;
  2:
    begin
      lWeek := findcomponent('Week1') as TKalenderCalendarWeek;
      if lWeek <> nil then
      begin
        lWeek.DisposeOf;
        lWeek := nil;
      end;

      lWeek := findcomponent('Week2') as TKalenderCalendarWeek;
      if lWeek <> nil then
      begin
        lWeek.name := 'Week1';
        lWeek.tag  := 1;
        lWeek := nil;
      end;

      lWeek := findcomponent('Week3') as TKalenderCalendarWeek;
      if lWeek <> nil then
      begin
        lWeek.name := 'Week2';
        lWeek.tag  := 2;

        lWeek := nil;
      end;

      lWeek := findcomponent('Week2') as TKalenderCalendarWeek;
      if lWeek <> nil then
        with TKalenderCalendarWeek.create(self) do
        begin
          name := 'Week3';

          Parent      := layWeeks;
          Position.X  := lWeek.Position.x + (lWeek.Width + 1);
          Align       := talignlayout.left;
          Tag         := 3;
          onSetdate  := setDate;

          width := self.width;

          lWeek := nil;
        end;

      factivePage := 1;
      layWeeks.position.x := - self.width;

      date := IncWeek(date, 1);
    end;
  end;
end;

procedure TKalenderCalendar.SetCalenderMode(const value: TkalenderMode);
var
  ldtDate: tdate;
begin
  if value <> FMode then
  begin
    ldtDate := fdate;
    FMode := value;

    fdate := 0;
    date := ldtDate;

    setActivePage(factivePage);

    layWeeksScroll.visible := true;
    layMonthsScroll.visible := true;

    case FMode of
    TKalenderMode.Week:
      begin
        flaWeeksOpacity.inverse := false;
        flaMonthsOpacity.inverse := true;
        flaKalenderHeigth.inverse := true;
      end;
    TKalenderMode.Month, TKalenderMode.Range:
      begin
        flaWeeksOpacity.inverse := true;
        flaMonthsOpacity.inverse := false;
        flaKalenderHeigth.inverse := false;
      end;
    end;

    flaWeeksOpacity .start;
    flaMonthsOpacity.start;
    flaKalenderHeigth.start;
  end;
end;

procedure TKalenderCalendar.setDate(const value: tdate);
var
  lstrDttitle: string;
begin
  if (value <> fdate) or fupdate then
  begin
    fdate := value;
    fupdate := false;

    case FMode of
    TKalenderMode.Week:
      begin                             
        if DayOfTheWeek(fdate) = 7 then
        begin
          FWeek1.firstDate := endOfTheWeek(incWeek(fdate, -1));
          FWeek2.firstDate := endOfTheWeek(fdate);
          FWeek3.firstDate := endOfTheWeek(incWeek(fdate,  1));
        end
        else
        begin
          FWeek1.firstDate := endOfTheWeek(incWeek(fdate, -2));
          FWeek2.firstDate := endOfTheWeek(incWeek(fdate, -1));
          FWeek3.firstDate := endOfTheWeek(fdate);
        end;

        FWeek1.date := 0;

        if FWeek2.date = fdate then
          FWeek2.update
        else
          FWeek2.date := fdate;

        FWeek3.date := 0;
      end;
    TKalenderMode.Month, TKalenderMode.Range:
      begin
        FMonth1.firstDate := incmonth(fdate, -1);
        FMonth2.firstDate := fdate;
        FMonth3.firstDate := incmonth(fdate, 1);

        FMonth1.date := 0;

        if FMonth2.date = fdate then
          FMonth2.update
        else
          FMonth2.date := fdate;

        FMonth3.date := 0;
      end;
    end;

    lstrDttitle := formatdatetime('MMMM yyyy', fdate);
    labKalenderTitle.text := lstrDttitle;

    if assigned(fonSetDate) then
      case FMode of
      TKalenderMode.Week: fonSetDate(fdate, FWeek2.firstDate, FWeek2.lastDate);
      TKalenderMode.Month, TKalenderMode.Range: fonSetDate(fdate, FMonth2.firstDate, FMonth2.lastDate);
      end;
  end;
end;

procedure TKalenderCalendar.setActivePage(const value: integer);
begin
  factivePage := value;

  case FMode of
  TKalenderMode.Week:
    begin
      flaLayWeek.startvalue := layWeeks.position.x;

      case factivePage of
      0: flaLayWeek.stopvalue := 0;
      1: flaLayWeek.stopvalue := - self.width;
      2: flaLayWeek.stopvalue := - (self.width * 2);
      end;

      flaLayWeek.start;
    end;
  TKalenderMode.Month, TKalenderMode.Range:
    begin
      flaLayMonth.startvalue := layWeeks.position.x;

      case factivePage of
      0: flaLayMonth.stopvalue := 0;
      1: flaLayMonth.stopvalue := - self.width;
      2: flaLayMonth.stopvalue := - (self.width * 2);
      end;

      flaLayMonth.start;
    end;
  end;  
end;

procedure TKalenderCalendar.SetParent(const value: tfmxObject);
begin
  inherited;
  resize(true);
end;

procedure TKalenderCalendar.update;
begin
  fupdate := true;
  date := fdate;
end;

end.


