import 'dart:typed_data';

abstract class Printer {
  static const String openMethod = 'openPrinter';
  static const String closeMethod = 'closePrinter';
  static const String setSpeedLevelMethod = 'setSpeedLevel';
  static const String setGrayLevelMethod = 'setGrayLevel';
  static const String setupPageMethod = 'setupPage';
  static const String clearPageMethod = 'clearPage';
  static const String printPageMethod = 'printPage';
  static const String drawLineMethod = 'drawLine';
  static const String drawTextMethod = 'drawText';
  static const String drawTextExMethod = 'drawTextEx';
  static const String drawBarcodeMethod = 'drawBarcode';
  static const String drawBitmapMethod = 'drawBitmap';
  static const String getStatusMethod = 'getStatus';

  static const String defaultFont = 'simsun';

  /// Open the printer
  ///
  /// returns true if open successful, otherwise, false
  Future<bool> open();

  /// Close the printer
  ///
  /// returns true if close successful, otherwise, false
  Future<bool> close();

  /// Set print speed level
  ///
  /// params:
  ///
  /// level - a value that ranges 50 to 80, defaults to 62
  Future<void> setSpeedLevel(int level);

  /// Set print gray level
  ///
  /// params:
  ///
  /// level - a value that ranges 0 to 4, defaults to 0
  Future<void> setGrayLevel(int level);

  /// Set the page size. Unit is in pixel. 8 pixels is equivalent to 1 mm.
  ///
  /// params:
  ///
  /// width - Page width, -1 means largest possible width (width = 384)
  ///
  /// height - Page height, -1 means printer driver to manage the page height.
  ///
  /// returns true when success, otherwise false.
  Future<bool> setupPage(int width, int height);

  /// Clear the current page.
  ///
  /// returns true if successful, otherwise false.
  Future<bool> clearPage();

  /// Print the current page.
  ///
  /// params:
  ///
  /// rotate - The rotation angle, currently supports only 0 (non-rotating)
  ///
  /// returns print status
  Future<PrinterStatus> printPage([int rotate = 0]);

  /// Draw a line in the current page.
  /// (0, 0) point axis: Oon the upper left corner of the screen
  ///
  /// params:
  ///
  /// x0 - start point X axis
  ///
  /// y0 - start point Y axis
  ///
  /// x1 - end point X axis
  ///
  /// y1 - end point Y axis
  ///
  /// lineWidth - in pixel
  ///
  /// returns true if successful, otherwise false
  Future<bool> drawLine(int x0, int y0, int x1, int y1, int lineWidth);

  /// Draw text on the current page
  ///
  /// params:
  /// data - The string to be draw
  ///
  /// x - Start point X axis
  ///
  /// y - Start point Y axis
  ///
  /// fontName - Font to be used, otherwise, default system font is used.
  /// Custom fonts can be specified, for example, specifying the full path
  /// mnt/sdcard/xxx.ttf.
  ///
  /// fontSize - The font size, in pixel
  ///
  /// bold - The font bold style
  ///
  /// italic - The font italic style
  ///
  /// rotate - The text direction. 0 no rotation, 1 rotate 90 degrees, 2 rotate
  /// 180 degrees, 3 rotate 270 degrees.
  ///
  /// If successful, returns actual printing height. Returns -1 when failed.
  Future<int> drawText(String data, int x, int y, String fontName, int fontSize,
      bool bold, bool italic, int rotate);

  /// Draw text on the current page
  ///
  /// params:
  ///
  /// data - The string to be draw
  ///
  /// x - Start point X axis
  ///
  /// y - Start point Y axis
  ///
  /// width - Text is printed to the width of the rectangle on the page
  ///
  /// height - Text is printed to the height of the rectangle on the page
  ///
  /// fontName - Font to be used, otherwise, default system font is used.
  /// Custom fonts can be specified, for example, specifying the full path
  /// /mnt/sdcard/xxx.ttf.
  ///
  /// fontSize - The font size, in pixel
  ///
  /// rotate - The text direction. 0 no rotation, 1 rotate 90 degrees, 2 rotate
  /// 180 degrees, 3 rotate 270 degrees.
  ///
  /// style - Font style (0x0001 - underline, 0x0002 - italic,
  /// 0x0004 - bold, 0x0008 - reverse effect, 0x0010 - strike out), you can mix
  /// the style by using the OR operator, style= 0x0002|0x0004
  ///
  /// format - Set to 0 means word wrap at the specified width range 0-384,
  /// Set to 1 means no word wrap
  ///
  /// Returns actual printing height if successful. Returns -1 if failed.
  Future<int> drawTextEx(String data, int x, int y, int width, int height,
      String fontName, int fontSize, int rotate, int style, int format);

  /// Draw barcode on the current page
  ///
  /// params:
  ///
  /// data - The barcode text
  ///
  /// x - Start point at X axis
  ///
  /// y - Start point at Y axis
  ///
  /// barcodeType - Symbology
  ///
  /// width - There are four thickness level to the lines, 1 being the thinnest
  /// and 4 being the thickest.
  ///
  /// height - The barcode height in pixel
  ///
  /// rotate - The barcode rotation, 0 no rotation, 1 rotate 90 degree, 2 rotate
  /// 180 degree, 3 rotate 270 degree.
  ///
  /// Returns actual printing height if successful. Returns -1 when failed.
  Future<int> drawBarcode(String data, int x, int y, int barcodeType, int width,
      int height, int rotate);

  /// Draw a mono-bitmaps on the current page
  ///
  /// params:
  ///
  /// pBmp - ByteArray data for mono-bitmaps
  ///
  /// xDest - Start point at X axis
  ///
  /// yDest - Start point at Y axis
  ///
  /// widthDest - horizontal width bytes
  ///
  /// heightDest - vertical height point
  ///
  /// Returns actual printing height if successful. Returns -1 if failed.
  Future<int> drawBitmap(
      Uint8List pBmp, int xDest, int yDest, int widthDest, int heightDest);

  /// Gets the current state of the printer
  ///
  /// Returns the printer status.
  Future<PrinterStatus> get status;
}

enum PrinterStatus {
  busy,
  unknownError,
  driverError,
  ok,
  outOfPaper,
  overHeat,
  underVoltage,
}

class PrinterFontStyle {
  const PrinterFontStyle._();

  static const int underline = 0x0001;
  static const int italic = 0x0002;
  static const int bold = 0x0004;
  static const int reverseEffect = 0x0008;
  static const int strikeOut = 0x0010;
}

class BarcodeType {
  const BarcodeType._();

  static const int code11 = 1;
  static const int c25Matrix = 2;
  static const int c25Inter = 3;
  static const int c25Iata = 4;
  static const int c25logic = 6;
  static const int c25ind = 7;
  static const int code39 = 8;
  static const int exCode39 = 9;
  static const int eanx = 13;
  static const int ean128 = 16;
  static const int codaBar = 18;
  static const int code128 = 20;
  static const int dpleit = 21;
  static const int dpident = 22;
  static const int code16K = 23;
  static const int code49 = 24;
  static const int code93 = 25;
  static const int flat = 28;
  static const int rss14 = 29;
  static const int rssLTD = 30;
  static const int rssEXP = 31;
  static const int telepen = 32;
  static const int upca = 34;
  static const int upce = 37;
  static const int postnet = 40;
  static const int msiPlessey = 47;
  static const int fim = 49;
  static const int logmars = 50;
  static const int pharma = 51;
  static const int pzn = 52;
  static const int pharmaTwo = 53;
  static const int pdf417 = 55;
  static const int pdf417Trunc = 56;
  static const int maxicode = 57;
  static const int qrcode = 58;
  static const int code128B = 60;
  static const int auspost = 63;
  static const int ausreply = 66;
  static const int ausroute = 67;
  static const int ausredirect = 68;
  static const int isbnx = 69;
  static const int rm4scc = 70;
  static const int datamatrix = 71;
  static const int ean14 = 72;
  static const int codaBlockf = 74;
  static const int nve18 = 75;
  static const int japanPost = 76;
  static const int koreanPost = 77;
  static const int rss14Stack = 79;
  static const int rss14StackOmni = 80;
  static const int rssExpstack = 81;
  static const int planet = 82;
  static const int microPDF417 = 84;
  static const int oneCode = 85;
  static const int plessey = 86;
  static const int aztec = 92;
}
