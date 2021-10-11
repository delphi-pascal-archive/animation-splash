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
  // ����� ���� ������, ��� ���������� ����� ������ �� �������� ����������
//  AnimationSplashForm := TAnimationSplashForm.CreateEmptyBackGround(196, 273, 72, 72);

  // ���������� ������ �� ������ �����
  AnimationSplashForm.ShowTaskbarButton := True;
  // ��������� ����, ���� ShowTaskbarButton = True
  AnimationSplashForm.SplashFormCaption := '��������...';
  // ������������ ���� ������ ����
  AnimationSplashForm.SplashFormTopMost := False;
  // �������� ���������� � ��������� ������
  // ����������� �� �������, �.�. SetTimerInterval * FadeSpeed
  AnimationSplashForm.FadeSpeed := 7;
  // ��������� ��������� �������
  AnimationSplashForm.SetTimerInterval(15);

// ����� ��������
  ProgressTextItem := AnimationSplashForm.TextData.AddNewItem;
  with AnimationSplashForm.TextData.Items[ProgressTextItem] do begin
    // ���������� �����
    Visible := True;
    // ���������� ���� ������
    VisibleShadow := True;
    // ���� � ������� ������������ �����
    TextBox := MakeRect(90, 75, 200, 20);
    // ���� ������
    Color := $FFF0F0F4;
    // ���� ����
    ShadowColor := $FF6C6C39;
    // �����
    FontName := 'Verdana';
    FontSize := 11;
    // ���������� �� �����������
    PositionH := StringAlignmentNear;
    RenderingHint := TextRenderingHintSingleBitPerPixelGridFit;
  end;

// �������� ���
  with AnimationSplashForm.ProgressBar^ do begin
    // ���������� �������� ���
    BarVisible := True;
    // ���������� ����� �������� ����
    BarBorderVisible := True;
    // ������� �������� ����
    BarBox := MakeRect(16, 96, 266, 14);
    // ���� �������� ����
    BarColor := $30FFFFFF;
    // ���� �������
    BarBorderColor := $FFF0F0F0;
  end;




// ������
  // ���������� ������
  AnimationSplashForm.ProgressIconsVisible := True;
  // �������� ���������� ������ (� ���������) � ����������� �� LoadingPartTime
  // 100 ������, ��� ������ ����� ����������� �� ����� (LoadingPartTime),
  // 50 - ��������� �� �������� �������
  AnimationSplashForm.IconFullPaintPercent := 100;
  // ������ �������� ��������� ������
  AnimationSplashForm.IconAnimation := iaFadeColor;
  // ��������� ������ ������ - ����� ����
  AnimationSplashForm.IconPosLeft := 20;
  // ��������� ������ ������ - ������� ����
  AnimationSplashForm.IconPosTop := 117;
  // ���������� ����� ��������
  AnimationSplashForm.IconSpace := 2;
  // ������� ����.��������� �� ������ ���� ����.������.
  // ���� ��� ����. = 0, �� ������� �������� ������ ����.������
  AnimationSplashForm.IconStep := 0;
  // ������ ��������� ���� ������
  AnimationSplashForm.Icons := TImagesList.CreateFrom(SplashImagePath + 'Icons.dat');
{  // ������ �������� �� ������ � ���������� � ���� ����
  // ����� �������� ���� ��� � ���� �����
  AnimationSplashForm.Icons := TImagesList.Create;
  AnimationSplashForm.Icons.AddFromFile(SplashImagePath + 'ico1.png');
  AnimationSplashForm.Icons.AddFromFile(SplashImagePath + 'ico2.png');
  AnimationSplashForm.Icons.AddFromFile(SplashImagePath + 'ico3.png');
  AnimationSplashForm.Icons.AddFromFile(SplashImagePath + 'ico4.png');
  AnimationSplashForm.Icons.AddFromFile(SplashImagePath + 'ico5.png');
  AnimationSplashForm.Icons.SaveToFile(SplashImagePath + 'Icons.dat');}

  // ������������� ���������� ������ ��� ��������
  // ����� ��������� ProgressBarCurrentPart �������� ������ 1
  AnimationSplashForm.ProgressBarPatrs := 5;

  // ��������� Splash
  AnimationSplashForm.StartSplash;

  Application.Initialize;
  Application.CreateForm(Tfrm_Main, frm_Main);
  // ������� � ����������
  AnimationSplashForm.CloseSplash(30, True);
  Application.Run;
end.