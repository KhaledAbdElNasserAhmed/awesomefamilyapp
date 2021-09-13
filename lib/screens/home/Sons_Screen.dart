import 'package:awesomefamilyapp/models/Kids.dart';
import 'package:awesomefamilyapp/models/user.dart';
import 'package:awesomefamilyapp/services/auth.dart';
import 'package:awesomefamilyapp/services/database.dart';
import 'package:awesomefamilyapp/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

import 'avatar_picker_grid.dart';



TextEditingController _controller = TextEditingController();

class SonsScreen extends StatelessWidget {
  final AuthService _auth = AuthService();
  // ignore: non_constant_identifier_names

  String name;
  String nickname;
  String gender;
  DateTime birthdate;
  String birthdatestring = "00/00/00";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/bg.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('logout as parent'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "AMAZING ",
                style: TextStyle(
                  fontFamily: "Funhouse",
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

          //We Are Family

          Text(
            "WE ARE FAMILY",
            style: TextStyle(
              color: Colors.white,
              letterSpacing: 10,
              fontSize: 12,
              fontFamily: 'VarelaRound',
            ),
          ),
          SizedBox(
            height: 25,
          ),
          //Add your child button
          Container(
              width: 190.0,
              height: 190.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  color: greenColor,
                  image: new DecorationImage(
                      fit: BoxFit.fitHeight,
                      image: new AssetImage('assets/avatars/avatar_3.png')))),

          RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.yellow)),
              color: Color(0xff173434),
              child: Text(
                'ADD YOUR KID',
                style: TextStyle(color: Colors.yellow),
              ),
              onPressed: () {
                showBottomSheet(
                    context: context, builder: (context) => AddKid());
              }),




          Expanded(
            child:   Padding(
              padding: const EdgeInsets.symmetric(horizontal:35, vertical: 8),
              child: Container(

                child: generateNotificationsList(),

              ),
            ),
          )
          ,
         /* RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.yellow)),
              color: Color(0xff173434),
              child: Text(
                'Create',
                style: TextStyle(color: Colors.yellow),
              ),
              onPressed: () {
                DatabaseService(uid: "v7i7ZEL5NINn5xm4SY6ebZrvXjk2").newParentWithSonsSubcollection();
              }),

          RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.yellow)),
              color: Color(0xff173434),
              child: Text(
                'Read',
                style: TextStyle(color: Colors.yellow),
              ),
              onPressed: () async{
                await DatabaseService(uid: "v7i7ZEL5NINn5xm4SY6ebZrvXjk2").returbSubcollection();
              }),*/
        ],
      ),
    );
  }
}


class AddKid extends StatefulWidget {
  @override
  _AddKidState createState() => _AddKidState();
}

class _AddKidState extends State<AddKid> {
  final _formKey = GlobalKey<FormState>();

  String error = '';

  bool isSpinning = false;

  String kidName;

  String kidNickName;

  String gender;
  String kidID;
  DateTime birthdate;
  String displayDate;
  void setAvatar(String newAvatar){
setState(() {
  avatar=newAvatar;
});
  }
  var myKid = Kid();
  String avatar;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return ModalProgressHUD(
      inAsyncCall: isSpinning,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          height: MediaQuery.of(context).size.height / 1.0,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 50),
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    //Circular Avatar
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: Color(0xffFDCF09),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: greenColor,
                        backgroundImage: AssetImage('assets/avatars/${avatar??"avatar_2.png"}'),
                      ),
                    ),

//Input Fields

//Add Another Kid - Done Buttons

                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side:
                            BorderSide(color: Color(0xff173434), width: 2)),
                        color: Color(0xffFFCB02),
                        child: Text(
                          'PICK AVATAR',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {

                          setState(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AvatarPicker(this.setAvatar)),
                            );

                            print(myKid.avatar);
                            avatar=myKid.avatar;
                          });
                        }),

                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'YOUR KID NAME',
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0)),
                      style: TextStyle(
                        color: Colors.yellow,
                      ),
                      validator: (val) =>
                      val.isEmpty ? 'Enter a valid name ' : null,
                      onChanged: (val) {
                        kidName = val;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'NICK NAME',
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                          fillColor: Colors.yellow,
                          hintStyle: TextStyle(color: Color(0xff173434))),
                      style: TextStyle(
                        color: Color(0xff173434),
                      ),
                      validator: (val) =>
                      val.isEmpty ? 'Enter a valid nickname ' : null,
                      onChanged: (val) {
                        kidNickName = val;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: 'GENDER',
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20.0)),
                      style: TextStyle(
                        color: Colors.yellow,
                      ),
                      validator: (val) => val.isEmpty ? 'Enter a Gender' : null,
                      onChanged: (val) {
                        gender = val;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    Stack(
                      children: <Widget>[
                        TextField(
                          controller: _controller,
                          decoration: textInputDecoration.copyWith(
                              hintText: "BirthDate",
                              contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                              fillColor: Colors.yellow,
                              hintStyle: TextStyle(color: Color(0xff173434))),
                          style: TextStyle(
                            color: Color(0xff173434),
                          ),
                        ),
                        Positioned(
                          right: -20,
                          child: RaisedButton(
                            color: Color(0xff173434),
                            shape: CircleBorder(
                                side: BorderSide(color: Colors.white)),
                            padding: EdgeInsets.all(10),
                            child: Icon(
                              Icons.calendar_today,
                              size: 25,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              showDatePicker(
                                  context: context,
                                  initialDate: birthdate == null
                                      ? DateTime.now()
                                      : birthdate,
                                  firstDate: DateTime(2001),
                                  lastDate: DateTime(2030))
                                  .then((date) {
                                setState(() {
                                  birthdate = date;
                                  displayDate = date.month.toString() +
                                      '/' +
                                      date.day.toString() +
                                      '/' +
                                      date.year.toString();
                                  _controller.text = displayDate;
                                });
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "* Very important so we can recommend best activites by his age",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: Color(0xff173434), width: 2)),
                            color: Color(0xff173434),
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.yellow),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(18.0),
                                side: BorderSide(
                                    color: Color(0xff173434), width: 2)),
                            color: Color(0xff173434),
                            child: Text(
                              'Done',
                              style: TextStyle(color: Colors.yellow),
                            ),
                            onPressed: () async {
                              setState(() {
                                isSpinning = true;
                              });

                              if (_formKey.currentState.validate()) {
                                print(kidNickName + kidName + gender);
                                print(birthdate.year.toString() +
                                    ':' +
                                    birthdate.month.toString() +
                                    ':' +
                                    birthdate.day.toString());

                                myKid.name = kidName;
                                myKid.nickname = kidNickName;
                                myKid.setBirthDate(birthdate);
                                myKid.gender = gender;
                                myKid.avatar=avatar;

                                await DatabaseService(uid: user.uid)
                                    .createNewSon(
                                    myKid.name,
                                    myKid.nickname,
                                    myKid.gender,
                                    myKid.databaseBirthdate,
                                    user.uid,
                                    user.email,
                                    myKid.avatar);
                                isSpinning = false;
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  isSpinning = false;
                                });
                              }
                            }),
                      ],
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.yellow),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class generateNotificationsList extends StatefulWidget {
  @override
  _generateNotificationsListState createState() => _generateNotificationsListState();
}

class _generateNotificationsListState extends State<generateNotificationsList> {
  List<String> temp;
  List<String> temp2;
  @override
  Widget build(BuildContext context) {
    final notifications = Provider.of<List<String>>(context);
    final user = Provider.of<User>(context);
    return notifications == null
        ? Container()
        : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {

temp=notifications[index].split("-");
temp2 = notifications[index].split(" ");


temp2 = notifications[index].split("-");
var prefix = temp2[0].trim();                 // prefix: "date"
var activityName = temp2.sublist(1).join(' ').trim(); // date: "'2019:04:01'"

          return Dismissible(
            // Each Dismissible must contain a Key. Keys allow Flutter to
            // uniquely identify widgets.
            key: Key(notifications[index]),
            // Provide a function that tells the app
            // what to do after an item has been swiped away.
            onDismissed: (direction) {
              // Remove the item from the data source.
              setState(() {
// Show a snackbar. This snackbar could also contain "Undo" actions.
                if(notifications[index]!= null)
                  Scaffold
                      .of(context)
                      .showSnackBar(SnackBar(content: Text(notifications[index]+ " dismissed")));
                DatabaseService(uid:user.uid).removeNotification(notifications[index]);
                notifications.removeAt(index);
              });


            },
            child: ListTile(title: Text(temp[0],style: TextStyle(color: Colors.white), ), subtitle: Text(activityName, style: TextStyle(color: Colors.white60),)),
          );


        });
  }
}

