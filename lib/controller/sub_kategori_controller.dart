import 'package:agile_note/database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:agile_note/models/super_kategori.dart';
import 'package:agile_note/models/sub_kategori.dart';
import 'package:agile_note/models/link.dart';

 // CRUD SubKategori
Future<SubKategori> createSubKategori(SubKategori subKategori) async {
  final Database db = await NoteDatabase.instance.database;
  final id = await db.insert(tabelSubKategori, subKategori.toJson());
  return subKategori.copy(id: id);
}

Future<List<SubKategori>> getAllSubKategori() async {
  final Database db = await NoteDatabase.instance.database;
  final List<Map<String, dynamic>> results = await db.query(tabelSubKategori);
  return results.map((json) => SubKategori.fromJson(json)).toList();
}