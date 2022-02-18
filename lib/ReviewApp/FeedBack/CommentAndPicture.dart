import 'dart:convert';

import 'package:capsianfood/components/constants.dart';
import 'package:flutter/cupertino.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommentAndPicture extends StatefulWidget {
  String comment,image;

  CommentAndPicture(this.comment, this.image);

  @override
  _CommentAndPictureState createState() => _CommentAndPictureState();
}

class _CommentAndPictureState extends State<CommentAndPicture> {

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
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 270,
                decoration: BoxDecoration(
                    color: blueColor,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                       // image: widget.image!=null ?MemoryImage(base64Decode(widget.image)):AssetImage("assets/business.jpg")
                        image: widget.image!=null ?NetworkImage(widget.image):AssetImage("assets/business.jpg")
                    )
                ),
              ),
              Center(
                child: Card(
                  elevation: 10,
                  color: whiteTextColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: whiteTextColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: 320,
                    height: 260,
                    child: Column(
                      children: [
                        Text("Comments",
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                                color: yellowColor,
                                fontSize: 35,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        Text(widget.comment!=null?widget.comment:"",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                                color: blueColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )

            ],
          )
      ),
    );
  }
}
