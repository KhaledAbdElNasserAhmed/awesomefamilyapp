import 'package:awesomefamilyapp/models/Activity.dart';
import 'package:awesomefamilyapp/services/auth.dart';
import 'package:awesomefamilyapp/services/database.dart';
import 'package:flutter/material.dart';
import 'navigationclass.dart';
import 'DestinationView.dart';
import 'package:provider/provider.dart';
import 'package:awesomefamilyapp/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesomefamilyapp/models/Kids.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //print(user.uid);
    return FutureBuilder(
      future: DatabaseService(uid:user.uid).getNotifications(),
      builder: (context, snapshot) {
        if(snapshot.hasData){
        return FutureProvider<List<String>>.value(
            value:DatabaseService(uid:user.uid).getNotifications(),
          builder: (context, snapshot) {
            return StreamProvider<List<Kid>>.value(
              value:DatabaseService(uid:user.uid).sons,
              child: StreamBuilder(
                stream:DatabaseService(uid:user.uid).sons,
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    return Scaffold(
                      body: SafeArea(
                        top: false,
                        child: IndexedStack(
                          index: _currentIndex,
                          children: allDestinations.map<Widget>((Destination destination) {
                            return DestinationView(destination: destination);
                          }).toList(),
                        ),
                      ),
                      bottomNavigationBar: BottomNavigationBar(
                        backgroundColor: Color(0xff173434),
                        selectedItemColor: Colors.white,
                        currentIndex: _currentIndex,
                        onTap: (int index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        items: allDestinations.map((Destination destination) {
                          return BottomNavigationBarItem(
                              icon: Icon(destination.icon),
                              backgroundColor: destination.color,
                              title: Text(destination.title)
                          );
                        }).toList(),
                      ),
                    );

                  }
                  else return CircularProgressIndicator();

                },
              ),
            );
          }
        );}
        else return CircularProgressIndicator();
      }
    )??CircularProgressIndicator();
  }
}