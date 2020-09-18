import 'package:flutter/services.dart';

import 'scanner.dart';

class ScannerImpl implements Scanner {
  const ScannerImpl(this._methodChannel, this._eventChannel);

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;

  @override
  Future<bool> close() =>
      _methodChannel.invokeMethod<bool>(Scanner.closeMethod);

  @override
  Future<bool> get isPowerOn =>
      _methodChannel.invokeMethod<bool>(Scanner.scannerStateMethod);

  @override
  Stream<String> get onScannerDecode =>
      _eventChannel.receiveBroadcastStream().map((event) => event as String);

  @override
  Future<bool> open() => _methodChannel.invokeMethod<bool>(Scanner.openMethod);

  @override
  Future<bool> startDecode() =>
      _methodChannel.invokeMethod<bool>(Scanner.startDecodeMethod);

  @override
  Future<bool> stopDecode() =>
      _methodChannel.invokeMethod<bool>(Scanner.stopDecodeMethod);
}
