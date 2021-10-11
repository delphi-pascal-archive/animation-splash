{*******************************************************************************

  Animation Splash Form (ASF)

  Автор:     Andy BitOff, bitoff@pisem.net, ICQ:95044580, Санкт-Петербург, Россия
  Copyright: Andy BitOff
  Дата:      19.02.2009
  Версия:    1.1.0

  Зависимость: GDI+ (GDIPAPI, GDIPOBJ, GDIPUTIL)

*******************************************************************************}

{===============================================================================
  ASFMain unit

  TAnimationSplashForm
    Создает анимированное окно в дополнительном потоке
    со своей очередью сообщений.
    Позволяет сделать информативное сплэш окно любой сложности.

================================================================================

  История изменений
  ------------------------------------------------------------------------------
  1.1.1
    * Исправлены недочеты в коде
  1.1.0
    * Устранена утечка памяти (defecator меня все-таки доканал)
    * Мелкие исправления
  1.0.0
    * Решен глюк с отображением эффекта фэйда для иконок
    * Работают все эффекты для иконок
  0.94.0
    + Добавлен эффект анимации, но пока не используется
    * Изменен приоритет потока (забыл исправить перед релизом.
	    Спасибо Сергей М., что напомнил ;))
    * Исправлена ошибка Access violation появлявшаяся в редких случаях при запуске Demo
    * Мелкие исправления
  0.93.0
    Тестовая версия
  ------------------------------------------------------------------------------

===============================================================================}


unit ASFMain;

interface

uses
  Windows, Messages, Classes, Graphics, SysUtils, Contnrs, Forms,
  GDIPAPI, GDIPOBJ, GDIPUTIL, ASFLists;

resourcestring
  eFileNotFound = 'File %s not found';
  eIndexOutOfBounds = 'Index out of bounds (%d)';

  
type
  TIconInfo = record
    IconIndex: Integer;
    IconPos: Integer;
    IconWidth: Integer;
    IconHeight: Integer;
  end;

  PProgressBarInfo = ^TProgressBarInfo;
  TProgressBarInfo = record
    BarVisible: Boolean;
    BarBorderVisible: Boolean;
    BarBox: TGPRect;
    BarColor: Cardinal;
    BarBorderColor: Cardinal;
  end;

  TIconAnimation = (iaNone, iaFade, iaFadeColor, iaSlideTop, iaSlideLeft, iaSlideCorner);

  TAnimationSplashForm = class(TThread)
  private
    FAnimations: TObjectList;
    FBackGroundFileName: string;
    FBGHeight: Integer;
    FBGResolutionX: Integer;
    FBGResolutionY: Integer;
    FBGWidth: Integer;
    FBMPBackground: TGPBitmap;
    FClose: Boolean;
    FCritSec: TRTLCriticalSection;
    FCurrentIconPosition: Integer;
    FDC: HDC;
    FFadeSpeed: Integer;
    FDestroy: Boolean;
    FFTimerInterval: Integer;
    FIconAnimation: TIconAnimation;
    FIconFullPaintPercent: Integer;
    FIconPosArray: array of TIconInfo;
    FIconPosLeft: Integer;
    FIconPosTop: Integer;
    FIcons: TImagesList;
    FIconSpace: Integer;
    FIconStep: Integer;
    FLoadingPartTime: Integer;
    FOnePartProgressSize: Integer;
    FProgressBar: PProgressBarInfo;
    FProgressBarCurrentPart: Integer;
    FProgressBarPatrs: Integer;
    FProgressIconCurrentItem: Integer;
    FProgressIconsVisible: Boolean;
    FrameNumber: integer;
    FShowTaskbarButton: Boolean;
    FSplashFormCaption: string;
    FSplashFormTopMost: Boolean;
    FStartCurrentPart: Integer;
    FTestSpeed: Boolean;
    FTextData: TTextItemList;
    FTickCountAll: Integer;
    FTickCountOld: Integer;
    FTickZero: Cardinal;
    FTransparent: integer;
    FTransparentOld: integer;
    FWaitClose: Integer;
    function CreateMyWnd(): hWnd;
    procedure InitData;
    procedure TimerProc();
    procedure RenderForm(TransparentValue: byte; SourceImage: TGPBitmap);
    procedure TextOut(TextInfo: TTextItem; TextColor: Cardinal; GPGraphics:
        TGPGraphics; GPRect: TGPRectF);
    procedure SetProgressBarPatrs(const Value: Integer);
    procedure SetProgressBarCurrentPart(const Value: Integer);
    procedure SetLoadingPartTime(const Value: Integer);
    function GetMyTickCount: Integer;
    procedure PaintIcons(GPGraphics: TGPGraphics);
    procedure SetProgressIconCurrentItem(const Value: Integer);
    procedure SetProgressIconsVisible(const Value: Boolean);
    procedure SetIconFullPaintPercent(Value: Integer);
    procedure SetIconAnimation(const Value: TIconAnimation);
    procedure DrawSplash;
    procedure PaintProgressBar(GPGraphics: TGPGraphics);
    function GetAnimationRect(ItemIndex: Integer; GPImageAttributes:
        TGPImageAttributes): TGPRectF;
    function CalcCurrentIconPos(IconItem: Integer): Integer;
    function GetAnimations(Index: Integer): TAnimationFrames;
    procedure SetAnimations(Index: Integer; const Value: TAnimationFrames);
    function AnimationValidIndex(Index: integer): Boolean;
    procedure PaintAnimations(GPGraphics: TGPGraphics);
    procedure SetFadeSpeed(Value: Integer);
    property FTimerInterval: Integer read FFTimerInterval write FFTimerInterval;
    procedure PaintText(GPGraphics: TGPGraphics);
    procedure SetIconPosLeft(const Value: Integer);
    procedure SetIconPosTop(const Value: Integer);
    procedure SetIconSpace(const Value: Integer);
    procedure SetIconStep(const Value: Integer);
    function SetLengthIconArray: Boolean;
  protected
    procedure Execute; override;
  published

  public
    constructor Create(BackGroundFileName: string);
    constructor CreateEmptyBackGround(Width, Height, ResolutionX, ResolutionY: Integer);
    destructor Destroy; override;
    procedure StartSplash;
    procedure CloseSplash(CloseDelay: Integer; Destroy: Boolean = True);
    procedure SetTimerInterval(Interval: Integer);
    function TestSpeedDrawSplash: Integer;
    procedure IncCurrentPart;
    procedure IncCurrentItemIcon;
    function AnimationsAdd(Value: TAnimationFrames): Integer;
    function AnimationsCount: Integer;
    property Animations[Index: Integer]: TAnimationFrames read GetAnimations write SetAnimations;
    property FadeSpeed: Integer read FFadeSpeed write SetFadeSpeed;
    property IconAnimation: TIconAnimation read FIconAnimation write SetIconAnimation;
    property IconFullPaintPercent: Integer read FIconFullPaintPercent write SetIconFullPaintPercent;
    property IconPosLeft: Integer read FIconPosLeft write SetIconPosLeft;
    property IconPosTop: Integer read FIconPosTop write SetIconPosTop;
    property Icons: TImagesList read FIcons write FIcons;
    property IconSpace: Integer read FIconSpace write SetIconSpace;
    property IconStep: Integer read FIconStep write SetIconStep;
    property LoadingPartTime: Integer read FLoadingPartTime write SetLoadingPartTime;
    property ProgressBar: PProgressBarInfo read FProgressBar write FProgressBar;
    property ProgressBarCurrentPart: Integer read FProgressBarCurrentPart write SetProgressBarCurrentPart;
    property ProgressBarPatrs: Integer read FProgressBarPatrs write SetProgressBarPatrs;
    property ProgressIconCurrentItem: Integer read FProgressIconCurrentItem write SetProgressIconCurrentItem;
    property ProgressIconsVisible: Boolean read FProgressIconsVisible write SetProgressIconsVisible;
    property ShowTaskbarButton: Boolean read FShowTaskbarButton write FShowTaskbarButton;
    property SplashFormCaption: string read FSplashFormCaption write FSplashFormCaption;
    property SplashFormTopMost: Boolean read FSplashFormTopMost write FSplashFormTopMost;
    property TextData: TTextItemList read FTextData write FTextData;
  end;

function WndProc(Wnd: HWND; message: UINT; wParam: Integer; lParam: Integer) : Integer; stdcall;

var
  AnimationSplashForm: TAnimationSplashForm;

implementation

const
  RsSystemIdleProcess = 'System Idle Process';
  RsSystemProcess = 'System Process';
  InitProcessClassName = 'SplashWindow';
  NotBGImage = '*NotFile*';

var
  AppHandle: HWND;
  Msg: TMsg;
  FadeColorMatrix: TColorMatrix =  // Для фэйда иконок
     ((1.0, 0.0, 0.0, 0.0, 0.0),
      (0.0, 1.0, 0.0, 0.0, 0.0),
      (0.0, 0.0, 1.0, 0.0, 0.0),
      (0.0, 0.0, 0.0, 1.0, 0.0),
      (0.0, 0.0, 0.0, 0.0, 1.0));
  FadeColorColorMatrix: TColorMatrix =  // Для фэйда цвета иконок
     ((0.299, 0.299, 0.299, 0.0, 0.0),
      (0.587, 0.587, 0.587, 0.0, 0.0),
      (0.114, 0.114, 0.114, 0.0, 0.0),
      (0.0, 0.0, 0.0, 1.0, 0.0),
      (0.0, 0.0, 0.0, 0.0, 1.0));




function WndProc(Wnd: HWND; message: UINT; wParam: Integer; lParam: Integer) : Integer; stdcall;
begin
  case message of
    WM_TIMER: begin
        AnimationSplashForm.TimerProc();
        result := 0;
      end;
    WM_DESTROY: begin
        PostQuitMessage(0);
        result := 0;
      end;
   else
     result := DefWindowProc(Wnd, message, wParam, lParam);
   end;
end;



constructor TAnimationSplashForm.Create(BackGroundFileName: string);
begin
  FBackGroundFileName := BackGroundFileName;
  FBGWidth := 0;
  FBGHeight := 0;
  InitData();
  inherited Create(True);
end;

constructor TAnimationSplashForm.CreateEmptyBackGround(Width, Height,
    ResolutionX, ResolutionY: Integer);
begin
  FBackGroundFileName := NotBGImage;
  FBGWidth := Width;
  FBGHeight := Height;
  FBGResolutionX := ResolutionX;
  FBGResolutionY := ResolutionY;
  InitData();
  inherited Create(True);
end;

destructor TAnimationSplashForm.Destroy;
var
  I: Integer;
begin
  KillTimer(AppHandle, 0);
  FBMPBackground.Free;
  for I := 0 to FAnimations.Count - 1 do
    FAnimations.Items[i].Free;
  if (Icons <> nil) and (Icons.Count <> 0) then begin
    for i := 0 to Icons.Count - 1 do
      Icons.Items[i].Free;
    SetLength(FIconPosArray, 0);
  end;
  TextData.Free;
  Dispose(FProgressBar);
  DeleteCriticalSection(FCritSec);
  SetForegroundWindow(Application.Handle);
  inherited;
end;

procedure TAnimationSplashForm.Execute;
begin
  SetLengthIconArray();
  FreeOnTerminate := True;
  AppHandle := CreateMyWnd;
  if AppHandle = 0 then
    Exit;
  SetThreadPriority(GetCurrentThread, THREAD_PRIORITY_NORMAL);
  SetTimer(AppHandle, 0, FTimerInterval, nil);
  while GetMessage(Msg, 0, 0, 0) do begin
    TranslateMessage(Msg);
    DispatchMessage(Msg);
  end;
end;

function TAnimationSplashForm.CreateMyWnd(): hWnd;
var
  wc: WndClass;
  f: Integer;
begin
  wc.style := CS_HREDRAW or CS_VREDRAW;
  wc.lpfnWndProc := @WndProc;
  wc.cbClsExtra := 0;
  wc.cbWndExtra := 0;
  wc.hInstance := hInstance;
  wc.hIcon := 0;
  wc.hCursor := 0;
  wc.hbrBackground := COLOR_INACTIVECAPTION;
  wc.lpszMenuName := nil;
  wc.lpszClassName := InitProcessClassName;
  result := 0;
  if Windows.RegisterClass(wc) = 0 then
    Exit;
  f := WS_EX_APPWINDOW;
  if not ShowTaskbarButton then
    f := WS_EX_TOOLWINDOW;
  if SplashFormTopMost then
    f := f or WS_EX_TOPMOST;
  result := CreateWindowEx(f, InitProcessClassName,
      PChar(SplashFormCaption), WS_POPUP,
      GetSystemMetrics(SM_CXFULLSCREEN) div 2 - Integer(FBMPBackground.GetWidth) div 2,
      GetSystemMetrics(SM_CYFULLSCREEN) div 2 - Integer(FBMPBackground.GetHeight) div 2,
      FBMPBackground.GetWidth,
      FBMPBackground.GetHeight,
      0, 0, hInstance, nil);
end;

procedure TAnimationSplashForm.InitData;
begin
  InitializeCriticalSection(FCritSec);
  if FBackGroundFileName <> NotBGImage then begin
    if not FileExists(FBackGroundFileName) then
      raise Exception.Create(Format(eFileNotFound , [FBackGroundFileName]));
    FBMPBackground := TGPBitmap.Create(FBackGroundFileName);
  end
  else begin
    FBMPBackground := TGPBitmap.Create(FBGWidth, FBGHeight);
    FBMPBackground.SetResolution(FBGResolutionX, FBGResolutionY);
  end;
  FAnimations := TObjectList.Create(True);
  FClose := False;
  New(FProgressBar);
  with ProgressBar^ do begin
    BarVisible := False;
    BarBorderVisible := True;
    BarBox := MakeRect(0, 0, 100, 20);
    BarColor := $FFFFFFFF;
    BarBorderColor := $FFFFFFFF;
  end;
  TextData := TTextItemList.Create;
  FCurrentIconPosition := 0;
  FFadeSpeed := 7;
  FProgressIconCurrentItem := 0;
  FrameNumber := 0;
  FStartCurrentPart := 0;
  FTickCountAll := 0;
  FTickCountOld := 0;
  FTickZero := 0;
  FTransparent := 0;
  FTransparentOld := 255;
  IconFullPaintPercent := 100;
  LoadingPartTime := 0;
  ProgressIconsVisible := True;
  ProgressBarPatrs := 1;
end;

procedure TAnimationSplashForm.CloseSplash(CloseDelay: Integer; Destroy: Boolean = True);
begin
  FWaitClose := CloseDelay;
  FClose := True;
  FDestroy := Destroy;
end;

procedure TAnimationSplashForm.StartSplash;
begin
  FClose := False;
  Resume;
end;

procedure TAnimationSplashForm.SetTimerInterval(Interval: Integer);
begin
  FTimerInterval := Interval;
end;

procedure TAnimationSplashForm.SetFadeSpeed(Value: Integer);
begin
  EnterCriticalSection(FCritSec);
  try
    if Value < 1 then
      Value := 1
    else
      if Value > 255 then
        Value := 255;
    FFadeSpeed := Value;
  finally
    LeaveCriticalSection(FCritSec);
  end;
end;

procedure TAnimationSplashForm.SetProgressBarPatrs(const Value: Integer);
begin
  EnterCriticalSection(FCritSec);
  try
    if Value > 0 then
      FProgressBarPatrs := Value
    else
      FProgressBarPatrs := 1;
    FProgressBarCurrentPart := 1;
    FOnePartProgressSize := FProgressBar.BarBox.Width div FProgressBarPatrs;
  finally
    LeaveCriticalSection(FCritSec);
  end;
end;

procedure TAnimationSplashForm.SetProgressBarCurrentPart(const Value: Integer);
begin
  EnterCriticalSection(FCritSec);
  try
    if FProgressBarCurrentPart <= FProgressBarPatrs then
      FProgressBarCurrentPart := Value
    else
      FProgressBarCurrentPart := FProgressBarPatrs;
    FStartCurrentPart := FOnePartProgressSize * (FProgressBarCurrentPart - 1);
    FTickCountAll := 0;
  finally
    LeaveCriticalSection(FCritSec);
  end;
end;

procedure TAnimationSplashForm.IncCurrentPart;
begin
  EnterCriticalSection(FCritSec);
  try
    if FProgressBarCurrentPart < FProgressBarPatrs then
      ProgressBarCurrentPart := ProgressBarCurrentPart + 1
    else
      ProgressBarCurrentPart := FProgressBarPatrs;
  finally
    LeaveCriticalSection(FCritSec);
  end;
end;

procedure TAnimationSplashForm.SetLoadingPartTime(const Value: Integer);
begin
  EnterCriticalSection(FCritSec);
  try
    if Value > 0 then
      FLoadingPartTime := Value
    else
      FLoadingPartTime := 1;
  finally
    LeaveCriticalSection(FCritSec);
  end;
end;

procedure TAnimationSplashForm.SetProgressIconsVisible(const Value: Boolean);
begin
  FProgressIconsVisible := Value;
end;

procedure TAnimationSplashForm.SetIconPosLeft(const Value: Integer);
begin
  EnterCriticalSection(FCritSec);
  try
    FIconPosLeft := Value;
  finally
    LeaveCriticalSection(FCritSec);
  end;          
end;

procedure TAnimationSplashForm.SetIconPosTop(const Value: Integer);
begin
  EnterCriticalSection(FCritSec);
  try
    FIconPosTop := Value;
  finally
    LeaveCriticalSection(FCritSec);
  end;          
end;

procedure TAnimationSplashForm.SetIconSpace(const Value: Integer);
begin
  EnterCriticalSection(FCritSec);
  try
    FIconSpace := Value;
  finally
    LeaveCriticalSection(FCritSec);
  end;          
end;

procedure TAnimationSplashForm.SetIconStep(const Value: Integer);
begin
  EnterCriticalSection(FCritSec);
  try
    FIconStep := Value;
  finally
    LeaveCriticalSection(FCritSec);
  end;          
end;

function TAnimationSplashForm.CalcCurrentIconPos(IconItem: Integer): Integer;
var
  I: Integer;
  a: Integer;
begin
  Result := IconPosLeft;
  for I := 0 to Length(FIconPosArray) - 1 do begin
    if FIconPosArray[i].IconIndex = -1 then
      Continue;
    a := IconStep;
    if i = 0 then
      a := 0
    else
      if a = 0 then
        a := FIconPosArray[i - 1].IconWidth;

    Result := Result + a;
    if i <> 0 then
      Result := Result + IconSpace;
  end;
end;

procedure TAnimationSplashForm.SetProgressIconCurrentItem(const Value: Integer);
var
  nf: Integer;

  function NextFree: Integer;
  var
    I: Integer;
  begin
    Result := Length(FIconPosArray) - 1;
    for I := 0 to Result do begin
      if FIconPosArray[i].IconIndex = -1 then begin
        Result := I;
        Break;
      end;
    end;
  end;

begin
  EnterCriticalSection(FCritSec);
  try
    if Icons <> nil then begin
      if FProgressIconCurrentItem <= Icons.Count - 1 then
        FProgressIconCurrentItem := Value
      else
        FProgressIconCurrentItem := Icons.Count - 1;
      nf := NextFree;
      if SetLengthIconArray() then begin
        FIconPosArray[nf].IconIndex := ProgressIconCurrentItem;
        FIconPosArray[nf].IconPos := CalcCurrentIconPos(ProgressIconCurrentItem);
        FIconPosArray[nf].IconWidth :=
            Icons.Items[FProgressIconCurrentItem].GetWidth;
        FIconPosArray[nf].IconHeight :=
            Icons.Items[FProgressIconCurrentItem].GetHeight;
      end;            
    end;
  finally
    LeaveCriticalSection(FCritSec);
  end;
end;

function TAnimationSplashForm.SetLengthIconArray: Boolean;
var
  i: Integer;
begin
  Result := False;
  if (Icons <> nil) and (Icons.Count <> 0) and (Length(FIconPosArray) <> Icons.Count) then begin
    SetLength(FIconPosArray, Icons.Count);
    for I := 0 to Length(FIconPosArray) - 1 do begin
      FIconPosArray[i].IconIndex := -1;
      FIconPosArray[i].IconPos := 0;
      FIconPosArray[i].IconWidth := 0;
      FIconPosArray[i].IconHeight := 0;
    end;
  end;
  if Length(FIconPosArray) <> 0 then
    Result := True;
end;

procedure TAnimationSplashForm.IncCurrentItemIcon;
begin
  EnterCriticalSection(FCritSec);
  try
    if FProgressIconCurrentItem < Icons.Count - 1 then
      ProgressIconCurrentItem := ProgressIconCurrentItem + 1
    else
      ProgressIconCurrentItem := Icons.Count - 1;
  finally
    LeaveCriticalSection(FCritSec);
  end;
end;

procedure TAnimationSplashForm.SetIconFullPaintPercent(Value: Integer);
begin
  EnterCriticalSection(FCritSec);
  try
    if Value > 100 then
      Value := 100;
    if Value < 0 then
      Value := 0;
    FIconFullPaintPercent := Value;
  finally
    LeaveCriticalSection(FCritSec);
  end;
end;

procedure TAnimationSplashForm.SetIconAnimation(const Value: TIconAnimation);
begin
  EnterCriticalSection(FCritSec);
  try
    FIconAnimation := Value;
  finally
    LeaveCriticalSection(FCritSec);
  end;
end;

function TAnimationSplashForm.GetMyTickCount: Integer;
begin
  Result := GetTickCount() - FTickZero;
end;

function TAnimationSplashForm.TestSpeedDrawSplash: Integer;
var
  TickCount: Integer;
begin
  TickCount := GetTickCount();
  FTestSpeed := True;
  DrawSplash();
  FTestSpeed := False;
  Result := GetMyTickCount() - TickCount;
end;

function TAnimationSplashForm.GetAnimations(Index: Integer): TAnimationFrames;
begin
  EnterCriticalSection(FCritSec);
  Result := nil;
  try
    if AnimationValidIndex(Index) then begin
      Result := TAnimationFrames(FAnimations.Items[index]);
    end
    else
      raise Exception.Create(Format(eIndexOutOfBounds, [Index]));
  finally
    LeaveCriticalSection(FCritSec);
  end;            
end;

procedure TAnimationSplashForm.SetAnimations(Index: Integer; const Value: TAnimationFrames);
begin
  EnterCriticalSection(FCritSec);
  try
    if (AnimationValidIndex(Index)) and (Value <> nil) then begin
      FAnimations.Items[index].Free;
      FAnimations.Items[index] := Value;
    end
    else
      raise Exception.Create(Format(eIndexOutOfBounds, [Index]));
  finally
    LeaveCriticalSection(FCritSec);
  end;
end;

function TAnimationSplashForm.AnimationsCount: Integer;
begin
  EnterCriticalSection(FCritSec);
  try
    Result := FAnimations.Count;
  finally
    LeaveCriticalSection(FCritSec);
  end;
end;

function TAnimationSplashForm.AnimationsAdd(Value: TAnimationFrames): Integer;
begin
  EnterCriticalSection(FCritSec);
  try
    Result := -1;
    if Value <> nil then begin
      Result := FAnimations.Add(Value);
    end;
  finally
    LeaveCriticalSection(FCritSec);
  end;
end;

function TAnimationSplashForm.AnimationValidIndex(Index: integer): Boolean;
begin
  Result := (Index >= 0) and (Index < AnimationsCount);
end;

procedure TAnimationSplashForm.TimerProc();
var
  TickCount: Integer;
begin
  if FTickZero = 0 then
    FTickZero := GetTickCount();
  TickCount := GetMyTickCount() - FTickCountOld;
  FTickCountOld := GetMyTickCount();
  if FClose then begin
    if FTransparent > 0 then begin
      if FWaitClose > 0 then begin
        Dec(FWaitClose);
      end
      else begin
        FTransparent := FTransparent - FFadeSpeed;
        if FTransparent < 0 then begin
          FTransparent := 0;
          if FDestroy then
{            DestroyWindow(AppHandle);}
          // при дестрое (DestroyWindow) происходит моргание во время
          // уничтожения сплэша и активации основной формы
            PostMessage(AppHandle, WM_DESTROY, 0, 0);
          Exit;
        end;
      end;
    end;
  end
  else begin
    if FTransparent < 255 then begin
      if FTransparent < FTransparentOld then begin
        FTransparent := FTransparent + FFadeSpeed;
        if FTransparent > FTransparentOld then FTransparent := FTransparentOld;
      end else begin
        FTransparent := FTransparentOld;
      end;
    end;
  end;
  DrawSplash();
  if FrameNumber = 0 then
    ShowWindow(AppHandle, SW_SHOW);
  Inc(FrameNumber);
  FTickCountAll := FTickCountAll + TickCount;
end;

procedure TAnimationSplashForm.DrawSplash;
var
  GPGraph: TGPGraphics;
  tmpImage: TGPBitmap;
  w, h: Integer;
begin
  w := FBMPBackground.GetWidth;
  h := FBMPBackground.GetHeight;
  tmpImage := TGPBitmap.Create(w, h,PixelFormat32bppARGB);
  tmpImage.SetResolution(FBMPBackground.GetHorizontalResolution, FBMPBackground.GetVerticalResolution);
  GPGraph := TGPGraphics.Create(tmpImage);
  GPGraph.DrawImage(FBMPBackground, MakeRect(0, 0, w, h), 0, 0, w, h, UnitPixel);
  try
    if TextData.Count <> 0 then begin
      PaintText(GPGraph);
    end;
    if ProgressBar.BarVisible then begin
      PaintProgressBar(GPGraph);
    end;
    if ProgressIconsVisible then begin
      PaintIcons(GPGraph);
    end;
    if FAnimations.Count <> 0 then begin
      PaintAnimations(GPGraph);
    end;
    RenderForm(FTransparent, tmpImage);
  finally
    tmpImage.Free;
    GPGraph.Free;
  end;
end;

procedure TAnimationSplashForm.RenderForm(TransparentValue: byte; SourceImage: TGPBitmap);
var
  zsize: TSize;
  zpoint: TPoint;
  zbf: TBlendFunction;
  TopLeft: TPoint;
  WR: TRect;
  GPGraph: TGPGraphics;
  m_hdcMemory: HDC;
  hdcScreen: HDC;
  hBMP: HBITMAP;
begin
  hdcScreen := GetDC(0);
  m_hdcMemory := CreateCompatibleDC(hdcScreen);
  hBMP := CreateCompatibleBitmap(hdcScreen, SourceImage.GetWidth(), SourceImage.GetHeight());
  SelectObject(m_hdcMemory, hBMP);
  GPGraph := TGPGraphics.Create(m_hdcMemory);
  try
{    GPGraph.SetInterpolationMode(InterpolationModeHighQualityBicubic);}
    GPGraph.DrawImage(SourceImage, 0, 0, SourceImage.GetWidth(), SourceImage.GetHeight());
    SetWindowLong(AppHandle, GWL_EXSTYLE, GetWindowLong(AppHandle, GWL_EXSTYLE) or WS_EX_LAYERED);
    zsize.cx := SourceImage.GetWidth;
    zsize.cy := SourceImage.GetHeight;
    zpoint := Point(0, 0);
    with zbf do begin
      BlendOp := AC_SRC_OVER;
      BlendFlags := 0;
      AlphaFormat := AC_SRC_ALPHA;
      SourceConstantAlpha := TransparentValue;
    end;
    GetWindowRect(AppHandle, WR);
    TopLeft := Wr.TopLeft;
    if not FTestSpeed then
      UpdateLayeredWindow(AppHandle, FDC, @TopLeft, @zsize, GPGraph.GetHDC, @zpoint, 0, @zbf, ULW_ALPHA);
  finally
    GPGraph.ReleaseHDC(m_hdcMemory);
    ReleaseDC(0, hdcScreen);
    DeleteObject(hBMP);
    DeleteDC(m_hdcMemory);
    GPGraph.Free;
  end;
end;

procedure TAnimationSplashForm.PaintText(GPGraphics: TGPGraphics);
var
  i: Integer;
  GPRect: TGPRectF;
begin
  for I := 0 to TextData.Count - 1 do begin
    with TextData.Items[i] do begin
      if Visible then begin
        if VisibleShadow then begin
          GPRect := MakeRect(TextBox.X + 1, TextBox.Y + 1, TextBox.Width + 1, Int(TextBox.Height + 1));
          TextOut(TextData.Items[i], TextData.Items[i].ShadowColor, GPGraphics, GPRect);
        end;
        GPRect := MakeRect(TextBox.X, TextBox.Y, TextBox.Width, Int(TextBox.Height));
        TextOut(TextData.Items[i], TextData.Items[i].Color, GPGraphics, GPRect);
      end;
    end;
  end;
end;

procedure TAnimationSplashForm.TextOut(TextInfo: TTextItem; TextColor:
    Cardinal; GPGraphics: TGPGraphics; GPRect: TGPRectF);
var
  GPStrForm: TGPStringFormat;
  GPBrush: TGPBrush;
  GPFont: TGPFont;
begin
  with TextInfo do begin
    GPFont := TGPFont.Create(FontName, FontSize, FontStyle);
    GPBrush := TGPSolidBrush.Create(MakeColor(GetAlpha(TextColor), GetRValue(TextColor), GetGValue(TextColor), GetBValue(TextColor)));
    GPStrForm := TGPStringFormat.Create;
    try
      GPStrForm.SetAlignment(PositionH);
      GPStrForm.SetLineAlignment(PositionV);
      GPGraphics.SetTextRenderingHint(RenderingHint);
      GPGraphics.DrawString(Text, length(Text), GPFont, GPRect, GPStrForm, GPBrush);
    finally
      GPStrForm.Free;
      GPBrush.Free;
      GPFont.Free;
    end;
  end;
end;

procedure TAnimationSplashForm.PaintProgressBar(GPGraphics: TGPGraphics);
var
  GPPen: TGPPen;
  GPBrush: TGPBrush;
  W: Integer;
begin
  GPPen := TGPPen.Create(ProgressBar.BarBorderColor);
  GPBrush := TGPSolidBrush.Create(ProgressBar.BarColor);
  try
    w := Round(FTickCountAll / (LoadingPartTime / FOnePartProgressSize)) + FStartCurrentPart;
    if w > FOnePartProgressSize * ProgressBarCurrentPart then begin
      w := FOnePartProgressSize * ProgressBarCurrentPart;
    end;
    with ProgressBar^ do begin
      if ProgressBar.BarBorderVisible then begin
        GPGraphics.DrawRectangle(GPPen, BarBox.X, BarBox.Y, BarBox.Width, BarBox.Height);
        GPGraphics.FillRectangle(GPBrush, BarBox.X + 2, BarBox.Y + 2, w - 3 , BarBox.Height - 3);
      end
      else begin
        GPGraphics.FillRectangle(GPBrush, BarBox.X, BarBox.Y, w, BarBox.Height);
      end;
    end;
  finally
    GPPen.Free;
    GPBrush.Free;
  end;
end;

procedure TAnimationSplashForm.PaintIcons(GPGraphics: TGPGraphics);
var
  I, it, w, h: Integer;
  GPImageAttributes: TGPImageAttributes;
  tmpImage: TGPBitmap;
  aRect: TGPRectF;
  GPGraph: TGPGraphics;
begin
  if Assigned(Icons) then begin
    GPImageAttributes := TGPImageAttributes.Create;
    try
      for i := 0 to Length(FIconPosArray) - 1 do begin
        if FIconPosArray[i].IconIndex = -1 then begin
          it := i - 1;
          Break;
        end;
        it := i;
      end;
      if (it <> -1) and (Length(FIconPosArray) <> 0) then begin
        for I := 0 to it - 1 do begin
          if FIconPosArray[i].IconIndex <> -1 then
            GPGraphics.DrawImage(Icons.Items[FIconPosArray[i].IconIndex],
                FIconPosArray[i].IconPos, IconPosTop);
        end;
        aRect := GetAnimationRect(it, GPImageAttributes);
        w := Icons.Items[FIconPosArray[it].IconIndex].GetWidth;
        h := Icons.Items[FIconPosArray[it].IconIndex].GetHeight;
        tmpImage := TGPBitmap.Create(w, h, PixelFormat32bppARGB);
//        tmpImage.SetResolution(GPGraphics.GetDpiX, GPGraphics.GetDpiY);
        // Правилнее будет всё-таки ставить разрешение копируемой картинки. Мне так кажется
        tmpImage.SetResolution(Icons.Items[FIconPosArray[it].IconIndex].GetHorizontalResolution,
            Icons.Items[FIconPosArray[it].IconIndex].GetVerticalResolution);
        GPGraph := TGPGraphics.Create(tmpImage);
        GPGraph.DrawImage(Icons.Items[FIconPosArray[it].IconIndex],
            MakeRect(0, 0, w, h), 0, 0, w, h, UnitPixel);
        GPGraphics.DrawImage(tmpImage, aRect, 0, 0, aRect.Width, aRect.Height,
            UnitPixel, GPImageAttributes);
        tmpImage.Free;
        GPGraph.Free;
      end;
    finally
      GPImageAttributes.Free;
    end;
  end;
end;

function TAnimationSplashForm.GetAnimationRect(ItemIndex: Integer;
    GPImageAttributes: TGPImageAttributes): TGPRectF;
const
  c299 = 1 - 0.299;
  c587 = 1 - 0.587;
  c114 = 1 - 0.114;
var
  a, tc: Real;
begin
  tc := FTickCountAll / (LoadingPartTime * (IconFullPaintPercent / 100));
  case IconAnimation of
    iaNone: begin
        Result := MakeRect(CalcCurrentIconPos(ItemIndex), IconPosTop,
              Int(FIconPosArray[ItemIndex].IconWidth),
              Int(FIconPosArray[ItemIndex].IconHeight));
      end;
    iaFade: begin
        a := tc;
        if a > 1 then
          a := 1;
        FadeColorMatrix[3, 3] := a;
        GPImageAttributes.SetColorMatrix(FadeColorMatrix);
        Result := MakeRect(CalcCurrentIconPos(ItemIndex), IconPosTop,
              Int(FIconPosArray[ItemIndex].IconWidth),
              Int(FIconPosArray[ItemIndex].IconHeight));
      end;
    iaFadeColor: begin
        a := c299 + (c299 * tc);
        if a > 1 then a := 1;
        FadeColorColorMatrix[0, 0] := a;
        a := 0.299 - (0.299 * tc);
        if a < 0 then a := 0;
        FadeColorColorMatrix[0, 1] := a;
        FadeColorColorMatrix[0, 2] := a;
        a := c587 + (c587 * tc);
        if a > 1 then a := 1;
        FadeColorColorMatrix[1, 1] := a;
        a := 0.587 - (0.587 * tc);
        if a < 0 then a := 0;
        FadeColorColorMatrix[1, 0] := a;
        FadeColorColorMatrix[1, 2] := a;
        a := c114 + (c114 * tc);
        if a > 1 then a := 1;
        FadeColorColorMatrix[2, 2] := a;
        a := 0.114 - (0.114 * tc);
        if a < 0 then a := 0;
        FadeColorColorMatrix[2, 0] := a;
        FadeColorColorMatrix[2, 1] := a;
        GPImageAttributes.SetColorMatrix(FadeColorColorMatrix);
        Result := MakeRect(CalcCurrentIconPos(ItemIndex), IconPosTop,
              Int(FIconPosArray[ItemIndex].IconWidth),
              Int(FIconPosArray[ItemIndex].IconHeight));
      end;
    iaSlideTop: begin
        Result := MakeRect(CalcCurrentIconPos(ItemIndex), IconPosTop,
              FIconPosArray[ItemIndex].IconWidth,
              Round(FIconPosArray[ItemIndex].IconHeight * tc));
      end;
    iaSlideLeft: begin
        Result := MakeRect(CalcCurrentIconPos(ItemIndex), IconPosTop,
              Round(FIconPosArray[ItemIndex].IconWidth * tc),
              FIconPosArray[ItemIndex].IconHeight);
      end;
    iaSlideCorner: begin
        Result := MakeRect(CalcCurrentIconPos(ItemIndex), IconPosTop,
              Round(FIconPosArray[ItemIndex].IconWidth * tc),
              Round(FIconPosArray[ItemIndex].IconHeight * tc));
      end;
  end;
end;

procedure TAnimationSplashForm.PaintAnimations(GPGraphics: TGPGraphics);
var
  i: Integer;
begin
  for i := 0 to FAnimations.Count - 1 do begin
    with TAnimationFrames(FAnimations.Items[i]) do begin
      if Count <> 0 then begin
        GPGraphics.DrawImage(Items[NumCurrentLoadingImage], PositionLeft, PositionTop);
        CalculateDelay;
      end;
    end;
  end;
end;

end.

