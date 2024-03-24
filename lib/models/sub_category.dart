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
      id: map[SubCategoryFields.columnCategoryId],
      subCategoryName: map[SubCategoryFields.columnSubCategoryName],
      categoryId: map[SubCategoryFields.columnCategoryId],
    );
  }
}


// STATIC VERSION
// class SubCategory {
//   final int? id;
//   final String subCategoryName;
//   final int? categoryId; // Foreign key

//   SubCategory({
//     this.id,
//     required this.subCategoryName,
//     required this.categoryId, // Foreign key
//   });

//   SubCategory copy({int? id, String? subCategoryName, int? categoryId}) {
//     return SubCategory(
//       id: id ?? this.id,
//       subCategoryName: subCategoryName ?? this.subCategoryName, 
//       categoryId: categoryId ?? this.categoryId,
//     );
//   }

//   static SubCategory fromJson(Map<String, Object?> json) {
//     return SubCategory(
//       id: json[SubCategoryFields.id] as int?,
//       subCategoryName: json[SubCategoryFields.subCategoryName] as String,
//       categoryId: json[SubCategoryFields.categoryId] as int?
//     );
//   }

//   Map<String, Object?> toJson() => {
//         SubCategoryFields.id: id,
//         SubCategoryFields.subCategoryName: subCategoryName,
//       };
// }
