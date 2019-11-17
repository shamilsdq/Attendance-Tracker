import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';


class Details 
{
  int dateid;
  bool h1 = false, h2 = false, h3 = false, h4 = false, h5 = false, h6 = false;
  int total = 0, working = 6;
  DB db = DB();

  Details(DateTime date)
  {
    var temp = date.year.toString();
    if(date.month < 10) temp = temp + '0';
    temp = temp + date.month.toString();
    if(date.day < 10) temp = temp + '0';
    temp = temp + date.day.toString();
    dateid = int.parse(temp);
  }

  Map<String, dynamic> toMap()
  {
    var map = Map<String, dynamic>();
    map['dateid'] = dateid;
    map['h1'] = h1;
    map['h2'] = h2;
    map['h3'] = h3;
    map['h4'] = h4;
    map['h5'] = h5;
    map['h6'] = h6;
    map['total'] = total;
    map['working'] = working;
    return map;
  }

  Details.fromMap(Map<String, dynamic> map)
  {
    dateid = map['dateid'];
    h1 = map['h1']!=0;
    h2 = map['h2']!=0;
    h3 = map['h3']!=0;
    h4 = map['h4']!=0;
    h5 = map['h5']!=0;
    h6 = map['h6']!=0;
    total = map['total'];
    working = map['working'];
  }

  update() async
  {
    db.update(this);
    print("day = ${this.total} / ${this.working}");
  }

  refresh() async
  {
    var date = DateTime(int.parse(dateid.toString()[0]+dateid.toString()[1]+dateid.toString()[2]+dateid.toString()[3]), int.parse(dateid.toString()[4]+dateid.toString()[5]), int.parse(dateid.toString()[6]+dateid.toString()[7]));
    if(date.weekday == 7) date = date.add(new Duration(days: -2));
    else if(date.weekday == 6) date = date.add(new Duration(days: -1));

    dateid = (date.year * 100 + date.month) * 100 + date.day;
    print (dateid);

    var temp = await db.fetch(this.dateid);
    if(temp == null) db.add(this);
    else
    {
      this.h1 = temp.h1;
      this.h2 = temp.h2;
      this.h3 = temp.h3;
      this.h4 = temp.h4;
      this.h5 = temp.h5;
      this.h6 = temp.h6;
      this.total = temp.total;
      this.working = temp.working;
    }
  }

  remove() async
  {
    db.remove(dateid);
  }
}




class Stats
{
  int total=0, working=0;
  DB db = DB();

  Stats(this.total, this.working);

  Stats.fromDB(Map<String, dynamic> map)
  {
    total = map['total'];
    working = map['working'];
  }

  update() async
  {
    var result = await db.getStats();
    if (result != null && result.working != null) 
    { 
      this.total = result.total;
      this.working = result.working;
    }
    print("total = ${this.total} / ${this.working}");
  }
}




class DB
{
  static final DB _instance = DB._();
  static Database _database;

  DB._();

  factory DB() => _instance;

  Future<Database> get db async {
    if (_database != null) return _database;
    _database = await init();
    return _database;
  }

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'database.db');
    var database = openDatabase(
      dbPath, 
      version: 1, 

      onCreate: (Database db, int version) {
        db.execute('''
          CREATE TABLE details(
            dateid INT PRIMARY KEY,
            h1 BOOLEAN,
            h2 BOOLEAN,
            h3 BOOLEAN,
            h4 BOOLEAN,
            h5 BOOLEAN,
            h6 BOOLEAN,
            total INTEGER NOT NULL DEFAULT 0,
            working INTEGER NOT NULL DEFAULT 0
          )
        ''');
        print("Database was created!");
      },

      onUpgrade: (Database db, int oldVersion, int newVersion) { /* Run migration according database versions */},
    );
    return database;
  }



  // CRUD operations

  Future<int> add(Details day) async {
    var client = await db;
    return client.insert('details', day.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  
  Future<Details> fetch(int dateid) async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureMaps = client.query('details', where: 'dateid = ?', whereArgs: [dateid]);
    var maps = await futureMaps;
    if (maps.length != 0) return Details.fromMap(maps.first);
    return null;
  }

  Future<int> update(Details newday) async {
    var client = await db;
    return client.update('details', newday.toMap(), where: 'dateid = ?', whereArgs: [newday.dateid], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Details>> fetchAll() async {
    var client = await db;
    var result = await client.rawQuery('SELECT * FROM details');
    if(result.length == 0) return null;
    List<Details> list = result.map((item) => Details.fromMap(item)).toList();
    return list;
  }

  Future<void> remove(int dateid) async {
    var client = await db;
    return client.delete('details', where: 'dateid = ?', whereArgs: [dateid]);
  }



  // Statistics operations

  Future<Stats> getStats() async {
    var client = await db;
    final Future<List<Map<String, dynamic>>> futureStats = client.rawQuery("SELECT SUM(total) as total, SUM(working) as working FROM details");
    var stats = await futureStats;
    if(stats.length!=0) return Stats.fromDB(stats.first);
    else return getStats();
  }

  Future<void> clearStats() async {
    var client = await db;
    return client.rawQuery("TRUNCATE details");
  }
}