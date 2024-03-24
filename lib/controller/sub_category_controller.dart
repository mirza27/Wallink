import 'package:wallink_v1/database/link_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/models/link.dart';

// CRUD SubCategory
Future<int> insertSubCategory(String nameSubCategory, int categoryId) async {
  Database db = await LinkDatabase.instance.database;
  return await db.insert(tableSubCategories, {
    SubCategoryFields.columnSubCategoryName: nameSubCategory,
    SubCategoryFields.columnCategoryId: categoryId,
  });
}

Future<List<Map<String, dynamic>>> getSubCategoryByCategoryId(int? categoryId) async {
  Database db = await LinkDatabase.instance.database;
  return await db.query(tableSubCategories,
      where: '${SubCategoryFields.columnCategoryId} = ?',
      whereArgs: [categoryId]);
}

Future<void> editSubCategory(int id, String newName) async {
  Database db = await LinkDatabase.instance.database;
  await db.update(
    tableSubCategories,
    {SubCategoryFields.columnSubCategoryName: newName},
    where: '${SubCategoryFields.columnSubCategoryId} = ?',
    whereArgs: [id],
  );
}

Future<void> deleteSubCategory(int id) async {
  Database db = await LinkDatabase.instance.database;
  await db.delete(
    tableLinks,
    where: '${LinkFields.columnSubCategoryId} = ?',
    whereArgs: [id],
  );

  await db.delete(
    tableSubCategories,
    where: '${SubCategoryFields.columnSubCategoryId} = ?',
    whereArgs: [id],
  );
}

// Future<SubCategory> createSubCategory(SubCategory subCategory) async {
//   final Database db = await LinkDatabase.instance.database;
//   final id = await db.insert(tableSubCategories, subCategory.toJson());
//   return subCategory.copy(id: id);
// }

// Future<List<SubCategory>> getAllSubCategory() async {
//   final Database db = await LinkDatabase.instance.database;
//   final List<Map<String, dynamic>> results = await db.query(tableSubCategories);
//   return results.map((json) => SubCategory.fromJson(json)).toList();
// }


// // mengemabil sub category berdasrkan 
// Future<String> getSubCategoryInfo(int linkId) async {
//   final Database db = await LinkDatabase.instance.database;
//   final List<Map<String, dynamic>> results = await db.rawQuery('''
//     SELECT ${SubCategoryFields.id}, ${SubCategoryFields.subCategoryName}
//     FROM $tableSubCategories
//     WHERE ${SubCategoryFields.id} = (
//       SELECT ${LinkFields.subCategoryId}
//       FROM $tableLinks
//       WHERE ${LinkFields.id} = $linkId
//     )
//   ''');

//   if (results.isNotEmpty) {
//     return '${results.first[SubCategoryFields.id]} - ${results.first[SubCategoryFields.subCategoryName]}';
//   } else {
//     return 'Subcategory not found';
//   }
// }