import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stay_bus/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stay_bus/pages/location.dart';
import 'package:stay_bus/pages/map_page.dart';
import 'package:stay_bus/pages/settings.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  //final Function nextPageCallback;
  final Function(int) onPageChange;

  HomePage({Key? key, required this.onPageChange}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? errorMessage;
  final TextEditingController _zipCodeController = TextEditingController();
  List<Locations> _busSystems = [];
  List<Locations> _filteredBusSystems = [];
  Locations? _selectedLocation;
  bool _showSubmitButton = false;
  final User? user = Auth().currentUser;

  Future<void> getBusSystems() async {
    final CollectionReference locationsRef =
        FirebaseFirestore.instance.collection('locations');

    final QuerySnapshot querySnapshot = await locationsRef.get();

    final List<Locations> busSystems = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Locations(name: data['name'], zipCode: data['zipcode']);
    }).toList();

    setState(() {
      _busSystems = busSystems;
    });
  }

  Future<void> searchBusSystems(String userZipCode) async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    final List<Locations> filteredBusSystems = [];
    try {
      final userPlacemarks = await locationFromAddress(userZipCode);
      final userCoordinates = userPlacemarks.first;

      // Calculate the distance and filter the bus systems based on the user's zip code
      for (final location in _busSystems) {
        final busPlacemarks = await locationFromAddress(location.zipCode);
        final busCoordinates = busPlacemarks.first;

        final distanceInMeters = Geolocator.distanceBetween(
          userCoordinates.latitude,
          userCoordinates.longitude,
          busCoordinates.latitude,
          busCoordinates.longitude,
        );
        final distanceInMiles =
            distanceInMeters * 0.000621371; // Convert to miles
        if (distanceInMiles <= 100) {
          location.distance = distanceInMiles;
          filteredBusSystems.add(location);
        }
      }
      filteredBusSystems.sort((a, b) => a.distance!.compareTo(b.distance!));
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      setState(() {
        errorMessage = '$e';
      });
    }
    setState(() {
      _showSubmitButton = false;
      _selectedLocation = null;
      _filteredBusSystems = filteredBusSystems;
    });
  }

  @override
  void dispose() {
    _zipCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    getBusSystems();
    super.initState();
  }

  Widget _signOutButton() {
    return ElevatedButton(
      onPressed: signOut,
      child: const Text('Sign Out'),
    );
  }

  Future<void> uploadLocationToFirestore() async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
    if (user != null && _selectedLocation != null) {
      try {
        await userCollection.doc(user?.uid).update({
          'location': _selectedLocation!.name,
        });
        Navigator.pop(context);
        print('Location uploaded to Firestore successfully');
      } catch (error) {
        Navigator.pop(context);
        setState(() {
          errorMessage = '$error';
        });
        print('Error uploading location to Firestore: $error');
      }
    }
    widget.onPageChange(1);
  }

  void selectLocation(Locations location) {
    setState(() {
      _selectedLocation = location;
      _showSubmitButton = true;
    });
  }

  Widget showAlert() {
    if (errorMessage != null) {
      return Container(
        margin: EdgeInsets.only(top: 100),
        child: Container(
          color: Colors.amberAccent,
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(right: 8.0),
                child: Icon(Icons.error_outline),
              ),
              Expanded(
                child: Text(errorMessage == '' ? '' : "$errorMessage"),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(
                    () {
                      errorMessage = null;
                    },
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox(height: 0);
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: Column(
        children: [
          showAlert(),
          Container(
            margin: EdgeInsets.only(top: 85.0),
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                SizedBox(width: 8.0),
                Expanded(
                  child: TextField(
                    controller: _zipCodeController,
                    decoration: InputDecoration(
                        hintText: 'Enter Zip Code...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        prefixIcon: Icon(Icons.search),
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0)),
                  ),
                ),
                SizedBox(width: 8.0),
                GestureDetector(
                  onTap: () {
                    final String userZipCode = _zipCodeController.text.trim();
                    searchBusSystems(userZipCode);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: Color(0xFF18417F),
                        borderRadius: BorderRadius.circular(5)),
                    child: const Center(
                      child: Text(
                        'Search',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredBusSystems.length,
              itemBuilder: (context, index) {
                final location = _filteredBusSystems[index];
                final isSelected = _selectedLocation == location;
                return GestureDetector(
                  onTap: () {
                    selectLocation(location);
                    print('Selected location: ${location.name}');
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10, left: 20, right: 20),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: isSelected ? Colors.blue : Colors.grey[200],
                    ),
                    child: ListTile(
                      title: Text(
                        location.name,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : null,
                          color: isSelected ? Colors.white : null,
                        ),
                      ),
                      subtitle: Text(
                        '${location.zipCode} - ${location.distance!.toStringAsFixed(2)} miles',
                        style: TextStyle(
                          color: isSelected ? Colors.white : null,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_showSubmitButton)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  uploadLocationToFirestore();
                },
                icon: Icon(Icons.arrow_forward),
                label: Text('Submit'),
              ),
            ),
          _signOutButton(),
        ],
      ),
    );
  }
}
