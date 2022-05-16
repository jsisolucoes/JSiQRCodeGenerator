unit JSiQRCodeGenFMX;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Types,
  WinAPI.Windows,
  System.UITypes,
  FMX.DelphiZXIngQRCode,
  FMX.Graphics,
  FMX.Objects;

type
  TQRCodeEncoding = (qrAuto, qrNumeric, qrAlphanumeric, qrISO88591, qrUTF8NoBOM, qrUTF8BOM);

  TOnGenerate = procedure(Sender: TObject; Tempo: Integer; const aQRCode: TBitmap) of object;
  TOnError = procedure(Sender: TObject; ErroN: Integer; ErroMsg: String) of object;

  TJSiQRCodeGenFMX = class(TComponent)
  private
    FQR: TDelphiZXingQRCode;     //Onde a mágica acontece
    FData: WideString;           //informacao do QR Code
    FEncoding: TQRCodeEncoding;  //Tipo de texto
    FQZone: Integer;             //"Borda" do QR Code
    FQRBitmap: TBitmap;          //LINK - Bitmap para retorno do QR code
    FImageControl: TImage;       //LINK - controle para exibição do QR Code
    FTempo: Integer;
    FOnError: TOnError;
    FOnGenerate: TOnGenerate;    //tempo de conversao em ms
    procedure DoGenQRCode;
    procedure setImageControl(const Value: TImage);
  protected
    procedure DoOnGenerate(Tempo: Integer; const aQRCode: TBitmap);
    procedure DoOnError(ErrorN: Integer; ErrorMsg: String);
  public
    constructor Create(aOwner: TComponent); override;
    destructor Destroy; override;
    procedure GenerateQRCode;
  published
    property Data: WideString read FData write FData;
    property Encoding: TQRCodeEncoding read FEncoding write FEncoding;
    property QuietZone: Integer read FQZone write FQZone;
    property ImageControl: TImage read FImageControl write setImageControl;
    property Tempo: Integer read FTempo;
    property OnGenerate: TOnGenerate read FOnGenerate write FOnGenerate;
    property OnError: TOnError read FOnError write FOnError;
    property QRCode: TBitmap read FQRBitmap;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('JSi', [TJSiQRCodeGenFMX]);
end;

{ TJSiQRCodeGenFMX }

constructor TJSiQRCodeGenFMX.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FQR := TDelphiZXingQRCode.Create;
  FQRBitmap := TBitmap.Create;
end;

destructor TJSiQRCodeGenFMX.Destroy;
begin
  FQRBitmap.Free;
  FQR.Free;
  inherited Destroy;
end;

procedure TJSiQRCodeGenFMX.DoGenQRCode;
begin
  FTempo := 0;
  var Start: Integer;
  var Stop: Integer := 0;
  var bitdata: TBitmapData;
  var Col, Row: Integer;
  var PixelC: TAlphaColor;
  try
    Start := GetTickCount; //iniciando contagem de tempo
    FQRBitmap.Canvas.Clear(TalphaColors.White); //limpando o bitmap
    FQR.Data := FData;
    FQR.Encoding := FMX.DelphiZXIngQRCode.TQRCodeEncoding(Ord(FEncoding));
    FQR.QuietZone := FQZone;
    FQRBitmap.SetSize(FQR.Rows, FQR.Columns);
    for Row := 0 to Pred(FQR.Rows) do
      begin
        for Col := 0 to Pred(FQR.Columns) do
          begin
            if FQR.IsBlack[Row,Col] then
              PixelC := talphacolors.Black
            else
              PixelC := talphacolors.White;
            if FQRBitmap.Map(TMapAccess.Write, bitdata) then
              begin
                Try
                  bitdata.SetPixel(Col,Row, PixelC);
                Finally
                  FQRBitmap.Unmap(bitdata);
                End;
              end;
          end;
      end;

    if Assigned(FImageControl) then  //controle linkado, entao ja exibe o resultado
      begin
        var rSrc: TRectF;
        var rDest: TRectF;
        FImageControl.DisableInterpolation := true;
        FImageControl.WrapMode := TImageWrapMode.iwStretch;
        FImageControl.Bitmap.SetSize(FQRBitmap.Width, FQRBitmap.Height);

        rSrc := TRectF.Create(0, 0, FQRBitmap.Width, FQRBitmap.Height);
        rDest := TRectF.Create(0, 0, FImageControl.Bitmap.Width, FImageControl.Bitmap.Height);

        if FImageControl.Bitmap.Canvas.BeginScene then
          try
            FImageControl.Bitmap.Canvas.Clear(TAlphaColors.White);

            FImageControl.Bitmap.Canvas.DrawBitmap(FQRBitmap, rSrc, rDest, 1);
          finally
            FImageControl.Bitmap.Canvas.EndScene;
          end;
        Stop := GetTickCount;
        FTempo := (Stop-Start);
      end
    else
      begin
        FTempo := (Stop-Start);
      end;
  DoOnGenerate(FTempo, FQRBitmap);
  except on E:Exception do
    DoOnError(1,'Não foi possível criar o QRCode (' +  E.Message + ')');
  end;
end;

procedure TJSiQRCodeGenFMX.DoOnError(ErrorN: Integer; ErrorMsg: String);
begin
  if Assigned(FOnError) then
    FOnError(Self,ErrorN,ErrorMsg);
end;

procedure TJSiQRCodeGenFMX.DoOnGenerate(Tempo: Integer; const aQRCode: TBitmap);
begin
  if Assigned(FOnGenerate) then
    FOnGenerate(Self,Tempo, aQRCode);
end;

procedure TJSiQRCodeGenFMX.GenerateQRCode;
begin
  DoGenQRCode;
end;

procedure TJSiQRCodeGenFMX.setImageControl(const Value: TImage);
begin
  FImageControl := Value;
end;

end.
