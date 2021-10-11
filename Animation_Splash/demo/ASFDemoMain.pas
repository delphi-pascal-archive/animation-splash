unit ASFDemoMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShellAPI;

type
  Tfrm_Main = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure LabelMouseEnter(Sender: TObject);
    procedure LabelMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frm_Main: Tfrm_Main;

{===================================================== }
// Хранит индекс текста, который надо будет менять в процессе
  ProgressTextItem: Integer;

const
  //заколебался придумывать :) (© antonn) =)
  TextStatusLoader: array [0..16] of string =
    ('Инициализация...',  // 1
     'Проверка путей',
     'Загрузка ядра',

     'Загрузка модулей',   // 2

     'Проверка обновлений',  // 3
     'Загрузка новой версии',
     'Обновление...',

     'Инициализация COM',        // 4
     'Проверка запущенных служб',
     'Установка сетевых параметров',

     'Загрузка настроек',   // 5
     'Подключение MUI',
     'Формирование меню',
     'Применение профиля',
     'Загрузка интерфейса',
     'Подготовка к работе...',
     'Готово :)');

implementation

uses
  ASFMain;

{$R *.dfm}

procedure Tfrm_Main.FormCreate(Sender: TObject);
begin
  // Установить индекс текущей иконки
  AnimationSplashForm.ProgressIconCurrentItem := 0;
  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[0];
  // в мс. приблизительно
  AnimationSplashForm.LoadingPartTime := 3000;
  // Имитация долгого безответного действия
  Sleep(1000);
  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[1];
  Sleep(1000); // Имитация долгого безответного действия
  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[2];
  Sleep(1000); // Имитация долгого безответного действия


  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[3];
  AnimationSplashForm.IncCurrentPart;
  AnimationSplashForm.IncCurrentItemIcon;
  AnimationSplashForm.LoadingPartTime := 2000;
  // Имитация долгого безответного действия
  Sleep(2000);


  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[4];
  AnimationSplashForm.IncCurrentPart;
  AnimationSplashForm.IncCurrentItemIcon;
  AnimationSplashForm.LoadingPartTime := 4000;
  // Имитация долгого безответного действия
  Sleep(2000);
  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[5];
  Sleep(1000);
  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[6];
  Sleep(1000);


  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[7];
  AnimationSplashForm.IncCurrentPart;
  AnimationSplashForm.IncCurrentItemIcon;
  AnimationSplashForm.LoadingPartTime := 4000;
  // Имитация долгого безответного действия
  Sleep(2000);
  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[8];
  Sleep(1000);
  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[9];
  Sleep(1000);

  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[10];
  AnimationSplashForm.IncCurrentPart;
  AnimationSplashForm.IncCurrentItemIcon;
  AnimationSplashForm.LoadingPartTime := 3500;
  // Имитация долгого безответного действия
  Sleep(600);
  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[11];
  Sleep(600);
  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[12];
  Sleep(600);
  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[13];
  Sleep(600);
  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[14];
  Sleep(600);
  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[15];
  Sleep(600);


  AnimationSplashForm.TextData.Items[ProgressTextItem].Text := TextStatusLoader[16];
end;














procedure Tfrm_Main.Label2Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  ShellExecute(Application.Handle, nil,
      'mailto:Andy%20Bitoff<bitoff@pisem.net>?subject=AnimationSplashForm',
      nil, nil, SW_SHOWNORMAL);
  Screen.Cursor := crDefault;
end;

procedure Tfrm_Main.Label3Click(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  ShellExecute(Application.Handle, nil,
      'http://AnimationSplash.elementfx.com/',
      nil, nil, SW_SHOWNORMAL);
  Screen.Cursor := crDefault;
end;

procedure Tfrm_Main.LabelMouseEnter(Sender: TObject);
var
  a: Integer;
begin
  Screen.Cursor := crHandPoint;
  a := TLabel(Sender).Tag;
  TLabel(Sender).Tag := TLabel(Sender).Font.Color;
  TLabel(Sender).Font.Color := TColor(a);
end;

procedure Tfrm_Main.LabelMouseLeave(Sender: TObject);
begin
  LabelMouseEnter(Sender);
  Screen.Cursor := crDefault;
end;

end.


