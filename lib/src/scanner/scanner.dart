abstract class Scanner {
  static const String startDecodeMethod = 'startDecode';
  static const String stopDecodeMethod = 'stopDecode';
  static const String scannerStateMethod = 'getScannerState';
  static const String openMethod = 'openScanner';
  static const String closeMethod = 'closeScanner';

  /// Turn on the power for the bar code reader.
  ///
  /// returns false if failed. true if success.
  Future<bool> open();

  /// Turn off the power for the bar code reader.
  ///
  /// returns false if failed. true if success.
  Future<bool> close();

  /// get the scanner power states
  ///
  /// true if the scanner is power on.
  Future<bool> get isPowerOn;

  /// Call this method to start decoding.
  ///
  /// returns true if the scanner and the trigger is already active
  Future<bool> startDecode();

  /// This stops any data acquisition currently in progress.
  ///
  /// returns true if it stopped successfully
  Future<bool> stopDecode();

  /// A Stream to listen for scanned/decoded barcode events.
  ///
  /// returns String if the scanner detects some barcode.
  Stream<String> get onScannerDecode;
}
