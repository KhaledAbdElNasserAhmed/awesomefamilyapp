import 'package:awesomefamilyapp/models/Kids.dart';
import 'package:awesomefamilyapp/models/user.dart';
import 'package:awesomefamilyapp/screens/authenticate/WelcomePage.dart';
import 'package:awesomefamilyapp/screens/authenticate/authenticate.dart';
import 'package:awesomefamilyapp/screens/home/home.dart';
import 'package:awesomefamilyapp/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'home/child_Screen.dart';


class Wrapper extends StatelessWidget {

  final String kidUID;

  Wrapper({this.kidUID});


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);



    //print(user.uid);

//    // return either the Home or Authenticate widget
//    if (user == null){
//      return Authenticate();
//    } else {
//      return HomePage();
//    }

    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {

        if (snapshot.hasData) {
          if (snapshot.data.isAnonymous) { // logged in using email and password
            return FutureBuilder<String>(
              future: AuthService().loggedInKid,
              builder:(context,snapshot2){

                if(snapshot2.hasData){
                  return FutureBuilder<Kid>(

                    future: Firestore.instance.collection('sons').document(snapshot2.data)
                        .get().then((DocumentSnapshot){

                      return Kid(
                          name: DocumentSnapshot.data['name']?? '',
                          nickname: DocumentSnapshot.data['nickname']?? '',
                          gender: DocumentSnapshot.data['gender']?? '',
                          databaseBirthdate: DocumentSnapshot.data['birthdate']?? '',
                          parentUID: DocumentSnapshot.data['parentUID']?? '',
                          parentEmail: DocumentSnapshot.data['parentEmail'],
                          sonUID: DocumentSnapshot.data['sonUID'],
                          activities: List.from(DocumentSnapshot['activities']),
                          gifts: List.from(DocumentSnapshot['gifts']),
                          currentCoins: DocumentSnapshot.data['currentcoins'],
                          totalCoins: DocumentSnapshot.data['totalcoins'],
                          avatar: DocumentSnapshot.data['avatar']

                      );

                    }),
                    builder: (context, snapshot){
                      if(snapshot.connectionState == ConnectionState.done){
                        return ChildScreen(myKidID: snapshot2.data, myKid:snapshot.data,);
                      }
                      else return Stack(
                        children: <Widget>[
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height : MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/bg.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child:Scaffold(
                                  backgroundColor: Colors.transparent,
                                  body: Center(child: CircularProgressIndicator()))),
                        ],
                      );
                    },

                  );
                }
                else{
                  return FutureBuilder<Kid>(

                  future: Firestore.instance.collection('sons').document(kidUID)
                      .get().then((DocumentSnapshot){

                    return Kid(
                        name: DocumentSnapshot.data['name']?? '',
                        nickname: DocumentSnapshot.data['nickname']?? '',
                        gender: DocumentSnapshot.data['gender']?? '',
                        databaseBirthdate: DocumentSnapshot.data['birthdate']?? '',
                        parentUID: DocumentSnapshot.data['parentUID']?? '',
                        parentEmail: DocumentSnapshot.data['parentEmail'],
                        sonUID: DocumentSnapshot.data['sonUID'],
                        activities: List.from(DocumentSnapshot['activities']),
                        gifts: List.from(DocumentSnapshot['gifts'])

                    );

                  }),
                  builder: (context, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      return ChildScreen(myKidID: kidUID, myKid:snapshot.data,);
                    }
                    else return Stack(
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height : MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/bg.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child:Scaffold(
                                backgroundColor: Colors.transparent,
                                body: Center(child: CircularProgressIndicator()))),
                      ],
                    );
                  },

                );}
                },

            );
          } else {
            // logged in using other providers
            return HomePage();
          }
        } else {
          return WelcomePage();
        }
      },
    );


  }
}