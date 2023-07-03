import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:stay_bus/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stay_bus/pages/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _zipCodeController = TextEditingController();
  List<Locations> _busSystems = [];
  final User? user = Auth().currentUser;

  Future<void> searchBusSystems(String userZipCode) async {
    final CollectionReference locationsRef =
        FirebaseFirestore.instance.collection('locations');

    final QuerySnapshot querySnapshot = await locationsRef.get();

    final List<Locations> busSystems = querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Locations(name: data['name'], zipCode: data['zipcode']);
    }).toList();

    final List<Locations> filteredBusSystems = [];
    try {
      final userPlacemarks = await locationFromAddress(userZipCode);
      final userCoordinates = userPlacemarks.first;

      // Calculate the distance and filter the bus systems based on the user's zip code
      for (final location in busSystems) {
        final busPlacemarks = await locationFromAddress(location.zipCode);
        final busCoordinates = busPlacemarks.first;

        final distanceInMeters = Geolocator.distanceBetween(
          userCoordinates.latitude,
          userCoordinates.longitude,
          busCoordinates.latitude,
          busCoordinates.longitude,
        );

        // Set your desired distance criteria here (e.g., 10 kilometers)
        if (distanceInMeters <= 10000) {
          filteredBusSystems.add(location);
        }
      }
    } catch (e) {
      print('Error occurred: $e');
    }

    setState(() {
      _busSystems = filteredBusSystems;
    });
  }

  @override
  void dispose() {
    _zipCodeController.dispose();
    super.dispose();
  }

  // Future getDocId() async {
  //   await FirebaseFirestore.instance.collection('locations').get().then(
  //         (snapshot) => snapshot.docs.forEach((element) {
  //           docIDs.add(element.reference.id);
  //         }),
  //       );
  // }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  // @override
  // void initState() {
  //   getDocId();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
                      hintText: 'Search Bus Systems. Ex (03062)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final String userZipCode = _zipCodeController.text.trim();
              searchBusSystems(userZipCode);
            },
            child: Text('Search'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _busSystems.length,
              itemBuilder: (context, index) {
                final location = _busSystems[index];
                return ListTile(
                  title: Text(location.name),
                  subtitle: Text(location.zipCode),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          color: Colors.blue,
        ),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
