import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/Questions.dart';
import 'package:capsianfood/networks/ReviewsNetworks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateQuestion extends StatefulWidget {
  int businessId,categoryId,subCategoryId;
 Questions questions;
  UpdateQuestion(this.businessId, this.categoryId, this.subCategoryId,this.questions);

  @override
  _AddAQuestionState createState() => _AddAQuestionState();
}

class _AddAQuestionState extends State<UpdateQuestion> {
  TextEditingController questionText;
  List reviewTypeList=["Star Rating", "Yes/No", "Radio Button"];

  int questionTypeId;

  String token;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("reviewToken");
      });
    });
    questionText = TextEditingController();
    questionText.text =  widget.questions.questionText;

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update A Question",
          style: GoogleFonts.prompt(
              textStyle: TextStyle(
                color: whiteTextColor,
                fontSize: 22, ),

              fontWeight: FontWeight.bold
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
                    child: DropdownButtonFormField(
                      value: Utils.getQuestionType(widget.questions.questionType),
                      items: reviewTypeList!=null?reviewTypeList.map((trainer)=>DropdownMenuItem(
                        child: Text(trainer,
                          style: GoogleFonts.prompt(
                          textStyle: TextStyle(
                              color: whiteTextColor,
                              //fontSize: 22,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        ),
                        value: trainer,
                      )).toList():[""].map((name) => DropdownMenuItem(
                          value: name,
                          child: Text("$name",style: GoogleFonts.prompt(
                            textStyle: TextStyle(
                                color: yellowColor,
                                //fontSize: 22,
                                fontWeight: FontWeight.bold
                            ),
                          ),)))
                          .toList(),
                      decoration: InputDecoration(labelText: "Review Options",labelStyle: GoogleFonts.prompt(
                        textStyle: TextStyle(
                            color: yellowColor,
                            //fontSize: 22,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            borderSide: BorderSide(color: blueColor, width: 1.0)
                        ),
                      ),
                      onChanged: (value){
                        questionTypeId= reviewTypeList.indexOf(value)+1;
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  // if(_questionController.questionTypeId.value==3){
                  //   Navigator.push(context,MaterialPageRoute(builder:(context)=>AddOptions(businessId: widget.businessId,subCategoryId: widget.subCategoryId,categoryId: widget.categoryId,questionTypeId: _questionController.questionTypeId.value,questionText: _questionController.questionText.text,)));
                  // }else{
                    ReviewNetworks().updateQuestions(Questions(
                      businessId: widget.businessId,
                      categoryId: widget.categoryId,
                      subCategoryId: widget.subCategoryId,
                      questionText: questionText.text,
                      questionType: questionTypeId,
                      id: widget.questions.id,
                      isVisible: true,
                    ), token,context);
                //  }
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
                        child: Text("SAVE", style: TextStyle(
                          color: whiteTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),),
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
