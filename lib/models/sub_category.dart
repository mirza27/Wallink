const String tableSubCategories = "subCategories";

class SubCategoryFields {
  static final List<String> value = [];

  static const String id = "_id";
  static const String subCategoryName = "subCategoryName";
  static const String categoryId = "_categoryId"; // Foreign key
}

class SubCategory {
  final int? id;
  final String subCategoryName;
  final int? categoryId; // Foreign key

  SubCategory({
    this.id,
    required this.subCategoryName,
    required this.categoryId, // Foreign key
  });

  SubCategory copy({int? id, String? subCategoryName, int? categoryId}) {
    return SubCategory(
      id: id ?? this.id,
      subCategoryName: subCategoryName ?? this.subCategoryName, 
      categoryId: categoryId ?? this.categoryId,
    );
  }

  static SubCategory fromJson(Map<String, Object?> json) {
    return SubCategory(
      id: json[SubCategoryFields.id] as int?,
      subCategoryName: json[SubCategoryFields.subCategoryName] as String,
      categoryId: json[SubCategoryFields.categoryId] as int?
    );
  }

  Map<String, Object?> toJson() => {
        SubCategoryFields.id: id,
        SubCategoryFields.subCategoryName: subCategoryName,
      };
}
