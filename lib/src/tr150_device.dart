import 'package:flutter/services.dart';
import 'printer/printer.dart';
import 'printer/printer_impl.dart';
import 'scanner/scanner.dart';
import 'scanner/scanner_impl.dart';

class Tr150Device {
  Tr150Device._()
      : _channel = const MethodChannel('tr150'),
        // TODO: might listen to multiple event channels
        _eventChannel = const EventChannel('tr150_event') {
    _printer = PrinterImpl(_channel);
    _scanner = ScannerImpl(_channel, _eventChannel);
  }

  static final Tr150Device instance = Tr150Device._();

  final MethodChannel _channel;
  final EventChannel _eventChannel;

  Printer _printer;

  Printer get printer => _printer;

  Scanner _scanner;

  Scanner get scanner => _scanner;
}
