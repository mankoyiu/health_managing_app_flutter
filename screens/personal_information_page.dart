import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

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
  List<String> _selectedConditions = [];
  List<String> _selectedAllergies = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _generalHistoryController = TextEditingController();
  final TextEditingController _pastMedicalHistoryController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _familyHistoryController = TextEditingController();
  final TextEditingController _socialHistoryController = TextEditingController();
  final TextEditingController _yearOfBirthController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final List<String> _commonConditions = [
    'Diabetes',
    'Hypertension',
    'Asthma',
    'Arthritis',
    'Heart Disease',
    'Depression',
    'Anxiety',
    'High Cholesterol',
    'Thyroid Disorder',
    'Migraine'
  ];

  final List<String> _commonAllergies = [
    'Penicillin',
    'Aspirin',
    'Ibuprofen',
    'Latex',
    'Peanuts',
    'Shellfish',
    'Eggs',
    'Dairy',
    'Pollen',
    'Dust Mites'
  ];

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
    setState(() {
      _isLoading = true;
    });

    try {
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
        _selectedConditions = prefs.getStringList('conditions') ?? [];
        _selectedAllergies = prefs.getStringList('selectedAllergies') ?? [];
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _savePersonalInformation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save all data
      await Future.wait([
        prefs.setString('name', _nameController.text.trim()),
        prefs.setString('gender', _gender),
        prefs.setInt('yearOfBirth', int.parse(_yearOfBirthController.text)),
        prefs.setString('generalHistory', _generalHistoryController.text.trim()),
        prefs.setString('pastMedicalHistory', _pastMedicalHistoryController.text.trim()),
        prefs.setString('medications', _medicationsController.text.trim()),
        prefs.setString('allergies', _allergiesController.text.trim()),
        prefs.setString('familyHistory', _familyHistoryController.text.trim()),
        prefs.setString('socialHistory', _socialHistoryController.text.trim()),
        prefs.setStringList('conditions', _selectedConditions),
        prefs.setStringList('selectedAllergies', _selectedAllergies),
      ]);

      // Verify data was saved correctly
      final savedName = prefs.getString('name');
      if (savedName != _nameController.text.trim()) {
        throw Exception('Data verification failed');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Information saved successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _calculateAge() {
    if (_yearOfBirth > 0) {
      setState(() {
        _age = DateTime.now().year - _yearOfBirth;
      });
    }
  }

  Widget _buildSection(String title, Widget content) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection(
                    'Basic Information',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                            hintText: 'Enter your full name',
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Gender',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: RadioListTile(
                                title: const Text('Male'),
                                value: 'male',
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value.toString();
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: RadioListTile(
                                title: const Text('Female'),
                                value: 'female',
                                groupValue: _gender,
                                onChanged: (value) {
                                  setState(() {
                                    _gender = value.toString();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _yearOfBirthController,
                          decoration: const InputDecoration(
                            labelText: 'Year of Birth',
                            border: OutlineInputBorder(),
                            hintText: 'YYYY',
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your year of birth';
                            }
                            if (value.length != 4) {
                              return 'Please enter a valid year (YYYY)';
                            }
                            final year = int.tryParse(value);
                            if (year == null || year < 1900 || year > DateTime.now().year) {
                              return 'Please enter a valid year';
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          onChanged: (value) {
                            if (value.length == 4) {
                              setState(() {
                                _yearOfBirth = int.parse(value);
                                _calculateAge();
                              });
                            }
                          },
                        ),
                        if (_age > 0) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Age: $_age years',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ],
                    ),
                  ),

                  _buildSection(
                    'Medical Conditions',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select any conditions you have:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _commonConditions.map((condition) {
                            return FilterChip(
                              label: Text(condition),
                              selected: _selectedConditions.contains(condition),
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedConditions.add(condition);
                                  } else {
                                    _selectedConditions.remove(condition);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _generalHistoryController,
                          decoration: const InputDecoration(
                            labelText: 'Additional Medical History',
                            border: OutlineInputBorder(),
                            hintText: 'Enter any other medical conditions or history',
                          ),
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),

                  _buildSection(
                    'Allergies',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select any allergies you have:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: _commonAllergies.map((allergy) {
                            return FilterChip(
                              label: Text(allergy),
                              selected: _selectedAllergies.contains(allergy),
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    _selectedAllergies.add(allergy);
                                  } else {
                                    _selectedAllergies.remove(allergy);
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _allergiesController,
                          decoration: const InputDecoration(
                            labelText: 'Additional Allergies',
                            border: OutlineInputBorder(),
                            hintText: 'Enter any other allergies',
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),

                  _buildSection(
                    'Medications',
                    TextFormField(
                      controller: _medicationsController,
                      decoration: const InputDecoration(
                        labelText: 'Current Medications',
                        border: OutlineInputBorder(),
                        hintText: 'List all current medications and dosages',
                      ),
                      maxLines: 3,
                    ),
                  ),

                  _buildSection(
                    'Family History',
                    TextFormField(
                      controller: _familyHistoryController,
                      decoration: const InputDecoration(
                        labelText: 'Family Medical History',
                        border: OutlineInputBorder(),
                        hintText: 'Enter any significant family medical history',
                      ),
                      maxLines: 3,
                    ),
                  ),

                  _buildSection(
                    'Social History',
                    TextFormField(
                      controller: _socialHistoryController,
                      decoration: const InputDecoration(
                        labelText: 'Social History',
                        border: OutlineInputBorder(),
                        hintText: 'Enter information about lifestyle, occupation, etc.',
                      ),
                      maxLines: 3,
                    ),
                  ),

                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _savePersonalInformation,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                      child: const Text('Save Information'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
  }
} 