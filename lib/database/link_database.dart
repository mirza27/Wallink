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
    _database = await _initDB('dasdaadssad.db');
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
          ${CategoryFields.columnCategoryId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${CategoryFields.columnCategoryName} TEXT NOT NULL
        )
        ''');

    await db.execute('''
        CREATE TABLE $tableSubCategories (
          ${SubCategoryFields.columnSubCategoryId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${SubCategoryFields.columnSubCategoryName} TEXT NOT NULL,
          ${SubCategoryFields.columnCategoryId} INTEGER,
          FOREIGN KEY (${SubCategoryFields.columnCategoryId}) REFERENCES $tableCategories(${CategoryFields.columnCategoryId}) ON DELETE CASCADE
        )
        ''');

    await db.execute('''
      CREATE TABLE $tableLinks (
        ${LinkFields.columnLinkId} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${LinkFields.columnLinkName} TEXT NOT NULL,
        ${LinkFields.columnLink} TEXT NOT NULL,
        ${LinkFields.columnSubCategoryId} INTEGER,
        ${LinkFields.columnCreatedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        ${LinkFields.columnUpdatedAt} TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        
        FOREIGN KEY (${LinkFields.columnSubCategoryId}) REFERENCES $tableSubCategories(${SubCategoryFields.columnSubCategoryId}) ON DELETE CASCADE
        )
      ''');

    await db.execute('''
      CREATE TRIGGER IF NOT EXISTS update_link_trigger
      AFTER UPDATE ON $tableLinks
      FOR EACH ROW
      BEGIN
          UPDATE $tableLinks SET updated_at = CURRENT_TIMESTAMP WHERE ${LinkFields.columnCreatedAt} = OLD.${LinkFields.columnCreatedAt};
      END;
        ''');

    // INSERT DATA SAAT INISIASI AWAL (hanya saat awal tes)
    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    // Masukkan data kategori dan subkategori ambil dari file links.dart
    for (var category in listData) {
      int categoryId = await db.insert(tableCategories,
          {CategoryFields.columnCategoryName: category.categoryName});
      for (var subCategory in category.subCategories) {
        int subCategoryId = await db.insert(tableSubCategories, {
          SubCategoryFields.columnSubCategoryName: subCategory.subCategoryName,
          SubCategoryFields.columnCategoryId: categoryId
        });
        for (var link in subCategory.links) {
          await db.insert(tableLinks, {
            LinkFields.columnLinkName: link.name,
            LinkFields.columnLink: link.link,
            LinkFields.columnSubCategoryId: subCategoryId
          });
        }
      }
    }
  }

}
