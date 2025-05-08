import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  Future<bool> login(String userId, String password) async {
    final url = Uri.parse(
      "https://pickerdriver.testuatah.com/v1/api/qatar/pk_dv_login.php",
    );

    final response = await http.post(
      url,
      body: jsonEncode({"emp_id": userId, "password": password, "version": ""}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data['success'] == 1) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
