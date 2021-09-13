import 'package:awesomefamilyapp/shared/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'authenticate.dart';
import 'sign_in.dart';
import 'child_login.dart';
class WelcomePage extends StatefulWidget {
  final Function toggleView;
  WelcomePage({this.toggleView});
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(

        children: <Widget>[

          Container(

            height: height,
            width: width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(


              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "AMAZING ",
                      style: TextStyle(
                        fontFamily: "Funhouse",
                        fontSize: 35,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2, 1),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "FAMILY ",
                      style: TextStyle(
                        fontFamily: "Funhouse",
                        fontSize: 35,
                        fontWeight: FontWeight.w500,
                        color: Colors.yellow,
                        shadows: <Shadow>[
                          Shadow(
                            offset: Offset(2, 1),
                            blurRadius: 2.0,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Text(
                  "WE ARE FAMILY",
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 10,
                      fontSize: 12),
                ),
                SizedBox(height: height/5,),
                Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RawMaterialButton(
                          onPressed: () {Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ChildLogin()),
                          );},
                          elevation: 2.0,
                          fillColor: greenColor,
                          child: CircleAvatar(
                              radius: width/4-10 , backgroundImage: AssetImage('assets/boy.jpg')),

                          shape: CircleBorder(),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:10),
                          child: Text(
                            "Child Login ",
                            style: TextStyle(
                              fontFamily: "Funhouse",
                              fontSize: 20,
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(2, 1),
                                  blurRadius: 2.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RawMaterialButton(
                          onPressed: () {Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Authenticate()),
                          );},
                          elevation: 2.0,
                          fillColor: greenColor,
                          child: CircleAvatar(
                              radius: width/4-10 , backgroundImage: AssetImage('assets/dad.png')),

                          shape: CircleBorder(),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical:10),
                          child: Text(
                            "Parent Login ",
                            style: TextStyle(
                              fontFamily: "Funhouse",
                              fontSize: 20,
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(2, 1),
                                  blurRadius: 2.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
