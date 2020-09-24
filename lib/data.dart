//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart';

class Task {
  // int id;
  String palabra;
  String significado;
  String desc;

  Task(this.palabra, this.significado, this.desc); //, this.id);

  // ignore: non_constant_identifier_names
  Map<String, dynamic> ToMap() {
    return {
      "palabra": palabra,
      "significado": significado,
      "desc": desc,
    };
  }

  Task.fromMap(Map<String, dynamic> map) {
    //int id = map["id"];
    palabra = map["palabra"];
    significado = map["significado"];
    desc = map["desc"];
  }
}

const oneSecond = Duration(seconds: 1);

class TaskDatabase {
  Database _bd;

  Future<List<Task>> initDB() async {
// open the database
    _bd = await openDatabase(
        /*join(await getDatabasesPath(), */ "my_db.db" /*)*/,
        version: 1, onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute('''
          CREATE TABLE Palabras(
            id INTEGER PRIMARY KEY,
            palabra TEXT, 
            significado TEXT,
            desc TEXT
            )
          ''');
    });
    print("BD iniciada");
  }

  incert(Task task) async {
    if (task.ToMap() == null) {
      print('se ingresan valores nulos');
    } else {
      print("no se ingresan valores nulos");
      _bd.insert("Palabras", task.ToMap());
    }
  }

  delete(var task) async {
    print("se intenta eliminar task");
    print(task);
    return _bd.rawDelete('DELETE FROM Palabras WHERE palabra = ?', [task]);
  }

  // ignore: missing_return
  Future<List<Task>> obtener() async {
    List<Map<String, dynamic>> resuls =
        await _bd.rawQuery('SELECT * FROM Palabras');
    print(resuls);
    if (resuls == null) {
      print("el valor obtenido es nulo");
      print(resuls);
    } else {
      return resuls.map((map) => Task.fromMap(map)).toList();
    }
  }
}
