// PENAMAAN QUERY INISIASI SQLITE
const String tableCategories = "categories_tables";
class CategoryFields {
  static final List<String> value = [];

  static const String columnCategoryId = "id";
  static const String columnCategoryName = "category_name";
}


// READ OBJECT FROM DB DYNAMIC
class Category {
  int? id;
  String? nameCategory;

  Category({this.id, this.nameCategory});

  Map<String, dynamic> toMap() {
    return {
      CategoryFields.columnCategoryId: id,
      CategoryFields.columnCategoryName: nameCategory,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map[CategoryFields.columnCategoryId],
      nameCategory: map[CategoryFields.columnCategoryName],
    );
  }
}
