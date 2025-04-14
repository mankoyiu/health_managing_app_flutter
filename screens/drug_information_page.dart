import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DrugInformationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drug Information'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to WebMD website
            launchUrl(Uri.parse('https://www.webmd.com/drugs'));
          },
          child: Text('Go to WebMD'),
        ),
      ),
    );
  }
} 