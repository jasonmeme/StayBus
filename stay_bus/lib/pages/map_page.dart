import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stay_bus/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stay_bus/pages/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  //final Locations selectedBusSystem;

  MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController? _mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  String? selected_location;

  // void initState() {
  //   super.initState();
  //   fetchUserLocation(); // Fetch the user's location when the page is loaded
  // }

  Future<void> fetchUserLocation() async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await userCollection.doc(user.uid).get();
      final location = userData.data()?['location'] as String?;
      setState(() {
        selected_location = location;
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
          // Your map content goes here
          // Positioned(
          //   top: 16.0,
          //   left: 16.0,
          //   child: Text(
          //     'User Location: ${selected_location ?? 'Unknown'}',
          //     style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          //   ),
          // ),
        ],
      ),
    );
  }
}
