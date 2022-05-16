TJSiQRCodeGenFMX
=================

TJSiQRCodeGenFMX is a non visual component for Firemonkey based on DelphiZXingQRCode;

You can Generate a TBitmap with QRCode or link the result on an TImage;

# Structure #
TJSiQRCodeGenFMX;
  -Properties;
    -Data {Text type information to compose the QRCode};
    -Encoding {Encoding for Data};
    -QuietZone;
    -Tempo {time for each QRCode build on ms};
    -QRCode {TBitmap with QRCode generated};
    -Name {Component name};
    -ImageControl {Link to TImage control};
  -Events;
    -OnGenerate {Returns Time and QRCode Bitmap};
    -OnError { Returns Error Number and Error Message};
  -Methods;
    -GenerateQRCode { Do generate the QRCode };

# Getting Started #

A sample Delphi FMX project is provided in the Sample folder to demonstrate how to use TJSiQRCodeGenFMX. 


[Provided by jsisolucoes]
