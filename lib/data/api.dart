import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiProvider {
//   //List<dynamic> data = [];

Future<dynamic> fetchData() async {
  var url = Uri.parse('http://backendsession.onrender.com/home');
  var response = await http.get(url);

  if (response.statusCode == 200) {
    var jsonData = jsonDecode(response.body);
    // print(jsonData);

    return jsonData;
  } else {
    throw Exception('Failed to load data');
  }
}
}


