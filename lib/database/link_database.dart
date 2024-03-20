import 'package:sqflite/sqflite.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:path/path.dart';
import 'package:wallink_v1/data_links.dart';

class LinkDatabase {
  static final LinkDatabase instance = LinkDatabase._init();
  LinkDatabase._init();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('wallink.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    // MEMBUAT TABEL SAAT INISIASI AWAL
    await db.execute('''
        CREATE TABLE $tableCategories (
          ${CategoryFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${CategoryFields.categoryName} TEXT NOT NULL
        )
        ''');

    await db.execute('''
        CREATE TABLE $tableSubCategories (
          ${SubCategoryFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${SubCategoryFields.subCategoryName} TEXT NOT NULL,
          ${SubCategoryFields.categoryId} INTEGER,
          FOREIGN KEY (${SubCategoryFields.categoryId}) REFERENCES $tableCategories(${CategoryFields.id}) ON DELETE CASCADE
        )
        ''');

    await db.execute('''
      CREATE TABLE $tableLinks (
        ${LinkFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${LinkFields.linkName} TEXT NOT NULL,
        ${LinkFields.link} TEXT NOT NULL,
        ${LinkFields.time} TEXT NOT NULL,
        ${LinkFields.subCategoryId} INTEGER,
        FOREIGN KEY (${LinkFields.subCategoryId}) REFERENCES $tableSubCategories(${SubCategoryFields.id}) ON DELETE CASCADE
        )
      ''');

    // INSERT DATA SAAT INISIASI AWAL (hanya saat awal tes)
    // await _insertInitialData(db); 
  }

  Future<void> _insertInitialData(Database db) async {
    // Masukkan data kategori dan subkategori ambil dari file links.dart
    for (var category in listData) {
      int categoryId = await db.insert(tableCategories,
          {CategoryFields.categoryName: category.categoryName});
      for (var subCategory in category.subCategories) {
        int subCategoryId = await db.insert(tableSubCategories, {
          SubCategoryFields.subCategoryName: subCategory.subCategoryName,
          SubCategoryFields.categoryId: categoryId
        });
        for (var link in subCategory.links) {
          await db.insert(tableLinks, {
            LinkFields.linkName: link.name,
            LinkFields.link: link.link,
            LinkFields.time: link.createdAt.toIso8601String(),
            LinkFields.subCategoryId: subCategoryId
          });
        }
      }
    }
  }


  // CRUD HELPER
  

}
