import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBProvider {
  static Database _database;

  Future<Database> get database async {
    if (_database != null)
      return _database;

    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "CadastroAJ.db");
    return await openDatabase(path, version: 1, onOpen: (db) {}, onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Cadastro ("
          "id INTEGER PRIMARY KEY,"
          "matricula TEXT,"
          "nome TEXT,"
          "telefone TEXT,"
          "data_nascimento TEXT,"
          "lider TEXT,"
          "foto_path TEXT"
          ")"
      );
    });
  }

  DBProvider._();
  static final DBProvider db = DBProvider._();
}