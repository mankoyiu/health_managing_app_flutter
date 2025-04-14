import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/apiitem.dart';

class ApiService {
  final apiUrl = Uri.https(
        'back-ddbb7-default-rtdb.asia-southeast1.firebasedatabase.app',
        'record.json');

  //   final apiUrl = Uri.https(
  //   'api.jsonbin.io', // Authority (host)
  //   '/v3/b/6669c731ad19ca34f87816ff', // Path
  // );

  Future<List<Item>> fetchItems() async {
    final response = await http.get(apiUrl);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Item.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
