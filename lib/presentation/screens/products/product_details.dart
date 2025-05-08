import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:it_department/logic/product_add/product_add.dart';
import 'dart:convert';
import 'package:it_department/presentation/screens/home/home_screen.dart';
import 'package:toastification/toastification.dart';

class ProductDetails extends StatefulWidget {
  final String? barcode;

  const ProductDetails(this.barcode, {super.key});

  @override
  State<ProductDetails> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProductDetails> {
  List<dynamic> items = [];
  String errorMessage = '';
  List<TextEditingController> _uomWeightControllers = [];
  List<String> list = <String>['OUT', 'CTN', 'PCS'];

  List<String> dropdownValues = [];

  void _homeNavigate(BuildContext context) {
    setState(() {
      items = [];
      errorMessage = '';
    });
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeScreen(),
      ), // or BarcodeScanner()
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  // String testBarCode = "6253015500063";

  void _showSuccess(bool isSuccess) {
    toastification.show(
      context: context,
      title: Text(
        isSuccess ? "Product added successfully" : "Prodcuct not added",
      ),
      description: Text(
        isSuccess
            ? "Your product added successfully"
            : "Failed! Please try again",
      ),
      type: isSuccess ? ToastificationType.success : ToastificationType.error,
      style: ToastificationStyle.fillColored,
      autoCloseDuration: const Duration(seconds: 3),
      alignment: Alignment.topCenter,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProductData();
  }

  void handleSubmit() async {
    List<Map<String, dynamic>> uomData = [];

    for (int i = 0; i < items.length; i++) {
      final int id = items[i]['id'];
      final String uom = dropdownValues[i];
      String uomWeight = _uomWeightControllers[i].text.trim();

      // Add '.00' if there's no decimal point
      if (!uomWeight.contains('.')) {
        uomWeight += '.00';
      }

      uomData.add({'id': id, 'package_uom': uom, 'uom_weight': uomWeight});

      // Update local state
      items[i]['uom'] = uom;
      items[i]['uom_weight'] = uomWeight;
    }

    print(uomData);

    try {
      final service = AddProductService();
      final response = await service.addProduct(uomData);
      print(response);
      if (response == true) {
        _showSuccess(true);
        _homeNavigate(context);
      } else {
        _showSuccess(false);
      }
    } catch (e) {
      _showSuccess(false);
    }
  }

  Future<void> fetchProductData() async {
    if (widget.barcode == null) {
      setState(() {
        errorMessage = "No barcode provided.";
      });
      return;
    }

    final uri = Uri.parse(
      "https://pickerdriver.testuatah.com/v1/api/itdepartment/scan-sku.php?sku=${widget.barcode}",
    );

    // final uri = Uri.parse(
    //   "https://pickerdriver.testuatah.com/v1/api/itdepartment/scan-sku.php?sku=${testBarCode}",
    // );

    try {
      final response = await http.get(uri);

      print(response.body);

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      // Try decoding safely
      dynamic decodedData;
      try {
        decodedData = jsonDecode(response.body);
      } catch (e) {
        setState(() {
          errorMessage = "Invalid JSON format: ${response.body}";
        });
        return;
      }

      if (response.statusCode == 200) {
        if (decodedData is Map && decodedData.containsKey('items')) {
          final List<dynamic> fetchedItems = decodedData['items'];
          setState(() {
            items = fetchedItems;
            errorMessage = '';

            _uomWeightControllers = List.generate(
              fetchedItems.length,
              (index) => TextEditingController(
                text: fetchedItems[index]['uom_weight'] ?? '',
              ),
            );

            dropdownValues = List.generate(fetchedItems.length, (index) {
              final apiUom = fetchedItems[index]['uom'];
              if (!list.contains(apiUom)) {
                list.add(apiUom);
              }
              return apiUom ?? list[0];
            });
          });
        } else if (decodedData is Map && decodedData.containsKey('message')) {
          setState(() {
            errorMessage = decodedData['message']; // SKU not found
            items = [];
          });
        } else {
          setState(() {
            errorMessage = "Unexpected response format.";
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to fetch data. Status: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Network or decoding error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text("Product Information"),
          backgroundColor: Color(0x80DDEB9D),
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (items.isEmpty && errorMessage.isEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: CircularProgressIndicator(color: Colors.blueGrey),
                  ),
                )
              else if (errorMessage.isNotEmpty)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      dynamic item = items[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                        child: Card(
                          color: Colors.white70,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "${item['description']}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text("Item No: ${item['item_no']}"),
                                Text("Barcode: ${item['barcodes']}"),
                                // Text("UOM: ${item['uom']}"),
                                SizedBox(height: 15),

                                DropdownButtonFormField<String>(
                                  value: dropdownValues[index],
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropdownValues[index] = newValue!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: "Select the Item UOM",
                                    border: OutlineInputBorder(),
                                  ),
                                  items:
                                      list.map<DropdownMenuItem<String>>((
                                        String value,
                                      ) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                ),

                                SizedBox(height: 20),

                                TextField(
                                  controller: _uomWeightControllers[index],
                                  decoration: const InputDecoration(
                                    labelText: 'UOM Weight',
                                    border: OutlineInputBorder(),
                                  ),
                                  keyboardType: TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                                ),

                                SizedBox(height: 30),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: ElevatedButton(
                  onPressed: () {
                    handleSubmit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Submit All",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // Button at bottom
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () {
                    _homeNavigate(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    "Scan More",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
