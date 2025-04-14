import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/apiitem.dart';

class LocalDataService {
  Future<List<Item>> loadLocalJson() async {
    final apiUrl = Uri.https(
        'back-ddbb7-default-rtdb.asia-southeast1.firebasedatabase.app',
        'record.json');
    // final apiUrl = Uri.https(
    // 'api.jsonbin.io', // Authority (host)
    // '/v3/b/6669c731ad19ca34f87816ff/record.json', // Path
    // );
    
    final response = await http.get(apiUrl);

    final String responseBody = response.body;
    final List<dynamic> data = json.decode(responseBody);
    return data.map((json) => Item.fromJson(json)).toList();
  }
}
