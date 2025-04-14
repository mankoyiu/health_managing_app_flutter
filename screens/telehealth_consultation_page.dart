import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TelehealthConsultationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telehealth Consultation'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to Zoom app
            launchUrl(Uri.parse('https://zoom.us/'));
          },
          child: Text('Go to Zoom'),
        ),
      ),
    );
  }
} 