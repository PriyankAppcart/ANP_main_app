import 'dart:io';

import 'package:doer/sqliteDB/DBHelper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class TableProject {

  final instance = DatabaseHelper.instance;

  //====================== tbl_name =====================================================
  static final tbl_name = 'tbl_drp_collection';
  static final columnId = '_id';
  static final drp_collection = "drp_collection";

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(tbl_name, row);
  }

  // All of the rows are returned as a list of maps, where each map is
  // a key-value list of columns.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(tbl_name);
  }

  Future<List<Map<String, dynamic>>> queryRowCount() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $tbl_name');
  }
  Future<List<Map<String, dynamic>>> querySelectRows(urls) async {
    Database db = await instance.database;
    return await db.rawQuery('''
    SELECT * FROM $tbl_name 
    WHERE $url = ?
    ''',
        [urls]);
  }

  Future<void> deleteall() async {
    Database db = await instance.database;
    await db.delete(tbl_name);

  }
}