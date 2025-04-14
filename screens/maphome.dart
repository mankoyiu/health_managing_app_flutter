import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/mapwidget.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';

class MapHomeScreen extends StatefulWidget {
  @override
  _MapHomeScreenState createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> with SingleTickerProviderStateMixin {
  LatLng? _currentLocation;
  bool _isRecording = false;
  List<ActivityRecord> _walkingHistory = [];
  List<ActivityRecord> _runningHistory = [];
  List<ActivityRecord> _bikeHistory = [];
  final _screenshotController = ScreenshotController();
  StreamSubscription<Position>? _locationSubscription;
  late TabController _tabController;
  double _totalDistance = 0.0;
  Duration _duration = Duration.zero;
  double _caloriesBurned = 0.0;
  Timer? _timer;
  ActivityType _currentActivityType = ActivityType.walking;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    _tabController = TabController(vsync: this, length: 3);
    _tabController.addListener(_handleTabChange);
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permission is required for activity tracking')),
      );
    }
  }

  void _handleTabChange() {
    setState(() {
      _currentActivityType = ActivityType.values[_tabController.index];
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  void _startRecording() async {
    if (!await Permission.location.isGranted) {
      _requestLocationPermission();
      return;
    }

    setState(() {
      _isRecording = true;
      _totalDistance = 0.0;
      _duration = Duration.zero;
      _caloriesBurned = 0.0;
    });

    // Start timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _duration += Duration(seconds: 1);
      });
    });

    // Create new activity record
    final newRecord = ActivityRecord(
      startTime: DateTime.now(),
      startLocation: _currentLocation!,
      activityType: _currentActivityType,
    );

    setState(() {
      switch (_currentActivityType) {
        case ActivityType.walking:
          _walkingHistory.add(newRecord);
          break;
        case ActivityType.running:
          _runningHistory.add(newRecord);
          break;
        case ActivityType.cycling:
          _bikeHistory.add(newRecord);
          break;
      }
    });

    _recordLocationUpdates();
  }

  void _stopRecording() {
    if (!_isRecording) return;

    setState(() {
      _isRecording = false;
      _timer?.cancel();
    });

    // Update the current record
    final currentHistory = _getCurrentHistory();
    if (currentHistory.isNotEmpty) {
      final currentRecord = currentHistory.last;
      currentRecord.endTime = DateTime.now();
      currentRecord.endLocation = _currentLocation;
      currentRecord.distance = _totalDistance;
      currentRecord.duration = _duration;
      currentRecord.caloriesBurned = _calculateCalories(
        _currentActivityType,
        _totalDistance,
        _duration,
      );
    }

    _stopLocationUpdates();
  }

  void _recordLocationUpdates() {
    LatLng? previousLocation;
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Update every 1 meter
      ),
    ).listen((position) {
      final newLocation = LatLng(position.latitude, position.longitude);
      
      setState(() {
        _currentLocation = newLocation;
        
        if (_isRecording && previousLocation != null) {
          // Calculate distance between points
          final distance = Geolocator.distanceBetween(
            previousLocation.latitude,
            previousLocation.longitude,
            newLocation.latitude,
            newLocation.longitude,
          );
          
          _totalDistance += distance / 1000; // Convert to kilometers
          
          // Update current record
          final currentHistory = _getCurrentHistory();
          if (currentHistory.isNotEmpty) {
            currentHistory.last.path.add(newLocation);
          }
        }
        
        previousLocation = newLocation;
      });
    });
  }

  double _calculateCalories(ActivityType type, double distance, Duration duration) {
    // Basic calorie calculation based on activity type, distance, and duration
    const walkingCaloriesPerKm = 50.0;
    const runningCaloriesPerKm = 80.0;
    const cyclingCaloriesPerKm = 30.0;

    switch (type) {
      case ActivityType.walking:
        return distance * walkingCaloriesPerKm;
      case ActivityType.running:
        return distance * runningCaloriesPerKm;
      case ActivityType.cycling:
        return distance * cyclingCaloriesPerKm;
    }
  }

  List<ActivityRecord> _getCurrentHistory() {
    switch (_currentActivityType) {
      case ActivityType.walking:
        return _walkingHistory;
      case ActivityType.running:
        return _runningHistory;
      case ActivityType.cycling:
        return _bikeHistory;
    }
  }

  void _stopLocationUpdates() {
    _locationSubscription?.cancel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopLocationUpdates();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Activities'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.directions_walk)),
            Tab(icon: Icon(Icons.directions_run)),
            Tab(icon: Icon(Icons.directions_bike)),
          ],
        ),
      ),
      body: _currentLocation != null
          ? Column(
              children: [
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildMapWidget(),
                      _buildMapWidget(),
                      _buildMapWidget(),
                    ],
                  ),
                ),
                if (_isRecording) _buildActivityStats(),
              ],
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!_isRecording)
            ElevatedButton(
              onPressed: _startRecording,
              child: Text('Start Activity'),
            ),
          if (_isRecording)
            ElevatedButton(
              onPressed: _stopRecording,
              child: Text('Stop Activity'),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      bottomNavigationBar: _getBottomNavigationBar(),
    );
  }

  Widget _buildActivityStats() {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn('Distance', '${_totalDistance.toStringAsFixed(2)} km'),
          _buildStatColumn('Duration', _formatDuration(_duration)),
          _buildStatColumn('Calories', '${_caloriesBurned.toStringAsFixed(0)} kcal'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  Widget _buildMapWidget() {
    final currentHistory = _getCurrentHistory();
    final currentPath = currentHistory.isNotEmpty && _isRecording
        ? currentHistory.last.path
        : <LatLng>[];

    return MapWidget(
      currentLocation: _currentLocation!,
      location: _currentLocation!,
      path: currentPath,
    );
  }

  Widget? _getBottomNavigationBar() {
    final currentHistory = _getCurrentHistory();
    
    return currentHistory.isNotEmpty
        ? Container(
            height: 200,
            child: ListView.builder(
              itemCount: currentHistory.length,
              itemBuilder: (context, index) {
                final record = currentHistory[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text('Activity ${index + 1}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Start: ${record.startTime.toString()}'),
                        if (record.endTime != null)
                          Text('End: ${record.endTime.toString()}'),
                        Text('Distance: ${record.distance.toStringAsFixed(2)} km'),
                        Text('Duration: ${_formatDuration(record.duration)}'),
                        Text('Calories: ${record.caloriesBurned.toStringAsFixed(0)} kcal'),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        : null;
  }
}

enum ActivityType {
  walking,
  running,
  cycling,
}

class ActivityRecord {
  final DateTime startTime;
  DateTime? endTime;
  final LatLng startLocation;
  LatLng? endLocation;
  final ActivityType activityType;
  final List<LatLng> path = [];
  double distance = 0.0;
  Duration duration = Duration.zero;
  double caloriesBurned = 0.0;

  ActivityRecord({
    required this.startTime,
    required this.startLocation,
    required this.activityType,
  });
}