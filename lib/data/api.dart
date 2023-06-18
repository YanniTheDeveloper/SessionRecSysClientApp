import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiProvider {
//   //List<dynamic> data = [];

  Future<dynamic> fetchData() async {
    var url = Uri.parse('http://backendsession.onrender.com/getid');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      // print(jsonData);

      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> postData(Map<String, dynamic> selectedEvent) async {
  var url = Uri.parse('http://backendsession.onrender.com/event');

  // var headers = <String, String>{
  //   'Content-Type': 'application/json',
  // };

  var response = await http.post(url, body: selectedEvent);

  if (response.statusCode == 200) {
    print('POST request successful');
    print(response.body);
  } else {
    print('POST request failed');
  }
}
}


