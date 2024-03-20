import 'package:wallink_v1/database/link_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/models/link.dart';

 // CRUD SubCategory
Future<SubCategory> createSubCategory(SubCategory subCategory) async {
  final Database db = await LinkDatabase.instance.database;
  final id = await db.insert(tableSubCategories, subCategory.toJson());
  return subCategory.copy(id: id);
}

Future<List<SubCategory>> getAllSubCategory() async {
  final Database db = await LinkDatabase.instance.database;
  final List<Map<String, dynamic>> results = await db.query(tableSubCategories);
  return results.map((json) => SubCategory.fromJson(json)).toList();
}