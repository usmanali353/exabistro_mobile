import 'package:capsianfood/ReviewApp/Questions/UpdateQuestionOption.dart';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/QuestionOptions.dart';
import 'package:capsianfood/networks/ReviewsNetworks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionOptionsList extends StatefulWidget {
  int questionId;
  QuestionOptionsList(this.questionId);
  @override
  _QuestionOptionsListState createState() => _QuestionOptionsListState();
}

class _QuestionOptionsListState extends State<QuestionOptionsList> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  List<QuestionOptions> questionOption =[];

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
        // actions: [
        //   _accountController.getLoggedInUserData().role=="Admin"?
        //   IconButton(
        //     icon: Icon(Icons.add, color: color4,size:25,),
        //     onPressed: (){
        //       push(context,MaterialPageRoute(builder:(context)=>AddQuestionOptions(widget.questionId)));
        //     },
        //   ):Container()
        // ],
        title: Text("Question Options",
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
          return Utils.check_connectivity().then((isConnected){
            if(isConnected){
              ReviewNetworks().getQuestionOptions(widget.questionId,token,context).then((value) {
                setState(() {
                  questionOption =value;
                });
              });
            }else{
              Utils.showError(context,"Network not Available");
            }
          });
        },
        child: Container(
          color: whiteTextColor,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(itemCount:questionOption!=null?questionOption.length:0, itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.20,
                    secondaryActions: <Widget>[
                      IconSlideAction(
                        icon: Icons.edit,
                        color: Colors.blue,
                        caption: 'Update',
                        onTap: () async {
                         Navigator.push(context,MaterialPageRoute(builder:(context)=>UpdateOptions(questionOption[index])));
                        },
                      ),
                      IconSlideAction(
                        icon: Icons.visibility_off,
                        color: Colors.red,
                        caption: 'Visibility',
                        onTap: () async {
                          ReviewNetworks().changeQuestionOptionVisibility(questionOption[index].questionOptionId, context);
                        },
                      ),
                    ],
                    child: Card(
                      elevation: 6,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 70,
                        decoration: BoxDecoration(
                          //color: color1,
                          borderRadius: BorderRadius.circular(10),
                          //border: Border.all(color: yellowColor, width: 2)
                        ),
                        child: ListTile(
                          onTap: (){
                            // Navigator.push(context,MaterialPageRoute(builder:(context)=>BusinessSubCategoryList(widget.q,categoriesController.categoryList[index].id)));
                          },
                          title: Text(questionOption!=null&&questionOption[index].questionOptionText!=null?questionOption[index].questionOptionText:"-",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                  color: yellowColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          subtitle: Text(questionOption!=null&&questionOption[index].rating!=null?questionOption[index].rating.toString():"-",
                            style: GoogleFonts.prompt(
                              textStyle: TextStyle(
                                  color: blueColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          leading: FaIcon(
                            FontAwesomeIcons.building,
                            color: yellowColor,
                          ),
                        ),
                      ),
                    )
                ),
              );
          }),
        ),
      ),
    );
  }
}
