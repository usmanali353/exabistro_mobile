import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:capsianfood/screens/AdminPannel/Restarant&Stores/Restaurant/RestaurantList/constants.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class ProductCard extends StatelessWidget {
  const ProductCard({
    Key key,
    this.itemIndex,
    this.product,
    this.press,
    this.longpress
  }) : super(key: key);

  final int itemIndex;
  final dynamic product;
  final Function press,longpress;

  @override
  Widget build(BuildContext context) {
    // It  will provide us total height and width of our screen
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      // color: Colors.blueAccent,
      height: 180,
      child: InkWell(
        onLongPress: longpress,
        onTap: press,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            // Those are our background
            Container(
              height: 136,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: itemIndex.isEven ? kBlueColor : kSecondaryColor,
                boxShadow: [kDefaultShadow],
              ),
              child: Container(
                margin: EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
            ),
            // our product image
            Positioned(
              top: 45,
              right: 10,
              child: Hero(
                tag: '${product['id']}',
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    height: 115,
                    // image is square but we add extra 20 + 20 padding thats why width is 200
                    width: 115,
                    child: Image.network(product['image']!=null?product['image']:"http://www.4motiondarlington.org/wp-content/uploads/2013/06/No-image-found.jpg")
                  // child:Image.asset(
                  //   "assets/bb.jpg",
                  //   fit: BoxFit.cover,
                  // ),
                ),
              ),
            ),
            // Product title and price
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                height: 150,
                // our image take 200 width, thats why we set out total width - 200
                width: size.width - 150,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 12, bottom: 0),
                      child: Text(
                        product['name'],
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFAB00)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 0, bottom: 0),
                      child: Text(
                      product['website'],
                        //"helloossdxadadadADDDFSFDASGG",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF172a3a)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 2, bottom: 2),
                      child: Text(
                       product['phoneNo'],
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF172a3a)
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8, top: 0, bottom: 2),
                      child: Text(
                        product['email'],
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF172a3a)
                        ),
                      ),
                    ),
                    // it use the availabl
                    // it use the available space
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: kDefaultPadding * 1.5, // 30 padding
                        vertical: kDefaultPadding / 4, // 5 top and bottom
                      ),
                      decoration: BoxDecoration(
                        color: kBlueColor,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(22),
                          topRight: Radius.circular(22),
                        ),
                      ),
                      child: Text(
                        "${getStatus(product['statusId'])}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600
                        ),

                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String getStatus(int id){
    String status;

    if(id!=null){
      if(id==0){
        status = "Pending";
      }
      else if(id ==1){
        status = "Approve";
      }else if(id ==2){
        status = "Reject";
      }

      return status;
    }else{
      return "";
    }
  }

}
