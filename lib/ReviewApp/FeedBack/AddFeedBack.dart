import 'dart:async';
import 'dart:convert';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/CustomerFeedBack.dart';
import 'package:capsianfood/model/TasteClicks/QuestionOptions.dart';
import 'package:capsianfood/model/TasteClicks/Questions.dart';
import 'package:capsianfood/model/TasteClicks/RegisterViewModel.dart';
import 'package:capsianfood/model/TasteClicks/SelectedOptions.dart';
import 'package:capsianfood/networks/ReviewsNetworks.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CommentWithPicture.dart';


class AddRatings extends StatefulWidget {
  int businessId,categoryId,subcategoryId;
  RegisterViewModel userInfo;
  AddRatings({this.businessId,this.categoryId,this.subcategoryId,this.userInfo});

  @override
  _AddRatingsState createState() => _AddRatingsState();
}

class _AddRatingsState extends State<AddRatings> {
  StreamController _event =StreamController<dynamic>.broadcast();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  var groupValue,groupValue2;
  List<CustomerFeedBack> customerFeedback=[];
  List<Questions> questionList = [];
  @override
  void initState() {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
    //_feedbackController.customerFeedback.clear();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Review",
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
        // actions: [
        //   IconButton(
        //     icon:Icon(Icons.add, color: whiteTextColor, size: 30,),
        //     onPressed: (){
        //       Navigator.push(context,MaterialPageRoute(builder: (context)=>CommentWithPicture(businessId: widget.businessId,subcategoryId: widget.subcategoryId,categoryId: widget.categoryId,customerFeedBack: customerFeedback,customerInfo: widget.userInfo,)));
        //     },
        //   )
        // ],
      ),

      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: ()async{
          return Utils.check_connectivity().then((isConnected){
            if(isConnected){
              ReviewNetworks().getQuestionsforCustomer(0, 0, widget.subcategoryId, context).then((value) {
             setState(() {
               questionList =value;
             });
              });
              //_questionController.getQuestionsforCustomer(widget.subcategoryId, context);
            }
          });
        },
        child: Column(
          children: [
            Container(
                color: whiteTextColor,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-200,
                child: ListView.builder(itemCount: questionList.length, itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 6,
                        color: whiteTextColor,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          //height: 190,
                          decoration: BoxDecoration(
                            //color: whiteTextColor,
                            borderRadius: BorderRadius.circular(8),
                            //border: Border.all(color: color1, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(questionList[index].questionText,
                                  style: GoogleFonts.prompt(
                                    textStyle: TextStyle(
                                        color: yellowColor,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                              questionList[index].questionType==1?Center(
                                child: RatingBar.builder(
                                  initialRating: 0,
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    switch (index) {
                                      case 0:
                                        return Icon(
                                          Icons.sentiment_very_dissatisfied,
                                          color: Colors.red,
                                        );
                                      case 1:
                                        return Icon(
                                          Icons.sentiment_dissatisfied,
                                          color: Colors.redAccent,
                                        );
                                      case 2:
                                        return Icon(
                                          Icons.sentiment_neutral,
                                          color: Colors.amber,
                                        );
                                      case 3:
                                        return Icon(
                                          Icons.sentiment_satisfied,
                                          color: Colors.lightGreen,
                                        );
                                      case 4:
                                        return Icon(
                                          Icons.sentiment_very_satisfied,
                                          color: Colors.green,
                                        );
                                    }
                                  },
                                  onRatingUpdate: (rating) {
                                    customerFeedback.insert(index,
                                        CustomerFeedBack(
                                          businessId: widget.businessId,
                                          categoryId: questionList[index].categoryId,
                                          subCategoryId:questionList[index].subCategoryId,
                                          questionId:questionList[index].id,
                                          rating: rating,
                                          questions: questionList[index],

                                          selectedOptions: [],
                                        ));
                                  },
                                ),
                              ):questionList[index].questionType==2?Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  CustomRadioButton(
                                    enableShape: true,
                                    elevation: 0,
                                    //defaultSelected: "Sunday",

                                    enableButtonWrap: true,
                                    width: 120,
                                    autoWidth: true,
                                    unSelectedColor: Theme.of(context).canvasColor,
                                    buttonLables: [
                                      "Yes",
                                      "No"
                                    ],
                                    selectedBorderColor: Colors.white,
                                    unSelectedBorderColor: yellowColor,
                                    buttonValues: [
                                      5.0,
                                      2.0
                                    ],
                                    radioButtonValue: (value) {
                                      List<SelectedOptions> options=[];
                                      customerFeedback.insert(index,
                                          CustomerFeedBack(
                                              businessId: widget.businessId,
                                              categoryId: questionList[index].categoryId,
                                              subCategoryId: questionList[index].subCategoryId,
                                              questionId: questionList[index].id,
                                              questions: questionList[index],
                                              rating:  value,
                                              selectedOptions: []
                                          ));
                                    },
                                    selectedColor: yellowColor,
                                  )
                                ],
                              ):questionList[index].questionType==3?

                              Container(
                                child:CustomRadioButton(
                                  enableShape: true,
                                  elevation: 0,
                                  //defaultSelected: "Sunday",

                                  enableButtonWrap: true,
                                  width: 120,
                                  autoWidth: true,
                                  unSelectedColor: Theme.of(context).canvasColor,
                                  buttonLables: [
                                    for(var options in questionList[index].questionOptions)
                                      options.questionOptionText
                                  ],
                                  selectedBorderColor: Colors.white,
                                  unSelectedBorderColor: yellowColor,
                                  buttonValues: [
                                    for(var options in questionList[index].questionOptions)
                                      options.questionOptionText
                                  ],
                                  radioButtonValue: (value) {

                                    List<SelectedOptions> options=[];
                                    Iterable<QuestionOptions> option= questionList[index].questionOptions.where((element) => element.questionOptionText==value);
                                    options.add(SelectedOptions(questionOptionsId: option.elementAt(0).questionOptionId));
                                    customerFeedback.insert(index,
                                        CustomerFeedBack(
                                          businessId: widget.businessId,
                                          categoryId: questionList[index].categoryId,
                                          subCategoryId: questionList[index].subCategoryId,
                                          questionId: questionList[index].id,
                                          questions: questionList[index],
                                          rating:  option.elementAt(0).rating,
                                          selectedOptions: options,
                                        ));
                                    print(jsonEncode(customerFeedback));
                                  },
                                  selectedColor: yellowColor,
                                ),
                              ):Container()
                            ],
                          ),
                        ),
                      ),
                    );
                })
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>CommentWithPicture(businessId: widget.businessId,subcategoryId: widget.subcategoryId,categoryId: widget.categoryId,customerFeedBack: customerFeedback,customerInfo: widget.userInfo,)));
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
    );
  }
}
