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


// STATIC VERSION
// class Category {
//   final int? id;
//   final String categoryName;

//   Category({
//     this.id,
//     required this.categoryName,
//   });

//   Category copy({int? id, String? categoryName}) {
//     return Category(
//       id: id ?? this.id,
//       categoryName: categoryName ?? this.categoryName,
//     );
//   }

//   static Category fromJson(Map<String, Object?> json) {
//     return Category(
//       id: json[CategoryFields.id] as int?,
//       categoryName: json[CategoryFields.categoryName] as String,
//     );
//   }

//   Map<String, Object?> toJson() => {
//         CategoryFields.id: id,
//         CategoryFields.categoryName: categoryName,
//       };
// }
