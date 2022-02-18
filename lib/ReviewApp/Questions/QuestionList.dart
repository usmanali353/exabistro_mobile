import 'package:capsianfood/ReviewApp/Questions/UpdateQuestion.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/Questions.dart';
import 'package:capsianfood/networks/ReviewsNetworks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AddAQuestion.dart';
import 'QuestionOptions.dart';


class QuestionnaireList extends StatefulWidget {
  int businessId,categoryId,subCategoryId;

  QuestionnaireList({this.businessId, this.categoryId, this.subCategoryId});

  @override
  _QuestionnaireListState createState() => _QuestionnaireListState();
}

class _QuestionnaireListState extends State<QuestionnaireList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
 List<Questions> questionList =[];

  String token;

  @override
  void initState() {
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("reviewToken");
        print(token);
      });
    });

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: whiteTextColor,size:25,),
            onPressed: (){
             Navigator.push(context, MaterialPageRoute(builder: (context)=> AddAQuestion(widget.businessId,widget.categoryId,widget.subCategoryId)));
            },
          ),
        ],
        title: Text("Questionnaire",
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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: ()async{
          Utils.check_connectivity().then((isConnected){
            if(isConnected){
              ReviewNetworks().getQuestions(widget.businessId, widget.categoryId, widget.subCategoryId,token,context).then((value) {
                setState(() {
                  questionList = value;
                });
              });
             // _questionController.getQuestions(widget.subCategoryId, context);
            }else{
              Utils.showError(context,"Network not Available");
            }
          });
        },
        child: Container(
            color: whiteTextColor,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(itemCount:questionList.length, itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slidable(
                      actionPane: SlidableDrawerActionPane(),
                      actionExtentRatio: 0.20,
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          icon: Icons.edit,
                          color: blueColor,
                          caption: 'Update',
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder:(context)=>UpdateQuestion(widget.businessId,widget.categoryId,widget.subCategoryId,questionList[index])));

                          },
                        ),
                        IconSlideAction(
                          icon: questionList[index].isVisible?Icons.visibility_off:Icons.visibility,
                          color: Colors.red,
                          caption: 'Visibility',
                          onTap: () {
                            ReviewNetworks().changeQuestionVisibility(questionList[index].id, context);
                          },
                        ),
                      ],
                      child: Card(
                        elevation: 6,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          //height: 70,
                          decoration: BoxDecoration(
                            //color: color1,
                            borderRadius: BorderRadius.circular(10),
                            //border: Border.all(color: yellowColor, width: 2)
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(context,MaterialPageRoute(builder:(context)=>QuestionOptionsList(questionList[index].id)));
                            },
                            title: Text(questionList[index].questionText,
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                    color: yellowColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            subtitle: Text(Utils.getQuestionType(questionList[index].questionType),
                              style: GoogleFonts.prompt(
                                textStyle: TextStyle(
                                    color: blueColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                );
              })
        ),
      ),
    );
  }
}
