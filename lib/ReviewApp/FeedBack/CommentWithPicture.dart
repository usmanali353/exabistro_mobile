import 'dart:convert';
import 'dart:io';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/CustomerFeedBack.dart';
import 'package:capsianfood/model/TasteClicks/RegisterViewModel.dart';
import 'package:capsianfood/model/TasteClicks/feedback.dart';
import 'package:capsianfood/networks/ReviewsNetworks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class CommentWithPicture extends StatefulWidget {
  int businessId,categoryId,subcategoryId;
 List<CustomerFeedBack> customerFeedBack=[];
  RegisterViewModel customerInfo;
  CommentWithPicture({this.businessId, this.categoryId, this.subcategoryId,this.customerFeedBack,this.customerInfo});

  @override
  _CommentWithPictureState createState() => _CommentWithPictureState();
}

class _CommentWithPictureState extends State<CommentWithPicture> {
  bool isVisible= true;
  File _image;
  var selectedImage;
  TextEditingController comment;
  @override
  void initState() {
    comment = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comment & Picture",
          style: GoogleFonts.prompt(
            textStyle: TextStyle(
                color: whiteTextColor,
                fontSize: 22,
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        iconTheme: IconThemeData(
            color: whiteTextColor
        ),
        centerTitle: true,
        backgroundColor: yellowColor,
      ),
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
                    height: 105,
                    color: color5,
                    child: Stack(
                      children: [
                        ClipPath(
                          clipper: WaveClipperTwo(flip: true),
                          child: Container(
                            height: 90,
                            color: yellowColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    width: 400,
                    height: 360,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Card(
                          color: whiteTextColor,
                          elevation:6,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller:comment,
                                style: GoogleFonts.prompt(
                                  textStyle: TextStyle(
                                      color: blueColor,
                                      fontWeight: FontWeight.w500
                                  ),
                                ),
                                obscureText: false,maxLines: 5,
                                // validator: (String value) =>
                                // value.isEmpty ? "This field is Required" : null,
                                decoration: InputDecoration(
                                  // suffixIcon: Icon(Icons.add_location,color: Colors.amberAccent,),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: yellowColor, width: 1.0)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: whiteTextColor, width: 1.0)
                                  ),
                                  labelText: 'Comment',
                                  labelStyle: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                  //suffixIcon: Icon(Icons.email,color: Colors.amberAccent,size: 27,),
                                ),
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.all(16),
                                height: 100,
                                width: 80,
                                child: _image == null ? Text('No image selected.',
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: blueColor,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ) : Image.file(_image),
                              ),
                              MaterialButton(
                                color: yellowColor,
                                onPressed: (){
                                  Utils.getImage().then((image_file){
                                    if(image_file!=null){
                                      image_file.readAsBytes().then((image){
                                        if(image!=null){
                                          setState(() {
                                            selectedImage=base64Encode(image);
                                            _image = image_file;
                                          });
                                        }
                                      });
                                    }else{

                                    }
                                  });
                                },
                                child: Text("Select Image",
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: whiteTextColor,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                    final ids = widget.customerFeedBack.map((e) => e.questionId).toSet();
                    widget.customerFeedBack.retainWhere((x) => ids.remove(x.questionId));
                    ReviewNetworks().AddFeedBack(feedback(
                      businessId: widget.businessId,
                      categoryId: widget.categoryId,
                      subCategoryId: widget.subcategoryId,
                      customerFeedBacks: widget.customerFeedBack,
                      email: widget.customerInfo.email,
                      country: widget.customerInfo.country,
                      city: widget.customerInfo.city,
                      phone: widget.customerInfo.phone,
                      image: selectedImage,
                      comment: comment.text,
                      customerName: widget.customerInfo.name,
                    ),context);
                  },
                  child: Center(
                    child: Card(
                      elevation: 8,
                      color: yellowColor,
                      child: Container(
                        height: 55,
                        width: 250,
                        decoration: BoxDecoration(
                          //color: color1,
                          // gradient: new LinearGradient(
                          //     colors: [
                          //       Color(0xff222831), Color(0xff393e46)
                          //     ]
                          // ),
                          borderRadius: BorderRadius.circular(15),
                          //border: Border.all(color: Color(0xfbb55400), width: 3)
                        ),
                        child: Center(
                          child: Text("SAVE",
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
