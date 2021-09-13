import 'package:awesomefamilyapp/models/user.dart';
import 'package:awesomefamilyapp/models/Gift.dart';
import 'package:awesomefamilyapp/models/Kids.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:awesomefamilyapp/services/auth.dart';
import 'package:awesomefamilyapp/services/database.dart';
import 'package:awesomefamilyapp/shared/constants.dart';



class Consts {
  Consts._();

  static const double padding = 40.0;
}

class giftsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final sons = Provider.of<List<Kid>>(context);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return StreamProvider<List<Kid>>.value(
      value: DatabaseService(uid: user.uid).sons,
      child: StreamProvider<List<Gift>>.value(
        value: DatabaseService(uid: user.uid).recommendedGifts,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Container(
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
                        backgroundColor: Colors.grey,
                        backgroundImage: AssetImage('assets/gift.jpg'),
                      ),
                    ),
                    //son name
                    //Pick Activity
                    SizedBox(
                      height: 20,
                    ),

//                  Text(
//                    myKid.name,
//                    style: TextStyle(
//                        fontFamily: 'Funhouse',
//                        color: Colors.white,
//                        fontSize: 25),
//                  ),

//                  Text(
//                    myKid.nickname,
//                    style: TextStyle(
//                        fontFamily: 'Funhouse',
//                        color: Colors.yellow,
//                        fontSize: 25),
//                  ),
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
                          'CREATE YOUR OWN GIFT',
                          style: TextStyle(
                              fontFamily: 'Funhouse', color: Colors.white),
                        ),
                        onPressed: () {

                          showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                CustomDialogGifts(myKids: sons),
                          );
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 6),
                      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
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
                            "RECOMMENDED GIFTS",
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
                        child: generateRecommendedGiftsList(
                        ),
                      ),
                    )

                    //Recommended activites based on age
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*

class generateKidGiftsList extends StatelessWidget {
  final Kid mykid;
  final Function removeGift;
  generateKidGiftsList({this.mykid, this.removeGift});
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final GiftsList = Provider.of<List<Gift>>(context);
    return GiftsList==null ? Container() : ListView.builder(
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
  GiftsTiles(
      {this.gift,
        this.height,
        this.width,
        this.mykid,
        this.removeGift});

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
              Expanded(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          recommendedGiftCustomDialog(
                            giftID: this.gift.giftID,
                            giftPrice: this.gift.price,
                            giftName: this.gift.name,
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
                                await DatabaseService(uid: user.uid)
                                    .removeGiftFromSon(this.mykid.sonUID,
                                    this.gift.giftID);
                                this.removeGift(this.gift.giftID);
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
                      width: this.width / 1.5,
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
                                  width: 35,
                                  height: 35,
                                  child: Image.asset("assets/trash.png"))),
                          Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "REMOVE THIS GIFT",
                                  style: TextStyle(color: greenColor),
                                ),
                              )),
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

*/


class CustomDialogGifts extends StatefulWidget {
  final List<Kid> myKids;

  CustomDialogGifts({Key key, @required this.myKids}) : super(key: key);

  @override
  _CustomDialogGiftsState createState() => new _CustomDialogGiftsState(myKids: myKids);
}

class _CustomDialogGiftsState extends State<CustomDialogGifts> {
  _CustomDialogGiftsState({this.myKids});

  final List<Kid> myKids;
  String giftName;
  String _chosenValue;
  int giftPrice = 0;


  final _activityKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SimpleDialog(
      title: Text("Add Gift", style: TextStyle(color: yellowColor)),
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
                  borderRadius: BorderRadius.circular(45),
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
                                hintText: 'GIFT NAME',
                                hintStyle: TextStyle(color: greenColor),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20.0)),
                            style: TextStyle(
                              color: greenColor,
                            ),
                            validator: (val) =>
                            val.isEmpty
                                ? 'Enter a valid Gift name '
                                : null,
                            onChanged: (val) {
                              giftName = val;
                            },
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                fillColor: yellowColor,
                                hintText: 'GIFT PRICE',
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
                                return 'Enter a valid Gift Price';
                            },
                            onChanged: (val) {
                              giftPrice = int.parse(val);
                            },
                          ),
                          SizedBox(height: 10.0),
                          Text("ENTER THE NUMBER OF COINS FOR THIS GIFT", style: TextStyle(color: yellowColor, fontSize: 10),),
                          SizedBox(height: 10.0),

                          Container(

                            decoration: BoxDecoration(
                                color: Color(
                                  0xff173434,
                                ),
                                shape: BoxShape.rectangle,
                                border: Border.all(color: yellowColor),
                                borderRadius: BorderRadius.all(Radius.circular(25))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: greenColor,),
                                  child: DropdownButton<String>(
                                    hint: Text("CHOOSE YOUR KID", style: TextStyle(fontFamily: 'Funhouse', color: yellowColor),),
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    iconDisabledColor: Colors.white,
                                    iconEnabledColor: Colors.white,
                                    value: _chosenValue,
                                    underline: Container(), // this is the magic
                                    items: myKids
                                        .map<DropdownMenuItem<String>>((Kid myKid) {
                                      return DropdownMenuItem<String>(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context).size.width / 10,
                                              left: MediaQuery.of(context).size.width / 6),
                                          child: Text(
                                            myKid.name,
                                            style: TextStyle(fontFamily: 'Funhouse', color: yellowColor),
                                          ),
                                        ),
                                        value: myKid.sonUID,
                                      );
                                    }).toList(),
                                    onChanged: (String value) {
                                      setState(() {
                                        _chosenValue = value;
                                      });
                                      print(_chosenValue);
                                    },
                                  ),
                                ),
                              ],
                            ),
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
                                  'Add Gift',
                                  style: TextStyle(color: greenColor),
                                ),
                                onPressed: () async {
                                  if (_activityKey.currentState.validate()) {
                                    await DatabaseService(uid: user.uid)
                                        .createNewGift(
                                        giftName,
                                        giftPrice,
                                      false
                                        );
                                    await DatabaseService(uid: user.uid)
                                        .addGiftToSon(_chosenValue);
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


class recommendedGiftCustomDialog extends StatefulWidget {

  final String giftName;
  final int giftPrice;
  final String giftID;
  final List<Kid> myKids;

  recommendedGiftCustomDialog(
      {Key key,
        @required this.giftName,
        @required this.giftPrice,
        @required this.giftID,
      @required this.myKids})
      : super(key: key);

  @override
  _recommendedGiftCustomDialogState createState() =>
      new _recommendedGiftCustomDialogState(
          giftID: giftID,
          giftName: giftName,
          giftPrice: giftPrice,
      myKids: myKids);
}

class _recommendedGiftCustomDialogState
    extends State<recommendedGiftCustomDialog> {
  _recommendedGiftCustomDialogState(
      { this.giftName, this.giftPrice, this.giftID, this.myKids});

  final List<Kid> myKids;
  final String giftName;
  final int giftPrice;
  final String giftID;
  String sonUID;


  final _giftKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    return SimpleDialog(
      title: Text("Add Gift", style: TextStyle(color: yellowColor)),
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


                          Container(
                            decoration: BoxDecoration(
                                color: Color(
                                  0xff173434,
                                ),
                                shape: BoxShape.rectangle,
                                border: Border.all(color: yellowColor),
                                borderRadius: BorderRadius.all(Radius.circular(25))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Theme(
                                  data: Theme.of(context).copyWith(
                                    canvasColor: greenColor,),
                                  child: DropdownButton<String>(
                                    hint: Text("CHOOSE YOUR KID", style: TextStyle(fontFamily: 'Funhouse', color: yellowColor),),
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    iconDisabledColor: Colors.white,
                                    iconEnabledColor: Colors.white,
                                    value: sonUID,
                                    underline: Container(), // this is the magic
                                    items: myKids
                                        .map<DropdownMenuItem<String>>((Kid myKid) {
                                      return DropdownMenuItem<String>(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              right: MediaQuery.of(context).size.width / 10,
                                              left: MediaQuery.of(context).size.width / 6),
                                          child: Text(
                                            myKid.name,
                                            style: TextStyle(fontFamily: 'Funhouse', color: yellowColor),
                                          ),
                                        ),
                                        value: myKid.sonUID,
                                      );
                                    }).toList(),
                                    onChanged: (String value) {
                                      setState(() {
                                        sonUID = value;
                                      });
                                      print(sonUID);
                                    },
                                  ),
                                ),
                              ],
                            ),


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
                                  'Add GIFT',
                                  style: TextStyle(color: greenColor),
                                ),
                                onPressed: () async {
                                  if (_giftKey.currentState.validate()) {
                                    //await DatabaseService(uid: user.uid).createNewActivity(activityName, activityReward, startDate, endDate, isDaily, false);
                                    await DatabaseService(uid: user.uid)
                                        .addRecommendedGiftToSon(
                                        sonUID, giftID);

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


class DropdownExample extends StatefulWidget {

final List<Kid>mysons;

  DropdownExample({this.mysons});
  @override
  _DropdownExampleState createState() {
    return _DropdownExampleState();
  }
}

class _DropdownExampleState extends State<DropdownExample> {
  String _value = "one";
  List<DropdownButton<String>> mymenuitems=[];


  @override
  Widget build(BuildContext context) {
    return Expanded(
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
              child: Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 10,
                    left: MediaQuery.of(context).size.width / 6),
                child: Text(
                  'ACTIVITIES',
                  style: TextStyle(fontFamily: 'Funhouse', color: yellowColor),
                ),
              ),
              value: 'one',
            ),
            DropdownMenuItem<String>(
              child: Padding(
                padding: EdgeInsets.only(
                    right: MediaQuery.of(context).size.width / 10,
                    left: MediaQuery.of(context).size.width / 6),
                child: Text('GIFTS',
                    style:
                    TextStyle(fontFamily: 'Funhouse', color: yellowColor)),
              ),
              value: 'two',
            ),
          ],
          onChanged: (String value) {
            setState(() {

              if(_value!=value){
                _value = value;
              }

            });
          },
          value: _value,

        ),
      ),
    );
  }
}

class generateRecommendedGiftsList extends StatelessWidget {


  generateRecommendedGiftsList();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final recommendedGifts = Provider.of<List<Gift>>(context);
    final myKids = Provider.of<List<Kid>>(context);
    return recommendedGifts==null ? Container():ListView.builder(
        itemCount: recommendedGifts.length,
        itemBuilder: (context, index) {
          return recommendedGiftsTiles(
            gift: recommendedGifts[index],
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            myKids: myKids,
          );
        });
  }
}



class recommendedGiftsTiles extends StatelessWidget {
  final Gift gift;
  final double height;
  final double width;
  final List<Kid> myKids;
  recommendedGiftsTiles(
      {this.gift, this.height, this.width, this.myKids});

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
              gift.name,
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
            child: Text(gift.price.toString(),
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
                      recommendedGiftCustomDialog(
                        giftName: gift.name,
                        giftID: gift.giftID,
                        giftPrice: gift.price,
                        myKids: myKids,
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
