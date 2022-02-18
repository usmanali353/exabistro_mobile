import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Address.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';// Stores the Google Maps API Key
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:math' show cos, sqrt, asin;


class getPosition extends StatefulWidget {
  @override
  _DirectionMapScreenState createState() => _DirectionMapScreenState();
}

class _DirectionMapScreenState extends State<getPosition> {

  CameraPosition _initialLocation;
  GoogleMapController mapController;

  final Geolocator _geolocator = Geolocator();
  List<Marker> myMarker = [];
  Address address;
  Position _currentPosition;
  String _currentAddress;
  var longitude,latitue;

  final startAddressController = TextEditingController();

  String _startAddress = '';
  MapType _currentMapType = MapType.normal;
  Set<Marker> markers = {};

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    TextEditingController controller,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey[400],
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue[300],
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await _geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        _initialLocation = CameraPosition(target: LatLng(_currentPosition.latitude, _currentPosition.longitude));
        myMarker.clear();
        myMarker.add(Marker(
          markerId: MarkerId("Your Current Location"),
          position: LatLng(position.latitude,position.longitude),
          // draggable: true,
          // onDragEnd: (dragEndPosition){
          //   // print(dragEndPosition);
          // }
        ));
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(latitue!=null?latitue:position.latitude, longitude!=null?longitude:position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }
  _handleTap(LatLng tappedPoint){
    print(tappedPoint);
    setState(() {

      myMarker.clear();
      myMarker.add(Marker(
        markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
      ));
    });
  }
  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
          latitue!=null?latitue: _currentPosition.latitude, longitude!=null?longitude:_currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name},${place.subLocality}, ${place.locality}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;

      });
    } catch (e) {
      print(e);
    }
  }

  // Map Type
  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  void initState() {
    _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
    _getCurrentLocation();
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Visibility(
      visible: _initialLocation!=null,
      child: Container(
        height: height,
        width: width,
        child: Scaffold(
          key: _scaffoldKey,
          body: Stack(
            children: <Widget>[
              // Map View
              GoogleMap(
                // markers: markers != null ? Set<Marker>.from(markers) : null,
                markers: Set.from(myMarker),
                initialCameraPosition: _initialLocation,
                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                onTap:(argument) {
                  setState(() {
                    longitude = argument.longitude;
                    latitue = argument.latitude;
                  });
                  _handleTap(argument);
                  _getAddress();
                },
              ),
              // Show zoom buttons
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 130, bottom: 100),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ClipOval(
                        child: Material(
                          color: Colors.white54, // button color
                          child: InkWell(
                            splashColor: Color(0xFF172a3a), // inkwell color
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.add, size: 30, color: yellowColor,),
                            ),
                            onTap: () {
                              mapController.animateCamera(
                                CameraUpdate.zoomIn(),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ClipOval(
                        child: Material(
                          color: Colors.white54, // button color
                          child: InkWell(
                            splashColor: Color(0xFF172a3a), // inkwell color
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Icon(Icons.remove, size: 30, color: yellowColor,),
                            ),
                            onTap: () {
                              mapController.animateCamera(
                                CameraUpdate.zoomOut(),
                              );
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // Show the place input fields & button for
              // showing the route
              SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white70,
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      width: width * 0.9,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SizedBox(height: 10),

                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Show current location button
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, bottom: 10.0),
                    child: ClipOval(
                      child: Material(
                        color: Color(0xFF172a3a), // button color
                        child: InkWell(
                          splashColor: Colors.amberAccent, // inkwell color
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.done, color: yellowColor,),
                          ),
                          onTap: () {
                            address =Address(address: _currentAddress!=null?_currentAddress:"Enter Address",latitude: latitue!=null?latitue:_currentPosition.latitude,longitude: longitude!=null?longitude:_currentPosition.longitude);
                            Navigator.pop(context,address);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 70.0, bottom: 30.0, left: 70),
                    child: Flushbar(
                      //backgroundColor: Colors.white24,
                      title:  _currentAddress!=null?_currentAddress.toString():"Address Could't Fetch",
                      duration:  Duration(seconds: 3),
                      message:  _currentPosition.toString(),
                    ),
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                    child: ClipOval(
                      child: Material(
                        color: Color(0xFF172a3a), // button color
                        child:  FloatingActionButton(
                          heroTag:"ChangeMode",
                          onPressed: _onMapTypeButtonPressed,
                          materialTapTargetSize: MaterialTapTargetSize.padded,
                          backgroundColor: Color(0xFF172a3a),
                          child: const Icon(Icons.map, size: 36.0, color: yellowColor,),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
