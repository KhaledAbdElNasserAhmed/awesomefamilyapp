import 'package:awesomefamilyapp/services/auth.dart';
import 'package:awesomefamilyapp/shared/constants.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool isSpinning = false;
  String error = '';

  // text field state
  String email = '';
  String password = '';
  String username = '';
  String phonenumber='';
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Container(
                  child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical:40.0, horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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

                          SizedBox(height: 50.0),

                          Stack(
                            children: <Widget>[
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Enter your email',
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0)),
                                style: TextStyle(
                                  color: Colors.yellow,
                                ),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter an email' : null,
                                onChanged: (val) {
                                  setState(() => email = val);
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: 20.0),

                          Stack(
                         children: <Widget>[TextFormField(
                           decoration: textInputDecoration.copyWith(
                               hintText: 'Enter your password',
                               contentPadding: const EdgeInsets.symmetric(
                                   horizontal: 20.0)),
                           style: TextStyle(
                             color: Colors.yellow,
                           ),
                           obscureText: true,
                           validator: (val) => val.length < 6
                               ? 'Enter a password of six or more characters long'
                               : null,
                           onChanged: (val) {
                             setState(() {
                               password = val;
                             });
                           },
                         ),],
                          ),

                          SizedBox(height: 20.0),

                          Stack(
                            children: <Widget>[
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Confirm your password',
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0)),
                                style: TextStyle(
                                  color: Colors.yellow,
                                ),
                                obscureText: true,
                                validator: (val) => val != password
                                    ? 'passwords dont match'
                                    : null,
                                onChanged: (val) {},
                              ),
                            ],
                          ),

                          SizedBox(height: 20.0),
                          Stack(
                            children: <Widget>[
                              TextFormField(
                                decoration: textInputDecoration.copyWith(
                                    hintText: 'Enter your phone number',
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0)),
                                style: TextStyle(
                                  color: Colors.yellow,
                                ),
                                validator: (val) =>  val.length < 11
                                    ? 'Enter a valid phone number'
                                    : null,
                                onChanged: (val) {phonenumber= val;},
                              ),
                            ],
                          ),

                          SizedBox(height: 20.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Color(0xff173434))),
                                  color: Color(0xff173434),
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(color: Colors.yellow),
                                  ),
                                  onPressed: () {
                                    widget.toggleView();
                                  }),
                              SizedBox(
                                width: 20,
                              ),
                              RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: Color(0xff173434))),
                                  color: Color(0xff173434),
                                  child: Text(
                                    'Register',
                                    style: TextStyle(color: Colors.yellow),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      dynamic result = await _auth
                                          .registerWithEmailAndPassword(
                                              email, password, phonenumber);

                                      if (result == null) {
                                        setState(() {
                                          error =
                                              'Please supply a valid email';
                                        });
                                      } else {
                                        setState(() => isSpinning = true);
                                      }
                                    }
                                  }),
                            ],
                          ),

                          SizedBox(height: 12.0),

                          Text(
                            error,
                            style: TextStyle(
                                color: Colors.red, fontSize: 14.0),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
