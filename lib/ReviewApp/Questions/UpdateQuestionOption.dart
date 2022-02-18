import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/QuestionOptions.dart';
import 'package:capsianfood/networks/ReviewsNetworks.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateOptions extends StatefulWidget{
  QuestionOptions options;

  UpdateOptions(this.options);

  @override
  _UpdateBusinessCategoryState createState() => _UpdateBusinessCategoryState();
}

class _UpdateBusinessCategoryState extends State<UpdateOptions> {
  TextEditingController questionOptionText,rating;

  @override
  void initState() {
    questionOptionText = TextEditingController();
    rating = TextEditingController();
    questionOptionText.text=widget.options.questionOptionText;
    rating.text=widget.options.rating.toString();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Question Option",
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4,
                  color: whiteTextColor,
                child: Container(
                  child: TextFormField(
                    controller: questionOptionText,
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
                      labelText: "Option Text",
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
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 6,
                color: whiteTextColor,
                child: Container(
                  child: TextFormField(
                    controller: rating,
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
                      labelText: "Rating",
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
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                ReviewNetworks().updateQuestionOptions
                (QuestionOptions(
                 questionOptionId: widget.options.questionOptionId,
                  questionOptionText: questionOptionText.text,
                  rating: double.parse(rating.text),
                  questionId: widget.options.questionId
                ),context);
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
                      child: Text("UPDATE",
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
          ],
        ),
      ),
    );
  }
}
