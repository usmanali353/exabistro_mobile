import 'package:capsianfood/StoreHomePage.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/Stores.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class SearchedRestaurantList extends StatelessWidget {
   List<Store> storesList=[];
   var token;
   SearchedRestaurantList(this.storesList,this.token);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor ,
        title: Text("Searched Restaurant",
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: ListView.builder(
          itemCount: storesList.length,
          itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>StoreHomePage(token,storesList[index])));
                },
                child: Card(
                  elevation: 6,
                  child: Container(
                      decoration: BoxDecoration(
                        //border: Border.all(color: yellowColor),
                      ),
                      height: 230,
                      // width: 500,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
                                image: NetworkImage(storesList[index].image??"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg") ,//AssetImage('assets/bb.jpg'),
                              ),
                              //color: Colors.amberAccent,
                              borderRadius: BorderRadius.only(
                                //bottomRight: Radius.circular(15),
                                topLeft: Radius.circular(15),
                              ),
                            ),
                            height: 140,
                            // width: MediaQuery.of(context).size.width,
                            child: Stack(
                              children: [

                                Positioned(
                                  //top:-130,
                                  top: 0,
                                  left:5,
                                  bottom: 105,

                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                          color: TimeOfDay.now().hour>=int.parse(storesList[index].openTime.toString().substring(0,2)) || TimeOfDay.now().hour<=int.parse(storesList[index].closeTime.toString().substring(0,2))?Colors.green:Colors.red,
                                          //color: TimeOfDay.now().hour>=int.parse(storesList[index].openTime!=null?storesList[index].openTime.toString().substring(0,2):0) || TimeOfDay.now().hour<=int.parse(storesList[index].closeTime!=null?storesList[index].closeTime.toString().substring(0,2):0)?Colors.green:Colors.red,
                                          borderRadius: BorderRadius.circular(10),
                                          //border: Border.all(color: yellowColor)
                                        ) ,
                                        height: 20,
                                        width: 70,
                                        child: Center(
                                          child: Text
                                            ((){
                                            if(storesList[index].openTime!=null && storesList[index].closeTime!=null){
                                              if(TimeOfDay.now().hour>=int.parse(storesList[index].openTime.toString().substring(0,2)) || TimeOfDay.now().hour<=int.parse(storesList[index].closeTime.toString().substring(0,2))){
                                                return "Open";
                                              }else{
                                                return "Close";
                                              }
                                            }else{
                                              return "";
                                            }
                                          }(),
                                            // (TimeOfDay.now().hour.toString(),//storesList[index].openTime!=null?storesList[index].openTime:'',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              //fontWeight: FontWeight.bold
                                            ),
                                          ),
                                        )
                                    ),
                                  ),
                                ),
                                Positioned(
                                  //top:-130,
                                    top: 105,
                                    left:10,
                                    bottom: 0,

                                    child: Visibility(
                                      visible: storesList[index].dineIn!=null?storesList[index].dineIn:false,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: yellowColor,
                                              borderRadius: BorderRadius.circular(10),
                                              //border: Border.all(color: yellowColor)
                                            ) ,
                                            height: 60,
                                            width: 80,
                                            child: Center(
                                              child: Text('Dine-In',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  //fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            )
                                        ),
                                      ),
                                    )
                                ),
                                Positioned(
                                  //top:-130,
                                    top: 105,
                                    left:100,
                                    bottom: 0,

                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Visibility(
                                        visible: storesList[index].takeAway!=null?storesList[index].takeAway:false,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: yellowColor,
                                              borderRadius: BorderRadius.circular(10),
                                              //border: Border.all(color: yellowColor)
                                            ) ,
                                            height: 60,
                                            width: 80,
                                            child: Center(
                                              child: Text('Pick-Up',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  //fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            )
                                        ),
                                      ),
                                    )
                                ),
                                Positioned(
                                  //top:-130,
                                    top: 105,
                                    left:190,
                                    bottom: 0,

                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Visibility(
                                        visible: storesList[index].delivery!=null?storesList[index].delivery:false,
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: yellowColor,
                                              borderRadius: BorderRadius.circular(10),
                                              //border: Border.all(color: yellowColor)
                                            ) ,
                                            height: 60,
                                            width: 80,
                                            child: Center(
                                              child: Text('Delivery',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15,
                                                  //fontWeight: FontWeight.bold
                                                ),
                                              ),
                                            )
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(storesList[index].name!=null?storesList[index].name:'',
                                  style: TextStyle(
                                      color: TextColor1,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25
                                  ),
                                ),
                                FaIcon(FontAwesomeIcons.directions, color: yellowColor, size: 35,),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Text('${storesList[index].address}',
                              maxLines: 2,
                              style: TextStyle(
                                  color: TextLightColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12
                              ),
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
