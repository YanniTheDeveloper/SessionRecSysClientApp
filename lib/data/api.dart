import 'package:http/http.dart' as http;
import 'dart:convert';

List<dynamic> listo = [];

class ApiProvider {
//   //List<dynamic> data = [];
  Future<dynamic> fetchData() async {
    var url = Uri.parse('https://205c-35-247-42-227.ngrok-free.app/getid');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      // print(jsonData);

      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> sendDataToServer(Map<String, dynamic> requestData) async {
    String serverUrl = 'https://205c-35-247-42-227.ngrok-free.app/event';
    try {
      String jsonData = jsonEncode(requestData);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      http.Response response = await http.post(
        Uri.parse(serverUrl),
        headers: headers,
        body: jsonData,
      );

      if (response.statusCode == 200) {
        print('Event data sent to the server successfully');
        // print('Response body: ${response.body}');
        listo = jsonDecode(response.body);

        // listo = response.map<>.

        // print("this is : ${listo}");
        return listo;

        // print(response.body);
      } else {
        // print(
        // 'Failed to send event data. Response status: ${response.statusCode}');
        // print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while sending event data: $e');
    }
  }
}
