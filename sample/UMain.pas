unit UMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Layouts,
  FMX.Objects,
  FMX.Controls.Presentation,
  FMX.StdCtrls,
  System.Kalender.Api,
  FMX.Kalender;

type
  TFormMain = class(TForm)
    layKalenderSimpleMonth: TLayout;
    layKalenderSimpleWeek: TLayout;
    layKalenderSimpleRange: TLayout;
    layWeekChangeResult: TLayout;
    labWeekChangeResult: TLabel;
    layMonthChangeResult: TLayout;
    labMonthChangeResult: TLabel;
    layRangeStartChangeResult: TLayout;
    labRangeStartChangeResult: TLabel;
    layRangeEndChangeResult: TLayout;
    labRangeEndChangeResult: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Layout1: TLayout;
    Label4: TLabel;
    Rectangle1: TRectangle;
    Rectangle2: TRectangle;
    Rectangle3: TRectangle;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FbooActivate: Boolean;
    procedure showSimpleKaCender;

    procedure onChangeDateWeek(const AValue: TDate);
    procedure onChangeDateMonth(const AValue: TDate);
    procedure onChangeDateRange(const AStartDate, AEndDate: TDate);
    procedure onDblClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.fmx}

{ TFormMain }

procedure TFormMain.FormActivate(Sender: TObject);
begin
  if not(FbooActivate) then
    exit;
  FbooActivate := false;

  showSimpleKaCender;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FbooActivate := true;
end;

procedure TFormMain.onChangeDateMonth(const AValue: TDate);
begin
  labMonthChangeResult.text := FormatDateTime('dd/MM/yyyy', AValue);
end;

procedure TFormMain.onChangeDateRange(const AStartDate, AEndDate: TDate);
begin
  labRangeStartChangeResult.Text := FormatDateTime('dd/MM/yyyy', AStartDate);
  labRangeEndChangeResult.Text := FormatDateTime('dd/MM/yyyy', AEndDate);
end;

procedure TFormMain.onChangeDateWeek(const AValue: TDate);
begin
  labWeekChangeResult.text := FormatDateTime('dd/MM/yyyy', AValue);
end;

procedure TFormMain.onDblClick(Sender: TObject);
begin
  showMessage(TFmxObject(Sender).Name);
end;

procedure TFormMain.showSimpleKaCender;
begin
  TKalender
    .New(Self, layKalenderSimpleWeek)
    .Align(TAlignLayout.Client)
    .Mode(TKalenderMode.Week)
    .OnChangeDate(onChangeDateWeek)
    .OnCalendarDblClick(onDblClick)
    .Date(Now());

  TKalender
    .New(Self, layKalenderSimpleMonth)
    .Mode(TKalenderMode.Month)
    .Align(TAlignLayout.Client)
    .OnChangeDate(onChangeDateMonth)
    .OnCalendarDblClick(onDblClick)
    .Date(Now());

  TKalender
    .New(Self, layKalenderSimpleRange)
    .Mode(TKalenderMode.Range)
    .Align(TAlignLayout.Client)
    .OnChangeDate(onChangeDateRange)
    .Date(Now());
end;

end.
