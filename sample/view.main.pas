unit view.main;

interface

{
  Version 1.0

    - Problems with visualization of qrcode image, set DisableInterpolation := True on TImage control
    - Generated QRCode can be saved from JSiQRCodeGenFMX1.QRCode
}

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.ScrollBox,
  FMX.Memo, FMX.Objects, JSiQRCodeGenFMX, FMX.EditBox, FMX.SpinBox, FMX.ListBox,
  FMX.StdCtrls, FMX.Edit, FMX.Controls.Presentation;

type
  TviewMain = class(TForm)
    btnGen: TButton;
    edtData: TEdit;
    Label1: TLabel;
    grpConfig: TGroupBox;
    edtEncoding: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    edtQZone: TSpinBox;
    JSiQRCodeGenFMX1: TJSiQRCodeGenFMX;
    lblTime: TLabel;
    imgQRCode: TImage;
    mLog: TMemo;
    btnSave: TButton;
    SD: TSaveDialog;
    procedure JSiQRCodeGenFMX1Error(Sender: TObject; ErroN: Integer;
      ErroMsg: string);
    procedure JSiQRCodeGenFMX1Generate(Sender: TObject; Tempo: Integer;
      const aQRCode: TBitmap);
    procedure btnGenClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  viewMain: TviewMain;

implementation

{$R *.fmx}

procedure TviewMain.btnGenClick(Sender: TObject);
begin
  if trim(edtData.Text) = '' then
    begin
      ShowMessage('Enter with QRCode data');
      edtData.SetFocus;
      exit;
    end;
  btnSave.Enabled := False;
  With JSiQRCodeGenFMX1 do
    begin
      Data := Trim(edtData.Text);
      Encoding := TQRCodeEncoding(edtEncoding.Selected.Index);
      QuietZone := StrToIntDef(edtQZone.Text,4);
      GenerateQRCode;
    end;
end;

procedure TviewMain.btnSaveClick(Sender: TObject);
begin
  if not JSiQRCodeGenFMX1.QRCode.IsEmpty then
    begin
      if SD.Execute then
        begin
          JSiQRCodeGenFMX1.QRCode.SaveToFile(SD.FileName);
        end;
    end;
end;

procedure TviewMain.FormCreate(Sender: TObject);
begin
  mLog.Lines.Clear;
end;

procedure TviewMain.JSiQRCodeGenFMX1Error(Sender: TObject; ErroN: Integer;
  ErroMsg: string);
begin
  mLog.Lines.Add('An Error Occur: ' + ErroN.ToString + ' - ' + ErroMsg);
end;

procedure TviewMain.JSiQRCodeGenFMX1Generate(Sender: TObject; Tempo: Integer;
  const aQRCode: TBitmap);
begin
  mLog.Lines.Add('QRCode Generated in ' + Tempo.ToString + ' ms');
  lblTime.Text := Tempo.ToString + ' ms';
  btnSave.Enabled := True;
end;

end.
