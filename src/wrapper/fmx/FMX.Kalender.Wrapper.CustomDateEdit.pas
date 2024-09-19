unit FMX.Kalender.Wrapper.CustomDateEdit;

interface

uses
  System.SysUtils,
  System.Classes,
  System.UITypes,
  FMX.Controls,
  FMX.Edit,
  FMX.DateTimeCtrls;

type

  TOnOpenPickerClick = procedure(Sender: TObject) of Object;

  TCustomDateEdit = class(TDateEdit)
  private
    { private declarations }
    FOnOpenPickerClick: TOnOpenPickerClick;
  protected
    { protected declarations }
    procedure OpenPicker; override;
  public
    { public declarations }
    constructor Create(AOwner: TComponent); override;
    property Font;
    property TextAlign;
  published
    { published declarations }
    property OnOpenPickerClick: TOnOpenPickerClick read FOnOpenPickerClick write FOnOpenPickerClick;

    property ShowClearButton;
    property ShowCheckBox;
    property IsChecked;
    property Date;
    property WeekNumbers;
    property Format;
    property TodayDefault;
    property DateFormatKind;
    property IsEmpty;
    property OnChange;
    property OnCheckChanged;
    property OnClosePicker;
    property OnOpenPicker;
    { inherited }
    property Align;
    property Anchors;
    property CanFocus default True;
    property CanParentFocus;
    property Cursor default crIBeam;
    property ClipChildren default False;
    property ClipParent default False;
    property DisableFocusEffect;
    property DragMode default TDragMode.dmManual;
    property EnableDragHighlight default True;
    property Enabled default True;
    property FirstDayOfWeek;
    property Height;
    property HelpContext;
    property HelpKeyword;
    property HelpType;
    property Hint;
    property HitTest default True;
    property Locked default False;
    property KeyboardType;
    property Padding;
    property Opacity;
    property Margins;
    property PopupMenu;
    property Position;
    property RotationAngle;
    property RotationCenter;
    property ReadOnly;
    property Scale;
    property Size;
    property StyleLookup;
    property StyledSettings;
    property TabOrder;
    property TabStop;
    property TextSettings;
    property TouchTargetExpansion;
    property Visible default True;
    property Width;
    property ParentShowHint;
    property ShowHint;
    property OnApplyStyleLookup;
    property OnFreeStyle;
    property OnDragEnter;
    property OnDragLeave;
    property OnDragOver;
    property OnDragDrop;
    property OnDragEnd;
    property OnKeyDown;
    property OnKeyUp;
    property OnCanFocus;
    property OnEnter;
    property OnExit;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnMouseWheel;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnPainting;
    property OnPaint;
    property OnResize;
    property OnResized;
  end;

procedure Register;

implementation

{ TCustomDateEdit }

constructor TCustomDateEdit.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

procedure TCustomDateEdit.OpenPicker;
begin
  if Assigned(FOnOpenPickerClick) then
    FOnOpenPickerClick(Self)
  else
    inherited OpenPicker;
end;

procedure Register;
begin
  RegisterComponents('CustomComponents', [TCustomDateEdit]);
end;

end.
