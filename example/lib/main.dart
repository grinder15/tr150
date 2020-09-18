import 'package:flutter/material.dart';
import 'package:tr150/tr150.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scannedBarcode = 'None';
  Tr150Device _device = Tr150Device.instance;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _device.scanner.onScannerDecode.listen((barcode) {
        setState(() {
          _scannedBarcode = barcode != null ? barcode : 'None';
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            IconButton(
              icon: Icon(Icons.print),
              onPressed: _printDemo,
            ),
          ],
        ),
        body: Center(
          child: Text('Scanned Barcode: $_scannedBarcode'),
        ),
      ),
    );
  }

  Future<void> _printDemo() async {
    final printer = _device.printer;
    int height = 66;
    await printer.setupPage(384, 780);

    await printer.drawText(
        "Jerome Arenas", 5, 50, Printer.defaultFont, 48, false, false, 0);
    height += 48;

    await printer.drawText("ABCDEFGHLIJKMNOPQXYZTRSW", 0, height,
        Printer.defaultFont, 36, false, false, 0);
    height += 40;

    await printer.drawText("ABCDEFGHLIJKMNOPQXYZTRSWGHLIJKMNOPQX", 0, height,
        Printer.defaultFont, 24, false, false, 0);
    height += 28;

    await printer.drawText("abcdefghlijkmnopqxyztrsw", 0, height,
        Printer.defaultFont, 36, false, false, 0);
    height += 40;

    await printer.drawText("abcdefghlijkmnopqxyztrswefghlijkmn", 0, height,
        Printer.defaultFont, 24, false, false, 0);
    height += 28;

    await printer.drawText(
        "囎囏囐囑囒囓囔囕囖墼囏", 0, height, Printer.defaultFont, 36, false, false, 0);
    height += 42;

    await printer.drawText("囎囏囐囑囒囓囔囕囖墼墽墾孽囎囏囓囔", 0, height, Printer.defaultFont,
        24, false, false, 0);
    height += 28;

    await printer.drawText("HHHHHHHHHHHHHHHHHHHHHHHH", 0, height,
        Printer.defaultFont, 36, false, false, 0);
    height += 40;

    await printer.drawText("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH", 0, height,
        Printer.defaultFont, 24, false, false, 0);
    height += 32;

    await printer.drawText(
        "☆★○●▲△▼☆★○●▲☆★○", 0, height, Printer.defaultFont, 36, false, false, 0);
    height += 40;

    await printer.drawText(
        "ぱばびぶづぢだざじずぜぞ", 0, height, Printer.defaultFont, 36, false, false, 0);
    height += 48;

    await printer.drawText(
        "㊣㈱卍▁▂▃▌▍▎▏※※㈱㊣", 0, height, Printer.defaultFont, 36, false, false, 0);
    height += 50;

    await printer.drawBarcode(
        "12345678ABCDEF", 32, height, BarcodeType.code128, 2, 70, 0);

    await printer.printPage();
  }
}
