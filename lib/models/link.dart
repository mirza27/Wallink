// PENAMAAN QUERY INISIASI SQLITE
const String tableLinks = "links_tables";

class LinkFields {
  static final List<String> values = [];

  static const String columnLinkId = "id";
  static const String columnLinkName = "link_name";
  static const String columnLink = "link";
  static const String columnSubCategoryId = "sub_category_id";
  static const String columnCreatedAt = "created_at";
  static const String columnUpdatedAt = "updated_at";
}

// READ OBJECT FROM DB DYNAMIC
class Link {
  int? id;
  String? link;
  String? nameLink;
  int? subCategoryId;
  DateTime? createdAt; // created mbe updated sek gaiso embo lapo aneh
  DateTime? updatedAt;

  Link({this.id, this.nameLink, this.link, this.subCategoryId, this.createdAt, this.updatedAt});

  Map<String, dynamic> toMap() {
    return {
      LinkFields.columnLinkId: id,
      LinkFields.columnLinkName: nameLink,
      LinkFields.columnLink: link,
      LinkFields.columnSubCategoryId: subCategoryId, 
      LinkFields.columnCreatedAt : createdAt, 
      LinkFields.columnUpdatedAt : updatedAt,
    };
  }

  factory Link.fromMap(Map<String, dynamic> map) {
    return Link(
        id: map[LinkFields.columnLinkId],
        nameLink: map[LinkFields.columnLinkName],
        link: map[LinkFields.columnLink],
        subCategoryId: map[LinkFields.columnSubCategoryId], 
        createdAt : DateTime.parse(map[LinkFields.columnCreatedAt] as String),
        updatedAt: DateTime.parse(map[LinkFields.columnUpdatedAt] as String),);
  }
}
