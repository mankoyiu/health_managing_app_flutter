import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final LatLng currentLocation;
  final LatLng location;
  final List<LatLng> path;

  const MapWidget({
    Key? key,
    required this.currentLocation,
    required this.location,
    this.path = const <LatLng>[],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: currentLocation,
        initialZoom: 15.0,
        maxZoom: 18.0,
        minZoom: 5.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
          userAgentPackageName: 'com.xmed.app',
        ),
        if (path.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: path,
                color: Colors.blue,
                strokeWidth: 4.0,
              ),
            ],
          ),
        MarkerLayer(
          markers: [
            if (path.isNotEmpty)
              Marker(
                width: 40.0,
                height: 40.0,
                point: path.first,
                child: Icon(
                  Icons.location_on,
                  color: Colors.green,
                  size: 30.0,
                ),
              ),
            Marker(
              width: 40.0,
              height: 40.0,
              point: currentLocation,
              child: Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 30.0,
              ),
            ),
            if (path.isNotEmpty)
              Marker(
                width: 40.0,
                height: 40.0,
                point: path.last,
                child: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 30.0,
                ),
              ),
          ],
        ),
      ],
    );
  }
}



