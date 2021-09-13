import 'package:awesomefamilyapp/services/auth.dart';
import 'package:awesomefamilyapp/shared/QrScanner.dart';
import 'package:awesomefamilyapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ChildLogin extends StatefulWidget {

  @override
  _ChildLoginState createState() => _ChildLoginState();
}

class _ChildLoginState extends State<ChildLogin> {

  final storage = new FlutterSecureStorage();
  final AuthService _auth = AuthService();
  final TextEditingController _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isSpinning = false;

  String error = '';

  String email = '';

  String username = '';

  String sonUID ="";


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    void setSonUID(String newUID){

      setState(() async{
        sonUID=newUID;
        await storage.write(key: "key", value: sonUID);
        _controller.text=sonUID;
      });
    }
    return  ModalProgressHUD(
      inAsyncCall: isSpinning,
      child: Stack(
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
            child:    Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRViewExample(setSonUID: setSonUID,)),
                  );
                },
                child: Icon(Icons.camera),
                backgroundColor: greenColor,
              ),
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical:40.0, horizontal: 20),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          //Amazing Family
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "AMAZING ",
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w500,
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
                          ),

                          //We Are Family

                          Text(
                            "WE ARE FAMILY",
                            style: TextStyle(
                                color: Colors.white, letterSpacing: 10, fontSize: 12),
                          ),

                          //Ribbons and stuff

                          SizedBox(height: height/12),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Enter your parent email',
                            ),
                            style: TextStyle(
                              color: Colors.yellow,
                            ),
                            validator: (val) => val.isEmpty ? 'Enter a valid email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          SizedBox(height: 20.0),


                          TextFormField(
                            controller: _controller,
                            style: TextStyle(color: Colors.yellow),
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Scan your ID'),
                            validator: (val) => val.isEmpty ? 'Scan again' : null,
                            onChanged: (val) {
                              setState(()async{
                                sonUID = val;
                                await setSonUID(sonUID);
                              }



                              );
                            },
                          ),
                          SizedBox(height: 20.0),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: new BorderRadius.circular(18.0),
                                      side: BorderSide(color: Color(0xff173434))),
                                  color: Color(0xff173434),
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(color: Colors.yellow),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      isSpinning = true;
                                    });
                                    if (_formKey.currentState.validate()) {
                                      dynamic result = await _auth
                                          .signInAnon();

                                      Navigator.pop(context);

                                      if (result == null) {
                                        setState(() {
                                          error =
                                          'Could not sign in with those credentials';
                                          isSpinning = false;
                                        });
                                      }

                                      setState(() {
                                        isSpinning = false;
                                      });
                                    }
                                    setState(() {
                                      isSpinning = false;
                                    });
                                  }),
                              SizedBox(
                                width: 20,
                              ),
                            ],
                          ),


                          SizedBox(height: 12.0),
                          Text(
                            error,
                            style: TextStyle(color: Colors.white, fontSize: 14.0),
                          ),

                          Text(
                              sonUID,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),


        ],
      ),
    );
  }
}



