// PENAMAAN QUERY INISIASI SQLITE
const String tableSubCategories = "sub_categories_tables";

class SubCategoryFields {
  static final List<String> value = [];

  static const String columnSubCategoryId = "id";
  static const String columnSubCategoryName = "sub_category_name";
  static const String columnCategoryId = "category_id"; // Foreign key
  static const String columnIsArchive = "is_archive";
}

// READ OBJECT FROM DB DYNAMIC
class SubCategory {
  int? id;
  String? subCategoryName;
  int? categoryId;
  bool? is_archive = false;

  SubCategory({this.id, this.subCategoryName, this.categoryId, this.is_archive = false});

  Map<String, dynamic> toMap() {
    return {
      SubCategoryFields.columnSubCategoryId: id,
      SubCategoryFields.columnSubCategoryName: subCategoryName,
      SubCategoryFields.columnCategoryId: categoryId,
      SubCategoryFields.columnIsArchive: is_archive,
    };
  }

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(
      id: map[SubCategoryFields.columnSubCategoryId],
      subCategoryName: map[SubCategoryFields.columnSubCategoryName],
      categoryId: map[SubCategoryFields.columnCategoryId],
      is_archive: map[SubCategoryFields.columnIsArchive] == 1
    );
  }
}
