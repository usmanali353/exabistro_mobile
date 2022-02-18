import 'dart:typed_data';
import 'package:capsianfood/components/constants.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'dart:io' show Platform;
import 'package:image/image.dart';

import 'Utils/Utils.dart';
import 'model/Stores.dart';

class OrderPrint extends StatefulWidget {
  var orderObj,tableName;List itemList=[];
   Store storeObj;
  OrderPrint(this.orderObj, this.storeObj, this.itemList,this.tableName);

  @override
  _OrderPrintState createState() => _OrderPrintState();
}

class _OrderPrintState extends State<OrderPrint> {

  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;

  @override
  void initState() {
    if (Platform.isAndroid) {
      bluetoothManager.state.listen((val) {
        print('state = $val');
        if (!mounted) return;
        if (val == 12) {
          print('on');
          initPrinter();
        } else if (val == 10) {
          print('off');
          setState(() => _devicesMsg = 'Bluetooth Disconnect!');
        }
      });
    } else {
      initPrinter();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        title: Text('Select Device For Print',
          style: TextStyle(
            color: yellowColor,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            //fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor:  BackgroundColor,
      ),
      body: _devices.isEmpty
          ? Center(child: Text(_devicesMsg ?? ''))
          : ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (c, i) {
          return ListTile(
            leading: Icon(Icons.print, color: blueColor,),
            title: Text(_devices[i].name,  style: TextStyle(
              color: yellowColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              //fontStyle: FontStyle.italic,
            ),),
            subtitle: Text(_devices[i].address,  style: TextStyle(
              color: blueColor,
              fontSize: 17,
              fontWeight: FontWeight.w300,
              //fontStyle: FontStyle.italic,
            ),),
            onTap: () {
              _startPrint(_devices[i]);
            },
          );
        },
      ),
    );
  }

  void initPrinter() {
    _printerManager.startScan(Duration(seconds: 2));
    _printerManager.scanResults.listen((val) {
      if (!mounted) return;
      setState(() => _devices = val);
      if (_devices.isEmpty) setState(() => _devicesMsg = 'No Devices');
    });
  }

  Future<void> _startPrint(PrinterBluetooth printer) async {
    _printerManager.selectPrinter(printer);
    final result = await _printerManager.printTicket(await _ticket(PaperSize.mm58));
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(result.msg),
      ),
    );
  }

  Future<Ticket> _ticket(PaperSize paper) async {
    final ticket = Ticket(paper);
     Uint8List bytes;
    double total = 0;

    // Image assets
  // final ByteData data = await rootBundle.load('assets/store.png');
  //   Utils.urlToFile(context,widget.storeObj.qrCodeImage).then((value){
  //    setState(() {
  //      bytes = value.readAsBytesSync();
  //    });
  //   });
   // final Uint8List bytes = data.buffer.asUint8List();
    //final Image image = decodeImage(bytes);
    ticket.text(
      widget.storeObj.name,
      styles: PosStyles(align: PosAlign.center,height: PosTextSize.size2,width: PosTextSize.size2,),
      //linesAfter: 1,
    );
    ticket.text(
      widget.storeObj.address,
      styles: PosStyles(align: PosAlign.center,height: PosTextSize.size1,width: PosTextSize.size1,),
      //linesAfter: 1,
    );
    ticket.text(
      widget.storeObj.cellNo,
      styles: PosStyles(align: PosAlign.center,height: PosTextSize.size1,width: PosTextSize.size1,),
      linesAfter: 1,
    );
    ticket.row([
      PosColumn(text: 'Order#: ', width: 8,styles:PosStyles(bold: true)),
      PosColumn(text: '${widget.orderObj['id']}', width: 4,styles:PosStyles(bold: true)),
      //PosColumn(text: ' Table: ${widget.orderObj['orderType']==3?widget.orderObj['tableId'].toString():""}', width: 4,styles:PosStyles(bold: true)),
    ]);

    ticket.row([
      PosColumn(text: 'Date: ', width: 8,styles:PosStyles(bold: true)),
      PosColumn(text: '${widget.orderObj['createdOn'].toString().substring(0,10)}', width: 4),
    ]);
    ticket.row([
      PosColumn(text: 'Order Type:', width: 8,styles:PosStyles(bold: true)),
      PosColumn(text: ' ${widget.orderObj['orderType']==1?"Dine-In":widget.orderObj['orderType']==2?"Takeaway":"Delivery"}', width: 4,styles:PosStyles(bold: true)),
    ]);
    widget.orderObj['orderType']==1?ticket.row([
      PosColumn(text: 'Table: ', width: 8,styles:PosStyles(bold: true)),
      PosColumn(text: '${widget.tableName}', width: 4),
    ]):"";
    ticket.emptyLines(1);
    ticket.hr();
    ticket.row([
      PosColumn(text: 'Qty', width: 1,styles:PosStyles(bold: true)),
      PosColumn(text: ' Name', width: 8,styles:PosStyles(bold: true)),
      PosColumn(text: 'Size', width: 1,styles:PosStyles(bold: true)),
      PosColumn(text: 'Amount', width: 2,styles:PosStyles(bold: true)),
    ]);
    ticket.hr();
    for (var i = 0; i < widget.itemList.length; i++) {
      total += widget.itemList[i]['price'];
      //ticket.text(widget.itemList[i]['name']);

      ticket.row([
        PosColumn(text: '${widget.itemList[i]['quantity']}', width: 1,),
        PosColumn(text: ' ${widget.itemList[i]['name'].toString()}', width: 8,styles: PosStyles(align: PosAlign.left)),
        PosColumn(text: '(${widget.itemList[i]['sizeName'].toString().substring(0,1)})', width: 1),
       // PosColumn(text: '${ widget.itemList[i]['price']} ', width: 2),
        PosColumn(text: '${ widget.itemList[i]['totalPrice']} ', width: 2),
      ]);
      // ticket.row([
      //   PosColumn(text: '${"Olives\n Mashroom"}', width: 12),
      //   //PosColumn(text: '${ widget.itemList[i]['price']} x ${widget.itemList[i]['quantity']}', width: 4),
      //
      // ]);
      ticket.text('Topping', styles:PosStyles(bold: true),);
      for (var j = 0; j < widget.itemList[i]['orderItemsToppings'].length; j++) {
      //  total += widget.itemList[i]['price'];
        ticket.row([
          PosColumn(text: '-', width: 1, styles:PosStyles(bold: true)),
          PosColumn(text: 'x${widget.itemList[i]['orderItemsToppings'][j]['quantity']}', width: 2,),
          PosColumn(text: ' ${widget.itemList[i]['orderItemsToppings'][j]['additionalItem']['stockItemName']}', width: 5),
          PosColumn(text: ' ${ widget.itemList[i]['orderItemsToppings'][j]['price']} ', width: 4),
        ]);
      }
    }
    ticket.feed(1);
    ticket.hr();
    ticket.row([
      PosColumn(text: 'SubTotal', width: 9, styles: PosStyles(bold: true)),
      PosColumn(text: '${widget.orderObj['netTotal']}', width: 3, styles: PosStyles(bold: true)),
    ]);
    ticket.hr();
    for (var i = 0; i < widget.orderObj['orderTaxes'].length; i++) {
      ticket.row([
        PosColumn(text: ' ${widget.orderObj['orderTaxes'][i]['taxName']}', width: 9),
        PosColumn(text: '${ widget.orderObj['orderTaxes'][i]['amount']} ', width: 3),
      ]);
      // ticket.row([
      //   PosColumn(text: '${"Olives\n Mashroom"}', width: 12),
      //   //PosColumn(text: '${ widget.itemList[i]['price']} x ${widget.itemList[i]['quantity']}', width: 4),
      //
      // ]);
    }
    ticket.hr();
    ticket.row([
      PosColumn(text: 'Total', width: 9, styles: PosStyles(bold: true)),
      PosColumn(text: '${widget.orderObj['grossTotal'].toString()}', width: 3, styles: PosStyles(bold: true)),
    ]);
    ticket.hr();
    ticket.feed(2);
    ticket.text('Thank You',styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.text('Scan to Visit Our Website',styles: PosStyles(align: PosAlign.center, bold: true));
    ticket.emptyLines(1);
    ticket.qrcode("http://dev.exabistro.com/#/storeMenu/${widget.storeObj.id}");

    ticket.cut();

    return ticket;
  }

  @override
  void dispose() {
    _printerManager.stopScan();
    super.dispose();
  }

}