import 'package:flutter/material.dart';
import 'package:it_department/presentation/screens/scanner/barcode_scanner.dart';
import 'package:it_department/presentation/widgets/popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Hides the back button
        centerTitle: true,
        title: Text("Home"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(elevation: 0),
              child: Icon(Icons.logout_sharp),
              onPressed: () => {},
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/barcode_scan.png", height: 150),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "Tap To Scan For Add Barcodes",
                        style: TextStyle(
                          fontFamily: "Roboto",
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 50,
                right: 50,
                child: FloatingActionButton(
                  onPressed:
                      () => {
                        showDialog(
                          context: context,
                          builder: (context) => Popup(),
                        ),
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BarcodeScanner(),
                        //   ),
                        // ),
                      },
                  child: Image.asset(
                    "assets/images/barcode_scan.png",
                    height: 30,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
