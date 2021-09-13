import 'package:awesomefamilyapp/screens/authenticate/WelcomePage.dart';
import 'package:awesomefamilyapp/screens/home/home.dart';
import 'package:awesomefamilyapp/screens/wrapper.dart';
import 'package:awesomefamilyapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:awesomefamilyapp/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final storage = new FlutterSecureStorage();
  // This widget is the root of your application.

  //Logout (REMOVE PLEASE)

  Future signout() async {
    AuthService _auth = new AuthService();
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    //signout();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return StreamProvider<User>.value(
            value: AuthService().user,
            child: MaterialApp(
              home: Scaffold(
                body: StreamBuilder(
                    stream: AuthService().user,
                    builder: (context, snapshot) {
                      return FutureBuilder(
                          future: AuthService().loggedInKid,
                          builder: (context, snapshot2) {
                            if(snapshot2.hasData)
                            {
                              return Wrapper(kidUID: snapshot2.data,) ?? CircularProgressIndicator();
                            }
                        else if (snapshot.hasData) {
                          return HomePage() ?? CircularProgressIndicator();
                        }
                        return WelcomePage();
                      });
                    }),
              ),
            )) ??
        CircularProgressIndicator();
  }
}
