import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:api_cache_manager/models/cache_db_model.dart';
import 'package:api_cache_manager/utils/cache_manager.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

class Utils{
   static String baseUrl(){
     //return "http://192.236.147.77:9000/api/";
     return "http://173.212.235.106:8500/api/";
     //return "http://172.28.52.13:45455/api/";
   }
   static String ReviewBaseUrl(){
     //return "http://iibtechnology-001-site1.dtempurl.com/api/";
     return "http://173.212.235.106:3400/api/";
   }
   static bool validateStructure(String value){
     RegExp regExp = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^\w\s]).{6,}$');
     return regExp.hasMatch(value);
   }
   static bool validateEmail(String value){
     RegExp regExp=  RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
     return regExp.hasMatch(value);
   }

   static Future addOfflineData(String key,String offlineData)async{
     APICacheDBModel cacheDBModel = new APICacheDBModel(
         key: key, syncData: offlineData);
     await APICacheManager().addCacheData(cacheDBModel);
   }

   static void deleteOfflineData(String key)async{
     await APICacheManager().deleteCache(key);
   }

   static Future<bool> checkOfflineDataExists(String key)async{
     return await APICacheManager().isAPICacheKeyExist(key);
   }

   static Future<APICacheDBModel> getOfflineData(String key)async{
     return await APICacheManager().getCacheData(key);
   }

   static Future<ConnectivityResult> check_connection() async {
     return await (Connectivity().checkConnectivity());
   }

   static Future<bool> check_connectivity () async{
     bool result = await DataConnectionChecker().hasConnection;
     return result;
   }
   static dynamic myEncode(dynamic item){
     if(item is DateTime)
       return item.toIso8601String();
   }
   static void showSuccess(BuildContext context,String message){
     Flushbar(
       backgroundColor: Colors.green,
       duration: Duration(seconds: 3),
       message: message,
     ).show(context);

   }
   static void showError(BuildContext context,String message){
     Flushbar(
       backgroundColor: Colors.red,
       duration: Duration(seconds: 3),
       message: message,
     ).show(context);

   }
   static Map<String, dynamic> parseJwt(String token) {
     final parts = token.split('.');
     if (parts.length != 3) {
       throw Exception('invalid token');
     }

     final payload = _decodeBase64(parts[1]);
     final payloadMap = json.decode(payload);
     if (payloadMap is! Map<String, dynamic>) {
       throw Exception('invalid payload');
     }

     return payloadMap;
   }
   static String _decodeBase64(String str) {
     String output = str.replaceAll('-', '+').replaceAll('_', '/');

     switch (output.length % 4) {
       case 0:
         break;
       case 2:
         output += '==';
         break;
       case 3:
         output += '=';
         break;
       default:
         throw Exception('Illegal base64url string!"');
     }

     return utf8.decode(base64Url.decode(output));
   }

   static Future<String> translate(String input)async{
     final translator=GoogleTranslator();
     var trans=await translator.translate(input,to:"en");
    return trans.text;
   }
   static Future<File> getImage() async {
     var image = await ImagePicker.pickImage(source: ImageSource.gallery);
     return image;
   }

   // static TwilioFlutter initializeTwilio(){
   //  var twilioFlutter = TwilioFlutter(
   //       accountSid : 'AC6414a8b9b8c39d810990bc24cd2ef679', // replace *** with Account SID
   //       authToken : '961149c8d93400faf901e04ef16366af',  // replace xxx with Auth Token
   //       twilioNumber : '+19065694110'  // replace .... with Twilio Number
   //   );
   //  return twilioFlutter;
   // }
   // static sendMessage(String number,String message){
   //
   //   initializeTwilio().sendSMS(
   //       toNumber : number,
   //       messageBody : message);
   // }
   static void shareImage(BuildContext context,Uint8List pngBytes) async{
     try{
       var rng = new Random();

       Directory tempDir = await getTemporaryDirectory();

       String tempPath = tempDir.path;

       File file = new File('$tempPath'+ (rng.nextInt(10000)).toString() +'.png');

       await file.writeAsBytes(pngBytes);
       Share.shareFiles([file.path], text:"Please Scan this qr code to get details");
     }catch(e){
       showError(context,e.toString());
     }
   }
   static Future<File> urlToFile(BuildContext context,String imageUrl) async {
     ProgressDialog pd=ProgressDialog(context);
     pd.show();
     try{
       var rng = new Random();

       Directory tempDir = await getTemporaryDirectory();

       String tempPath = tempDir.path;

       File file = new File('$tempPath'+ (rng.nextInt(10000)).toString() +'.png');

       http.Response response = await http.get(imageUrl);
       if(response.statusCode==200){
         pd.hide();
         await file.writeAsBytes(response.bodyBytes);
       }else{
         pd.hide();
         Utils.showError(context, response.statusCode.toString());
       }
       return file;
     }catch(e){
       pd.hide();
     }
     return null;
   }
   static Future<bool> isLogin()async{
     bool res=true;
     SharedPreferences.getInstance().then((value) {
       var token = value.getString("token");
       if(token!=null){
         res = true;
       }
         });
     return res;
   }

   /// Review

   static String getQuestionType(int id){
     if(id==1){
       return "Star Rating";
     }else if(id==2){
       return "Yes/No";
     }else if(id==3){
       return "Radio Button";
     }
   }

}