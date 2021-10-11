unit ASFLists;

interface

uses Contnrs, SysUtils, Classes, Windows, GDIPAPI, GDIPOBJ, GDIPUTIL;

type

  TImagesList = class(TObjectList)
  private
    FCS: TRTLCriticalSection;
    FencoderClsid: TGUID;
    function GetItems(Index: Integer): TGPImage;
    procedure SetItems(Index: Integer; const Value: TGPImage);
  public
    constructor Create;
    constructor CreateFrom(FileName: string); overload;
    constructor CreateFrom(ResourceName: string; ResourceType: PChar); overload;
    constructor CreateFrom(Stream: TStream); overload;
    destructor Destroy; override;
    function Add(Value: TGPImage): Integer;
    procedure LoadFromFile(FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(FileName: string);
    procedure SaveToStream(Stream: TStream);
    function AddFromFile(FileName: string): Integer;
    function AddFromStream(Stream: TStream): Integer;
    property Items[Index: Integer]: TGPImage read GetItems write SetItems; default;
  end;

  TAnimationFrames = class(TImagesList)
  private
    FACS: TRTLCriticalSection;
    FNumCurrentLoadingImage: Integer;
    FPositionLeft: Integer;
    FPositionTop: Integer;
    FDelayBetweenImages: Integer;
    FCurrentDelayBetweenImages: Integer;
    procedure Init;
  public
    constructor Create; overload;
    constructor CreateFrom(FileName: string); overload;
    constructor CreateFrom(ResourceName: string; ResourceType: PChar); overload;
    constructor CreateFrom(Stream: TStream); overload;
    destructor Destroy; override;
    function Add(Value: TGPImage): Integer;
    procedure CalculateDelay;
    procedure LoadFromFile(FileName: string);
    procedure LoadFromStream(Stream: TStream);
    procedure SaveToFile(FileName: string);
    procedure SaveToStream(Stream: TStream);
    property DelayBetweenImages: Integer read FDelayBetweenImages write FDelayBetweenImages;
    property NumCurrentLoadingImage: Integer read FNumCurrentLoadingImage write FNumCurrentLoadingImage;
    property PositionLeft: Integer read FPositionLeft write FPositionLeft;
    property PositionTop: Integer read FPositionTop write FPositionTop;
  end;

  TTextItem = class (TObject)
  private
    FVisible: Boolean;
    FVisibleShadow: Boolean;
    FText: WideString;
    FTextBox: TGPRect;
    FColor: Cardinal;
    FShadowColor: Cardinal;
    FFontName: string;
    FFontSize: integer;
    FFontStyle: integer;
    FPositionH: TStringAlignment;
    FPositionV: TStringAlignment;
    FRenderingHint: TTextRenderingHint;
  public
    procedure Assign(source : TTextItem);
    property Visible: Boolean read FVisible write FVisible;
    property VisibleShadow: Boolean read FVisibleShadow write FVisibleShadow;
    property Text: WideString read FText write FText;
    property TextBox: TGPRect read FTextBox write FTextBox;
    property Color: Cardinal read FColor write FColor;
    property ShadowColor: Cardinal read FShadowColor write FShadowColor;
    property FontName: string read FFontName write FFontName;
    property FontSize: integer read FFontSize write FFontSize;
    property FontStyle: integer read FFontStyle write FFontStyle;
    property PositionH: TStringAlignment read FPositionH write FPositionH;
    property PositionV: TStringAlignment read FPositionV write FPositionV;
    property RenderingHint: TTextRenderingHint read FRenderingHint write FRenderingHint;
  end;

  TTextItemList = class (TObject)
  private
    FTICS: TRTLCriticalSection;
    FItems: TObjectList;
    function GetCount: Integer;
    function GetItem(Index: Integer): TTextItem;
    procedure SetItem(Index: Integer; const Value: TTextItem);
  public
    constructor Create;
    destructor Destroy; override;
    function AddItem(Item: TTextItem) : Integer;
    procedure DeleteItem(Index: Integer);
    procedure Clear;
    function AddNewItem: Integer;
    property Items[Index: Integer]: TTextItem read GetItem write SetItem;
    property Count: Integer read GetCount;
  end;


implementation

uses
  ActiveX, ASFMain;

const
    si = SizeOf(Integer);

type
  TFixedStreamAdapter = class(TStreamAdapter)
    public
      function Stat(out statstg: TStatStg; grfStatFlag: Longint): HResult; override; stdcall;
    end;



{ TFixedStreamAdapter }

function TFixedStreamAdapter.Stat(out statstg: TStatStg; grfStatFlag: Integer): HResult;
begin
  Result := inherited Stat(statstg, grfStatFlag);
  statstg.pwcsName := nil;
end;



{ TImagesList }

constructor TImagesList.Create;
begin
  inherited Create;
  GetEncoderClsid('image/png', FencoderClsid);
  InitializeCriticalSection(FCS);
  OwnsObjects := True;
end;

constructor TImagesList.CreateFrom(FileName: string);
begin
  Create;
  LoadFromFile(FileName);
end;

constructor TImagesList.CreateFrom(Stream: TStream);
begin
  Create;
  LoadFromStream(Stream);
end;

constructor TImagesList.CreateFrom(ResourceName: string; ResourceType: PChar);
begin
  Create;
  LoadFromStream(TResourceStream.Create(Hinstance, ResourceName, ResourceType));
end;

destructor TImagesList.Destroy;
begin
  DeleteCriticalSection(FCS);
  inherited Destroy;
end;

function TImagesList.Add(Value: TGPImage): Integer;
{var
  tmpImage: TGPImage;}
begin
  EnterCriticalSection(FCS);
  try
{    tmpImage := TGPImage.Create;
    tmpImage := Value.Clone;}
    Result := inherited Add(Value);
  finally
    LeaveCriticalSection(FCS);
  end;
end;

function TImagesList.AddFromFile(FileName: string): Integer;
begin
  EnterCriticalSection(FCS);
  try
    Result := Add(TGPImage.Create(FileName));
  finally
    LeaveCriticalSection(FCS);
  end;          
end;

function TImagesList.AddFromStream(Stream: TStream): Integer;
begin
  EnterCriticalSection(FCS);
  try
    Result := Add(TGPImage.Create(TFixedStreamAdapter.Create(Stream)));
  finally
    LeaveCriticalSection(FCS);
  end;
end;

function TImagesList.GetItems(Index: Integer): TGPImage;
begin
  EnterCriticalSection(FCS);
  try
    Result := TGPImage(GetItem(Index));
  finally
    LeaveCriticalSection(FCS);
  end;          
end;

procedure TImagesList.SetItems(Index: Integer; const Value: TGPImage);
begin
  EnterCriticalSection(FCS);
  try
    Items[Index] := Value;
  finally
    LeaveCriticalSection(FCS);
  end;          
end;

procedure TImagesList.LoadFromFile(FileName: string);
begin
  EnterCriticalSection(FCS);
  try
    if not FileExists(FileName) then
      raise Exception.Create(Format(eFileNotFound , [FileName]));
    LoadFromStream(TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite));
  finally
    LeaveCriticalSection(FCS);
  end;
end;

procedure TImagesList.LoadFromStream(Stream: TStream);
var
  aSize: Int64;
  tmpStream: TMemoryStream;
begin
  EnterCriticalSection(FCS);
  try
    tmpStream := TMemoryStream.Create;
    try
      while Stream.Position < Stream.Size do begin
        Stream.Read(aSize, SizeOf(aSize));
        tmpStream.SetSize(aSize);
        tmpStream.CopyFrom(Stream, aSize);
        AddFromStream(tmpStream);
        tmpStream.Clear;
      end;
    finally
      tmpStream.Free;
    end;
  finally
    LeaveCriticalSection(FCS);
  end;          
end;

procedure TImagesList.SaveToFile(FileName: string);
begin
  EnterCriticalSection(FCS);
  try
    if Count = 0 then exit;
    SaveToStream(TFileStream.Create(FileName, fmCreate or fmShareDenyWrite));
  finally
    LeaveCriticalSection(FCS);
  end;
end;

procedure TImagesList.SaveToStream(Stream: TStream);
var
  i: Integer;
  aSize: Int64;
  tmpStream: TMemoryStream;
begin
  EnterCriticalSection(FCS);
  try
    tmpStream := TMemoryStream.Create;
    try
      for i := 0 to Count - 1 do begin
        tmpStream.Clear;
        Items[i].Save(TFixedStreamAdapter.Create(tmpStream), FencoderClsid);
        aSize := tmpStream.Size;
        Stream.Seek(0, soFromEnd);
        Stream.Write(aSize, SizeOf(aSize));
        tmpStream.Position := 0;
        Stream.CopyFrom(tmpStream, aSize);
      end;
    finally
      tmpStream.Free;
    end;
  finally
    LeaveCriticalSection(FCS);
  end;
end;



{ TAnimationFrames }

constructor TAnimationFrames.Create;
begin
  inherited Create;
  Init();
end;

constructor TAnimationFrames.CreateFrom(FileName: string);
begin
  Create;
  LoadFromFile(FileName);
end;

constructor TAnimationFrames.CreateFrom(Stream: TStream);
begin
  Create;
  LoadFromStream(Stream);
end;

constructor TAnimationFrames.CreateFrom(ResourceName: string; ResourceType: PChar);
begin
  Create;
  LoadFromStream(TResourceStream.Create(Hinstance, ResourceName, ResourceType));
end;

destructor TAnimationFrames.Destroy;
begin
  DeleteCriticalSection(FACS);
  inherited;
end;

procedure TAnimationFrames.Init;
begin
  InitializeCriticalSection(FACS);
  NumCurrentLoadingImage := 0;
  PositionLeft := 0;
  PositionTop := 0;
  DelayBetweenImages := 1;
  FCurrentDelayBetweenImages := 0;
end;

function TAnimationFrames.Add(Value: TGPImage): Integer;
begin
  EnterCriticalSection(FACS);
  try
    Result := inherited Add(Value);
  finally
    LeaveCriticalSection(FACS);
  end;
end;

procedure TAnimationFrames.LoadFromFile(FileName: string);
begin
  EnterCriticalSection(FACS);
  try
    if not FileExists(FileName) then
      raise Exception.Create(Format(eFileNotFound , [FileName]));
    LoadFromStream(TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite));
  finally
    LeaveCriticalSection(FACS);
  end;
end;

procedure TAnimationFrames.LoadFromStream(Stream: TStream);
var
  aSize: Int64;
  tmpStream: TMemoryStream;
begin
  EnterCriticalSection(FACS);
  try
    tmpStream := TMemoryStream.Create;
    try
      Stream.Read(FNumCurrentLoadingImage, si);
      Stream.Read(FPositionLeft, si);
      Stream.Read(FPositionTop, si);
      Stream.Read(FDelayBetweenImages, si);
      Stream.Read(aSize, SizeOf(aSize));
      tmpStream.SetSize(aSize);
      tmpStream.CopyFrom(Stream, aSize);
      tmpStream.Position := 0;
      inherited LoadFromStream(tmpStream);
    finally
      tmpStream.Free;
    end;
  finally
    LeaveCriticalSection(FACS);
  end;
end;

procedure TAnimationFrames.SaveToFile(FileName: string);
begin
  EnterCriticalSection(FACS);
  try
    if Count = 0 then exit;
    SaveToStream(TFileStream.Create(FileName, fmCreate or fmShareDenyWrite));
  finally
    LeaveCriticalSection(FACS);
  end;
end;

procedure TAnimationFrames.SaveToStream(Stream: TStream);
var
  aSize: Int64;
  tmpStream: TMemoryStream;
begin
  EnterCriticalSection(FACS);
  try
    tmpStream := TMemoryStream.Create;
    try
      Stream.Write(FNumCurrentLoadingImage, si);
      Stream.Write(FPositionLeft, si);
      Stream.Write(FPositionTop, si);
      Stream.Write(FDelayBetweenImages, si);
      inherited SaveToStream(tmpStream);
      aSize := tmpStream.Size;
      Stream.Seek(0, soFromEnd);
      Stream.Write(aSize, SizeOf(aSize));
      tmpStream.Position := 0;
      Stream.CopyFrom(tmpStream, aSize);
    finally
      tmpStream.Free;
    end;
  finally
    LeaveCriticalSection(FACS);
  end;
end;

procedure TAnimationFrames.CalculateDelay;
begin
  EnterCriticalSection(FACS);
  try
    Dec(FCurrentDelayBetweenImages);
    if FCurrentDelayBetweenImages <= 0 then begin
      FCurrentDelayBetweenImages := FDelayBetweenImages;
      Inc(FNumCurrentLoadingImage);
      if FNumCurrentLoadingImage = Count then
        FNumCurrentLoadingImage := 0;
    end;
  finally
    LeaveCriticalSection(FACS);
  end;
end;


{ TTextItem }

procedure TTextItem.Assign(Source: TTextItem);
begin
  Visible := Source.FVisible;
  VisibleShadow := Source.FVisibleShadow;
  Text := Source.FText;
  TextBox := Source.FTextBox;
  Color := Source.FColor;
  ShadowColor := Source.FShadowColor;
  FontName := Source.FFontName;
  FontSize := Source.FFontSize;
  FontStyle := Source.FFontStyle;
  PositionH := Source.FPositionH;
  PositionV := Source.FPositionV;
  RenderingHint := Source.FRenderingHint;
end;

{ TTextItemList }

constructor TTextItemList.Create;
begin
  InitializeCriticalSection(FTICS);
  FItems := TObjectList.Create(True);
end;

destructor TTextItemList.Destroy;
begin
  FItems.Free;
  DeleteCriticalSection(FTICS);
  inherited;
end;

function TTextItemList.GetItem(Index: Integer): TTextItem;
begin
  try
    Result := TTextItem(FItems.Items[Index]);
  except
    Result := nil;
  end;
end;

procedure TTextItemList.SetItem(Index: Integer; const Value: TTextItem);
begin
  EnterCriticalSection(FTICS);
  try
    TTextItem(FItems.Items[Index]).Assign(Value);
  finally
    LeaveCriticalSection(FTICS);
  end;          
end;

function TTextItemList.AddItem(Item: TTextItem): Integer;
begin
  EnterCriticalSection(FTICS);
  try
    Result := FItems.Add(Item);
  finally
    LeaveCriticalSection(FTICS);
  end;          
end;

function TTextItemList.AddNewItem: Integer;
var
  tmp: TTextItem;
begin
  tmp := TTextItem.Create;
  with tmp do begin
    Visible := False;
    VisibleShadow := True;
    Text := '';
    TextBox := MakeRect(0, 0, 100, 20);
    Color := $FFFFFFFF;
    ShadowColor := $FF6C6C39;
    FontName := 'Verdana';
    FontSize := 11;
    FontStyle := FontStyleRegular;
    PositionH := StringAlignmentNear;
    PositionV := StringAlignmentCenter;
    RenderingHint := TextRenderingHintAntiAlias;
  end;
  Result := AddItem(tmp);
end;

procedure TTextItemList.Clear;
begin
  EnterCriticalSection(FTICS);
  try
    FItems.Clear;
  finally
    LeaveCriticalSection(FTICS);
  end;          
end;

procedure TTextItemList.DeleteItem(Index: Integer);
begin
  EnterCriticalSection(FTICS);
  try
    FItems.Delete(Index);
  finally
    LeaveCriticalSection(FTICS);
  end;          
end;

function TTextItemList.GetCount: Integer;
begin
  Result := FItems.Count;
end;

end.

