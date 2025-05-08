import 'package:flutter/material.dart';
import 'package:it_department/presentation/screens/products/product_details.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<BarcodeScanner> {
  Barcode? _barcode;

  bool _hasNavigated = false; // Declare this in your State class

  Widget _barcodePreview(BuildContext context, Barcode? value) {
    if (value != null && !_hasNavigated) {
      _hasNavigated = true; // Prevent multiple navigations

      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetails(value.displayValue),
          ),
        );
      });
    }

    return Text(
      value?.displayValue ?? 'Scan something!',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      setState(() {
        _barcode = barcodes.barcodes.firstOrNull;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(onDetect: _handleBarcode),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Center(child: _barcodePreview(context, _barcode)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
