import 'package:wallink_v1/database/link_database.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wallink_v1/models/link.dart';

// CRUD Link
Future<int> insertLink(String link, String nameLink, int subCategoryId) async {
  Database db = await LinkDatabase.instance.database;
  return await db.insert(tableLinks, {
    LinkFields.columnLink: link,
    LinkFields.columnLinkName: nameLink,
    LinkFields.columnSubCategoryId: subCategoryId
  });
}

Future<List<Map<String, dynamic>>> getAllLink() async {
  Database db = await LinkDatabase.instance.database;
  return await db.query(tableLinks);
}

Future<List<Map<String, dynamic>>> getLink(int? subCategoryId) async {
  Database db = await LinkDatabase.instance.database;
  return await db.query(tableLinks,
      where: '${LinkFields.columnSubCategoryId} = ?',
      whereArgs: [subCategoryId]);
}

Future<List<Map<String, dynamic>>> getFavLink() async {
  Database db = await LinkDatabase.instance.database;
  return await db.query(tableLinks,
      where: '${LinkFields.columnIsFavorite} = ? ', whereArgs: [1]);
}

Future<void> editLink(int id, String newName, String newLink) async {
  Database db = await LinkDatabase.instance.database;
  await db.update(
    tableLinks,
    {
      LinkFields.columnLinkName: newName,
      LinkFields.columnLink: newLink,
    },
    where: '${LinkFields.columnLinkId} = ?',
    whereArgs: [id],
  );
}

Future<void> markAsFavorite(int id, ) async {
  Database db = await LinkDatabase.instance.database;
  await db.update(tableLinks, {LinkFields.columnIsFavorite: 1}, 
  where: '${LinkFields.columnLinkId} = ? ', 
  whereArgs: [id]);
}

Future<void> markAsUnFavorite(int id, ) async {
  Database db = await LinkDatabase.instance.database;
  await db.update(tableLinks, {LinkFields.columnIsFavorite: 0}, 
  where: '${LinkFields.columnLinkId} = ? ', 
  whereArgs: [id]);
}


Future<void> deleteLink(int id) async {
  Database db = await LinkDatabase.instance.database;
  await db.delete(tableLinks,
      where: '${LinkFields.columnLinkId} = ?', whereArgs: [id]);
}

// Future<Link> createLink(Link link) async {
//   final Database db = await LinkDatabase.instance.database;
//   final id = await db.insert(tableLinks, link.toJson());
//   return link.copy(id: id);
// }

// Future<List<Link>> getAllLink() async {
//   final Database db = await LinkDatabase.instance.database;
//   final List<Map<String, dynamic>> results = await db.query(tableLinks);
//   return results.map((json) => Link.fromJson(json)).toList();
// }
