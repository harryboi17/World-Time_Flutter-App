class AlarmInfo {
  int? id;
  String title;
  DateTime alarmDateTime;
  int isPending;
  int isRepeat;
  int gradientColorIndex;
  // tz.Location location;

  AlarmInfo({
        required this.id,
        required this.title,
        required this.alarmDateTime,
        required this.isPending,
        required this.isRepeat,
        required this.gradientColorIndex,
        // required this.location
  });

  // Future<void> initID() async{
  //   AlarmHelper alarmHelper = AlarmHelper();
  //   alarmHelper.initializeDatabase().then((value){
  //     this.id = alarmHelper.getId();
  //   });
  // }

  factory AlarmInfo.fromMap(Map<String, dynamic> json) => AlarmInfo(
    id: json["id"],
    title: json["title"],
    alarmDateTime: DateTime.parse(json["alarmDateTime"]),
    isPending: json["isPending"],
    isRepeat: json["isRepeat"],
    gradientColorIndex: json["gradientColorIndex"],
    // location: json["location"]
  );
  Map<String, dynamic> toMap() => {
    "id": id,
    "title": title,
    "alarmDateTime": alarmDateTime.toIso8601String(),
    "isPending": isPending,
    "isRepeat": isRepeat,
    "gradientColorIndex": gradientColorIndex,
    // "location" : location.toString(),
  };
}