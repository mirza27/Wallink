import 'package:agile_note/database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:agile_note/models/super_kategori.dart';
import 'package:agile_note/models/sub_kategori.dart';
import 'package:agile_note/models/link.dart';

// CRUD SuperKategori
Future<SuperKategori> createSuperKategori(SuperKategori superKategori) async {
  final Database db = await NoteDatabase.instance.database;
  final id = await db.insert(tabelSuperKategori, superKategori.toJson());
  return superKategori.copy(id: id);
}

Future<List<SuperKategori>> getAllSuperKategori() async {
  final Database db = await NoteDatabase.instance.database;
  final List<Map<String, dynamic>> results = await db.query(tabelSuperKategori);
  return results.map((json) => SuperKategori.fromJson(json)).toList();
}
 

