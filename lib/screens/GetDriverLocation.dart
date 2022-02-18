import 'package:background_fetch/background_fetch.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/model/Address.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/AdminPannel/AdminNavBar/AdminNavBar.dart';
import 'package:capsianfood/screens/DeliveryBoyPannel/DeliveryBoyNavBar/DeliveryBoyNavBar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';// Stores the Google Maps API Key
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:shared_preferences/shared_preferences.dart';


class GetDriverLocation extends StatefulWidget {
  var orderDetails,orderStutus,driverId;
  bool isDeliverySide;
  GetDriverLocation({this.orderDetails,this.orderStutus,this.isDeliverySide,this.driverId});

  @override
  _DirectionMapScreenState createState() => _DirectionMapScreenState();
}


class _DirectionMapScreenState extends State<GetDriverLocation> {

  CameraPosition _initialLocation;
  GoogleMapController mapController;

  final Geolocator _geolocator = Geolocator();
  Position _currentPosition;
  List<Marker> myMarker = [];
  Address address;
  String _currentAddress;
  var longitude,latitude;

  final startAddressController = TextEditingController();
  //final destinationAddressController = TextEditingController();

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
        _initialLocation = CameraPosition(
          target: LatLng(_currentPosition.latitude,_currentPosition.longitude)
          //  target: LatLng(widget.orderDetails['driverLatitude']!=null?double.parse(widget.orderDetails['driverLatitude']):_currentPosition.latitude, widget.orderDetails['driverLongitude']!=null?double.parse(widget.orderDetails['driverLongitude']):_currentPosition.latitude)
        );
        myMarker.clear();
        myMarker.add(Marker(
          markerId: MarkerId("Your Current Location"),
          position: LatLng(position.latitude, position.longitude)
        ));
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
             // target: LatLng(widget.orderDetails['driverLatitude']!=null?widget.orderDetails['driverLatitude']:position.latitude, widget.orderDetails['driverLongitude']!=null?widget.orderDetails['driverLongitude']:position.longitude),
              target: LatLng(position.latitude, position.longitude),
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
        // draggable: true,
        // onDragEnd: (dragEndPosition){
        //   // print(dragEndPosition);
        // }
      ));
    });
  }
  // Method for retrieving the address
  _getAddress() async {
    try {
      List<Placemark> p = await _geolocator.placemarkFromCoordinates(
        _currentPosition.latitude,_currentPosition.longitude
      );

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name},${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}";
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
    BackgroundFetch.configure(BackgroundFetchConfig(
        forceAlarmManager: true,
        requiredNetworkType: NetworkType.ANY,
        stopOnTerminate: true,
        requiresStorageNotLow: false,
        minimumFetchInterval:10
    ), (String taskId){
      _getCurrentLocation();
      var a;
      SharedPreferences.getInstance().then((prefs){
        var driverLocation = {
          "orderid": 79,
          "DriverId": 6,
          "DriverAddress": "Wazirabad Punjab",
          "DriverLongitude": "74.1119",
          "DriverLatitude": "32.4302"
        };
        networksOperation.updateDriverLocation(context, prefs.getString("token"), widget.orderDetails['id'],widget.orderDetails['driverId']
        ,_currentAddress,_currentPosition.longitude.toString(),_currentPosition.latitude.toString())
            .then((value){

          if(value)   {
            Utils.showSuccess(context, "Successful running");
          }
        });


        //   }
        // });
      });

      BackgroundFetch.finish(taskId);
    }).then((int status){
      print("Background Service Running $status");
    });
    BackgroundFetch.start().then((int status) {
      print('[BackgroundFetch] start success: $status');
    }).catchError((e) {
      print('[BackgroundFetch] start FAILURE: $e');
    });

    if(widget.orderStutus == 7){
      BackgroundFetch.stop().then((value) {
        Utils.showSuccess(context, "Stop has run");
      });


    }
    // BackgroundFetch.scheduleTask(TaskConfig(
    //   delay: 5000,
    //   requiresStorageNotLow: false,
    //   stopOnTerminate: false,
    //   periodic: true,
    //   taskId: "DriverLocationUpdate",
    //   enableHeadless: true,
    //   requiresBatteryNotLow: true,
    // )).then((value){
    //   print("Task is started");
    // });
   // BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
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
          appBar:   AppBar(

            title: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 38),
                child: Container(
                  height: 45,
                  width: 400,
                  child: Image.asset(
                    'assets/caspian11.png',
                  ),
                ),
              ),
            ),
            //centerTitle: true,
            backgroundColor: Color(0xff172a3a),
            //automaticallyImplyLeading: false,
          ),
          body: Stack(
            children: <Widget>[
              // Map View
              GoogleMap(
                zoomControlsEnabled: false,
                // markers: markers != null ? Set<Marker>.from(markers) : null,
                markers: Set.from(myMarker),
                initialCameraPosition: _initialLocation,
                // myLocationEnabled: true,
                // myLocationButtonEnabled: false,
                // mapType: _currentMapType,
                // zoomGesturesEnabled: true,
                // zoomControlsEnabled: false,
                // polylines: Set<Polyline>.of(polylines.values),

                onMapCreated: (GoogleMapController controller) {
                  mapController = controller;
                },
                onTap:(argument) {
                  // setState(() {
                  //   longitude = argument.longitude;
                  //   latitue = argument.latitude;
                  // });
                  // _handleTap(argument);
                  _getAddress();
                },
              ),
              // Show zoom buttons
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 150),
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
                              child: Icon(Icons.add, size: 30,),
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
                              child: Icon(Icons.remove, size: 30,),
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
                            // _textField(
                            //     label: 'Start',
                            //     hint: 'Choose starting point',
                            //     prefixIcon: Icon(Icons.donut_large, color: Colors.lightBlue,),
                            //     suffixIcon: IconButton(
                            //       icon: Icon(Icons.my_location),
                            //       onPressed: () {
                            //
                            //         startAddressController.text = _currentAddress;
                            //         _startAddress = _currentAddress;
                            //       },
                            //     ),
                            //     controller: startAddressController,
                            //     width: width,
                            //     locationCallback: (String value) {
                            //       setState(() {
                            //         _startAddress = value;
                            //       });
                            //     }),
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
                            child: Icon(Icons.backspace, color: Colors.white,),
                          ),
                          onTap: () {
                            print(widget.orderDetails['driverLatitude'].toString());
                            // address =Address(address: _currentAddress,latitude: latitue,longitude: longitude);
                           // Navigator.pop(context);
                            if(widget.orderStutus==6 && widget.isDeliverySide==false){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminNavBar(storeId: widget.orderDetails['storeId'],roleId: 1,),));

                            }else if(widget.orderStutus==6 && widget.isDeliverySide==true){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeliveryBoyNavBar(widget.orderDetails['storeId'],widget.driverId),));

                            }else if(widget.orderStutus==7 && widget.isDeliverySide==false){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AdminNavBar(storeId: widget.orderDetails['storeId'],roleId: 1,),));

                            }else if(widget.orderStutus==7 && widget.isDeliverySide==true){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DeliveryBoyNavBar(widget.orderDetails['storeId'],widget.driverId),));

                            }
                            // _getCurrentLocation();
                            // mapController.animateCamera(
                            //   CameraUpdate.newCameraPosition(
                            //     CameraPosition(
                            //       target: LatLng(
                            //         latitue,
                            //         longitude
                            //         // _currentPosition.latitude,
                            //         // _currentPosition.longitude,
                            //       ),
                            //       zoom: 18.0,
                            //     ),
                            //   ),
                            // );
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
                    padding: const EdgeInsets.only(right: 70.0, bottom: 40.0, left: 70),
                    child: Flushbar(
                      //backgroundColor: Colors.white24,
                      title:  _currentAddress.toString(),
                      duration:  Duration(seconds: 3),
                     // message: "Latitude: "+_currentPosition.latitude.toString()+",Longitude: "+_currentPosition.longitude.toString(),
                       message: 'CURRENT POS: $_currentPosition',
                      // message: "Lat"+widget.latitude.toString()!=null?widget.latitude.toString(): _currentPosition.latitude.toString()+"Log"+
                      //     widget.latitude.toString()!=null?widget.latitude.toString(): _currentPosition.longitude.toString(),
                    //  message: "Latitude: ${widget.orderDetails['driverLatitude']!=null?widget.orderDetails['driverLatitude'].toString():_currentPosition.latitude},Longitude: ${widget.orderDetails['driverLongitude']!=null?widget.orderDetails['driverLongitude'].toString():_currentPosition.longitude}",
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
                          child: const Icon(Icons.map, size: 36.0),
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
