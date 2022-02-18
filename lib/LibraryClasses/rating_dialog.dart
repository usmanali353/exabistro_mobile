//library rating_dialog;
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';

class _RatingDialogState extends State<RatingDialog> {
  TextEditingController mycomment;
  int _rating = 0;
  List myList=[];

  List<Widget> _buildStarRatingButtons() {
    List<Widget> buttons = [];

    for (int rateValue = 1; rateValue <= 5; rateValue++) {
      final starRatingButton = IconButton(
          icon: Icon(_rating >= rateValue ? Icons.star : Icons.star_border,
              color: widget.accentColor, size: 35),
          onPressed: () {
            setState(() {
              _rating = rateValue;
            });
          });
      buttons.add(starRatingButton);
    }

    return buttons;
  }


  @override
  void initState() {
    mycomment=TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final String commentText =
    _rating >= 4 ? widget.positiveComment : widget.negativeComment;
    // final Color commentColor = _rating >= 4 ? Colors.green[600] : Colors.red;

    return AlertDialog(
      contentPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          widget.icon,
          const SizedBox(height: 15),
          Text(widget.title,
              style:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          // Text(
          //   widget.description,
          //   textAlign: TextAlign.center,
          // ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: mycomment,
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
              obscureText: false,
              // decoration: InputDecoration(
              //   focusedBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Colors.amberAccent, width: 1.0)
              //   ),
              //   enabledBorder: OutlineInputBorder(
              //       borderSide: BorderSide(color: Color(0xFF172a3a), width: 1.0)
              //   ),
              //   labelText: "Comment",
              //   labelStyle: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
              //
              // ),
              textInputAction: TextInputAction.next,
//                                  focusNode: focusEmail,
//                                  onFieldSubmitted: (v) {
//                                    FocusScope.of(context).requestFocus(focusEmail);
//                                  },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildStarRatingButtons(),
          ),
          Visibility(
            visible: _rating > 0,
            child: Column(
              children: <Widget>[
                const Divider(),
                FlatButton(
                  child: Text(
                    widget.submitButton,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: widget.accentColor,
                        fontSize: 18),
                  ),
                  onPressed: () {
                    if(widget.uId!=null){
                      var reviewsData ={
                        "Id":widget.uId,
                        "Rating":_rating,
                        "Comments":mycomment.text,
                        "CreatedBy":widget.customerId,
                        "CreatedOn":"11/12/2020",
                        "StoreId":widget.storeId,
                        "ProductId":widget.productId,
                        "CustomerId":widget.customerId
                      };
                      print(reviewsData);
                      networksOperation.updateReviews(context, widget.token, reviewsData).then((value) {
                        if(value!=null){
                          Navigator.pop(context);
                          Navigator.of(context).pop();
                        }
                      });
                    }else{
                      var reviewsData ={
                        "Rating":_rating,
                        "Comments":mycomment.text,
                        "CreatedBy":widget.customerId,
                       // "CreatedOn":"11/12/2020",
                        "StoreId":widget.storeId,
                        "ProductId":widget.productId,
                        "CustomerId":widget.customerId
                      };
                      print(reviewsData);
                      networksOperation.addReviews(context, widget.token, reviewsData).then((value) {
                        if(value!=null){
                          Navigator.pop(context);
                          Navigator.of(context).pop();
                        }
                      });
                    }



                    myList.add({
                      "rating": _rating,
                      "comment":mycomment.text
                    });
                    widget.onSubmitPressed(_rating);
                    // print(mycomment.text);
                    //widget.onSubmitPressed(_rating,mycomment);
                  },
                ),
                Visibility(
                  visible: commentText.isNotEmpty,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 5),
                      Text(
                        commentText,
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                Visibility(
                  visible:
                  _rating <= 3 && widget.alternativeButton.isNotEmpty,
                  child: FlatButton(
                    child: Text(
                      widget.alternativeButton,
                      style: TextStyle(
                          color: widget.accentColor,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onAlternativePressed();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RatingDialog extends StatefulWidget {
  var productId,storeId,customerId,token,uId;
  final String title;
  final String description;
  final String submitButton;
  final String alternativeButton;
  final String positiveComment;
  final String negativeComment;
  final Widget icon;
  final Color accentColor;
  final ValueSetter<int> onSubmitPressed;
  // final ValueSetter<List> onSubmitPressed;
  final VoidCallback onAlternativePressed;

  RatingDialog(
      {@required this.icon,
        @required this.title,
        @required this.description,
        @required this.onSubmitPressed,
        @required this.submitButton,
        this.accentColor = Colors.blue,
        this.alternativeButton = "",
        this.positiveComment = "",
        this.negativeComment = "",
        this.onAlternativePressed,
        this.productId,
        this.customerId,
        this.uId,
        this.storeId,
        this.token
      });

  @override
  _RatingDialogState createState() => new _RatingDialogState();
}
