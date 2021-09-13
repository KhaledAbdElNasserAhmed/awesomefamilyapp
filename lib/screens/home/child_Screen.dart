import 'package:awesomefamilyapp/models/Activity.dart';
import 'package:awesomefamilyapp/models/Gift.dart';
import 'package:awesomefamilyapp/models/Kids.dart';
import 'package:awesomefamilyapp/models/user.dart';
import 'package:awesomefamilyapp/services/auth.dart';
import 'package:awesomefamilyapp/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesomefamilyapp/shared/constants.dart';
import 'package:rating_bar/rating_bar.dart';


class Consts {
  Consts._();


  static const double padding = 20.0;
}

class ChildScreen extends StatefulWidget {

  final String myKidID;
  final Kid myKid;
ChildScreen({this.myKidID, this.myKid});

  @override
  _ChildScreenState createState() => _ChildScreenState();
}

class _ChildScreenState extends State<ChildScreen> {
  Kid myKid;
  String kidUID;


  Future<Kid> updateKid()async{

    Kid newkid = await Firestore.instance.collection('sons').document(widget.myKidID)
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
          totalCoins: DocumentSnapshot.data['totalcoins']


      );

    }
    );
    return newkid;
  }



  @override
  void initState() {
  myKid=widget.myKid;
  super.initState();

  }


  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
   Kid new23= await Future.delayed(Duration(seconds: 2), updateKid);


    setState(() {
      myKid = new23;
    });
    return null;
  }


  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String dropDownValue = "Activities";
  List<Activity> mylist =[new Activity(name: "test",activityID: "test",dateFrom: "test",dateTo: "Test", isDaily: true, createdByID: "Test",reward: 10,)];
  @override
  Widget build(BuildContext context) {


    void RemoveActivityCallback(String val) {
      setState(() {
        this.myKid.activities.remove(val);
      });
    }

    void RemoveGiftCallback(String val) {
      setState(() {
        this.myKid.gifts.remove(val);
      });
    }

    void toggleDropdown() {
      if (dropDownValue == "Activities") {
        setState(() {
          dropDownValue = "Gifts";
        });
      } else if (dropDownValue == "Gifts") {
        setState(() {
          dropDownValue = "Activities";
        });
      }
    }

    // ignore: missing_return
    Widget switchGiftActivity(String val) {
      if (val == 'Activities') {
        return generateKidActivityList(
          mykid: myKid,
          removeActivity: RemoveActivityCallback,
        );
      } else if (val == 'Gifts') {
        return generateKidGiftsList(
          mykid: myKid,
          removeGift: RemoveGiftCallback,
        );
      }
    }


    final user = Provider.of<User>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final AuthService _auth = AuthService();
    return StreamProvider<List<Activity>>.value(
      value:DatabaseService(uid: user.uid)
          .kidActivities(myKid.activities) ,
      child: StreamProvider<List<Gift>>.value(
        value: DatabaseService(uid: user.uid).kidGifts(myKid.gifts),
        child: RefreshIndicator(
          onRefresh: refreshList,
          key: refreshKey,
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
                      backgroundColor: Colors.transparent,
                      resizeToAvoidBottomInset: false,
                      body: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Container(
                            height: height,
                            width: width,
                            child: Column(
                              children: <Widget>[

                                //Amazing Family Text and logo
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

                                //We Are Family

                                Text(
                                  "WE ARE FAMILY",
                                  style: TextStyle(
                                      fontFamily: 'VarelaRound',
                                      color: Colors.white,
                                      letterSpacing: 10,
                                      fontSize: 12),
                                ),
                                FlatButton.icon(
                                  icon: Icon(Icons.person),
                                  label: Text('logout as kid'),
                                  onPressed: () async {
                                    await _auth.signOut();
                                  },
                                ),
                                //Kid Avatar
                                CircleAvatar(
                                  radius: height / 10,
                                  backgroundColor: Color(0xffFDCF09),
                                  child: CircleAvatar(
                                    radius: (height / 10) - 3,
                                    backgroundColor: greenColor,
                                    backgroundImage: AssetImage("assets/avatars/"+"${this.myKid.avatar}"),
                                  ),
                                ),
                                //son name
                                //Pick Activity
                                SizedBox(
                                  height: 5,
                                ),
                                RatingBar.readOnly(
                                  filledColor: yellowColor,
                                  initialRating: 4.0,
                                  isHalfAllowed: true,
                                  halfFilledIcon: Icons.star_half,
                                  filledIcon: Icons.star,
                                  emptyIcon: Icons.star_border,
                                ),
                                Text(
                                  myKid.name==null ? "Not available":myKid.name,
                                  style: TextStyle(
                                      fontFamily: 'Funhouse',
                                      color: Colors.white,
                                      fontSize: 20),
                                ),

                                Text(
                                  myKid.nickname,
                                  style: TextStyle(
                                      fontFamily: 'Funhouse',
                                      color: yellowColor,
                                      fontSize: 20),
                                ),
                                Text(
                                  myKid.currentCoins.toString() + " Coins",
                                  style: TextStyle(
                                      fontFamily: 'Funhouse',
                                      color: yellowColor,
                                      fontSize: 20),
                                ),

                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal:
                                      MediaQuery.of(context).size.width / 6),
                                  padding: EdgeInsets.symmetric(horizontal: 25),
                                  decoration: BoxDecoration(
                                      color: Color(
                                        0xff173434,
                                      ),
                                      shape: BoxShape.rectangle,
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(25))),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      DropdownExample(
                                        toggle: toggleDropdown,
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                        MediaQuery.of(context).size.width / 6),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 15, horizontal: 35),
                                    decoration: BoxDecoration(
                                        color: Color(
                                          0xffFFCB02,
                                        ),
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(25))),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              "NAME",
                                              style:
                                              TextStyle(color: Color(0xff173434)),
                                            ),
                                            Text(
                                              dropDownValue == "Activities"
                                                  ? "TIME"
                                                  : "",
                                              style:
                                              TextStyle(color: Color(0xff173434)),
                                            ),
                                            Text(
                                                dropDownValue == "Activities"
                                                    ? "EFFORT"
                                                    : "COINS",
                                                style: TextStyle(
                                                    color: Color(0xff173434))),
                                          ],
                                        ),
                                      ],
                                    )),

                                //Kid Name
                                //Kid NickName
                                //Create your own Activity button

                                Expanded(
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width / 10),
                                      alignment: Alignment(0.0, 0.0),
                                      child: switchGiftActivity(dropDownValue)),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),


                    ),
                  ),

                ],




          ),
        ),
      ),
    );
  }
}



class generateKidActivityList extends StatelessWidget {
  final Kid mykid;
  final Function removeActivity;
  generateKidActivityList({this.mykid, this.removeActivity});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final ActivitiesList = Provider.of<List<Activity>>(context);
    return ActivitiesList == null
        ? Container()
        : ListView.builder(
        itemCount: ActivitiesList.length,
        itemBuilder: (context, index) {
          return ActivityTiles(
            activity: ActivitiesList[index],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            mykid: mykid,
            removeActivity: removeActivity,
          );
        });
  }
}



class generateKidGiftsList extends StatelessWidget {
  final Kid mykid;
  final Function removeGift;
  generateKidGiftsList({this.mykid, this.removeGift});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final GiftsList = Provider.of<List<Gift>>(context);
    return GiftsList == null
        ? Container()
        : ListView.builder(
        itemCount: GiftsList.length,
        itemBuilder: (context, index) {
          return GiftsTiles(
            gift: GiftsList[index],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            mykid: mykid,
            removeGift: removeGift,
          );
        });
  }
}



class GiftsTiles extends StatelessWidget {
  final Gift gift;
  final double height;
  final double width;
  final Kid mykid;
  final Function removeGift;

  GiftsTiles({this.gift, this.height, this.width, this.mykid, this.removeGift});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Text(
                  this.gift.name,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text("|", style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 2,
                child: Text(this.gift.price.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: greenColor,
                          title: Text(
                              'Are you sure you want to claim this Gift?',
                              style: TextStyle(color: yellowColor)),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('You cannot undo this action.',
                                    style: TextStyle(color: yellowColor)),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'Yes',
                                style: TextStyle(color: yellowColor),
                              ),
                              onPressed: () async {
                                await DatabaseService(uid: user.uid).addNotificationToParent(this.mykid.parentUID, this.mykid.nickname, false, this.gift.name);
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('No',
                                  style: TextStyle(color: yellowColor)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width / 1.3,
                      decoration: BoxDecoration(
                          color: Color(
                            0xffFFCB02,
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                  height: this.height / 18,
                                  child: Image.asset("assets/trash.png"))),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "REMOVE THIS GIFT",
                                  style: TextStyle(color: greenColor),
                                )),
                          ),
                        ],
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

}



class ActivityTiles extends StatelessWidget {
  final Activity activity;
  final double height;
  final double width;
  final Kid mykid;
  final Function removeActivity;
  ActivityTiles(
      {this.activity,
        this.height,
        this.width,
        this.mykid,
        this.removeActivity});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Text(
                  this.activity.name,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text("|", style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Text(this.activity.reward.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
              ),
              SizedBox(
                width: 10,
              ),
              Text("|", style: TextStyle(color: Colors.white, fontSize: 16)),
              SizedBox(
                width: 10,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: false, // user must tap button!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: greenColor,
                          title: Text(
                              'Notification will be sent to your parent to finish this Activity, Continue ?',
                              style: TextStyle(color: yellowColor)),
                          content: SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text('You cannot undo this action.',
                                    style: TextStyle(color: yellowColor)),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text(
                                'Yes',
                                style: TextStyle(color: yellowColor),
                              ),
                              onPressed: () async {
                                await DatabaseService(uid: user.uid).addNotificationToParent(this.mykid.parentUID, this.mykid.nickname, true, this.activity.name);
                                Navigator.of(context).pop();
                              },
                            ),
                            FlatButton(
                              child: Text('No',
                                  style: TextStyle(color: yellowColor)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width / 1.3,
                      decoration: BoxDecoration(
                          color: Color(
                            0xffFFCB02,
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Stack(
                        children: <Widget>[
                          Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                  height: this.height / 18,
                                  child: Image.asset("assets/trash.png"))),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "REMOVE THIS ACTIVITY",
                                  style: TextStyle(color: greenColor),
                                )),
                          ),
                        ],
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}



class DropdownExample extends StatefulWidget {
  final Function toggle;

  DropdownExample({this.toggle});
  @override
  _DropdownExampleState createState() {
    return _DropdownExampleState();
  }
}

class _DropdownExampleState extends State<DropdownExample> {
  String _value = "one";

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: greenColor,
        ),
        child: DropdownButton<String>(
          icon: Icon(Icons.keyboard_arrow_down),
          iconDisabledColor: Colors.white,
          iconEnabledColor: Colors.white,
          underline: SizedBox(),
          items: [
            DropdownMenuItem<String>(
              child: Text(
                'ACTIVITIES',
                style: TextStyle(fontFamily: 'Funhouse', color: yellowColor),
              ),
              value: 'one',
            ),
            DropdownMenuItem<String>(
              child: Text('GIFTS',
                  style: TextStyle(fontFamily: 'Funhouse', color: yellowColor)),
              value: 'two',
            ),
          ],
          onChanged: (String value) {
            setState(() {
              if (_value != value) {
                _value = value;
                widget.toggle();
              }
            });
          },
          value: _value,
        ),
      ),
    );
  }
}
