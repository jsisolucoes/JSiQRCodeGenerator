unit JSiQRCodeGenVCL;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Types,
  System.UITypes,
  VCL.DelphiZXIngQRCode,
  VCL.Graphics,
  Vcl.ExtCtrls;

type
  TQRCodeEncoding = (qrAuto, qrNumeric, qrAlphanumeric, qrISO88591, qrUTF8NoBOM, qrUTF8BOM);

  TOnGenerate = procedure(Sender: TObject; Tempo: Integer; const aQRCode: TBitmap) of object;
  TOnError = procedure(Sender: TObject; ErroN: Integer; ErroMsg: String) of object;

  TJSiQCodeGenVCL = class(TComponent)
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
  RegisterComponents('JSi', [TJSiQCodeGenVCL]);
end;

{ TJSiQCodeGenVCL }

constructor TJSiQCodeGenVCL.Create(aOwner: TComponent);
begin
  inherited Create(aOwner);
  FQR := TDelphiZXingQRCode.Create;
  FQRBitmap := TBitmap.Create;
end;

destructor TJSiQCodeGenVCL.Destroy;
begin
  FQRBitmap.Free;
  FQR.Free;
  inherited Destroy;
end;

procedure TJSiQCodeGenVCL.DoGenQRCode;
begin
  FTempo := 0;
  var Start: Integer;
  var Stop: Integer := 0;
  var Col, Row: Integer;
  try
    Start := TThread.GetTickCount; //iniciando contagem de tempo
    FQRBitmap.Canvas.Brush.Color := clWhite;
    FQR.Data := FData;
    FQR.Encoding := VCL.DelphiZXIngQRCode.TQRCodeEncoding(Ord(FEncoding));
    FQR.QuietZone := FQZone;
    FQRBitmap.SetSize(FQR.Rows, FQR.Columns);
    for Row := 0 to Pred(FQR.Rows) do
      begin
        for Col := 0 to Pred(FQR.Columns) do
          begin
            if FQR.IsBlack[Row,Col] then
              FQRBitmap.Canvas.Pixels[Col,Row] := clBlack
            else
              FQRBitmap.Canvas.Pixels[Col,Row] := clWhite;
          end;
      end;

    if Assigned(FImageControl) then  //controle linkado, entao ja exibe o resultado
      begin
//        var scale: Double;
//        FImageControl.Canvas.Brush.Color := clWhite;
//        FImageControl.Canvas.FillRect(Rect(0,0,FImageControl.Width,FImageControl.Height));
//
//        if FImageControl.Width < FImageControl.Height then
//          begin
//            scale := FImageControl.Width / FImageControl.Height;
//          end
//        else
//            scale := FImageControl.Height / FImageControl.Width;
//        FImageControl.Canvas.StretchDraw(rect(0,0, Trunc(Scale * QRCode.Width), trunc(Scale * QRCode.Height)), QrCode);
        FImageControl.Picture.Bitmap.Assign(QRCode);
        FImageControl.Stretch := True;
        FImageControl.Center := True;
        Stop := TThread.GetTickCount;
        FTempo := (Stop-Start);
      end
    else
      begin
        Stop := TThread.GetTickCount;
        FTempo := (Stop-Start);
      end;
  DoOnGenerate(FTempo, FQRBitmap);
  except on E:Exception do
    DoOnError(1,'Não foi possível criar o QRCode (' +  E.Message + ')');
  end;
end;

procedure TJSiQCodeGenVCL.DoOnError(ErrorN: Integer; ErrorMsg: String);
begin
  if Assigned(FOnError) then
    FOnError(Self,ErrorN,ErrorMsg);
end;

procedure TJSiQCodeGenVCL.DoOnGenerate(Tempo: Integer; const aQRCode: TBitmap);
begin
  if Assigned(FOnGenerate) then
    FOnGenerate(Self,Tempo, aQRCode);
end;

procedure TJSiQCodeGenVCL.GenerateQRCode;
begin
  DoGenQRCode;
end;

procedure TJSiQCodeGenVCL.setImageControl(const Value: TImage);
begin
  FImageControl := Value;
end;

end.
