import 'package:flutter/material.dart';
import 'dart:io';

class AskExpertsPage extends StatefulWidget {
  @override
  _AskExpertsPageState createState() => _AskExpertsPageState();
}

class _AskExpertsPageState extends State<AskExpertsPage> {
  String _enquiry = '';
  String _expert = 'Expert 1'; // Set a default value
  String _contactNo = '';
  File? _attachment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ask Your Experts'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Enquiry',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _enquiry = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Expert',
                border: OutlineInputBorder(),
              ),
              value: _expert,
              onChanged: (value) {
                setState(() {
                  _expert = value!;
                });
              },
              items: ['Expert 1', 'Expert 2', 'Expert 3']
                  .map((e) => DropdownMenuItem<String>(
                        value: e,
                        child: Text(e),
                      ))
                  .toList(),
            ),
            SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Contact Number',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _contactNo = value;
                });
              },
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save the enquiry to the database
                print('Enquiry: $_enquiry');
                print('Expert: $_expert');
                print('Contact Number: $_contactNo');
                if (_attachment != null) {
                  print('Attachment: $_attachment');
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
} 