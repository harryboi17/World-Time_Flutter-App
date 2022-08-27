import 'package:sqflite/sqflite.dart';
import 'package:world_time/models/alarm_info.dart';
import 'package:path/path.dart';

const String tableAlarm = 'alarm';
const String columnId = 'id';
const String columnTitle = 'title';
const String columnDateTime = 'alarmDateTime';
const String columnPending = 'isPending';
const String columnRepeating = 'isRepeat';
const String columnColorIndex = 'gradientColorIndex';
const String columnLocation = 'location';

class AlarmHelper{
  static final AlarmHelper alarmHelper = AlarmHelper._init();
  static Database? _dataBase;

  AlarmHelper._init();

  Future<Database> get database async{
    if(_dataBase == null){
      _dataBase = await initializeDatabase();
    }
    return _dataBase!;
  }

  Future<Database> initializeDatabase() async {
    final dir = await getDatabasesPath();
    final path = join(dir, 'alarm.db');

    var database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
        const textType = 'TEXT NOT NULL';
        const integerType = 'INTEGER';
        const boolType = 'BOOLEAN NOT NULL';

        await db.execute('''
        CREATE TABLE $tableAlarm(
        $columnId $idType,
        $columnTitle $textType,
        $columnDateTime $textType,
        $columnPending $integerType,
        $columnRepeating $integerType,
        $columnColorIndex $integerType
        ) 
        ''');
      },
    );
    return database;
  }

  Future<void> insertAlarm(AlarmInfo alarmInfo) async{
    var db = await alarmHelper.database;
    var result = await db.insert(tableAlarm, alarmInfo.toMap());
    print('insert result : $result');
  }

  Future<int?> getId() async{
    var db = await alarmHelper.database;
    var cursor = await db.query(tableAlarm);
    if(cursor.isEmpty){return 0;}

    var result = cursor.last;
    return AlarmInfo.fromMap(result).id! + 1;
  }

  Future<List<AlarmInfo>> getAlarms() async {
    List<AlarmInfo> _alarms = [];

    var db = await alarmHelper.database;
    var result = await db.query(tableAlarm);
    result.forEach((element) {
      var alarmInfo = AlarmInfo.fromMap(element);
      _alarms.add(alarmInfo);
    });

    return _alarms;
  }

  Future<void> delete(int id) async {
    var db = await alarmHelper.database;
    var result = await db.delete(tableAlarm, where: '$columnId = ?', whereArgs: [id]);
    print("delete result : $result");
  }
  
  Future<void> updateAlarm(int id, AlarmInfo alarmInfo) async{
    var db = await alarmHelper.database;
    var result = await db.update(
        tableAlarm,
        alarmInfo.toMap(),
        where: '$columnId = ?',
        whereArgs: [id]
    );
    print("update result : $result");
  }

}