import 'package:capsianfood/components/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gifimage/flutter_gifimage.dart';
import 'package:google_fonts/google_fonts.dart';


class ClientTimerScreen extends StatefulWidget {
  var orderDetails;

  ClientTimerScreen({this.orderDetails});

  @override
  _ClientTimerScreenState createState() => _ClientTimerScreenState();
}

class _ClientTimerScreenState extends State<ClientTimerScreen> with TickerProviderStateMixin {
  Animation _animation;
  AnimationController _controller, _animationController;
  int levelClock = 900;
  GifController controller,controller1;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    setState(() {
      if(widget.orderDetails['orderStatus'] == 4){
        levelClock = widget.orderDetails['estimatedPrepareTime']!=null?widget.orderDetails['estimatedPrepareTime']*60:600;

      }else if(widget.orderDetails['orderStatus'] == 6){
        levelClock = widget.orderDetails['estimatedPrepareTime']!=null?widget.orderDetails['estimatedPrepareTime']*60:600;

      }else{
        levelClock = 900;
      }
    });
    // TODO: implement initState
    controller = GifController(vsync: this);
    controller1 = GifController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_){
      controller.repeat(min: 0,max: 150,period: Duration(seconds:7));
    });
    WidgetsBinding.instance.addPostFrameCallback((_){
      controller1.repeat(min: 0,max: 44,period: Duration(seconds:5));
    });
    // WidgetsBinding.instance.addPostFrameCallback((_){
    //   controller2.repeat(min: 0,max: 13,period: Duration(milliseconds: 200));
    //   controller4.repeat(min: 0,max: 13,period: Duration(milliseconds: 200));
    // });
    // controller3 = GifController(vsync: this,duration: Duration(milliseconds: 200),reverseDuration: Duration(milliseconds: 200));
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
            levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
    );

    _controller.forward();
    _animationController = AnimationController(vsync:this,duration: Duration(seconds: 2));
    _animationController.repeat(reverse: true);
    _animation =  Tween(begin: 1.0,end: 5.0).animate(_animationController)..addListener((){

    });
    super.initState();
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: yellowColor
        ),
        backgroundColor: BackgroundColor,
        title: Text('Details',
          style: TextStyle(
              color: yellowColor,
              fontSize: 22,
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,

      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              //colorFilter: new ColorFilter.mode(Colors.white.withOpacity(0.7), BlendMode.dstATop),
              image: AssetImage('assets/bb.jpg'),
            )
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: yellowColor, width: 2),
                color: BackgroundColor
              ),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height /3,
              //color: Colors.amberAccent,
              child: widget.orderDetails['orderStatus']==4?GifImage(
                controller: controller,
                image:AssetImage("assets/gifimage2.gif"),
                //AssetImage("assets/gifimage2.gif"),
              ):GifImage(
                controller: controller1,
                image: AssetImage('assets/deliveryBoygif.gif'),
                //AssetImage("assets/gifimage2.gif"),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      //color: Colors.amberAccent,
                      child: Center(
                        child: Text("Remaining Time",
                          style: TextStyle(
                                  fontSize: 30.0,
                                  fontWeight: FontWeight.bold,
                                  color: yellowColor,
                                  fontFamily: 'poppins'
                              ),
                        ),
                      ),
                    ),
                  ),
                  Countdown(
                    animation: StepTween(
                      begin: levelClock, // THIS IS A USER ENTERED NUMBER
                      end: 0,
                    ).animate(_controller),
                  ),
                 SizedBox(height: 25,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: BackgroundColor,
                          boxShadow: [BoxShadow(
                              color: yellowColor,
                              blurRadius: _animation.value,
                              spreadRadius: _animation.value
                          )]
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height /3.5,
                      child: Column(
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('Delivery Details',
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: yellowColor,
                                ),
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('ORDER ID: ',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: yellowColor
                                    ),
                                  ),
                                  Text(widget.orderDetails['id'].toString(),
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: PrimaryColor
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Date: ",
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                      color: yellowColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(widget.orderDetails['createdOn'].toString().substring(0,10),
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                      color: PrimaryColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(9.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 8, left: 8, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total: ",
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                      color: yellowColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(widget.orderDetails['grossTotal'].toString(),
                                  style: GoogleFonts.ubuntu(
                                    textStyle: TextStyle(
                                      color: PrimaryColor,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ],
                      ),

                    ),
                  ),
                ],
              )
            ),
          ],
        ),
      ),
    );
  }
}



class Countdown extends AnimatedWidget {
  Countdown({Key key, this.animation}) : super(key: key, listenable: animation);
  Animation<int> animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString()}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Text(
      "$timerText",
      style: TextStyle(
        fontSize: 55,
        fontWeight: FontWeight.bold,
        color: PrimaryColor,
      ),
    );
  }
}