import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';


/*-------------------------------------
Data Class
--------------------------------------*/
class Calc {
  final int fromValue;
  final int toValue;
  final String fromUnit;
  final String toUnit;

  Calc({this.fromValue, this.toValue, this.fromUnit, this.toUnit});

  Map<String, dynamic> toMap() {
    return {
      'fromValue': fromValue,
      'toValue': toValue,
      'fromUnit': fromUnit,
      'toUnit': toUnit,
    };
  }

  @override
  String toString() {
    return '$fromValue$fromUnit = $toValue$toUnit';
  }
}


/*-------------------------------------
Database
--------------------------------------*/
class DatabaseProvider {
  DatabaseProvider._();
  static const databaseName = 'calc_database.db';

  // Class Instance
  static final DatabaseProvider instance = DatabaseProvider._();

  // Database Instance
  static Database _database;

  // Database getter
  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }
 
  //Database Initializer
  Future<Database> initializeDatabase() async {
    print('Initialize');

    // Avoid errors caused by flutter upgrade.
    WidgetsFlutterBinding.ensureInitialized(); 

    // Make sure database directory exists
    var databasesPath = await getDatabasesPath();
    try {
      await Directory(databasesPath).create(recursive: true);
    } catch (_) {}

    // Open Database
    return await openDatabase(join(databasesPath, databaseName),
      onCreate: (Database db, int version) async {
        await db.execute(
          "CREATE TABLE calcs(id INTEGER PRIMARY KEY, fromValue INTEGER, toValue INTEGER, fromUnit TEXT, toUnit TEXT)"
        );
      },
      version: 1,
    );
  }


  /*-------------------------------------
  Insert
  --------------------------------------*/
  Future<void> insertCalc(Calc calc) async {
    final Database db = await database;

    try {
      await db.insert(
        'calcs',
        calc.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (err) {
      print(err);
    }
  }

  
  /*-------------------------------------
  Get Saved Results
  --------------------------------------*/
  Future<List<Calc>> getCalcs() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('calcs');

    return List.generate(maps.length, (i) {
      return Calc(
        fromValue: maps[i]['fromValue'],
        toValue: maps[i]['toValue'],
        fromUnit: maps[i]['fromUnit'],
        toUnit: maps[i]['toUnit']
      );
    });
  }
}
