import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/Questions.dart';
import 'package:capsianfood/networks/ReviewsNetworks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddAnswers.dart';


class AddAQuestion extends StatefulWidget {
  int businessId,categoryId,subCategoryId;

  AddAQuestion(this.businessId, this.categoryId, this.subCategoryId);

  @override
  _AddAQuestionState createState() => _AddAQuestionState();
}

class _AddAQuestionState extends State<AddAQuestion> {
  TextEditingController questionText;
  List reviewTypeList=["Star Rating", "Yes/No", "Radio Button"];
  var questionTypeId,questionType;

  String token;
  @override
  void initState() {
    questionText = TextEditingController();

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("reviewToken");
      });
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add A Question",
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 6,
                  color: whiteTextColor,
                  child: Container(
                    child: TextFormField(
                      controller: questionText,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                            color: blueColor,
                            //fontSize: 22,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      obscureText: false,
                      validator: (String value) =>
                      value.isEmpty ? "This field is Required" : null,
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: whiteTextColor, width: 1.0)
                        ),
                        labelText: "Question?",
                        labelStyle: GoogleFonts.prompt(
                          textStyle: TextStyle(
                              color: yellowColor,
                              //fontSize: 22,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  elevation: 6,
                  color: whiteTextColor,
                  child: Container(
                    decoration: BoxDecoration(
                      color: whiteTextColor,
                      border: Border.all(color: yellowColor, width: 1)
                    ),
                    child: DropdownButtonFormField(
                      items: reviewTypeList!=null?reviewTypeList.map((trainer)=>DropdownMenuItem(
                        child: Text(trainer,style: TextStyle(color: yellowColor),),
                        value: trainer,
                      )).toList():[""].map((name) => DropdownMenuItem(
                          value: name, child: Text("$name",style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                            color: whiteTextColor,
                            //fontSize: 22,
                          ),

                          fontWeight: FontWeight.bold
                      ),
                      )))
                          .toList(),
                      decoration: InputDecoration(labelText: "Review Options",labelStyle: GoogleFonts.prompt(
                        textStyle: TextStyle(
                            color: yellowColor,
                            //fontSize: 22,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                      ),
                      value: questionType,
                      onChanged: (value){
                        questionType = value;
                       questionTypeId = reviewTypeList.indexOf(value)+1;
                       print(questionTypeId);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  print(token);
                   if(questionTypeId==3){
                       Navigator.push(context,MaterialPageRoute(builder:(context)=>AddOptions(businessId: widget.businessId,subCategoryId: widget.subCategoryId,categoryId: widget.categoryId,questionTypeId: questionTypeId,questionText: questionText.text,)));
                   }else{
                     ReviewNetworks().addQuestions(Questions(
                       businessId: widget.businessId,
                       categoryId: widget.categoryId,
                       subCategoryId: widget.subCategoryId,
                       questionType: questionTypeId,
                       questionText: questionText.text
                     ),token, context);
                   }
                },
                child: Center(
                  child: Card(
                    elevation: 6,
                    color: yellowColor,
                    child: Container(
                      height: 55,
                      width: 220,
                      decoration: BoxDecoration(
                        color: yellowColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text("SAVE", style: GoogleFonts.prompt(
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
            ],
          ),
        ),
      ),
    );
  }
}
