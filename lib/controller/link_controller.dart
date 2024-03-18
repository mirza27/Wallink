import 'package:agile_note/database/database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:agile_note/models/super_kategori.dart';
import 'package:agile_note/models/sub_kategori.dart';
import 'package:agile_note/models/link.dart';

// CRUD Link

Future<Link> createLink(Link link) async {
  final Database db = await NoteDatabase.instance.database;
  final id = await db.insert(tabelLink, link.toJson());
  return link.copy(id: id);
}

Future<List<Link>> getAllLink() async {
  final Database db = await NoteDatabase.instance.database;
  final List<Map<String, dynamic>> results = await db.query(tabelLink);
  return results.map((json) => Link.fromJson(json)).toList();
}