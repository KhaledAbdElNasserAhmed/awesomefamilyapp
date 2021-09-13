import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'wrapper.dart';

class SplashScreen extends StatefulWidget {


  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  final storage = new FlutterSecureStorage();
  String loggedinkid="";
  AnimationController animationController;
  Animation<double> animation;

  void checkIfLoggedIN()async{


    setState(() async{
      loggedinkid = await storage.read(key: "key");
      print(loggedinkid);
    });

  }


  startTime() async {

      loggedinkid = await storage.read(key: "key");
      print(loggedinkid);

    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {


      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Wrapper()),
      );


  }

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
    new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[

          Container( width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[


              Padding(padding: EdgeInsets.only(bottom: 30.0),child:Text("ALL COPYRIGHTS RESERVED BY OUR TEAM", style: TextStyle(fontSize: 10),))


            ],),
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("AMAZING", style: TextStyle(fontSize:35, color: Colors.yellow), ),
                  Text("FAMILY", style: TextStyle(fontSize:35, color: Colors.yellow), ),
                ],
              ),

            ],
          ),
        ],
      ),
    );
  }
}