import 'package:wallink_v1/database/link_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/models/link.dart';

// CRUD Link
Future<Link> createLink(Link link) async {
  final Database db = await LinkDatabase.instance.database;
  final id = await db.insert(tableLinks, link.toJson());
  return link.copy(id: id);
}

Future<List<Link>> getAllLink() async {
  final Database db = await LinkDatabase.instance.database;
  final List<Map<String, dynamic>> results = await db.query(tableLinks);
  return results.map((json) => Link.fromJson(json)).toList();
}