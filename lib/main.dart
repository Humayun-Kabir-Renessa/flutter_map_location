// this will show current location in map
// at the same time it will show address of current location in text
// Geocoding is used to convert location latitude & longitude into address
// showing current time

import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyLocation(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyLocation extends StatefulWidget {
  final String title;
  const MyLocation({Key? key, required this.title}) : super(key: key);

  @override
  _MyLocationState createState() => _MyLocationState();
}

class _MyLocationState extends State<MyLocation> {
  // Below two will be used to get current position, current date time and current address
  LocationData? _currentPosition;
  String? _address,_dateTime;

  // declare & initialize location related
  Location location = Location();
  GoogleMapController? _controller;
  LatLng _initialcameraposition = LatLng(23.79318382597098, 90.37573726780906);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLoc();

  }
  // on map created
  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    location.onLocationChanged.listen((l) {
      _controller!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude!, l.longitude!),zoom: 15),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Container(
            //address container
            color: Colors.blueGrey.withOpacity(.8),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Google map section in UI
                  Container(
                    height:  MediaQuery.of(context).size.height/1.3,
                    width: MediaQuery.of(context).size.width,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(target: _initialcameraposition, zoom: 15.0),
                      mapType: MapType.normal,
                      onMapCreated: _onMapCreated,
                      myLocationEnabled: true,
                    ),
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  if (_dateTime != null)
                    Text(
                      "Date/Time: $_dateTime",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),

                  SizedBox(
                    height: 3,
                  ),
                  if (_currentPosition != null)
                    Text(
                      "Latitude: ${_currentPosition!.latitude}, Longitude: ${_currentPosition!.longitude}",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  SizedBox(
                    height: 3,
                  ),
                  if (_address != null)
                    Text(
                      "Address: $_address",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  SizedBox(
                    height: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),

    );
  }

// get user's current location
  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    // if location service is not enabled, then request to enable it
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    // check whether location permission is granted or not.
    // If not granted then request permission
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    // get user's current location
    _currentPosition = await location.getLocation();
    // initial camera position
    _initialcameraposition = LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
    location.onLocationChanged.listen((LocationData currentLocation) {
      print("${currentLocation.longitude} : ${currentLocation.longitude}");
      setState(() {
        _currentPosition = currentLocation;
        _initialcameraposition =
            LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);

        DateTime now = DateTime.now();
        _dateTime = DateFormat('EEE d MMM kk:mm:ss ').format(now);
        // get address using Geocoding from current location
        _getAddress(_currentPosition!.latitude!, _currentPosition!.longitude!)
            .then((value) {
          setState(() {
            _address = "${value.first.name},${value.first.subThoroughfare},${value.first.thoroughfare},${value.first.subLocality},${value.first.locality},${value.first.postalCode},${value.first.country}";
          });
        });
      });
    });
  }
// this method takes latitude and longiture and returns address using Geocoding package
  Future<List<geo.Placemark>> _getAddress(double lat, double lang) async {
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(lat, lang);
    //print(placemarks);
    return placemarks;
  }

}