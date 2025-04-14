import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io'; // Import the dart:io library
import 'package:image_picker/image_picker.dart'; // For image picking if needed
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const appTitle = "XMed";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: const HomePage(title: appTitle),
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2C3E50),
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Color.fromARGB(255, 220, 125, 30),
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({super.key, required this.title});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    PersonalInformationPage(),
    MedicationProfilePage(),
    ActivityPage(),
    DrugInformationPage(),
    AskExpertsPage(),
    TelehealthConsultationPage(),
  ];

  void _onItemTapped(int idx) {
    setState(() {
      _selectedIndex = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF2C3E50)),
              child: Text(
                'XMed',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ListTile(
              title: const Text('My Medical Summary'),
              selected: _selectedIndex == 0,
              onTap: () {
                _onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('My Medication Profile'),
              selected: _selectedIndex == 1,
              onTap: () {
                _onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('My Activity'),
              selected: _selectedIndex == 2,
              onTap: () {
                _onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Drug Information'),
              selected: _selectedIndex == 3,
              onTap: () {
                _onItemTapped(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Ask Your Experts'),
              selected: _selectedIndex == 4,
              onTap: () {
                _onItemTapped(4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Telehealth Consultation'),
              selected: _selectedIndex == 5,
              onTap: () {
                _onItemTapped(5);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}




// Personal Information Page
class PersonalInformationPage extends StatefulWidget {
  @override
  _PersonalInformationPageState createState() => _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  String _name = '';
  String _gender = '';
  int _yearOfBirth = 0;
  int _age = 0;
  String _generalHistory = '';
  String _pastMedicalHistory = '';
  String _medications = '';
  String _allergies = '';
  String _familyHistory = '';
  String _socialHistory = '';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _generalHistoryController = TextEditingController();
  final TextEditingController _pastMedicalHistoryController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _familyHistoryController = TextEditingController();
  final TextEditingController _socialHistoryController = TextEditingController();
  final TextEditingController _yearOfBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPersonalInformation();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _generalHistoryController.dispose();
    _pastMedicalHistoryController.dispose();
    _medicationsController.dispose();
    _allergiesController.dispose();
    _familyHistoryController.dispose();
    _socialHistoryController.dispose();
    _yearOfBirthController.dispose();
    super.dispose();
  }

  Future<void> _loadPersonalInformation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _gender = prefs.getString('gender') ?? '';
      _yearOfBirth = prefs.getInt('yearOfBirth') ?? 0;
      _generalHistory = prefs.getString('generalHistory') ?? '';
      _pastMedicalHistory = prefs.getString('pastMedicalHistory') ?? '';
      _medications = prefs.getString('medications') ?? '';
      _allergies = prefs.getString('allergies') ?? '';
      _familyHistory = prefs.getString('familyHistory') ?? '';
      _socialHistory = prefs.getString('socialHistory') ?? '';
      _calculateAge();
    });
    _nameController.text = _name;
    _yearOfBirthController.text = _yearOfBirth.toString();
    _generalHistoryController.text = _generalHistory;
    _pastMedicalHistoryController.text = _pastMedicalHistory;
    _medicationsController.text = _medications;
    _allergiesController.text = _allergies;
    _familyHistoryController.text = _familyHistory;
    _socialHistoryController.text = _socialHistory;
  }

  Future<void> _savePersonalInformation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('gender', _gender);
    await prefs.setInt('yearOfBirth', int.parse(_yearOfBirthController.text));
    await prefs.setString('generalHistory', _generalHistoryController.text);
    await prefs.setString('pastMedicalHistory', _pastMedicalHistoryController.text);
    await prefs.setString('medications', _medicationsController.text);
    await prefs.setString('allergies', _allergiesController.text);
    await prefs.setString('familyHistory', _familyHistoryController.text);
    await prefs.setString('socialHistory', _socialHistoryController.text);
  }

  void _calculateAge() {
    setState(() {
      _age = DateTime.now().year - _yearOfBirth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
            ],
          ),
          RadioListTile(
            title: const Text('Male'),
            value: 'male',
            groupValue: _gender,
            onChanged: (value) {
              setState(() {
                _gender = value.toString();
              });
            },
          ),
          RadioListTile(
            title: const Text('Female'),
            value: 'female',
            groupValue: _gender,
            onChanged: (value) {
              setState(() {
                _gender = value.toString();
              });
            },
          ),
          TextField(
            controller: _yearOfBirthController,
            decoration: const InputDecoration(
              labelText: 'Year of Birth',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (value) {
              setState(() {
                _yearOfBirth = int.parse(value);
                _calculateAge();
              });
            },
          ),
          const SizedBox(height: 8),
          Text('Age: $_age'),
          TextField(
            controller: _generalHistoryController,
            decoration: const InputDecoration(
              labelText: 'General History',
            ),
          ),
          TextField(
            controller: _pastMedicalHistoryController,
            decoration: const InputDecoration(
              labelText: 'Past Medical History',
            ),
          ),
          TextField(
            controller: _medicationsController,
            decoration: const InputDecoration(
              labelText: 'Medications',
            ),
          ),
          TextField(
            controller: _allergiesController,
            decoration: const InputDecoration(
              labelText: 'Allergies',
            ),
          ),
          TextField(
            controller: _familyHistoryController,
            decoration: const InputDecoration(
              labelText: 'Family History',
            ),
          ),
          TextField(
            controller: _socialHistoryController,
            decoration: const InputDecoration(
              labelText: 'Social History',
            ),
          ),
          SaveButton(onPressed: _savePersonalInformation),
        ],
      ),
    );
  }
}

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Save'),
    );
  }
}


// My Medication Profile Page
class MedicationProfilePage extends StatefulWidget {
  @override
  _MedicationProfilePageState createState() => _MedicationProfilePageState();
}

class _MedicationProfilePageState extends State<MedicationProfilePage> {
  List<Map<String, dynamic>> _medications = [
    {'name': 'Medication 1', 'dosage': '10mg', 'image': null},
    {'name': 'Medication 2', 'dosage': '20mg', 'image': null},
    // Add more medications as needed
  ];
  File? _medicationImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Medication Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text('Medication List'),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _medications.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: _medications[index]['image'] != null
                        ? Image.file(_medications[index]['image']!)
                        : Icon(Icons.medication),
                    title: Text(_medications[index]['name']),
                    subtitle: Text(_medications[index]['dosage']),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Add or update medication
              },
              child: Text('Add/Update Medication'),
            ),
          ],
        ),
      ),
    );
  }
}


// My Activity Page
class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  List<Map<String, dynamic>> _activities = [
    {'name': 'Activity 1', 'duration': '30 mins'},
    {'name': 'Activity 2', 'duration': '45 mins'},
    // Add more activities as needed
  ];
  double _exerciseRoutine = 50.0;
  double _healthMetrics = 75.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Activity'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            Text('Exercise Routine'),
            Slider(
              value: _exerciseRoutine,
              onChanged: (value) {
                setState(() {
                  _exerciseRoutine = value;
                });
              },
              min: 0.0,
              max: 100.0,
            ),
            SizedBox(height: 16.0),
            Text('Health Metrics'),
            Slider(
              value: _healthMetrics,
              onChanged: (value) {
                setState(() {
                  _healthMetrics = value;
                });
              },
              min: 0.0,
              max: 100.0,
            ),
            SizedBox(height: 16.0),
            Text('Activity List'),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _activities.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_activities[index]['name']),
                    subtitle: Text(_activities[index]['duration']),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Add or update activity
              },
              child: Text('Add/Update Activity'),
            ),
          ],
        ),
      ),
    );
  }
}


// Drug Information Page
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


// Ask Your Experts Page
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

// Telehealth Consultation Page
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

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Second Route'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Go Back!'),
        ),
      ),
    );
  }
}