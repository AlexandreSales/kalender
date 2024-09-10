unit FM.Kalender.Calendar;

interface

uses
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
  calender.week,
  calender.month,
  calender.locker;

type
  tprocedureOnSetDate = procedure(const pcurrentDate, pfirstDate, plastDate: tdate) of object;
  tcalenderType = (tcNone, tcWeek, tcMonth);


  TCalendar = class(TFrame)
    layCalender: TLayout;
    layCalenderTitle: TLayout;
    layCalenderBack: TLayout;
    layCalenderNext: TLayout;
    labCalenderTitle: TLabel;
    layWeeksScroll: TLayout;
    layWeeks: TLayout;
    flaLayWeek: TFloatAnimation;
    imgBtnCalenderMonthBack: TPath;
    imgBtnCalenderMonthNext: TPath;
    layMonthsScroll: TLayout;
    layMonths: TLayout;
    flaLayMonth: TFloatAnimation;
    layCalenderType: TLayout;
    pthCalendarType: TPath;
    flaWeeksOpacity: TFloatAnimation;
    flaMonthsOpacity: TFloatAnimation;
    flaCalenderHeigth: TFloatAnimation;
    rctCalenderBack: TRectangle;
    efcCalenderBackShadow: TShadowEffect;

    procedure layWeeksScrollMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
    procedure layWeeksScrollMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure layWeeksScrollMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
    procedure layWeeksScrollMouseLeave(Sender: TObject);
    procedure flaLayWeekFinish(Sender: TObject);
    procedure layWeeksScrollTap(Sender: TObject; const Point: TPointF);
    procedure layCalenderBackClick(Sender: TObject);
    procedure layCalenderNextClick(Sender: TObject);
    procedure layWeeksScrollResize(Sender: TObject);
    procedure FrameResize(Sender: TObject);
    procedure flaLayMonthFinish(Sender: TObject);
    procedure flaCalenderHeigthFinish(Sender: TObject);
    procedure layCalenderTypeClick(Sender: TObject);
  private
    { Private declarations }
    factivePage: integer;
    fdownIndex: integer;
    fstartDrag: boolean;
    fupdate: boolean;
    fdonwPos: tpointf;
    fdate: tdate;
    fonSetDate: tprocedureOnSetDate;
    fcalenderType: tcalenderType;

    fcalenderWeek1: tcalenderWeek;
    fcalenderWeek2: tcalenderWeek;
    fcalenderWeek3: tcalenderWeek;

    fcalenderMonth1: tcalenderMonth;
    fcalenderMonth2: tcalenderMonth;
    fcalenderMonth3: tcalenderMonth;

    procedure setEndDrag(sender: tobject);

    procedure setEndWeek;
    procedure setEndMonth;

    procedure setActivePage(const value: integer);
    procedure setDate(const value: tdate);
    procedure setCalenderType(const value: tcalenderType);
    function getlockers: tcalenderLocker;
  protected
    { protected declarations }
    procedure SetParent(const value: tfmxObject); override;
    procedure SetAlign(const value: talignLayout); Override;

    procedure resize(const psetPosition: boolean = true);
    property activePage: integer read factivePage write setActivePage;
  public
    { public declarations }
    Constructor Create(FOwner: TComponent); Override;
    Destructor  Destroy; Override;
  published
    { published declarations }
    procedure update;

    property date: tdate read fdate write setDate;
    property onSetDate: tprocedureOnSetDate read fonSetDate write fonSetDate;
    property calenderType: tcalenderType read fcalenderType write setCalenderType;
    property lockers: tcalenderLocker read getlockers;
  end;

implementation

{$R *.fmx}

{ Tfrm_calender }

  function remainder(const pdbl_numerator, pdbl_denominator: Double): Double;
  begin
    result := trunc((pdbl_numerator / pdbl_denominator) * 100) - (trunc(pdbl_numerator / pdbl_denominator) * 100);
  end;

constructor TCalendar.create(FOwner: TComponent);
begin
  inherited;
  fcalenderType := tcNone;
  fdate := 0;

  factivePage  := 1;
  fstartDrag   := false;

  fupdate := false;

  fdonwPos     := pointf(0, 0);
  fdownIndex   := -1;

  locker := tcalenderLocker.create;

  fcalenderWeek1 := TcalenderWeek.create(nil);
  with fcalenderWeek1 do
  begin
    name := 'calenderWeek1';

    parent      := layWeeks;
    position.X  := 0;
    align       := talignlayout.left;
    tag         := 1;
    onSetdate   := setDate;
    hitTest     := false;

    width := self.width;
  end;

  fcalenderWeek2 := tcalenderWeek.create(nil);
  with fcalenderWeek2 do
  begin
    name := 'calenderWeek2';

    parent      := layWeeks;
    position.X  := fcalenderWeek1.position.x + fcalenderWeek1.size.width + 1;
    align       := talignlayout.left;
    tag         := 2;
    onSetdate   := setDate;
    hitTest     := false;

    width := self.width;
  end;

  fcalenderWeek3 := tcalenderWeek.create(nil);
  with fcalenderWeek3 do
  begin
    name := 'calenderWeek3';

    parent      := layWeeks;
    position.X  := fcalenderWeek2.position.x + fcalenderWeek2.size.width + 1;
    align       := talignlayout.left;
    tag         := 3;
    onSetdate   := setDate;
    hitTest     := false;

    width := self.width;
  end;

  fcalenderMonth1 := tcalenderMonth.create(nil);
  with fcalenderMonth1 do
  begin
    name := 'calenderMonth1';

    parent      := layMonths;
    position.X  := 0;
    align       := talignlayout.left;
    tag         := 1;
    onSetdate   := setDate;
    hitTest     := false;

    width := self.width;
  end;

  fcalenderMonth2 := tcalenderMonth.create(nil);
  with fcalenderMonth2 do
  begin
    name := 'calenderMonth2';

    parent      := layMonths;
    position.X  := fcalenderMonth1.position.x + fcalenderMonth1.size.width + 1;
    align       := talignlayout.left;
    tag         := 2;
    onSetdate   := setDate;
    hitTest     := false;

    width := self.width;
  end;

  fcalenderMonth3 := tcalenderMonth.create(nil);
  with fcalenderMonth3 do
  begin
    name := 'calenderMonth3';

    parent      := layMonths;
    position.X  := fcalenderMonth2.position.x + fcalenderMonth2.size.width + 1;
    align       := talignlayout.left;
    tag         := 3;
    onSetdate   := setDate;
    hitTest     := false;

    width := self.width;
  end;

  resize;

  fcalenderType := tcWeek;
  date := date;
end;

destructor TCalendar.Destroy;
begin

  if fcalenderWeek1 <> nil then
    freeandnil(fcalenderWeek1);

  if fcalenderWeek2 <> nil then
    freeandnil(fcalenderWeek2);

  if fcalenderWeek3 <> nil then
    freeandnil(fcalenderWeek3);

  if fcalenderMonth1 <> nil then
    freeAndNil(fcalenderMonth1);

  if fcalenderMonth2 <> nil then
    freeAndnil(fcalenderMonth2);

  if fcalenderMonth3 <> nil then
    freeAndNil(fcalenderMonth3);

  if locker <> nil then
    freeandnil(locker);

  inherited;
end;

procedure TCalendar.flaCalenderHeigthFinish(Sender: TObject);
begin
  layweeksscroll.visible := fcalenderType = tcWeek;
  layMonthsScroll.visible := fcalenderType = tcMonth;

  case fcalenderType of
  tcWeek: pthCalendarType.rotationangle := 0;
  tcMonth: pthCalendarType.rotationangle := 180;
  end;
end;

procedure TCalendar.flaLayMonthFinish(Sender: TObject);
begin
  setEndMonth;
end;

procedure TCalendar.flaLayWeekFinish(Sender: TObject);
begin
  setEndWeek;
end;

procedure TCalendar.FrameResize(Sender: TObject);
begin
  resize;
end;

function TCalendar.getlockers: tcalenderLocker;
begin
  result := locker;
end;

procedure TCalendar.layCalenderBackClick(Sender: TObject);
begin
  case calenderType of
  tcWeek: date := incWeek(date, -1);
  tcMonth: date := incMonth(date, -1);
  end;
end;

procedure TCalendar.layCalenderNextClick(Sender: TObject);
begin
  case calenderType of
  tcWeek: date := incWeek(date, 1);
  tcMonth: date := incMonth(date, 1);
  end;
end;

procedure TCalendar.layCalenderTypeClick(Sender: TObject);
begin
  case fcalenderType of
  tcWeek: calenderType := tcMonth;
  tcMonth: calenderType := tcWeek;
  end;
end;

procedure TCalendar.layWeeksScrollMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if (activePage >= 0) and (Button = TMouseButton.mbLeft) then
  begin
    fstartDrag := true;
    fdonwPos   := pointf(x, y);
    fdownIndex := activePage;
    
    {$if defined(mswindows) or defined(osx)}
      if (sender is tlayout) then
        case tcalenderType(tlayout(sender).tag) of
        tcWeek: fcalenderWeek2.getDatePosition(pointf(x, y), true);
        tcMonth: fcalenderMonth2.getDatePosition(pointf(x, y), true);
        end;
    {$endif}
  end;
end;

procedure TCalendar.layWeeksScrollMouseLeave(Sender: TObject);
begin
  inherited;
  setEndDrag(Sender);
end;

procedure TCalendar.layWeeksScrollMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Single);
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
      case tcalenderType(tlayout(sender).tag) of
      tcWeek: layWeeks.position.x := lsglNewX;
      tcMonth: layMonths.position.x := lsglNewX;
      end;
  end;
end;

procedure TCalendar.layWeeksScrollMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  inherited;   
  setEndDrag(sender);
end;

procedure TCalendar.layWeeksScrollResize(Sender: TObject);
begin
  resize;
end;

procedure TCalendar.layWeeksScrollTap(Sender: TObject; const Point: TPointF);
begin
  if (sender is tlayout) then
    case tcalenderType(tlayout(sender).tag) of
    tcWeek: fcalenderWeek2.getDatePosition(point, true);
    tcMonth:
      begin

      {$if defined(mswindows) or defined(osx)}
        fcalenderMonth2.getDatePosition(point, true);
      {$else}
        var linduc := tlayout(sender).position.y + tframe(tlayout(sender).parent.parent).position.y + tcontrol(tlayout(sender).parent.parent.parent.parent.parent.parent.parent.parent).position.y;
        fcalenderMonth2.getDatePosition(tpointf.create(point.x, point.y - linduc), true);
      {$endif}
      end;
    end;
end;


procedure TCalendar.resize(const psetPosition: boolean = true);
begin
  if fcalenderWeek1 <> nil then
    fcalenderWeek1.size.width := self.width;

  if fcalenderWeek2 <> nil then
    fcalenderWeek2.size.width := self.width;

  if fcalenderWeek3 <> nil then
    fcalenderWeek3.size.width := self.width;

  layWeeks.size.width := (self.width * 3);

  if fcalenderMonth1 <> nil then
    fcalenderMonth1.size.width := self.width;

  if fcalenderMonth2 <> nil then
    fcalenderMonth2.size.width := self.width;

  if fcalenderMonth3 <> nil then
    fcalenderMonth3.size.width := self.width;

  layWeeks.size.width := (self.width * 3);

  if psetPosition then
    layWeeks.position.x := - self.width;
end;

procedure TCalendar.SetAlign(const Value: talignLayout);
begin
  inherited;
  resize;
end;

procedure TCalendar.setEndDrag(sender: tobject);
var
  lintPage: integer;
begin
  inherited;

  if (sender is tlayout) and fstartDrag then
  begin
    fstartDrag := false;

    case tcalenderType(tlayout(sender).tag) of
    tcWeek:
      begin
        lintPage := abs(trunc(layWeeks.position.x / width));
        if (abs(remainder(layWeeks.position.x, width)) > 50) then
          lintPage := lintPage + 1;
      end;
    tcMonth:
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

procedure TCalendar.setEndMonth;
var
  lcalenderMonth : TcalenderMonth;
begin

  case  factivePage of
  0:
    begin
      lcalenderMonth := findcomponent('calenderMonth3') as TcalenderMonth;
      if lcalenderMonth <> nil then
      begin
        lcalenderMonth.DisposeOf;
        lcalenderMonth := nil;
      end;

      lcalenderMonth := findcomponent('calenderMonth2') as TcalenderMonth;
      if lcalenderMonth <> nil then
      begin
        lcalenderMonth.name := 'calenderMonth3';
        lcalenderMonth.tag  := 3;
        lcalenderMonth := nil;
      end;

      lcalenderMonth := findcomponent('calenderMonth1') as TcalenderMonth;
      if lcalenderMonth <> nil then
      begin
        lcalenderMonth.name := 'calenderMonth2';
        lcalenderMonth.tag  :=2;
        lcalenderMonth := nil;
      end;

      lcalenderMonth := findcomponent('calenderMonth2') as TcalenderMonth;
      if lcalenderMonth <> nil then
        with TcalenderMonth.create(self) do
        begin
          name := 'calenderMonth1';

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
      lcalenderMonth := findcomponent('calenderMonth1') as TcalenderMonth;
      if lcalenderMonth <> nil then
      begin
        lcalenderMonth.disposeof;
        lcalenderMonth := nil;
      end;

      lcalenderMonth := findcomponent('calenderMonth2') as TcalenderMonth;
      if lcalenderMonth <> nil then
      begin
        lcalenderMonth.name := 'calenderMonth1';
        lcalenderMonth.tag  := 1;
        lcalenderMonth := nil;
      end;

      lcalenderMonth := findcomponent('calenderMonth3') as TcalenderMonth;
      if lcalenderMonth <> nil then
      begin
        lcalenderMonth.name := 'calenderMonth2';
        lcalenderMonth.tag  := 2;

        lcalenderMonth := nil;
      end;

      lcalenderMonth := findcomponent('calenderMonth2') as TcalenderMonth;
      if lcalenderMonth <> nil then
        with TcalenderMonth.create(self) do
        begin
          name := 'calenderMonth3';

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

procedure TCalendar.setEndWeek;
var
  lcalenderWeek : tcalenderWeek;
begin

  case  factivePage of
  0:
    begin
      lcalenderWeek := findcomponent('calenderWeek3') as tcalenderWeek;
      if lcalenderWeek <> nil then
      begin
        lcalenderWeek.DisposeOf;
        lcalenderWeek := nil;
      end;

      lcalenderWeek := findcomponent('calenderWeek2') as tcalenderWeek;
      if lcalenderWeek <> nil then
      begin
        lcalenderWeek.name := 'calenderWeek3';
        lcalenderWeek.tag  := 3;
        lcalenderWeek := nil;
      end;

      lcalenderWeek := findcomponent('calenderWeek1') as tcalenderWeek;
      if lcalenderWeek <> nil then
      begin
        lcalenderWeek.name := 'calenderWeek2';
        lcalenderWeek.tag  := 2;
        lcalenderWeek := nil;
      end;

      lcalenderWeek := findcomponent('calenderWeek2') as tcalenderWeek;
      if lcalenderWeek <> nil then
        with tcalenderWeek.create(self) do
        begin
          name := 'calenderWeek1';

          Parent      := layWeeks;
          Position.X  := lcalenderWeek.Position.x - (lcalenderWeek.Width + 1);
          Align       := talignlayout.left;
          tag         := 1;
          onSetdate  := setDate;

          lcalenderWeek := nil;

          width := self.width;
        end;

      factivePage := 1;
      layWeeks.position.x := - self.width;

      date := IncWeek(date, -1);
    end;
  2:
    begin
      lcalenderWeek := findcomponent('calenderWeek1') as tcalenderWeek;
      if lcalenderWeek <> nil then
      begin
        lcalenderWeek.DisposeOf;
        lcalenderWeek := nil;
      end;

      lcalenderWeek := findcomponent('calenderWeek2') as tcalenderWeek;
      if lcalenderWeek <> nil then
      begin
        lcalenderWeek.name := 'calenderWeek1';
        lcalenderWeek.tag  := 1;
        lcalenderWeek := nil;
      end;

      lcalenderWeek := findcomponent('calenderWeek3') as tcalenderWeek;
      if lcalenderWeek <> nil then
      begin
        lcalenderWeek.name := 'calenderWeek2';
        lcalenderWeek.tag  := 2;

        lcalenderWeek := nil;
      end;

      lcalenderWeek := findcomponent('calenderWeek2') as tcalenderWeek;
      if lcalenderWeek <> nil then
        with tcalenderWeek.create(self) do
        begin
          name := 'calenderWeek3';

          Parent      := layWeeks;
          Position.X  := lcalenderWeek.Position.x + (lcalenderWeek.Width + 1);
          Align       := talignlayout.left;
          Tag         := 3;
          onSetdate  := setDate;

          width := self.width;

          lcalenderWeek := nil;
        end;

      factivePage := 1;
      layWeeks.position.x := - self.width;

      date := IncWeek(date, 1);
    end;
  end;
end;

procedure TCalendar.setCalenderType(const value: tcalenderType);
var
  ldtDate: tdate;
begin
  if value <> fcalenderType then
  begin
    ldtDate := fdate;
    fcalenderType := value;

    fdate := 0;
    date := ldtDate;

    setActivePage(factivePage);

    layWeeksScroll.visible := true;
    layMonthsScroll.visible := true;

    case fcalenderType of
    tcWeek:
      begin
        flaWeeksOpacity.inverse := false;
        flaMonthsOpacity.inverse := true;
        flaCalenderHeigth.inverse := true;
      end;
    tcMonth:
      begin
        flaWeeksOpacity.inverse := true;
        flaMonthsOpacity.inverse := false;
        flaCalenderHeigth.inverse := false;
      end;
    end;

    flaWeeksOpacity .start;
    flaMonthsOpacity.start;
    flaCalenderHeigth.start;
  end;
end;

procedure TCalendar.setDate(const value: tdate);
var
  lstrDttitle: string;
begin
  if (value <> fdate) or fupdate then
  begin
    fdate := value;
    fupdate := false;

    case fcalenderType of
    tcWeek:
      begin                             
        if DayOfTheWeek(fdate) = 7 then
        begin
          fcalenderWeek1.firstDate := endOfTheWeek(incWeek(fdate, -1));
          fcalenderWeek2.firstDate := endOfTheWeek(fdate);
          fcalenderWeek3.firstDate := endOfTheWeek(incWeek(fdate,  1));
        end
        else
        begin
          fcalenderWeek1.firstDate := endOfTheWeek(incWeek(fdate, -2));
          fcalenderWeek2.firstDate := endOfTheWeek(incWeek(fdate, -1));
          fcalenderWeek3.firstDate := endOfTheWeek(fdate);
        end;

        fcalenderWeek1.date := 0;

        if fcalenderWeek2.date = fdate then
          fcalenderWeek2.update
        else
          fcalenderWeek2.date := fdate;

        fcalenderWeek3.date := 0;
      end;
    tcMonth:
      begin
        fcalenderMonth1.firstDate := incmonth(fdate, -1);
        fcalenderMonth2.firstDate := fdate;
        fcalenderMonth3.firstDate := incmonth(fdate, 1);

        fcalenderMonth1.date := 0;

        if fcalenderMonth2.date = fdate then
          fcalenderMonth2.update
        else
          fcalenderMonth2.date := fdate;

        fcalenderMonth3.date := 0;
      end;
    end;

    lstrDttitle := formatdatetime('MMMM yyyy', fdate);
    labCalenderTitle.text := lstrDttitle;

    if assigned(fonSetDate) then
      case fcalenderType of
      tcWeek: fonSetDate(fdate, fcalenderWeek2.firstDate, fcalenderWeek2.lastDate);
      tcMonth: fonSetDate(fdate, fcalenderMonth2.firstDate, fcalenderMonth2.lastDate);
      end;
  end;
end;

procedure TCalendar.setActivePage(const value: integer);
begin
  factivePage := value;

  case fcalenderType of
  tcWeek:
    begin
      flaLayWeek.startvalue := layWeeks.position.x;

      case factivePage of
      0: flaLayWeek.stopvalue := 0;
      1: flaLayWeek.stopvalue := - self.width;
      2: flaLayWeek.stopvalue := - (self.width * 2);
      end;

      flaLayWeek.start;
    end;
  tcMonth:
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

procedure TCalendar.SetParent(const value: tfmxObject);
begin
  inherited;
  resize(true);
end;

procedure TCalendar.update;
begin
  fupdate := true;
  date := fdate;
end;

end.


