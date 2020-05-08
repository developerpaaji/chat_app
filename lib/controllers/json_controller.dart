import 'dart:convert';

class JsonController {
  static dynamic convertToJson(json) {
    return jsonDecode(jsonEncode(json));
  }
}
