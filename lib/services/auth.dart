import 'package:awesomefamilyapp/models/Kids.dart';
import 'package:awesomefamilyapp/models/user.dart';
import 'package:awesomefamilyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final storage = new FlutterSecureStorage();
  // create user obj based on firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    print("From the map function : "+user.uid);
    return user != null ? User(uid: user.uid, email: user.email, isParent: true) : null;
  }

  User _userFromFirebaseUserParent(FirebaseUser user, bool isParent) {
    return user != null ? User(uid: user.uid, email: user.email, isParent: isParent) : null;
  }

  // auth change user stream
  Stream<User> get user {
    print("Current User Bruh" + _auth.currentUser().toString());
    return _auth.onAuthStateChanged
    //.map((FirebaseUser user) => _userFromFirebaseUser(user));
        .map(_userFromFirebaseUser);
  }


Future<String> get loggedInKid async{
    String test = await storage.read(key: "key");
    return test;
}

Future<Kid> myKid(String myKidID){
  Firestore.instance.collection('sons').document(myKidID)
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

  });
}


  // sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password, String phonenumber) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      await DatabaseService(uid:user.uid).createNewUser( user.email, phonenumber);
      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

}