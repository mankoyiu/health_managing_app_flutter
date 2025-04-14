import 'package:flutter/material.dart';
import '../models/apiitem.dart';


class DetailScreen extends StatelessWidget {
  final Item item;

  DetailScreen({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: Padding(
padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(item.thumbnailUrl, width: double.infinity, height: 200, fit: BoxFit.cover),
            SizedBox(height: 16.0),
            Text(item.title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8.0),
            Text(item.url),
          ],
        ),
      ),
    );
  }
}
