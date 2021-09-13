import 'package:awesomefamilyapp/services/auth.dart';
import 'package:awesomefamilyapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'child_login.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool isSpinning = false;
  String error = '';

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
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
            child: Scaffold(
              /*floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChildLogin()),
                  );
                },
                child: CircleAvatar(
                    radius: 25, backgroundImage: AssetImage('assets/boy.jpg')),
                backgroundColor: greenColor,
              ),*/
              backgroundColor: Colors.transparent,
              resizeToAvoidBottomInset: false,
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 20),
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
                                color: Colors.white,
                                letterSpacing: 10,
                                fontSize: 12),
                          ),

                          //Ribbons and stuff

                          SizedBox(height: height / 12),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Enter your email',
                            ),
                            style: TextStyle(
                              color: Colors.yellow,
                            ),
                            validator: (val) =>
                                val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            style: TextStyle(color: Colors.yellow),
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                hintText: 'Enter your password'),
                            validator: (val) => val.length < 6
                                ? 'Enter a password of six or more characters long'
                                : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side:
                                          BorderSide(color: Color(0xff173434))),
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
                                          .signInWithEmailAndPassword(
                                              email, password);

                                      if (result == null) {
                                        setState(() {
                                          error =
                                              'Could not sign in with those credentials';
                                          isSpinning = false;
                                        });
                                      }

                                      setState(() {
                                        isSpinning = false;
                                        Navigator.pop(context);
                                      });
                                    }
                                    setState(() {
                                      isSpinning = false;
                                    });
                                  }),
                              SizedBox(
                                width: 20,
                              ),
                              RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side:
                                          BorderSide(color: Color(0xff173434))),
                                  color: Color(0xff173434),
                                  child: Text(
                                    'Register',
                                    style: TextStyle(color: Colors.yellow),
                                  ),
                                  onPressed: () async {
                                    setState(() {
                                      isSpinning = true;
                                      widget.toggleView();
                                    });
                                    if (_formKey.currentState.validate()) {
                                      dynamic result = await _auth
                                          .signInWithEmailAndPassword(
                                              email, password);

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
                                  })
                            ],
                          ),

                          SizedBox(height: 12.0),
                          Text(
                            error,
                            style:
                                TextStyle(color: Colors.white, fontSize: 14.0),
                          ),
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
