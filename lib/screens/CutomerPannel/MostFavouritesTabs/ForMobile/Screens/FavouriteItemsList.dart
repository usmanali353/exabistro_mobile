import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Products.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Home/Screens/Additional_details.dart';


class FavouriteItemsList extends StatefulWidget {
  var token,userId;

  FavouriteItemsList(this.token, this.userId);

  @override
  _FavouriteItemsListState createState() => _FavouriteItemsListState();
}

class _FavouriteItemsListState extends State<FavouriteItemsList> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();
  bool isListVisible = false;
  bool isFavourite;
  List<Products> productlist=[];



  @override
  void initState() {
    Utils.check_connectivity().then((value) {
      if (value) {
        SharedPreferences.getInstance().then((value) {
              print(value.getString("userId"));
            networksOperation.getAllFavouriteByUserId(context,int.parse(value.getString("userId"))).then((
                value) {
              setState(() {
                isListVisible=true;
                productlist = value;
            });
          });
        });
      }
    });
   // networksOperation.getAllFavouriteByUserId()


    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: (){
          return Utils.check_connectivity().then((result){
            if(result){
              SharedPreferences.getInstance().then((value) {
                print(value.getString("userId"));
                networksOperation.getAllFavouriteByUserId(context,int.parse(value.getString("userId"))).then((
                    value) {
                  productlist.clear();
                  setState(() {
                    productlist = value;
                  });
                });
              });
            }else{
              Utils.showError(context, "Network Error");
            }
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/bb.jpg'),
              )
          ),
          child: isListVisible==true&&productlist.length>0? Container(
            child: ListView.builder(itemCount: productlist!=null?productlist.length:0, itemBuilder: (context, index){
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.20,
                  secondaryActions: <Widget>[
                    // IconSlideAction(
                    //   icon: Icons.edit,
                    //   color: blueColor,
                    //   caption: 'Update',
                    //   // onTap: () async {
                    //   //   //print(barn_lists[index]);
                    //   //   Navigator.push(context,MaterialPageRoute(builder: (context)=>update_Sizes(sizes[index])));
                    //   // },
                    // ),
                    IconSlideAction(
                      icon: Icons.highlight_off,
                      color: Colors.red,
                      caption: 'Remove',
                      onTap: () async {
                      SharedPreferences.getInstance().then((value) {
                        networksOperation.addProductFavourite(context,widget.token, productlist[index].id,int.parse(value.getString("userId"))).then((value){
                          if(value!=null)
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                        });
                      });
                      WidgetsBinding.instance
                          .addPostFrameCallback((_) => _refreshIndicatorKey.currentState.show());
                      },
                    ),
                  ],
                  child: Card(
                    elevation: 8,
                    child: InkWell(
                      onTap: () {
                        print(productlist[index].productSizes);
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AdditionalDetail(productlist[index].id,productlist[index],null),));

                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 95,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          //border: Border.all(color: Colors.orange, width: 1)
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 5,),
                            Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                //color: yellowColor,
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(productlist[index].image!=null?productlist[index].image:'https://www.hearthsidecabinrentals.com/wp-content/uploads/2017/11/A-variety-of-foods-from-a-breakfast-buffet-on-a-table.jpg',),//AssetImage('assets/food6.jpeg', )
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child:
                                      LikeButton(
                                        size: 30,
                                        circleColor:
                                        CircleColor(start: Colors.red, end: Colors.red),
                                        bubblesColor: BubblesColor(
                                          dotPrimaryColor: Colors.red,
                                          dotSecondaryColor: Colors.red,
                                        ),
                                        likeBuilder: (bool isLiked) {
                                          return FaIcon(
                                            FontAwesomeIcons.solidHeart,
                                            color: Colors.red,//isLiked ? Colors.red : Colors.grey,
                                            size: 30
                                          );
                                        },
                                        // likeCount: 665,
                                        // countBuilder: (int count, bool isLiked, String text) {
                                        //   var color = isLiked ? Colors.deepPurpleAccent : Colors.grey;
                                        //   Widget result;
                                        //   if (count == 0) {
                                        //     result = Text(
                                        //       "love",
                                        //       style: TextStyle(color: color),
                                        //     );
                                        //   } else
                                        //     result = Text(
                                        //       text,
                                        //       style: TextStyle(color: color),
                                        //     );
                                        //   return result;
                                        // },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            VerticalDivider(color: yellowColor,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5,),
                                Text(
                                  productlist[index].name,
                                  style: TextStyle(
                                    color: yellowColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    //fontStyle: FontStyle.italic,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Restaurant: ",
                                      style: TextStyle(
                                        color: yellowColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    Text(
                                      productlist[index].storeName,
                                      style: TextStyle(
                                        color: blueColor,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            )
                          ],
                        )
                      ),
                    ),
                  ),
                ),
              );
            }),
          ):isListVisible==false?Center(
            child: SpinKitSpinningLines(
              lineWidth: 5,
              color: yellowColor,
              size: 100.0,
            ),
          ):isListVisible==true&&productlist.length==0?Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/noDataFound.png")
                  )
              ),
            ),
          ):
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/noDataFound.png")
                )
            ),
          ),
        ),
      ),
    );
  }
}
