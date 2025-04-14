import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../models/apiitem.dart';
import 'package:http/http.dart' as http;

class ItemListTile extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  ItemListTile({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _loadImage(item.thumbnailUrl),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListTile(
            leading: Image.memory(
              snapshot.data!,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(item.title),
            subtitle: Text(item.url),
            onTap: onTap,
          );
        } else if (snapshot.hasError) {
          return ListTile(
            leading: Icon(Icons.error),
            title: Text(item.title),
            subtitle: Text(item.url),
            onTap: onTap,
          );
        } else {
          return ListTile(
            leading: CircularProgressIndicator(),
            title: Text(item.title),
            subtitle: Text(item.url),
          );
        }
      },
    );
  }

  Future<Uint8List> _loadImage(String url) async {
    final response = await http.get(
      Uri.parse(url),
      headers: {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3'},
    );
    return response.bodyBytes;
  }
}