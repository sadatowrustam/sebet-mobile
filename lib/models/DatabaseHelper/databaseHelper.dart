import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note.dart';

class DatabasHelper {
  final String _dbName = "myDatabase.db";

  DatabasHelper._privateConstructor();

  static final DatabasHelper instance = DatabasHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initialeDatabase();
    return _database!;
  }

  _initialeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, _dbName);
    print(path);
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    final indexType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final idtype = 'INTEGER';
    await db.execute("""
    CREATE TABLE  $tableName ( 
   " ${NoteFields.columnIndex}" $indexType,
  "${NoteFields.produtId}" STRING,
   "${NoteFields.pricePro}" REAL,
    "${NoteFields.columnId}" $idtype,
    "${NoteFields.columnsany}" $idtype,
    "${NoteFields.brandname}" STRING,
     "${NoteFields.name}" STRING,
      "${NoteFields.brandnameru}" STRING,
     "${NoteFields.nameru}" STRING,
      "${NoteFields.img}" STRING,
       "${NoteFields.stok}" $idtype
    
    
     )
    """);
  }

  Future<Note> insert(Note note) async {
    Database db = await instance.database;
    final id = await db.insert(tableName, note.toJson());
    return note.copy(id: id);
  }

  Future<Note?> queryAll(int id) async {
    final db = await instance.database;
    final map = await db.query(tableName,
        columns: NoteFields.values,
        where: '${NoteFields.columnId}=?',
        whereArgs: [id]);
    if (map.isNotEmpty) {
      return Note.fromJson(map.first);
    }
  }

  Future<int> getLenght() async {
    Database db = await this.database;
    var result =
        await db.query(tableName, orderBy: '${NoteFields.columnId} ASC');
    int count = result.length;
    return count;
  }

  Future<int?> getCount(int id) async {
    //database connection
    Database db = await this.database;
    var x = await db.rawQuery(
        'SELECT COUNT(*) FROM $tableName where ${NoteFields.columnId}==$id');
    int? count = Sqflite.firstIntValue(x);
    debugPrint(count.toString());
    return count;
  }

  Future<List<Map<String, dynamic>>> getCountList(int id) async {
    //database connection
    Database db = await this.database;
    var x = await db
        .rawQuery('SELECT * FROM $tableName where ${NoteFields.columnId}==$id');

    return x;
  }

  Future<List<Map<String, dynamic>>> tumProduct() async {
    var db = await instance.database;
    var sonuc = db.query(tableName, orderBy: '${NoteFields.columnId} ASC');
    return sonuc;
  }

  Future<int> update(Note note) async {
    Database db = await instance.database;

    return await db.update(tableName, note.toJson(),
        where: "${NoteFields.columnId} =?", whereArgs: [note.index]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(tableName, where: "ID=?", whereArgs: [id]);
  }

  Future deleteAll() async {
    Database db = await instance.database;
    return await db.delete(
      tableName,
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
