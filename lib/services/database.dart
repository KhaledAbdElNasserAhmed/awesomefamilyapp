
import 'package:awesomefamilyapp/models/Activity.dart';
import 'package:awesomefamilyapp/models/Gift.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesomefamilyapp/models/Kids.dart';

class DatabaseService {
  final String uid;
  List<Kid> kidsList=[];
  List<String>activities=[];
  int totalActivities=0;
  List<String>gifts=[];
  DatabaseService({this.uid});
  static String currentActivityID;
  static String currentGiftID;
  static String currentSonID;

//Collection of parents database ( Contains all the parents accounts and data )
  final CollectionReference parentsCollection = Firestore.instance.collection('parents');
//Collection of Sons database ( Contains all the parents accounts and data )
  final CollectionReference sonsCollection = Firestore.instance.collection('sons');
  //Collection of Tasks database ( Public Activites that will be recommended to the users)

  final CollectionReference activitesCollection = Firestore.instance.collection('activities');

  //Collection of Gifts database ( Public Activites that will be recommended to the users)

  final CollectionReference giftsCollection = Firestore.instance.collection('gifts');

  //After Sign up Create a user directory in the database with null values if needed




  Future createNewUser(String email, String phone) async {
    return await parentsCollection.document(uid).setData({
      'Email': email,
      'phone': phone,
      'notifications':List<String>()
    });
  }
//Notifications template - Son Name - Notification
  Future addNotificationToParent(String parentUID, String sonName, bool isActivity, String task) async {
    List<String> temp = List();

    if(isActivity)
      temp.add(sonName.toUpperCase() +"-"+ " Finished " + task + " Activity");
   else
      temp.add(sonName.toUpperCase() +"-"+ " Wants a/an " + task);

    return await parentsCollection.document(parentUID).updateData({"notifications": FieldValue.arrayUnion(temp)});

  }


  Future<List<String>>getNotifications() async{


    return  Firestore.instance.collection('parents').document(this.uid)
        .get().then((DocumentSnapshot){

      return List.from(DocumentSnapshot['notifications']);

    });


  }

  Future removeNotification(String notification) async {
    List<String> temp = List();
    temp.add(notification);
    return await parentsCollection.document(uid).updateData({"notifications": FieldValue.arrayRemove(temp)});

  }
/*  void newParentWithSonsSubcollection() {

    Firestore.instance.collection('parentsWithSubcollection').document('LoKs0aKtuNXdTo0kMy3m').get().then((value) {
      print(value.documentID);
      Firestore.instance.collection('parentsWithSubcollection')
          .document(value.documentID)
          .collection("pets")
          .add({"petName": "blacky3", "petType": "dog", "petAge": 1});
    });

  }*/


  void returbSubcollection(){

      Firestore.instance.collection('parentsWithSubcollection').getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((result) {
          Firestore.instance.collection('parentsWithSubcollection')
              .document(result.documentID)
              .collection("pets")
              .getDocuments()
              .then((querySnapshot) {
            querySnapshot.documents.forEach((result) {
              print(result.data['petAge']);
            });
          });
        });
      });


  }

  //CHILD SECTION .map(_KidFromSnapshot);
  Future<Kid>getKid(String childID) async{

    return  Firestore.instance.collection('sons').document(childID)
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
          rating: DocumentSnapshot.data['rating']??5.0,

      );

    });


  }

//  Kid _KidFromSnapshot(QuerySnapshot snapshot){
//
//      return Kid(
//          name: doc.data['name']?? '',
//          nickname: doc.data['nickname']?? '',
//          gender: doc.data['gender']?? '',
//          databaseBirthdate: doc.data['birthdate']?? '',
//          parentUID: doc.data['parentUID']?? '',
//          parentEmail: doc.data['parentEmail'],
//          sonUID: doc.data['sonUID'],
//          activities: List.from(doc['activities']),
//          gifts: List.from(doc['gifts'])
//
//      );
//
//  }






//////SON SECTION/////

  Stream<List<Kid>> get sons{
    return sonsCollection.snapshots().map(_sonsListFromSnapshot);
  }


  List<Kid> _sonsListFromSnapshot(QuerySnapshot snapshot){

    return snapshot.documents.where((doc) => doc.data['parentUID'] ==this.uid).map((doc){

      return Kid(
          name: doc.data['name']?? '',
          nickname: doc.data['nickname']?? '',
          gender: doc.data['gender']?? '',
          databaseBirthdate: doc.data['birthdate']?? '',
          parentUID: doc.data['parentUID']?? '',
          parentEmail: doc.data['parentEmail'],
          sonUID: doc.data['sonUID']??'',
          activities: List.from(doc['activities']),
          gifts: List.from(doc['gifts']),
          currentCoins: doc.data['currentcoins'],
          totalCoins: doc.data['totalcoins'],
          avatar: doc.data['avatar'],
          rating: doc.data['rating']

      );
    }).toList();
  }


  Future createNewSon(String name, String nickname, String gender, String birthdate, String parentID, String parentEmail, String avatar) async {

    DocumentReference dr = sonsCollection.document();
    String myId = dr.documentID;
    return await sonsCollection.document(myId).setData({
      'name': name,
      'nickname': nickname,
      'gender': gender,
      'parentUID':parentID,
      'birthdate':birthdate,
      'currentcoins':0,
      'totalcoins':0,
      'activities': List(),
      'parentEmail':parentEmail,
      'sonUID':myId,
      'gifts': List(),
      'avatar':avatar,
      'rating':5.0
    });
  }
/*//////GIFTS SECTION/////
  //////GIFTS SECTION/////
//////GIFTS SECTION/////
 */
  Future createNewGift(String name, int price, bool isShared) async {

    DocumentReference dr = giftsCollection.document();
    String myId = dr.documentID;
    currentGiftID=myId;
    return await giftsCollection.document(myId).setData({
      'name': name,
      'price': price,
      'isShared':false,
      'createdByID': uid,
      'giftID':myId
    });


  }



  Future addGiftToSon(String sonUID) async {
    List<String> temp = List();
    temp.add(currentGiftID);
    return await sonsCollection.document(sonUID).updateData({"gifts": FieldValue.arrayUnion(temp)});

  }

  Future addRecommendedGiftToSon(String sonUID, String giftID) async {
    List<String> temp = List();
    temp.add(giftID);
    return await sonsCollection.document(sonUID).updateData({"gifts": FieldValue.arrayUnion(temp)});

  }

  Future removeGiftFromSon(String sonUID, String giftID, int cost, int currentcoins,int totalcoins) async {
    List<String> temp = List();
    temp.add(giftID);
    this.gifts.remove(giftID);


    await subCoinsToSon(sonUID,cost,currentcoins);
    return await sonsCollection.document(sonUID).updateData({"gifts": FieldValue.arrayRemove(temp)});

  }

  Stream<List<Gift>> kidGifts(List<String>giftsList){
    this.gifts=List.from(giftsList);
    return giftsCollection.snapshots().map(_kidGiftsFromSnapshot);
  }
  List<Gift>_kidGiftsFromSnapshot(QuerySnapshot snapshot){

    return snapshot.documents.where((doc){
      if(this.gifts.contains(doc.data['giftID'])){
        return true;
      }else return false;

    } ).map((doc){

      return Gift(
          giftID: doc.data['giftID']?? '',
          createdByID: doc.data['createdByID']?? '',
          price: doc.data['price']?? '',
          name: doc.data['name'],
          isShared: doc.data['isShared'],
      );
    }).toList();
  }


  Stream<List<Gift>> get recommendedGifts{
    return giftsCollection.snapshots().map(_recommendedGiftsFromSnapshot);
  }
  List<Gift> _recommendedGiftsFromSnapshot(QuerySnapshot snapshot){

    return snapshot.documents.where((doc) => doc.data['isShared'] == true).map((doc){

      return Gift(
          giftID: doc.data['giftID']?? '',
          createdByID: doc.data['createdByID']?? '',
          price: doc.data['price']?? '',
          name: doc.data['name'],
          isShared: doc.data['isShared'],
      );
    }).toList();
  }





  //////ACTIVITIES SECTION/////
  Future addActivityToSon(String sonUID) async {
    List<String> temp = List();
    temp.add(currentActivityID);
    return await sonsCollection.document(sonUID).updateData({"activities": FieldValue.arrayUnion(temp)});

  }

  Future removeActivityFromSon(String sonUID, String activityID, int reward, int currentCoins, int totalCoins, bool isDaily) async {
    List<String> temp = List();
    DateTime now = new DateTime.now();

    if(isDaily){

      await addCoinsToSon(sonUID,reward,currentCoins, totalCoins);
      return await activitesCollection.document(activityID).updateData({"completionDate": DateTime(now.year, now.month, now.day).toString()});
    }
    else{
      temp.add(activityID);
      this.activities.remove(activityID);
      await addCoinsToSon(sonUID,reward,currentCoins, totalCoins);
       await activitesCollection.document(activityID).updateData({"completionDate": DateTime(now.year, now.month, now.day).toString()});
      return await sonsCollection.document(sonUID).updateData({"activities": FieldValue.arrayRemove(temp)});
    }

  }

  Future subCoinsToSon(String sonUID, int cost, int currentcoins) async {

    if(currentcoins == null)
      currentcoins=0;

    if(currentcoins < cost){ return null;}

    else{
      int newCoinsAmount = currentcoins-cost;
      return await sonsCollection.document(sonUID).updateData({"currentcoins": newCoinsAmount});
    }


  }


  Future addCoinsToSon(String sonUID, int reward, int currentCoins, int totalCoins) async {

    if(currentCoins == null)
      currentCoins=0;
    int newCoinsAmount = currentCoins+reward;
    await sonsCollection.document(sonUID).updateData({"currentcoins": newCoinsAmount});
    return await sonsCollection.document(sonUID).updateData({"totalcoins": totalCoins+reward});
  }

  Future addRecommendedActivityToSon(String sonUID, String activityID, String name, int reward, String startDate, String endDate, bool isDaily, bool isShared) async {
    DocumentReference dr = activitesCollection.document();
    String myId = dr.documentID;
    currentActivityID=myId;
    await activitesCollection.document(myId).setData({
      'name': name,
      'reward': reward,
      'startDate': startDate,
      'endDate':endDate,
      'reward':reward,
      'isDaily':isDaily,
      'isShared':false,
      'createdByID': uid,
      'ActivityID':myId,
      'completionDate':"",
      'kidUID':sonUID
    });
    List<String> temp = List();
    temp.add(currentActivityID);
    return await sonsCollection.document(sonUID).updateData({"activities": FieldValue.arrayUnion(temp)});

  }


  Future createNewActivity(String name, int reward, String startDate, String endDate, bool isDaily, bool isShared, String kidUID) async {

    DocumentReference dr = activitesCollection.document();
    String myId = dr.documentID;
    currentActivityID=myId;
    return await activitesCollection.document(myId).setData({
      'name': name,
      'reward': reward,
      'startDate': startDate,
      'endDate':endDate,
      'reward':reward,
      'isDaily':isDaily,
      'isShared':false,
      'createdByID': uid,
      'ActivityID':myId,
      'completionDate':"",
      'kidUID':kidUID
    });


  }



  Stream<List<Activity>> kidActivities(List<String>activitiesList){
    if(activitiesList==null){

    }
    else{
      this.activities=List.from(activitiesList);
      return activitesCollection.snapshots().map(_kidActivitiesFromSnapshot);
    }

  }
  List<Activity> _kidActivitiesFromSnapshot(QuerySnapshot snapshot){

    return snapshot.documents.where((doc){
    if(this.activities.contains(doc.data['ActivityID'] )){
      double rating=0;
     // if(doc.data['ActivityID'])
      totalActivities++;
      print(doc.data['kidUID'].toString());
      print("A new Activity Has been added $totalActivities");
      // convert from string to actual date, to be able to compare it
      String stringDate = doc.data['endDate'];
      String completionDate = doc.data['completionDate'];
     // DateTime dt2 = DateTime.parse(completionDate);
      DateTime now = new DateTime.now();
      DateTime date = new DateTime(now.year, now.month, now.day);
      String sonUID =  doc.data['kidUID'].toString();
      List<String> temp = stringDate.split('/');
      DateTime dt = DateTime(int.parse(temp[2]),int.parse(temp[0]),int.parse(temp[1]));
      //print("Completion date : " + dt2.toString());
      if(totalActivities!=0)
      rating= (((totalActivities)- activities.length)/totalActivities)*5;

      print("Rating = "+ rating.toString());
      print("Total = "+ totalActivities.toString());
      print("Current = "+ activities.length.toString());
      sonsCollection.document(sonUID).updateData({"rating": rating});


      if(DateTime.now().isAfter(dt.add(Duration(days: 1)))){
        totalActivities--;
        print("A old Activity Has been removed  $totalActivities");
//Update Rating
        List<String> temp = List();
        temp.add(doc.data['ActivityID']);
        this.activities.remove(doc.data['ActivityID']);
        sonsCollection.document(sonUID).updateData({"activities": FieldValue.arrayRemove(temp)});
       // sonsCollection.document(sonUID).updateData({"activities": FieldValue.arrayRemove(temp)});
        return false;
      }

      else if (date.toString() == completionDate){
        this.activities.remove(doc.data['ActivityID']);
        print("Active Activities = " + activities.length.toString());
        if(totalActivities!=0)
          rating= (((totalActivities)- activities.length)/totalActivities)*5;
        sonsCollection.document(sonUID).updateData({"rating": rating});

        return false;
      }

      return true;
    }else return false;

    }


    ).map((doc){
      return Activity(
          activityID: doc.data['ActivityID']?? '',
          createdByID: doc.data['createdByID']?? '',
          dateTo: doc.data['endDate']?? '',
          dateFrom: doc.data['startDate']?? '',
          reward: doc.data['reward']?? '',
          name: doc.data['name'],
          isShared: doc.data['isShared'],
          isDaily: doc.data['isDaily'],
          completionDate:doc.data['completionDate'],
        kidUID: doc.data['kidUID'],
      );
    }).toList();
  }


  Future<double> getRating()async{


  }

  int getActivitesfromUI(){
    return this.totalActivities;

  }


  Stream<List<Activity>> get recommendedActivities{
    return activitesCollection.snapshots().map(_recommendedActivitiesFromSnapshot);
  }
  List<Activity> _recommendedActivitiesFromSnapshot(QuerySnapshot snapshot){

    return snapshot.documents.where((doc) => doc.data['isShared'] == true).map((doc){

      return Activity(
          activityID: doc.data['ActivityID']?? '',
          createdByID: doc.data['createdByID']?? '',
          dateTo: doc.data['endDate']?? '',
          dateFrom: doc.data['startDate']?? '',
          reward: doc.data['reward']?? '',
          name: doc.data['name'],
          isShared: doc.data['isShared'],
          isDaily: doc.data['isDaily'],
          completionDate: "",
          kidUID: ""
      );
    }).toList();
  }






}
