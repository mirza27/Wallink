import 'package:wallink_v1/database/link_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/models/link.dart';

// CRUD Category
Future<Category> createCategory(Category category) async {
  final Database db = await LinkDatabase.instance.database;
  final id = await db.insert(tableCategories, category.toJson());
  return category.copy(id: id);
}

Future<List<Category>> getAllCategory() async {
  final Database db = await LinkDatabase.instance.database;
  final List<Map<String, dynamic>> results = await db.query(tableCategories);
  return results.map((json) => Category.fromJson(json)).toList();
}
