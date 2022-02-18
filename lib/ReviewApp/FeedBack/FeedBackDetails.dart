import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/TasteClicks/CustomerFeedBack.dart';
import 'package:capsianfood/model/TasteClicks/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'CommentAndPicture.dart';



class FeedbackDetails extends StatefulWidget {
  List<CustomerFeedBack> customerFeedbacks;
  feedback f;
  FeedbackDetails(this.customerFeedbacks,this.f);

  @override
  _FeedbackDetailsState createState() => _FeedbackDetailsState();
}

class _FeedbackDetailsState extends State<FeedbackDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          widget.f.comment!=null||widget.f.image!=null?
          IconButton(
            icon: Icon(Icons.announcement, color: whiteTextColor,size:25,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> CommentAndPicture(widget.f.comment,widget.f.image)));
            },
          ):Container(),
        ],
        title: Text("Feedback Details",
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
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(itemCount:widget.customerFeedbacks.length, itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 6,
              color: whiteTextColor,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  //height: 70,
                  decoration: BoxDecoration(
                    //color: color1,
                    borderRadius: BorderRadius.circular(10),
                    //border: Border.all(color: color1, width: 2)
                  ),
                  child: ListTile(
                    title: Text(widget.customerFeedbacks[index].questions.questionText,
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                            color: yellowColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    subtitle: Text((){
                      if(widget.customerFeedbacks[index].questions.questionType==1){
                        return widget.customerFeedbacks[index].rating.toString()+" Stars Rating";
                      }else if(widget.customerFeedbacks[index].questions.questionType==2){
                        if(widget.customerFeedbacks[index].rating==5.0){
                          return "Yes";
                        }else
                          return "No";
                      }else if(widget.customerFeedbacks[index].questions.questionType==3&&widget.customerFeedbacks[index].selectedOptions.length>0){
                        List<String> selectedOptions=[];
                        for(int i=0;i<widget.customerFeedbacks[index].selectedOptions.length;i++){
                          selectedOptions.add(widget.customerFeedbacks[index].selectedOptions[i].questionOptions.questionOptionText);
                        }
                        return selectedOptions.toString().replaceAll("[","").replaceAll("]", "");
                      }else
                        return widget.customerFeedbacks[index].rating.toString();
                    }(),
                      style: GoogleFonts.prompt(
                        textStyle: TextStyle(
                            color: blueColor,
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    leading: FaIcon(
                      FontAwesomeIcons.comment,
                      color: yellowColor,
                      size: 35,
                    ),
                  )
              ),
            ),
          );
        }),
      ),
    );
  }
}
