import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/QuestionOptions.dart';
import 'package:capsianfood/model/TasteClicks/Questions.dart';
import 'package:capsianfood/networks/ReviewsNetworks.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AddOptions extends StatefulWidget {
  int businessId, categoryId,subCategoryId,questionTypeId;
  String questionText;

  AddOptions({this.businessId, this.categoryId, this.subCategoryId,
      this.questionTypeId, this.questionText});

  @override
  _AddOptionsState createState() => _AddOptionsState();
}

class _AddOptionsState extends State<AddOptions> {
  var optionTextTECS = <TextEditingController>[];
  var ratingTECS = <TextEditingController>[];
  var cards = <Card>[];
  int id=null;
  
  List<QuestionOptions> optionsList=[];

  String token;
  Card createCard() {
    id??null;
    var optionText = TextEditingController();
    var rating = TextEditingController();
    optionTextTECS.add(optionText);
    ratingTECS.add(rating);
    return Card(
      elevation: 10,
      color: whiteTextColor,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: yellowColor, width: 1)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top:16.0),
              child: Text('Option ${cards.length + 1}'),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                  controller: optionText,
                  decoration: InputDecoration(labelText: 'Option Text'),
                  keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16,left: 16,right: 16),
              child: TextField(
                  controller: rating,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'Rating')
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {

    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("reviewToken");
      });
    });
    super.initState();
    cards.add(createCard());
  }

  _onDone() {
    List<QuestionOptions> entries = [];
    for (int i = 0; i < cards.length; i++) {
      var optionText = optionTextTECS[i].text;
      var rating = ratingTECS[i].text;
      entries.add(QuestionOptions(rating: double.parse(rating),questionOptionText: optionText));
    }
    optionsList.addAll(entries);
    ReviewNetworks().addQuestions(Questions(
        businessId: widget.businessId,
        categoryId: widget.categoryId,
        subCategoryId: widget.subCategoryId,
        questionType: widget.questionTypeId,
        questionText: widget.questionText,
      questionOptions: optionsList
    ), token,context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Question Options", style:
      GoogleFonts.prompt(
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
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: cards.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: cards[index],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:  InkWell(
              onTap: () => setState(() => cards.add(createCard())),
              child: Center(
                child: Card(
                  elevation: 6,
                  color: yellowColor,
                  child: Container(
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      color: yellowColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text("ADD", style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                            color: whiteTextColor,
                            fontSize: 20,

                            fontWeight: FontWeight.bold
                        ),
                      ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButton:
      FloatingActionButton(child: Icon(Icons.done, color: whiteTextColor,), onPressed: _onDone, backgroundColor: yellowColor,),
    );
  }
}