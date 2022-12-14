import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  static Route<dynamic> route() => MaterialPageRoute(
        builder: (context) => HomePage(),
      );
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // var location = new Location();
  late Position _currentPosition;
  late String _currentAddress;
  late Map<String, double> userLocation;
  var placeArray = [];
  String dispLocation = "";

  _setLastLocation(lat, long) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('lat', lat);
    await prefs.setDouble('long', long);
  }

  _getLastLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      placeArray = [prefs.getDouble('lat'), prefs.getDouble('long')];
      dispLocation =
          'Last coordinates LAT: ${placeArray[0]}, LNG: ${placeArray[1]}';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Container(
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
                child: Text("Get location"),
                onPressed: () {
                  _getCurrentLocation();
                }),
            if (_currentPosition != null)
              Text(
                  "LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}"),
            if (_currentAddress != null) Text(_currentAddress),
            if (_currentPosition != null)
              ElevatedButton(
                  child: Text("Save current location"),
                  onPressed: () {
                    _setLastLocation(
                        _currentPosition.latitude, _currentPosition.longitude);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Saved LAT: ${_currentPosition.latitude}, LNG: ${_currentPosition.longitude}')));
                  }),
            ElevatedButton(
                child: Text("Get last location"),
                onPressed: () {
                  _getLastLocation();
                }),
            Text(dispLocation),
          ],
        ),
      ),
    );
  }

  _getCurrentLocation() {
    _getAddressFromLatLng() async {
      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
            _currentPosition.latitude, _currentPosition.longitude);

        Placemark place = placemarks[0];
        setState(() {
          _currentAddress =
              "${place.street}, ${place.subAdministrativeArea}, ${place.country}";
        });
      } catch (e) {
        print(e);
      }
    }

    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }).catchError((e) {
      print(e);
    });
  }
}
