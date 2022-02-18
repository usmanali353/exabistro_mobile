import 'dart:ui';
import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/model/ProductSizes.dart';
import 'package:capsianfood/model/Sizes.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';


class ProductDetails extends StatefulWidget{
  var token,categoryId,subCategoryId,productId,productName,productDescription,image,storeId;

  ProductDetails(this.token, this.categoryId, this.subCategoryId,this.productId,this.productName,this.productDescription,this.image,this.storeId);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ProductDetailsState(token,categoryId,subCategoryId,productId,productName,productDescription,image,storeId);
  }

}
class ProductDetailsState extends State<ProductDetails>{
  var cards = <Card>[];
  var token,categoryId,subCategoryId,productId,productName,productDescription,storeId,image;
  var dietDropDowns;
  List<Sizes> sizes=[];
  List sizesList=[];
  var priceTECs = <TextEditingController>[];
  ProductDetailsState(this.token, this.categoryId, this.subCategoryId,this.productId,this.productName,this.productDescription,this.image,this.storeId);
  List<String> products=[],time=[];
  var selected_size=[];
  @override
  void initState() {
    print(widget.storeId);
    print(storeId);
    Utils.check_connectivity().then((result){
      if(result){
        networksOperation.getSizes(context,storeId).then((response){
          if(response!=null){
            setState(() {
              sizes=response;
              print(sizes.toString()+"jhbjhkjghgkgjhbhjvj");
              sizesList.clear();
              for (int i = 0; i < sizes.length; i++) {
                sizesList.add(sizes[i].name);
              }
              cards.add(createCard());
            });
          }else{

          }
        });
      }else{

      }
    });


    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor:  BackgroundColor,
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        title:Text("Add Sizes & Price",
          style: TextStyle(
              color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
          ),
        ),

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
    child: Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: cards.length,
            itemBuilder: (BuildContext context, int index) {
              return cards[index];
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RaisedButton(
            color: yellowColor,
            child: Text('ADD',
              style: TextStyle(
                  color: BackgroundColor, fontSize: 17, fontWeight: FontWeight.bold
              ),
            ),
            onPressed: () => setState(() => cards.add(createCard())),
          ),
        )
      ],
    )
      ),
      floatingActionButton:
      FloatingActionButton(child: Icon(Icons.done), onPressed:() async{
            var price,sizeId;
            List<Map> entries = [];

            for(int i=0;i<cards.length;i++){
              if(priceTECs[i].text!=null) {
                price = double.parse(priceTECs[i].text);
              }
              if(selected_size!=null&&selected_size.length>0){
                sizeId=sizes[selected_size[i]].id;
              }
              entries.add(ProductSize(sizeId: sizeId,price: price).toJson());
            }
            print(entries);
            print(productName);
           // dynamic product;
           if(productId == null){
             print("jfgfhgfhghjihgfchkugf");
             dynamic product ={
               "name": productName,
               "description":productDescription,
               "storeid":storeId,
               "categoryId":categoryId,
               "subCategoryId":subCategoryId,
               "productSizes":entries,
               "image": image,
               "IsVisible":true,

             };
              print(product);

              networksOperation.addProduct(context, token, product)
                  .then((response){
                if(response){
                  Navigator.pop(context,'Refresh');
                  Navigator.pop(context,'Refresh');
                  Utils.showSuccess(context, "Added Successfully");
                }
              });

           }else{
             dynamic product ={
               "id":productId,
               "name": productName,
               "description":productDescription,
               "storeid":storeId.toString(),
               "categoryId":categoryId.toString(),
               "subCategoryId":subCategoryId.toString(),
               "productSizes":entries,
               "image": image,
               "IsVisible":true,

             };
             print(product);
             // networksOperation.updateProduct(context, token, categoryId.toString(), subCategoryId.toString(), productId, productName, productDescription, storeId.toString(), image)
             networksOperation.updateProduct(context, token, product)
                 .then((response){
               if(response){
                 Navigator.pop(context,'Refresh');
                 Navigator.pop(context,'Refresh');
                 // Navigator.of(context).pop();
                 // Navigator.pop(context);
                 // Navigator.pop(context);
                 Utils.showSuccess(context, "Successfully Update");
               }else{
                 Utils.showError(context, "Please Try Agian");
               }
             });
           }
      }),
    );

  }

  Card createCard() {
    var priceController = TextEditingController();
    priceTECs.add(priceController);
    return Card(

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
              color: BackgroundColor,
            border: Border.all(color: yellowColor, width: 2)
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Size ${cards.length + 1}',style: TextStyle(color: yellowColor,fontWeight: FontWeight.bold,fontSize: 20),),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: DropdownButtonFormField(
                     // hint: Text("Select Size"),
                      items: sizesList!=null?sizesList.map((trainer)=>DropdownMenuItem(
                        child: Text(trainer,style: TextStyle(color: yellowColor),),
                        value: trainer,
                      )).toList():[""].map((name) => DropdownMenuItem(
                          value: name, child: Text("$name",style: TextStyle(color: yellowColor),)))
                          .toList(),
                      decoration: InputDecoration(labelText: "Sizes",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            borderSide: BorderSide(color: yellowColor, width: 1.0)
                        ),
                      ),
                      onChanged: (value){
                        setState(() {
                          selected_size.insert(cards.length-1, sizesList.indexOf(value));

                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16,right: 16),
                    child: TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                       style: TextStyle(color: yellowColor),
                      decoration: InputDecoration(labelText: "Price",labelStyle: TextStyle(color: yellowColor, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(9.0),
                            borderSide: BorderSide(color: PrimaryColor, width: 1.0)
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                ]
            ),
          ),
        ),
      ),
    );
  }

}