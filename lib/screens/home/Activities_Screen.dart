import 'package:awesomefamilyapp/models/Activity.dart';
import 'package:awesomefamilyapp/models/Gift.dart';
import 'package:awesomefamilyapp/services/auth.dart';
import 'package:awesomefamilyapp/shared/QrGenerator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:awesomefamilyapp/shared/constants.dart';
import 'package:awesomefamilyapp/services/database.dart';
import 'package:awesomefamilyapp/models/Kids.dart';
import 'package:provider/provider.dart';
import 'package:awesomefamilyapp/models/user.dart';
import 'package:awesomefamilyapp/shared/custom_switch.dart';
import 'package:rating_bar/rating_bar.dart';

TextEditingController _startDatecontroller = TextEditingController();
TextEditingController _endDatecontroller = TextEditingController();

String getDate(DateTime dt) {
  String __days;
  String __months;

  if (dt.day < 10) {
    __days = '0' + dt.day.toString();
  } else {
    __days = dt.day.toString();
  }

  if (dt.month < 10) {
    __months = '0' + dt.month.toString();
  } else {
    __months = dt.month.toString();
  }

  return dt.year.toString() + __months + __days;
}

DateTime getDateTime(String Date) {
  int year = int.parse(Date.substring(0, 1));
  int month = int.parse(Date.substring(2, 3));
  int day = int.parse(Date.substring(3, 4));
  List<int> restofthedate = [];
  restofthedate.add(month);
  restofthedate.add(day);
  DateTime dt = DateTime(year, month, day);
  return dt;
}

class Consts {
  Consts._();

  static const double padding = 20.0;
}

class CustomDialog extends StatefulWidget {
  final Kid myKid;

  CustomDialog({Key key, @required this.myKid}) : super(key: key);

  @override
  _CustomDialogState createState() => new _CustomDialogState(mykid: myKid);
}

class _CustomDialogState extends State<CustomDialog> {
  _CustomDialogState({this.mykid});

  final Kid mykid;
  String activityName;
  int activityReward = 0;
  bool isDaily = false;
  String startDate;
  String endDate;
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime;

  final _activityKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SimpleDialog(
      title: Text("Add Activity", style: TextStyle(color: yellowColor)),

      elevation: 0.0,
      backgroundColor: Colors.transparent,
      children: <Widget>[
        SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: Consts.padding,
                  bottom: Consts.padding,
                  left: Consts.padding,
                  right: Consts.padding,
                ),
                decoration: new BoxDecoration(
                  color: greenColor.withOpacity(0.9),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Form(
                      key: _activityKey,
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                fillColor: yellowColor,
                                hintText: 'ACTIVITY NAME',
                                hintStyle: TextStyle(color: greenColor),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0)),
                            style: TextStyle(
                              color: greenColor,
                            ),
                            validator: (val) => val.isEmpty
                                ? 'Enter a valid Activity name '
                                : null,
                            onChanged: (val) {
                              activityName = val;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                fillColor: yellowColor,
                                hintText: 'REWARD AMOUT',
                                hintStyle: TextStyle(color: greenColor),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0)),
                            style: TextStyle(
                              color: greenColor,
                            ),
                            validator: (val) {
                              int temp = int.parse(val);

                              if (temp > 0 && val != null)
                                return null;
                              else
                                return 'Enter a valid Reward Amount ';
                            },
                            onChanged: (val) {
                              activityReward = int.parse(val);
                            },
                          ),
                          SizedBox(height: 10.0),
                          Stack(
                            children: <Widget>[
                              TextFormField(
                                validator: (val) {
                                  if (startDateTime.compareTo(endDateTime) < 0)
                                    return null;
                                  else
                                    return 'Enter a valid start date';
                                },
                                controller: _startDatecontroller,
                                decoration: textInputDecoration.copyWith(
                                    hintText: "Start Date",
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    fillColor: yellowColor,
                                    hintStyle:
                                        TextStyle(color: Color(0xff173434))),
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
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2030))
                                        .then((date) {
                                      startDateTime = date;

                                      startDate = getDate(date);
                                      startDate = date.month.toString() +
                                          '/' +
                                          date.day.toString() +
                                          '/' +
                                          date.year.toString();
                                      setState(() {
                                        _startDatecontroller.text = startDate;
                                      });
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Stack(
                            children: <Widget>[
                              TextFormField(
                                validator: (val) {
                                  if (endDateTime.compareTo(startDateTime) > 0)
                                    return null;
                                  else
                                    return 'Enter a valid end date ';
                                },
                                controller: _endDatecontroller,
                                decoration: textInputDecoration.copyWith(
                                    hintText: "End Date",
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    fillColor: yellowColor,
                                    hintStyle:
                                        TextStyle(color: Color(0xff173434))),
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
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2030))
                                        .then((date) {
                                      endDateTime = date;

                                      endDate = getDate(date);
                                      endDate = date.month.toString() +
                                          '/' +
                                          date.day.toString() +
                                          '/' +
                                          date.year.toString();
                                      setState(() {
                                        _endDatecontroller.text = endDate;
                                      });
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "  Repetitions: ",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: yellowColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              CustomSwitch(
                                activeColor: yellowColor,
                                value: isDaily,
                                onChanged: (value) {
                                  setState(() {
                                    isDaily = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Color(0xff173434), width: 2)),
                                color: Color(0xffFFCB02),
                                child: Text(
                                  'Add Activity',
                                  style: TextStyle(color: greenColor),
                                ),
                                onPressed: () async {
                                  if (_activityKey.currentState.validate()) {
                                    await DatabaseService(uid: user.uid)
                                        .createNewActivity(
                                            activityName,
                                            activityReward,
                                            startDate,
                                            endDate,
                                            isDaily,
                                            false,mykid.sonUID);
                                    await DatabaseService(uid: user.uid)
                                        .addActivityToSon(mykid.sonUID);

                                    _startDatecontroller.text = "Start Date";
                                    _endDatecontroller.text = "End Date";
                                    Navigator.pop(context);
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class recommendedActivityCustomDialog extends StatefulWidget {
  final Kid myKid;
  final String activityName;
  final int activityReward;
  final String activityID;

  recommendedActivityCustomDialog(
      {Key key,
      @required this.myKid,
      @required this.activityName,
      @required this.activityReward,
      @required this.activityID})
      : super(key: key);

  @override
  _recommendedActivityCustomDialogState createState() =>
      new _recommendedActivityCustomDialogState(
          mykid: myKid,
          activityID: activityID,
          activityName: activityName,
          activityReward: activityReward);
}

class _recommendedActivityCustomDialogState
    extends State<recommendedActivityCustomDialog> {
  _recommendedActivityCustomDialogState(
      {this.mykid, this.activityName, this.activityReward, this.activityID});

  final Kid mykid;
  final String activityName;
  final int activityReward;
  final String activityID;
  bool isDaily = false;
  String startDate;
  String endDate;
  DateTime startDateTime = DateTime.now();
  DateTime endDateTime;

  final _activityKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SimpleDialog(
      title: Text("Add Activity",softWrap: false, style: TextStyle(color: yellowColor)),

      elevation: 0.0,
      backgroundColor: Colors.transparent,
      children: <Widget>[
        SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: Consts.padding,
                  bottom: Consts.padding,
                  left: Consts.padding,
                  right: Consts.padding,
                ),
                decoration: new BoxDecoration(
                  color: greenColor.withOpacity(0.9),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Form(
                      key: _activityKey,
                      child: Column(
                        children: <Widget>[
                          Text(
                            activityName,
                            style: TextStyle(
                                fontFamily: 'Funhouse',
                                color: yellowColor,
                                fontSize: 20),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "REWARD : ",
                                style: TextStyle(
                                    fontFamily: 'Funhouse',
                                    color: yellowColor,
                                    fontSize: 20),
                              ),
                              Text(
                                activityReward.toString(),
                                style: TextStyle(
                                    fontFamily: 'Funhouse',
                                    color: yellowColor,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Stack(
                            children: <Widget>[
                              TextFormField(
                                validator: (val) {
                                  if (startDateTime.compareTo(endDateTime) < 0)
                                    return null;
                                  else
                                    return 'Enter a valid start date';
                                },
                                controller: _startDatecontroller,
                                decoration: textInputDecoration.copyWith(
                                    hintText: "Start Date",
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    fillColor: yellowColor,
                                    hintStyle:
                                        TextStyle(color: Color(0xff173434))),
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
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2030))
                                        .then((date) {
                                      startDateTime = date;

                                      startDate = getDate(date);
                                      startDate = date.month.toString() +
                                          '/' +
                                          date.day.toString() +
                                          '/' +
                                          date.year.toString();
                                      setState(() {
                                        _startDatecontroller.text = startDate;
                                      });
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Stack(
                            children: <Widget>[
                              TextFormField(
                                validator: (val) {
                                  if (endDateTime.compareTo(startDateTime) > 0)
                                    return null;
                                  else
                                    return 'Enter a valid end date ';
                                },
                                controller: _endDatecontroller,
                                decoration: textInputDecoration.copyWith(
                                    hintText: "End Date",
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20.0),
                                    fillColor: yellowColor,
                                    hintStyle:
                                        TextStyle(color: Color(0xff173434))),
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
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2020),
                                            lastDate: DateTime(2030))
                                        .then((date) {
                                      endDateTime = date;

                                      endDate = getDate(date);
                                      endDate = date.month.toString() +
                                          '/' +
                                          date.day.toString() +
                                          '/' +
                                          date.year.toString();
                                      setState(() {
                                        _endDatecontroller.text = endDate;
                                      });
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "  Repetitions: ",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: yellowColor,
                                    fontWeight: FontWeight.w700),
                              ),
                              CustomSwitch(
                                activeColor: yellowColor,
                                value: isDaily,
                                onChanged: (value) {
                                  setState(() {
                                    isDaily = value;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Color(0xff173434), width: 2)),
                                color: Color(0xffFFCB02),
                                child: Text(
                                  'Add Activity',
                                  style: TextStyle(color: greenColor),
                                ),
                                onPressed: () async {
                                  if (_activityKey.currentState.validate()) {
                                    //await DatabaseService(uid: user.uid).createNewActivity(activityName, activityReward, startDate, endDate, isDaily, false);
                                    await DatabaseService(uid: user.uid)
                                        .addRecommendedActivityToSon(
                                            mykid.sonUID, activityID, activityName, activityReward,startDate,endDate,isDaily,false);

                                    setState(() {
                                      _startDatecontroller.text = "Start Date";
                                      _endDatecontroller.text = "End Date";
                                    });
                                    Navigator.pop(context);
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

//GIFT DIALOG

class recommendedGiftCustomDialog extends StatefulWidget {
  final Kid myKid;
  final String giftName;
  final int giftPrice;
  final String giftID;

  recommendedGiftCustomDialog(
      {Key key,
      @required this.myKid,
      @required this.giftName,
      @required this.giftPrice,
      @required this.giftID})
      : super(key: key);

  @override
  _recommendedGiftCustomDialogState createState() =>
      new _recommendedGiftCustomDialogState(
          mykid: myKid,
          giftID: giftID,
          giftName: giftName,
          giftPrice: giftPrice);
}

class _recommendedGiftCustomDialogState
    extends State<recommendedGiftCustomDialog> {
  _recommendedGiftCustomDialogState(
      {this.mykid, this.giftName, this.giftPrice, this.giftID});

  final Kid mykid;
  final String giftName;
  final int giftPrice;
  final String giftID;

  final _giftKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SimpleDialog(
      title: Text("Add Gift", style: TextStyle(color: yellowColor)),
      titlePadding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 4),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      children: <Widget>[
        SingleChildScrollView(
          child: Stack(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  top: Consts.padding,
                  bottom: Consts.padding,
                  left: Consts.padding,
                  right: Consts.padding,
                ),
                decoration: new BoxDecoration(
                  color: greenColor.withOpacity(0.9),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(35),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                    Form(
                      key: _giftKey,
                      child: Column(
                        children: <Widget>[
                          Text(
                            giftName,
                            style: TextStyle(
                                fontFamily: 'Funhouse',
                                color: yellowColor,
                                fontSize: 20),
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "REWARD : ",
                                style: TextStyle(
                                    fontFamily: 'Funhouse',
                                    color: yellowColor,
                                    fontSize: 20),
                              ),
                              Text(
                                giftPrice.toString(),
                                style: TextStyle(
                                    fontFamily: 'Funhouse',
                                    color: yellowColor,
                                    fontSize: 20),
                              ),
                            ],
                          ),
                          SizedBox(height: 20.0),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(18.0),
                                    side: BorderSide(
                                        color: Color(0xff173434), width: 2)),
                                color: Color(0xffFFCB02),
                                child: Text(
                                  'Add GIFT',
                                  style: TextStyle(color: greenColor),
                                ),
                                onPressed: () async {
                                  if (_giftKey.currentState.validate()) {
                                    //await DatabaseService(uid: user.uid).createNewActivity(activityName, activityReward, startDate, endDate, isDaily, false);
                                    await DatabaseService(uid: user.uid)
                                        .addRecommendedGiftToSon(
                                            mykid.sonUID, giftID);

                                    Navigator.pop(context);
                                  }
                                }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

//is opened when the parent wants to add activity to his son's account
class sonActivityScreen extends StatelessWidget {
  final Kid myKid;

  sonActivityScreen({this.myKid});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return StreamProvider<List<Activity>>.value(
      value: DatabaseService(uid: user.uid).recommendedActivities,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Container(
            height: height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
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
                  SizedBox(
                    height: 20,
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
                    height: 20,
                  ),

                  Text(
                    myKid.name,
                    style: TextStyle(
                        fontFamily: 'Funhouse',
                        color: Colors.white,
                        fontSize: 25),
                  ),

                  Text(
                    myKid.nickname,
                    style: TextStyle(
                        fontFamily: 'Funhouse',
                        color: Colors.yellow,
                        fontSize: 25),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  RaisedButton(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          side: BorderSide(color: Colors.yellow)),
                      color: Color(0xff173434),
                      child: Text(
                        'CREATE YOUR OWN ACTIVITY',
                        style: TextStyle(
                            fontFamily: 'Funhouse', color: Colors.white),
                      ),
                      onPressed: () {
                        _startDatecontroller.text = "Start Date";
                        _endDatecontroller.text = "End Date";
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              CustomDialog(myKid: myKid),
                        );
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width / 6),
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
                    decoration: BoxDecoration(
                        color: Color(
                          0xff173434,
                        ),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "RECOMMENDED ACTIVITIES",
                          style: TextStyle(color: Colors.yellow),
                        ),
                      ],
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 6),
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                      decoration: BoxDecoration(
                          color: Color(
                            0xffFFCB02,
                          ),
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(Radius.circular(25))),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                "NAME",
                                style: TextStyle(color: Color(0xff173434)),
                              ),
                              Text(
                                "|",
                                style: TextStyle(color: Color(0xff173434)),
                              ),
                              Text("REWARD",
                                  style: TextStyle(color: Color(0xff173434))),
                            ],
                          ),
                        ],
                      )),

                  //Kid Name
                  //Kid NickName
                  //Create your own Activity button

                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      alignment: Alignment(0.0, 0.0),
                      child: generateRecommendedActivityList(
                        mykid: myKid,
                      ),
                    ),
                  )
                  //Recommended activites based on age
                ],
              ),
            ),
          )),
    );
  }
}
//Meet your son screen

class MeetYourSon extends StatefulWidget {
  final Kid myKid;
  String dropvalue;
  final Function removeActivity;


  MeetYourSon({this.myKid, this.dropvalue, this.removeActivity});

  @override
  _MeetYourSonState createState() => _MeetYourSonState();
}

class _MeetYourSonState extends State<MeetYourSon> {
  String dropDownValue = "Activities";

  @override
  Widget build(BuildContext context) {
    void RemoveActivityCallback(String val, int reward) {
      setState(() {
        this.widget.myKid.activities.remove(val);

        if (widget.myKid.currentCoins == null) widget.myKid.currentCoins = 0;

        if (widget.myKid.totalCoins == null) widget.myKid.totalCoins = 0;

        this.widget.myKid.currentCoins += reward;
        this.widget.myKid.totalCoins += reward;
      });
    }

    void RemoveGiftCallback(String val, int cost) {
      setState(() {
        this.widget.myKid.gifts.remove(val);
        this.widget.myKid.currentCoins -=cost;
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

    Widget switchGiftActivity(String val) {
      if (val == 'Activities') {
        return generateKidActivityList(
          mykid: widget.myKid,
          removeActivity: RemoveActivityCallback,
        );
      } else if (val == 'Gifts') {
        return generateKidGiftsList(
          mykid: widget.myKid,
          removeGift: RemoveGiftCallback,
        );
      }
    }

    final user = Provider.of<User>(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return StreamProvider<List<Gift>>.value(
      value: DatabaseService(uid: user.uid).kidGifts(widget.myKid.gifts),
      child: StreamProvider<List<Activity>>.value(
          value: DatabaseService(uid: user.uid)
              .kidActivities(widget.myKid.activities),
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
                            SizedBox(
                              height: 10,
                            ),
                            //Kid Avatar
                            CircleAvatar(
                              radius: height / 10,
                              backgroundColor: Color(0xffFDCF09),
                              child: CircleAvatar(
                                radius: (height / 10) - 3,
                                backgroundColor: greenColor,
                                backgroundImage: AssetImage("assets/avatars/"+"${widget.myKid.avatar}"),
                              ),
                            ),
                            //son name
                            //Pick Activity
                            SizedBox(
                              height: 5,
                            ),
                            RatingBar.readOnly(
                              filledColor: yellowColor,
                              initialRating: widget.myKid.rating??5.0,
                              isHalfAllowed: true,
                              halfFilledIcon: Icons.star_half,
                              filledIcon: Icons.star,
                              emptyIcon: Icons.star_border,
                            ),
                            Text(
                              widget.myKid.name,
                              style: TextStyle(
                                  fontFamily: 'Funhouse',
                                  color: Colors.white,
                                  fontSize: 20),
                            ),

                            Text(
                              widget.myKid.nickname,
                              style: TextStyle(
                                  fontFamily: 'Funhouse',
                                  color: yellowColor,
                                  fontSize: 20),
                            ),
                            Text(
                              widget.myKid.currentCoins.toString() + " Coins",
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
                                          style: TextStyle(
                                              color: Color(0xff173434)),
                                        ),
                                        Text(
                                          dropDownValue == "Activities"
                                              ? "TIME"
                                              : "",
                                          style: TextStyle(
                                              color: Color(0xff173434)),
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
          )),
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

//Sons tiles in the sons tab
class sonsTiles extends StatelessWidget {
  final Kid kid;
  final double height;
  final double width;
  final int numberOfActivities;
  sonsTiles({this.kid, this.height, this.width, this.numberOfActivities});

  void removeActivityCallback(int reward) {
    if (this.kid.currentCoins == null) this.kid.currentCoins = 0;
    if (this.kid.totalCoins == null) this.kid.totalCoins = 0;

    this.kid.currentCoins += reward;
    this.kid.totalCoins += reward;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Center(
          child: Column(
        children: <Widget>[
          //Son Avatar

          CircleAvatar(
            radius: height / 7,
            backgroundColor: Color(0xffFDCF09),
            child: CircleAvatar(
              radius: (height / 7) - 3,
              backgroundColor: greenColor,
              backgroundImage: AssetImage("assets/avatars/"+"${this.kid.avatar}"),
            ),
          ),
          //son name
          SizedBox(
            height: 10,
          ),
          //TODO Rating
          RatingBar.readOnly(
            filledColor: yellowColor,
            initialRating: kid.rating??5.0,
            isHalfAllowed: true,
            halfFilledIcon: Icons.star_half,
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
          ),
          //Pick Activity
          SizedBox(
            height: 15,
          ),
          Text(
            kid.name,
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontFamily: "Funhouse"),
          ),
          Text(
            kid.nickname,
            style: TextStyle(
                color: yellowColor, fontSize: 25, fontFamily: "Funhouse"),
          ),

          SizedBox(
            height: 20,
          ),
          RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  side: BorderSide(color: Color(0xff173434), width: 2)),
              color: Color(0xffFFCB02),
              child: Text(
                'PICK ACTIVITY',
                style: TextStyle(color: Colors.white, fontFamily: "Funhouse"),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => sonActivityScreen(myKid: kid)),
                );
              }),
          RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  side: BorderSide(color: yellowColor, width: 2)),
              color: greenColor,
              child: Text(
                'MEET YOUR SON :)',
                style: TextStyle(color: Colors.white, fontFamily: "Funhouse"),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MeetYourSon(
                          myKid: kid,
                          dropvalue: "Activities",
                          removeActivity: removeActivityCallback)),
                );
              }),
          RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 55, vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(25.0),
                  side: BorderSide(color: yellowColor, width: 2)),
              color: greenColor,
              child: Text(
                'SON QR CODE',
                style: TextStyle(color: Colors.white, fontFamily: "Funhouse"),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QRScanner(
                            message: kid.sonUID,
                          )),
                );
              }),
        ],
      )),
    );
  }
}

class recommendedActivityTiles extends StatelessWidget {
  final Activity activity;
  final double height;
  final double width;
  final Kid mykid;
  recommendedActivityTiles(
      {this.activity, this.height, this.width, this.mykid});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Text(
              activity.name,
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
            child: Text(activity.reward.toString(),
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
          Expanded(
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      recommendedActivityCustomDialog(
                    activityID: activity.activityID,
                    activityReward: activity.reward,
                    activityName: activity.name,
                    myKid: mykid,
                  ),
                );
              },
              child: Text("Details",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      decoration: TextDecoration.underline)),
            ),
          ),
        ],
      ),
    );
  }
}



class generateSonsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final myKids = Provider.of<List<Kid>>(context);
    final recommendedActivities = Provider.of<List<Activity>>(context);
    final user = Provider.of<User>(context);
    return StreamProvider<List<Activity>>.value(
      value: DatabaseService(uid: user.uid).recommendedActivities,
      child: myKids == null
          ? Container()
          : ListView.builder(
              itemCount: myKids.length,
              itemBuilder: (context, index) {
                return sonsTiles(
                  kid: myKids[index],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,numberOfActivities:DatabaseService(uid: user.uid).getActivitesfromUI() ,
                );
              }),
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
                              'Are you sure you want to delete this activity?',
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
                                print("Reward:" +
                                    this.activity.reward.toString() +
                                    "TotalCoins: " +
                                    this.mykid.totalCoins.toString());
                                await DatabaseService(uid: user.uid)
                                    .removeActivityFromSon(
                                        this.mykid.sonUID,
                                        this.activity.activityID,
                                        this.activity.reward,
                                        this.mykid.currentCoins, this.mykid.totalCoins, this.activity.isDaily);

                                this.removeActivity(this.activity.activityID,
                                    this.activity.reward);

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
                              'Are you sure you want to delete this Gift?',
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
                                if( this.mykid.currentCoins >= this.gift.price){
                                  await DatabaseService(uid: user.uid)
                                      .removeGiftFromSon(
                                      this.mykid.sonUID, this.gift.giftID, this.gift.price, this.mykid.currentCoins, this.mykid.totalCoins);
                                  this.removeGift(this.gift.giftID, this.gift.price);
                                  Navigator.of(context).pop();

                                }
else{

                                }

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

//Views the gifts available to the kid opened
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

class generateRecommendedActivityList extends StatelessWidget {
  final Kid mykid;

  generateRecommendedActivityList({this.mykid});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final recommendedActivities = Provider.of<List<Activity>>(context);
    return recommendedActivities == null
        ? Container()
        : ListView.builder(
            itemCount: recommendedActivities.length,
            itemBuilder: (context, index) {
              return recommendedActivityTiles(
                activity: recommendedActivities[index],
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                mykid: mykid,
              );
            });
  }
}



class AlreadyHasKids extends StatefulWidget {
  @override
  _AlreadyHasKidsState createState() => _AlreadyHasKidsState();
}

class _AlreadyHasKidsState extends State<AlreadyHasKids> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<Activity>>.value(
      value: DatabaseService(uid: user.uid).recommendedActivities,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: MediaQuery.of(context).size.height / 10,
              right: 0,
              left: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
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
                        fontFamily: 'VarelaRound',
                        color: Colors.white,
                        letterSpacing: 10,
                        fontSize: 12),
                  ),
                ],
              ),
            ),
            Scaffold(
                backgroundColor: Colors.transparent,
                body: Padding(
                  padding: const EdgeInsets.only(top: 150),
                  child: generateSonsList(),
                )),
          ],
        ),
      ),
    );

    //Add your child button);
  }
}

//Show the kids if it's not the first time
