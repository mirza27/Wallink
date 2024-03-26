// PENAMAAN QUERY INISIASI SQLITE
const String tableSubCategories = "sub_categories_tables";

class SubCategoryFields {
  static final List<String> value = [];

  static const String columnSubCategoryId = "id";
  static const String columnSubCategoryName = "sub_category_name";
  static const String columnCategoryId = "category_id"; // Foreign key
}

// READ OBJECT FROM DB DYNAMIC
class SubCategory {
  int? id;
  String? subCategoryName;
  int? categoryId;

  SubCategory({this.id, this.subCategoryName, this.categoryId});

  Map<String, dynamic> toMap() {
    return {
      SubCategoryFields.columnSubCategoryId: id,
      SubCategoryFields.columnSubCategoryName: subCategoryName,
      SubCategoryFields.columnCategoryId: categoryId,
    };
  }

  factory SubCategory.fromMap(Map<String, dynamic> map) {
    return SubCategory(
      id: map[SubCategoryFields.columnSubCategoryId],
      subCategoryName: map[SubCategoryFields.columnSubCategoryName],
      categoryId: map[SubCategoryFields.columnCategoryId],
    );
  }
}
