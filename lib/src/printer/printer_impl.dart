import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'printer.dart';

class PrinterImpl implements Printer {
  const PrinterImpl(this._methodChannel);

  final MethodChannel _methodChannel;

  @override
  Future<bool> clearPage() =>
      _methodChannel.invokeMethod<bool>(Printer.clearPageMethod);

  @override
  Future<bool> close() =>
      _methodChannel.invokeMethod<bool>(Printer.closeMethod);

  @override
  Future<int> drawBarcode(String data, int x, int y, int barcodeType, int width,
      int height, int rotate) {
    return _methodChannel
        .invokeMethod<int>(Printer.drawBarcodeMethod, <String, dynamic>{
      'data': data,
      'x': x,
      'y': y,
      'barcodeType': barcodeType,
      'width': width,
      'height': height,
      'rotate': rotate,
    });
  }

  @override
  Future<int> drawBitmap(
      Uint8List pBmp, int xDest, int yDest, int widthDest, int heightDest) {
    return _methodChannel
        .invokeMethod<int>(Printer.drawBitmapMethod, <String, dynamic>{
      'pBmp': pBmp,
      'xDest': xDest,
      'yDest': yDest,
      'widthDest': widthDest,
      'heightDest': heightDest,
    });
  }

  @override
  Future<bool> drawLine(int x0, int y0, int x1, int y1, int lineWidth) {
    return _methodChannel
        .invokeMethod<bool>(Printer.drawLineMethod, <String, dynamic>{
      'x0': x0,
      'y0': y0,
      'x1': x1,
      'y1': y1,
      'lineWidth': lineWidth,
    });
  }

  @override
  Future<int> drawText(String data, int x, int y, String fontName, int fontSize,
      bool bold, bool italic, int rotate) {
    return _methodChannel
        .invokeMethod<int>(Printer.drawTextMethod, <String, dynamic>{
      'data': data,
      'x': x,
      'y': y,
      'fontName': fontName,
      'fontSize': fontSize,
      'bold': bold,
      'italic': italic,
      'rotate': rotate,
    });
  }

  @override
  Future<int> drawTextEx(String data, int x, int y, int width, int height,
      String fontName, int fontSize, int rotate, int style, int format) {
    return _methodChannel
        .invokeMethod<int>(Printer.drawTextExMethod, <String, dynamic>{
      'data': data,
      'x': x,
      'y': y,
      'width': width,
      'height': height,
      'fontName': fontName,
      'fontSize': fontSize,
      'rotate': rotate,
      'style': style,
      'format': format,
    });
  }

  PrinterStatus _mapIntToStatus(int status) {
    if (status == -4) {
      return PrinterStatus.busy;
    } else if (status == -256) {
      return PrinterStatus.unknownError;
    } else if (status == -257) {
      return PrinterStatus.driverError;
    } else if (status == 0) {
      return PrinterStatus.ok;
    } else if (status == -1) {
      return PrinterStatus.outOfPaper;
    } else if (status == -2) {
      return PrinterStatus.overHeat;
    } else if (status == -3) {
      return PrinterStatus.underVoltage;
    }
    // TODO: throw exception here if not of the int matches.
    return PrinterStatus.busy;
  }

  @override
  Future<PrinterStatus> get status async {
    return _mapIntToStatus(
        await _methodChannel.invokeMethod<int>(Printer.getStatusMethod));
  }

  @override
  Future<bool> open() => _methodChannel.invokeMethod<bool>(Printer.openMethod);

  @override
  Future<PrinterStatus> printPage([int rotate = 0]) async {
    assert(rotate != null);
    return _mapIntToStatus(await _methodChannel
        .invokeMethod<int>(Printer.printPageMethod, <String, dynamic>{
      'rotate': rotate,
    }));
  }

  @override
  Future<void> setGrayLevel(int level) async {
    assert(level != null);
    await _methodChannel
        .invokeMethod<void>(Printer.setGrayLevelMethod, <String, dynamic>{
      'level': level,
    });
  }

  @override
  Future<void> setSpeedLevel(int level) async {
    assert(level != null);
    await _methodChannel
        .invokeMethod<void>(Printer.setSpeedLevelMethod, <String, dynamic>{
      'level': level,
    });
  }

  @override
  Future<bool> setupPage(int width, int height) => _methodChannel
          .invokeMethod<bool>(Printer.setupPageMethod, <String, dynamic>{
        'width': width,
        'height': height,
      });
}
