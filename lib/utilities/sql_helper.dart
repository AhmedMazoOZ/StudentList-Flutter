import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:studentdatabase/models/student.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

class SQL_Helper {
  static SQL_Helper dbhelper = SQL_Helper.createInstance();
  Database ?_database;

  SQL_Helper.createInstance();

  factory SQL_Helper() {
    if (dbhelper == null) {
      dbhelper = SQL_Helper.createInstance();
    }

    return dbhelper;
  }

  String tablename = "student_table";
  String _id = "id";
  String _name = "name";
  String _description = "description";
  String _pass = "pass";
  String _date = "date";

  Future <Database?> get database async {
    if (_database != null) {
      debugPrint("Asddd+1"+"Donnnnne22");
      return _database;

    } else if (_database == null) {
      _database = await initializedDatabase();
      debugPrint("Asddd+2"+"Donnnnne");
      return _database;
    }
  }

/*
Future<Database> Inintializeddatabase() async {
  Directory directory = await getApplicationDocumentsDirectory();
  String path = directory.path + "/student.db";
  debugPrint("Asddd+1"+path);
  var studentdb = await openDatabase(
      path, version: 1, onCreate: createdatabase);
  debugPrint(studentdb.toString());

  return studentdb;
}
*/
  Future<Database> initializedDatabase() async {
    var directory = await getDatabasesPath();
    String path = p.join(directory.toString(), "imo.db");
    debugPrint("Asddd+1"+path);
    /// create the database
    var notesDatabase = await openDatabase(
        path, version: 1, onCreate: createdatabase);
    return notesDatabase;
  }


void createdatabase(Database database, int verion) async {
  await database.execute(
      "CREATE TABLE $tablename($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_name TEXT,$_description TEXT ,$_pass INTEGER,"
          "$_date TEXT)");
}
/*
  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $tablename($_id INTEGER PRIMARY KEY AUTOINCREMENT, $_name TEXT, '
        '$_description TEXT, $_pass INTEGER, $_date TEXT)');
  }

   */
Future<List<Map<String, dynamic>>?> getstudentmaplist() async {
  Database ?db = await this.database;
  // var  result= await db?.query(tablename,orderBy: "$_id ASC");
  var result1 = await db?.rawQuery(
      "SELECT * FROM $tablename ORDER BY $_id ASC");
  debugPrint("User click result $result1");
  return result1;
}

Future<int?> InsertStudent(Student student) async {
  Database ?db = await this._database;
  var result = await db?.insert(tablename, student.tomap());
  return result;
}

Future<int?> UpdateStudent(Student student) async {
  Database ?db = await this._database;
  var result = await db?.update(
      tablename, student.tomap(), where: "$_id=?", whereArgs: [student.id]);
  return result;
}

Future<int?> DeleteStudent(int? id) async {
  Database ?db = await this._database;
  int? result = await db?.rawDelete("DELETE FROM $tablename WHERE $_id=$id");
  return result;
}

Future<int?> getcount() async {
  Database ?db = await this._database;
  List<Map<String, Object?>>? all = await db?.rawQuery(
      "SELECT COUNT (*) FROM $tablename ");
  int? result = Sqflite.firstIntValue(all!);
  return result;
}

Future<List<Student>> getstudentlist() async {
  var studenmaptlist = await getstudentmaplist();
  int? listcount = studenmaptlist?.length;
  debugPrint("User click save $listcount");
  List<Student>studentlist = <Student>[];
  for (int i = 0; i <= listcount! - 1; i++) {
    studentlist.add(Student.getMap(studenmaptlist![i]));
  }
  return studentlist;
}}
