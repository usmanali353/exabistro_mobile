import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';


class PDFLaout extends StatefulWidget {
  var orderId,orderItems,orderType,storeName,image;
  PDFLaout(this.orderId,this.orderItems,this.orderType,this.storeName,this.image);

  @override
  _PDFLaoutState createState() => _PDFLaoutState();
}

class _PDFLaoutState extends State<PDFLaout> {
  var pdf = pw.Document;
  @override
  void initState() {
    print(widget.orderItems[0].toString());
    super.initState();
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
      home: Scaffold(
        appBar: AppBar(title: Text("Order Details")),
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
                        pw.Center(
                            child: pw.Image(img,width: 100,height:100)
                        ),
                        pw.Text(widget.storeName,style: pw.TextStyle(fontSize:30,fontWeight: pw.FontWeight.bold)),
                        pw.Text("Order # "+widget.orderId.toString()),
                        pw.Text("Order Type: "+getOrderType(widget.orderType))
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
                                //pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(8),child:pw.Text('Size', style: pw.TextStyle(fontSize: 15.0)))]),
                                pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(8),child:pw.Text('Topping', style: pw.TextStyle(fontSize: 15.0)))]),
                              ]
                          ),
                          for(int i=0;i<widget.orderItems.length;i++)
                            pw.TableRow(
                                children: [
                                  pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(8),child:pw.Text((){
                                    List dealItems=[];
                                    if(!widget.orderItems[i]["isDeal"]){
                                      return widget.orderItems[i]['name']+" (${widget.orderItems[i]['sizeName']}) x${widget.orderItems[i]['quantity'].toString()}";
                                    }else if(widget.orderItems[i]["isDeal"]) {
                                      for (int j = 0; j < widget.orderItems[i]["deal"]["productDeals"].length; j++)
                                        dealItems.add(widget.orderItems[i]["deal"]["productDeals"][j]['productName'] + "  (${widget.orderItems[i]["deal"]["productDeals"][j]['sizeName'].toString()}) x ${widget.orderItems[i]["deal"]["productDeals"][j]['quantity'].toString()}\n");
                                      return dealItems.toString().replaceAll("[", " ").replaceAll("]", "").replaceAll(",", "");
                                    }else
                                      return "-";

                                  }(), style: pw.TextStyle(fontSize: 10.0),textAlign: pw.TextAlign.justify))]),
                                  pw.Column(children:[pw.Padding(padding: pw.EdgeInsets.all(8),child:pw.Text((){
                                    List<String> toppingName=[];
                                    if(!widget.orderItems[i]["isDeal"]){
                                      for(int j=0;j<widget.orderItems[i]['orderItemsToppings'].length;j++)
                                        toppingName.add((widget.orderItems[i]['orderItemsToppings'][j]['name']+" x ${widget.orderItems[i]['orderItemsToppings'][j]["quantity"]}"));
                                      return toppingName.toString().replaceAll("["," ").replaceAll("]", " ");
                                    }else
                                      return "-";

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