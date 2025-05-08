import 'dart:convert';
import 'package:http/http.dart' as http;

class AddProductService {
  Future<bool> addProduct(List data) async {
    final url = Uri.parse(
      "https://pickerdriver.testuatah.com/v1/api/itdepartment/update-product.php",
    );

    try {
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      print(data);
      print(jsonEncode(data));

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print("✅ API Response: $responseData");
        return true;
      } else {
        print("❌ Error: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("❌ Exception: $e");
      return false;
    }
  }
}
