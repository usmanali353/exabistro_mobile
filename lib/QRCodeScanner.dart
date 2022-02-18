import 'package:capsianfood/Utils/Utils.dart';
import 'package:capsianfood/components/constants.dart';
import 'package:capsianfood/networks/network_operations.dart';
import 'package:capsianfood/screens/CutomerPannel/Home/Screens/FoodDetail.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/CutomerPannel/Home/MainScreen.dart';


const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

class QRScanner extends StatefulWidget {
  const QRScanner({
    Key key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRScanner> {
  var qrText = '';
  var flashState = flashOn;
  var cameraState = frontCamera;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
 String token;

  var tableData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SharedPreferences.getInstance().then((value) {
      setState(() {
        this.token = value.getString("token");
      });
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner", style: TextStyle(
            color: yellowColor, fontSize: 22, fontWeight: FontWeight.bold
        ),
        ),
        centerTitle: true,
        backgroundColor: BackgroundColor,
        actions: [
          IconButton(
            icon: FaIcon(flashState=="flashOn"?Icons.flash_off:Icons.flash_on, color: yellowColor,),
            onPressed: () {
              if (controller != null) {
                controller.toggleFlash();
                if (_isFlashOn(flashState)) {
                  setState(() {
                    flashState = flashOff;
                  });
                } else {
                  setState(() {
                    flashState = flashOn;
                  });
                }
              }
            },
            // child:
            // Text(flashState, style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isFlashOn(String current) {
    return flashOn == current;
  }

  bool _isBackCamera(String current) {
    return backCamera == current;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code;
      });
      Utils.showSuccess(context, qrText);
        print(qrText);
        if(qrText!="")
          {
            controller.pauseCamera();
            if(qrText.contains("Store/",0)){
              print(qrText.replaceAll("Store/", ""));
              Navigator.push(context, MaterialPageRoute(builder:(context)=>HomePage(int.parse(qrText.replaceAll("Store/", "")))));
              //controller.resumeCamera();
            }else if(qrText.contains("http://dev.exabistro.com/StoreMenu/",0)){
              print(qrText.replaceAll("qwetyuio"+"http://dev.exabistro.com/StoreMenu/", ""));
              Navigator.push(context, MaterialPageRoute(builder:(context)=>HomePage(int.parse(qrText.replaceAll("http://dev.exabistro.com/StoreMenu/", "")))));
            }
            else if(qrText.contains("Table/",0)){
              networksOperation.getTableById(context,int.parse(qrText.replaceAll("Table/", ""))).then((value) {
                  Navigator.push(context, MaterialPageRoute(builder:(context)=>HomePage(value['storeId'])));
                SharedPreferences.getInstance().then((value) {
                  setState(() {
                    value.setString("tableId", qrText.replaceAll("Table/", ""));
                  });
                });
              });
              controller.resumeCamera();
            } else if(qrText.contains("http://dev.exabistro.com/#/StoreMenu/",0)){
              networksOperation.getTableById(context,int.parse(qrText.replaceAll("http://dev.exabistro.com/#/StoreMenu/", ""))).then((value) {
                Navigator.push(context, MaterialPageRoute(builder:(context)=>HomePage(value['storeId'])));
                SharedPreferences.getInstance().then((value) {
                  setState(() {
                    value.setString("tableId", qrText.replaceAll("Table/", ""));
                  });
                });
              });
              controller.resumeCamera();
            }else if(qrText.contains("Product/",0)){
              networksOperation. getProductById(context, int.parse(qrText.replaceAll("Product/", ""))).then((value) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FoodDetails(token,value,value.storeId),));
                SharedPreferences.getInstance().then((value) {
                  setState(() {
                    value.setString("id", qrText.replaceAll("Product/", ""));
                  });
                });
              });
              controller.resumeCamera();
            }else{
              Utils.showError(context, "No Record Found");
            }
          }else{
          Utils.showError(context, "No Data Found");
        }

        qrText.contains("store",0);

    });
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}