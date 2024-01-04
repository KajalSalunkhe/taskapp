import 'dart:convert';

import 'package:http/http.dart' as http;

class DogApiService {
  Future<String> fetchRandomDogImage() async {
    final response =
        await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['message'];
    } else {
      throw Exception('Failed to load image');
    }
  }
}
