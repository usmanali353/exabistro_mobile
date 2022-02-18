import 'dart:convert';
import 'dart:typed_data';

import 'package:capsianfood/model/PurchaseOrder.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class OverallPOPDFLaout extends StatefulWidget {
  var orderId;List<PurchaseOrderItem> orderItems;var storeName,image,token;
  OverallPOPDFLaout(this.orderId,this.orderItems,this.storeName,this.image,this.token);

  @override
  _PDFLaoutState createState() => _PDFLaoutState();
}

class _PDFLaoutState extends State<OverallPOPDFLaout> {
  var pdf = pw.Document;
  List allUnitList=[];
  @override
  void initState() {
    networksOperation.getStockUnitsDropDown(context,widget.token).then((value) {
      if(value!=null)
      {
        setState(() {
          allUnitList.clear();
          allUnitList = value;
        });
      }
    });
    super.initState();
  }
  String getUnitName(int id){
    String size="";
    if(id!=null&&allUnitList!=null){
      for(int i = 0;i < 5;i++){
        if(allUnitList[i]['id'] == id) {
          size = allUnitList[i]['name'];
        }
      }
    }
    return size;
  }
  String getOrderType(int id){
    String status;
    if(id!=null){
      if(id ==0){
        status = "None";
      }else if(id ==1){
        status = "Dine-In";
      }else if(id ==2){
        status = "Take Away";
      }else if(id ==3){
        status = "Delivery";
      }
      return status;
    }else{
      return "";
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(title: Text("PurchaseOrder Details")),
        body: PdfPreview(
          allowSharing: true,
          allowPrinting: true,
          build: (format) => _generatePdf(format,"Order Details"),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final pdf = pw.Document();
    final PdfImage img = await pdfImageFromImageProvider(pdf: pdf.document, image: MemoryImage(widget.image));
    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          return pw.Column(
              children: [
                pw.Padding(
                  padding: pw.EdgeInsets.only(top: 50),
                  child: pw.Column(
                      children: [
                        // pw.Row(
                        //     children: [
                        // pw.Column(children: [
                        //   pw.Text("Store Detail",style: pw.TextStyle(fontSize:30,fontWeight: pw.FontWeight.bold)),
                        //
                        // ]),
                        //   pw.Column(children: [
                        //
                        //   ])
                        // ]),
                        pw.Center(
                            child: pw.Image(img,width: 80,height:80)
                        ),
                        pw.Text(widget.storeName,style: pw.TextStyle(fontSize:25,fontWeight: pw.FontWeight.bold)),
                        pw.Text("PurchaseOrder # "+widget.orderId.toString(),style: pw.TextStyle(fontSize:18,fontWeight: pw.FontWeight.bold)),
                        pw.Text("Date: "+widget.orderItems[0].createdOn.toString().substring(0,10),style: pw.TextStyle(fontSize:18,fontWeight: pw.FontWeight.bold))
                      ]
                  ),
                ),
                pw.Center(
                    child:pw.Padding(
                      padding: pw.EdgeInsets.all(50),
                      child:pw.Table(
                        border: pw.TableBorder(width: 1,),
                        children: [
                          pw.TableRow(
                              children: [
                                pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(8),child:pw.Text('Name', style: pw.TextStyle(fontSize: 15.0)))]),
                                pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(8),child:pw.Text('Qty', style: pw.TextStyle(fontSize: 15.0)))]),
                                pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(8),child:pw.Text('Unit', style: pw.TextStyle(fontSize: 15.0)))]),
                                pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(8),child:pw.Text('Vendor', style: pw.TextStyle(fontSize: 15.0)))]),
                              ]
                          ),
                          for(int i=0;i<widget.orderItems.length;i++)
                            pw.TableRow(
                                children: [
                                  pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(8),child:pw.Text((){
                                    // List dealItems=[];
                                    // if(!widget.orderItems[i]["isDeal"]){
                                    //   return widget.orderItems[i]['name']+" (${widget.orderItems[i]['sizeName']}) x${widget.orderItems[i]['quantity'].toString()}";
                                    // }else if(widget.orderItems[i]["isDeal"]) {
                                    //   for (int j = 0; j < widget.orderItems[i]["deal"]["productDeals"].length; j++)
                                    //     dealItems.add(widget.orderItems[i]["deal"]["productDeals"][j]['productName'] + "  (${widget.orderItems[i]["deal"]["productDeals"][j]['sizeName'].toString()}) x ${widget.orderItems[i]["deal"]["productDeals"][j]['quantity'].toString()}\n");
                                    //   return dealItems.toString().replaceAll("[", " ").replaceAll("]", "").replaceAll(",", "");
                                    // }else
                                    //   return "-";
                                    return widget.orderItems[i].stockItemName+"  x ${widget.orderItems[i].itemQuantity.toString()}  (${getUnitName(widget.orderItems[i].unit)})";

                                  }(), style: pw.TextStyle(fontSize: 10.0),textAlign: pw.TextAlign.justify))]),
                                  pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(8),child:pw.Text((){
                                    return"  x ${widget.orderItems[i].itemQuantity.toString()}";

                                  }(), style: pw.TextStyle(fontSize: 10.0),textAlign: pw.TextAlign.justify))]),
                                  pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(8),child:pw.Text((){
                                    return" ${getUnitName(widget.orderItems[i].unit)}";

                                  }(), style: pw.TextStyle(fontSize: 10.0),textAlign: pw.TextAlign.justify))]),
                                  pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(8),child:pw.Text((){
                                    // List<String> toppingName=[];
                                    // if(!widget.orderItems[i]["isDeal"]){
                                    //   for(int j=0;j<widget.orderItems[i]['orderItemsToppings'].length;j++)
                                    //     toppingName.add((widget.orderItems[i]['orderItemsToppings'][j]['name']+" x ${widget.orderItems[i]['orderItemsToppings'][j]["quantity"]}"));
                                    //   return toppingName.toString().replaceAll("["," ").replaceAll("]", " ");
                                    // }else
                                    //   return "-";
                                    return widget.orderItems[i].vendorName;

                                  }(), style: pw.TextStyle(fontSize: 10.0)))]),
                                  //pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(16),child:pw.Text("x "+widget.orderItems[i]['quantity'].toString(), style: pw.TextStyle(fontSize: 20.0)))]),
                                ]
                            )
                        ],
                      ),
                    )
                ),

              ]
          );
        },
      ),
    );

    return pdf.save();
  }
}