import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

Note noteFromJson(String str) {
  final jsonData = json.decode(str);
  return Note.fromMap(jsonData);
}

String noteToJson(Note data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Note {
  int id;
  int indexOfObject;
  String descripton;
  String login;
  String password;
  String additionalInformation;

  Note({this.id, indexOfObject, descripton, login, password, additionalInformation});

  Map<String, dynamic> toMap() => {
      'id': id,
      'indexOfObject': indexOfObject,
      'descripton': descripton,
      'login': login,
      'password': password,
      'additionalInformation': additionalInformation,
  };
  
  factory Note.fromMap(Map<String, dynamic> json) => new Note(
        id: json["id"],
        indexOfObject: json["indexOfObject"],
        descripton: json["descripton"],
        login: json["login"],
        password: json["password"],
        additionalInformation: json["additionalInformation"],
      );
}



class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "NoteDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Notes ("
          "id INTEGER PRIMARY KEY,"
          "indexOfObject INTEGER,"
          "descripton TEXT,"
          "login TEXT,"
          "password TEXT,"
          "additionalInformation TEXT"
          ")");
    });
  }

  newNote(Note newNote) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Note");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Note (id,indexOfObject,descripton,login,password,additionalInformation)"
        " VALUES (?,?,?,?,?,?)",
        [id, newNote.indexOfObject, newNote.descripton, newNote.login, newNote.password, newNote.additionalInformation]);
    return raw;
  }

  updateNote(Note newNote) async {
    final db = await database;
    var res = await db.update("Note", newNote.toMap(),
        where: "id = ?", whereArgs: [newNote.id]);
    return res;
  }

  getNote(int id) async {
    final db = await database;
    var res = await db.query("Note", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Note.fromMap(res.first) : null;
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    var res = await db.query("Note");
    List<Note> list =
        res.isNotEmpty ? res.map((c) => Note.fromMap(c)).toList() : [];
    return list;
  }

  deleteNote(int id) async {
    final db = await database;
    return db.delete("Note", where: "id = ?", whereArgs: [id]);
  }
}