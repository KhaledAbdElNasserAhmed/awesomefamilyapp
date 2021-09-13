
class Activity{

  final String name;
  final String activityID;
  final bool isDaily;
  final String createdByID;
  final String dateFrom;
  final String dateTo;
  final int reward;
  final bool isShared;
  final String completionDate;
  final String kidUID;


  Activity({this.completionDate, this.name, this.activityID, this.isDaily, this.createdByID, this.dateFrom,this.dateTo, this.reward,this.isShared, this.kidUID});
}