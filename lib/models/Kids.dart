import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Date{
   int days;
   int months;
   int years;

   Date({this.days, this.months, this.years} );
}


class Kid {
   String parentEmail;
   String parentUID;
   String avatar;
   String name;
   String nickname;
   String gender;
   Date birthdate;
   String databaseBirthdate;
   int currentCoins;
   int totalCoins;
   List<String> activities;
   String sonUID;
   List<dynamic> temp;
   List<String> gifts;
   double rating;



   Kid({this.rating, this.name,this.nickname,this.databaseBirthdate,this.gender,this.parentEmail,this.parentUID,this.sonUID, this.activities, this.gifts, this.currentCoins, this.totalCoins, this.avatar:"avatar_1.png"});





  void setBirthDate(DateTime dt) {
    this.birthdate = Date();
    this.birthdate.days = dt.day;
    this.birthdate.months = dt.month;
    this.birthdate.years = dt.year;
    String __days;
    String __months;


    if(this.birthdate.days<10){
      __days='0'+this.birthdate.days.toString();
    }
    else{__days = this.birthdate.days.toString();}

    if(this.birthdate.months<10){
      __months='0'+this.birthdate.months.toString();
    }
    else{__months = this.birthdate.months.toString();}



    this.databaseBirthdate = this.birthdate.years.toString()+__months+__days;


  }

String convertBirthDate(){

    String __days;
    String __months;


    if(this.birthdate.days<10){
      __days='0'+this.birthdate.days.toString();
    }
    else{__days = this.birthdate.days.toString();}

    if(this.birthdate.months<10){
      __months='0'+this.birthdate.months.toString();
    }
    else{__months = this.birthdate.months.toString();}



    this.databaseBirthdate = this.birthdate.years.toString()+__months+__days;

    return this.databaseBirthdate;
}



   factory Kid.fromFireStore(DocumentSnapshot doc)
   {
     Map data = doc.data ;

     return Kid(
         name: data['Name'],
         databaseBirthdate: data['birthdate'],
         gender: data['gender'],
         nickname: data['nickname']

     );
   }
}