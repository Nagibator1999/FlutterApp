import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void dataBase() async {
  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'note_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      return db.execute(
        "CREATE TABLE notes(with their all fields)",
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  Future<void> insertNote(Note note) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'notes',
      note.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Note>> notes() async {
    // Get a reference to the database.
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('notes');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Note(
        indexOfObject: maps[i]['indexOfObject'],
        descripton: maps[i]['descripton'],
        login: maps[i]['login'],
        password: maps[i]['password'],
        additionalInformation: maps[i]['additionalInformation'],
      );
    });
  }

  Future<void> updateNote(Note note) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'note',
      note.toMap(),
      // Ensure that the Dog has a matching id.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [note.indexOfObject],
    );
  }

  Future<void> deleteNote(int indexOfObject) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the Dog from the database.
    await db.delete(
      'note',
      // Use a `where` clause to delete a specific dog.
      where: "id = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [indexOfObject],
    );
  }

  // var fido = Dog(
  //   id: 0,
  //   name: 'Fido',
  //   age: 35,
  // );

  // // Insert a dog into the database.
  // await insertDog(fido);

  // // Print the list of dogs (only Fido for now).
  // print(await dogs());

  // // Update Fido's age and save it to the database.
  // fido = Dog(
  //   id: fido.id,
  //   name: fido.name,
  //   age: fido.age + 7,
  // );
  // await updateDog(fido);

  // // Print Fido's updated information.
  // print(await dogs());

  // // Delete Fido from the database.
  // await deleteDog(fido.id);

  // // Print the list of dogs (empty).
  // print(await dogs());
}

class Note {
  int indexOfObject;
  String descripton;
  String login;
  String password;
  String additionalInformation;

  Note({this.indexOfObject, this.descripton, this.login, this.password, this.additionalInformation});

  Map<String, dynamic> toMap() {
    return {
      'id': indexOfObject,
      'descripton': descripton,
      'login': login,
      'password': password,
      'additionalInformation': additionalInformation,
    };
  }
}