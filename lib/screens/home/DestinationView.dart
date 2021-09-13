import 'package:flutter/material.dart';
import 'Sons_Screen.dart';
import 'navigationclass.dart';
import 'Activities_Screen.dart';
import 'gifts_screen.dart';
import 'package:awesomefamilyapp/services/database.dart';
import 'package:awesomefamilyapp/models/Kids.dart';

class DestinationView extends StatefulWidget {
  const DestinationView({Key key, this.destination}) : super(key: key);
  final Destination destination;

  @override
  _DestinationViewState createState() =>
      _DestinationViewState(destinationName: destination.title);
}

class _DestinationViewState extends State<DestinationView> {
  String destinationName;
  Kid mykid = Kid();
  DatabaseService ds;

  _DestinationViewState({this.destinationName});

  @override
  Widget build(BuildContext context) {
    if (destinationName == "Sons")
      return SonsScreen();
    else if (destinationName == "Activites") {
      return (AlreadyHasKids());
    } else if (destinationName == "Gifts") {
      return (giftsScreen());
    } else
      return SonsScreen();
  }
}
