program ASFDemoAntonn;

uses
  Forms,
  ASFDemoMain in 'ASFDemoMain.pas' {frm_Main},
  SysUtils,
  GDIPAPI,
  ASFLists in '..\..\ASFLists.pas',
  ASFMain in '..\..\ASFMain.pas';

{$R *.res}

var
{  Anim1: TAnimationFrames;}
  SplashImagePath, s: string;
  i: Integer;

begin
  SplashImagePath := ExtractFilePath(ParamStr(0)) + 'img\';

  AnimationSplashForm := TAnimationSplashForm.Create(SplashImagePath + 'Splash.png');
  // Здесь надо учесть, что центруется сплэш именно по размерам бэкграунда
//  AnimationSplashForm := TAnimationSplashForm.CreateEmptyBackGround(196, 273, 72, 72);

  // Показывать кнопку на Панели задач
  AnimationSplashForm.ShowTaskbarButton := True;
  // Заголовок онка, если ShowTaskbarButton = True
  AnimationSplashForm.SplashFormCaption := 'Загрузка...';
  // Отрисовывать окно поверх всех
  AnimationSplashForm.SplashFormTopMost := False;
  // Скорость проявления и затухания сплэша
  // зависимость от таймера, т.е. SetTimerInterval * FadeSpeed
  AnimationSplashForm.FadeSpeed := 7;
  // Установка интервала таймера
  AnimationSplashForm.SetTimerInterval(15);

// ТЕКСТ ПРОЦЕССА
  ProgressTextItem := AnimationSplashForm.TextData.AddNewItem;
  with AnimationSplashForm.TextData.Items[ProgressTextItem] do begin
    // Показывать текст
    Visible := True;
    // Показывать тень текста
    VisibleShadow := True;
    // Рект в котором отображается текст
    TextBox := MakeRect(90, 75, 200, 20);
    // цвет текста
    Color := $FFF0F0F4;
    // цвет тени
    ShadowColor := $FF6C6C39;
    // шрифт
    FontName := 'Verdana';
    FontSize := 11;
    // центровать по горизонтали
    PositionH := StringAlignmentNear;
    RenderingHint := TextRenderingHintSingleBitPerPixelGridFit;
  end;

// ПРОГРЕСС БАР
  with AnimationSplashForm.ProgressBar^ do begin
    // Показывать прогресс бар
    BarVisible := True;
    // Показывать рамку прогресс бара
    BarBorderVisible := True;
    // размеры прогресс бара
    BarBox := MakeRect(16, 96, 266, 14);
    // цвет прогресс бара
    BarColor := $30FFFFFF;
    // цвет бордюра
    BarBorderColor := $FFF0F0F0;
  end;




// ИКОНКИ
  // Показывать иконки
  AnimationSplashForm.ProgressIconsVisible := True;
  // Скорость проявления иконок (в процентах) в зависимости от LoadingPartTime
  // 100 значит, что иконка будет проявляться всё время (LoadingPartTime),
  // 50 - проявится за половину времени
  AnimationSplashForm.IconFullPaintPercent := 100;
  // Задать анимацию появления иконок
  AnimationSplashForm.IconAnimation := iaFadeColor;
  // Положение первой иконки - левый край
  AnimationSplashForm.IconPosLeft := 20;
  // Положение первой иконки - верхний край
  AnimationSplashForm.IconPosTop := 117;
  // Расстояние между иконками
  AnimationSplashForm.IconSpace := 2;
  // Сколько пикс.отступать от левого края пред.иконки.
  // Если это знач. = 0, то берется значение ширины пред.иконки
  AnimationSplashForm.IconStep := 0;
  // Теперь загружаем сами иконки
  AnimationSplashForm.Icons := TImagesList.CreateFrom(SplashImagePath + 'Icons.dat');
{  // Первая загрузка из файлов и сохранение в один файл
  // Затем загрузка идет уже и того файла
  AnimationSplashForm.Icons := TImagesList.Create;
  AnimationSplashForm.Icons.AddFromFile(SplashImagePath + 'ico1.png');
  AnimationSplashForm.Icons.AddFromFile(SplashImagePath + 'ico2.png');
  AnimationSplashForm.Icons.AddFromFile(SplashImagePath + 'ico3.png');
  AnimationSplashForm.Icons.AddFromFile(SplashImagePath + 'ico4.png');
  AnimationSplashForm.Icons.AddFromFile(SplashImagePath + 'ico5.png');
  AnimationSplashForm.Icons.SaveToFile(SplashImagePath + 'Icons.dat');}

  // Устанавливает количество частей для загрузки
  // Также автоматом ProgressBarCurrentPart ставится равной 1
  AnimationSplashForm.ProgressBarPatrs := 5;

  // Запустить Splash
  AnimationSplashForm.StartSplash;

  Application.Initialize;
  Application.CreateForm(Tfrm_Main, frm_Main);
  // Закрыть и уничтожить
  AnimationSplashForm.CloseSplash(30, True);
  Application.Run;
end.