// import 'package:note_app/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:agile_note/models/super_kategori.dart';
import 'package:agile_note/models/sub_kategori.dart';
import 'package:agile_note/models/link.dart';

class NoteDatabase {
  static final NoteDatabase instance = NoteDatabase._init();
  NoteDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('notes.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
        CREATE TABLE $tabelSuperKategori (
          ${SuperKategoriFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${SuperKategoriFields.namaKategori} TEXT NOT NULL,
          ${SuperKategoriFields.time} TEXT NOT NULL
        )
        ''');

    await db.execute('''
        CREATE TABLE $tabelSubKategori (
          ${SubKategoriFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${SubKategoriFields.namaSubKategori} TEXT NOT NULL,
          ${SubKategoriFields.time} TEXT NOT NULL,
          ${SubKategoriFields.superKategoriId} INTEGER,
          FOREIGN KEY (${SubKategoriFields.superKategoriId}) REFERENCES $tabelSuperKategori(${SuperKategoriFields.id}) ON DELETE CASCADE,
          INDEX (${SubKategoriFields.superKategoriId})
        )
        ''');

    await db.execute('''
    CREATE TABLE $tabelLink (
      ${LinkFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${LinkFields.namaLink} TEXT NOT NULL,
      ${LinkFields.link} TEXT NOT NULL,
      ${LinkFields.time} TEXT NOT NULL,
      ${LinkFields.subKategoriId} INTEGER,
      FOREIGN KEY (${LinkFields.subKategoriId}) REFERENCES ${tabelSubKategori}(${SubKategoriFields.id}) ON DELETE CASCADE
    )
  ''');
  }

  // // CRUD
  // Future<Note> create(Note note) async {
  //   final db = await instance.database;
  //   final id = await db.insert(tableNotes, note.toJson());
  //   return note.copy(id: id);
  // }

  // Future<List<Note>> getAllNotes() async {
  //   final db = await instance.database;
  //   final result = await db.query(tableNotes);
  //   return result.map((json) => Note.fromJson(json)).toList();
  // }

  // Future<Note> getNoteById(int id) async {
  //   final db = await instance.database;
  //   final result = await db
  //       .query(tableNotes, where: '${NoteFields.id} = ?', whereArgs: [id]);
  //   if (result.isNotEmpty) {
  //     return Note.fromJson(result.first);
  //   } else {
  //     throw Exception('ID $id not found');
  //   }
  // }

  // Future<int> deleteNoteById(int id) async {
  //   final db = await instance.database;
  //   return await db.delete(
  //     tableNotes,
  //     where: '${NoteFields.id} = ?',
  //     whereArgs: [id],
  //   );
  // }

  // Future<int> updateNote(Note note) async {
  //   final db = await instance.database;
  //   return await db.update(
  //     tableNotes,
  //     note.toJson(),
  //     where: '${NoteFields.id} = ?',
  //     whereArgs: [note.id],
  //   );
  // }
}
