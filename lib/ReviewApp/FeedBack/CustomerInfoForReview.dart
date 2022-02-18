import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/RegisterViewModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddFeedBack.dart';

class CustomerInfoForFeedback extends StatefulWidget{
  int businessId,categoryId,subcategoryId;

  CustomerInfoForFeedback({this.businessId, this.categoryId, this.subcategoryId});

  @override
  _CustomerInfoForFeedbackState createState() => _CustomerInfoForFeedbackState();
}

class _CustomerInfoForFeedbackState extends State<CustomerInfoForFeedback> {
  TextEditingController name,email,phone,city,country;

  @override
  void initState() {
    name =TextEditingController();
    email =TextEditingController();
    phone =TextEditingController();
    city =TextEditingController();
    country =TextEditingController();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.email.text = value.getString("email");
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: whiteTextColor,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: ClipPath(
                  clipper: WaveClipperTwo(flip: true),
                  child: Container(
                    height: 165,
                    color: color5,
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: WaveClipperTwo(flip: true),
                          child: Container(
                            height: 150,
                            color: yellowColor,
                            child:Padding(
                              padding: const EdgeInsets.only(top: 60),
                              child: Row(
                                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(Icons.arrow_back, color: whiteTextColor,size:30),
                                    onPressed: (){
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                  child: Container(
                    width: 400,
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/caspian11.png')
                        )
                    ),
                  )
              ),
              SizedBox(height: 10,),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 400,
                    height: 510,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Want to Give Feedback?',
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                    color: blueColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 8,
                            color: whiteTextColor,
                            child: Container(
                              child: TextFormField(
                                controller: name,
                                style:  GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                      color: blueColor,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: whiteTextColor, width: 1.0)
                                  ),
                                  labelText: "Name",
                                  labelStyle: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  suffixIcon: Icon(Icons.assignment_ind,color: yellowColor,size: 27,),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 8,
                            color: whiteTextColor,
                            child: Container(
                              child: TextFormField(
                                controller: email,
                                readOnly: true,
                                style:  GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                      color: blueColor,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: whiteTextColor, width: 1.0)
                                  ),
                                  labelText: "Email",
                                  labelStyle: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  suffixIcon: Icon(Icons.email,color: yellowColor,size: 27,),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 8,
                            color: whiteTextColor,
                            child: Container(
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                controller: phone,
                                style:  GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                      color: blueColor,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: whiteTextColor, width: 1.0)
                                  ),
                                  labelText: "Phone",
                                  labelStyle: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  suffixIcon: Icon(Icons.add_call,color: yellowColor,size: 27,),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 8,
                            color: whiteTextColor,
                            child: Container(
                              child: TextFormField(
                                controller: city,
                                style:  GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                      color: blueColor,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: whiteTextColor, width: 1.0)
                                  ),
                                  labelText: "City",
                                  labelStyle: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  suffixIcon: Icon(Icons.add_location,color: yellowColor,size: 27,),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            elevation: 8,
                            color: whiteTextColor,
                            child: Container(
                              child: TextFormField(
                                controller: country,
                                style:  GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                      color: blueColor,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                obscureText: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: whiteTextColor, width: 1.0)
                                  ),
                                  labelText: "Country",
                                  labelStyle: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  suffixIcon: Icon(Icons.account_balance,color: yellowColor,size: 27,),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: InkWell(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>AddRatings(businessId: widget.businessId,categoryId: widget.categoryId,subcategoryId: widget.subcategoryId,userInfo: RegisterViewModel(
                      email: email.text,
                      name: name.text,
                      phone: phone.text,
                      city: city.text,
                      country: country.text
                    ),)));
                  },
                  child: Center(
                    child: Card(
                      elevation: 8,
                      color: yellowColor,
                      child: Container(
                        height: 55,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text("Proceed",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                  color: whiteTextColor,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
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
class WaveClipperTwo extends CustomClipper<Path> {
  /// reverse the wave direction in vertical axis
  bool reverse;

  /// flip the wave direction horizontal axis
  bool flip;

  WaveClipperTwo({this.reverse = false, this.flip = false});

  @override
  Path getClip(Size size) {
    var path = Path();
    if (!reverse && !flip) {
      path.lineTo(0.0, size.height - 20);

      var firstControlPoint = Offset(size.width / 4, size.height);
      var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint =
      Offset(size.width - (size.width / 3.25), size.height - 65);
      var secondEndPoint = Offset(size.width, size.height - 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height - 40);
      path.lineTo(size.width, 0.0);
      path.close();
    } else if (!reverse && flip) {
      path.lineTo(0.0, size.height - 40);
      var firstControlPoint = Offset(size.width / 3.25, size.height - 65);
      var firstEndPoint = Offset(size.width / 1.75, size.height - 20);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondCP = Offset(size.width / 1.25, size.height);
      var secondEP = Offset(size.width, size.height - 30);
      path.quadraticBezierTo(
          secondCP.dx, secondCP.dy, secondEP.dx, secondEP.dy);

      path.lineTo(size.width, size.height - 20);
      path.lineTo(size.width, 0.0);
      path.close();
    } else if (reverse && flip) {
      path.lineTo(0.0, 20);
      var firstControlPoint = Offset(size.width / 3.25, 65);
      var firstEndPoint = Offset(size.width / 1.75, 40);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondCP = Offset(size.width / 1.25, 0);
      var secondEP = Offset(size.width, 30);
      path.quadraticBezierTo(
          secondCP.dx, secondCP.dy, secondEP.dx, secondEP.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    } else {
      path.lineTo(0.0, 20);

      var firstControlPoint = Offset(size.width / 4, 0.0);
      var firstEndPoint = Offset(size.width / 2.25, 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint = Offset(size.width - (size.width / 3.25), 65);
      var secondEndPoint = Offset(size.width, 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}