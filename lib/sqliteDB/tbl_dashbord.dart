import 'dart:io';

import 'package:doer/sqliteDB/DBHelper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class TableDashboard {


  final instance = DatabaseHelper.instance;

  //====================== tbl_dashboard =====================================================
  static final tbl_dashboard = 'tbl_dashboard';
  static final columnId = '_id';
  static final dahboard_list = "dahboard_list";




  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tbl_dashboard, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(tbl_dashboard);
  }

  Future<List<Map<String, dynamic>>> queryRowCount() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $tbl_dashboard');
  }
  Future<List<Map<String, dynamic>>> querySelectRows(urls) async {
    Database db = await instance.database;
    return await db.rawQuery('''
    SELECT * FROM $tbl_dashboard 
    WHERE $url = ?
    ''',
        [urls]);
  }

  Future<int> delete(urls) async {
    Database db = await instance.database;
    return await db.delete(tbl_dashboard, where: '$url = ?', whereArgs: [urls]);
  }

  Future<void> deleteall() async {
    Database db = await instance.database;
    await db.delete(tbl_dashboard);

  }


}