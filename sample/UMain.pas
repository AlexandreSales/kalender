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
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FbooActivate: Boolean;
    procedure showSimpleKaCender;
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

procedure TFormMain.showSimpleKaCender;
begin
  TKalender
    .New(Self, layKalenderSimpleWeek)
    .Align(TAlignLayout.Client)
    .Date(Now());

  TKalender
    .New(Self, layKalenderSimpleMonth)
    .Mode(TKalenderMode.Month)
    .Align(TAlignLayout.Client)
    .Date(Now());

  TKalender
    .New(Self, layKalenderSimpleRange)
    .Mode(TKalenderMode.Range)
    .Align(TAlignLayout.Client)
    .Date(Now());
end;

end.
