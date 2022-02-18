import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListComponent {
  Widget MenuList(context,String title, String image ,String compo1,String compo2,String compo3,
      String compo4,String compo5,String compo6) {
    return
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width * 0.98,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade300
            ),
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(compo1!=null?compo1:''),
                            SizedBox(width: 5,),
                            Text(compo2!=null?compo2:''),
                            SizedBox(width: 5,),
                            Text(compo3!=null?compo3:''),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(compo4!=null?compo4:''),
                            SizedBox(width: 5,),
                            Text(compo5!=null?compo5:''),
                            SizedBox(width: 5,),
                            Text(compo6!=null?compo6:''),
                          ],
                        )
                      ],
                    ),
                    leading: Container(decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                        child: Image.asset('assets/cover1.png',fit: BoxFit.fill,height: 50,width: 50,)
                    ),
                  )
              ),
            ),
          ),
          SizedBox(height: 10,),
        ],
      );

//        ],
//      );
  }
}