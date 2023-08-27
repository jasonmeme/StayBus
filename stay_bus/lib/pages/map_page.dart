import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stay_bus/pages/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';

class MapPage extends StatefulWidget {
  //final Locations selectedBusSystem;

  MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final user = FirebaseAuth.instance.currentUser;
  final databaseRef = FirebaseDatabase.instance.ref();
  String selectedLocation = 'No Location Selected';
  List<String> routes = [];
  late GoogleMapController? _mapController;
  final LatLng _center = const LatLng(45.521563, -122.677433);

  List<LatLng> stops = [];
  String? selectedRoute;
  final Map<PolylineId, Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    fetchLocationAndRoutes();
  }

  Future<void> fetchLocationAndRoutes() async {
    final userDocument =
        FirebaseFirestore.instance.collection('users').doc(user?.uid);

    final locationSnapshot = await userDocument.get();
    selectedLocation = locationSnapshot.data()?['location'];
    print(selectedLocation);

    if (selectedLocation.isNotEmpty) {
      databaseRef
          .child('Locations')
          .child(selectedLocation)
          .once()
          .then((DatabaseEvent event) {
        setState(() {
          if (event.snapshot.value is List<dynamic>) {
            routes = List<String>.from(event.snapshot.value as List<dynamic>);
            selectedRoute = null;
            stops = [];
            _polylines.clear();
          } else {
            routes = [];
          }
        });
      });
    }
  }

  Future<void> fetchRouteStops(String route) async {
    String combined = route + " " + selectedLocation.split(" ")[0];
    final routeDataSnapshot =
        await databaseRef.child('Routes').child(combined).once();
    if (routeDataSnapshot.snapshot.value is Map<dynamic, dynamic>) {
      final Map<String, dynamic> routeData = Map<String, dynamic>.from(
          routeDataSnapshot.snapshot.value as Map<dynamic, dynamic>);
      print(routeData.entries.toList());
      final sortedStops = routeData.entries.toList()
        ..sort((a, b) => a.value['Time'].compareTo(b.value['Time']));
      print(sortedStops);
      stops = sortedStops
          .map((stop) => LatLng(
                double.parse(stop.value['Latitude']),
                double.parse(stop.value['Longitude']),
              ))
          .toList();
      // Add a polyline for the route
      final polylineId = PolylineId(route);
      final polyline = Polyline(
        polylineId: polylineId,
        color: Colors.red,
        points: stops,
        width: 3,
      );
      _polylines[polylineId] = polyline;
    } else {
      // Handle the case where route data is not a map
      stops = [];
      _polylines.clear();
    }
    print(stops);
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  // computePath()async{
  // LatLng origin = new LatLng(departure.geometry.location.lat, departure.geometry.location.lng);
  // LatLng end = new LatLng(arrival.geometry.location.lat, arrival.geometry.location.lng);
  // routeCoords.addAll(await googleMapPolyline.getCoordinatesWithLocation(origin: origin, destination: end, mode: RouteMode.driving));

  // setState(() {
  //   polyline.add(Polyline(
  //       polylineId: PolylineId('iter'),
  //       visible: true,
  //       points: routeCoords,
  //       width: 4,
  //       color: Colors.blue,
  //       startCap: Cap.roundCap,
  //       endCap: Cap.buttCap
  //   ));
  // });
  //}

  String? errorMessage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedLocation.isEmpty ? 'No Location Selected' : selectedLocation,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20.0), // Choose your preferred style
        ),
        backgroundColor: Colors.deepPurple, // Choose your preferred color
      ),
      body: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            if (selectedLocation.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedRoute,
                    icon: const Icon(Icons.arrow_downward),
                    isExpanded: true,
                    items: routes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedRoute = newValue;
                          fetchRouteStops(newValue);
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      10.0), // Add some space between the dropdown and the map
              Expanded(
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: stops.isNotEmpty
                        ? stops[0]
                        : LatLng(
                            42.7654, -71.4676), // Default to Boston if no stops
                    zoom: 12,
                  ),
                  polylines: Set<Polyline>.of(_polylines.values),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
