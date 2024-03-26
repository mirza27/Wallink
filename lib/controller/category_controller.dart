import 'package:wallink_v1/database/link_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/models/link.dart';

// CRUD Category
Future<int> insertCategory(String nameCategory) async {
  Database db = await LinkDatabase.instance.database;
  return await db.insert(
      tableCategories, {CategoryFields.columnCategoryName: nameCategory});
}

Future<List<Map<String, dynamic>>> getCategories() async {
  Database db = await LinkDatabase.instance.database;
  return await db.query(tableCategories);
}

Future<void> editCategory(int id, String newName) async {
  Database db = await LinkDatabase.instance.database;
  await db.update(
    tableCategories,
    {CategoryFields.columnCategoryName: newName},
    where: '${CategoryFields.columnCategoryId} = ?',
    whereArgs: [id],
  );
}

// DELETE DATA
Future<void> deleteCategory(int id) async {
  Database db = await LinkDatabase.instance.database;

  // hapus link dengan subcategory yang didalam category
  await db.delete(
    tableLinks,
    where:
        '${LinkFields.columnSubCategoryId} IN (SELECT ${SubCategoryFields.columnCategoryId} FROM $tableSubCategories WHERE ${SubCategoryFields.columnCategoryId} = ?)',
    whereArgs: [id],
  );

  await db.delete(
    tableSubCategories,
    where: '${SubCategoryFields.columnCategoryId} = ?',
    whereArgs: [id],
  );
  await db.delete(
    tableCategories,
    where: '${CategoryFields.columnCategoryId} = ?',
    whereArgs: [id],
  );
}


// Future<Category> createCategory(Category category) async {
//   final Database db = await LinkDatabase.instance.database;
//   final id = await db.insert(tableCategories, category.toJson());
//   return category.copy(id: id);
// }

// Future<List<Category>> getAllCategory() async {
//   final Database db = await LinkDatabase.instance.database;
//   final List<Map<String, dynamic>> results = await db.query(tableCategories);
//   return results.map((json) => Category.fromJson(json)).toList();
// }
