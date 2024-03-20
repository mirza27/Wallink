const String tableCategories = "categories";

class CategoryFields {
  static final List<String> value = [];

  static const String id = "_id";
  static const String categoryName = "_categoryName";
}

class Category {
  final int? id;
  final String categoryName;

  Category({
    this.id,
    required this.categoryName,
  });

  Category copy({int? id, String? categoryName}) {
    return Category(
      id: id ?? this.id,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  static Category fromJson(Map<String, Object?> json) {
    return Category(
      id: json[CategoryFields.id] as int?,
      categoryName: json[CategoryFields.categoryName] as String,
    );
  }

  Map<String, Object?> toJson() => {
        CategoryFields.id: id,
        CategoryFields.categoryName: categoryName,
      };
}
