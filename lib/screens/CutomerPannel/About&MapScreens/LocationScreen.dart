import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'DirectionMapScreen.dart';


class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(56.1261, -3.1833);

  final Set<Marker> _markers = {};

  LatLng _lastMapPosition = _center;

  MapType _currentMapType = MapType.normal;

  void _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: translate('location_screen.info_window_title'),
          snippet:translate('location_screen.snippet_title'),
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  @override
  void initState() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
//        infoWindow: InfoWindow(
//          title: 'Really cool place',
//         // snippet: '5 Star Rating',
//        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF172a3a) ,
          title: Text(translate('location_screen.location_appbar_title'), style: TextStyle(
         color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold
          ),),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                image: AssetImage('assets/bb.jpg'),
              )
          ),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: SingleChildScrollView(
              child: new Container(
                decoration: new BoxDecoration(color: Colors.black.withOpacity(0.3)),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /2,
                                    child: Stack(
                                      children: <Widget>[
                                        GoogleMap(
                                          mapToolbarEnabled: true,
                                          onMapCreated: _onMapCreated,
                                          initialCameraPosition: CameraPosition(
                                            target: _center,
                                            zoom: 12,
                                          ),
                                          mapType: _currentMapType,
                                          markers: _markers,
                                          onCameraMove: _onCameraMove,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Align(
                                            alignment: Alignment.topRight,
                                            child: Column(
                                              children: <Widget> [
                                                FloatingActionButton(
                                                  heroTag:"ChangeMode",
                                                  onPressed: _onMapTypeButtonPressed,
                                                  materialTapTargetSize: MaterialTapTargetSize.padded,
                                                  backgroundColor: Color(0xFF172a3a),
                                                  child: const Icon(Icons.map, size: 36.0),
                                                ),
                                                SizedBox(height: 16.0),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                  ),
                                )
                            ),


                            Padding(
                              padding: EdgeInsets.only(top:20, bottom: 30, left: 10, right: 10),
                              child: Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                    color: Colors.white12,
                                  ),
                                  width: MediaQuery.of(context).size.width * 2 ,
                                  height: MediaQuery.of(context).size.height / 3,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                                          child: Text(translate('location_screen.address_title'),style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold),),
                                        ),
                                      ),
                                      //SizedBox(height: 10),

                                      SizedBox(height: 10),
                                      InkWell(
                                        onTap:(){
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=> DirectionMapScreen()));
                                        } ,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                              color: Color(0xFF172a3a),
                                            ),
                                            width: MediaQuery.of(context).size.width,
                                            height: 50,

                                            child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          FaIcon(FontAwesomeIcons.mapMarkerAlt, color: Colors.amberAccent, size: 25,),
                                                          Padding(
                                                            padding: EdgeInsets.all(5),
                                                          ),
                                                          Text(translate('buttons.get_direction'),style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                                        ],
                                                      ),
                                                      //Text("(2.9 Miles)",style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
                                                      // FaIcon(FontAwesomeIcons.angleRight, color: Colors.blue, size: 30,),
                                                    ],
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                              color: Colors.amberAccent,
                                            ),
                                            width: MediaQuery.of(context).size.width,
                                            height: 50,

                                            child: Center(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10.0),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: <Widget>[
                                                      Row(
                                                        children: <Widget>[
                                                          FaIcon(FontAwesomeIcons.phone, color: Color(0xFF172a3a), size: 25,),
                                                          Padding(
                                                            padding: EdgeInsets.all(5),
                                                          ),
                                                          Text("05111 22334",style: TextStyle(color: Color(0xFF172a3a),fontSize: 20,fontWeight: FontWeight.bold),),
                                                        ],
                                                      ),
                                                      //Text("(2.9 Miles)",style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
                                                      //FaIcon(FontAwesomeIcons.angleRight, color: Colors.blue, size: 30,),
                                                    ],
                                                  ),
                                                )
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
          ),
        ),
    );
  }
}
