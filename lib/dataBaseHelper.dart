import 'package:notesapp/noteModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static Future<Database>get database async{
    if (_database!=null){
      return _database!;
    }
    _database=await _initDatabase();
    return _database!;
  }
  static Future<Database> _initDatabase()async {
    final path = join(await getDatabasesPath(), "notes.db");
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE notes(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description TEXT
      )
          '''
      );
    });
  }
  static Future<int>insertNote(NoteModel note)async{
    final db=await database;
    return await db.insert("notes", note.toMap());
  }
  static Future<List<NoteModel>>getNote()async{
    final db=await database;
    final result=await db.query("notes");
    return result.map((map)=>NoteModel.fromMap(map)).toList();
  }
  static Future<int>updateToNote(NoteModel note)async{
    final db=await database;
    return await db.update("notes", note.toMap(),
      where:'id=?',
      whereArgs: [note.id],
    );
  }
  static Future<int>deleteNote(int id)async{
    final db=await database;
    return await db.delete("notes",
        where: "id=?",
        whereArgs: [id]
    );
  }
}
