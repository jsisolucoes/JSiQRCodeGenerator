unit view.main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ExtDlgs,
  JSiQRCodeGenVCL, Vcl.Samples.Spin, Vcl.StdCtrls;

type
  TviewMain = class(TForm)
    imgQR: TImage;
    Button1: TButton;
    edtDATA: TEdit;
    mLog: TMemo;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtEncoding: TComboBox;
    edtQZ: TSpinEdit;
    btnSave: TButton;
    Label3: TLabel;
    lblTime: TLabel;
    JSiQCodeGenVCL1: TJSiQCodeGenVCL;
    SD: TSavePictureDialog;
    procedure Button1Click(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure JSiQCodeGenVCL1Generate(Sender: TObject; Tempo: Integer;
      const aQRCode: TBitmap);
    procedure JSiQCodeGenVCL1Error(Sender: TObject; ErroN: Integer;
      ErroMsg: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  viewMain: TviewMain;

implementation

{$R *.dfm}

procedure TviewMain.btnSaveClick(Sender: TObject);
begin
  if not JSiQCodeGenVCL1.QRCode.Empty then
    begin
      if SD.Execute then
        begin
          JSiQCodeGenVCL1.QRCode.SaveToFile(SD.FileName);
        end;
    end;
end;

procedure TviewMain.Button1Click(Sender: TObject);
begin
  if trim(edtData.Text) = '' then
    begin
      ShowMessage('Enter with QRCode data');
      edtData.SetFocus;
      exit;
    end;
  btnSave.Enabled := False;
  With JSiQCodeGenVCL1 do
    begin
      Data := Trim(edtData.Text);
      Encoding := TQRCodeEncoding(edtEncoding.ItemIndex);
      QuietZone := StrToIntDef(edtQZ.Text,4);
      GenerateQRCode;
    end;
end;

procedure TviewMain.FormCreate(Sender: TObject);
begin
  mLog.Lines.Clear;
end;

procedure TviewMain.JSiQCodeGenVCL1Error(Sender: TObject; ErroN: Integer;
  ErroMsg: string);
begin
  mLog.Lines.Add('An Error Occur: ' + ErroN.ToString + ' - ' + ErroMsg);
end;

procedure TviewMain.JSiQCodeGenVCL1Generate(Sender: TObject; Tempo: Integer;
  const aQRCode: TBitmap);
begin
  mLog.Lines.Add('QRCode Generated in ' + Tempo.ToString + ' ms');
  lblTime.Caption := Tempo.ToString + ' ms';
  btnSave.Enabled := True;
end;

end.
