import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/GetCustomerLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';


class CustomerDetails extends StatefulWidget {
  var orderDetail,token;

  CustomerDetails(this.orderDetail,this.token);

  @override
  _CustomerDetailsState createState() => _CustomerDetailsState();
}

class _CustomerDetailsState extends State<CustomerDetails> {
 var userDetail;
 Future<void> _launched;

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    Utils.check_connectivity().then((value) {
      if(value){

        networksOperation.getCustomerById(context, widget.token, widget.orderDetail['customerId']).then((value){
          setState(() {


          userDetail = value;
            print(value);
            print(widget.orderDetail);
          });
        });
      }else{
        Utils.showError(context, "Network Error");
      }
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
       // automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(padding: EdgeInsets.only(top: 20),),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 42),
                          child: Text("Customer Name", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            color: Colors.amberAccent

                          ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 42),
                          child: Text(userDetail!=null?userDetail['firstName']+" "+userDetail['lastName']:"", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            color: Colors.white
                          ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Address", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          color: Colors.amberAccent
                        ),
                        ),
                        Text(userDetail!=null?userDetail['address']:"", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          color: Colors.white
                        ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Secondary Address", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.amberAccent
                        ),
                        ),
                        Text(widget.orderDetail['deliveryAddress']!=null?widget.orderDetail['deliveryAddress']:"", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white
                        ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Phone Number", style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          color: Colors.amberAccent
                        ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(userDetail!=null?userDetail['cellNo']:"", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              color: Colors.white
                            ),
                            ),
                            InkWell(
                              onTap: (){
                                if(userDetail['cellNo'] != null && userDetail['cellNo'] == num ){
                                setState(() {
                                  _launched = _makePhoneCall('tel:${userDetail['cellNo']}');
                                });
                                }else{
                                  Utils.showError(context, "Cell Number is not exist");
                                }
                              },
                                child: FaIcon(FontAwesomeIcons.phone, color: Colors.amberAccent, size: 30,)
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap:(){
                        print(widget.orderDetail['deliveryLatitude'].toString());
                        print(userDetail['longitude'].toString());
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> GetCutomerLocation(
                          latitude: widget.orderDetail['deliveryLatitude']!=null? double.parse(widget.orderDetail['deliveryLatitude']):userDetail['latitude']!=null?double.parse(userDetail['latitude']):32.5855,
                          longitude: widget.orderDetail['deliveryLongitude']!=null? double.parse(widget.orderDetail['deliveryLongitude']):userDetail['longitude']!=null?double.parse(userDetail['longitude']):74.0771,
                        // longitude: 74.074,latitude: 32.0355,
                        )));

                            },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 5, right: 10),
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)) ,
                                color: Color(0xFF172a3a),
                                border: Border.all(color: Colors.amberAccent)
                            ),
                            width: MediaQuery.of(context).size.width / 3,
                            height: MediaQuery.of(context).size.height  * 0.05,

                            child: Center(
                              child: Text("Location On Map",style: TextStyle(color: Colors.amberAccent,fontSize: 15,fontWeight: FontWeight.bold),),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30),
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
